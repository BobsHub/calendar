.global read_int

read_int:
	mov	r7, #3		@ Syscall for read
	mov	r0, #1		@ Prompt for input string
	ldr	r1, =strin	@ String buffer
	mov	r2, #10		@ Max chars to read in
	swi	0

	ldr	r0, =strin	@ r0 pointer in string
	mov	r1, #0		@ r1 to hold integer

next_term:
	ldrb 	r2, [r0]	@ Ascii value in r2
	subs	r2, r2, #48	@ Convert to a digit
	bmi	end		@ Ensure digit is between 0 and 9
	cmp	r2, #9
	bgt	end
	mov	r3, #10
	mla	r4, r1, r3, r2
	mov	r1, r4 
	add	r0, r0, #1	@ Point to next character in string 
	b	next_term
  
end:  
	mov	r0, r1

.DATA

strin: .ascii " "
