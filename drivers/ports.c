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

unsigned char port_byte_in(unsigned short port) {
  return port_read_byte(port);
}
void port_byte_out(unsigned short port, unsigned char data) {
  return port_write_byte(port, data);
}
unsigned short port_word_in(unsigned short port) {
  return port_read_word(port);
}
void port_word_out(unsigned short port, unsigned char data) {
  return port_write_word(port, data);
}