// ============================================================================
// Data Section: Read-only strings
// ============================================================================
.section .rodata
    // Strings for printf and scanf
    prompt_msg:     .string "Please input a positive integer: "
    in_fmt:         .string "%d%c"
    err_msg:        .string "Invalid input. Please enter a positive integer.\n"
    prime_msg:      .string "%d is a prime number.\n"
    not_prime_msg:  .string "%d is not a prime number.\n"

// ============================================================================
// Text Section: Code
// ============================================================================
.section .text
.global main
.global prime_check

// ============================================================================
// Function: main
// ============================================================================
main:
    // Prologue: Save Frame Pointer (x29) and Link Register (x30)
    // Allocate 32 bytes on stack:
    // [sp, 16] -> int x (4 bytes)
    // [sp, 20] -> char term (1 byte + padding)
    stp     x29, x30, [sp, -32]!
    mov     x29, sp

input_loop:
    // 1. printf("Please input a positive integer: ");
    adrp    x0, prompt_msg
    add     x0, x0, :lo12:prompt_msg
    bl      printf

    // 2. scanf("%d%c", &x, &term);
    // We must zero out 'term' on the stack first to ensure clean logic check later
    // (Although not strictly in C code, it prevents garbage values if scanf fails completely)
    strb    wzr, [sp, 20]

    adrp    x0, in_fmt              // arg0: format string
    add     x0, x0, :lo12:in_fmt
    add     x1, sp, 16              // arg1: address of x
    add     x2, sp, 20              // arg2: address of term
    bl      scanf

    // 3. Validation Logic
    // Check 1: scanf return value (in w0) != 2
    cmp     w0, 2
    b.ne    handle_error

    // Check 2: x <= 0
    ldr     w1, [sp, 16]            // Load x
    cmp     w1, 0
    b.le    handle_error

    // Check 3: term != '\n' (newline is ASCII 10)
    ldrb    w2, [sp, 20]            // Load term (byte)
    cmp     w2, 10
    b.ne    handle_error

    // If we got here, input is valid. Break loop.
    b       perform_computation

handle_error:
    // printf("Invalid input...\n");
    adrp    x0, err_msg
    add     x0, x0, :lo12:err_msg
    bl      printf

    // Check: if (term != '\n')
    ldrb    w2, [sp, 20]
    cmp     w2, 10
    b.eq    input_loop              // If term was \n, just loop back

    // Buffer clear loop: while (getchar() != '\n');
clear_buffer:
    bl      getchar
    cmp     w0, 10                  // Compare result with '\n'
    b.ne    clear_buffer            // If not newline, keep eating chars

    b       input_loop              // Go back to start of do-while

perform_computation:
    // prime_check(x);
    ldr     w0, [sp, 16]            // Load x into w0 (argument 1)
    bl      prime_check

    // return 0;
    mov     w0, 0
    
    // Epilogue: Restore FP/LR and stack
    ldp     x29, x30, [sp], 32
    ret

// ============================================================================
// Function: prime_check(int x)
// Input: w0 = x
// ============================================================================
prime_check:
    // Prologue
    // We need to save x19 (callee-saved) to store 'x' persistently across printf calls
    // We also need x20 for loop counter 'i'
    stp     x29, x30, [sp, -32]!
    mov     x29, sp
    stp     x19, x20, [sp, 16]      // Save callee-saved registers

    mov     w19, w0                 // Move x to w19 (safe register)

    // 1. if (x <= 1)
    cmp     w19, 1
    b.le    is_not_prime_jump

    // 2. else if (x == 2)
    cmp     w19, 2
    b.eq    is_prime_jump

    // 3. else if (x % 2 == 0) -> Check if bit 0 is 0
    tbz     w19, 0, is_not_prime_jump  // Test Bit Zero: if 0 (even), jump

    // 4. Loop: for (int i = 3; (long long)i * i <= x; i += 2)
    mov     w20, 3                  // i = 3

div_loop:
    // Calculate i * i using 64-bit logic (long long)
    // We use 'x20' (64-bit version of w20)
    mul     x2, x20, x20            // x2 = i * i
    
    // Compare i*i <= x
    // Note: x is in w19 (32-bit), treat as unsigned 64-bit for comparison
    uxtw    x3, w19                 // Zero-extend x into x3
    cmp     x2, x3
    b.gt    is_prime_jump           // If i*i > x, no divisors found -> Prime

    // Check: if (x % i == 0)
    // Calculate remainder: x - (x/i)*i
    udiv    w4, w19, w20            // w4 = x / i
    msub    w5, w4, w20, w19        // w5 = x - (w4 * i) -> Remainder
    
    cbz     w5, is_not_prime_jump   // If remainder is 0, it's not prime

    // i += 2
    add     w20, w20, 2
    b       div_loop

is_prime_jump:
    // printf("%d is a prime number.\n", x);
    adrp    x0, prime_msg
    add     x0, x0, :lo12:prime_msg
    mov     w1, w19                 // Move x into arg1
    bl      printf
    b       prime_check_end

is_not_prime_jump:
    // printf("%d is not a prime number.\n", x);
    adrp    x0, not_prime_msg
    add     x0, x0, :lo12:not_prime_msg
    mov     w1, w19                 // Move x into arg1
    bl      printf

prime_check_end:
    // Epilogue
    ldp     x19, x20, [sp, 16]      // Restore callee-saved registers
    ldp     x29, x30, [sp], 32      // Restore FP/LR and stack
    ret