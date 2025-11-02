.section .data
prompt1:    .string "Enter 8 numbers:\n"
prompt2:    .string "Enter number %d: "
prompt3:    .string "Enter a number to check: "
format_in:  .string "%d"
msg_found:  .string "There are two numbers in the list summing to the keyed-in number %d\n"
msg_not:    .string "There are not two numbers in the list summing to the keyed-in number %d\n"

.section .bss
list:       .space 32        # 8 integers * 4 bytes each
target:     .space 4

.section .text
.globl main

main:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $48, %rsp        # Allocate stack space (align to 16 bytes)
    
    # Print "Enter 8 numbers:"
    leaq    prompt1(%rip), %rdi
    xorq    %rax, %rax
    call    printf
    
    # Loop to read 8 numbers
    xorq    %r12, %r12       # i = 0
read_loop:
    cmpq    $8, %r12
    jge     read_done
    
    # Print "Enter number %d: "
    leaq    prompt2(%rip), %rdi
    movq    %r12, %rsi
    addq    $1, %rsi         # i + 1 for display
    xorq    %rax, %rax
    call    printf
    
    # Read integer
    leaq    format_in(%rip), %rdi
    leaq    list(%rip), %rax
    leaq    (%rax,%r12,4), %rsi  # &list[i]
    xorq    %rax, %rax
    call    scanf
    
    incq    %r12
    jmp     read_loop
    
read_done:
    # Print "Enter a number to check: "
    leaq    prompt3(%rip), %rdi
    xorq    %rax, %rax
    call    printf
    
    # Read target
    leaq    format_in(%rip), %rdi
    leaq    target(%rip), %rsi
    xorq    %rax, %rax
    call    scanf
    
    # Nested loop to find two sum
    xorq    %r12, %r12       # i = 0
    xorq    %r13, %r13       # found = 0
    
outer_loop:
    cmpq    $8, %r12
    jge     check_found
    
    movq    %r12, %r14
    incq    %r14             # j = i + 1
    
inner_loop:
    cmpq    $8, %r14
    jge     inner_done
    
    # Load list[i]
    leaq    list(%rip), %rax
    movl    (%rax,%r12,4), %ecx
    
    # Load list[j]
    movl    (%rax,%r14,4), %edx
    
    # Check if list[i] + list[j] == target
    addl    %edx, %ecx
    movl    target(%rip), %esi
    cmpl    %esi, %ecx
    jne     continue_inner
    
    # Found a match
    movq    $1, %r13
    jmp     check_found
    
continue_inner:
    incq    %r14
    jmp     inner_loop
    
inner_done:
    incq    %r12
    jmp     outer_loop
    
check_found:
    # Print result
    cmpq    $0, %r13
    je      not_found
    
    # Print found message
    leaq    msg_found(%rip), %rdi
    movl    target(%rip), %esi
    xorq    %rax, %rax
    call    printf
    jmp     end
    
not_found:
    # Print not found message
    leaq    msg_not(%rip), %rdi
    movl    target(%rip), %esi
    xorq    %rax, %rax
    call    printf
    
end:
    xorq    %rax, %rax       # return 0
    leave
    ret