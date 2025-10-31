#include <stdio.h>

int main() {
    int list[] = {1,2,4,8,16,32,64,128};
    int size = 8;
    int target;
    int found = 0;

    printf("Enter a number to check: ");
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
        printf("There are two numbers in the list summing to the keyed-in number %d\n", target);
    else
        printf("There are not two numbers in the list summing to the keyed-in number %d\n", target);

    return 0;
}
