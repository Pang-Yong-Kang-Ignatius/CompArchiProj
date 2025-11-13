# Program to calculate the execution time of a software program
# Formula: ExecutionTime = ClockCycleTime * Σ(InstructionCount_i * CPI_i)

import time  # For measuring execution time

MAX_TYPES = 10  # Maximum number of instruction types allowed


# Function to calculate execution time
def calculate_exec_time(t_clk, count, cpi, num_types):
    total_cycles = 0.0
    
    # Compute total cycles
    for i in range(num_types):
        total_cycles += count[i] * cpi[i]
    
    # Return execution time
    return t_clk * total_cycles


def main():
    # Get number of instruction types (must be between 1 and MAX_TYPES)
    while True:
        try:
            num_types = int(input(f"Enter the number of instruction types (1-{MAX_TYPES}): "))
            if 1 <= num_types <= MAX_TYPES:
                break
            else:
                print(f"   Invalid. Please enter a number between 1 and {MAX_TYPES}.")
        except ValueError:
            print(f"   Invalid. Please enter a number between 1 and {MAX_TYPES}.")

    # Get clock cycle time (must be > 0)
    while True:
        try:
            t_clk = float(input("Enter the value of clock cycle time (in second): "))
            if t_clk > 0:
                break
            else:
                print("   Invalid. Please enter a positive number.")
        except ValueError:
            print("   Invalid. Please enter a positive number.")

    # Initialize arrays
    count = []
    cpi = []

    # Get counts and CPIs for each instruction type
    for i in range(num_types):
        # count (must be >= 0)
        while True:
            try:
                c = int(input(f"Enter the count of Type {i + 1} instruction: "))
                if c >= 0:
                    count.append(c)
                    break
                else:
                    print("   Invalid. Please enter a non-negative whole number.")
            except ValueError:
                print("   Invalid. Please enter a non-negative whole number.")
        
        # cpi (must be > 0)
        while True:
            try:
                cp = float(input(f"Enter the CPI of Type {i + 1} instruction: "))
                if cp > 0:
                    cpi.append(cp)
                    break
                else:
                    print("   Invalid. Please enter a positive number.")
            except ValueError:
                print("   Invalid. Please enter a positive number.")

    # Start timing the calculation
    start_time = time.time()
    
    # Calculate execution time using the function
    exec_time = calculate_exec_time(t_clk, count, cpi, num_types)
    
    # End timing the calculation
    end_time = time.time()
    
    # Calculate elapsed time
    elapsed_time = end_time - start_time

    # Output result
    print("\n-------------------------------------------")
    print(f"The execution time of this program is {exec_time:.6f} seconds.")
    print("-------------------------------------------")
    
    # Print actual runtime of the calculation
    print(f"\nActual execution time for calculation: {elapsed_time:.9f} seconds")


if __name__ == "__main__":
    main()