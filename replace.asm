.386 
.model flat, stdcall 
option casemap:none 
include \masm32\include\windows.inc 
include \masm32\include\masm32.inc 
include \masm32\include\kernel32.inc 
includelib \masm32\lib\masm32.lib 
includelib \masm32\lib\kernel32.lib 

include \fractions.inc 
includelib \fractions.lib 

public StringLength 
public strcat 
public strlen 
public strcpy 

string macro p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, \
p31, p32 
	LOCAL a 
	ifnb <p1> 
	;; Saves a string (up to 32 entries (ex. string "Hello World!", 13, 10, 13, 10, ".....  " makes 6 entries)) and returns its memory address. 
	.data 
	a db p1 
	for entry, <p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, \
p31, p32> 
		ifnb <entry> 
			db entry 
		endif 
	endm 
	db 0 
	else 
		.data? 
		a         DB  512 dup (?) 
	endif 
	.code 
	exitm <offset a> 
endm 
extern replace                        : near 
some_functions macro 
	to_nspace: 
	@@: 
		mov al, byte ptr [ebx] 
		cmp al, 0 
		jz finish 
		inc ebx 
		cmp al, 32 
		jz @B 
		cmp al, 9 
		jz @B 
	@@: 
	dec ebx 
	ret 0 
	to_space: 
	@@: 
		mov al, byte ptr [ebx] 
		cmp al, 0 
		jz finish 
		cmp al, 32 
		jz @F 
		cmp al, 9 
		jz @F 
		inc ebx 
		jmp @B 
	@@: 
	ret 0 
	skip: 
		cmp byte ptr [ebx], 34 
		jz skip_lp2 
		cmp byte ptr [ebx], 0 
		jz finish 
	skip_lp1: 
		mov al, byte ptr [ebx] 
		cmp al, 34 
		jz skip_lp1s 
		cmp al, 32 
		jz skip_finish 
		cmp al, 9 
		jz skip_finish 
		cmp al, 13 
		jz skip_finish 
		cmp al, 10 
		jz skip_finish 
		cmp al, 0 
		jz almost_finish 
		
		inc ebx 
		jmp skip_lp1 
	skip_lp1s: 
		mov eax, ebx 
		inc eax 
		push ebx 
		push eax 
		call StringCopy 
		mov byte ptr [ebx], 32 
		jmp skip_finish 
	skip_lp2: 
		inc ebx 
		
		mov al, byte ptr [ebx] 
		cmp al, 34 
		jz skip_lp2s 
		cmp al, 0 
		jz skip_finish 
		jmp skip_lp2 
	skip_lp2s: 
		inc ebx 
		mov eax, ebx 
		inc eax 
		push ebx 
		push eax 
		call StringCopy 
		mov byte ptr [ebx], 32 
		jmp skip_finish 
	almost_finish: 
		mov al, byte ptr [ebx-1] 
		cmp al, 32 
		jz finish 
		cmp al, 9 
		jz finish 
		cmp al, 13 
		jz finish 
		cmp al, 10 
		jz finish 
		jmp skip_finish 
	skip_finish: 
	ret 0 
endm 

.data 
mem1     db 1, 8, 7, 12, 84, 223, 81, 74, 78, 91, 32, 93, 124, 249, 124, 192, 184, 83, 85, 35, 95, 38, 94, 38, 45, 32, 43, 125, 149, 243, 91, 100, 0 
.data? 
mem2     DB SIZEOF mem1 dup (?) 
CommandLine                           DWORD ? 
CmdLine                               DB  512 dup (?) 
conffile                              DB  512 dup (?) 
file_arr                              DD  128 dup (?) 
s1                                    DWORD ? 
.code 
start: 

call main 

ret 

