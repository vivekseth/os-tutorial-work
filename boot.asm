[org 0x7c00]







; Infinite Loop
jmp $ ; jump to current address = infinite loop

%include "print.asm"
%include "print_hex.asm"
%include "disk.asm"


; Padding and magic BIOS number
times 510-($-$$) db 0
dw 0xaa55
