set_interrupts: 
	enter 8, 0 
	
	; mov eax, dword [next_free_gdt]     ;; First undefined descriptor index in GDT 
	; mov dword [ebp-4], eax 
	
	; mov ebx, KERNEL_TSS 
	; mov ecx, 1 
	; mov edx, i00 
	; call default_tss 
	
	; push dword GATE_PRESENT 
	; push dword 0 
	; push dword GATE_TASK 
	; push dword 0 
	; push eax 
	; push dword 255 * 8 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; inc dword [ebp-4] 
	; mov eax, dword [ebp-4] 
	; inc ecx 
	; mov edx, i01 
	; call default_tss 
	
	; push dword GATE_PRESENT 
	; push dword 0 
	; push dword GATE_TASK 
	; push dword 0 
	; push eax 
	; push dword 0 * 8 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; inc dword [ebp-4] 
	; mov eax, dword [ebp-4] 
	; inc ecx 
	; mov edx, i02 
	; call default_tss 
	
	; push dword GATE_PRESENT 
	; push dword 0 
	; push dword GATE_TASK 
	; push dword 0 
	; push eax 
	; push dword 1 * 8 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; inc dword [ebp-4] 
	; mov eax, dword [ebp-4] 
	; inc ecx 
	; mov edx, i03 
	; call default_tss 
	
	; push dword GATE_PRESENT 
	; push dword 0 
	; push dword GATE_TASK 
	; push dword 0 
	; push eax 
	; push dword 2 * 8 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; inc dword [ebp-4] 
	; mov eax, dword [ebp-4] 
	; inc ecx 
	; mov edx, i04 
	; call default_tss 
	
	; push dword GATE_PRESENT 
	; push dword 0 
	; push dword GATE_TASK 
	; push dword 0 
	; push eax 
	; push dword 3 * 8 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; inc dword [ebp-4] 
	; mov eax, dword [ebp-4] 
	; inc ecx 
	; mov edx, i13 
	; call default_tss 
	
	; push dword GATE_PRESENT 
	; push dword 0 
	; push dword GATE_TASK 
	; push dword 0 
	; push eax 
	; push dword 12 * 8 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; inc dword [ebp-4] 
	; mov eax, dword [ebp-4] 
	; inc ecx 
	; mov edx, i14 
	; call default_tss 
	
	; push dword GATE_PRESENT 
	; push dword 0 
	; push dword GATE_TASK 
	; push dword 0 
	; push eax 
	; push dword 13 * 8 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; inc dword [ebp-4] 
	; inc ecx 
		; mov eax, ecx 
		; inc eax 
		; mov dword [next_free_tss], eax 
	; mov eax, dword [ebp-4] 
	; mov edx, default_fault 
	; call default_tss 
	
	; mov ebx, eax 
	
	; mov dword [ebp-8], 15 
	; .lp1: 
		; cmp dword [ebp-8], 20 
		; jnl .lp1s 
		
		; push dword GATE_PRESENT 
		; push dword 0 
		; push dword GATE_TASK 
		; push dword 0 
		; push ebx 
		; push dword [ebp-8] 
		; push dword KERNEL_IDT 
		; call SetGate 
		
		; inc dword [ebp-8] 
		; jmp .lp1 
	; .lp1s: 
	
	; mov dword [ebp-8], 5 
	; .lp2: 
		; cmp dword [ebp-8], 13 
		; jnl .lp2s 
		
		; push dword GATE_PRESENT 
		; push dword 0 
		; push dword GATE_TASK 
		; push dword 0 
		; push ebx 
		; push dword [ebp-8] 
		; push dword KERNEL_IDT 
		; call SetGate 
		
		; inc dword [ebp-8] 
		; jmp .lp2 
	; .lp2s: 
	
	; mov dword [ebp-8], 32 
	; .lp3: 
		; cmp dword [ebp-8], 256 
		; jnl .lp3s 
		
		; push dword GATE_PRESENT 
		; push dword 0 
		; push dword GATE_TASK 
		; push dword 0 
		; push ebx 
		; push dword [ebp-8] 
		; push dword KERNEL_IDT 
		; call SetGate 
		
		; inc dword [ebp-8] 
		; jmp .lp3 
	; .lp3s: 
	
	; push dword GATE_32BIT | GATE_PRESENT 
	; push dword 0 
	; push dword GATE_INTERRUPT 
	; push dword i10 
	; push dword 1<<3 
	; push dword 10 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; push dword GATE_32BIT | GATE_PRESENT 
	; push dword 0 
	; push dword GATE_INTERRUPT 
	; push dword i13 
	; push dword 1<<3 
	; push dword 13 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; push dword GATE_32BIT | GATE_PRESENT 
	; push dword 0 
	; push dword GATE_INTERRUPT 
	; push dword i06 
	; push dword 1<<3 
	; push dword 6 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; push dword GATE_32BIT | GATE_PRESENT 
	; push dword 0 
	; push dword GATE_INTERRUPT 
	; push dword i11 
	; push dword 1<<3 
	; push dword 11 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; push dword GATE_32BIT | GATE_PRESENT 
	; push dword 0 
	; push dword GATE_INTERRUPT 
	; push dword i12 
	; push dword 1<<3 
	; push dword 12 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; push dword GATE_32BIT | GATE_PRESENT 
	; push dword 0 
	; push dword GATE_INTERRUPT 
	; push dword i14 
	; push dword 1<<3 
	; push dword 14 
	; push dword KERNEL_IDT 
	; call SetGate 
	
	; inc dword [ebp-4] 
	; mov eax, dword [ebp-4] 
	
	leave 
