# Ask user to enter 8 numbers
numbers = [1, 2, 4, 8, 16, 32, 64, 128]


# Ask for target number
target = int(input("Enter a number to check: "))
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
