section .data
    prompt1 db "Please input first number: ", 0
    prompt2 db "Please input second number: ", 0
    prompt3 db "Please input third number: ", 0
    output_msg db "The largest number is %d", 10, 0
    format_in db "%d", 0

section .bss
    num1_input resd 1
    num2_input resd 1
    num3_input resd 1

section .text
    global _start

    ; Declare external C functions for I/O
    extern scanf
    extern printf
    extern exit

_start:
    ; --- Input num1 ---
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, prompt1    ; address of prompt1 string
    mov edx, 27         ; length of prompt1 string
    int 0x80

    push dword num1_input ; Push address of variable
    push dword format_in  ; Push format string
    call scanf            ; Call scanf
    add esp, 8            ; Clean up stack

    ; --- Input num2 ---
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, prompt2    ; address of prompt2 string
    mov edx, 28         ; length of prompt2 string
    int 0x80

    push dword num2_input
    push dword format_in
    call scanf
    add esp, 8

    ; --- Input num3 ---
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, prompt3    ; address of prompt3 string
    mov edx, 27         ; length of prompt3 string
    int 0x80

    push dword num3_input
    push dword format_in
    call scanf
    add esp, 8

    ; --- Find the largest number ---
    ; Load num1 into EAX (our current largest)
    mov eax, [num1_input]

    ; Compare with num2
    mov ebx, [num2_input]
    cmp eax, ebx
    jge .check_num3 ; If num1 >= num2, keep num1 as largest and check num3

    ; If num2 > num1, then num2 is currently the largest
    mov eax, ebx    ; EAX = num2

.check_num3:
    ; Compare with num3
    mov ebx, [num3_input]
    cmp eax, ebx
    jge .found_largest ; If current largest (EAX) >= num3, then EAX is the largest

    ; If num3 > current largest, then num3 is the largest
    mov eax, ebx    ; EAX = num3

.found_largest:
    ; EAX now holds the largest number

    ; --- Output the largest number ---
    push eax            ; Push the largest number
    push dword output_msg ; Push the format string
    call printf         ; Call printf
    add esp, 8          ; Clean up stack

    ; --- Exit ---
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; exit code 0
    int 0x80