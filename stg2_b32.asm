ORG 0x8000 

USE16 

db "S2" 

start: 

mov ax, 0xB800 
mov es, ax 

xor bx, bx 

mov byte [es:bx+00], "T" 
mov byte [es:bx+02], "h" 
mov byte [es:bx+04], "i" 
mov byte [es:bx+06], "s" 

mov byte [es:bx+08], " " 

mov byte [es:bx+10], "p" 
mov byte [es:bx+12], "r" 
mov byte [es:bx+14], "o" 
mov byte [es:bx+16], "g" 
mov byte [es:bx+18], "r" 
mov byte [es:bx+20], "a" 
mov byte [es:bx+22], "m" 

mov byte [es:bx+24], " " 

mov byte [es:bx+26], "i" 
mov byte [es:bx+28], "s" 

mov byte [es:bx+30], " " 

mov byte [es:bx+32], "a" 

mov byte [es:bx+34], " " 

mov byte [es:bx+36], "b" 
mov byte [es:bx+38], "o" 
mov byte [es:bx+40], "o" 
mov byte [es:bx+42], "t" 

mov byte [es:bx+44], " " 

mov byte [es:bx+46], "t" 
mov byte [es:bx+48], "e" 
mov byte [es:bx+50], "s" 
mov byte [es:bx+52], "t" 

mov byte [es:bx+54], "." 

mov byte [es:bx+56], " " 

mov byte [es:bx+58], "3" 
mov byte [es:bx+60], "2" 

.lp1: 
	xor ax, ax 
	int 0x16 
	mov ah, 0x0A 
	int 0x10 
	jmp .lp1 
.lp1s: 

cli 
hlt 

jmp .lp1s 
jmp $ 

