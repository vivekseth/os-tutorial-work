// #include <drivers/ports.h>
#include <drivers/screen.h>
#include <kernel/debug.h>

static char *VIDEO_MEMORY;

// void set_char_at(char c, char format, int x, int y) {
//   char *pixel = VIDEO_MEMORY + 2 * (80 * y + x);
//   pixel[0] = c;
//   pixel[1] = format;
// }

// char solid_color_format(int code) {
//   // code = code & 0xF;
//   char format = (code << 4) + code;
//   return format;
// }

// char color_format(char fc, char bc) {
//   return ((fc & 0xF) << 4) + (bc & 0xF);
// }

// void clear_screen() {
//   int code = 0;
//   for (int y=0; y<25; y++) {
//     for (int x=0; x<80; x++) {
//       char f = code / 16;
//       char b = code % 16;
//       set_char_at('@', color_format(f, b), x, y);
//       code = (code + 1) % (16 * 16);
//     }
//   }
// }





void _start() {
  clear_screen();

  kprint("Hello!\n");
  kprint("\n");
  kprint("Welcome to my kernel.\n");
  kprint("\n");
  kprint("Use kprint() to print strings\n");
}
