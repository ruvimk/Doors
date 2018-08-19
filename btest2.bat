\nasm\nasm test_2.asm -o test_2.bin
\nasm\nasm test_b.asm -o BOOT.IMG
\nasm\nasm test_b.asm -o BOOTIMG.BIN
iso -r test_b.iso bootimg.bin
chboot test_b.iso bootimg.bin