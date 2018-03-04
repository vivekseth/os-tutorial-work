[bits 32]

; Constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0F

; Print string pointed to by EBX
pm_print_string:
  pusha

  mov edx, VIDEO_MEMORY

.loop:
  mov al, [ebx]
  mov ah, WHITE_ON_BLACK

  cmp al, 0
  je .done

  mov [edx], ax

  ; advance str pointer by 1 character
  add ebx, 1
  ; advance frame buffer by 1 character cell (2 bytes)
  add edx, 2
  jmp .loop


.done:
  popa
  ret


clear_screen: 
  pusha

  mov edx, VIDEO_MEMORY

  mov al, 0x0
  mov ah, WHITE_ON_BLACK

  mov ecx, 0

.loop:
  cmp ecx, 80*25
  je .done

  mov [edx + 2 * ecx], ax

  add ecx, 1
  jmp .loop

.done:

  popa
  ret