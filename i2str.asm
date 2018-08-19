i2str: 
	enter 4, 0 
	push ecx 
	push edx 
	push ebx 
	push esi 
	push edi 
	
	xor eax, eax 
	mov edi, eax 
	
	mov eax, dword [ebp+08] 
	mov esi, eax 
	
	mov eax, dword [ebp+12] 
	mov ebx, eax 
	
	cmp esi, 0 
	jnl .over1 
		
		mov eax, esi 
		neg eax 
		mov esi, eax 
		
		inc ebx 
		
		mov byte [ebx], 45 
		
	.over1: 
	
	mov ecx, 10 
	xor edx, edx 
	mov eax, esi 
	.lbl1: 
	xor edx, edx 
	div ecx 
	
	inc edi 
	
	sub eax, 0 
	jnz .lbl1 
	
	add ebx, edi 
	
	mov byte [ebx], 0 
	.lp1: 
		dec ebx 
		
		mov eax, esi 
		xor edx, edx 
		mov ecx, 10 
		div ecx 
		mov esi, eax 
		
		mov eax, edx 
		add al, 48 
		mov byte [ebx], al 
		
		cmp esi, 0 
		jg .lp1 
	.lp1s: 
	
	mov eax, dword [ebp+12] 
	
	pop edi 
	pop esi 
	pop ebx 
	pop edx 
	pop ecx 
	leave 
ret 8 