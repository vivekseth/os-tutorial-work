gdt_start:

; Mandatory Null Descriptor
gdt_null:
  dq 0x0        ; 8 NULL bytes 

; Code Section:
;   Base: 0x0
;   Limit: 0xFFFFF (5 Fs)
;   Present: 1
;   Privilege: 0 (2 bits)
;   Descriptor Type: 1
;   Type:
;     Code: 1
;     Conforming: 0
;     Readable: 1
;     Accessed: 0
;   Other Flags:
;     Granularity: 1
;     32 Bit Default: 1
;     32 Bit Code Segment: 0
;     AVL: 0 (used for Debugging)
gdt_code:
  dw 0xffff     ; Segement Limit (bits 0-15)
  dw 0x0        ; Base Address (bits 0-15)
  db 0x0        ; Base Address (bits 16-23)
  db 10011010b  ; Access Byte
  db 11001111b  ; Segment Limit (bits 16-19)
  db 0x0        ; Base Address (bits 24-31)

; Data Section:
;   Base: 0x0
;   Limit: 0xFFFFF (5 Fs)
;   Present: 1
;   Privilege: 0 (2 bits)
;   Descriptor Type: 1
;   Type:
;     Code: 0
;     Conforming: 0
;     Readable: 1
;     Accessed: 0
;   Other Flags:
;     Granularity: 1
;     32 Bit Default: 1
;     32 Bit Code Segment: 0
;     AVL: 0 (used for Debugging)
gdt_data:
  dw 0xffff     ; Segement Limit (bits 0-15)
  dw 0x0        ; Base Address (bits 0-15)
  db 0x0        ; Base Address (bits 16-23)
  db 10010010b  ; Access Byte
  db 11001111b  ; Segment Limit (bits 16-19)
  db 0x0        ; Base Address (bits 24-31)

gdt_end: ; label to help with sizing GDT table

gdt_descriptor:
  dw gdt_end - gdt_start - 1 ; Size of the GDT Table (1 less than true size)
  dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
