#include <stdio.h>

int main(void) {
    const int NUM_TYPES = 4;
    double t_clk;
    long long count[4];
    double cpi[4];
    double total_cycles = 0.0, exec_time = 0.0;

    // Get clock cycle time (must be > 0)
    while (1) {
        printf("1) Enter the value of clock cycle time (in second): ");
        if (scanf("%lf", &t_clk) == 1 && t_clk > 0) {
            break;
        } else {
            printf("   Invalid. Please enter a positive number.\n");
            // clear invalid input
            while (getchar() != '\n');
        }
    }

    // Get counts and CPIs for 4 instruction types
    for (int i = 0; i < NUM_TYPES; i++) {

        // count (must be >= 0)
        while (1) {
            printf("%d) Enter the count of Type %d instruction: ", 2 + i * 2, i + 1);
            if (scanf("%lld", &count[i]) == 1 && count[i] >= 0) {
                break;
            } else {
                printf("   Invalid. Please enter a non-negative whole number.\n");
                while (getchar() != '\n');
            }
        }

        // cpi (must be > 0)
        while (1) {
            printf("%d) Enter the CPI of Type %d instruction: ", 3 + i * 2, i + 1);
            if (scanf("%lf", &cpi[i]) == 1 && cpi[i] > 0) {
                break;
            } else {
                printf("   Invalid. Please enter a positive number.\n");
                while (getchar() != '\n');
            }
        }
    }

    // Compute total cycles
    for (int i = 0; i < NUM_TYPES; i++) {
        total_cycles = total_cycles + (count[i] * cpi[i]);
    }

    // Execution time
    exec_time = t_clk * total_cycles;

    // Output result
    printf("\n-------------------------------------------\n");
    printf("The execution time of this program is %.6f seconds.\n", exec_time);
    printf("-------------------------------------------\n");

    return 0;
}
