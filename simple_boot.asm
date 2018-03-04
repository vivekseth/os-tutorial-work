; Infinite loop
loop: 
  jmp loop

; Fill bytes up to (and including) 510 with zero
times 510-($-$$) db 0

; Magic Number
dw 0xaa55
