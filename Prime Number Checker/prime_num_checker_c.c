#include <stdio.h>
#include <math.h>

void prime_check(int x);

int main(){
    /*initialise values*/
    int x;
    /*ask for input*/   
    printf("please input a number: ");
    scanf("%d", &x);
    
    /*computation*/
    prime_check(x);
    
    /*output*/
    return 0;
};

void prime_check(int x)
{
    int xyz = 0; 

    /* if input is 1 OR greater than 2 AND remainder of input mod 2 is equal to 0*/
    /* then input is a prime number*/
    if (x <= 1 || ((x > 2) && (x%2 == 0)))
        printf("%d is a not prime number", x);
    else
        if (x==2)
        {
            printf("%d is a prime number", x);
        }
        else{

            for (int i = 3; i * i <= x; i+=2) /*finding the */
            {
                if (x == 0)
                    xyz++;
            }
             if (xyz > 0)
            {
                printf("%d is not prime number", x);
            }
            else
            {
                printf("%d is prime number", x);
            }
        }

}

