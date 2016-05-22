calendar:	calendar.o date_values.o integer_to_string.o integer_divide.o read_write_string.o
	ld -o calendar calendar.o date_values.o integer_to_string.o integer_divide.o read_write_string.o

calendar.o:	calendar.s
	as -g -o calendar.o calendar.s

date_values.o:	date_values.s
	as -g -o date_values.o date_values.s

integer_to_string.o:	integer_to_string.s
	as -g -o integer_to_string.o integer_to_string.s

integer_divide.o:	integer_divide.s
	as -g -o integer_divide.o integer_divide.s

read_write_string.o:	read_write_string.s
	as -g -o read_write_string.o read_write_string.s

clean:	
	rm calendar *.o
