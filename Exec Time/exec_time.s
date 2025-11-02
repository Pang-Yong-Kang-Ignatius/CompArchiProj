
        .text
        .global main

main:
        // Prologue
        stp     x29, x30, [sp, -16]!
        mov     x29, sp

        // 1) Get clock cycle time (double)
        ldr     x0, =prompt_clk
        bl      printf
        ldr     x0, =fmt_double
        ldr     x1, =clock_time
        bl      scanf

        // Loop through 4 instruction types to get counts and CPIs
        mov     w19, 0                  // i = 0 (loop counter)
        ldr     x20, =count             // base address of count array
        ldr     x21, =cpi               // base address of cpi array

input_loop:
        cmp     w19, 4
        b.ge    input_done

        // Calculate prompt number for count: 2 + i * 2
        mov     w22, w19
        lsl     w22, w22, 1             // i * 2
        add     w22, w22, 2             // 2 + i * 2

        // Print count prompt
        ldr     x0, =prompt_count
        mov     w1, w22                 // prompt number
        add     w2, w19, 1              // instruction type (i+1)
        mov     w3, w2                  // instruction type again
        bl      printf

        // Read count[i]
        ldr     x0, =fmt_ll
        lsl     x1, x19, 3              // i * 8 (size of long long)
        add     x1, x20, x1             // &count[i]
        bl      scanf

        // Calculate prompt number for CPI: 3 + i * 2
        add     w22, w22, 1             // prompt number + 1

        // Print CPI prompt
        ldr     x0, =prompt_cpi
        mov     w1, w22                 // prompt number
        add     w2, w19, 1              // instruction type (i+1)
        mov     w3, w2                  // instruction type again
        bl      printf

        // Read cpi[i]
        ldr     x0, =fmt_double
        lsl     x1, x19, 3              // i * 8 (size of double)
        add     x1, x21, x1             // &cpi[i]
        bl      scanf

        // i++
        add     w19, w19, 1
        b       input_loop

input_done:
        // Compute: total_cycles = Σ(count[i] * cpi[i])
        fmov    d2, xzr                 // total_cycles = 0.0
        mov     w19, 0                  // i = 0

calc_loop:
        cmp     w19, 4
        b.ge    calc_done

        // Load count[i] and convert to double
        lsl     x9, x19, 3              // i * 8
        add     x10, x20, x9            // &count[i]
        ldr     x11, [x10]              // count[i]
        scvtf   d0, x11                 // convert to double

        // Load cpi[i]
        add     x10, x21, x9            // &cpi[i]
        ldr     d1, [x10]               // cpi[i]

        // Multiply and accumulate
        fmul    d0, d0, d1              // count[i] * cpi[i]
        fadd    d2, d2, d0              // total_cycles += count[i] * cpi[i]

        // i++
        add     w19, w19, 1
        b       calc_loop

calc_done:
        // exec_time = clock_time * total_cycles
        ldr     x9, =clock_time
        ldr     d0, [x9]                // d0 = clock_time
        fmul    d0, d0, d2              // d0 = exec_time

        // printf("The execution time ... %.6f second.\n", exec_time)
        ldr     x0, =out_fmt
        bl      printf

        // return 0
        mov     w0, 0
        ldp     x29, x30, [sp], 16
        ret

        .data
        .align 3

// Storage - using arrays like C version
clock_time:     .double 0.0
count:          .quad   0, 0, 0, 0      // Array of 4 long long values
cpi:            .double 0.0, 0.0, 0.0, 0.0  // Array of 4 double values

// Formats
fmt_double:     .asciz "%lf"
fmt_ll:         .asciz "%lld"
out_fmt:        .asciz "\nThe execution time of this software program is %.6f second.\n"

// Dynamic prompts using printf format strings
prompt_clk:     .asciz "1) The value of clock cycle time (in second): "
prompt_count:   .asciz "%d) The counts of Type %d instruction (Instruction%d_count): "
prompt_cpi:     .asciz "%d) The CPI of Type %d instruction (CPI_%d): "
