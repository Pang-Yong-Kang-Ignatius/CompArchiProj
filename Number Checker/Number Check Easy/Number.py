import time  # For measuring execution time

# Fixed list of numbers
numbers = [1, 2, 4, 8, 16, 32, 64, 128]

# Ask for target number
target = int(input("Enter a number to check: "))
found = False
REPEAT = 1_000_000  # Number of repetitions for timing

# ✅ Start timing
start_time = time.time()

# Repeat the check multiple times for accurate timing
for _ in range(REPEAT):
    found = False
    for i in range(len(numbers)):
        for j in range(i + 1, len(numbers)):
            if numbers[i] + numbers[j] == target:
                found = True
                break
        if found:
            break

# ✅ End timing
end_time = time.time()

# Calculate total and average time
elapsed_time = end_time - start_time
avg_time = elapsed_time / REPEAT

# Print result
if found:
    print(f"There are two numbers in the list summing to the keyed-in number: {target}")
else:
    print(f"There are not two numbers in the list summing to the keyed-in number: {target}")

# Print total and average execution time
print(f"\nTotal execution time for {REPEAT} repetitions: {elapsed_time:.6f} seconds")
print(f"Average execution time per run: {avg_time:.9f} seconds")
