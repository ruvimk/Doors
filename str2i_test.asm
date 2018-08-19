extern GetStdHandle 
extern WriteFile 
extern GetCommandLineA 
extern MessageBoxA 
import GetStdHandle kernel32.dll 
import WriteFile kernel32.dll 
import GetCommandLineA kernel32.dll 
import MessageBoxA user32.dll 

section .text use32 
..start: 

call main 

ret 

main: 
	enter 4, 0 
	
	call [GetCommandLineA] 
	mov dword [ebp-4], eax 
	
	;; Skip over any spaces. 
	mov ebx, eax 
	dec ebx 
	.lbl1: 
	inc ebx 
	cmp byte [ebx], 32 
	jz .lbl1 
	cmp byte [ebx], 9 
	jz .lbl1 
	
	;; Skip over any non-spaces. 
	.lbl2: 
	cmp byte [ebx], 32 
	jz .lbl3 
	cmp byte [ebx], 9 
	jz .lbl3 
	
	inc ebx 
	jmp .lbl2 
	
	.lbl3: 
	
	push ebx 
	call atoi 
	
	cmp eax, 72 
	jz .u72 
	
	sub eax, 0 
	jnl .ok 
		mov ebx, eax 
		push dword minus 
		call output 
		mov eax, ebx 
		neg eax 
	.ok: 
	
	push dword string1 
	push eax 
	call i2str 
	
	push eax 
	call output 
	
	push dword nl 
	call output 
	
	call render 
	
	xor eax, eax 
	leave 
ret 

.u72: 
	push dword 0 
	push dword ApplicationName 
	push dword ApplicationName 
	push dword 0 
	call [MessageBoxA] 
	xor eax, eax 
	leave 
ret 

print: 
	enter 0, 0 
	pusha 
	
	xor ecx, ecx 
	mov eax, dword [ebp+8] 
	mov ebx, eax 
	.lp1: 
		cmp byte [ebx+ecx], 0 
		jz .lp1s 
		
		inc ecx 
		jmp .lp1 
	.lp1s: 
	mov dword [ebp-4], eax 
	
	push dword -11 
	call [GetStdHandle] 
	
	lea ebx, [ebp-4] 
	push dword 0 
	push ebx 
	push dword [ebp-4] 
	push dword [ebp+8] 
	push eax 
	call [WriteFile] 
	
	popa 
	leave 
ret 4 

output: 
	enter 0, 0 
	pusha 
	
	push dword [ebp+8] 
	push dword output_string 
	call strcat 
	
	popa 
	leave 
ret 4 

render: 
	enter 0, 0 
	pusha 
	
	push dword 0 
	push dword ApplicationName 
	push dword output_string 
	push dword 0 
	call [MessageBoxA] 
	
	mov ebx, output_string 
	mov byte [ebx], 0 
	
	popa 
	leave 
ret 0 

strlen: 
	enter 0, 0 
	pusha 
	
	mov eax, dword [ebp+8] 
	xor ecx, ecx 
	mov ebx, eax 
	.lp1: 
		mov al, byte [ebx+ecx] 
		cmp al, 0 
		jz .lp1s 
		
		inc ecx 
		jmp .lp1 
	.lp1s: 
	
	mov eax, ecx 
	mov dword [ebp-4], eax 
	
	popa 
	leave 
ret 4 

strcat: 
	enter 0, 0 
	pusha 
	
	mov eax, dword [ebp+8] 
	push eax 
	call strlen 
	mov ecx, eax 
	
	add eax, dword [ebp+8] 
	push dword [ebp+12] 
	push eax 
	call strcpy 
	
	popa 
	leave 
ret 8 

strcpy: 
	enter 0, 0 
	pusha 
	
	push dword [ebp+12] 
	call strlen 
	mov ecx, eax 
	
	push ecx 
	push dword [ebp+08] 
	push dword [ebp+12] 
	call MemoryCopy 
	
	popa 
	leave 
ret 8 

MemoryCopy: 
	enter 0, 0 
	pusha 
	
	mov eax, dword [ebp+08] 
	mov edx, eax 
	
	mov eax, dword [ebp+12] 
	mov ebx, eax 
	
	cmp ebx, edx 
	jg .lbl1 
	
	xor ecx, ecx 
	jmp .lp2 
	
	.lbl1: 
	mov eax, dword [ebp+16] 
	mov ecx, eax 
	.lp1: 
		dec ecx 
		
		mov al, byte [edx+ecx] 
		mov byte [ebx+ecx], al 
		
		jecxz .lp1s 
		jmp .lp1 
	.lp1s: 
	jmp .finish 
	
	.lp2: 
		mov eax, dword [ebp+16] 
		cmp eax, ecx 
		jng .lp2s 
		
		mov al, byte [edx+ecx] 
		mov byte [ebx+ecx], al 
		
		inc ecx 
		jmp .lp2 
	.lp2s: 
	jmp .finish 
	
	.finish: 
	
	popa 
	leave 
ret 12 

%include "str2i.asm" 

%include "i2str.asm" 

section .data 
ApplicationName                   db "str2i Test", 0 

minus                             db 45, 0 
nl                                db 13, 10, 0 

section .bss 
string1                           resb   512 
output_string                     resb  4096 
