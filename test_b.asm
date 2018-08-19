ORG 0x7C00 
USE16 

jmp 0x00:start 

boot_drive: 
dw 0x00 

start: 

cli 
mov ax, 0x9000 
mov ss, ax 
mov sp, 0xFB00 
mov bp, sp 
sti 

xor ax, ax 
	mov ds, ax 
mov al, dl 
mov word [boot_drive], ax 

; mov ax, os_area 
; shr ax, 4 
; mov es, ax 

mov ax, 0x07E0 
mov es, ax 

push word 0x7A00 
push word [boot_drive] 
call biosGetParameters 

mov bx, 0x7A00 
mov al, byte [bx+00] 
call hexout 
mov al, byte [bx+02] 
call hexout 
mov al, byte [bx+04] 
call hexout 

.lbl01: 
hlt 
jmp .lbl01 

; push word 0 
; push word 128 
; push word 2 
; push word [boot_drive] 
; call biosReadSectors 

; jmp 0x07E0:0x00 

hexout: 
	enter 0, 0 
	push bx 
	
	shl ax, 4 
	shr al, 4 
	push ax 
	add al, 48 
	cmp al, 58 
	jl .over1 
		add al, 7 
	.over1: 
	mov ah, 0x0A 
	int 0x10 
	
	pop ax 
	mov al, 0x0A 
	xchg al, ah 
	add al, 48 
	cmp al, 58 
	jl .over2 
		add al, 7 
	.over2: 
	int 0x10 
	
	mov al, 13 
	int 0x10 
	mov al, 10 
	int 0x10 
	
	pop bx 
	leave 
ret 

; pushf 

; mov ax, os_area 
; shr ax, 4 
; push ax 

; push word 0 

; iret 


%include "dd/BIOS.asm" 

TIMES  510 - ($ - $$)  DB 0xAA55 
dw 0xAA55 

os_area: 
incbin "test_2.bin" 

TIMES  720 * 1024 - ($ - $$)  DB 0x00 
;TIMES  144 * 1024 * 1024 / 100 - ($ - $$)  DB  0x00 