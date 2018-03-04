; BX = pointer to NULL terminated string
print: 
  pusha

_print_iterate:
  mov al, [bx] 
  cmp al, 0
  je _print_done
  
  mov ah, 0x0e
  int 0x10

  add bx, 1
  jmp _print_iterate

_print_done:
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