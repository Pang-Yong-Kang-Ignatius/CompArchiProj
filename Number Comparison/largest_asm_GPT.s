    .section .rodata
prompt:     .asciz "Enter number %d: "
fmt_in:     .asciz "%d"
msg_out:    .asciz "The largest number is: %d\n"

    .section .bss
    .align 4
nums:       .space 12                 // 3 * 4 bytes (int)

    .text
    .global main
    .global largest
    .extern printf
    .extern scanf

// int main(void)
main:
    // prologue
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    stp     x19, x20, [sp, -16]!

    // i = 0
    mov     x19, #0

// for (i = 0; i < 3; i++)
.Lread_loop:
    cmp     x19, #3
    b.ge    .Lread_done

    // printf("Enter number %d: ", i+1)
    ldr     x0, =prompt            // x0 = format
    add     x1, x19, #1            // x1 = i+1
    bl      printf

    // scanf("%d", &nums[i])
    ldr     x0, =fmt_in            // x0 = "%d"
    ldr     x20, =nums             // x20 = &nums[0]
    add     x1, x20, x19, lsl #2   // x1 = &nums[i]
    bl      scanf

    add     x19, x19, #1
    b       .Lread_loop

.Lread_done:
    // call largest(nums[0], nums[1], nums[2])
    ldr     x20, =nums
    ldr     w0, [x20, #0]          // a
    ldr     w1, [x20, #4]          // b
    ldr     w2, [x20, #8]          // c
    bl      largest

    // return 0
    mov     w0, #0

    // epilogue
    ldp     x19, x20, [sp], 16
    ldp     x29, x30, [sp], 16
    ret


// void largest(int a, int b, int c)
// AArch64 calling convention: a,b,c in w0,w1,w2
largest:
    // prologue
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Determine largest in w3
    mov     w3, w0                 // largest = a

    // if (b > largest) largest = b;
    cmp     w1, w3
    ble     .Lskip_b
    mov     w3, w1
.Lskip_b:

    // if (c > largest) largest = c;
    cmp     w2, w3
    ble     .Lskip_c
    mov     w3, w2
.Lskip_c:

    // printf("The largest number is: %d\n", largest)
    ldr     x0, =msg_out           // format
    mov     w1, w3                 // value
    bl      printf

    // epilogue
    ldp     x29, x30, [sp], 16
    ret
