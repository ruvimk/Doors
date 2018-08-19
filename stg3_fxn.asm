

; %define s3*f           stg3_fxn_*names 
; %define s3*e           stg3_fxn_*extra 

; s*3f              equ  stg3_*fxn_names 
; s*3e              equ  stg3_*fxn_extra 

;; Table with the stage 3 function entries. 
;; Entry Structure: 
;;  	* const char function_name 
;;  	* the_function 
;;  	int number_of_parameters /* with each parameter being 4 bytes */ 
;;  	int reserved /* must be 0 */ 
;; .....  
stg3_int_table: 
	dd s3f.SetGDTdesc 
	dd SetGDTdesc 
	dd 7 
	dd 0 
	
	dd s3f.SetGate 
	dd SetGate 
	dd 7 
	dd 0 
	
	dd s3f.GetMemorySize 
	dd s3e.GetMemorySize 
	dd 0 
	dd 0 
	
	dd s3f.print 
	dd s3e.print 
	dd 1 
	dd 0 
	
	dd s3f.putchar 
	dd s3e.putchar 
	dd 1 
	dd 0 
	
	dd s3f.cls 
	dd s3e.cls 
	dd 0 
	dd 0 
	
	dd s3f.GetCursor 
	dd s3e.GetCursor 
	dd 0 
	dd 0 
	
	dd s3f.SetCursor 
	dd s3e.SetCursor 
	dd 1 
	dd 0 
	
	dd s3f.stg3_fxn 
	dd stg3_fxn 
	dd 3 
	dd 0 
	
	dd s3f.stg3_free_params 
	dd stg3_free_params 
	dd 5 
	dd 0 
	
	dd s3f.StrCmp1 
	dd StrCmp1 
	dd 2 
	dd 0 
	
	dd s3f.MemoryCopy 
	dd MemoryCopy 
	dd 3 
	dd 0 
	
	dd 0 
	dd 0 
	dd 0 
	dd 0 
;; .....  

stg3_fxn_names: 
.SetGDTdesc       db "SetGDTdesc", 0 
.SetGate          db "SetGate", 0 
.CallFromUser     db "CallFromUser", 0 
.GetMemorySize    db "GetMemorySize", 0 

.print            db "print", 0 
.cls              db "cls", 0 
.putchar          db "putchar", 0 
.GetCursor        db "GetCursor", 0 
.SetCursor        db "SetCursor", 0 

.stg3_fxn         db "stg3_fxn", 0 
.stg3_free_params db "stg3_free_params", 0 
.StrCmp1          db "StrCmp1", 0 
.MemoryCopy       db "MemoryCopy", 0 

stg3_fxn_extra: 
call .over1 
db "object{stg3_fxn_extra} (native)", 13, 10, 13, 10, "Halting CPU...  ", 13, 10, 0 
.over1: 
call .print 
.over2: 
cli 
hlt 
jmp .over2 
.GetMemorySize: 
	xor eax, eax 
	mov ax, word [mem_sz_2] 
	mov ebx, eax 
	mov ax, word [mem_sz_1] 
ret 0 
.print: 
	push ebx 
	mov eax, dword [esp+8] 
	mov ebx, eax 
	xor eax, eax 
	.print.lp1: 
		cmp byte [ebx], 0 
		jz .print.lp1s 
		
		mov al, byte [ebx] 
		push eax 
		call .putchar 
		
		inc ebx 
		jmp .print.lp1 
	.print.lp1s: 
	pop ebx 
	;; Return whatever putchar() returned. 
