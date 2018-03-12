[org 0x7c00]
[bits 16]
KERNEL_OFFSET equ 0x1000
VBE_DATA_OFFSET equ 0x2000

  mov [BOOT_DRIVE], dl

  mov bp, 0x9000
  mov sp, bp
  
  mov bx, MSG_REAL_MODE
  call print
  call new_line

  call load_kernel ; read kernel from disk
  call set_vbe_mode
  call switch_to_pm

  jmp $ ; should never be called

; Included Files
%include "boot/print.asm"
%include "boot/gdt.asm"
%include "boot/switch_to_pm.asm"
%include "boot/pm_print.asm"
%include "boot/print_hex.asm"
%include "boot/disk.asm"

[bits 16]
load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print
  call new_line

  mov bx, KERNEL_OFFSET
  mov dh, 16
  mov dl, [BOOT_DRIVE]
  call disk_load

  ret

[bits 16]
load_vbe_data:
  pusha
  
  mov bx, MSG_LOAD_VBE_INFO
  call print
  call new_line

  mov di, VBE_DATA_OFFSET
  mov ax, 0x4F00
  int 0x10
  
  cmp ax, 0x004F
  je .done

  mov bx, MSG_ERR
  call print
  call new_line

.done:
  popa
  ret

[bits 16]
set_vbe_mode:
  pusha

  ; 0x0101, 0x0103, 0x0105

  
  mov bx, MSG_SET_VBE_MODE
  call print
  call new_line

  mov di, VBE_DATA_OFFSET
  mov ax, 0x4F02
  mov bl, 0x0110
  mov bh, 0x0 ; 0 | 00 0 00 ? ?
  int 0x10
  
  cmp ax, 0x004F
  je .done

  mov bx, MSG_ERR
  call print
  call new_line

  mov dx, ax
  call print_hex
  call new_line

.done:
  popa
  ret






; 32-bit Protected Mode Entry Point
[bits 32]
BEGIN_PM:
  ; Clear screen takes too many of the 512bytes to store in this stage
  ; I should store this in the kernel instead
  ; call clear_screen

  mov ebx, MSG_PROT_MODE
  call pm_print_string
  call KERNEL_OFFSET
  jmp $

; Global Variables
BOOT_DRIVE db 0 ; store boot drive (BIOS store this in dl on boot)
MSG_REAL_MODE db "@16r", 0
MSG_PROT_MODE db "@32p", 0
MSG_LOAD_KERNEL db "@K", 0
MSG_LOAD_VBE_INFO db "@vbe_l", 0
MSG_SET_VBE_MODE db "@vbe_l", 0
MSG_ERR db "@Err", 0

; Padding and magic BIOS number
times 510-($-$$) db 0
dw 0xaa55
