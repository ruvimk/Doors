

;; ata32.asm - ATA PIO Mode Function Library 
;;  Functions: 
;;  	ataReadSectors (startingPort:DWORD, lbaStart:DWORD, lbaStartHigh:DWORD, sectorCount:DWORD, pBuffer:DWORD, use_master?:DWORD) 
;;  	ataWriteSectors (startingPort:DWORD, lbaStart:DWORD, lbaStartHigh:DWORD, sectorCount:DWORD, pBuffer:DWORD, use_master?:DWORD) 
;;  	ataReset (startingPort:DWORD) 
;;  	ataCacheFlush (startingPort:DWORD) 

ERROR_SUCCESS                            equ  0 
ERROR_INVALID_DRIVE                      equ  15 
ERROR_WRITE_FAULT                        equ  29 
ERROR_READ_FAULT                         equ  30 

ATA_READ_SECTORS                         equ  0x20 
ATA_READ_SECTORS_EXT                     equ  0x24 
ATA_WRITE_SECTORS                        equ  0x30 
ATA_WRITE_SECTORS_EXT                    equ  0x34 
ATA_CACHE_FLUSH                          equ  0xE7 

SOME_NUMBER_01                           equ  10000 


ataCore: 
	ret 
	.ReadTransfer: 
		;; Native access only. 
		;; params:  b, count, buff 
		;; vars:    a, i, j, p 
		enter 0, 0 
		pusha 
			
			xor esi, esi 
			.rt_lp1: 
				mov eax, esi 
				cmp eax, dword [ebp+12] 
				jnl .rt_lp1s 
				
				mov eax, dword [ebp+08] 
				;;mov bx, ax 
				mov cx, ax 
				
				.rt_lp1a: 
					mov dx, cx 
					add dx, 7 
					in al, dx 
					cmp al, 0x48 
					jz .rt_lp1as 
					
					sub al, 0 
					jnz .rt_lp1a_over1 
						mov dword [ataLastError], ERROR_INVALID_DRIVE 
						jmp .rt_ret0 
					.rt_lp1a_over1: 
					
					mov ah, al 
					and al, 0x01 
					and ah, 0x10 
					or al, ah 
					sub al, 0 
					jnz .rt_lp1a_over2 
						mov dword [ataLastError], ERROR_READ_FAULT 
						jmp .rt_ret0 
					.rt_lp1a_over2: 
					
					nop 
					
					jmp .rt_lp1a 
				.rt_lp1as: 
				
				mov eax, dword [ebp+16] 
				mov ebx, eax 
				xor edi, edi 
				.rt_lp1b: 
					cmp edi, 256 
					jnl .rt_lp1bs 
					
					mov dx, cx 
					in ax, dx 
					mov word [ebx], ax 
					
					add ebx, 2 
					
					inc edi 
					jmp .rt_lp1b 
				.rt_lp1bs: 
				
				mov dx, cx 
				add dx, 7 
				in al, dx 
				in al, dx 
				in al, dx 
				in al, dx 
				in al, dx 
				
				inc esi 
				jmp .rt_lp1 
			.rt_ret0: 
				mov dword [ebp-4], 0 
				popa 
				leave 
				ret 12 
			.rt_lp1s: 
			
		popa 
		leave 
		mov eax, 1 
	ret 12 
	.WriteTransfer: 
		;; Native access only. 
		;; params:  b, count, buff 
		;; vars:    a, i, j, p 
		enter 0, 0 
		pusha 
			
			xor esi, esi 
			.wt_lp1: 
				mov eax, esi 
				cmp eax, dword [ebp+12] 
				jnl .wt_lp1s 
				
				mov eax, dword [ebp+08] 
				mov cx, ax 
				
				.wt_lp1a: 
					mov dx, cx 
					add dx, 7 
					in al, dx 
					cmp al, 0x48 
					jz .wt_lp1as 
					
					sub al, 0 
					jnz .wt_lp1a_over1 
						mov dword [ataLastError], ERROR_INVALID_DRIVE 
						jmp .rt_ret0 
					.wt_lp1a_over1: 
					
					mov ah, al 
					and al, 0x01 
					and ah, 0x10 
					or al, ah 
					sub al, 0 
					jnz .wt_lp1a_over2 
						mov dword [ataLastError], ERROR_WRITE_FAULT 
						jmp .rt_ret0 
					.wt_lp1a_over2: 
					
					nop 
					
					jmp .wt_lp1a 
				.wt_lp1as: 
				
				mov eax, dword [ebp+16] 
				mov ebx, eax 
				xor edi, edi 
				.wt_lp1b: 
					cmp edi, 256 
					jnl .wt_lp1bs 
					
					mov ax, word [ebx] 
					
					mov dx, cx 
					out dx, ax 
					
					add ebx, 2 
					
					inc edi 
					jmp .wt_lp1b 
				.wt_lp1bs: 
				
				mov dx, cx 
				add dx, 7 
				in al, dx 
				in al, dx 
				in al, dx 
				in al, dx 
				in al, dx 
				
				inc esi 
				jmp .wt_lp1 
			.wt_lp1s: 
			
		popa 
		leave 
		mov eax, 1 
	ret 12 
.end_of_function: 

ataReadData:                             ;;  params:  drive, start, start_high, count, buffer 
	enter 0, 0 
	pusha 
	;; vars:     b, count, top_4 
	
	
	
	popa 
	leave 
ret 20 

ataResetController: 
	enter 0, 0 
	
	mov eax, dword [ataStartPort] 
	mov edx, eax 
	
	add eax, 0x200 
	mov ebx, eax 
	
	mov dx, bx 
	add dx, 6 
	in al, dx 
	or al, 0x04 
	out dx, al 
	
	and al, 0xFB 
	out dx, al 
	
	xor eax, eax 
	leave 
ret 

ataCacheFlush: 
	enter 0, 0 
	
	mov eax, dword [ataStartPort] 
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
ret 

ataEnableInterrupts:      ;;  params:  state 
	push edx 
	push ebx 
	
	mov eax, dword [ataStartPort] 
	mov edx, eax 
	add eax, 0x200 
	mov ebx, eax 
	
	mov dx, bx 
	add dx, 6 
	in al, dx 
	mov bl, al 
	
	mov eax, dword [esp+12] 
	sub eax, 0 
	jnz .enable 
	jmp .disable 
	.enable: 
		mov al, bl 
		and al, 0xFD 
		jmp .finish 
	.diable: 
		mov al, bl 
		or al, 0x02 
		jmp .finish 
	.finish: 
	out dx, al 
	pop ebx 
	pop edx 
ret 4 

ataSelectController:       ;;  params:  controllerNumber 
	mov eax, dword [esp+4] 
	cmp eax, 1 
	jz .c1 
	cmp eax, 2 
	jz .c2 
	ret 4 
	.c1: 
		mov dword [ataStartPort], 0x1F0 
		ret 4 
	.c2: 
		mov dword [ataStartPort], 0x170 
		ret 4 
.returned: 



ataLastError: 
dd 0x00 

ataStartPort: 
dd 0x1F0 

