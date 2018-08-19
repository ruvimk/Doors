ORG 0x1000 

USE16 

db "S3" 

%include "kernel32.h" 

%include "setgdt_d.h" 
%include "setgate.h" 

%include "tss.h" 

jmp start 

;; 8-byte align the GDT. 
TIMES 16 - ($ - $$)  DB 0x00 

GDT: 
.myNULL: 
dd 0x00 
dd 0x00 
.myCode: 
dw 0xFFFF 
dw 0x0000 
db 0x00 
db 10011010b 
db 11001111b 
db 0x00 
.myData: 
dw 0xFFFF 
dw 0x0000 
db 0x00 
db 10010010b 
db 11001111b 
db 0x00 

TIMES 64 - ($ - $$)  DB 0x00 

the_kernel: 

;; ORG 0x1000 + 64 

;; cd32.bin - Kernel For Booting From CD 
incbin "cd32.bin" 

err_lw: 
mov ax, 0xB800 
xor bx, bx 
mov es, ax 
mov byte [es:bx+00], "E" 
mov byte [es:bx+02], "L" 
hlt 
jmp err_lw 

start: 

mov bx, last_word 
cmp byte [bx+00], "L" 
jnz err_lw 
cmp byte [bx+01], "W" 
jnz err_lw 

xor ax, ax 
mov es, ax 
mov ds, ax 

call GetMemorySize 
mov word [mem_sz_1], ax 
mov ax, bx 
mov word [mem_sz_2], ax 

cli 

lgdt [GDT_desc]               ;; Load the global descriptor table. 

;; Enable protected mode. 
mov eax, cr0 
or eax, 1 
mov cr0, eax 

;; Use protected mode and jump to start of p.m. part of program. 
jmp 00001000b:start_pm 

;; Table size is 24 bytes and start is at GDT. 
GDT_desc: 
dw 24 
dd GDT 

;; The memory size fields. 
mem_sz_1: 
dw 0x00 
mem_sz_2: 
dw 0x00 

;; The start of the protected mode part of the program. 
USE32 
start_pm: 

cli 

;; Set up DS and ES. 
mov ax, 10000b 
mov ds, ax 
mov es, ax 

;; Oh ... and SS. 
mov ss, ax 

;; Set ESP to 0x9FBF0 (0x9FBFF is the last byte we can use). 
mov esp, 0x9FBF0 

;; Let's change the GDT. 

;; Clear an area in memory. 
push dword 0 
push dword 65536 
push dword KERNEL_GDT 
call FillMemory 

;; Copy current GDT to the next memory location. 
push dword 24 
push dword KERNEL_GDT 
push dword GDT 
call MemoryCopy 

;; Set up GDT_desc. 
mov word [GDT_desc+00], 0 
mov dword [GDT_desc+04], KERNEL_GDT 

mov dword [next_free_gdt], 3 

;; Set the new GDT. 
lgdt [GDT_desc] 

call stg3_fxn_extra.cls 

;; And now it's time to pass control to the kernel. 
jmp the_kernel 

%include "getmemorysize.asm" 

%include "fillmem32.asm" 

%include "setgdt_d.asm" 
%include "setgate.asm" 

%include "stg3_fxn.nasm" 

%include "stg3_int.asm" 

%include "dd/ata32.asm" 

;msg: 
db "Hello. ", 13, 10, 13, 10 
db "How are you doing? ", 13, 10 
db "Hello? ", 13, 10 
db 13, 10 
db "Whatever. Bye. ", 13, 10 
db 13, 10 
db 13, 10 
db 0 

msg: 
db "Hello there. ", 13, 10 
db 13, 10 
db "I am a virus. ", 13, 10 
db "But I am very stupid, so I don't know how to do anything. ", 13, 10 
db "So would you please copy me and send me to all your friends' computers? ", 13, 10 
db "Please? ", 13, 10 
db 13, 10 
db "Pretty please with a cherry on top? ", 13, 10 
db 13, 10 
db "I beseech you, please? ", 13, 10 
db 0 

no_ip_1: 
call .over1 
db "no_ip_1", 13, 10, 0 
.over1: 
call stg3_fxn_extra.print 
.over2: 
cli 
hlt 
jmp .over2 

err_wrong_selector: 
call .over1 
db "wrong selector", 13, 10, 0 
.over1: 
call stg3_fxn_extra.print 
.over2: 
cli 
hlt 
jmp .over2 

next_free_gdt: 
dd 0x01 

next_free_tss: 
dd 0x00 

%include "i2str.asm" 

%include "str2i.asm" 

_wait: 
	cli 
enter 1, 0 
mov eax, dword [ebp+8] 
mov ecx, eax 
mov al, 0 
out 0x70, al 
in al, 0x71 
mov byte [ebp-1], al 
.lp1: 
jecxz .lp1s 
mov al, 0 
out 0x70, al 
in al, 0x71 
cmp al, byte [ebp-1] 
jz .lp1 
dec ecx 
mov byte [ebp-1], al 
jmp .lp1 
.lp1s: 
leave 
ret 4 

string1: 
TIMES 512 db 0x00 

nl: 
db 13 
db 10 
db 0 

last_word: 
dw "LW" 