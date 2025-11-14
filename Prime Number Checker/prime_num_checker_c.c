#include <stdio.h>
#include <math.h> 

void prime_check(int x);

int main(){
    /*initialise values*/
    int x;
    char term; // To catch non-integer input

    /*ask for input with validation*/
    do {
        printf("Please input a positive integer: ");
        // Try to read an integer. scanf returns the number of items successfully read.
        // It also leaves non-matching characters in the input buffer.
        if (scanf("%d%c", &x, &term) != 2 || term != '\n' || x <= 0) {
            printf("Invalid input. Please enter a positive integer.\n");
            // Clear the input buffer in case of invalid input
            // (e.g., if the user typed "abc" or "123a")
            if (term != '\n') { // Only clear if there's something to clear besides the newline
                while (getchar() != '\n');
            }
        } else {
            // Valid input received, break the loop
            break;
        }
    } while (1); // Loop indefinitely until valid input causes a 'break'
    
    /*computation*/
    prime_check(x);
    
    /*output*/
    return 0;
}

void prime_check(int x)
{
    // Handle special cases first
    if (x <= 1) {
        printf("%d is not a prime number.\n", x);
    } else if (x == 2) {
        printf("%d is a prime number.\n", x);
    } else if (x % 2 == 0) { // All even numbers greater than 2 are not prime
        printf("%d is not a prime number.\n", x);
    } else {
        // Only check odd divisors up to the square root of x
        int is_prime = 1; // Assume it's prime until a divisor is found
        for (int i = 3; (long long)i * i <= x; i += 2) { // Use long long for i*i to prevent overflow
            if (x % i == 0) {
                is_prime = 0; // Found a divisor, so it's not prime
                break; // No need to check further
            }
        }

        if (is_prime) {
            printf("%d is a prime number.\n", x);
        } else {
            printf("%d is not a prime number.\n", x);
        }
    }
}