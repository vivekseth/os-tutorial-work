#include <kernel/util.h>
#include <drivers/screen.h>
#include <kernel/debug.h>

void _start() {
  clear_screen();

  kprint("Hello!\n");
  kprint("\n");
  kprint("Welcome to my kernel.\n");
  kprint("\n");
  kprint("Use kprint() to print strings\n");

  for (int i=0; i<100; i++) {
    char str[3];
    str[0] = (i % 26) + 'a';
    str[1] = '\n';
    str[2] = 0;
    kprint(str);
  }
}
