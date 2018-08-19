strcmp: 
.cd: 
	enter 0, 0 
	push edx 
	push ebx 
	
	mov eax, dword [ebp+08] 
	mov ebx, eax 
	
	mov eax, dword [ebp+12] 
	mov edx, eax 
	
	.lp1: 
		xchg ebx, edx 
		mov al, byte [ebx] 
		xchg ebx, edx 
		xchg al, ah 
		mov al, byte [ebx] 
		
		inc ebx 
		
		cmp al, ah 
		jz .lp1 
		
		cmp al, 32 
		jz .lp1z 
		cmp al, 9 
		jz .lp1z 
		cmp al, 13 
		jz .lp1z 
		cmp al, 10 
		jz .lp1z 
		cmp al, 59 
		jz .lp1z 
		
		sub al, ah 
		pop ebx 
		pop edx 
		leave 
		ret 8 
	.lp1z: 
	
	xor eax, eax 
	pop ebx 
	pop edx 
	leave 
ret 8 

