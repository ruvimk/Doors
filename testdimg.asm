incbin "test_d.bin" 
TIMES 512 - ($ - $$)  DB 0x00 

incbin "stg2_b16.bin" 

TIMES  512 * 18 * 9 + 512 - ($ - $$)  DB 0x00 
incbin "stg2_b32.bin" 

TIMES  1440 * 1024 - ($ - $$)  DB 0x00 