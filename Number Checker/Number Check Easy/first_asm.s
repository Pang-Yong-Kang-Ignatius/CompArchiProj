.data
list:.word 1,2,4,8,16,32,64,128        // Define a list of 8 integers
size:.word 8                            // Store the size of the list (8)
target:.word 0                          // Variable to hold user input target number
found:.word 0                           // Flag to indicate if a pair is found (1 = found)
prompt:.asciz "Enter a number to check: "  // Message prompt for user input
fmt_in:.asciz "%d"                      // Format specifier for integer input
msg_yes:.asciz "There are two numbers in the list summing to the keyed-in number %d\n"  // Message if a pair is found
msg_no:.asciz "There are not two numbers in the list summing to the keyed-in number %d\n" // Message if no pair found

.text
.global main
.extern printf
.extern scanf

main:
sub sp,sp,#16                           // Create stack space (save return address)
str x30,[sp]                            // Store link register (return address) on stack

ldr x0,=prompt                          // Load the address of prompt message
bl printf                               // Call printf to print "Enter a number to check: "

ldr x0,=fmt_in                          // Load format string "%d" for scanf
ldr x1,=target                          // Load address of target variable
bl scanf                                // Call scanf to read user input into target

ldr x2,=found                           // Load address of 'found' variable
mov w3,#0                               // Initialize found = 0
str w3,[x2]                             // Store found = 0 into memory
mov x4,#0                               // Initialize i = 0 (outer loop counter)

ldr x5,=size                            // Load address of 'size'
ldr w16,[x5]                            // Load list size (8) into w16
ldr x6,=list                            // Load address of the list array
ldr x7,=target                          // Load address of target variable
ldr w17,[x7]                            // Load target value into w17

outer_loop:
cmp x4,x16                              // Compare i with size (i < size?)
bge end_outer                           // If i >= size, exit outer loop
add x8,x4,#1                            // Set j = i + 1 (initialize inner loop counter)

inner_loop:
cmp x8,x16                              // Compare j with size (j < size?)
bge next_i                              // If j >= size, exit inner loop
lsl x9,x4,#2                            // Calculate offset i*4 (each word is 4 bytes)
add x9,x6,x9                            // Compute address of list[i]
ldr w10,[x9]                            // Load list[i] into w10
lsl x11,x8,#2                           // Calculate offset j*4
add x11,x6,x11                          // Compute address of list[j]
ldr w12,[x11]                           // Load list[j] into w12
add w13,w10,w12                         // w13 = list[i] + list[j]
cmp w13,w17                             // Compare sum with target
beq found_pair                          // If sum == target, jump to found_pair
add x8,x8,#1                            // Increment j
b inner_loop                            // Repeat inner loop

next_i:
add x4,x4,#1                            // Increment i
b outer_loop                            // Repeat outer loop

found_pair:
mov w3,#1                               // Set found = 1
str w3,[x2]                             // Store found = 1 into memory

end_outer:
ldr w14,[x2]                            // Load value of found
cbz w14,print_no                        // If found == 0, jump to print_no
ldr x0,=msg_yes                         // Load success message
mov w1,w17                              // Move target value into w1 (printf argument)
bl printf                               // Print success message
b done                                  // Jump to done

print_no:
ldr x0,=msg_no                          // Load failure message
mov w1,w17                              // Move target value into w1 (printf argument)
bl printf                               // Print failure message

done:
ldr x30,[sp]                            // Restore link register
add sp,sp,#16                           // Free stack space
mov w0,#0                               // Return value 0 (normal exit)
ret                                     // Return to operating system
