import time  # Import time module to measure execution time

# Ask user to enter 8 valid integers
numbers = []  # List to store the user's numbers
i = 0  # Counter to track the number of inputs
while i < 8:
    num_str = input(f"Enter number {i + 1}: ")  # Prompt user to enter a number
    if num_str.lstrip('-').isdigit():  # Check if the input is a valid integer (allowing for negative numbers)
        numbers.append(int(num_str))  # Convert the input to an integer and append it to the list
        i += 1  # Increment the counter
    else:
        print("Invalid input! Please enter an integer.")  # Inform user if input is invalid

# Ask for target number
while True:  # Repeat until a valid integer is entered for the target
    target_str = input("Enter a number to check: ")  # Prompt user to enter the target
    if target_str.lstrip('-').isdigit():  # Check if the input is a valid integer (allowing for negative numbers)
        target = int(target_str)  # Convert input to an integer
        break  # Exit the loop if input is valid
    else:
        print("Invalid input! Please enter an integer.")  # Inform user if input is invalid

found = False  # Variable to track if a pair is found
REPEAT = 1_000_000  # Repeat the process 1 million times for accurate timing

# ✅ Start timing only for the checking process
start_time = time.perf_counter()  # Record the start time for the check process

# Perform the pair-checking process REPEAT times
for _ in range(REPEAT):
    found = False  # Reset the found flag for each repetition
    for i in range(len(numbers)):  # Loop over the first number in the list
        for j in range(i + 1, len(numbers)):  # Loop over the second number in the list (after the first)
            if numbers[i] + numbers[j] == target:  
                found = True  
                break  
        if found:  
            break

# ✅ Stop timing
end_time = time.perf_counter()  # Record the end time for the check process

# Calculate total and average execution times
elapsed_time = end_time - start_time  # Total time for REPEAT iterations
avg_time = elapsed_time / REPEAT  # Average time per repetition

# Print the result of the Two Number Sum Check
if found:
    print(f"There are two numbers in the list summing to the keyed-in number: {target}")
else:
    print(f"There are not two numbers in the list summing to the keyed-in number: {target}")

# Print execution time statistics
print(f"\nTotal execution time for {REPEAT:,} repetitions: {elapsed_time:.6f} seconds")
print(f"Average execution time per run: {avg_time:.9f} seconds")
