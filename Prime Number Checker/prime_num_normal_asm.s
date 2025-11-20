    .global main
    .global prime_check
    .extern printf
    .extern scanf

// ------------------------------------------------------------
// main function
// ------------------------------------------------------------
    .text
main:
    // Prologue
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    // Reserve space for integer x (4 bytes)
    SUB     SP, SP, #16            // make space on stack
    ADD     X1, SP, #0             // X1 = &x

    // Print prompt: "Enter a number: "
    LDR     X0, =input_prompt
    BL      printf

    // scanf("%d", &x)
    LDR     X0, =scanf_fmt
    MOV     X1, SP                 // address of x
    BL      scanf

    // Load x into W0 so prime_check(x) sees the argument
    LDR     W0, [SP]
    BL      prime_check

    // Epilogue
    ADD     SP, SP, #16
    LDP     X29, X30, [SP], #16
    RET


// ------------------------------------------------------------
// prime_check(int x)
// ------------------------------------------------------------
prime_check:
    // Prologue
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    // if (x <= 1) → not prime
    CMP     W0, #1
    B.GT    .L_check_greater_than_1

    // x <= 1: print "not prime"
    MOV     W1, W0
    LDR     X0, =notprime_fmt
    BL      printf
    B       .L_exit

.L_check_greater_than_1:
    // if (x == 2) → prime
    CMP     W0, #2
    B.NE    .L_check_even

    MOV     W1, W0
    LDR     X0, =prime_fmt
    BL      printf
    B       .L_exit

.L_check_even:
    // if (x % 2 == 0) → not prime
    AND     W3, W0, #1
    CMP     W3, #0
    B.NE    .L_start_loop

    MOV     W1, W0
    LDR     X0, =notprime_fmt
    BL      printf
    B       .L_exit

// Odd divisor loop
.L_start_loop:
    MOV     W1, #1              // is_prime = 1
    MOV     W2, #3              // i = 3

.L_loop_cond:
    MUL     W3, W2, W2          // W3 = i*i
    CMP     W3, W0
    B.GT    .L_loop_end         // i*i > x ? stop loop

    // Compute x % i
    UDIV    W4, W0, W2
    MUL     W5, W4, W2
    SUB     W3, W0, W5          // remainder

    CMP     W3, #0
    B.NE    .L_inc_i            // remainder ≠ 0 → continue

    // Found a divisor
    MOV     W1, #0
    B       .L_loop_end

.L_inc_i:
    ADD     W2, W2, #2
    B       .L_loop_cond

.L_loop_end:
    CMP     W1, #1
    B.NE    .L_not_prime

    MOV     W1, W0
    LDR     X0, =prime_fmt
    BL      printf
    B       .L_exit

.L_not_prime:
    MOV     W1, W0
    LDR     X0, =notprime_fmt
    BL      printf

.L_exit:
    // Epilogue
    LDP     X29, X30, [SP], #16
    RET


// ------------------------------------------------------------
// Data Section
// ------------------------------------------------------------
    .data
input_prompt:
    .asciz "Enter a number: "
scanf_fmt:
    .asciz "%d"
prime_fmt:
    .asciz "%d is a prime number.\n"
notprime_fmt:
    .asciz "%d is not a prime number.\n"