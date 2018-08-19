

;; ata32.asm - ATA PIO Mode Function Library 
;;  Functions: 
;;  	ataReadSectors (startingPort:DWORD, lbaStart:DWORD, lbaStartHigh:DWORD, sectorCount:DWORD, pBuffer:DWORD, use_master?:DWORD) 
;;  	ataWriteSectors (startingPort:DWORD, lbaStart:DWORD, lbaStartHigh:DWORD, sectorCount:DWORD, pBuffer:DWORD, use_master?:DWORD) 
;;  	ataReset (startingPort:DWORD) 
;;  	ataCacheFlush (startingPort:DWORD) 

ERR_GREATERTHAN2GB                       equ  1 
ERR_NOTREADY                             equ  2 
ERR_ERROR                                equ  3 
ERR_GREATERTHAN1000SECTORS               equ  4 

ATA_READ_SECTORS                         equ  0x20 
ATA_READ_SECTORS_EXT                     equ  0x24 
ATA_WRITE_SECTORS                        equ  0x30 
ATA_WRITE_SECTORS_EXT                    equ  0x34 
ATA_CACHE_FLUSH                          equ  0xE7 

ataReadSectors:          ;;  params:  startingPort:DWORD, lbaStart:DWORD, lbaStartHigh:DWORD, sectorCount:DWORD, pBuffer:DWORD, use_master?:DWORD 
	enter 20, 0 
	
	mov eax, dword [ebp+28] 
	cmp eax, 0 
	jnz .use_master_1 
	jmp .use_master_0 
	.use_master_1: 
		mov dword [ebp-4], 0xE0 
		jmp .use_master_over 
	.use_master_0: 
		mov dword [ebp-4], 0xF0 
		jmp .use_master_over 
	.use_master_over: 
	
	mov eax, dword [ebp+12] 
	mov dword [ebp-16], eax 
	mov eax, dword [ebp+16] 
	mov dword [ebp-20], eax 
	
	mov eax, dword [ebp+20] 
	mov dword [ebp-12], eax 
	
	mov eax, dword [ebp+20] 
	cmp eax, 0x3FFFFF 
	jg .gt2gb 
	
	mov eax, dword [ebp+20] 
	cmp eax, 256 
	jg .gt256err 
	
	
	in al, dx 
	test al, 0x88 
	jz .status_ok 
	
	push dword [ebp+8] 
	call ataReset 
	
	in al, dx 
	test al, 0x88 
	jz .status_ok 
	
	mov dword [ataLastError], ERR_NOTREADY 
	mov eax, -1 
	jmp .finish 
	
	.status_ok: 
	
	cmp dword [ebp+16], 0 
	jnz .use48 
	
	mov eax, dword [ebp+12] 
	add eax, dword [ebp+20] 
	jo .use48 
	
	mov eax, dword [ebp+20] 
	cmp eax, 256 
	jg .use48 
	
	.use28: 
		
		; mov eax, dword [ebp+20] 
		; mov ecx, eax 
		; .lp28_1: 
			; jecxz .lp28_1s 
			
			; call .pio28r 
			
			; jmp .lp28_1 
		; .lp28_1s: 
		
		call .pio28r 
		
		jmp .useFinish 
	.use48: 
		
		; mov eax, dword [ebp+20] 
		; mov ecx, eax 
		; .lp48_1: 
			; jecxz .lp48_1s 
			
			; call .pio48r 
			
			; jmp .lp48_1 
		; .lp48_1s: 
		
		mov eax, dword [ebp+20] 
		cmp eax, 0x10000 
		jg .gt10000err 
		
		call .pio48r 
		
		jmp .useFinish 
	.useFinish: 
	
	mov dword [ataLastError], 0 
	xor eax, eax 
	jmp .finish 
	
	.pio28r: 
		mov eax, dword [ebp+24] 
		mov ebx, eax 
		
		mov ax, word [ebp+8] 
		mov dx, ax 
		or dx, 2 
		
		mov al, byte [ebp-12] 
		out dx, al 
		
		mov al, byte [ebp-16] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp-15] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp-14] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp-13] 
		inc dx 
		and al, 0x0F 
		or eax, dword [ebp-4] 
		out dx, al 
		
		mov al, ATA_READ_SECTORS 
		inc dx 
		out dx, al 
		
		in al, dx 
		in al, dx 
		in al, dx 
		in al, dx 
		
		jmp .pio28r_lp1 
		
		.pio28r_lp1: 
			in al, dx 
			
			test al, 0x80         ;; BSY 
			jnz .pio28r_retry 
			
			test al, 0x08         ;; DRQ 
			jnz .pio28r_data_ready 
			
			test al, 0x21 
			jnz .pio28r_error 
			
			jmp .pio28r_retry 
		.pio28r_retry: 
			dec ecx 
			jmp .pio28r_lp1 
		.pio28r_error: 
			mov dword [ataLastError], ERR_ERROR 
			mov eax, -1 
			jmp .finish 
		.pio28r_data_ready: 
		
		sub dx, 7 
		
		mov cx, 256 
		.pio28r_lp2: 
			jcxz .pio28r_lp2s 
			
			in ax, dx 
			mov word [ebx], ax 
			
			add ebx, 2 
			dec cx 
			jmp .pio28r_lp2 
		.pio28r_lp2s: 
		
		or dx, 7 
		in al, dx 
		in al, dx 
		in al, dx 
		in al, dx 
		
		inc dword [ebp-16] 
		dec dword [ebp-12] 
		
		cmp byte [ebp-12], 0 
		jnz .pio28r_lp1 
		
		in al, dx 
		
		sub dx, 7 
		
		test al, 0x21 
		jnz .pio28r_error 
		
		mov dword [ataLastError], 0 
		xor eax, eax 
		jmp .finish 
	;; .....  
	
	.pio48r: 
		mov eax, dword [ebp+24] 
		mov ebx, eax 
		
		mov eax, dword [ebp-4] 
		sub eax, 0xA0 
		mov dword [ebp-4], eax 
		
		mov ecx, eax 
		mov eax, dword [ebp+8] 
		mov edx, eax 
		mov eax, ecx 
		
		add dx, 6 
		out dx, al 
		sub dx, 6 
		
		add dx, 2 
		mov al, byte [ebp+21] 
		out dx, al 
		
		mov al, byte [ebp+12+3] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp+12+4] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp+12+5] 
		inc dx 
		out dx, al 
		
		mov eax, dword [ebp+8] 
		mov edx, eax 
		
		add dx, 2 
		
		mov al, byte [ebp+20] 
		out dx, al 
		
		mov al, byte [ebp+12+0] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp+12+1] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp+12+2] 
		inc dx 
		out dx, al 
		
		mov eax, dword [ebp+8] 
		mov edx, eax 
		
		add dx, 7 
		mov al, ATA_READ_SECTORS_EXT 
		out dx, al 
		
		in al, dx 
		in al, dx 
		in al, dx 
		in al, dx 
		
		jmp .pio48r_lp1 
		
		.pio48r_lp1: 
			in al, dx 
			
			test al, 0x80         ;; BSY 
			jnz .pio48r_retry 
			
			test al, 0x08         ;; DRQ 
			jnz .pio48r_data_ready 
			
			test al, 0x21 
			jnz .pio48r_error 
			
			jmp .pio48r_retry 
		.pio48r_retry: 
			dec ecx 
			jmp .pio48r_lp1 
		.pio48r_error: 
			mov dword [ataLastError], ERR_ERROR 
			mov eax, -1 
			jmp .finish 
		.pio48r_data_ready: 
		
		sub dx, 7 
		
		mov cx, 256 
		.pio48r_lp2: 
			jcxz .pio48r_lp2s 
			
			in ax, dx 
			mov word [ebx], ax 
			
			add ebx, 2 
			dec cx 
			jmp .pio48r_lp2 
		.pio48r_lp2s: 
		
		or dx, 7 
		in al, dx 
		in al, dx 
		in al, dx 
		in al, dx 
		
		inc dword [ebp-16] 
		dec dword [ebp-12] 
		
		cmp word [ebp-12], 0 
		jnz .pio48r_lp1 
		
		in al, dx 
		
		sub dx, 7 
		
		test al, 0x21 
		jnz .pio48r_error 
		
		mov dword [ataLastError], 0 
		xor eax, eax 
		jmp .finish 
	;; .....  
	
	.gt2gb: 
		mov dword [ataLastError], ERR_GREATERTHAN2GB 
		mov eax, -1 
		jmp .finish 
	.gt10000err: 
		mov dword [ataLastError], ERR_GREATERTHAN10000SECTORS 
		mov eax, -1 
		jmp .finish 
	.finish: 
	
	leave 
