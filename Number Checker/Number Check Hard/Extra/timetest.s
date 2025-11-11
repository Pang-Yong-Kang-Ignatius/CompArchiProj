// timetest.s — ARM64 (AArch64) Linux (Raspberry Pi 64-bit), GNU as syntax
// Reads 8 integers, reads a target, runs the two-sum check REPEAT times,
// times with clock(), and prints total & average seconds.

    .equ    REPEAT, 1000

    .section .rodata
prompt1:    .asciz "Enter 8 numbers:\n"
prompt2:    .asciz "Enter number %d: "
prompt3:    .asciz "Enter a number to check: "
fmt_d:      .asciz "%d"
fmt_total:  .asciz "\nTotal execution time for %d repetitions: %.6f seconds\n"
fmt_avg:    .asciz "Average execution time per run: %.9f seconds\n"
msg_found:  .asciz "There are two numbers in the list summing to the keyed-in number %d\n"
msg_not:    .asciz "There are not two numbers in the list summing to the keyed-in number %d\n"

inv_cps:    .double 0.000001                // 1.0 / CLOCKS_PER_SEC (1e6)

    .section .bss
    .align 3
list:       .space 32                        // 8 * 4 bytes
target:     .space 4

    .section .text
    .global main
    .extern printf
    .extern scanf
    .extern clock

main:
    // Prologue
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    stp     x19, x20, [sp, -16]!
    stp     x21, x22, [sp, -16]!
    stp     x23, x24, [sp, -16]!

    // Print intro
    ldr     x0, =prompt1
    bl      printf

    // i = 0, base(list) -> x21
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

// ---- Start timing: start = clock() ----
    bl      clock
    mov     x23, x0                         // x23 = start ticks

// ---- Repeat two-sum REPEAT times ----
    mov     x24, #0                         // r = 0
repeat_loop:
    cmp     x24, #REPEAT
    b.ge    repeats_done

    // found = 0; i = 0
    mov     x22, #0                         // found
    mov     x19, #0                         // i
    ldr     x21, =list

outer_loop:
    cmp     x19, #8
    b.ge    after_search
    add     x20, x19, #1                    // j = i + 1

inner_loop:
    cmp     x20, #8
    b.ge    next_i

    ldr     w0, [x21, x19, lsl #2]          // list[i]
    ldr     w1, [x21, x20, lsl #2]          // list[j]
    add     w0, w0, w1                      // sum

    ldr     x2, =target
    ldr     w1, [x2]                        // target
    cmp     w0, w1
    b.ne    next_j

    mov     x22, #1                         // found = 1
    b       after_search

next_j:
    add     x20, x20, #1
    b       inner_loop

next_i:
    add     x19, x19, #1
    b       outer_loop

after_search:
    add     x24, x24, #1
    b       repeat_loop

repeats_done:
// ---- End timing: end = clock() ----
    bl      clock
    mov     x24, x0                         // x24 = end ticks

// ticks = end - start
    sub     x0, x24, x23                    // x0 = ticks (uint64)

// seconds = (double)ticks * (1.0 / 1e6)
    scvtf   d0, x0                          // d0 = (double)ticks
    ldr     x1, =inv_cps
    ldr     d1, [x1]                        // d1 = 1e-6
    fmul    d0, d0, d1                      // d0 = elapsed_time (seconds)

// avg_time = seconds / REPEAT
    fmov    d2, d0                          // keep total in d2
    mov     x2, #REPEAT
    scvtf   d1, x2                          // d1 = (double)REPEAT
    fdiv    d1, d2, d1                      // d1 = avg_time

// Print total
    ldr     x0, =fmt_total                  // fmt
    mov     x1, #REPEAT                     // %d
    fmov    d0, d2                          // %.6f total seconds
    bl      printf

// Print average
    ldr     x0, =fmt_avg
    fmov    d0, d1                          // %.9f avg seconds
    bl      printf

// Print found/not (based on last run)
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

// ---- Epilogue ----
done:
    ldp     x23, x24, [sp], 16
    ldp     x21, x22, [sp], 16
    ldp     x19, x20, [sp], 16
    ldp     x29, x30, [sp], 16
    mov     w0, #0
    ret
