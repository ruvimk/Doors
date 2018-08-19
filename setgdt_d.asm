;; Segment Descriptor: 
;;  	Byte 0 (starting from): 
;;  		Bits 0..15		Segment Limit 0..15 
;;  		Bits 16..31		Base Address 0..15 
;;  	Byte 4 (starting from): 
;;  		Bits 0..7		Base Address 16..23 
;;  		Bits 8..11		Type (segment type) 
;;  		Bit 12  		S (descriptor type) (0=system;1=code/data;) 
;;  		Bits 13..14		DPL (descriptor privilege level) 
;;  		Bit 15  		P (segment present) 
;;  		Bits 16..19		Segment Limit 16..19 
;;  		Bit 20  		AVL (available for system use) 
;;  		Bit 21  		0 
;;  		Bit 22  		D / B (default operation size) (0=16-bit;1=32-bit;) 
;;  		Bit 23  		G (granularity) 
;;  		Bits 24..31		Base Address 24..31 
;; .....  

;; TSS Descriptor: 
;;  D / B (bit 22) = 0 
;;  S (bit 12)     = 0 
;;  Type (8..11)   = 10B1, where B is busy flag 

;; SetGDTdesc() 
;; params: 
;;  	pGDT:DWORD	Pointer to the GDT. 
;;  	iGDT:DWORD	Index into the GDT. 
;;  	bGDT:DWORD	Base address for the segment. 
;;  	lGDT:DWORD	Limit value for the segment. 
;;  	sGDT:DWORD	Type of segment (ie code, data, ...; use types from header;) 
;;  	fGDT:DWORD	Flags:  Bits (0=16-bit;1=32-bit;) and Type (00b=system;10b=code/data;) and Segment Present (000b=false;100b=true;) 
;;  					and AVL (Available for use by system software) (0000b=false;1000b=true;) 
;;  	vGDT:DWORD	DPL (Descriptor Privilege Level) 
;; return: 
;;  	pDSC:DWORD	Pointer to the descriptor. 
;; .....  
SetGDTdesc: 
	enter 4, 0 
	push ebx 
	
	mov dword [ebp-4], 0 
	
	;; Get the address of the descriptor. 
	mov eax, dword [ebp+12] 
	shl eax, 3 
	add eax, dword [ebp+08] 
	mov ebx, eax 
	
	;; Clear the table descriptor. 
	mov dword [ebx+00], 0 
	mov dword [ebx+04], 0 
	
	;; Check to see if we need to set the granularity flag. 
	mov eax, dword [ebp+20] 
	cmp eax, 1<<19                 ;; Less than 2^19? 
	jl .over1 
		;; num<<24 = num / 4096 (4 KB) 
		shr eax, 12 
		push eax 
			;; Set the granularity flag. 
			mov eax, dword [ebp-4] 
			or eax, 100000000000000000000000b 
			mov dword [ebp-4], eax 
		pop eax 
	.over1: 
	mov word [ebx+00], ax 
	
	;; EAX still has the higher-order part of the segment limit. 
	and eax, 1111b<<16 
	or dword [ebp-4], eax 
	
	;; The base address. 
	mov eax, dword [ebp+16] 
	mov word [ebx+02], ax 
	shr eax, 16 
	mov byte [ebx+04], al 
	mov byte [ebx+07], ah 
	
	;; Check whether it's 16- or 32-bit. 
	mov eax, dword [ebp+28] 
	and eax, 1b 
	shl eax, 22 
	or dword [ebp-4], eax 
	
	;; Check the S flag. 
	mov eax, dword [ebp+28] 
	and eax, 10b 
	shl eax, 12 - 1 
	or dword [ebp-4], eax 
	
	;; Get the descriptor privilege level. 
	mov eax, dword [ebp+32] 
	and eax, 11b                   ;; Make sure it's 2 bits in size. 
	shl eax, 13                    ;; The DPL field starts from bit 13. 
	or dword [ebp-4], eax 
	
	;; Check the P (segment present) flag. 
	mov eax, dword [ebp+28] 
	and eax, 100b 
	shl eax, 15 - 2 
	or dword [ebp-4], eax 
	
	;; Check the AVL (available for use by system software) flag. 
	mov eax, dword [ebp+28] 
	and eax, 1000b 
	shl eax, 20 - 3 
	or dword [ebp-4], eax 
	
	;; Check the type (code? data?) 
	mov eax, dword [ebp+24] 
	shl eax, 8 
	or dword [ebp-4], eax 
	
	;; Now store the [ebp-4] field into the table. 
	mov eax, dword [ebx+4] 
	or eax, dword [ebp-4] 
	mov dword [ebx+4], eax 
	
	;; Return the address of the descriptor. 
	mov eax, ebx 
	
	pop ebx 
	leave 
ret 28 