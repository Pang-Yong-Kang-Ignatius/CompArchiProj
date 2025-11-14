def get_integer_input(prompt): #make function for input validation
    
    #prompts the user for an integer and keeps re-prompting until valid input is given.

    while True: # loop indefinitely until valid input is received
        try:
            user_input = input(prompt)
            num = int(user_input) # Attempt to convert input to integer
            return num # if successful, return the integer and exit the loop
        except ValueError:
            # if fails, ask for retry
            print("Invalid input. Please enter a whole number.")

# validate input for each number
num1 = get_integer_input("Please input the first number: ")
num2 = get_integer_input("Please input the second number: ")
num3 = get_integer_input("Please input the third number: ")

#put all numbers in a list
numbers = [num1, num2, num3]

#use the built-in max() function
largest_num = max(numbers)

#output result
print(f'The largest number is {largest_num}')