# Input validation for the first number
while True:
    try:
        num1_str = input("Please input first number: ")
        num1 = int(num1_str)
        break  # Exit the loop if input is valid
    except ValueError:
        print("Invalid input. Please enter an integer.")

# Input validation for the second number
while True:
    try:
        num2_str = input("Please input second number: ")
        num2 = int(num2_str)
        break  # Exit the loop if input is valid
    except ValueError:
        print("Invalid input. Please enter an integer.")

# Input validation for the third number
while True:
    try:
        num3_str = input("Please input third number: ")
        num3 = int(num3_str)
        break  # Exit the loop if input is valid
    except ValueError:
        print("Invalid input. Please enter an integer.")


largest = [num1, num2, num3]  # Now all numbers in this list are guaranteed to be integers

# Your original logic for finding the largest number
largest_num = num1 # Initialize with the first number

for n in largest:
    if n >= largest_num: # Compare with current largest_num, not max(largest) every time
        largest_num = n

print(f'The largest number is {largest_num}')