incbin "test_f.bin" 
TIMES 512 - ($ - $$)  DB 0x00 

incbin "stage2.bin" 
TIMES 512 + 65536 - ($ - $$)  DB 0x00 

TIMES  1440 * 1024 - ($ - $$)  DB 0x00 