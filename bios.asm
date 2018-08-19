ORG 0x7C00 + 8 
USE16 

dw biosGetParameters 
dw biosDOS2BIOSnotation 

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
	enter 16 + 4 + 2, 0 
	
	push bx 
	
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
	mov word [bp-20], ax 
	mov word [bp-18], dx 
	
	lea bx, [bp-16] 
	
	.lp1: 
		lea ax, [bp-16+6] 
		cmp ax, bx 
		jng .lp1s 
		
		mov ax, word [bp-22] 
		mov cx, ax 
		
		mov ax, word [ss:bx] 
		mul cx 
		mov cx, ax 
		
		mov ax, word [bp-20] 
		mov dx, word [bp-18] 
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
		mov ax, word [bp-20] 
		mov dx, word [bp-18] 
		div cx 
		mov word [bp-08], ax 
		
		mov cx, ax 
		mov ax, word [bp-06] 
		mul cx 
		neg ax 
		add word [bp-22], ax 
		
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