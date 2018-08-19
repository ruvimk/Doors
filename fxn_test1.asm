extern MessageBoxA 
import MessageBoxA user32.dll 

%include "setgate.h" 
%include "setgdt_d.h" 

int_index                                  equ  7 

gdt_index                                  equ  5 

section .text use32 
..start: 

call main 

ret 

%include "setgate.asm" 
%include "setgdt_d.asm" 

main: 
	enter 0, 0 
	
	push dword 0            ;; DPL (descriptor privilege level) 
	push dword DESC_PRESENT 
	push dword PAGE_TSS 
	push dword 64 + 16 + 2  ;; Limit 
	push dword 01000001b    ;; Base address. 
	push dword gdt_index 
	push dword gdt 
	call SetGDTdesc 
	
	mov ebx, gdt 
	xor ecx, ecx 
	jmp .lp1 
	.comma: db 44, 32, 0 
	.nl:    db 13, 10, 0 
	.lp1: 
		cmp ecx, 16 
		jnl .lp1s 
		
		push dword string_01 
		push dword [ebx+(ecx*4)] 
		call i2str 
			mov edx, ebx 
		mov ebx, eax 
		mov eax, string_02 
		call StringCat 
		mov ebx, .comma 
		call StringCat 
			mov ebx, edx 
		push dword string_01 
			inc ecx 
		push dword [ebx+(ecx*4)] 
		call i2str 
			mov edx, ebx 
		mov ebx, eax 
		mov eax, string_02 
		call StringCat 
		mov ebx, .nl 
		call StringCat 
		mov ebx, edx 
		
		inc ecx 
		
		jmp .lp1 
	.lp1s: 
	
	push dword 0 
	push dword the_title 
	push dword string_02 
	push dword 0 
	call [MessageBoxA] 
	
	leave 
ret 0 

%include "/RS/include/nasm.inc" 

section .data 
the_title                          db "FXN Test 1", 0 
string_01: TIMES 512                DB 0x00 
string_02: TIMES 512                DB 0x00 
string_03: TIMES 512                DB 0x00 

section .bss 
gdt                                resq 8 
idt                                resq 8 