main proc 
	enter 0, 0 
	
	;; Test the MemoryCopy() function. 
	pusha 
		push dword ptr 0 
		push dword ptr SIZEOF mem2 
		push dword ptr offset mem2 
		call FillMemory 
		
		push dword ptr SIZEOF mem1 
		push dword ptr offset mem2 
		push dword ptr offset mem1 
		call MemoryCopy 
		
		mov ebx, offset mem1 
		mov edx, offset mem2 
		xor ecx, ecx 
		lp01: 
			cmp ecx, SIZEOF mem1 
			jnl lp01s 
			
			mov al, byte ptr [ebx+ecx] 
			cmp al, byte ptr [edx+ecx] 
			jnz lp01ne 
			
			inc ecx 
			jmp lp01 
		lp01ne: 
			push dword ptr string("MemoryCopy() failed. ", 13, 10) 
			call StdOut 
			jmp lp01f 
		lp01s: 
			push dword ptr string("MemoryCopy() succeded! ", 13, 10) 
			call StdOut 
			jmp lp01f 
		lp01f: 
	popa 
	
	call GetCommandLine 
	mov dword ptr [CommandLine], eax 
	
	mov ebx, eax 
	mov eax, offset CmdLine 
	push ebx 
	push eax 
	call StringCopy 
	
	mov ebx, eax 
	
	call to_nspace 
	call skip 
	call to_nspace 
	
	mov eax, offset conffile 
	push ebx 
	push eax 
	call StringCopy 
	
	push ebx 
		mov ebx, offset conffile 
		call skip 
		mov byte ptr [ebx], 0 
		
		push dword ptr offset conffile 
		call StdOut 
		push dword ptr string(13, 10, 13, 10) 
		call StdOut 
	pop ebx 
	
	call skip 
	call to_nspace 
	
	push dword ptr offset file_arr 
	push ebx 
	call get_cmd_array 
	
	mov ebx, offset file_arr 
	lp1: 
		mov eax, dword ptr [ebx] 
		cmp eax, 0 
		jz lp1s 
		
		push ebx 
		enter 0, 0 
			enter 0, 0 
			push eax 
			call StringLength 
			push dword ptr string() 
			push eax 
			call i2str 
			push eax 
			call StdOut 
			leave 
			push dword ptr string(32) 
			call StdOut 
		leave 
		pop ebx 
		
		mov eax, dword ptr [ebx] 
		
		push ebx 
			push eax 
			call StdOut 
			push dword ptr string(13, 10) 
			call StdOut 
		pop ebx 
		
		add ebx, 4 
		jmp lp1 
	lp1s: 
	
	push dword ptr offset file_arr 
	call free_array 
	
	jmp finish 
	
	some_functions 
	
	finish: 
	
	leave 
	ret 0 
main endp 

get_cmd_array proc       ;; the_string:DWORD, the_array:DWORD 
	enter 4, 0 
	
	mov eax, dword ptr [ebp+12] 
	mov dword ptr [ebp-4], eax 
	
	mov eax, dword ptr [ebp+8] 
	mov ebx, eax 
	
	lp1: 
	mov edx, ebx 
	call skip 
	sub ebx, edx 
	jz finish 
	
	;; Allocate memory. 
		push ebx 
		push edx 
	inc ebx 
	push ebx 
	; push dword ptr 0 
	push dword ptr GMEM_ZEROINIT 
	call GlobalAlloc 
	mov ebx, eax 
	mov eax, dword ptr [ebp-4] 
	xchg eax, ebx 
		pop edx 
	mov dword ptr [ebx], eax 
	push eax 
	push edx 
	call MemoryCopy 
		; mov ebx, eax 
		; mov eax, dword ptr [ebp-4] 
		; xchg eax, ebx 
		; add ebx, eax 
		; dec ebx 
		; mov byte ptr [ebx], 0 
	add dword ptr [ebp-4], 4 
	mov ebx, edx 
	call skip 
	call to_nspace 
	jmp lp1 
	
	some_functions 
	
	finish: 
	
	mov eax, dword ptr [ebp-4] 
	mov ebx, eax 
	mov dword ptr [ebx], 0 
	
	mov eax, dword ptr [ebp+12] 
	leave 
	ret 8 
get_cmd_array endp 

free_array proc     ;; the_array:DWORD 
	enter 0, 0 
	
	mov eax, dword ptr [ebp+8] 
	mov ebx, eax 
	lp1: 
		mov eax, dword ptr [ebx] 
		cmp eax, 0 
		jz lp1s 
		
		push ebx 
			push eax 
			call GlobalFree 
		pop ebx 
		
		add ebx, 4 
		jmp lp1 
	lp1s: 
	
	leave 
	ret 4 
free_array endp 

MemoryCopy proc       ;; from:DWORD, to:DWORD, size:DWORD 
	enter 0, 0 
	pusha 
	
	mov eax, dword ptr [ebp+08] 
	mov edx, eax 
	
	mov eax, dword ptr [ebp+12] 
	mov ebx, eax 
	
	cmp ebx, edx 
	jg lbl1 
	
	xor ecx, ecx 
	jmp lp2 
	
	lbl1: 
	mov eax, dword ptr [ebp+16] 
	mov ecx, eax 
	xor eax, eax 
	lp1: 
		dec ecx 
		
		mov al, byte ptr [edx+ecx] 
		mov byte ptr [ebx+ecx], al 
		
		jecxz lp1s 
		jmp lp1 
	lp1s: 
	jmp finish 
	
	lp2: 
		mov eax, dword ptr [ebp+16] 
		cmp eax, ecx 
		jng lp2s 
		
		mov al, byte ptr [edx+ecx] 
		mov byte ptr [ebx+ecx], al 
		
		inc ecx 
		jmp lp2 
	lp2s: 
	jmp finish 
	
	finish: 
	
	mov eax, dword ptr [ebp+16] 
	mov dword ptr [ebp-4], eax 
	
	popa 
	leave 
	ret 12 
MemoryCopy endp 

