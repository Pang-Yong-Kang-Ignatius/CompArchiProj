# Ask user to enter 8 valid integers
numbers = []
i = 0
while i < 8:
    num_str = input(f"Enter number {i + 1}: ")
    if num_str.lstrip('-').isdigit():     # check if input is a valid integer
        numbers.append(int(num_str))
        i += 1
    else:
        print("Invalid input! Please enter an integer.")

# Ask for target number
while True:
    target_str = input("Enter a number to check: ")
    if target_str.lstrip('-').isdigit():
        target = int(target_str)
        break
    else:
        print("Invalid input! Please enter an integer.")

found = False

# Check if any two numbers add up to the target
for i in range(len(numbers)):
    for j in range(i + 1, len(numbers)):
        if numbers[i] + numbers[j] == target:
            found = True
            break
    if found:
        break

# Print result
if found:
    print(f"There are two numbers in the list summing to the keyed-in number: {target}")
else:
    print(f"There are not two numbers in the list summing to the keyed-in number: {target}")
