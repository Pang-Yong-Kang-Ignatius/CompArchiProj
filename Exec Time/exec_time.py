# ExecutionTime = ClockCycleTime * Σ(InstructionCount_i * CPI_i)

def ask_float(prompt):
    return float(input(prompt))

def ask_int(prompt):
    return int(input(prompt))

t_clk = ask_float("1) The value of clock cycle time (in second): ")

c1 = ask_int("2) The counts of Type 1 instruction (Instruction1_count): ")
cpi1 = ask_float("3) The CPI of Type 1 instruction (CPI_1): ")

c2 = ask_int("4) The counts of Type 2 instruction (Instruction2_count): ")
cpi2 = ask_float("5) The CPI of Type 2 instruction (CPI_2): ")

c3 = ask_int("6) The counts of Type 3 instruction (Instruction3_count): ")
cpi3 = ask_float("7) The CPI of Type 3 instruction (CPI_3): ")

c4 = ask_int("8) The counts of Type 4 instruction (Instruction4_count): ")
cpi4 = ask_float("9) The CPI of Type 4 instruction (CPI_4): ")

total_cycles = c1*cpi1 + c2*cpi2 + c3*cpi3 + c4*cpi4
exec_time = t_clk * total_cycles

print(f"The execution time of this software program is {exec_time:.6f} second.")
