.global _date_values
.global current_year
.global current_month
.global current_day
.global total_days
.global days_in_month

@ Finds the year, month and day
@ Stores total days from 1/1/1970 to now

_date_values:
	stmdb	sp!, { r0, r1, r2, r3, r7 }
	ldr	r0, =lr_bak
	str	lr, [r0]

@ Find total number of days from 1/1/1970 to now

	mov	r7, #78			@ Syscall for gettimeofday
	ldr	r0, =tv			@ Timeval buffer.
	ldr	r1, =tz			@ Timezone buffer
	swi	0

	ldr	r0, =tv
	ldr	r0, [r0]		@ Fetch total seconds since 1/1/1970
	ldr	r1, =#86400		@ Divide by seconds/day to get days
	bl	_int_divide		@ in: r0/r1. r0(quotient) returned
	ldr	r1, =total_days
	strh	r0, [r1]		@ Store total days

@ Next find current year

	ldr	r1, =#1461		@ Groups of 4 years are 1461 days up to 2099
	bl	_int_divide
	mov	r0, r0, lsl #2		@ Groups*4 years total so far

	ldr	r2, =#365	
_next_year:				@ Any remaining years have 365, 365, 366 days
	subs	r3, r1, r2
	blt	_years_done
	add	r0, r0, #1		@ Add remaining years in r0
	mov	r1, r3			@ And put days left in r1
	b	_next_year
	ldr	r2, =#366
	b	_next_year

_years_done:
	cmp	r0, #129		@ 2099 Maximum year
	mov	r7, #1
	swieq	0	

	ldr	r2, =#1970
	add	r0, r0, r2
	ldr	r2, =current_year
	strh	r0, [r2]		@ Store current year
	ldr	r2, =current_day
	strb	r1, [r2]		@ Store days left
	
@ Find current day in month
	
	mov	r1, #4			@ year/4 = 0 for leap years < 2100
	bl	_int_divide		@ in: r0/r1 out r1(modulus)		
	teq	r1, #0			@ Is it a leap year?
	ldr	r2, =days_in_month
	mov	r3, #29
	streqb	r3, [r2, #1]		@ Update the days_in_month array
					@ 29 days in Feb if leap year

	mov	r0, #0			@ Start at zero and accumulate months
	ldr	r1, =current_day
	ldrb	r1, [r1]		@ Fetch days left from the top of the year
_next_month:
	ldrb	r3, [r2, r0]		@ Fetch day count for month
	subs	r3, r1, r3		@ Subtract days in month from days left 
	movge	r1, r3
	addgt	r0, r0, #1		@ If any days left roll over into next month
	bgt	_next_month

	ldr	r2, =current_month
	strb	r0, [r2]		@ Store 0 based month
	ldr	r2, =current_day
	strb	r1, [r2]		@ Store 0 based day		
			
_end:
	ldmia	sp!, { r0, r1, r2, r3, r7 }
	ldr	lr, =lr_bak
	ldr	lr, [lr]
	bx	lr

.DATA
.balign 4
lr_bak:	.word 0		

.balign 4	
tv:	.word 0, 0	@ Timeval struct. Seconds returned in word 1
			@ Microseconds in word 2 
tz:	.word 0, 0	@ Timezone struct. Supply minutes west of GMT
							@ in word 1
.balign 2
total_days:	.hword 0

.balign 2
current_year:	.hword 0

.balign 1	
current_month:	.byte 0

.balign 1
current_day:	.byte 0

.balign 1
days_in_month:
	.byte 31, 28, 31, 30, 31, 30
	.byte 31, 31, 30, 31, 30, 31
