# ExecutionTime = ClockCycleTime * Σ(InstructionCount_i * CPI_i)
# Input: clock cycle time, instruction counts and CPIs for N instruction types
# Output: execution time in seconds


def get_positive_float(prompt):
    """Get a positive float from user with validation."""
    while True:
        try:
            value = float(input(prompt))
            if value > 0:
                return value
            else:
                print("   Please enter a positive number.")
        except ValueError:
            print("   Invalid input. Please enter a valid number.")


def get_non_negative_int(prompt):
    """Get a non-negative integer from user with validation."""
    while True:
        try:
            value = int(input(prompt))
            if value >= 0:
                return value
            else:
                print("   Please enter a non-negative integer.")
        except ValueError:
            print("   Invalid input. Please enter a whole number.")


def get_instruction_metrics(num_types):
    """Collect instruction counts and CPIs for all instruction types."""
    counts = []
    cpis = []
    
    for i in range(num_types):
        count = get_non_negative_int(
            f"{2 + i * 2}) The counts of Type {i + 1} instruction (Instruction{i + 1}_count): "
        )
        counts.append(count)
        
        cpi = get_positive_float(
            f"{3 + i * 2}) The CPI of Type {i + 1} instruction (CPI_{i + 1}): "
        )
        cpis.append(cpi)
    
    return counts, cpis


def calculate_execution_time(clock_time, counts, cpis):
    """Calculate total execution time."""
    total_cycles = sum(count * cpi for count, cpi in zip(counts, cpis))
    return clock_time * total_cycles


def main():
    """Calculate and display execution time based on instruction metrics."""
    print("CSC1104 – Execution Time Calculator\n")

    # Ask user how many instruction types
    while True:
        try:
            num_types = int(input("Enter the number of instruction types: "))
            if num_types > 0:
                break
            else:
                print("   Please enter a positive integer.")
        except ValueError:
            print("   Invalid input. Please enter a whole number.")

    # Get clock cycle time
    t_clk = get_positive_float("1) The value of clock cycle time (in second): ")

    # Get instruction counts and CPIs
    counts, cpis = get_instruction_metrics(num_types)

    # Calculate execution time
    exec_time = calculate_execution_time(t_clk, counts, cpis)

    # Display result
    print("\n-------------------------------------------")
    print(f"The execution time of this software program is {exec_time:.6f} second.")
    print("-------------------------------------------")


if __name__ == "__main__":
    main()
