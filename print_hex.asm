; DX = 16bit hex value
[bits 16]
print_hex:
  pusha

  call _print_hex_prefix

  push dx
  mov dl, dh
  call _print_byte
  pop dx

  call _print_byte

  popa
  ret

; DL = 8bit value
_print_byte:
  pusha
  
  ; get upper 4 bits
  mov cl, dl
  shr cl, 4
  call _half_byte_to_char
  mov al, cl
  mov ah, 0x0e ; tty mode
  int 0x10

  ; get lower 4 bits
  mov cl, dl
  and cl, 0xF
  call _half_byte_to_char
  mov al, cl
  mov ah, 0x0e ; tty mode
  int 0x10
  
  popa
  ret

; input CL = 4bit value
; output CL = character
_half_byte_to_char:
  mov bl, 0xA
  cmp cl, bl
  jl __half_byte_to_char_num
  jmp __half_byte_to_char_letter

_half_byte_to_char_complete:
  ret

__half_byte_to_char_num:
  add cl, 0x30
  jmp _half_byte_to_char_complete

__half_byte_to_char_letter:  
  add cl, 0x37
  jmp _half_byte_to_char_complete


_print_hex_prefix:
  pusha
  mov al, '0'
  mov ah, 0x0e ; tty mode
  int 0x10

  mov al, 'x'
  mov ah, 0x0e ; tty mode
  int 0x10
  popa
  ret
