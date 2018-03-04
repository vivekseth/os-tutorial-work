[org 0x7c00]

mov bx, HELLO
call print

call new_line

mov bx, GOODBYE
call print

call new_line


; Infinite Loop
jmp $ ; jump to current address = infinite loop

%include "print.asm"


; data
HELLO:
    db 'Hello, World', 0

GOODBYE:
    db 'Goodbye', 0

; Padding and magic BIOS number
times 510-($-$$) db 0
dw 0xaa55
