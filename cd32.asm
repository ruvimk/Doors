ORG 0x1040 
USE32 

start: 

jmp .over1 
.the_msg: 
db "Hello, this is CD32 speaking... ", 0, 0, 0, 0, 0 
.over1: 

mov ebx, 0xB8000 
mov edx, .the_msg 
.lp1: 
	mov eax, dword [edx] 
	mov dword [ebx], eax 
	sub eax, 0 
	jz .lp1s 
	
	add ebx, 4 
	add edx, 4 
	jmp .lp1 
.lp1s: 

cli 
hlt 