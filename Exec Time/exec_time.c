#include <stdio.h>

// ExecutionTime = ClockCycleTime * Σ(InstructionCount_i * CPI_i)
// Input: clock cycle time, instruction counts and CPIs for 4 instruction types
// Output: execution time in seconds

int main(void) {
    double t_clk;
    long long count[4];
    double cpi[4];

    // Helper macro to clear invalid input buffer
    #define CLEAR_INPUT() while (getchar() != '\n')

    // Get clock cycle time
    while (1) {
        printf("1) The value of clock cycle time (in second): ");
        if (scanf("%lf", &t_clk) == 1 && t_clk > 0)
            break;
        CLEAR_INPUT();
    }

    // Get counts and CPIs for 4 instruction types using for-loop
    for (int i = 0; i < 4; i++) {
        // instruction count
        while (1) {
            printf("%d) The counts of Type %d instruction (Instruction%d_count): ", 2 + i * 2, i + 1, i + 1);
            if (scanf("%lld", &count[i]) == 1 && count[i] >= 0)
                break;
            CLEAR_INPUT();
        }

        // CPI
        while (1) {
            printf("%d) The CPI of Type %d instruction (CPI_%d): ", 3 + i * 2, i + 1, i + 1);
            if (scanf("%lf", &cpi[i]) == 1 && cpi[i] >= 0)
                break;
            CLEAR_INPUT();
        }
    }

    // Compute execution time
    double total_cycles = 0;
    for (int i = 0; i < 4; i++) {
        total_cycles += count[i] * cpi[i];
    }

    double exec_time = t_clk * total_cycles;

    // Output result
    printf("\nThe execution time of this software program is %.6f second.\n", exec_time);

    return 0;
}