ret 4 
.putchar: 
	push ecx 
	push edx 
	push ebx 
	
	mov ebx, 0x463 
	mov ax, word [ebx] 
	mov bx, ax 
	mov dx, ax 
	add dx, 4 
		cmp dx, 0x3D0 
		jl .putchar.monochrome 
	in al, dx 
	test al, 10b 
	jnz .putchar.notext 
	
	mov ah, 40 
	
	test al, 1 
	jnz .putchar.go_on 
	
	.putchar.monochrome: 
	mov ah, 80 
	
	.putchar.go_on: 
	mov cl, ah 
	
	mov eax, dword [esp+16] 
	cmp al, 13 
	jz .putchar.cr 
	cmp al, 10 
	jz .putchar.lf 
	
	mov dx, bx 
	xor eax, eax 
	mov al, 15 
	out dx, al 
	jmp .putchar.over1 
	.putchar.over1: 
	inc dx 
	in al, dx 
	dec dx 
	xchg al, ah 
	mov al, 14 
	out dx, al 
	jmp .putchar.over2 
	.putchar.over2: 
	inc dx 
	in al, dx 
	dec dx 
	xchg al, ah 
	
	mov ecx, eax 
	mov ebx, 0xB8000 
	mov eax, dword [esp+16] 
	mov byte [ebx+(ecx*2)], al 
	mov ebx, edx 
	
	inc ecx 
	
	mov al, 15 
	out dx, al 
	inc dx 
	mov al, cl 
	out dx, al 
	dec dx 
	
	mov al, 14 
	out dx, al 
	inc dx 
	mov al, ch 
	out dx, al 
	dec dx 
	
	mov eax, dword [esp+16] 
	jmp .putchar.finish 
	
	.putchar.cr: 
	call .GetCursor 
	xor ax, ax 
	push eax 
	call .SetCursor 
	mov eax, dword [esp+16] 
	jmp .putchar.finish 
	
	.putchar.lf: 
	call .GetCursor 
	add eax, 0x10000 
	push eax 
	call .SetCursor 
	mov eax, dword [esp+16] 
	jmp .putchar.finish 
	
	.putchar.notext: 
	xor eax, eax 
	jmp .putchar.finish 
	
	.putchar.finish: 
	
	pop ebx 
	pop edx 
	pop ecx 
ret 4 
.cls: 
	push ebx 
	xor eax, eax 
	mov ecx, 80 * 25 
	mov ah, 00001000b 
	mov ebx, 0xB8000 
	.cls.lp1: 
		jecxz .cls.lp1s 
		
		mov byte [ebx+00], al 
		
		;or byte [ebx+01], ah 
		
		mov byte [ebx+01], 00001111b 
		
		dec ecx 
		add ebx, 2 
		jmp .cls.lp1 
	.cls.lp1s: 
	push dword 0 
	call .SetCursor 
	pop ebx 
	xor eax, eax 
ret 0 
.GetCursor: 
	enter 0, 0 
	pusha 
	
	mov ebx, 0x463 
	mov ax, word [ebx] 
	mov bx, ax 
	mov dx, ax 
	
	cmp dx, 0x3D0 
	jl .GetCursor.monochrome 
	
	add dx, 4 
	in al, dx 
	test al, 10b 
	jnz .GetCursor.notext 
	
	mov ah, 40 
	
	test al, 1 
	jnz .GetCursor.go_on 
	
	.GetCursor.monochrome: 
	mov ah, 80 
	
	.GetCursor.go_on: 
	xor ecx, ecx 
	mov cl, ah 
	
	xor eax, eax 
	
	mov dx, bx 
	mov al, 15 
	out dx, al 
	inc dx 
	in al, dx 
	
	xchg al, ah 
	
	mov dx, bx 
	mov al, 14 
	out dx, al 
	inc dx 
	in al, dx 
	
	xchg al, ah 
	
	xor edx, edx 
	div ecx 
	
	shl eax, 16 
	mov ax, dx 
	mov dword [ebp-4], eax 
	
	jmp .GetCursor.finish 
	
	.GetCursor.notext: 
	xor eax, eax 
	jmp .GetCursor.finish 
	
	.GetCursor.finish: 
	
	popa 
	leave 
	;; Return:  Low-order word= cursor column; high-order word= cursor row; 
ret 0 
.SetCursor: 
	enter 0, 0 
	pusha 
	
	mov ebx, 0x463 
	mov ax, word [ebx] 
	mov bx, ax 
	mov dx, ax 
	
	cmp dx, 0x3D0 
	jl .SetCursor.monochrome 
	
	add dx, 4 
	in al, dx 
	
	test al, 10b 
	jnz .SetCursor.notext 
	
	mov ah, 40 
	
	test al, 1 
	jnz .SetCursor.go_on 
	
	.SetCursor.monochrome: 
	mov ah, 80 
	
	.SetCursor.go_on: 
	xor ecx, ecx 
	mov cl, ah 
	
	mov eax, dword [ebp+8] 
	shr eax, 16 
	mul ecx 
	mov ecx, eax 
	
	xor eax, eax 
	mov ax, word [ebp+8] 
	add eax, ecx 
	
	mov ecx, eax 
	
	mov dx, bx 
	mov al, 15 
	out dx, al 
	inc dx 
	mov al, cl 
	out dx, al 
	
	mov dx, bx 
	mov al, 14 
	out dx, al 
	inc dx 
	mov al, ch 
	out dx, al 
	
	jmp .SetCursor.finish 
	
	.SetCursor.notext: 
	xor eax, eax 
	jmp .SetCursor.finish 
	
	.SetCursor.finish: 
	
	popa 
	leave 
ret 4 

