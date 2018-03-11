// #include <drivers/ports.h>
#include <drivers/screen.h>
#include <kernel/debug.h>

void _start() {
  clear_screen();

  kprint("Hello!\n");
  kprint("\n");
  kprint("Welcome to my kernel.\n");
  kprint("\n");
  kprint("Use kprint() to print strings\n");
}
