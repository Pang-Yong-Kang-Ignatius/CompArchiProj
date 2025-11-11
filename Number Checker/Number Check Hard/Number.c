#include <stdio.h>

int main() {
    int list[8];
    int size = 8;
    int target;
    int found = 0;

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

    // Check if any two numbers sum to the target
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

    // Display result
    if (found)
        printf("There are two numbers in the list summing to the keyed-in number %d\n", target);
    else
        printf("There are not two numbers in the list summing to the keyed-in number %d\n", target);

    return 0;
}
