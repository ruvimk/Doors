%macro fjump 2 
	db 0xEA 
	dw %2 
	dw %1 
%endmacro 

jmp "ab":"cd" 

db 0xEA 
dw 0x1234 
dw 0x5678 

fjump 0x9ABC, 0xDEF0 

nop 