; BX = pointer to NULL terminated string
[bits 16]
print: 
  pusha

.iterate:
  mov al, [bx] 
  cmp al, 0
  je .done
  
  mov ah, 0x0e
  int 0x10

  add bx, 1
  jmp .iterate

.done:
  popa
  ret

new_line:
  pusha

  mov ah, 0x0e
  mov al, 0xA
  int 0x10
  mov al, 0xD
  int 0x10

  popa
  ret