section .data
    prompt db "Please input a number: ", 0
    is_prime_msg db "%d is a prime number", 10, 0
    not_prime_msg db "%d is not a prime number", 10, 0

section .bss
    num_input resd 1 ; Reserve space for the user's number

section .text
    global _start

_start:
    ; Print the prompt
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, prompt     ; address of prompt string
    mov edx, 23         ; length of prompt string
    int 0x80

    ; Read user input
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, num_input  ; address to store the input
    mov edx, 10         ; max bytes to read (enough for an integer)
    int 0x80

    ; Convert ASCII input to integer
    ; This is a simplified conversion, real-world would involve more robust parsing
    ; For simplicity, let's assume `num_input` contains a single digit or small number string
    ; A more complex solution would parse the string digit by digit.
    ; For now, let's assume we read into num_input as a string and then convert.
    ; We'll use a standard C library function for demonstration.
    ; Let's assume an external function `atoi` or similar.
    ; For a pure assembly solution without external libraries for input, it's more involved.

    ; Let's assume `num_input` now holds the integer directly after some magic or
    ; let's implement a very basic ASCII to integer conversion for a single digit for simplicity
    ; (This is *not* production-ready, but demonstrates the concept without external C libs)

    ; If we're truly avoiding external libraries like C's scanf/printf for integer IO,
    ; we need to write our own routines or make assumptions.
    ; Let's assume for now that `num_input` can be read as an integer from the user.
    ; A common approach for number input/output in assembly is to use libc.

    ; Let's use `scanf` for input and `printf` for output, linking with C library.
    ; This makes the example more practical.

    ; Stack setup for C function calls (cdecl calling convention)
    ; Push format string, then address of variable for scanf
    extern scanf
    extern printf
    extern exit

    ; Read the number
    push num_input
    push dword format_in
    call scanf
    add esp, 8 ; Clean up stack

    ; Get the number from num_input
    mov eax, [num_input]

    ; Store num in ebx for later use in printing
    mov ebx, eax

    ; Check if num > 1
    cmp eax, 1
    jle .not_prime_less_equal_one

    ; Calculate s = int(num**.5)
    ; This requires a square root function.
    ; FPU (x87) or SSE/AVX can do this. For integer square root, a loop or a specialized algorithm is needed.
    ; Let's implement a simple integer square root approximation.

    mov ecx, 2 ; i = 2
    mov edx, eax ; Copy num to edx for integer square root algorithm
    xor ebx, ebx ; result = 0 (for square root)
    mov edi, 1 ; bit = 1
    shl edi, 30 ; Start with the highest possible bit (assuming 32-bit number)

.sqrt_loop:
    cmp edi, 0
    je .sqrt_end

    ; if (edx - (ebx + edi)) >= 0
    mov esi, ebx
    add esi, edi
    cmp edx, esi
    jl .sqrt_skip_add

    ; result += bit (ebx += edi)
    add ebx, edi
    ; edx -= result (edx -= ebx) - careful here, the 'result' for subtraction is the previous one.
    ; it should be: if (num >= (root + bit) * (root + bit))
    ; A simpler integer sqrt:
    ; root = 0
    ; bit = 1 << 15 (for 16-bit) or 1 << 30 (for 32-bit)
    ; while (bit != 0):
    ;   if (num >= (root + bit)*(root + bit)):
    ;     root += bit
    ;   bit >>= 1

    ; Let's use a simpler, iterative square root for positive integers if num is not too large
    ; s = 0
    ; while s*s <= num:
    ;   s += 1
    ; s -= 1

    ; Simpler integer square root:
    xor ecx, ecx ; ecx will be 's'
.isqrt_loop:
    mov edx, ecx ; edx = s
    imul edx, ecx ; edx = s * s
    cmp edx, eax ; Compare s*s with num
    jg .isqrt_end_loop ; If s*s > num, break

    inc ecx ; s++
    jmp .isqrt_loop

.isqrt_end_loop:
    dec ecx ; s-- (because we incremented one too many times)
    mov esi, ecx ; esi now holds 's' (integer square root)

    ; Loop from i = 2 to s (exclusive, so range(2, s))
    mov ecx, 2 ; i = 2

.prime_check_loop:
    cmp ecx, esi ; Compare i with s
    jge .is_prime ; If i >= s, then it's a prime number (no factors found)

    ; Check if (num % i) == 0
    xor edx, edx      ; Clear edx for division
    mov eax, [num_input] ; Load num into eax for division
    div ecx           ; eax = num / i, edx = num % i

    cmp edx, 0        ; Compare remainder with 0
    je .not_prime     ; If remainder is 0, it's not prime

    inc ecx           ; i++
    jmp .prime_check_loop

.is_prime:
    ; Print "num is a prime number"
    push dword [num_input]
    push dword is_prime_msg
    call printf
    add esp, 8
    jmp .exit

.not_prime:
.not_prime_less_equal_one:
    ; Print "num is not a prime number"
    push dword [num_input]
    push dword not_prime_msg
    call printf
    add esp, 8

.exit:
    mov eax, 1        ; sys_exit
    xor ebx, ebx      ; exit code 0
    int 0x80

section .data
    format_in db "%d", 0 ; Format string for scanf