%define              str1     0x7B00 

biosReadSectors:         ;;  params:  drive:WORD, wkWhere:WORD, wkLength:WORD, wkBuffer:WORD 
	enter 8 + 4, 0 
	
	push bx 
	
	mov byte [bp-8], 2 
	
	call biosReadWriteProc 
	
	pop bx 
	
	leave 
ret 8 

; biosWriteSectors:        ;;  params:  drive:WORD, wkWhere:WORD, wkLength:WORD, wkBuffer:WORD 
	; enter 8, 0 
	
	; push bx 
	
	; mov byte [bp-8], 3 
	
	; call biosReadWriteProc 
	
	; pop bx 
	
	; leave 
; ret 8 

biosReadWriteProc: 
	push word 0x7A00 
	push word [bp+4] 
	call biosGetParameters 
	
	mov ax, word [bp+10] 
	mov bx, ax 
	
	; mov ax, word [bp+6] 
	; mov si, ax 
	
	; mov ax, word [bp+8] 
	; mov di, ax 
	
	mov ax, word [bp+6] 
	mov word [bp-10], ax 
	mov si, ax 
	
	mov ax, word [bp+8] 
	mov word [bp-12], ax 
	mov di, ax 
	
	.lp1: 
		cmp di, 0 
		jz .lp1s 
		
		push word 0x7A00 
		push si 
		call biosDOS2BIOSnotation 
		
		mov ax, word [bp+4] 
		mov dl, al 
		
		mov ah, byte [bp-8] 
		mov al, 1 
		
		int 0x13 
		
		inc si 
		dec di 
		add bx, 512 
		jmp .lp1 
	.lp1s: 
ret 

biosGetParameters:       ;;  params:  drive:WORD, parameterTable:WORD 
	enter 0, 0 
	push bx 
	
	mov al, byte [bp+4] 
	mov dl, al 
	
	mov ah, 0x08 
	int 0x13 
	
	mov ax, word [bp+6] 
	mov bx, ax 
	
	xor ax, ax 
	
	mov al, dh 
	inc al 
	mov byte [bx+00], al 
	
	mov al, ch 
	inc al 
	mov byte [bx+02], al 
	
	mov al, cl 
	mov byte [bx+04], al 
	
	pop bx 
	leave 
ret 4 

biosDOS2BIOSnotation:    ;;  params:  sectorNumber:WORD, parameterTable:WORD  return:  DH=side(head), CH=track, CL=sector 
	enter 16, 0 
	
	push bx 
	
	;; debug 
		push word str1 
		push word [bp+4] 
		call i2str 
	;; .....  
	
	mov ax, word [bp+6] 
	mov bx, ax 
	
	mov ax, word [bx+00] 
	mov word [bp-16], ax 
	mov ax, word [bx+02] 
	mov word [bp-14], ax 
	mov ax, word [bx+04] 
	mov word [bp-12], ax 
	mov word [bp-10], 0 
	
	mov ax, word [bx+00] 
	mov cx, ax 
	mov ax, word [bx+02] 
	mul cx 
	mov cx, ax 
	mov ax, word [bx+04] 
	mul cx 
	mov word [bp-08], ax 
	
	lea bx, [bp-16] 
	
	.lp1: 
		lea ax, [bp-16+6] 
		cmp ax, bx 
		jng .lp1s 
		
		mov ax, word [bp+4] 
		mov cx, ax 
		
		mov ax, word [ss:bx] 
		mul cx 
		mov cx, ax 
		
		mov ax, word [bp-08] 
		xchg ax, cx 
		div cx 
			mov cx, bp 
			sub cx, 16 - 4 
			cmp bx, cx 
			jnl .lbl2 
		.lbl1: 
			sub dx, 0 
			jz .lbl3 
			
			dec ax 
			jmp .lbl3 
		.lbl2: 
			sub dx, 0 
			jnz .lbl3 
			
			inc ax 
			jmp .lbl3 
		.lbl3: 
		mov word [bp-06], ax 
		
		push ax 
		
		mov ax, word [ss:bx] 
		mov cx, ax 
		mov ax, word [bp-08] 
		div cx 
		mov word [bp-08], ax 
		
		mov cx, ax 
		mov ax, word [bp-06] 
		mul cx 
		neg ax 
		add word [bp+4], ax 
		
		add bx, 2 
		jmp .lp1 
	.lp1s: 
	
	pop ax 
	mov cl, al 
	
	pop ax 
	mov ch, al 
	
	pop ax 
	mov dh, al 
	
	pop bx 
	
	leave 
ret 4 

i2str: 
	enter 16, 0 
	
	mov ax, word [bp+4] 
	add al, 48 
	mov ah, 0x0A 
	int 0x10 
	
	mov al, "a" 
	int 0x10 
	
	mov al, 13 
	int 0x10 
	mov al, 10 
	int 0x10 
	
	leave 
	ret 4 
;; .....  

