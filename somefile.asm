ORG 0x7C00 
use16 

%define     KERNEL_SECTOR_COUNT 0x40
%define     KERNEL_START_SECTOR 0x02
%define     KERNEL_LOAD_SEGMENT 0x0000
%define     KERNEL_LOAD_OFFSET  0x8000

; CODE
__start:
    ; disable interrupts
    .init_stack:
        cli
        ; save this drive number
        mov     [thisdrive], dl
        ; set up stack and data segments
        xor     ax, ax
        mov     ds, ax
        mov     ss, ax
        mov     sp, 7900h
        sti

    ; change video mode
    mov     ax, 0003h
    int     10h

    ; clear the screen
    mov     ax, 0600h
    mov     bh, 07h
    xor     cx, cx
    mov     dx, 184fh
    int     10h

    ; try to enable A20 using the BIOS
    mov     ax, 2401h
    int     15h
    jnc     .load_kernel                    ; if CF=1 then we failed.

    ; okay, we failed. try another method.
    ; go through keyboard controller
    in      al, 92h
    or      al, 02h
    out     92h, al
    ; check to see if A20 is enabled
    call    _check_a20

    ; If carry flag is set then we failed again. Print error and hang.
    jnc     .load_kernel

    ; If we get here then A20 failed. print no A20 error message
    mov     si, msg_err_a20
    call    _print

    ; fall through and hang.
    .hang:
        cli
        hlt

    .load_kernel:
        ; print "kernel loading" message
        mov     si, msg_loading
        call    _print

        ; reset the disk controller
        mov     ah, 00h
        mov     dl, [thisdrive]
        int     13h
        jc      .load_reset_failed

        ; load the kernel code
        mov     ah, 02h                     ; int 13h, subfunction 02h
        mov     al, KERNEL_SECTOR_COUNT     ; number of sectors to read
        mov     ch, 00h                     ; starting cylinder
        mov     cl, KERNEL_START_SECTOR     ; starting sector, base 1
        mov     dh, 00h                     ; head
        mov     dl, [thisdrive]             ; drive number
        mov     bx, KERNEL_LOAD_SEGMENT     ;
        mov     es, bx                      ;
        mov     bx, KERNEL_LOAD_OFFSET      ; kernel loads at ES:BX
        int     13h

        jc      .load_failed                ; disk read failure on carry

        ; jump to kernel
        jmp     [p_loadaddr]

    .load_reset_failed:
        mov     si, msg_err_dskrst
        call    _print
        jmp     .hang

    .load_failed:
        mov     si, msg_err_disk
        call    _print
        jmp     .hang

_print:
    mov     ah, 0eh
    mov     bx, 0007h

    ._printloop:
        ; load the next char to print
        lodsb
        ; test for end of string
        cmp     al, 00h
        je      .done_print
        ; print character
        int     10h
        ; go on to next
        jmp     ._printloop

    .done_print:
    ret

; FUNCTION TO CHECK WHETHER A20 IS ENABLED
_check_a20:
    ;disable interrupts
    cli
    push    ds

    ; ES = 0, DS = 0ffffh
    xor     ax, ax
    mov     es, ax
    not     ax
    mov     ds, ax

    ; DI = 0500h, SI = 0510h
    mov     di, 0500h
    mov     si, 0510h

    ; Note that because without A20 we're limited to 1 megabyte of memory, if
    ; A20 isn't enabled then high addresses will wrap around. Because of segmen-
    ; tation in 8086 mode, ES:[DI] and DS:[SI] (0000h:0500h and ffffh:0510h
    ; respectively) should map to the same memory address. So all we have to do
    ; is store a value to ES:[DI] and read it back from DS:[SI]. If we get the
    ; same value, then we're guaranteed that A20 isn't enabled. If we don't get
    ; the same value, then A20 is definitely on.

    cmpsw
    jne     .a20_ok

    ; we got the same value back. If we write something different to each and
    ; get the same value in both then we've got A20 disabled.
    mov     WORD [es:di], 0cafeh
    mov     WORD [ds:si], 0deadh
    cmp     WORD [es:di], 0deadh
    jne     .a20_ok

    ; if we get here then A20 is definitely disabled. Set carry flag and exit.
    .a20_disabled:
        stc
        jmp     .exit

    ; If we get here then A20 is enabled. Clear carry flag and exit.
    .a20_ok:
        clc

    .exit:
        pop     ds
        sti
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONSTANT DATA
msg_err_a20:    db  "Could not enable high memory.",00h
msg_err_disk:   db  "Disk read error.",00h
msg_err_dskrst: db  "Disk reset error.",00h
msg_loading:    db  "Loading kernel from disk...",00h
p_loadaddr:     dw  KERNEL_LOAD_OFFSET, KERNEL_LOAD_SEGMENT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VARIABLE DATA
thisdrive:      db  0 

TIMES  510 - ($ - $$)  DB 0x00 
dw 0xAA55 