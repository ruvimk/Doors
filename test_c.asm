ORG 0x7C00 
USE16 

jmp 0x00:start 

TIMES 8 - ($ - $$) DB 0x00 

_imp: 
incbin "bios.bin" 

%define   get_params        _imp + 0 
%define   dos2bios          _imp + 2 

%define   STAGE2_SECTORS    128 
%define   STAGE2_OFFSET     0x8000 

boot_drive: 
dw 0x00 

sector_number: 
dw 0x02 

first_sector: 
dw 0x02 

drive_params: 
dw 0x00 
dw 0x00 
dw 0x00 

start: 

cli 
xor ax, ax 
mov es, ax 
mov ds, ax 
mov ss, ax 
mov sp, 0x7BE0 
sti 

mov al, dl 
mov word [boot_drive], ax 

call b800 
mov byte [es:bx+00], "b" 
mov byte [es:bx+02], "b" 

mov ax, 0x2401 
int 0x15 
jnc .load_stage2 

call b800 
mov byte [es:bx+00], "a" 
mov byte [es:bx+02], "a" 

in al, 0x92 
or al, 0x02 
out 0x92, al 

call .check_a20 
sub al, 0 
jz .load_stage2 

call b800 
mov byte [es:bx+00], "2" 
mov byte [es:bx+02], "0" 

.hang: 
hlt 
jmp .hang 

.check_a20: 
	cli 
	push ds 
	
	xor ax, ax 
	mov es, ax 
	not ax 
	mov ds, ax 
	
	mov si, 0x0510 
	mov di, 0x0500 
	
	mov al, byte [si] 
	cmp al, byte [di] 
	jnz .check_a20_ok 
	
	inc al 
	mov byte [si], al 
	
	cmp al, byte [di] 
	jnz .check_a20_ok 
	
	dec byte [si] 
	
	mov ax, -1 
	jmp .check_a20_finish 
	
	.check_a20_ok: 
	dec byte [si] 
	xor ax, ax 
	jmp .check_a20_finish 
	
	.check_a20_finish: 
	pop ds 
ret 

.load_stage2: 
	; mov ax, [boot_drive] 
	; mov dx, ax 
	; int 0x13 
	;jc .load_stage2_err1 
	
	.load_stage2_err1not: 
	
	push word drive_params 
	push word [boot_drive] 
	call [get_params] 
	
	call b800 
	mov byte [es:bx+00], "p" 
	mov byte [es:bx+02], "r" 
	
	mov bx, STAGE2_OFFSET 
	.lp1: 
		mov ax, word [sector_number] 
		sub ax, word [first_sector] 
		cmp ax, STAGE2_SECTORS 
		jg .lp1s 
		
		push word drive_params 
		push word [sector_number] 
		call [dos2bios] 
		
		mov al, byte [boot_drive] 
		mov dl, al 
		
		mov ax, 0x0201 
		int 0x13 
		jc .load_stage2_err2 
		
		call b800 
		mov byte [es:bx+00], "b" 
		mov byte [es:bx+02], "r" 
		
		inc word [sector_number] 
		add bx, 512 
		jmp .lp1 
	.lp1s: 
	
	jmp 0x00:STAGE2_OFFSET 
	
	jmp .load_stage2_finish 
.load_stage2_err1: 
; call b800 
; mov byte [es:bx+00], "e" 
; mov byte [es:bx+02], "1" 
jmp .hang 
.load_stage2_err2: 
call b800 
mov byte [es:bx+00], "e" 
mov byte [es:bx+02], "2" 
jmp .hang 
.load_stage2_finish: 

call b800 
mov byte [es:bx+00], "O" 
mov byte [es:bx+02], "K" 

jmp 0x00:STAGE2_OFFSET 

b800: 
mov ax, 0xB800 
mov es, ax 
xor bx, bx 
ret 

TIMES  510 - ($ - $$)  DB 0x00 
dw 0xAA55 