ret 0 

default_tss: 
	enter 16, 0 
	pusha 
	
	;; [ebp-04] =  GDT index 
	;; [ebp-08] =  base of TSS array area 
	;; [ebp-12] =  index of TSS (in array) 
	;; [ebp-16] =  address of the first instruction to execute 
	
	mov dword [ebp-04], eax 
	mov eax, ebx 
	mov dword [ebp-08], eax 
	mov eax, ecx 
	mov dword [ebp-12], eax 
	mov eax, edx 
	mov dword [ebp-16], eax 
	
	mov eax, dword [ebp-04] 
	shl eax, 3 
	mov dword [ebp-20], eax 
	
	;; Set the GDT descriptor. 
	push dword 0         ;; DPL (descriptor privilege level) 
	push dword DESC_PRESENT 
	push dword PAGE_TSS 
	push dword TSS_SIZE  ;; Limit 
		mov eax, dword [ebp-12] 
		mov ecx, eax 
		mov eax, dword [ebp-08] 
		mov ebx, eax 
		mov eax, TSS_SIZE 
		mul ecx 
		add eax, ebx 
	push eax             ;; Base address. 
	push dword [ebp-04] 
	push dword KERNEL_GDT 
	call SetGDTdesc 
	
	push dword 0 
	push dword TSS_SIZE 
		mov eax, dword [ebp-08] 
		mov ebx, eax 
		mov eax, dword [ebp-12] 
		mov ecx, TSS_SIZE 
		mul ecx 
		add ebx, eax 
	push ebx 
	call FillMemory 
	
	mov eax, dword [ebp-16] 
	mov dword [ebx+TSS_EIP], eax 
	
	mov dword [ebx+TSS_GS], 2<<3 
	mov dword [ebx+TSS_FS], 2<<3 
	mov dword [ebx+TSS_DS], 2<<3 
	mov dword [ebx+TSS_SS], 2<<3 
	mov dword [ebx+TSS_CS], 1<<3 
	mov dword [ebx+TSS_ES], 2<<3 
	
	mov dword [ebx+TSS_EFLAGS], OS_SYS_APP_EFLAGS 
	
	mov eax, cr3 
	mov dword [ebx+TSS_CR3], eax 
	
	xor eax, eax 
	mov ax, ss 
	mov dword [ebx+TSS_SS2], eax 
	mov dword [ebx+TSS_SS1], eax 
	mov dword [ebx+TSS_SS0], eax 
	
	mov eax, STAGE3_ESP 
	mov dword [ebx+TSS_ESP2], eax 
	mov dword [ebx+TSS_ESP1], eax 
	mov dword [ebx+TSS_ESP0], eax 
	
	mov eax, dword [default_esp] 
	mov dword [ebx+TSS_ESP], eax 
	mov dword [ebx+TSS_EBP], eax 
	
	sub dword [default_esp], 8192 
	
	mov dword [ebx+TSS_IOBITMAP], 0x68 
	
	popa 
	leave 
ret 0 

default_esp: 
dd KERNEL_ESP 

i00: 
	enter 0, 0 
	
	
	
	leave 
iret 

i01: 
	enter 0, 0 
	
	
	
	leave 
iret 

i02: 
	enter 0, 0 
	
	;; NMI interrupt. 
	
	
	
	leave 
iret 

i03: 
	enter 0, 0 
	
	
	
	leave 
iret 

i04: 
	enter 0, 0 
	
	
	
	leave 
iret 

;; interrupt 
i06: 
	enter 0, 0 
	pusha 
	
	jmp .over1 
	db "Interrupt Number 6 (Invalid Opcode)", 13, 10, 13, 10, "Halting CPU...  ", 13, 10, 0 
	.over1: 
	call stg3_fxn_extra.print 
	.over2: 
	cli 
	hlt 
	jmp .over2 
	
	popa 
	leave 
