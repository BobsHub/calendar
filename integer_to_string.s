.global	_int_to_str

@ Convert an integer to a string
@ r0 is passed as an integer
@ r0 is returned as pointer to string

_int_to_str:
	stmdb	sp!, { r1, r2 }		@ Registers we'll use
	ldr	r1, =lr_bak
	str	lr, [r1]
	
	ldr	r2, =value_string
	add	r2, r2, #10		@ Position string pointer to '\0'

_next_digit:
	sub	r2, r2, #1		@ Decrement string pointer to receive next digit

	mov	r1, #10			@ Using divide function
	bl	_int_divide		@ In: r0 / r1. Out: r0 = quotient, r1 = remainder	
	
	add	r1, r1, #48		@ Convert term to an ascii character
	strb	r1, [r2]		@ Insert character in value_string
	teq	r0, #0
	bne	_next_digit

	mov	r0, r2			@ Start of string returned in r0

	ldmia	sp!, { r1, r2 }
	ldr	lr, =lr_bak
	ldr	lr, [lr]
	bx	lr

.DATA
value_string:
	.asciz "          "		@ 10 characters to hold the string

.balign 4
lr_bak:	.word 0
