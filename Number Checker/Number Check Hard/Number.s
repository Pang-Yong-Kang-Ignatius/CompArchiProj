// two_sum_repeated.s — ARM64 Assembly (Raspberry Pi 64-bit)
// Functionality: same as earlier C version with timing using now_ns()
// Build: gcc two_sum_repeated.s now_ns.c -o two_sum_repeated

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
    .extern now_ns

// ------------------------------------------------------------
// Constants (assembler-level, not memory variables)
// ------------------------------------------------------------
SIZE    = 8
REPEAT  = 1000000

// ------------------------------------------------------------
// main() — Measure execution time of repeated pair-sum checking
// ------------------------------------------------------------
main:
    // --- Prologue ---
    stp     x29, x30, [sp, -64]!                      // save FP/LR
    mov     x29, sp
    stp     x19, x20, [sp, 16]
    stp     x21, x22, [sp, 32]
    stp     x23, x24, [sp, 48]

    // --- Prompt user for target ---
    ldr     x0, =prompt3                              // "Enter a number to check: "
    bl      printf

    // --- Read target integer ---
    ldr     x0, =fmt_d
    ldr     x1, =target
    bl      scanf

    // --- Get start time (ns) ---
    bl      now_ns
    mov     x23, x0                                   // x23 = start_time

    // --- Repeat loop counter ---
    mov     w19, #0                                   // r = 0

outer_repeat:
    cmp     w19, #REPEAT                              // while (r < REPEAT)
    b.ge    done_repeats

    mov     w24, #0                                   // found = 0
    mov     w20, #0                                   // i = 0

// ------------------------------------------------------------
// Outer and inner loops over list pairs
// ------------------------------------------------------------
outer_i:
    cmp     w20, #SIZE                                // if i >= SIZE
    b.ge    end_i_loop

    add     w21, w20, #1                              // j = i + 1

inner_j:
    cmp     w21, #SIZE                                // if j >= SIZE
    b.ge    next_i

    // --- Load list[i] and list[j] ---
    ldr     x2, =list
    sxtw    x3, w20
    ldr     w0, [x2, x3, lsl #2]                      // w0 = list[i]
    sxtw    x4, w21
    ldr     w1, [x2, x4, lsl #2]                      // w1 = list[j]
    add     w0, w0, w1                                // w0 = list[i] + list[j]

    // --- Compare with target ---
    ldr     w1, target                                // w1 = target
    cmp     w0, w1
    b.ne    not_equal

    mov     w24, #1                                   // found = 1
    b       end_i_loop                                // break both loops

not_equal:
    add     w21, w21, #1                              // j++
    b       inner_j                                   // continue inner loop

next_i:
    add     w20, w20, #1                              // i++
    b       outer_i                                   // continue outer loop

end_i_loop:
    add     w19, w19, #1                              // r++
    b       outer_repeat                              // repeat next run

// ------------------------------------------------------------
// After all repetitions: measure end time
// ------------------------------------------------------------
done_repeats:
    bl      now_ns
    mov     x22, x0                                   // x22 = end_time
    sub     x21, x22, x23                             // x21 = elapsed_ns

    // Compute average = elapsed / REPEAT
    mov     x0, x21
    mov     x1, #REPEAT
    udiv    x2, x0, x1                                // x2 = avg_ns

    // Load target for printing
    ldr     w4, target

// ------------------------------------------------------------
// Print result message
// ------------------------------------------------------------
    cbz     w24, print_not                            // if found == 0 → not found
    ldr     x0, =msg_found
    mov     w1, w4
    bl      printf
    b       after_result

print_not:
    ldr     x0, =msg_not
    mov     w1, w4
    bl      printf

after_result:
    // Print total time and average
    ldr     x0, =msg_time
    mov     x1, x21                                   // total ns
    mov     w2, #REPEAT                               // repeat count
    mov     x3, x2                                    // avg ns/run
    bl      printf

    // --- Return 0 ---
    mov     w0, #0
    ldp     x23, x24, [sp, 48]
    ldp     x21, x22, [sp, 32]
    ldp     x19, x20, [sp, 16]
    ldp     x29, x30, [sp], 64
    ret