iret 

i10: 
	cli 
	enter 0, 0 
	pusha 
	
	call stg3_fxn_extra.cls 
	
	call .over1 
	db "Error:  Invalid TSS", 13, 10, 0 
	.over1: 
	call stg3_fxn_extra.print 
	
	call .over2 
	db 13, 10, "Memory Dump At Bad Segment: ", 13, 10, 0 
	.comma: db 44, 32, 0 
	.over2: 
	call stg3_fxn_extra.print 
	
	mov eax, dword [ebp+4] 
	and eax, -111b - 1 
	mov ebx, KERNEL_TSS 
	add ebx, eax 
	xor ecx, ecx 
	.lp1: 
		cmp ecx, 104 
		jz .lp1s 
		
		push dword string01 
		push dword [ebx+ecx] 
		call i2str 
		push eax 
		call stg3_fxn_extra.print 
		push dword .comma 
		call stg3_fxn_extra.print 
		
		add ecx, 4 
		jmp .lp1 
	.lp1s: 
	push dword nl 
	call stg3_fxn_extra.print 
	
	call .over3 
	db 13, 10, "Halting CPU...  ", 13, 10, 0 
	.over3: 
	call stg3_fxn_extra.print 
	
	.over4: 
	cli 
	hlt 
	jmp .over4 
	
	popa 
	leave 
	sti 
iret 

;; interrupt 
i11: 
	enter 0, 0 
	pusha 
	
	jmp .over1 
	db "Interrupt Number 11 (Segment Not Present)", 13, 10, 13, 10, "Halting CPU...  ", 13, 10, 0 
	.over1: 
	call stg3_fxn_extra.print 
	.over2: 
	cli 
	hlt 
	jmp .over2 
	
	popa 
	leave 
iret 

;; interrupt 
i12: 
	enter 0, 0 
	pusha 
	
	jmp .over1 
	db "Interrupt Number 12 (Stack Segment Fault)", 13, 10, 13, 10, "Halting CPU...  ", 13, 10, 0 
	.over1: 
	call stg3_fxn_extra.print 
	.over2: 
	cli 
	hlt 
	jmp .over2 
	
	popa 
	leave 
iret 

i13: 
	enter 0, 0 
	pusha 
	
	mov dword [ebp-4], -1 
	
	call .get_user_ip 
	
	;; At this point, EBX should point to the instruction that raised the exception. 
	
	mov al, byte [ebx] 
	cmp al, 0xCD 
	jz .user_interrupt 
	jmp .user_done 
	
	.user_done: 
		;; Some code that would terminate the application. 
		
		mov eax, dword [ebp+4] 
		push eax 
		call tss_fault_maybe 
		
		jmp .finish 
	.user_interrupt: 
		;; Interrupt-handler code. 
		
		mov al, byte [ebx+01] 
		cmp al, 0x50 
		jz .stg3_interrupt 
		jmp .finish 
		
		.stg3_interrupt: 
			
			call .get_user_tss 
			
			mov eax, dword [ebx+TSS_ESP] 
			push eax 
			push dword user_interrupt_fxn 
			int 0x50 
			mov dword [ebp-4], eax 
			
			jmp .finish 
		;; .....  
		
		jmp .finish 
	.get_user_ip: 
		call .get_user_tss 
		
		mov eax, dword [ebx+TSS_CS] 
		mov ecx, eax 
		mov eax, dword [ebx+TSS_EIP] 
		xchg eax, ecx 
		
		test eax, 100b 
		jnz .use_ldt 
		
		and eax, -111b - 1 
		add eax, KERNEL_GDT 
		mov ebx, eax 
		
		jmp .use_cont 
		
		.use_ldt: 
		and eax, -111b - 1 
		add eax, dword [ebx+TSS_LDT] 
		mov ebx, eax 
		
		jmp .use_cont 
		
		.use_cont: 
		
		call get_base_address 
		mov ebx, eax 
		add ebx, ecx 
		
		ret 0 
	.get_user_tss: 
		xor eax, eax 
		str ax 
		and eax, -111b - 1 
		add eax, KERNEL_GDT 
		mov ebx, eax 
		
		call get_base_address 
		mov ebx, eax 
		
		mov eax, dword [ebx+TSS_PrevTaskLink] 
		and eax, -111b - 1 
		add eax, KERNEL_GDT 
		mov ebx, eax 
		
		call get_base_address 
		mov ebx, eax 
		
		ret 0 
	.finish: 
	
	popa 
	leave 
iret 

