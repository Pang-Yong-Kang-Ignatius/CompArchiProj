# Program to calculate the execution time of a software program
# Formula: ExecutionTime = ClockCycleTime * Σ(InstructionCount_i * CPI_i)

NUM_INSTR_TYPES = 4

# Get clock cycle time with basic validation
while True:
    try:
        t_clk = float(input("1) Enter the value of clock cycle time (in seconds): "))
        if t_clk > 0:
            break
        else:
            print("   Please enter a positive number.")
    except ValueError:
        print("   Invalid input. Please enter a valid number.")

# Initialize total cycles
total_cycles = 0

# Loop for each instruction type
for i in range(1, NUM_INSTR_TYPES + 1):
    # Instruction count
    while True:
        try:
            count = int(input(f"{2 + (i - 1) * 2}) Enter the count of Type {i} instruction: "))
            if count >= 0:
                break
            else:
                print("   Please enter a non-negative integer.")
        except ValueError:
            print("   Invalid input. Please enter a whole number.")
    
    # CPI value
    while True:
        try:
            cpi = float(input(f"{3 + (i - 1) * 2}) Enter the CPI of Type {i} instruction: "))
            if cpi > 0:
                break
            else:
                print("   Please enter a positive number.")
        except ValueError:
            print("   Invalid input. Please enter a valid number.")

    # Add to total cycles
    total_cycles = total_cycles + (count * cpi)

# Calculate execution time
exec_time = t_clk * total_cycles

# Display result
print("\n-------------------------------------")
print(f"The execution time of this program is {exec_time:.6f} seconds.")
print("-------------------------------------")
