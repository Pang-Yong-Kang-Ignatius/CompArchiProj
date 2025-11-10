#include <stdio.h>
#include <time.h>   // for clock()

int main() {
    int list[8];
    int size = 8;
    int target;
    int found = 0;
    clock_t start_time, end_time;
    double elapsed_time;
    const int REPEAT = 1000000; // number of repetitions for timing

    printf("Enter 8 numbers:\n");
    for (int i = 0; i < size; i++) {
        while (1) {
            printf("Enter number %d: ", i + 1);
            if (scanf("%d", &list[i]) == 1) {
                break;
            } else {
                printf("Invalid input! Please enter an integer.\n");
                while (getchar() != '\n'); // clear invalid input
            }
        }
    }

    while (1) {
        printf("Enter a number to check: ");
        if (scanf("%d", &target) == 1) {
            break;
        } else {
            printf("Invalid input! Please enter an integer.\n");
            while (getchar() != '\n');
        }
    }

    // ✅ Start timing just before the repeated test loop
    start_time = clock();

    for (int r = 0; r < REPEAT; r++) {
        found = 0;
        for (int i = 0; i < size; i++) {
            for (int j = i + 1; j < size; j++) {
                if (list[i] + list[j] == target) {
                    found = 1;
                    break;
                }
            }
            if (found)
                break;
        }
    }

    // ✅ End timing
    end_time = clock();

    // Calculate total and average time
    elapsed_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
    double avg_time = elapsed_time / REPEAT;

    // Show logical output
    if (found)
        printf("There are two numbers in the list summing to the keyed-in number %d\n", target);
    else
        printf("There are not two numbers in the list summing to the keyed-in number %d\n", target);

    // Print total and average execution time
    printf("\nTotal execution time for %d repetitions: %.6f seconds\n", REPEAT, elapsed_time);
    printf("Average execution time per run: %.9f seconds\n", avg_time);

    return 0;
}
