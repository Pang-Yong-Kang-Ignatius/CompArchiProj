while True:
    try:
        num_str = input('Please input a number: ')
        num = int(num_str)
        break # Exit the loop if input is a valid integer
    except ValueError:
        print("Invalid input. Please enter an integer.")

s = int(num**.5) #converting float to integer for range function

if num > 1: #checking if number is either 1 or greater than 1
    for i in range(2, s+1): #checks for factors from 2 to s+1
        if (num % i) == 0: #checks for each factor
            print(f'{num} is not a prime number')
            break
    else:
        print(f'{num} is a prime number')
else:
    print(f'{num} is not a prime number') #output if equal to 1