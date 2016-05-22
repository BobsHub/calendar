.global _int_divide

@ Integer divide. r0 / r1 going in
@ Returned are r0 (quotient), r1 (remainder)
_int_divide:
	@ We'll be using r2, r3, and r4 so save the old values
	stmdb	sp!, { r2, r3, r4 }
	ldr	r2, =lr_bak
	str	lr, [r2]		@ Save the lr
	
	teq	r1, #0			@ Trap divide by 0
	moveq	r0, #0
	mvneq	r1, #0

	mvn	r4, r1			@ Save divisor
_start_pos:
	mov	r2, r1, lsl #1		@ Multiply divisor by 2 until <= dividend
	cmp	r0, r2
	movhs	r1, r2
	bhi	_start_pos

	mov	r3, #0			@ r3 will hold quotient
_next:
	mov	r3, r3, lsl #1		@ Shift LSB of previous quotient left
	subs	r2, r0, r1		@ Subtract divisor from dividend
	movge	r0, r2			@ Remainder becomes new dividend
	orrge	r3, r3, #1		@ Set LSB for current quotient
	tst	r1, r4			@ Test for original divisor (signal to stop)
	movne	r1, r1, lsr #1		@ Divide divisor by 2
	bne	_next

	mov	r1, r0
	mov	r0, r3

	ldmia	sp!, { r2, r3, r4 }	@ Restore old registers
	ldr	lr, =lr_bak
	ldr	lr, [lr]		@ and the lr
	bx	lr			@ Return

.DATA
.balign 4
lr_bak: .word 0
