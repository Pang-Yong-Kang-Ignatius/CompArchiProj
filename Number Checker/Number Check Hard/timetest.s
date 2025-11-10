// two_sum_pure.s — ARM64 Assembly (Raspberry Pi x64, pure assembly version)
// Measure total and average execution time without using any C helper.
// Build: gcc two_sum_pure.s -o two_sum_pure
// Run:   ./two_sum_pure

    .section .rodata
prompt3:    .asciz "Enter a number to check: "
fmt_d:      .asciz "%d"
msg_found:  .asciz "There are two numbers in the list summing to the keyed-in number %d\n"
msg_not:    .asciz "There are not two numbers in the list summing to the keyed-in number %d\n"
msg_time:   .asciz "\nTotal: %llu ns for %d repetitions (avg %llu ns)\n"

    .align 4
list:       .word 1, 2, 4, 8, 16, 32, 64, 128          // fixed list of integers

    .section .bss
    .align 4
target:     .space 4                                   // space for target integer

    .text
    .global main
    .extern printf
    .extern scanf
    .extern clock_gettime                              // from libc

// ------------------------------------------------------------
// Constant values (assembler-level)
// ------------------------------------------------------------
SIZE    = 8
REPEAT  = 1000000
CLOCK_MONOTONIC_RAW = 4

// ------------------------------------------------------------
// Helper: get time in nanoseconds → returns x0 = ns (uint64_t)
// ------------------------------------------------------------
get_time_ns:
    sub     sp, sp, #16               // allocate space for struct timespec (16 B)
    mov     w0, #CLOCK_MONOTONIC_RAW  // clock id = 4 (CLOCK_MONOTONIC_RAW)
    mov     x1, sp                    // pointer to struct timespec
    bl      clock_gettime             // call libc clock_gettime()
    ldr     x2, [sp]                  // tv_sec  (first 8 bytes)
    ldr     x3, [sp, 8]               // tv_nsec (next 8 bytes)
    mov     x4, #1000000000
    mul     x0, x2, x4                // sec * 1e9
    add     x0, x0, x3                // + nanoseconds
    add     sp, sp, #16               // restore stack
    ret

// ------------------------------------------------------------
// main() — repeated two-sum test + timing
// ------------------------------------------------------------
main:
    // --- Prologue ---
    stp     x29, x30, [sp, -64]!
    mov     x29, sp
    stp     x19, x20, [sp, 16]
    stp     x21, x22, [sp, 32]
    stp     x23, x24, [sp, 48]

    // --- Prompt user for target ---
    ldr     x0, =prompt3
    bl      printf

    // --- Read target integer ---
    ldr     x0, =fmt_d
    ldr     x1, =target
    bl      scanf

    // --- Get start time ---
    bl      get_time_ns
    mov     x23, x0                   // x23 = start_time

    // --- Outer repeat loop ---
    mov     w19, #0                   // r = 0

outer_repeat:
    cmp     w19, #REPEAT
    b.ge    done_repeats

    mov     w24, #0                   // found = 0
    mov     w20, #0                   // i = 0

outer_i:
    cmp     w20, #SIZE
    b.ge    end_i_loop
    add     w21, w20, #1              // j = i + 1

inner_j:
    cmp     w21, #SIZE
    b.ge    next_i
    ldr     x2, =list
    sxtw    x3, w20
    ldr     w0, [x2, x3, lsl #2]      // w0 = list[i]
    sxtw    x4, w21
    ldr     w1, [x2, x4, lsl #2]      // w1 = list[j]
    add     w0, w0, w1                // w0 = list[i] + list[j]
    ldr     w1, target
    cmp     w0, w1
    b.ne    not_equal
    mov     w24, #1
    b       end_i_loop

not_equal:
    add     w21, w21, #1
    b       inner_j

next_i:
    add     w20, w20, #1
    b       outer_i

end_i_loop:
    add     w19, w19, #1
    b       outer_repeat

// ------------------------------------------------------------
// Done — measure end time and print results
// ------------------------------------------------------------
done_repeats:
    bl      get_time_ns
    mov     x22, x0                   // end_time
    sub     x21, x22, x23             // elapsed_ns = end - start

    // average_ns = elapsed / REPEAT
    mov     x0, x21
    mov     x1, #REPEAT
    udiv    x2, x0, x1                // x2 = average

    // Load target value
    ldr     w4, target

    // Print result messages
    cbz     w24, print_not
    ldr     x0, =msg_found
    mov     w1, w4
    bl      printf
    b       after_result

print_not:
    ldr     x0, =msg_not
    mov     w1, w4
    bl      printf

after_result:
    // Print timing info
    ldr     x0, =msg_time
    mov     x1, x21                   // total ns
    mov     w2, #REPEAT
    mov     x3, x2                    // avg ns
    bl      printf

    // --- Return 0 ---
    mov     w0, #0
    ldp     x23, x24, [sp, 48]
    ldp     x21, x22, [sp, 32]
    ldp     x19, x20, [sp, 16]
    ldp     x29, x30, [sp], 64
    ret
