import time

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
REPEAT = 1_000_000   # repeat one million times for accurate timing

# ✅ Start timing only for the checking process
start_time = time.perf_counter()

for _ in range(REPEAT):
    found = False
    for i in range(len(numbers)):
        for j in range(i + 1, len(numbers)):
            if numbers[i] + numbers[j] == target:
                found = True
                break
        if found:
            break

# ✅ Stop timing
end_time = time.perf_counter()

# Calculate total and average execution times
elapsed_time = end_time - start_time
avg_time = elapsed_time / REPEAT

# Print result
if found:
    print(f"There are two numbers in the list summing to the keyed-in number: {target}")
else:
    print(f"There are not two numbers in the list summing to the keyed-in number: {target}")

print(f"\nTotal execution time for {REPEAT:,} repetitions: {elapsed_time:.6f} seconds")
print(f"Average execution time per run: {avg_time:.9f} seconds")
