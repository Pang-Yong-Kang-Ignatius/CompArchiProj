    // ------------------------------------------------------------
    // Data section for constant strings
    // ------------------------------------------------------------
    .section .rodata
prompt1:    .asciz "Enter 8 numbers:\n"                          // Prompt for entering 8 numbers
prompt2:    .asciz "Enter number %d: "                           // Prompt for each number input
prompt3:    .asciz "Enter a number to check: "                   // Prompt for target number
fmt_d:      .asciz "%d"                                          // Format string for scanf
msg_found:  .asciz "There are two numbers in the list summing to the keyed-in number %d\n"
msg_not:    .asciz "There are not two numbers in the list summing to the keyed-in number %d\n"

    // ------------------------------------------------------------
    // Uninitialized data (for storing numbers and target)
    // ------------------------------------------------------------
    .section .bss
    .align 4
list:       .space 32          // Reserve 32 bytes → 8 integers * 4 bytes each
target:     .space 4           // Reserve 4 bytes for the target integer

    // ------------------------------------------------------------
    // Code section
    // ------------------------------------------------------------
    .text
    .global main
    .extern printf
    .extern scanf

// ------------------------------------------------------------
// main() function start
// ------------------------------------------------------------
main:
    // --- Function prologue (stack frame setup) ---
    stp     x29, x30, [sp, -16]!        // Push frame pointer (x29) and return address (x30) onto stack
    mov     x29, sp                     // Set new frame pointer
    stp     x19, x20, [sp, -16]!        // Save callee-saved registers x19, x20
    stp     x21, x22, [sp, -16]!        // Save callee-saved registers x21, x22

    // --- Print "Enter 8 numbers:\n" ---
    ldr     x0, =prompt1                // x0 = address of prompt1 string
    bl      printf                      // Call printf(prompt1)

    // --- Initialize variables ---
    mov     x19, #0                     // i = 0 (loop counter)
    ldr     x21, =list                  // x21 = base address of list array

// ------------------------------------------------------------
// Read 8 numbers (no validation)
// ------------------------------------------------------------
read_loop:
    cmp     x19, #8                     // Compare i with 8
    b.ge    read_done                   // If i >= 8 → exit loop

    // --- Print "Enter number %d: " ---
    ldr     x0, =prompt2                // x0 = format string
    add     x1, x19, #1                 // x1 = i + 1 (for printf argument)
    bl      printf                      // printf("Enter number %d: ", i+1)

    // --- Read integer into list[i] ---
    ldr     x0, =fmt_d                  // x0 = "%d"
    add     x1, x21, x19, lsl #2        // x1 = &list[i] → base + (i * 4)
    bl      scanf                       // scanf("%d", &list[i])

    // --- Increment i ---
    add     x19, x19, #1                // i++
    b       read_loop                   // Repeat until 8 numbers entered

// ------------------------------------------------------------
// Read target number (no validation)
// ------------------------------------------------------------
read_done:
    // --- Prompt user for target number ---
    ldr     x0, =prompt3                // x0 = "Enter a number to check: "
    bl      printf                      // Print prompt

    // --- Read target value ---
    ldr     x0, =fmt_d                  // x0 = "%d"
    ldr     x1, =target                 // x1 = &target
    bl      scanf                       // scanf("%d", &target)

// ------------------------------------------------------------
// Pair-sum checking logic (two nested loops)
// ------------------------------------------------------------
have_target:
    mov     x22, #0                     // found = 0
    mov     x19, #0                     // i = 0
    ldr     x0, =target                 // x0 = address of target
    ldr     w2, [x0]                    // w2 = target value

// --- Outer loop: iterate i from 0 to 7 ---
outer_loop:
    cmp     x19, #8                     // if (i >= 8)
    b.ge    check_found                 // → exit outer loop
    add     x20, x19, #1                // j = i + 1

// --- Inner loop: iterate j from i+1 to 7 ---
inner_loop:
    cmp     x20, #8                     // if (j >= 8)
    b.ge    next_i                      // → move to next i

    // --- sum = list[i] + list[j] ---
    ldr     w0, [x21, x19, lsl #2]      // w0 = list[i]
    ldr     w1, [x21, x20, lsl #2]      // w1 = list[j]
    add     w0, w0, w1                  // w0 = list[i] + list[j]

    // --- Compare with target ---
    cmp     w0, w2                      // if (sum == target)
    b.ne    next_j                      // if not equal, continue inner loop

    // --- Found a valid pair ---
    mov     x22, #1                     // found = 1
    b       check_found                 // break both loops

// --- Increment j and continue inner loop ---
next_j:
    add     x20, x20, #1                // j++
    b       inner_loop                  // continue inner loop

// --- Increment i and continue outer loop ---
next_i:
    add     x19, x19, #1                // i++
    b       outer_loop                  // continue outer loop

// ------------------------------------------------------------
// Print result based on 'found' flag
// ------------------------------------------------------------
check_found:
    cbz     x22, not_found              // if (found == 0) → jump to not_found

    // --- Print success message ---
    ldr     x0, =msg_found              // x0 = message string
    mov     w1, w2                      // w1 = target (printf argument)
    bl      printf                      // printf(msg_found, target)
    b       done                        // skip not_found section

// --- Print failure message ---
not_found:
    ldr     x0, =msg_not                // x0 = message string
    mov     w1, w2                      // w1 = target
    bl      printf                      // printf(msg_not, target)

// ------------------------------------------------------------
// Function epilogue (restore stack + return)
// ------------------------------------------------------------
done:
    ldp     x21, x22, [sp], 16          // Restore x21, x22
    ldp     x19, x20, [sp], 16          // Restore x19, x20
    ldp     x29, x30, [sp], 16          // Restore frame pointer + return address
    mov     w0, #0                      // Return 0 to indicate success
    ret                                 // Return to OS
