#loop to check if input is valid integer
while True:
    try:
        num_str = input('Please input a number: ')
        num = int(num_str) #only accept integer input
        break # Exit the loop if input is a valid integer
    except ValueError:
        print("Invalid input. Please enter an integer.") #if not integer, ask user again for input
#loops until valid integer is input, then breaks out of loop


#calculating square root of number
s = int(num**.5) #converting float (sqrt of num) to integer (s) for range function

if num > 1: #checking if number is either 1 or greater than 1
    for i in range(2, s+1): #iterate loop for factors from 2 to s+1
        if (num % i) == 0: #checks for each factor
            print(f'{num} is not a prime number')
            break
    else:
        print(f'{num} is a prime number')
else:
    print(f'{num} is not a prime number') #output if equal to 1