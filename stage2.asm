ORG 0x8000 
USE16 

%define      STAGE3_SEGMENT                    0x1800 
%define      STAGE3_OFFSET                     0x0000 

%define      STAGE3_SEGMENT_32                 0x0000 
%define      STAGE3_OFFSET_32                  0x1000 

%define      STACK_SEGMENT                     0x2800 
%define      STACK_SEGMENT_32                  0x0000 

db "S2" 

jmp start 

b32: 
dw 0x00 

start: 

mov ax, 0xB800 
mov es, ax 
xor bx, bx 

mov byte [es:bx+00], "S" 
mov byte [es:bx+02], "2" 

;; Check to see if this is PCjr; if so, use the PCjr code. 
mov bx, 0xF000 
mov es, bx 
mov bx, 0xFFFE 
mov al, byte [es:bx] 
cmp al, 0xFD 
jz .use_bJR 

;; Take over the keyboard interrupt. 
xor bx, bx 
mov es, ax 
mov ax, word [es:bx+(1*9)+0x00] 
mov word [i_ip], ax 
mov ax, word [es:bx+(1*9)+0x02] 
mov word [i_cs], ax 
mov word [es:bx+(1*9)+0x00], .force_b16 
mov ax, cs 
mov word [es:bx+(1*9)+0x02], ax 

mov cx, 10000 
.lp01: 
	jcxz .lp01s 
	
	dec cx 
	jmp .lp01 
.lp01s: 

pushf 
pop ax 
shr ax, 13 

test al, 100b 
jz .use_b32 

jmp .use_b16 

.use_bJR: 
	mov ax, STAGE3_SEGMENT 
	mov es, ax 
	mov di, STAGE3_OFFSET 
mov si, bJR_start 
mov ax, bJR_stop 
sub ax, si 
mov cx, ax 
jmp .use_cont 

.use_b16: 
	mov ax, STAGE3_SEGMENT 
	mov es, ax 
	mov di, STAGE3_OFFSET 
mov si, b16_start 
mov ax, b16_stop 
sub ax, si 
mov cx, ax 
jmp .use_cont 

.use_b32: 
mov word [b32], 1 
	mov ax, STAGE3_SEGMENT_32 
	mov es, ax 
	mov di, STAGE3_OFFSET_32 
mov si, b32_start 
mov ax, b32_stop 
sub ax, si 
mov cx, ax 
jmp .use_cont 

.force_b16: 
cli 
;; Check to see if a key is pressed; if so, go to 16-bit mode. 
in al, 0x64 
test al, 10b 
jnz .force_b16_true 
sti 
iret 
.force_b16_true: 
;; Restore the original keyboard interrupt handler. 
xor bx, bx 
mov es, ax 
mov ax, word [i_ip] 
mov word [es:bx+(1*9)+0x00], ax 
mov ax, word [i_cs] 
mov word [es:bx+(1*9)+0x02], ax 
;; Go to the 16-bit code starter. 
sti 
jmp .use_b16 

.use_err: 
mov ax, 0xB800 
mov es, ax 
xor bx, bx 

mov byte [es:bx+00], "u" 
mov byte [es:bx+02], "e" 

hlt 
jmp .use_err 

.use_cont: 
	mov bx, si 
	cmp byte [bx+00], "S" 
	jnz .use_err 
	cmp byte [bx+01], "3" 
	jnz .use_err 
; mov ax, STAGE3_SEGMENT 
; mov es, ax 
; mov di, STAGE3_OFFSET 
.lp1: 
	jcxz .lp1s 
	
	mov al, byte [ds:si] 
	mov byte [es:di], al 
	
	inc si 
	inc di 
	dec cx 
	jmp .lp1 
.lp1s: 

;; Restore the original keyboard interrupt handler. 
xor bx, bx 
mov es, ax 
mov ax, word [i_ip] 
mov word [es:bx+(1*9)+0x00], ax 
mov ax, word [i_cs] 
mov word [es:bx+(1*9)+0x02], ax 

mov ax, 0xB800 
mov es, ax 
xor bx, bx 

mov byte [es:bx+00], "O" 
mov byte [es:bx+02], "K" 

mov ax, word [b32] 
cmp ax, 0 
jnz .use_32_01 

mov ax, STAGE3_SEGMENT 
mov ds, ax 
mov es, ax 

mov ax, STACK_SEGMENT 
mov ss, ax 

jmp .cont_01 

.use_32_01: 

mov ax, STAGE3_SEGMENT_32 
mov ds, ax 
mov es, ax 

mov ax, STACK_SEGMENT_32 
mov ss, ax 

jmp .cont_01 

.cont_01: 

mov sp, 0xFFFF 

xor bx, bx 

cmp byte [bx+00], "S" 
jnz err_s3 
cmp byte [bx+01], "3" 
jnz err_s3 

err_s3_not: 

xor ax, ax 
mov bx, ax 
mov cx, ax 
mov dx, ax 
mov si, ax 
mov di, ax 

cmp word [b32], 0 
jnz .over001 

jmp STAGE3_SEGMENT:STAGE3_OFFSET + 2 

.over001: 

jmp STAGE3_SEGMENT_32:STAGE3_OFFSET_32 + 2 

i_ip: 
dw 0x00 
i_cs: 
dw 0x00 

bJR_start: 
incbin "s2_jr.bin" 
bJR_stop: 

b16_start: 
incbin "s2_16.bin" 
b16_stop: 

b32_start: 
incbin "s2_32.bin" 
b32_stop: 

err_s3: 
cmp byte [bx+0x1000], "S" 
jnz err_s3_for_sure 
cmp byte [bx+0x1001], "3" 
jnz err_s3_for_sure 
jmp err_s3_not 
err_s3_for_sure: 
mov ax, 0xB800 
mov es, ax 
xor bx, bx 

mov byte [es:bx+00], "e" 
mov byte [es:bx+02], "3" 

hlt 
jmp err_s3 