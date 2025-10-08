#include <stdio.h>

int main() {
    int list[8];
    int size = 8;
    int target;
    int found = 0;

    printf("Enter 8 numbers:\n");
    for (int i = 0; i < size; i++) {
        printf("Enter number %d: ", i + 1);
        scanf("%d", &list[i]);
    }

    printf("Enter a number: ");
    scanf("%d", &target);

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

    if (found)
        printf("There are two numbers that add up to %d\n", target);
    else
        printf("c %d\n", target);

    return 0;
}
