; BX = pointer to NULL terminated string
print: 
  pusha

_iterate:
  mov al, [bx] 
  cmp al, 0
  je _done
  
  mov ah, 0x0e
  int 0x10

  add bx, 1
  jmp _iterate

_done:
  popa
  ret
