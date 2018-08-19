

;// Some constants. 
%define KERNEL_IDT                               0x100000 
%define KERNEL_GDT                               0x100800 
%define KERNEL_TSS                               0x110800 

;// Stage 3 ESP is at 0x09FBF0; we're using that - 8192 
%define KERNEL_ESP                               0x09DBF0 
%define STAGE3_ESP                               0x09FBF0 

;// Operating-System-Specific values. 
%define OS_SYS_APP_EFLAGS                        00000000000000000000001000000010b 
%define OS_USR_APP_EFLAGS                        00000000000000000000001000000010b 

%define OS_@@@_APP_EFLAGS                        00000000000000000011001000000010b 