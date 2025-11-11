#include <stdio.h>
#include <stdlib.h>  // for malloc()

// ExecutionTime = ClockCycleTime * Σ(InstructionCount_i * CPI_i)
// Input: clock cycle time, instruction counts and CPIs for user-defined instruction types
// Output: execution time in seconds

int main(void) {
    double t_clk;
    int num_types;

    // Helper macro to clear invalid input buffer, clears garbage data
    #define CLEAR_INPUT() while (getchar() != '\n')

    // Get number of instruction types
    while (1) {
        printf("Enter the number of instruction types: ");
        if (scanf("%d", &num_types) == 1 && num_types > 0)
            break;
        printf("   Invalid input. Please enter a positive whole number.\n");
        CLEAR_INPUT();
    }

    // Dynamically allocate arrays
    long long *count = malloc(num_types * sizeof(long long));
    double *cpi = malloc(num_types * sizeof(double));

    if (count == NULL || cpi == NULL) {
        printf("Memory allocation failed.\n");
        return 1;
    }

    // Get clock cycle time
    while (1) {
        printf("1) The value of clock cycle time (in second): ");
        if (scanf("%lf", &t_clk) == 1 && t_clk > 0)
            break;
        printf("   Invalid input. Please enter a positive number.\n");
        CLEAR_INPUT();
    }

    // Get counts and CPIs for each instruction type using for-loop
    for (int i = 0; i < num_types; i++) {
        // Instruction count
        while (1) {
            printf("%d) The counts of Type %d instruction (Instruction%d_count): ",
                   2 + i * 2, i + 1, i + 1);
            if (scanf("%lld", &count[i]) == 1 && count[i] >= 0)
                break;
            printf("   Invalid input. Please enter a non-negative whole number.\n");
            CLEAR_INPUT();
        }

        // CPI
        while (1) {
            printf("%d) The CPI of Type %d instruction (CPI_%d): ",
                   3 + i * 2, i + 1, i + 1);
            if (scanf("%lf", &cpi[i]) == 1 && cpi[i] > 0)
                break;
            printf("   Invalid input. Please enter a positive number.\n");
            CLEAR_INPUT();
        }
    }

    // Compute total cycles
    double total_cycles = 0;
    for (int i = 0; i < num_types; i++) {
        total_cycles += count[i] * cpi[i];
    }

    // Compute execution time
    double exec_time = t_clk * total_cycles;

    // Display result
    printf("\n-------------------------------------------\n");
    printf("The execution time of this software program is %.6f seconds.\n", exec_time);
    printf("-------------------------------------------\n");

    // Free dynamically allocated memory
    free(count);
    free(cpi);

    return 0;
}