stg3_int_table_ForUser: 
	dd s3f.GetMemorySize 
	dd s3e.GetMemorySize 
	dd 0 
	dd 0 
	
	dd s3f.print 
	dd s3e.print 
	dd 1 
	dd 0 
	
	dd s3f.putchar 
	dd s3e.putchar 
	dd 1 
	dd 0 
	
	dd s3f.cls 
	dd s3e.cls 
	dd 0 
	dd 0 
	
	dd s3f.GetCursor 
	dd s3e.GetCursor 
	dd 0 
	dd 0 
	
	dd s3f.SetCursor 
	dd s3e.SetCursor 
	dd 1 
	dd 0 
	
	dd s3f.StrCmp1 
	dd StrCmp1 
	dd 2 
	dd 0 
	
	dd s3f.MemoryCopy 
	dd MemoryCopy 
	dd 3 
	dd 0 
	
	dd 0 
	dd 0 
	dd 0 
	dd 0 
;; .....  

;; stg3_int() - interrupt handler for stage 3 interrupts 
stg3_int: 
	enter 8, 0 
	
	xor eax, eax 
	str ax 
	or ax, 111b 
	sub ax, 111b 
	add eax, KERNEL_GDT 
	mov ebx, eax 
	
	call get_base_address 
	
	mov ebx, eax 
	
	mov dword [ebp-4], eax 
	
	mov eax, dword [ebx+TSS_PrevTaskLink] 
	or eax, 111b 
	sub eax, 111b 
	add eax, KERNEL_GDT 
	mov ebx, eax 
	
	call get_base_address 
	
	mov ebx, eax 
	
	mov dword [ebp-4], eax 
	
	xor eax, eax 
	mov ax, word [ebx+TSS_CS] 
	and ax, 11b 
	jnz .from_user 
	
	push ebx 
		mov eax, dword [ebx+TSS_PrevTaskLink] 
		or eax, 111b 
		sub eax, 111b 
		add eax, KERNEL_GDT 
		mov ebx, eax 
		
		call get_base_address 
		
		mov dword [ebp-8], eax 
	pop ebx 
	
	mov eax, dword [ebx+TSS_ESP] 
	mov ebx, eax 
	add ebx, 14 
	push dword s3f.CallFromUser 
	push dword [ebx] 
	call StrCmp1 
	cmp eax, 0 
	jz .from_user_2 
	
	mov eax, ebx 
	add eax, 4 
	push dword stg3_int_table 
	push eax 
	push dword [ebx] 
	call stg3_fxn 
	
	push dword [ebp-4] 
	push dword 1 
	push dword stg3_int_table 
	push dword [ebx] 
	push ebx 
	call stg3_free_params 
	
	mov eax, dword [ebp-4] 
	
	jmp .finish 
	
	.from_user: 
	mov eax, dword [ebx+TSS_ESP] 
	mov ebx, eax 
	add eax, 4 
	push dword stg3_int_table_ForUser 
	push eax 
	push dword [ebx] 
	call stg3_fxn 
	
	push dword [ebp-4] 
	push dword 1 
	push dword stg3_int_table_ForUser 
	push dword [ebx] 
	push ebx 
	call stg3_free_params 
	
	mov eax, dword [ebp-4] 
	
	jmp .finish 
	
	.from_user_2: 
	add ebx, 4 
	mov eax, dword [ebx] 
	mov ebx, eax 
	add eax, 4 
	push dword stg3_int_table_ForUser 
	push eax 
	push dword [ebx] 
	call stg3_fxn 
	
	push dword [ebp-8] 
	push dword 1 
	push dword stg3_int_table_ForUser 
	push dword [ebx] 
	push ebx 
	call stg3_free_params 
	
	mov eax, dword [ebp-8] 
	
	jmp .finish 
	
	.finish: 
	
	mov ebx, eax 
	mov eax, dword [stg3_fxn_return] 
	mov dword [ebx+TSS_EAX], eax 
	
	leave 
iret 

