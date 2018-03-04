[org 0x7c00]

mov ah, 0x0e ; tty

mov dx, 0x4142
call print_hex


; Infinite Loop
jmp $ ; jump to current address = infinite loop

%include "print.asm"
%include "print_hex.asm"

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
