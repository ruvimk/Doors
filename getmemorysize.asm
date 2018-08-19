;; GetMemorySize() 
;; parameters: 
;;   none 
;; return: 
;;   AX= number of 64KB chunks of memory after 16MB. 
;;   BX= number of KB of memory after 1MB and before 16MB. 
;; .....  
GetMemorySize: 
	xor cx, cx 
	xor dx, dx 
	mov ax, 0xE801 
	int 0x15 
	cmp dx, 0 
	jz .over1 
		mov ax, cx 
		mov bx, dx 
	.over1: 
ret 