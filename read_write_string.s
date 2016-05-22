.global _print_string

@ Print a string. r0 points to buffer
_print_string:
	@ Registers needed for syscall. so back up old values
	stmdb	sp!, { r1, r2, r7 }
	ldr	r1, =lr_bak
	str	lr, [r1]	@ and link register

	@ Determine the length of the string
	mov	r1, #0
_character_count:
	ldrb	r2, [r0, r1]
	teq	r2, #0
	addne	r1, r1, #1
	bne 	_character_count

	@ Syscall for writing to screen
	mov	r2, r1		@ Max characters to write
	mov	r1, r0		@ String buffer in r1
	mov	r7, #4		@ Write
	mov	r0, #1		@ To screen
	swi	0	

	ldmia	sp!, { r1, r2, r7 }
	ldr	lr, =lr_bak
	ldr	lr, [lr]
	bx	lr


@ Read a string. r0 = buffer, r1 = count	 
_read_string:
	stmdb	sp!, { r2, r7 }
	ldr	r2, =lr_bak
	str	lr, [r2]

	@ Syscall for reading from keyboard
	mov	r2, r1		@ Pass character count
	mov	r1, r0		@ Pass buffer
	mov	r7, #3		@ Read
	mov	r0, #0		@ From keyboard				
	swi	0

	ldmia	sp!, { r2, r7 }
	ldr	lr, =lr_bak
	ldr	lr, [lr]
	bx	lr

.DATA

.balign 4
lr_bak:	.word 0	 
