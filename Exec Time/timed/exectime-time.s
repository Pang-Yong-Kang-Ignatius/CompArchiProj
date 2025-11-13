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
        // Start timing: call clock()
        bl      clock
        str     x0, [sp, #-16]!         // Save start_time on stack

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
        str     d0, [sp, #-16]!         // Save exec_time on stack

        // End timing: call clock()
        bl      clock
        mov     x22, x0                 // x22 = end_time

        // Calculate elapsed time: (end_time - start_time) / CLOCKS_PER_SEC
        ldr     x21, [sp, #16]          // Load start_time from stack
        sub     x23, x22, x21           // x23 = end_time - start_time
        scvtf   d3, x23                 // Convert to double
        ldr     x9, =clocks_per_sec
        ldr     d4, [x9]                // d4 = CLOCKS_PER_SEC
        fdiv    d3, d3, d4              // d3 = elapsed_time in seconds

        // Retrieve exec_time from stack
        ldr     d0, [sp], 16            // Pop exec_time
        add     sp, sp, 16              // Pop start_time

        // printf("The execution time ... %.6f second.\n", exec_time)
        ldr     x0, =out_fmt
        bl      printf

        // printf("\nActual execution time for calculation: %.9f seconds\n", elapsed_time)
        ldr     x0, =time_fmt
        fmov    d0, d3                  // Move elapsed_time to d0
        bl      printf

        // return 0
        mov     w0, 0
        ldp     x29, x30, [sp], 16
        ret

        .data
        .align 3

// Storage - using arrays 
clock_time:     .double 0.0
count:          .quad   0, 0, 0, 0      // Array of 4 long long values
cpi:            .double 0.0, 0.0, 0.0, 0.0  // Array of 4 double values
clocks_per_sec: .double 1000000.0       // CLOCKS_PER_SEC (typically 1000000)

// Formats
fmt_double:     .asciz "%lf"
fmt_ll:         .asciz "%lld"
out_fmt:        .asciz "\nThe execution time of this software program is %.6f second.\n"
time_fmt:       .asciz "\nActual execution time for calculation: %.9f seconds\n"

// Dynamic prompts using printf format strings
prompt_clk:     .asciz "1) The value of clock cycle time (in second): "
prompt_count:   .asciz "%d) The counts of Type %d instruction (Instruction%d_count): "
prompt_cpi:     .asciz "%d) The CPI of Type %d instruction (CPI_%d): "
