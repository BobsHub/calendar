@ Print a calendar to the screen showing the date
.global _start

_start:

@ Print month title bar

	bl	_date_values		@ Function to get day/month/year
	ldr	r0, =current_month
	ldrb	r0, [r0]		@ Fetch the month
	ldr	r1, =current_day
	ldrb	r1, [r1]		@ And the day
					
	ldr	r2, =addr_months	@ Point to top of string array containing month names
	mov	r0, r0, lsl #2		@ Prepare pointer to be 4*(zero based month) for addressing
	add	r2, r2, r0		@ Offset into the month string 
	ldr	r0, [r2]		@ and load the string address at offset	
	bl	_print_string		@ Call function to print the month (r0=buffer)				
	
@ Prints the year

	ldr	r2, =current_year	@ Fetch year from date_values.s
	ldrh	r0, [r2]
	bl	_int_to_str		@ Convert integer in r0 to a string.
					@ Returned is pointer to string in r0
	bl	_print_string		@ Function prints a string in buffer r0
	ldr	r0, =month_title
	bl	_print_string		@ Print the rest of the header days	

@ Print the month body

	@ Find the start square for the month
	ldr	r0, =total_days
	ldrh	r0, [r0]		@ Fetch total days from 1/1/1970 to now
	sub	r0, r0, r1		@ Total days from 1/1/1970 to month/1/year
	add	r0, r0, #4		@ 1/1/1970 starts at square #5
	mov	r1, #7			
	bl	_int_divide		@ 0 based start square returned in r1 (modulus)

	@ Print spaces for the leading blank squares
	mov	r2, #0				
_blank_days:
	ldr	r0, =blank_square
	cmp	r2, r1
	bge	_start_calendar_day
	bl	_print_string
	add	r2, r2, #1
	b	_blank_days

	@ Start printing the days
_start_calendar_day:
	ldr	r0, =current_month
	ldrb	r0, [r0]		@ Fetch the month
	ldr	r4, =days_in_month	@ Array of days in each month from date_values.s
	ldrb	r4, [r4, r0]		@ Fetch the day count
	ldr	r2, =current_day
	ldrb	r2, [r2]		@ And the current day in month
	add	r2, r2, #1		@ Calendar days start with a '1'

	mov	r3, #0
	mov	r5, r1			@ Save start box
_next_calendar_day:
	add	r3, r3, #1
	ldr	r0, =single_space
	teq	r3, r2
	cmp	r3, #10
	ldrlt	r0, =double_space
	bl	_print_string
	ldr	r0, =double_space
	teq	r3, r2
	ldreq	r0, =left_arrow
	bl	_print_string
	mov	r0, r3
	bl	_int_to_str
	bl	_print_string

	mov	r1, #7			@ Wrap numbers at 7 boxes
	add	r0, r3, r5
	bl	_int_divide
	ldr	r0, =newline
	teq	r1, #0
	bleq	_print_string		@ Newline after box 7

	cmp	r3, r4
	blt	_next_calendar_day

	ldr	r0, =newline
	bl	_print_string
	ldr	r0, =newline
	bl	_print_string


_end:
	mov	r7, #1
	swi	0

@ Address label for months (Creates an array of pointers to strings)
addr_months:
	.word lbl_jan, lbl_feb, lbl_mar, lbl_apr, lbl_may, lbl_jun
	.word lbl_jul, lbl_aug, lbl_sep, lbl_oct, lbl_nov, lbl_dec

.DATA

month_title:
	.ascii "\n-----------------------------------"
	.asciz "\n  Sun  Mon  Tue  Wed  Thu  Fri  Sat\n"

blank_square:	.asciz "     "
double_space:	.asciz "  "
single_space:	.asciz " "
left_arrow:		.asciz "->"
newline:		.asciz "\n"

lbl_jan: .asciz "\n           January "
lbl_feb: .asciz "\n          February "
lbl_mar: .asciz "\n            March "
lbl_apr: .asciz "\n            April "
lbl_may: .asciz "\n             May "
lbl_jun: .asciz "\n            June "
lbl_jul: .asciz "\n            July "
lbl_aug: .asciz "\n           August "
lbl_sep: .asciz "\n          September "
lbl_oct: .asciz "\n           October "
lbl_nov: .asciz "\n          November "
lbl_dec: .asciz "\n          December "
