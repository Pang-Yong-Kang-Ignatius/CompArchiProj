    .section .rodata
prompt1:    .asciz "Enter 8 numbers:\n" 
prompt2:    .asciz "Enter number %d: "
prompt3:    .asciz "Enter a number to check: "
fmt_d:      .asciz "%d"                     // scanf format specifier for integers
msg_found:  .asciz "There are two numbers in the list summing to the keyed-in number %d\n"
msg_not:    .asciz "There are not two numbers in the list summing to the keyed-in number %d\n"
msg_inv:    .asciz "Invalid input! Please enter an integer.\n" // error message for invalid input

    .section .bss
    .align 4
list:       .space 32                       // reserve 8 * 4 bytes for list of integers
target:     .space 4                        // reserve 4 bytes for target integer

    .text
    .global main
    .extern printf
    .extern scanf
    .extern getchar

// ------------------------------------------------------------
// main() function start
// ------------------------------------------------------------
main:
    // --- Function prologue (stack frame setup) ---
    stp     x29, x30, [sp, -16]!            // Save frame pointer and link register
    mov     x29, sp                         // Set up new frame pointer
    stp     x19, x20, [sp, -16]!            // Save callee-saved registers
    stp     x21, x22, [sp, -16]!            // Save more registers for later use

    // --- Print initial prompt ---
    ldr     x0, =prompt1                    // x0 = address of "Enter 8 numbers:\n"
    bl      printf                          // call printf(prompt1)

    mov     x19, #0                         // i = 0 (counter for input loop)
    ldr     x21, =list                      // x21 = base address of list array

// ------------------------------------------------------------
// Read 8 numbers from user with input validation
// ------------------------------------------------------------
read_loop:
    cmp     x19, #8                         // if (i >= 8)
    b.ge    read_done                       // stop reading when 8 numbers entered

read_one:
    // --- print "Enter number %d: " ---
    ldr     x0, =prompt2                    // x0 = format string
    add     x1, x19, #1                     // x1 = i + 1 (argument for %d)
    bl      printf                          // printf("Enter number %d: ", i+1)

    // --- attempt to read integer ---
    ldr     x0, =fmt_d                      // x0 = "%d"
    add     x1, x21, x19, lsl #2            // x1 = &list[i]
    bl      scanf                           // scanf("%d", &list[i]); return value in w0

    cmp     w0, #1                          // did scanf read exactly 1 integer?
    beq     read_ok                         // if yes, accept it

    // --- invalid input handling ---
    ldr     x0, =msg_inv                    // x0 = error message
    bl      printf                          // printf("Invalid input! Please enter an integer.\n")

    // --- clear invalid characters until newline ---
clear_buf:
    bl      getchar                         // getchar() returns char in w0
    cmp     w0, #10                         // check if it is '\n'
    b.ne    clear_buf                       // if not newline, keep clearing
    b       read_one                        // retry same number input

read_ok:
    add     x19, x19, #1                    // i++
    b       read_loop                       // continue reading next number

// ------------------------------------------------------------
// After reading all 8 numbers, get target number with validation
// ------------------------------------------------------------
read_done:
read_target:
    // --- prompt for target number ---
    ldr     x0, =prompt3                    // x0 = "Enter a number to check: "
    bl      printf

    // --- attempt to read integer target ---
    ldr     x0, =fmt_d
    ldr     x1, =target
    bl      scanf

    cmp     w0, #1                          // did scanf read valid integer?
    beq     have_target                     // if yes, proceed

    // --- invalid target input ---
    ldr     x0, =msg_inv
    bl      printf

clr_tgt:
    bl      getchar                         // clear input buffer
    cmp     w0, #10                         // until newline '\n'
    b.ne    clr_tgt
    b       read_target                     // retry target input

// ------------------------------------------------------------
// Pair sum checking logic (two nested loops)
// ------------------------------------------------------------
have_target:
    mov     x22, #0                         // found = 0
    mov     x19, #0                         // i = 0

outer_loop:
    cmp     x19, #8                         // if i >= 8
    b.ge    check_found                     // stop outer loop
    add     x20, x19, #1                    // j = i + 1

inner_loop:
    cmp     x20, #8                         // if j >= 8
    b.ge    next_i                          // go to next i

    // --- load list[i] + list[j] ---
    ldr     w0, [x21, x19, lsl #2]          // w0 = list[i]
    ldr     w1, [x21, x20, lsl #2]          // w1 = list[j]
    add     w0, w0, w1                      // w0 = list[i] + list[j]

    // --- compare with target ---
    ldr     w1, target                      // w1 = target
    cmp     w0, w1                          // compare sum to target
    b.ne    next_j                          // if not equal, continue inner loop

    mov     x22, #1                         // found = 1
    b       check_found                     // break out of both loops

next_j:
    add     x20, x20, #1                    // j++
    b       inner_loop                      // continue checking next pair

next_i:
    add     x19, x19, #1                    // i++
    b       outer_loop                      // repeat outer loop

// ------------------------------------------------------------
// Print results depending on 'found' flag
// ------------------------------------------------------------
check_found:
    cbz     x22, not_found                  // if found == 0 → print "not found"

    // --- print found message ---
    ldr     x0, =msg_found                  // x0 = success message format
    ldr     w1, target                      // w1 = target (printf arg)
    bl      printf
    b       done                            // skip "not found"

not_found:
    // --- print not found message ---
    ldr     x0, =msg_not                    // x0 = failure message format
    ldr     w1, target                      // w1 = target
    bl      printf

// ------------------------------------------------------------
// End of program (cleanup + return 0)
// ------------------------------------------------------------
done:
    ldp     x21, x22, [sp], 16              // restore registers x21, x22
    ldp     x19, x20, [sp], 16              // restore registers x19, x20
    ldp     x29, x30, [sp], 16              // restore frame pointer + link register
    mov     w0, #0                          // return 0
    ret                                     // return to OS
