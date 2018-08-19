;; SetGate() 
;;  	params: 
;;  		pTbl:DWORD	Pointer to the table. 
;;  		iTbl:DWORD	Index to the gate. 
;;  		sTbl:DWORD	Segment Selector (/ TSS Segment Selector) 
;;  		oTbl:DWORD	Offset 
;;  		tTbl:DWORD	Type Of Gate (ie task, interrupt, trap; refer to header;) 
;;  		lTbl:DWORD	DPL (Descriptor Privilege Level) 
;;  		bTbl:DWORD	Flags:  Size Of Gate (D) (0=16-bit;1=32-bit;) and Segment Present (P) (00b=gone;10b=present;) 
;;  	return: 
;;  		pEnt:DWORD	Pointer to the gate entry in the table. 
;; .....  
SetGate: 
	enter 4, 0 
	push ebx 
	
	mov dword [ebp-4], 0 
	
	;; Get the address of the descriptor in the table. 
	mov eax, dword [ebp+8] 
	mov ebx, eax 
	mov eax, dword [ebp+12] 
	dec al 
	shl eax, 3 
	add ebx, eax 
	
	;; Clear the descriptor. 
	xor eax, eax 
	mov dword [ebx+00], eax 
	mov dword [ebx+04], eax 
	
	;; Set the segment selector. 
	mov ax, word [ebp+16] 
	mov word [ebx+02], ax 
	
	;; Set the offset. 
	mov eax, dword [ebp+20] 
	mov word [ebx+00], ax 
	shr eax, 16 
	mov word [ebx+06], ax 
	
	;; Set the DPL. 
	mov eax, dword [ebp+28] 
	and eax, 11b 
	shl eax, 13 
	or dword [ebp-4], eax 
	
	;; Check present (P). 
	mov eax, dword [ebp+32] 
	and eax, 10b 
	shl eax, 15 - 1 
	or dword [ebp-4], eax 
	
	;; Check size of gate (D). 
	mov eax, dword [ebp+32] 
	and eax, 01b 
	shl eax, 3 
	or eax, dword [ebp+24] 
	shl eax, 8 
	or dword [ebp-4], eax 
	
	;; Copy the part of the descriptor. 
	mov eax, dword [ebp-4] 
	or dword [ebx+04], eax 
	
	;; Return the address of the gate. 
	mov eax, ebx 
	
	pop ebx 
	leave 
ret 28 