    .section .rodata
prompt3:    .asciz "Enter a number to check: "                      // target prompt
fmt_d:      .asciz "%d"                                             // scanf integer format
msg_found:  .asciz "There are two numbers in the list summing to the keyed-in number %d\n"
msg_not:    .asciz "There are not two numbers in the list summing to the keyed-in number %d\n"
msg_time:   .asciz "\nTotal: %llu ns for %d repetitions (avg %llu ns)\n"

    .align 4
list:       .word 1, 2, 4, 8, 16, 32, 64, 128                       // fixed list[8]

    .section .bss
    .align 4
target:     .space 4                                                // int target

    .text
    .global main
    .extern printf
    .extern scanf
    .extern now_ns                                                  // uint64_t now_ns(void)

    .equ SIZE,   8                                                  // list size
    .equ REPEAT, 1000000                                            // repetition count

// ------------------------------------------------------------
// main() — read target, time REPEAT runs of pair-sum check
// ------------------------------------------------------------
main:
    // --- prologue ---
    stp     x29, x30, [sp, -64]!                                    // push FP/LR, make room
    mov     x29, sp                                                 // set frame pointer
    stp     x19, x20, [sp, 16]                                      // save x19-x20
    stp     x21, x22, [sp, 32]                                      // save x21-x22
    stp     x23, x24, [sp, 48]                                      // save x23-x24

    // --- print prompt for target ---
    ldr     x0, =prompt3                                            // x0 = "Enter a number to check: "
    bl      printf                                                  // printf(prompt3)

    // --- read target once ---
    ldr     x0, =fmt_d                                              // x0 = "%d"
    ldr     x1, =target                                             // x1 = &target
    bl      scanf                                                   // scanf("%d", &target)

    // --- start_time = now_ns() ---
    bl      now_ns                                                  // x0 = start ns
    mov     x23, x0                                                 // x23 = start_time

    // --- for (r = 0; r < REPEAT; ++r) ---
    mov     w19, #0                                                 // w19 = r = 0

outer_repeat:
    cmp     w19, #REPEAT                                            // r >= REPEAT ?
    b.ge    done_repeats                                            // yes -> exit loop

    mov     w24, #0                                                 // found = 0 for this repetition
    mov     w20, #0                                                 // i = 0

// ------------------------------------------------------------
// nested loops over pairs (i, j) with j = i+1..SIZE-1
// ------------------------------------------------------------
outer_i:
    cmp     w20, #SIZE                                              // i >= SIZE ?
    b.ge    end_i_loop                                              // yes -> end i-loop

    add     w21, w20, #1                                            // j = i + 1

inner_j:
    cmp     w21, #SIZE                                              // j >= SIZE ?
    b.ge    next_i                                                  // yes -> next i

    // --- load list[i] and list[j] ---
    ldr     x2, =list                                               // x2 = &list[0]
    sxtw    x3, w20                                                 // x3 = (int64)i
    ldr     w0, [x2, x3, lsl #2]                                    // w0 = list[i]
    sxtw    x4, w21                                                 // x4 = (int64)j
    ldr     w1, [x2, x4, lsl #2]                                    // w1 = list[j]
    add     w0, w0, w1                                              // w0 = list[i] + list[j]

    // --- compare with target ---
    ldr     w1, target                                              // w1 = target
    cmp     w0, w1                                                  // sum == target ?
    b.ne    not_equal                                               // no -> advance j

    mov     w24, #1                                                 // found = 1
    b       end_i_loop                                              // break both loops

not_equal:
    add     w21, w21, #1                                            // j++
    b       inner_j                                                 // continue inner loop

next_i:
    add     w20, w20, #1                                            // i++
    b       outer_i                                                 // continue outer loop

end_i_loop:
    add     w19, w19, #1                                            // r++
    b       outer_repeat                                            // next repetition

done_repeats:
    // --- end_time = now_ns(); elapsed = end - start ---
    bl      now_ns                                                  // x0 = end ns
    mov     x22, x0                                                 // x22 = end_time
    sub     x21, x22, x23                                           // x21 = elapsed_ns

    // --- avg = elapsed / REPEAT (integer, ns per run) ---
    mov     x0, x21                                                 // x0 = elapsed
    mov     x1, #REPEAT                                             // x1 = REPEAT
    udiv    x2, x0, x1                                              // x2 = avg_ns

    // --- load target for messages ---
    ldr     w4, target                                              // w4 = target

    // --- print result message (based on last repetition's 'found') ---
    cbz     w24, print_not                                          // if found == 0 -> not found
    ldr     x0, =msg_found                                          // x0 = msg_found fmt
    mov     w1, w4                                                  // x1 = target
    bl      printf                                                  // print "found"
    b       after_result

print_not:
    ldr     x0, =msg_not                                            // x0 = msg_not fmt
    mov     w1, w4                                                  // x1 = target
    bl      printf                                                  // print "not found"

after_result:
    // --- print timing: total, repeats, average ---
    ldr     x0, =msg_time                                           // x0 = timing fmt
    mov     x1, x21                                                 // x1 = total elapsed ns (unsigned long long)
    mov     w2, #REPEAT                                             // x2 = repetitions (int)
    mov     x3, x2                                                  // x3 = average ns/run (unsigned long long) — in x2 from udiv above
    bl      printf                                                  // print timing line

    // --- epilogue / return 0 ---
    mov     w0, #0                                                  // return code = 0
    ldp     x23, x24, [sp, 48]                                      // restore x23-x24
    ldp     x21, x22, [sp, 32]                                      // restore x21-x22
    ldp     x19, x20, [sp, 16]                                      // restore x19-x20
    ldp     x29, x30, [sp], 64                                      // restore FP/LR and deallocate
    ret                                                             // return
