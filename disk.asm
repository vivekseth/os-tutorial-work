; load 'dh' sectors from drive 'dl' into ES:BX
; cylinder = 0
; starting sector = 2
disk_load:
  pusha

  ; ERROR IS HERE
  push dx

  mov ah, 0x02 ; BIOS read sector function

  mov al, dh  ; read `dh` sectors from disk
  
  mov dh, 0x0 ; start reading from track on 1st side of disk
  
  mov ch, 0x0 ; select cylinder 3
  
  mov cl, 0x2 ; start with sector 2
              ; sector 1 is the boot sector

  int 0x13
  jc disk_error

  pop dx
  cmp al, dh
  jne sectors_error

  popa
  ret


disk_error:
  mov bx, DISK_ERROR
  call print
  call new_line

  mov dh, ah
  call print_hex
  jmp disk_loop

sectors_error:
  mov bx, SECTORS_ERROR
  call print
  jmp disk_loop


disk_loop:
  jmp $ ; infinite loop


DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
