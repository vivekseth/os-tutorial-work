; [org 0x7c00]

mov ah, 0x0e ; tty mode

mov bp, 0x8000
mov sp, bp

push 'A'
push 'B'
push 'C'
push 'D'

; Print out stack elements in order added
mov al, [bp - 2 * 1]
call print_char

mov al, [bp - 2 * 2]
call print_char

mov al, [bp - 2 * 3]
call print_char

mov al, [bp - 2 * 4]
call print_char


mov al, [0x8000]
call print_char

; pop elements off of stack

pop bx
mov al, bl
call print_char

pop bx
mov al, bl
call print_char

pop bx
mov al, bl
call print_char

pop bx
mov al, bl
call print_char


mov al, [0x8000]
call print_char


; Infinite Loop
jmp $ ; jump to current address = infinite loop

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

pop_and_print:
  pop bx
  mov al, bl
  call print_char
  ret


; Padding and magic BIOS number
times 510-($-$$) db 0
dw 0xaa55