;; interrupt 
i14: 
	enter 0, 0 
	pusha 
	
	jmp .over1 
	db "Interrupt Number 14 (Page Fault)", 13, 10, 13, 10, "Halting CPU...  ", 13, 10, 0 
	.over1: 
	call stg3_fxn_extra.print 
	.over2: 
	cli 
	hlt 
	jmp .over2 
	
	popa 
	leave 
iret 

default_fault: 
	enter 0, 0 
	
	
	
	leave 
iret 

tss_fault_maybe: 
	enter 0, 0 
	
	;call stg3_fxn_extra.cls 
	
	push dword nl 
	call stg3_fxn_extra.print 
	push dword nl 
	call stg3_fxn_extra.print 
	
	call .over1 
	db "Error:  ????", 13, 10, 0 
	.over1: 
	call stg3_fxn_extra.print 
	
	call .over2 
	db 13, 10, "Memory Dump At Segment (first 26 DWORDs): ", 13, 10, 0 
	.comma: db 44, 32, 0 
	.over2: 
	call stg3_fxn_extra.print 
	
	mov eax, dword [ebp+8] 
	and eax, -111b - 1 
	mov ebx, KERNEL_GDT 
	add ebx, eax 
	
	mov al, byte [ebx+04] 
	mov ah, byte [ebx+07] 
	shl eax, 16 
	mov ax, word [ebx+02] 
	mov ebx, eax 
	
	xor ecx, ecx 
	.lp1: 
		cmp ecx, 104 
		jz .lp1s 
		
		push dword string01 
		push dword [ebx+ecx] 
		call i2str 
		push eax 
		call stg3_fxn_extra.print 
		push dword .comma 
		call stg3_fxn_extra.print 
		
		add ecx, 4 
		jmp .lp1 
	.lp1s: 
	push dword nl 
	call stg3_fxn_extra.print 
	
	call .over3 
	db 13, 10, "Halting CPU...  ", 13, 10, 0 
	.over3: 
	call stg3_fxn_extra.print 
	
	.over4: 
	cli 
	hlt 
	jmp .over4 
	
	leave 
ret 4 

gdt_dump: 
	cli 
	enter 0, 0 
	pusha 
	
	push dword nl 
	call stg3_fxn_extra.print 
	
	call .over1 
	db "Generating GDT dump...  ", 13, 10, "Global Descriptor Table Contents (index range of 0 through ", 0 
	.comma: db 44, 32, 0 
	.over1: 
	call stg3_fxn_extra.print 
	
	push dword string01 
	push dword [ebp+8] 
	call i2str 
	push eax 
	call stg3_fxn_extra.print 
	
	call .over2 
	db "): ", 13, 10, 0 
	.over2: 
	call stg3_fxn_extra.print 
	
	mov ebx, KERNEL_GDT 
	xor ecx, ecx 
	.lp1: 
		mov eax, ecx 
		shr eax, 1 
		cmp eax, dword [ebp+8] 
		jg .lp1s 
		
		push dword string01 
		push dword [ebx+(ecx*4)] 
		call i2str 
		push eax 
		call stg3_fxn_extra.print 
		push dword .comma 
		call stg3_fxn_extra.print 
		
		inc ecx 
		jmp .lp1 
	.lp1s: 
	push dword nl 
	call stg3_fxn_extra.print 
	
	popa 
	leave 
ret 4 

idt_dump: 
	cli 
	enter 0, 0 
	pusha 
	
	push dword nl 
	call stg3_fxn_extra.print 
	
	call .over1 
	db "Generating IDT dump...  ", 13, 10, "Interrupt Descriptor Table Contents (index range of 0 through ", 0 
	.comma: db 44, 32, 0 
	.over1: 
	call stg3_fxn_extra.print 
	
	push dword string01 
	push dword [ebp+8] 
	call i2str 
	push eax 
	call stg3_fxn_extra.print 
	
	call .over2 
	db "): ", 13, 10, 0 
	.over2: 
	call stg3_fxn_extra.print 
	
	mov ebx, KERNEL_GDT 
	xor ecx, ecx 
	.lp1: 
		mov eax, ecx 
		shr eax, 1 
		cmp eax, dword [ebp+8] 
		jg .lp1s 
		
		push dword string01 
		push dword [ebx+(ecx*4)] 
		call i2str 
		push eax 
		call stg3_fxn_extra.print 
		push dword .comma 
		call stg3_fxn_extra.print 
		
		inc ecx 
		jmp .lp1 
	.lp1s: 
	push dword nl 
	call stg3_fxn_extra.print 
	
	popa 
	leave 
ret 4 

user_interrupt_fxn: 
db "CallFromUser", 0 

string01: 
TIMES 512 db 0x00 