;; stg3_fxn() - service for calling stage 3 functions 
;; params:  pFxnName:DWORD, pParamList:DWORD, pFxnNameTable:DWORD 
stg3_fxn: 
	enter 0, 0 
	pusha 
	
	mov eax, dword [ebp+16] 
	mov ebx, eax 
	.lp1: 
		cmp dword [ebx], 0 
		jz .lp1e 
		
		push dword [ebp+08] 
		push dword [ebx] 
		call StrCmp1 
		cmp eax, 0 
		jz .lp1s 
		
		add ebx, 16 
		jmp .lp1 
	.lp1e: 
		mov dword [ebp-4], -1 
		mov dword [stg3_fxn_return], -1 
		popa 
		leave 
		ret 12 
	.lp1s: 
	
	mov eax, dword [ebp+12] 
	mov edx, eax 
	
	mov eax, dword [ebx+08] 
	mov ecx, eax 
	shl ecx, 2 
	
	xchg ebx, edx 
	
	enter 0, 0 
		.lp2: 
			jecxz .lp2s 
			
			push dword [ebx+ecx] 
			
			sub ecx, 4 
			jmp .lp2 
		.lp2s: 
		xchg ebx, edx 
		call dword [ebx+04] 
		mov dword [stg3_fxn_return], eax 
	leave 
	
	popa 
	leave 
ret 12 

;; stg3_free_params() - service for freeing function parameter area from the caller's stack 
;; params:  pParamList:DWORD, pFxnName:DWORD, pFxnNameTable:DWORD, nExtraArgs:DWORD, pTSS:DWORD 
stg3_free_params: 
	enter 0, 0 
	pusha 
	
	mov eax, dword [ebp+16] 
	mov ebx, eax 
	.lp1: 
		cmp dword [ebx], 0 
		jz .lp1e 
		
		push dword [ebp+12] 
		push dword [ebx] 
		call StrCmp1 
		
		cmp eax, 0 
		jz .lp1s 
		
		add ebx, 16 
		jmp .lp1 
	.lp1e: 
		mov dword [ebp-4], -1 
		popa 
		leave 
		ret 20 
	.lp1s: 
	
	mov eax, dword [ebx+08] 
	add eax, dword [ebp+20] 
	shl eax, 2 
	mov dword [ebp-4], eax 
	
	mov ecx, eax 
	
	mov eax, dword [ebp+08] 
	mov ebx, eax 
	add eax, ecx 
	
	push ecx 
	push eax 
	push ebx 
	call MemoryCopy 
	
	mov eax, dword [ebp+24] 
	mov ebx, eax 
	
	mov eax, dword [ebp-4] 
	add dword [ebx+TSS_ESP], eax 
	
	popa 
	leave 
ret 20 

stg3_fxn_return: 
dd 0x00 

get_base_address: 
	mov al, byte [ebx+04] 
	mov ah, byte [ebx+07] 
	
	shl eax, 16 
	mov ax, word [ebx+02] 
ret 

;; StrCmp1() 
;; params:  str1:DWORD, str2:DWORD 
StrCmp1: 
	enter 0, 0 
	pusha 
	
	mov eax, dword [ebp+08] 
	mov ebx, eax 
	
	mov eax, dword [ebp+12] 
	mov edx, eax 
	
	xor eax, eax 
	
	.lp1: 
		mov al, byte [ebx] 
		sub al, byte [edx] 
		jnz .lp1s 
		
		inc ebx 
		inc edx 
		jmp .lp1 
	.lp1s: 
	
	mov dword [ebp-4], eax 
	
	cmp al, 0 
	jz .over1 
	xchg al, ah 
	cmp al, 0 
	jnz .finish 
	
	.over1: 
	
	cmp ah, 32 
	jz .over2 
	cmp ah, 9 
	jz .over2 
	cmp ah, 13 
	jz .over2 
	cmp ah, 10 
	jz .over2 
	
	jmp .finish 
	
	.over2: 
	
	mov dword [ebp-4], 0 
	
	.finish: 
	
	popa 
	leave 
ret 8 

;; MemoryCopy() 
;; params:  pFrom:DWORD, pTo:DWORD, nBytes:DWORD 
MemoryCopy: 
	enter 0, 0 
	pusha 
	
	mov eax, dword [ebp+08] 
	mov edx, eax 
	
	mov eax, dword [ebp+12] 
	mov ebx, eax 
	
	cmp ebx, edx 
	jg .lbl1 
	
	xor ecx, ecx 
	jmp .lp2 
	
	.lbl1: 
	mov eax, dword [ebp+16] 
	mov ecx, eax 
	.lp1: 
		dec ecx 
		
		mov al, byte [edx+ecx] 
		mov byte [ebx+ecx], al 
		
		jecxz .lp1s 
		jmp .lp1 
	.lp1s: 
	jmp .finish 
	
	.lp2: 
		mov eax, dword [ebp+16] 
		cmp eax, ecx 
		jng .lp2s 
		
		mov al, byte [edx+ecx] 
		mov byte [ebx+ecx], al 
		
		inc ecx 
		jmp .lp2 
	.lp2s: 
	jmp .finish 
	
	.finish: 
	
	popa 
	leave 
ret 12 