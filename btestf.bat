@echo off 
\nasm\nasm test_f.asm -o test_f.bin
\nasm\nasm cd32.asm -o cd32.bin
	\nasm\nasm s2_jr.asm -o s2_jr.bin&\nasm\nasm s2_16.asm -o s2_16.bin&\nasm\nasm s2_32.asm -o s2_32.bin
\nasm\nasm stage2.asm -o stage2.bin
\nasm\nasm testfimg.asm -o testfimg.bin&\nasm\nasm testfimg.asm -o BOOT.IMG&\nasm\nasm testfimg.asm -o BOOTIMG.BIN
if errorlevel 0 echo Building ISO Image...  
iso -r test_f.iso bootimg.bin&chboot test_f.iso bootimg.bin
@echo on 