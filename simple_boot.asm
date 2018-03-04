[org 0x7c00]

mov bp, 0x8000
mov sp, bp

mov bx, 0x9000
mov dh, 2
; BIOS supposedly sets dl with our boot disk number
call disk_load

mov dx, [0x9000]
call print_hex
call new_line

mov dx, [0x9000 + 0x200]
call print_hex
call new_line





; Infinite Loop
jmp $ ; jump to current address = infinite loop

%include "print.asm"
%include "print_hex.asm"
%include "disk.asm"

; data

the_secret:
    db "X"

HELLO:
    db 'Hello, World', 0

GOODBYE:
    db 'Goodbye', 0

; Padding and magic BIOS number
times 510-($-$$) db 0
dw 0xaa55

; boot sector = sector 1 of cyl 0 of head 0 of hdd 0
; from now on = sector 2 ...
times 256 dw 0xdada ; sector 2 = 512 bytes
times 256 dw 0xface ; sector 3 = 512 bytes
