    .section .rodata
prompt1:    .asciz "Enter 8 numbers:\n"
prompt2:    .asciz "Enter number %d: "
prompt3:    .asciz "Enter a number to check: "
fmt_d:      .asciz "%d"
msg_found:  .asciz "There are two numbers in the list summing to the keyed-in number %d\n"
msg_not:    .asciz "There are not two numbers in the list summing to the keyed-in number %d\n"
msg_inv:    .asciz "Invalid input! Please enter an integer.\n"
msg_time:   .asciz "Total: %llu ns for %d repeats (avg %llu ns)\n"

    .section .bss
    .align 4
list:       .space 32            // 8 * 4B
target:     .space 4

    .text
    .global main
    .extern printf
    .extern scanf
    .extern getchar
    .extern now_ns               // uint64_t now_ns(void)

    .equ REPEAT, 1000000

main:
    // prologue
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    stp     x19, x20, [sp, -16]!
    stp     x21, x22, [sp, -16]!
    stp     x23, x24, [sp, -16]!     // will hold start_ns, total_ns
    stp     x25, x26, [sp, -16]!     // loop/repeat temps

    // prompt "Enter 8 numbers:"
    ldr     x0, =prompt1
    bl      printf

    mov     x19, #0                  // i = 0
    ldr     x21, =list               // base of list

// ---- read 8 ints with validation
read_loop:
    cmp     x19, #8
    b.ge    read_done

read_one:
    ldr     x0, =prompt2
    add     x1, x19, #1
    bl      printf

    ldr     x0, =fmt_d
    add     x1, x21, x19, lsl #2     // &list[i]
    bl      scanf

    cmp     w0, #1
    beq     read_ok

    ldr     x0, =msg_inv
    bl      printf
clear_buf:
    bl      getchar
    cmp     w0, #10
    b.ne    clear_buf
    b       read_one

read_ok:
    add     x19, x19, #1
    b       read_loop

// ---- read target with validation
read_done:
read_target:
    ldr     x0, =prompt3
    bl      printf

    ldr     x0, =fmt_d
    ldr     x1, =target
    bl      scanf
    cmp     w0, #1
    beq     have_target

    ldr     x0, =msg_inv
    bl      printf
clr_tgt:
    bl      getchar
    cmp     w0, #10
    b.ne    clr_tgt
    b       read_target

// ---- pair-sum check once (for correctness message)
have_target:
    mov     x22, #0                  // found = 0
    mov     x19, #0                  // i = 0
outer_loop:
    cmp     x19, #8
    b.ge    print_result
    add     x20, x19, #1             // j = i+1
inner_loop:
    cmp     x20, #8
    b.ge    next_i
    ldr     w0, [x21, x19, lsl #2]   // list[i]
    ldr     w1, [x21, x20, lsl #2]   // list[j]
    add     w0, w0, w1
    ldr     w1, target
    cmp     w0, w1
    b.ne    next_j
    mov     x22, #1
    b       print_result
next_j:
    add     x20, x20, #1
    b       inner_loop
next_i:
    add     x19, x19, #1
    b       outer_loop

// ---- print result
print_result:
    cbz     x22, not_found
    ldr     x0, =msg_found
    ldr     w1, target
    bl      printf
    b       do_timing
not_found:
    ldr     x0, =msg_not
    ldr     w1, target
    bl      printf

// ---- timing: repeat the pair-check REPEAT times
do_timing:
    bl      now_ns                   // start
    mov     x23, x0                  // start_ns = x0

    mov     x25, #REPEAT             // repeat counter
time_outer_repeat:
    // found = 0; i = 0;
    mov     x22, #0
    mov     x19, #0
time_outer_i:
    cmp     x19, #8
    b.ge    time_chk_done
    add     x20, x19, #1
time_inner_j:
    cmp     x20, #8
    b.ge    time_next_i
    ldr     w0, [x21, x19, lsl #2]
    ldr     w1, [x21, x20, lsl #2]
    add     w0, w0, w1
    ldr     w1, target
    cmp     w0, w1
    b.ne    time_next_j
    mov     x22, #1
    b       time_chk_done
time_next_j:
    add     x20, x20, #1
    b       time_inner_j
time_next_i:
    add     x19, x19, #1
    b       time_outer_i
time_chk_done:
    subs    x25, x25, #1
    b.ne    time_outer_repeat

    bl      now_ns                   // end
    sub     x24, x0, x23            // total_ns = end - start

    // avg = total_ns / REPEAT
    mov     x2, #REPEAT
    udiv    x3, x24, x2             // x3 = avg_ns (integer)

    // printf("Total: %llu ns for %d repeats (avg %llu ns)\n", total_ns, REPEAT, avg_ns)
    ldr     x0, =msg_time
    mov     x1, x24                  // total_ns (unsigned long long)
    mov     w2, #REPEAT              // repeats (int)
    mov     x3, x3                   // avg_ns
    bl      printf

    // epilogue
    ldp     x25, x26, [sp], 16
    ldp     x23, x24, [sp], 16
    ldp     x21, x22, [sp], 16
    ldp     x19, x20, [sp], 16
    ldp     x29, x30, [sp], 16
    mov     w0, #0
    ret
