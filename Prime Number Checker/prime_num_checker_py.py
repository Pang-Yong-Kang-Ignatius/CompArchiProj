
print('Please input a number: ')
num = int(input()) #user input

s = int(num**.5) #converting float to integer for range function

if num > 1: #checking if number is either 1 or greater than 1
    for i in range(2, s+1): #checks for factors from 2 to num-1
        if (num % i) == 0: #checks for each factor
            print(f'{num} is not a prime number')
            break
    else:
        print(f'{num} is a prime number')
else:
    print(f'{num} is not a prime number') #output if equal to 1
    