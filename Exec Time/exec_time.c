#include <stdio.h>

#define MAX_TYPES 10  // Maximum number of instruction types allowed

// Function prototype
double calculate_exec_time(double t_clk, long long count[], double cpi[], int num_types);

int main(void) {
    int num_types;
    double t_clk;
    long long count[MAX_TYPES];
    double cpi[MAX_TYPES];
    double exec_time = 0.0;

    // Get number of instruction types (must be between 1 and MAX_TYPES)
    while (1) {
        printf("Enter the number of instruction types (1-%d): ", MAX_TYPES);
        if (scanf("%d", &num_types) == 1 && num_types >= 1 && num_types <= MAX_TYPES) {
            break;
        } else {
            printf("   Invalid. Please enter a number between 1 and %d.\n", MAX_TYPES);
            while (getchar() != '\n');
        }
    }

    // Get clock cycle time (must be > 0)
    while (1) {
        printf("Enter the value of clock cycle time (in second): ");
        if (scanf("%lf", &t_clk) == 1 && t_clk > 0) {
            break;
        } else {
            printf("   Invalid. Please enter a positive number.\n");
            
            while (getchar() != '\n');
        }
    }

    // Get counts and CPIs for each instruction type
    for (int i = 0; i < num_types; i++) {

        // count (must be >= 0)
        while (1) {
            printf("Enter the count of Type %d instruction: ", i + 1);
            if (scanf("%lld", &count[i]) == 1 && count[i] >= 0) {
                break;
            } else {
                printf("   Invalid. Please enter a non-negative whole number.\n");
                while (getchar() != '\n');
            }
        }

        // cpi (must be > 0)
        while (1) {
            printf("Enter the CPI of Type %d instruction: ", i + 1);
            if (scanf("%lf", &cpi[i]) == 1 && cpi[i] > 0) {
                break;
            } else {
                printf("   Invalid. Please enter a positive number.\n");
                while (getchar() != '\n');
            }
        }
    }

    // Calculate execution time using the function 
    // Formula: ExecutionTime = ClockCycleTime * Σ(InstructionCount_i * CPI_i)
    exec_time = calculate_exec_time(t_clk, count, cpi, num_types);

    // Output result
    printf("\n-------------------------------------------\n");
    printf("The execution time of this program is %.6f seconds.\n", exec_time);
    printf("-------------------------------------------\n");

    return 0;
}

// Function to calculate execution time
double calculate_exec_time(double t_clk, long long count[], double cpi[], int num_types) {
    double total_cycles = 0.0;
    
    // Compute total cycles
    for (int i = 0; i < num_types; i++) {
        total_cycles += count[i] * cpi[i];
    }
    
    // Return execution time
    return t_clk * total_cycles;
}