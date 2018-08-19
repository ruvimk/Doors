;// The TSS structure that we would want to use. 
%define TSS_T                                   0x64 - 0x00 
%define TSS_IO                                  0x64 - 0x02 
%define TSS_LDT                                 0x64 - 0x04 
%define TSS_GS                                  0x64 - 0x08 
%define TSS_FS                                  0x64 - 0x0C 
%define TSS_DS                                  0x64 - 0x10 
%define TSS_SS                                  0x64 - 0x14 
%define TSS_CS                                  0x64 - 0x18 
%define TSS_ES                                  0x64 - 0x1C 
%define TSS_EDI                                 0x64 - 0x20 
%define TSS_ESI                                 0x64 - 0x24 
%define TSS_EBP                                 0x64 - 0x28 
%define TSS_ESP                                 0x64 - 0x2C 
%define TSS_EBX                                 0x64 - 0x30 
%define TSS_EDX                                 0x64 - 0x34 
%define TSS_ECX                                 0x64 - 0x38 
%define TSS_EAX                                 0x64 - 0x3C 
%define TSS_EFLAGS                              0x64 - 0x40 
%define TSS_EIP                                 0x64 - 0x44 
%define TSS_CR3                                 0x64 - 0x48 
%define TSS_SS2                                 0x64 - 0x4C 
%define TSS_ESP2                                0x64 - 0x50 
%define TSS_SS1                                 0x64 - 0x54 
%define TSS_ESP1                                0x64 - 0x58 
%define TSS_SS0                                 0x64 - 0x5C 
%define TSS_ESP0                                0x64 - 0x60 
%define TSS_PrevTaskLink                        0x64 - 0x64 
%define TSS_IOBITMAP                            0x68 

%define TSS_SIZE                                104 + 128 