    .section .rodata
prompt1:    .asciz "Enter 8 numbers:\n"
prompt2:    .asciz "Enter number %d: "
prompt3:    .asciz "Enter a number to check: "
fmt_d:      .asciz "%d"
msg_found:  .asciz "There are two numbers in the list summing to the keyed-in number %d\n"
msg_not:    .asciz "There are not two numbers in the list summing to the keyed-in number %d\n"

    .section .bss
    .align 4
list:       .space 32          // 8 * 4 bytes
target:     .space 4

    .text
    .global main
    .extern printf
    .extern scanf

main:
    // Prologue
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    stp     x19, x20, [sp, -16]!
    stp     x21, x22, [sp, -16]!

    // Print intro text
    ldr     x0, =prompt1
    bl      printf

    // i = 0, base of list in x21
    mov     x19, #0
    ldr     x21, =list

// ---- Read 8 numbers (no validation) ----
read_loop:
    cmp     x19, #8
    b.ge    read_done

    ldr     x0, =prompt2
    add     x1, x19, #1
    bl      printf

    ldr     x0, =fmt_d
    add     x1, x21, x19, lsl #2
    bl      scanf

    add     x19, x19, #1
    b       read_loop

// ---- Read target (no validation) ----
read_done:
    ldr     x0, =prompt3
    bl      printf

    ldr     x0, =fmt_d
    ldr     x1, =target
    bl      scanf

// ---- Two-sum logic ----
    mov     x22, #0          // found = 0
    mov     x19, #0          // i = 0

outer_loop:
    cmp     x19, #8
    b.ge    check_found
    add     x20, x19, #1     // j = i + 1

inner_loop:
    cmp     x20, #8
    b.ge    next_i

    ldr     w0, [x21, x19, lsl #2]   // list[i]
    ldr     w1, [x21, x20, lsl #2]   // list[j]
    add     w0, w0, w1               // sum

    ldr     x2, =target
    ldr     w1, [x2]                 // w1 = target
    cmp     w0, w1
    b.ne    next_j

    mov     x22, #1                  // found = 1
    b       check_found

next_j:
    add     x20, x20, #1
    b       inner_loop

next_i:
    add     x19, x19, #1
    b       outer_loop

// ---- Print result ----
check_found:
    cbz     x22, not_found

    ldr     x0, =msg_found
    ldr     x1, =target
    ldr     w1, [x1]
    bl      printf
    b       done

not_found:
    ldr     x0, =msg_not
    ldr     x1, =target
    ldr     w1, [x1]
    bl      printf

// ---- Return ----
done:
    ldp     x21, x22, [sp], 16
    ldp     x19, x20, [sp], 16
    ldp     x29, x30, [sp], 16
    mov     w0, #0
    ret
