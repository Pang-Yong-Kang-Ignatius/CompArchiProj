#include <stdio.h>

// ExecutionTime = ClockCycleTime * Σ(InstructionCount_i * CPI_i)
// inputs are clock cycle time, instruction counts and CPIs for 4 types of instructions
// output is execution time in seconds

int main(void) {
    double t_clk, cpi1, cpi2, cpi3, cpi4;
    long long c1, c2, c3, c4;

    printf("1) The value of clock cycle time (in second): ");
    if (scanf("%lf", &t_clk) != 1) return 1;

    printf("2) The counts of Type 1 instruction (Instruction1_count): ");
    if (scanf("%lld", &c1) != 1) return 1;
    printf("3) The CPI of Type 1 instruction (CPI_1): ");
    if (scanf("%lf", &cpi1) != 1) return 1;

    printf("4) The counts of Type 2 instruction (Instruction2_count): ");
    if (scanf("%lld", &c2) != 1) return 1;
    printf("5) The CPI of Type 2 instruction (CPI_2): ");
    if (scanf("%lf", &cpi2) != 1) return 1;

    printf("6) The counts of Type 3 instruction (Instruction3_count): ");
    if (scanf("%lld", &c3) != 1) return 1;
    printf("7) The CPI of Type 3 instruction (CPI_3): ");
    if (scanf("%lf", &cpi3) != 1) return 1;

    printf("8) The counts of Type 4 instruction (Instruction4_count): ");
    if (scanf("%lld", &c4) != 1) return 1;
    printf("9) The CPI of Type 4 instruction (CPI_4): ");
    if (scanf("%lf", &cpi4) != 1) return 1;

    double total_cycles = c1*cpi1 + c2*cpi2 + c3*cpi3 + c4*cpi4;
    double exec_time = t_clk * total_cycles;

    printf("The execution time of this software program is %.6f second.\n", exec_time);
    return 0;
}
