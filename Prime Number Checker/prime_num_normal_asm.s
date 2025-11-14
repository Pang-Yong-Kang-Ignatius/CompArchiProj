.global prime_check
.text

prime_check:
    // Function entry:
    // x is in W0 (32-bit integer argument)
    // Save FP and LR to the stack, then set FP
    STP     X29, X30, [SP, #-16]!   // Push FP and LR onto the stack, adjust SP
    MOV     X29, SP                 // Set FP to current SP

    // Local variables (we can use registers for most, or stack for spills)
    // Let's keep 'x' in W0 for now as it's the input.
    // 'is_prime' can be held in W1.
    // Loop counter 'i' can be held in W2.
    // Temp registers W3, W4, W5 for calculations.

    // C code: if (x <= 1) { ... }
    CMP     W0, #1
    B.GT    .L_check_greater_than_1  // If x > 1, go to next check

    // x <= 1 block:
    LDR     X1, =.L_not_prime_msg   // Load address of "not prime" string into X1
    MOV     W0, W0                  // Move 'x' to W0 for printf (already there, but good practice)
    BL      printf                  // Call printf
    B       .L_prime_check_exit     // Jump to exit

.L_check_greater_than_1:
    // C code: else if (x == 2) { ... }
    CMP     W0, #2
    B.NE    .L_check_not_equal_2     // If x != 2, go to next check

    // x == 2 block:
    LDR     X1, =.L_prime_msg       // Load address of "prime" string into X1
    MOV     W0, W0                  // 'x' to W0 for printf
    BL      printf                  // Call printf
    B       .L_prime_check_exit     // Jump to exit

.L_check_not_equal_2:
    // C code: else if (x % 2 == 0) { ... }
    // x % 2 == 0 is equivalent to (x AND 1) == 0
    AND     W3, W0, #1              // W3 = x & 1
    CMP     W3, #0
    B.NE    .L_start_odd_divisor_loop // If (x & 1) != 0 (i.e., x is odd), start the loop

    // x % 2 == 0 block (x is even and > 2):
    LDR     X1, =.L_not_prime_msg   // Load address of "not prime" string into X1
    MOV     W0, W0                  // 'x' to W0 for printf
    BL      printf                  // Call printf
    B       .L_prime_check_exit     // Jump to exit

.L_start_odd_divisor_loop:
    // C code: int is_prime = 1; // Assume it's prime until a divisor is found
    MOV     W1, #1                  // W1 holds is_prime = 1

    // C code: for (int i = 3; (long long)i * i <= x; i += 2) {
    MOV     W2, #3                  // W2 holds i = 3

.L_loop_condition:
    // Calculate (long long)i * i
    MUL     X3, X2, X2              // X3 = i * i (using 64-bit multiply to prevent overflow)
                                    // Note: if x is truly a 32-bit int, then W0 is 32-bit.
                                    // For comparison, we need X0 to be 64-bit.
    SXTB    X0, W0                  // Sign-extend W0 (x) to X0 (64-bit) for comparison
    CMP     X3, X0                  // Compare i*i with x
    B.GT    .L_loop_end             // If i*i > x, loop terminates

    // C code: if (x % i == 0) { ... }
    // Calculate x % i (remainder of x / i)
    // AArch64 doesn't have a direct modulo instruction.
    // Remainder = x - (x / i) * i
    UDIV    W4, W0, W2              // W4 = x / i (unsigned division)
    MUL     W5, W4, W2              // W5 = (x / i) * i
    SUB     W3, W0, W5              // W3 = x - ((x/i) * i)  ==> W3 = x % i

    CMP     W3, #0                  // Compare remainder with 0
    B.NE    .L_continue_loop        // If remainder != 0, continue to next iteration

    // x % i == 0 block (found a divisor):
    // C code: is_prime = 0; break;
    MOV     W1, #0                  // is_prime = 0
    B       .L_loop_end             // Break out of loop

.L_continue_loop:
    // C code: i += 2
    ADD     W2, W2, #2              // i = i + 2
    B       .L_loop_condition       // Go back to check loop condition

.L_loop_end:
    // After the loop, check the 'is_prime' flag
    CMP     W1, #1                  // Compare is_prime with 1
    B.NE    .L_final_not_prime      // If is_prime != 1 (i.e., it's 0), it's not prime

    // is_prime is 1:
    LDR     X1, =.L_prime_msg       // Load address of "prime" string into X1
    MOV     W0, W0                  // 'x' to W0 for printf
    BL      printf                  // Call printf
    B       .L_prime_check_exit

.L_final_not_prime:
    // is_prime is 0:
    LDR     X1, =.L_not_prime_msg   // Load address of "not prime" string into X1
    MOV     W0, W0                  // 'x' to W0 for printf
    BL      printf                  // Call printf

.L_prime_check_exit:
    // Function exit:
    LDP     X29, X30, [SP], #16     // Restore FP and LR, adjust SP
    RET                             // Return from function

.data
.L_prime_msg:
    .asciz "%d is a prime number.\n"
.L_not_prime_msg:
    .asciz "%d is not a prime number.\n"