putchar proc 
	mov eax, dword ptr [esp+4] 
	mov byte ptr [s1+0], al 
	mov byte ptr [s1+1], 0 
	push dword ptr offset s1 
	call StdOut 
	ret 4 
putchar endp 

StringLength@4 proc     ;; the_string:DWORD 
	enter 0, 0 
	pusha 
	
	mov eax, dword ptr [ebp+8] 
	mov ebx, eax 
	
	xor ecx, ecx 
	lp1: 
		mov al, byte ptr [ebx+ecx] 
		cmp al, 0 
		jz lp1s 
		
		inc ecx 
		jmp lp1 
	lp1s: 
	
	mov eax, ecx 
	mov dword ptr [ebp-4], eax 
	
	popa 
	leave 
	ret 4 
StringLength@4 endp 

StringCopy proc     ;; to:DWORD, from:DWORD 
	enter 0, 0 
	pusha 
	
	push dword ptr [ebp+12] 
	call StringLength 
	inc eax 
	
	push eax 
	push dword ptr [ebp+08] 
	push dword ptr [ebp+12] 
	call MemoryCopy 
	
	popa 
	leave 
	ret 8 
StringCopy endp 

; i2str proc 
	; enter 0, 0 
	; push esi 
	; push edi 
	; push ecx 
	; push edx 
	; push ebx 
	
	; mov byte ptr [ebp-1], 0 
	
	; mov esi, dword ptr [ebp+8] 
	; mov edi, dword ptr [ebp+12] 
	; push esi 
	; call iLength 
	; xchg eax, ecx 
	; mov eax, esi 
	; lp1: 
		; jecxz lp1s 
		; dec ecx 
		; push ecx 
		; inc ecx 
		; mov ebx, eax 
		; call exp10 
		; xchg eax, ebx 
		; xor edx, edx 
		; div ebx 
		; dec ecx 
		; add al, 48 
		; mov byte ptr [edi], al 
		; inc edi 
		; sub al, 48 
		; push ecx 
		; mov ebx, eax 
		; call exp10 
		; mul ebx 
		; sub esi, eax 
		; mov eax, esi 
		; jmp lp1 
	; lp1s: 
	; mov byte ptr [edi], 0 
	
	; mov eax, dword ptr [ebp+12] 
	
	; pop ebx 
	; pop edx 
	; pop ecx 
	; pop edi 
	; pop esi 
	; leave 
	; ret 8 
; i2str endp 

; iLength proc 
	; enter 0, 0 
	; push ebx 
	; push ecx 
	; push edx 
	
	; mov eax, dword ptr [ebp+8] 
	; xor ecx, ecx 
	; lp1: 
		; mov ebx, 10 
		; xor edx, edx 
		; div ebx 
		; inc ecx 
		; cmp eax, 0 
		; jnz lp1 
	; lp1s: 
	
	; mov eax, ecx 
	
	; pop edx 
	; pop ecx 
	; pop ebx 
	; leave 
	; ret 4 
; iLength endp 

; exp10 proc 
	; enter 0, 0 
	; push ebx 
	; push ecx 
	; push edx 
	
	; mov ecx, dword ptr [ebp+8] 
	; mov eax, 1 
	; mov ebx, 10 
	; lp1: 
		; jecxz lp1s 
		; mul ebx 
		; dec ecx 
		; jmp lp1 
	; lp1s: 
	
	; pop edx 
	; pop ecx 
	; pop ebx 
	; leave 
	; ret 4 
; exp10 endp 

FillMemory proc 
enter 0, 0 
	push ebx 
	push ecx 
	
	mov eax, dword ptr [ebp+8] 
	mov ebx, eax 
	
	mov eax, dword ptr [ebp+12] 
	mov ecx, eax 
	
	mov eax, dword ptr [ebp+16] 
	lp1: 
		sub ecx, 4 
		jl lp2b 
		
		mov dword ptr [ebx], eax 
		
		add ebx, 4 
		jmp lp1 
	lp2b: add ecx, 4 
	lp2: 
		sub ecx, 2 
		jl lp3b 
		
		mov word ptr [ebx], ax 
		
		add ebx, 2 
		jmp lp2 
	lp3b: sub ecx, 1 
	lp3c: jl lp3f 
	lp3d: mov byte ptr [ebx], al 
	lp3f: 
	
	pop ecx 
	pop ebx 
	mov eax, dword ptr [ebp+8] 
	leave 
ret 12 
FillMemory endp 

StringCat proc 
	enter 0, 0 
	pusha 
	
	push dword ptr [ebp+08] 
	call StringLength 
	add eax, dword ptr [ebp+08] 
	push dword ptr [ebp+12] 
	push eax 
	call StringCopy 
	
	popa 
	leave 
	ret 8 
StringCat endp 

; public _StringLength 
; public _strcat 
; public _strlen 
; public _strcpy 

StringLength: jmp StringLength@4 
strcat: jmp StringCat 
strlen: jmp StringLength 
strcpy: jmp StringCopy 

end start 