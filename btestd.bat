\nasm\nasm stg2_b16.asm -o stg2_b16.bin
\nasm\nasm stg2_b32.asm -o stg2_b32.bin
\nasm\nasm test_d.asm -o test_d.bin
\nasm\nasm testdimg.asm -o testdimg.bin
\nasm\nasm testdimg.asm -o BOOT.IMG
\nasm\nasm testdimg.asm -o BOOTIMG.BIN
iso -r test_b.iso bootimg.bin
chboot test_b.iso bootimg.bin