ret 24 

ataWriteSectors:         ;;  params:  startingPort:DWORD, lbaStart:DWORD, lbaStartHigh:DWORD, sectorCount:DWORD, pBuffer:DWORD, use_master?:DWORD 
	enter 20, 0 
	
	mov eax, dword [ebp+28] 
	cmp eax, 0 
	jnz .use_master_1 
	jmp .use_master_0 
	.use_master_1: 
		mov dword [ebp-4], 0xE0 
		jmp .use_master_over 
	.use_master_0: 
		mov dword [ebp-4], 0xF0 
		jmp .use_master_over 
	.use_master_over: 
	
	mov eax, dword [ebp+12] 
	mov dword [ebp-16], eax 
	mov eax, dword [ebp+16] 
	mov dword [ebp-20], eax 
	
	mov eax, dword [ebp+20] 
	mov dword [ebp-12], eax 
	
	mov eax, dword [ebp+20] 
	cmp eax, 0x3FFFFF 
	jg .gt2gb 
	
	mov eax, dword [ebp+20] 
	cmp eax, 256 
	jg .gt256err 
	
	
	in al, dx 
	test al, 0x88 
	jz .status_ok 
	
	push dword [ebp+8] 
	call ataReset 
	
	in al, dx 
	test al, 0x88 
	jz .status_ok 
	
	mov dword [ataLastError], ERR_NOTREADY 
	mov eax, -1 
	jmp .finish 
	
	.status_ok: 
	
	cmp dword [ebp+16], 0 
	jnz .use48 
	
	mov eax, dword [ebp+12] 
	add eax, dword [ebp+20] 
	jo .use48 
	
	mov eax, dword [ebp+20] 
	cmp eax, 256 
	jg .use48 
	
	.use28: 
		
		; mov eax, dword [ebp+20] 
		; mov ecx, eax 
		; .lp28_1: 
			; jecxz .lp28_1s 
			
			; call .pio28r 
			
			; jmp .lp28_1 
		; .lp28_1s: 
		
		call .pio28r 
		
		jmp .useFinish 
	.use48: 
		
		; mov eax, dword [ebp+20] 
		; mov ecx, eax 
		; .lp48_1: 
			; jecxz .lp48_1s 
			
			; call .pio48r 
			
			; jmp .lp48_1 
		; .lp48_1s: 
		
		mov eax, dword [ebp+20] 
		cmp eax, 0x10000 
		jg .gt10000err 
		
		call .pio48r 
		
		jmp .useFinish 
	.useFinish: 
	
	mov dword [ataLastError], 0 
	xor eax, eax 
	jmp .finish 
	
	.pio28r: 
		mov eax, dword [ebp+24] 
		mov ebx, eax 
		
		mov ax, word [ebp+8] 
		mov dx, ax 
		or dx, 2 
		
		mov al, byte [ebp-12] 
		out dx, al 
		
		mov al, byte [ebp-16] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp-15] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp-14] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp-13] 
		inc dx 
		and al, 0x0F 
		or eax, dword [ebp-4] 
		out dx, al 
		
		mov al, ATA_WRITE_SECTORS 
		inc dx 
		out dx, al 
		
		in al, dx 
		in al, dx 
		in al, dx 
		in al, dx 
		
		jmp .pio28r_lp1 
		
		.pio28r_lp1: 
			in al, dx 
			
			test al, 0x80         ;; BSY 
			jnz .pio28r_retry 
			
			test al, 0x08         ;; DRQ 
			jnz .pio28r_data_ready 
			
			test al, 0x21 
			jnz .pio28r_error 
			
			jmp .pio28r_retry 
		.pio28r_retry: 
			dec ecx 
			jmp .pio28r_lp1 
		.pio28r_error: 
			mov dword [ataLastError], ERR_ERROR 
			mov eax, -1 
			jmp .finish 
		.pio28r_data_ready: 
		
		sub dx, 7 
		
		mov cx, 256 
		.pio28r_lp2: 
			jcxz .pio28r_lp2s 
			
			mov ax, word [ebx] 
			out dx, ax 
			
			add ebx, 2 
			dec cx 
			jmp .pio28r_lp2 
		.pio28r_lp2s: 
		
		or dx, 7 
		in al, dx 
		in al, dx 
		in al, dx 
		in al, dx 
		
		inc dword [ebp-16] 
		dec dword [ebp-12] 
		
		cmp byte [ebp-12], 0 
		jnz .pio28r_lp1 
		
		in al, dx 
		
		sub dx, 7 
		
		test al, 0x21 
		jnz .pio28r_error 
		
		mov dword [ataLastError], 0 
		xor eax, eax 
		jmp .finish 
	;; .....  
	
	.pio48r: 
		mov eax, dword [ebp+24] 
		mov ebx, eax 
		
		mov eax, dword [ebp-4] 
		sub eax, 0xA0 
		mov dword [ebp-4], eax 
		
		mov ecx, eax 
		mov eax, dword [ebp+8] 
		mov edx, eax 
		mov eax, ecx 
		
		add dx, 6 
		out dx, al 
		sub dx, 6 
		
		add dx, 2 
		mov al, byte [ebp+21] 
		out dx, al 
		
		mov al, byte [ebp+12+3] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp+12+4] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp+12+5] 
		inc dx 
		out dx, al 
		
		mov eax, dword [ebp+8] 
		mov edx, eax 
		
		add dx, 2 
		
		mov al, byte [ebp+20] 
		out dx, al 
		
		mov al, byte [ebp+12+0] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp+12+1] 
		inc dx 
		out dx, al 
		
		mov al, byte [ebp+12+2] 
		inc dx 
		out dx, al 
		
		mov eax, dword [ebp+8] 
		mov edx, eax 
		
		add dx, 7 
		mov al, ATA_WRITE_SECTORS_EXT 
		out dx, al 
		
		in al, dx 
		in al, dx 
		in al, dx 
		in al, dx 
		
		jmp .pio48r_lp1 
		
		.pio48r_lp1: 
			in al, dx 
			
			test al, 0x80         ;; BSY 
			jnz .pio48r_retry 
			
			test al, 0x08         ;; DRQ 
			jnz .pio48r_data_ready 
			
			test al, 0x21 
			jnz .pio48r_error 
			
			jmp .pio48r_retry 
		.pio48r_retry: 
			dec ecx 
			jmp .pio48r_lp1 
		.pio48r_error: 
			mov dword [ataLastError], ERR_ERROR 
			mov eax, -1 
			jmp .finish 
		.pio48r_data_ready: 
		
		sub dx, 7 
		
		mov cx, 256 
		.pio48r_lp2: 
			jcxz .pio48r_lp2s 
			
			mov ax, word [ebx] 
			out dx, ax 
			
			add ebx, 2 
			dec cx 
			jmp .pio48r_lp2 
		.pio48r_lp2s: 
		
		or dx, 7 
		in al, dx 
		in al, dx 
		in al, dx 
		in al, dx 
		
		inc dword [ebp-16] 
		dec dword [ebp-12] 
		
		cmp word [ebp-12], 0 
		jnz .pio48r_lp1 
		
		in al, dx 
		
		sub dx, 7 
		
		test al, 0x21 
		jnz .pio48r_error 
		
		mov dword [ataLastError], 0 
		xor eax, eax 
		jmp .finish 
	;; .....  
	
	.gt2gb: 
		mov dword [ataLastError], ERR_GREATERTHAN2GB 
		mov eax, -1 
		jmp .finish 
	.gt10000err: 
		mov dword [ataLastError], ERR_GREATERTHAN10000SECTORS 
		mov eax, -1 
		jmp .finish 
	.finish: 
	
	mov dword [ebp-4], eax 
		push dword [ebp+8] 
		call ataCacheFlush 
	mov eax, dword [ebp-4] 
	
	leave 
ret 24 

ataReset:                ;;  params:  startingPort:DWORD 
	enter 0, 0 
	
	mov eax, dword [ebp+8] 
	mov edx, eax 
	
	mov al, 4 
	out dx, al 
	xor eax, eax 
	out dx, al 
	
	in al, dx 
	in al, dx 
	in al, dx 
	in al, dx 
	
	.lp1: 
	in al, dx 
	and al, 0xC0 
	cmp al, 0x40 
	jnz .lp1 
	
	xor eax, eax 
	leave 
ret 4 

ataCacheFlush:           ;;  params:  startingPort:DWORD 
	enter 0, 0 
	
	mov eax, dword [ebp+8] 
	mov edx, eax 
	
	add dx, 7 
	mov al, ATA_CACHE_FLUSH 
	out dx, al 
	
	in al, dx 
	in al, dx 
	in al, dx 
	in al, dx 
	
	xor eax, eax 
	in al, dx 
	
	leave 
ret 4 

ataLastError: 
dd 0x00 

