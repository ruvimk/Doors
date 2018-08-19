;// Stuff that only applies to DATA segments. 
%define PAGE_READ                          0000b 
%define PAGE_READWRITE                     0010b 
%define PAGE_EXPANDDOWN                    0100b 

;// Stuff that can be applied to either DATA or CODE segments. 
%define PAGE_ACCESSED                      0001b 

;// Stuff that only applies to CODE segments. 
%define PAGE_EXECUTE                       1000b 
%define PAGE_EXECUTEREAD                   1010b 
%define PAGE_CONFORMING                    0100b 

;// Stuff that only applies to TSS segments. 
%define PAGE_TSS                           1001b 
%define PAGE_BUSY                          0010b 

;// Flags values. 
%define DESC_16BIT                         0000b 
%define DESC_32BIT                         0001b 
%define DESC_SYSTEM                        0000b 
%define DESC_CODE                          0010b 
%define DESC_DATA                          0010b 
%define DESC_CODEDATA                      0010b 
%define DESC_GONE                          0000b 
%define DESC_PRESENT                       0100b 
%define DESC_AVL                           1000b 