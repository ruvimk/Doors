str2i_new: 
	enter 4, 0 
	push ecx 
	push edx 
	push ebx 
	push esi 
	
	xor eax, eax 
	mov esi, eax 
	
	;; Skip over any leading spaces. 
	mov eax, dword [ebp+8] 
	mov ebx, eax 
	dec ebx 
	.lbl1: 
	inc ebx 
	cmp byte [ebx], 0 
	jz .str2i_z 
	cmp byte [ebx], 32 
	jz .lbl1 
	cmp byte [ebx], 9 
	jz .lbl1 
	cmp byte [ebx], 13 
	jz .lbl1 
	cmp byte [ebx], 10 
	jz .lbl1 
	
	cmp byte [ebx], 48 
	jl .str2i_z 
	cmp byte [ebx], 58 
	jnl .str2i_z 
	
	mov eax, ebx 
	mov dword [ebp-4], eax 
	
	;; Get 10^(however many digits there are (for the integer part only)). 
	mov ecx, 10 
	mov eax, 1 
	.lp1: 
		cmp byte [ebx], 48 
		jl .lp1s 
		cmp byte [ebx], 58 
		jnl .lp1s 
		
		mul ecx 
		
		inc ebx 
		jmp .lp1 
	.lp1s: 
	div ecx 
	
	mov ecx, eax 
	mov eax, dword [ebp-4] 
	mov ebx, eax 
	.lp2: 
		;; ESI += ([EBX] - 48) * ECX 
		xor eax, eax 
		mov al, byte [ebx] 
		sub al, 48 
		mul ecx 
		add esi, eax 
		
		;; ECX /= 10 
		mov eax, ecx 
		xor edx, edx 
		mov ecx, 10 
		div ecx 
		mov ecx, eax 
		
		inc ebx 
		
		jecxz .lp2s 
		jmp .lp2 
	.lp2s: 
	
	jmp .finish 
	
	.str2i_z: 
	xor eax, eax 
	pop esi 
	pop ebx 
	pop edx 
	pop ecx 
	leave 
	ret 4 
	
	.finish: 
	
	;; return ESI 
	mov eax, esi 
	
	pop esi 
	pop ebx 
	pop edx 
	pop ecx 
	leave 
ret 4 

atoi: 
	enter 0, 0 
	push ebx 
	
	;; Skip over any leading spaces. 
	mov eax, dword [ebp+8] 
	mov ebx, eax 
	dec ebx 
	.lbl1: 
	inc ebx 
	cmp byte [ebx], 0 
	jz .atoi_z 
	cmp byte [ebx], 45 
	jz .lbl3negative 
	cmp byte [ebx], 48 
	jl .lbl1 
	cmp byte [ebx], 58 
	jnl .lbl1 
	
	.lbl3: 
		cmp byte [ebx], 45 
		jz .lbl3negative 
		
		push ebx 
		call str2i_new 
		jmp .finish 
	.lbl3negative: 
	inc ebx 
	push ebx 
	call atoi 
	neg eax 
	jmp .finish 
	
	.atoi_z: 
	xor eax, eax 
	pop ebx 
	leave 
	ret 4 
	
	.finish: 
	
	pop ebx 
	leave 
ret 4 