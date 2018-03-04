mov ah, 0x0e ; tty mode

; First attempt
mov al, "1"
call print_char

mov al, the_secret
int 0x10
call new_line
call new_line

; Second attempt
mov al, "2"
call print_char

mov al, [the_secret]
int 0x10
call new_line
call new_line

; Third attempt
mov al, "3"
call print_char

mov al, [the_secret + 0x7c00]
int 0x10
call new_line
call new_line

; Fourth attempt
mov al, "4"
call print_char

mov bx, the_secret
add bx, 0x7c00
mov al, [bx]
int 0x10
call new_line
call new_line




; Infinite Loop
jmp $ ; jump to current address = infinite loop


the_secret:
  db "X"

new_line:
  mov al, 0xD
  int 0x10
  mov al, 0xA
  int 0x10
  ret

; place char in $al first
print_char:
  int 0x10
  call new_line
  ret


; Padding and magic BIOS number
times 510-($-$$) db 0
dw 0xaa55
