;; FillMemory() 
;;  	parameters: 
;;  		pMem:DWORD	Pointer to the memory to fill. 
;;  		sMem:DWORD	The size of the memory buffer. 
;;  		fMem:DWORD	The value to set the memory buffer to. 
;;  	return: 
;;  		pMem:DWORD	The pointer to the memory buffer, same as first argument. 
;; .....  
FillMemory: 
	enter 0, 0 
	push ebx 
	push ecx 
	
	mov eax, dword [ebp+8] 
	mov ebx, eax 
	
	mov eax, dword [ebp+12] 
	mov ecx, eax 
	
	mov eax, dword [ebp+16] 
	.lp1: 
		sub ecx, 4 
		jl .lp2b 
		
		mov dword [ebx], eax 
		
		add ebx, 4 
		jmp .lp1 
	.lp2b: add ecx, 4 
	.lp2: 
		sub ecx, 2 
		jl .lp3b 
		
		mov word [ebx], ax 
		
		add ebx, 2 
		jmp .lp2 
	.lp3b: mov byte [ebx], al 
	
	pop ecx 
	pop ebx 
	mov eax, dword [ebp+8] 
	leave 
ret 12 