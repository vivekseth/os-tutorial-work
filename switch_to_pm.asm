[bits 16]
switch_to_pm:
  
  ; Turn off interrupts until we have switched to Protected Mode
  cli

  ; Load Global Descriptor Table
  lgdt [gdt_descriptor]

  ; Switch to Protected Mode by setting first bit of CR0  (Control 
  ; Register) to 1
  mov eax, cr0
  or eax, 0x1
  mov cr0, eax

  ; Make a "Far Jump" to flush CPU pipeline of pre-fetched and 
  ; real-mode instructions 
  jmp CODE_SEG:init_pm

[bits 32]
init_pm:
  ; initialize segment regsiters to values from GDT
  mov ax, DATA_SEG
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  ; Setup stack 
  mov ebp, 0x90000
  mov esp, ebp

  call BEGIN_PM
