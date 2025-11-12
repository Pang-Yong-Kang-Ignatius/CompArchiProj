    .section .rodata                    // Define a read-only data section for string literals

prompt1:    .asciz "Enter 8 numbers:\n" // String for first message
prompt2:    .asciz "Enter number %d: "  // String for input prompt with number index
prompt3:    .asciz "Enter a number to check: " // String to ask for target number
fmt_d:      .asciz "%d"                 // Format string for integer input/output
msg_found:  .asciz "There are two numbers in the list summing to the keyed-in number %d\n" // Success message
msg_not:    .asciz "There are not two numbers in the list summing to the keyed-in number %d\n" // Failure message

    .section .bss                       // Define uninitialized data section
    .align 4                            // Align to 4-byte boundary for integers
list:       .space 32                   // Reserve 32 bytes (8 integers * 4 bytes each)
target:     .space 4                    // Reserve 4 bytes for target integer

    .text                               // Start of code section
    .global main                        // Make 'main' visible to linker
    .extern printf                      // Declare external function printf
    .extern scanf                       // Declare external function scanf

main:
    stp     x29, x30, [sp, -16]!        // Push frame pointer (x29) and link register (x30) onto stack
    mov     x29, sp                     // Set new frame pointer to current stack pointer
    stp     x19, x20, [sp, -16]!        // Push callee-saved registers x19 and x20
    stp     x21, x22, [sp, -16]!        // Push callee-saved registers x21 and x22

    ldr     x0, =prompt1                // Load address of prompt1 string into x0
    bl      printf                      // Call printf(prompt1) to display the message

    mov     x19, #0                     // Initialize loop counter i = 0
    ldr     x21, =list                  // Load address of list array into x21

// ---- Read 8 numbers (no validation) ----
read_loop:
    cmp     x19, #8                     // Compare i with 8
    b.ge    read_done                   // If i >= 8, exit loop

    ldr     x0, =prompt2                // Load address of "Enter number %d:" string
    add     x1, x19, #1                 // Compute i + 1 for display (1-based index)
    bl      printf                      // Call printf(prompt2, i+1)

    ldr     x0, =fmt_d                  // Load "%d" format string into x0
    add     x1, x21, x19, lsl #2        // Compute address of list[i] (4 bytes per int)
    bl      scanf                       // Call scanf("%d", &list[i])

    add     x19, x19, #1                // Increment i by 1
    b       read_loop                   // Jump back to read next number

// ---- Read target (no validation) ----
read_done:
    ldr     x0, =prompt3                // Load "Enter a number to check:" message
    bl      printf                      // Print it using printf()

    ldr     x0, =fmt_d                  // Load "%d" format string for integer input
    ldr     x1, =target                 // Load address of target variable
    bl      scanf                       // Call scanf("%d", &target)

// ---- Two-sum logic ----
    mov     x22, #0                     // found = 0 (initialize flag)
    mov     x19, #0                     // i = 0 (outer loop index)

outer_loop:
    cmp     x19, #8                     // Compare i with 8
    b.ge    check_found                 // If i >= 8, exit outer loop
    add     x20, x19, #1                // Set j = i + 1 (start of inner loop)

inner_loop:
    cmp     x20, #8                     // Compare j with 8
    b.ge    next_i                      // If j >= 8, go to next i

    ldr     w0, [x21, x19, lsl #2]      // Load list[i] into w0
    ldr     w1, [x21, x20, lsl #2]      // Load list[j] into w1
    add     w0, w0, w1                  // Compute sum = list[i] + list[j]

    ldr     x2, =target                 // Load address of target variable
    ldr     w1, [x2]                    // Load target value into w1
    cmp     w0, w1                      // Compare sum with target
    b.ne    next_j                      // If not equal, go to next_j

    mov     x22, #1                     // found = 1 (match found)
    b       check_found                 // Exit loops to check_found

next_j:
    add     x20, x20, #1                // Increment j by 1
    b       inner_loop                  // Repeat inner loop

next_i:
    add     x19, x19, #1                // Increment i by 1
    b       outer_loop                  // Repeat outer loop

// ---- Print result ----
check_found:
    cbz     x22, not_found              // If found == 0, branch to not_found

    ldr     x0, =msg_found              // Load address of msg_found string
    ldr     x1, =target                 // Load address of target variable
    ldr     w1, [x1]                    // Load target value into w1
    bl      printf                      // Print success message with target
    b       done                        // Skip not_found part

not_found:
    ldr     x0, =msg_not                // Load address of msg_not string
    ldr     x1, =target                 // Load address of target variable
    ldr     w1, [x1]                    // Load target value into w1
    bl      printf                      // Print failure message with target

// ---- Return ----
done:
    ldp     x21, x22, [sp], 16          // Restore x21, x22 from stack
    ldp     x19, x20, [sp], 16          // Restore x19, x20 from stack
    ldp     x29, x30, [sp], 16          // Restore frame pointer and link register
    mov     w0, #0                      // Return value 0 (normal exit)
    ret                                 // Return from main
