	.text
	.global main
	.extern printf
	.extern scanf

	.bss
	.align 3
list:	.skip 32             // 8 * 4 bytes
target:	.skip 4
found:	.skip 4
i_var:	.skip 4
j_var:	.skip 4

	.data
prompt1:        .asciz "Enter 8 numbers:\n"
prompt_num:     .asciz "Enter number %d: "
scan_int:       .asciz "%d"
prompt_target:  .asciz "Enter a number to check: "
msg_yes:        .asciz "There are two numbers in the list summing to the keyed-in number %d\n"
msg_no:         .asciz "There are not two numbers in the list summing to the keyed-in number %d\n"

	.text
main:
	// printf("Enter 8 numbers:\n");
	adrp	x0, prompt1
	add	x0, x0, :lo12:prompt1
	bl	printf

	// i = 0; found = 0;
	mov	w19, #0
	adrp	x0, found
	add	x0, x0, :lo12:found
	str	wzr, [x0]

	// for (i=0; i<8; i++)
loop_i:
	cmp	w19, #8
	bge	read_done

	// printf("Enter number %d: ", i+1);
	adrp	x0, prompt_num
	add	x0, x0, :lo12:prompt_num
	add	w1, w19, #1
	uxtw	x1, w1
	bl	printf

	// scanf("%d", &list[i]);
	adrp	x0, scan_int
	add	x0, x0, :lo12:scan_int
	adrp	x1, list
	add	x1, x1, :lo12:list
	uxtw	x2, w19
	add	x1, x1, x2, lsl #2
	bl	scanf

	add	w19, w19, #1
	b	loop_i

read_done:
	// scanf target
	adrp	x0, prompt_target
	add	x0, x0, :lo12:prompt_target
	bl	printf

	adrp	x0, scan_int
	add	x0, x0, :lo12:scan_int
	adrp	x1, target
	add	x1, x1, :lo12:target
	bl	scanf

	// found = 0; i = 0;
	adrp	x2, found
	add	x2, x2, :lo12:found
	str	wzr, [x2]

	mov	w19, #0            // i

outer_loop:
	cmp	w19, #8
	bge	after_loops

	// j = i + 1;
	add	w20, w19, #1       // j

inner_loop:
	cmp	w20, #8
	bge	next_i

	// if (list[i] + list[j] == target)
	adrp	x3, list
	add	x3, x3, :lo12:list
	uxtw	x4, w19
	ldr	w5, [x3, x4, lsl #2]    // list[i]
	uxtw	x4, w20
	ldr	w6, [x3, x4, lsl #2]    // list[j]
	add	w5, w5, w6              // sum

	adrp	x7, target
	add	x7, x7, :lo12:target
	ldr	w6, [x7]                // target
	cmp	w5, w6
	bne	inc_j

	// found = 1; break
	mov	w5, #1
	str	w5, [x2]
	b	after_loops

inc_j:
	add	w20, w20, #1
	b	inner_loop

next_i:
	add	w19, w19, #1
	b	outer_loop

after_loops:
	// if (found) printf(msg_yes, target); else printf(msg_no, target);
	ldr	w5, [x2]     // found
	adrp	x1, target
	add	x1, x1, :lo12:target
	ldr	w1, [x1]     // target value
	uxtw	x1, w1

	cmp	w5, #0
	beq	print_no

	adrp	x0, msg_yes
	add	x0, x0, :lo12:msg_yes
	bl	printf
	b	done

print_no:
	adrp	x0, msg_no
	add	x0, x0, :lo12:msg_no
	bl	printf

done:
	mov	w0, #0
	ret
