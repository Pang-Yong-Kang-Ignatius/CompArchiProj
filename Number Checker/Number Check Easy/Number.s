.data
list:.word 1,2,4,8,16,32,64,128
size:.word 8
target:.word 0
found:.word 0
prompt:.asciz "Enter a number to check: "
fmt_in:.asciz "%d"
msg_yes:.asciz "There are two numbers in the list summing to the keyed-in number %d\n"
msg_no:.asciz "There are not two numbers in the list summing to the keyed-in number %d\n"

.text
.global main
.extern printf
.extern scanf

main:
sub sp,sp,#16
str x30,[sp]

ldr x0,=prompt
bl printf

ldr x0,=fmt_in
ldr x1,=target
bl scanf

ldr x2,=found
mov w3,#0
str w3,[x2]
mov x4,#0

ldr x5,=size
ldr w16,[x5]
ldr x6,=list
ldr x7,=target
ldr w17,[x7]

outer_loop:
cmp x4,x16
bge end_outer
add x8,x4,#1

inner_loop:
cmp x8,x16
bge next_i
lsl x9,x4,#2
add x9,x6,x9
ldr w10,[x9]
lsl x11,x8,#2
add x11,x6,x11
ldr w12,[x11]
add w13,w10,w12
cmp w13,w17
beq found_pair
add x8,x8,#1
b inner_loop

next_i:
add x4,x4,#1
b outer_loop

found_pair:
mov w3,#1
str w3,[x2]

end_outer:
ldr w14,[x2]
cbz w14,print_no
ldr x0,=msg_yes
mov w1,w17
bl printf
b done

print_no:
ldr x0,=msg_no
mov w1,w17
bl printf

done:
ldr x30,[sp]
add sp,sp,#16
mov w0,#0
ret
