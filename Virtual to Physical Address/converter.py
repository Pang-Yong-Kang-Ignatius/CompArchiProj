import time

#array list for page table
Process_A = [ 
    9,      # Page 0
    1,      # Page 1
    14,     # Page 2
    10,     # Page 3
    -1,     # Page 4
    13,     # Page 5
    8,      # Page 6
    15,     # Page 7
    -1,     # Page 8
    30,     # Page 9
    18,     # Page 10
    -1,     # Page 11
    21,     # Page 12
    27,     # Page 13
    -1,     # Page 14
    22,     # Page 15
    29,     # Page 16
    -1,     # Page 17
    19,     # Page 18
    26,     # Page 19
    17,     # Page 20
    25,     # Page 21
    -1,     # Page 22
    31,     # Page 23
    20,     # Page 24
    0,      # Page 25
    5,      # Page 26
    4,      # Page 27
    -1,     # Page 28
    -1,     # Page 29    
    3,      # Page 30
    2       # Page 31
]
print("========================================= Convert Virtual Address to Physical Address Python =========================================")

while True:
    binary1 = input("Enter virtual memory page number (5 bits):")

    if all(char in '01' for char in binary1):
        decimal1 = int(binary1, 2) #converts binary to decimal
        if decimal1 <= 31:
            break  # stop the loop after valid conversion
        else:
            print("Input a valid binary that is less than or equals to 31.\n")
    else:
        print("Please enter a valid binary number (only 0s and 1s allowed).\n")
    

while True:
    binary2 = input("Enter virtual page offset number (8 bits): ")
    if all(char in '01' for char in binary2):
        decimal2 = int(binary2, 2)#converts binary to decimal
        if decimal2 <= 255:
            break  # stop the loop after valid conversion
        else:
            print("Input a valid binary that is less than or equals to 255.\n")
    else:
        print("Please enter a valid binary number (only 0s and 1s allowed).\n")

start_time = time.perf_counter()
binary2 = format(decimal2, '08b') #converts decimal to binary
grouped_binary2 = binary2[:4] + ' ' + binary2[4:] 

print("========================================================== Results ============================================================")

pageno = decimal1
pagenoint = int(pageno)
virtual_memory_binary = format(pagenoint, '05b')
frame_no = Process_A[pagenoint]
end_time = time.perf_counter()
execution_time = end_time - start_time
print("The virtual memory address you keyed in is: ", virtual_memory_binary, grouped_binary2)
if frame_no == -1:
    print("Frame number not found for this page")
else:
    frame_no_to_binary = format(frame_no,'05b')
    print("The physical memory address to be accessed after paging is:",frame_no_to_binary , grouped_binary2)

print(f"Execution time: {execution_time} seconds")