// pair_sum_simple.s — Raspberry Pi AArch64 Assembly
// Build:  gcc -O2 pair_sum_simple.s -o pair_sum_simple
// Run:    ./pair_sum_simple

        .section .rodata                  // Read-only data section (constants)
list:       .word 1,2,4,8,16,32,64,128    // The 8 fixed integers
msg_prompt: .asciz "Enter a number to check: "   // Prompt text
fmt_d:      .asciz "%d"                  // Format for scanf/printf
msg_yes:    .asciz "There are two numbers in the list summing to %d\n"
msg_no:     .asciz "There are not two numbers in the list summing to %d\n"
msg_time:   .asciz "Total ns: %llu   |   Avg ns: %llu\n"   // Timing results

        .section .bss                    // Uninitialized memory
target:     .space 4                     // Reserve 4 bytes for target integer

        .text                            // Code section
        .global main                     // Export symbol main
        .extern printf, scanf, clock_gettime // Declare external functions

        .equ REPEAT, 1000000             // Number of repetitions
        .equ CLOCK_MONOTONIC, 1          // clock_gettime source constant

main:
        stp x29, x30, [sp, -32]!         // Save frame pointer (x29) and return address (x30)
        mov x29, sp                      // Set new frame pointer

        adrp x0, msg_prompt@PAGE         // Load page address of prompt string
        add  x0, x0, msg_prompt@PAGEOFF  // Add offset to form full address
        bl   printf                      // printf(prompt)

        adrp x0, fmt_d@PAGE              // Load page of "%d"
        add  x0, x0, fmt_d@PAGEOFF       // Add offset
        adrp x1, target@PAGE             // Load page of target variable
        add  x1, x1, target@PAGEOFF      // Add offset → &target
        bl   scanf                       // scanf("%d", &target)

        mov  w0, #CLOCK_MONOTONIC        // w0 = CLOCK_MONOTONIC argument
        sub  sp, sp, #32                 // Reserve 32 bytes for timespec storage
        mov  x1, sp                      // x1 = &t0 storage
        bl   clock_gettime               // clock_gettime(CLOCK_MONOTONIC, &t0)

        mov  w19, #0                     // r = 0 (repeat counter)

REPEAT_LOOP:
        cmp  w19, #REPEAT                // Compare r with REPEAT
        b.ge DONE_REPEAT                 // If r >= REPEAT → stop

        mov  w20, #0                     // found = 0
        mov  w21, #0                     // i = 0

LOOP_I:
        cmp  w21, #8                     // if i >= 8 → end
        b.ge END_I_LOOP
        add  w22, w21, #1                // j = i + 1

LOOP_J:
        cmp  w22, #8                     // if j >= 8 → next i
        b.ge NEXT_I

        adrp x23, list@PAGE              // Load base address of list (high bits)
        add  x23, x23, list@PAGEOFF      // Add offset → x23 = &list
        ldr  w0, [x23, w21, sxtw #2]     // w0 = list[i]
        ldr  w1, [x23, w22, sxtw #2]     // w1 = list[j]
        add  w0, w0, w1                  // w0 = list[i] + list[j]

        adrp x24, target@PAGE            // Load target address (page)
        add  x24, x24, target@PAGEOFF    // Add offset → &target
        ldr  w1, [x24]                   // w1 = target
        cmp  w0, w1                      // Compare sum vs target
        b.ne INC_J                       // If not equal → continue inner loop

        mov  w20, #1                     // found = 1
        b    END_I_LOOP                  // Break out of both loops

INC_J:
        add  w22, w22, #1                // j++
        b    LOOP_J                      // Repeat inner loop

NEXT_I:
        add  w21, w21, #1                // i++
        b    LOOP_I                      // Repeat outer loop

END_I_LOOP:
        add  w19, w19, #1                // r++
        b    REPEAT_LOOP                 // Repeat top loop

DONE_REPEAT:
        mov  w0, #CLOCK_MONOTONIC        // clock_gettime(CLOCK_MONOTONIC, &t1)
        mov  x1, sp                      // Store into the same allocated memory
        bl   clock_gettime

        ldr x2, [sp]         // x2 = t0.sec
        ldr x3, [sp, #8]     // x3 = t0.nsec
        ldr x4, [sp, #16]    // x4 = t1.sec
        ldr x5, [sp, #24]    // x5 = t1.nsec

        sub x6, x4, x2       // (t1.sec - t0.sec)
        mov x7, #1000000000  // constant 1e9
        mul x6, x6, x7       // convert seconds to nanoseconds
        sub x7, x5, x3       // (t1.nsec - t0.nsec)
        add x6, x6, x7       // x6 = total_ns

        mov x8, #REPEAT      // divisor for average
        udiv x9, x6, x8      // x9 = avg_ns = total_ns / REPEAT

        add sp, sp, #32      // Free stack space used for timing data

        cbz w20, PRINT_NO    // If found == 0 → go print "not found"

        adrp x0, msg_yes@PAGE
        add  x0, x0, msg_yes@PAGEOFF
        adrp x1, target@PAGE
        add  x1, x1, target@PAGEOFF
        ldr  w1, [x1]
        bl   printf
        b PRINT_TIME

PRINT_NO:
        adrp x0, msg_no@PAGE
        add  x0, x0, msg_no@PAGEOFF
        adrp x1, target@PAGE
        add  x1, x1, target@PAGEOFF
        ldr  w1, [x1]
        bl   printf

PRINT_TIME:
        adrp x0, msg_time@PAGE
        add  x0, x0, msg_time@PAGEOFF
        mov  x1, x6         // x1 = total_ns
        mov  x2, x9         // x2 = avg_ns
        bl   printf         // print timing info

        ldp x29, x30, [sp], 32   // Restore frame pointer + return address
        mov w0, #0               // return 0
        ret                      // return to OS
