    .section .rodata                      // read-only strings
p1:        .asciz "Enter number 1: "      // prompt for first number
p2:        .asciz "Enter number 2: "      // prompt for second number
p3:        .asciz "Enter number 3: "      // prompt for third number
fmt_in:    .asciz "%d"                    // scanf integer format
msg_out:   .asciz "The largest number is: %d\n"   // output message format

    .section .bss                         // uninitialized memory
    .align 4
nums:      .space 12                      // space for 3 integers (3 × 4 bytes)

    .text
    .global main                          // expose main to linker
    .extern printf                        // use C library printf
    .extern scanf                         // use C library scanf

main:
    stp x29, x30, [sp, -16]!              // save frame pointer and return address
    mov x29, sp                           // set frame pointer to current stack

    ldr x0, =p1                           // load address of prompt 1
    bl printf                             // print prompt 1
    ldr x0, =fmt_in                       // load "%d"
    ldr x1, =nums                         // load address of nums[0]
    bl scanf                              // read first integer into nums[0]

    ldr x0, =p2                           // load address of prompt 2
    bl printf                             // print prompt 2
    ldr x0, =fmt_in                       // load "%d"
    ldr x1, =nums                         // load base address of nums array
    add x1, x1, #4                        // move pointer to nums[1]
    bl scanf                              // read second integer

    ldr x0, =p3                           // load address of prompt 3
    bl printf                             // print prompt 3
    ldr x0, =fmt_in                       // load "%d"
    ldr x1, =nums                         // load base address of nums array
    add x1, x1, #8                        // move pointer to nums[2]
    bl scanf                              // read third integer

    ldr x20, =nums                        // load base address of nums array
    ldr w4, [x20]                         // w4 = nums[0]
    ldr w5, [x20, #4]                     // w5 = nums[1]
    ldr w6, [x20, #8]                     // w6 = nums[2]

    mov w7, w4                            // assume nums[0] is largest

    cmp w5, w7                            // compare nums[1] with largest
    ble skip_second                       // if nums[1] <= largest skip update
    mov w7, w5                            // else largest = nums[1]

skip_second:
    cmp w6, w7                            // compare nums[2] with largest
    ble skip_third                        // if nums[2] <= largest skip update
    mov w7, w6                            // else largest = nums[2]

skip_third:
    ldr x0, =msg_out                      // load output format string
    mov w1, w7                            // w1 = largest number
    bl printf                             // print largest number

    ldp x29, x30, [sp], 16                // restore frame pointer & return address
    mov w0, #0                            // return 0
    ret                                   // return from main
