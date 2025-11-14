#include <stdio.h>

void largest(int a, int b, int c);

int main() {
    int num1, num2, num3;
    char term; // empty variable to catch non-integer input and newline characters

    /* input three numbers from the user with validation */
    do {
        printf("Enter three integers: ");
        // try to read three integers and the subsequent character (should be newline)
        if (scanf("%d %d %d%c", &num1, &num2, &num3, &term) != 4 || term != '\n') {
            printf("Invalid input. Please enter three integers separated by spaces.\n");
            // clear the input buffer
            if (term != '\n') { // only clear if there's something to clear besides the newline
                while (getchar() != '\n');
            }
        } else {
            // valid input received, break loop
            break;
        }
    } while (1); // loop indefinitely until valid input causes a 'break'

    largest(num1, num2, num3);

    return 0;
}

void largest(int a, int b, int c) {
    int largest_num; // new variable to store the largest number after each comparison

    /* determine largest number */
    if (a >= b && a >= c) {
        largest_num = a;
    } else if (b >= a && b >= c) {
        largest_num = b;
    } else {
        largest_num = c;
    }

    /* output the result */
    printf("The largest number is: %d\n", largest_num);
}