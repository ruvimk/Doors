\nasm\nasm test_c.asm -o test_c.bin
\nasm\nasm test_2.asm -o test_2.bin
\nasm\nasm testcimg.asm -o testcimg.bin
\nasm\nasm testcimg.asm -o BOOT.IMG
\nasm\nasm testcbin.asm -o BOOTIMG.BIN
iso -r test_b.iso bootimg.bin
chboot test_b.iso bootimg.bin