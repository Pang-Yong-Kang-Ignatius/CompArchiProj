#include <stdio.h>

void largest(int a, int b, int c);
int main() {

    int nums[3];  // array to store 3 numbers

    /* Ask for input using a for loop */
    for (int i = 0; i < 3; i++) {
        printf("Enter number %d: ", i + 1);
        scanf("%d", &nums[i]);
    }

    /* Call the function to find and print the largest number */
    largest(nums[0], nums[1], nums[2]);

    return 0;
}
void largest(int a, int b, int c) {
    int largest;

    /* Determine the largest number */
    if (a >= b && a >= c) {
        largest = a;
    } else if (b >= a && b >= c) {
        largest = b;
    } else {
        largest = c;
    }

    /* Output the result */
    printf("The largest number is: %d\n", largest);
}