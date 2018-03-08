#include <drivers/ports.h>

unsigned char port_read_byte(unsigned short port) {
  // in al, dx
  unsigned char output;
  asm("in %%al, %%dx" : "=a" (output) : "d" (port));
  return output;
}

void port_write_byte(unsigned short port, unsigned char data) {
  // out dx, al
  asm("out %%dx, %%al" : : "a" (data), "d" (port));
}

unsigned short port_read_word(unsigned short port) {
  // in ax, dx
  unsigned char output;
  asm("in %%ax, %%dx" : "=a" (output) : "d" (port));
  return output;
}

void port_write_word(unsigned short port, unsigned char data) {
  // out dx, ax
  asm("out %%dx, %%ax" : : "a" (data), "d" (port));
}
