// -------------------------------------------------------------
// CSC1104 - Number Checker with Execution Time (AArch64)       // file header
// Author : [Your Name]                                         // author tag (replace if needed)
// Purpose: Check if any two numbers in a fixed list sum to     // brief description
//          user input and time the computation using now_ns(). // timing description
// References: Lecture 6 (Assembly), Lecture 8 (Instruction Set)// citation note
// -------------------------------------------------------------

.data                                                          // start data section (variables & strings live here)
list:       .word 1,2,4,8,16,32,64,128                         // 8-element int array (4 bytes each)
size:       .word 8                                            // constant: number of elements in list
target:     .word 0                                            // storage for user-entered target sum
found:      .word 0                                            // flag set to 1 when a pair is found

REPEAT:     .word 1000000                                      // repeat count for timing loop

prompt:     .asciz "Enter a number to check: "                 // input prompt string (null-terminated)
fmt:        .asciz "%d"                                        // scanf/printf integer format
msg_yes:    .asciz "There are two numbers in the list summing to the keyed-in number %d\n" // success message
msg_no:     .asciz "There are not two numbers in the list summing to the keyed-in number %d\n" // failure message
msg_time:   .asciz "Total: %llu ns for %d repeats (avg %llu ns)\n" // timing report message

.text                                                          // start code section
.global main                                                   // export main symbol to linker
.extern printf                                                 // declare external printf
.extern scanf                                                  // declare external scanf
.extern now_ns                                                 // declare external now_ns: uint64_t now_ns(void)

main:                                                          // program entry
    SUB sp, sp, #32                                            // make 32 bytes stack space for frame
    STP x29, x30, [sp, #16]                                    // save frame pointer (x29) and return address (x30)
    MOV x29, sp                                                // set new frame pointer

    LDR x0, =prompt                                            // x0 = address of prompt string (printf arg#1)
    BL printf                                                  // print prompt
    LDR x0, =fmt                                               // x0 = "%d" format (scanf arg#1)
    LDR x1, =target                                            // x1 = &target (scanf arg#2)
    BL scanf                                                   // read integer into target

    LDR x19, =list                                             // x19 = base address of list (callee-saved)
    LDR x20, =size                                             // x20 = address of size
    LDR w21, [x20]                                             // w21 = size (8)
    LDR x22, =target                                           // x22 = address of target
    LDR w23, [x22]                                             // w23 = target value (zero-extended to 64-bit on use)
    LDR x24, =found                                            // x24 = address of found
    MOV w25, #0                                                // w25 = 0
    STR w25, [x24]                                             // found = 0

    LDR x26, =REPEAT                                           // x26 = address of REPEAT
    LDR w27, [x26]                                             // w27 = REPEAT count (1,000,000)

    BL now_ns                                                  // call timer to get start time
    MOV x9, x0                                                 // x9 = start time (ns)

repeat_loop:                                                   // top of outer repeat loop
    SUBS w27, w27, #1                                          // w27 = w27 - 1, update flags
    BMI end_repeat                                             // if went negative (past 0), exit repeat loop

    MOV w0, #0                                                 // w0 = 0
    STR w0, [x24]                                              // found = 0 (reset each repetition)
    MOV w1, #0
