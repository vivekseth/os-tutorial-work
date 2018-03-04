[org 0x7c00]
  mov bp, 0x9000
  mov sp, bp
  
  mov bx, MSG_REAL_MODE
  call print
  call new_line

  call switch_to_pm

  ; This code should never execute if switch happens
  mov bx, MSG_ERR_SWITCH_MODE
  call print
  call new_line

  jmp $ ; should never be called

; Included Files
%include "print.asm"
%include "gdt.asm"
%include "switch_to_pm.asm"
%include "pm_print.asm"
; %include "print_hex.asm"
; %include "disk.asm"

; 32-bit Protected Mode Entry Point
[bits 32]
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call pm_print_string
  jmp $

; Global Variables
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Successfully Landed in 32-bit Protected Mode", 0
MSG_ERR_SWITCH_MODE db "Error Switching to Protected Mode", 0

; Padding and magic BIOS number
times 510-($-$$) db 0
dw 0xaa55
