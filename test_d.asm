ORG 0x7C00 
USE16 

jmp 0x00:start 

%define    STAGE2_SECTORS             7 * 18 + 2 
%define    STAGE2_OFFSET              0x8000 

%define    STAGE2_LOAD_SEGMENT        0x0800 
%define    STAGE2_LOAD_OFFSET         0x0000 

%define    FLOPPY_HEADS               2 
%define    FLOPPY_TRACKS              80 
%define    FLOPPY_SECTORS             18 
%define    FLOPPY_BYTES               512 

%define    B16_TRACK                  0 
%define    B32_TRACK                  9 

%define    STAGE2_LOADS               7 
;%define    STAGE2_LOADS               (1217 / FLOPPY_SECTORS) - 17 - 1 

boot_drive: 
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

mov ax, 0x2401 
int 0x15 
jnc .load_stage2 

in al, 0x92 
or al, 0x02 
out 0x92, al 

call .check_a20 
cmp al, 0 
jz .load_stage2 

.hang: 
call b800 
mov byte [es:bx+00], "h" 
mov byte [es:bx+02], "h" 
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

.get_track: 
	pushf 
	pop ax 
	shr ax, 13 
	
	test al, 100b 
	jz .use_b32 
	
	jmp .use_b16 
	
	.use_b16: 
	mov ch, B16_TRACK 
	ret 
	
	.use_b32: 
	mov ch, B32_TRACK 
	ret 
	
ret 

.load_stage2: 
	call .get_track 
	
	call .prepare 
	
	;; First 17 sectors loaded; now loading 18 sectors at a time. 
	
	TIMES  STAGE2_LOADS  call .load 
	
	jmp .load_stage2_finish 
	
	.prepare: 
	mov ax, STAGE2_LOAD_SEGMENT 
	mov es, ax 
	
	mov bx, STAGE2_LOAD_OFFSET 
	
	mov dh, 0 
	mov cl, 2 
	
	mov al, byte [boot_drive] 
	mov dl, al 
	
	mov ah, 2 
	mov al, 17 
	int 0x13 
	
	mov cl, 1 
	
	ret 
	
	.load: 
	add bx, FLOPPY_BYTES * FLOPPY_SECTORS 
	
	inc ch 
	
	mov al, FLOPPY_SECTORS 
	int 0x13 
	jc .load_stage2_err 
	
	ret 
.load_stage2_err: 
	call b800 
	mov byte [es:bx+04], "2" 
	mov byte [es:bx+06], "e" 
	jmp .hang 
.load_stage2_inv: 
	call b800 
	mov byte [es:bx+04], "i" 
	mov byte [es:bx+06], "s" 
	jmp .hang 
.load_stage2_finish: 

mov bx, STAGE2_OFFSET 
cmp byte [bx+00], "S" 
jnz .load_stage2_inv 
cmp byte [bx+01], "2" 
jnz .load_stage2_inv 

jmp 0x00:STAGE2_OFFSET + 2 

b800: 
mov ax, 0xB800 
mov es, ax 
xor bx, bx 
ret 

TIMES  510 - ($ - $$)  DB 0x00 
DW 0xAA55 