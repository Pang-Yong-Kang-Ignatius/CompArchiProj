
        .text
        .global main

main:
        // Prologue
        stp     x29, x30, [sp, -16]!
        mov     x29, sp

        // 1) clock cycle time (double)
        ldr     x0, =prompt_clk
        bl      printf
        ldr     x0, =fmt_double
        ldr     x1, =clock_time
        bl      scanf

        // 2) count type 1 (long long)
        ldr     x0, =prompt_c1
        bl      printf
        ldr     x0, =fmt_ll
        ldr     x1, =c1
        bl      scanf
        // 3) cpi1 (double)
        ldr     x0, =prompt_cpi1
        bl      printf
        ldr     x0, =fmt_double
        ldr     x1, =cpi1
        bl      scanf

        // 4) count type 2
        ldr     x0, =prompt_c2
        bl      printf
        ldr     x0, =fmt_ll
        ldr     x1, =c2
        bl      scanf
        // 5) cpi2
        ldr     x0, =prompt_cpi2
        bl      printf
        ldr     x0, =fmt_double
        ldr     x1, =cpi2
        bl      scanf

        // 6) count type 3
        ldr     x0, =prompt_c3
        bl      printf
        ldr     x0, =fmt_ll
        ldr     x1, =c3
        bl      scanf
        // 7) cpi3
        ldr     x0, =prompt_cpi3
        bl      printf
        ldr     x0, =fmt_double
        ldr     x1, =cpi3
        bl      scanf

        // 8) count type 4
        ldr     x0, =prompt_c4
        bl      printf
        ldr     x0, =fmt_ll
        ldr     x1, =c4
        bl      scanf
        // 9) cpi4
        ldr     x0, =prompt_cpi4
        bl      printf
        ldr     x0, =fmt_double
        ldr     x1, =cpi4
        bl      scanf

        // Compute: total_cycles = c1*cpi1 + c2*cpi2 + c3*cpi3 + c4*cpi4  (all in FP)
        // d2 <- c1*cpi1
        ldr     x9, =c1
        ldr     x10, [x9]
        scvtf   d0, x10
        ldr     x9, =cpi1
        ldr     d1, [x9]
        fmul    d2, d0, d1

        // + c2*cpi2
        ldr     x9, =c2
        ldr     x10, [x9]
        scvtf   d0, x10
        ldr     x9, =cpi2
        ldr     d1, [x9]
        fmul    d0, d0, d1
        fadd    d2, d2, d0

        // + c3*cpi3
        ldr     x9, =c3
        ldr     x10, [x9]
        scvtf   d0, x10
        ldr     x9, =cpi3
        ldr     d1, [x9]
        fmul    d0, d0, d1
        fadd    d2, d2, d0

        // + c4*cpi4
        ldr     x9, =c4
        ldr     x10, [x9]
        scvtf   d0, x10
        ldr     x9, =cpi4
        ldr     d1, [x9]
        fmul    d0, d0, d1
        fadd    d2, d2, d0        // d2 = total_cycles

        // exec_time = t_clk * total_cycles
        ldr     x9, =clock_time
        ldr     d0, [x9]          // d0 = t_clk
        fmul    d0, d0, d2        // d0 = exec_time

        // printf("The execution time ... %.6f second.\n", exec_time)
        ldr     x0, =out_fmt
        bl      printf

        // return 0
        mov     w0, 0
        ldp     x29, x30, [sp], 16
        ret

        .data
        .align 3

// Storage
clock_time:     .double 0.0
c1:             .quad   0
c2:             .quad   0
c3:             .quad   0
c4:             .quad   0
cpi1:           .double 0.0
cpi2:           .double 0.0
cpi3:           .double 0.0
cpi4:           .double 0.0

// Formats
fmt_double:     .asciz "%lf"
fmt_ll:         .asciz "%lld"
out_fmt:        .asciz "The execution time of this software program is %.6f second.\n"

// Prompts (each ends with newline for safe flushing)
prompt_clk: .asciz "1) The value of clock cycle time (in second): "
prompt_c1:  .asciz "2) The counts of Type 1 instruction (Instruction1_count): "
prompt_cpi1:.asciz "3) The CPI of Type 1 instruction (CPI_1): "
prompt_c2:  .asciz "4) The counts of Type 2 instruction (Instruction2_count): "
prompt_cpi2:.asciz "5) The CPI of Type 2 instruction (CPI_2): "
prompt_c3:  .asciz "6) The counts of Type 3 instruction (Instruction3_count): "
prompt_cpi3:.asciz "7) The CPI of Type 3 instruction (CPI_3): "
prompt_c4:  .asciz "8) The counts of Type 4 instruction (Instruction4_count): "
prompt_cpi4:.asciz "9) The CPI of Type 4 instruction (CPI_4): "
