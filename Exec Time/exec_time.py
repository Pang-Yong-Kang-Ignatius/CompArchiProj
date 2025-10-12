# ExecutionTime = ClockCycleTime * Σ(InstructionCount_i * CPI_i)
# Input: clock cycle time, instruction counts and CPIs for 4 instruction types
# Output: execution time in seconds

NUM_INSTR_TYPES = 4


def get_positive_float(prompt):
    """Get a positive float from user with validation."""
    while True:
        try:
            value = float(input(prompt))
            if value > 0:
                return value
        except ValueError:
            continue


def get_non_negative_int(prompt):
    """Get a non-negative integer from user with validation."""
    while True:
        try:
            value = int(input(prompt))
            if value >= 0:
                return value
        except ValueError:
            continue


def get_instruction_metrics(num_types):
    """Collect instruction counts and CPIs for all instruction types.
    
    Args:
        num_types: Number of instruction types to collect data for
        
    Returns:
        tuple: (counts, cpis) - lists of instruction counts and CPI values
    """
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
    """Calculate total execution time.
    
    Args:
        clock_time: Clock cycle time in seconds
        counts: List of instruction counts
        cpis: List of CPI values
        
    Returns:
        float: Execution time in seconds
    """
    total_cycles = sum(count * cpi for count, cpi in zip(counts, cpis))
    return clock_time * total_cycles


def main():
    """Calculate and display execution time based on instruction metrics."""
    # Get clock cycle time
    t_clk = get_positive_float("1) The value of clock cycle time (in second): ")
    
    # Get instruction counts and CPIs
    counts, cpis = get_instruction_metrics(NUM_INSTR_TYPES)
    
    # Calculate execution time
    exec_time = calculate_execution_time(t_clk, counts, cpis)
    
    # Display result
    print(f"\nThe execution time of this software program is {exec_time:.6f} second.")

if __name__ == "__main__":
    main()
