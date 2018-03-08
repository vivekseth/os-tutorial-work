// void dummy_entrypoint(void) {
// }

static char *VIDEO_MEMORY;

void set_char_at(char c, char format, int x, int y) {
  char *pixel = VIDEO_MEMORY + 2 * (80 * y + x);
  pixel[0] = c;
  pixel[1] = format;
}

char solid_color_format(int code) {
  // code = code & 0xF;
  char format = (code << 4) + code;
  return format;
}

char color_format(char fc, char bc) {
  return ((fc & 0xF) << 4) + (bc & 0xF);
}

void clear_screen() {
  int code = 0;
  for (int y=0; y<25; y++) {
    for (int x=0; x<80; x++) {
      char f = code / 16;
      char b = code % 16;
      set_char_at('@', color_format(f, b), x, y);
      code = (code + 1) % (16 * 16);
    }
  }
}



int return_true() {
  return 1;
}

void wait_for_gdb() {
  while (return_true()) {}
  set_char_at('X', color_format(0, 15), 0, 0);
}





void _start() {
  VIDEO_MEMORY = (char *)0xb8000;

  // wait_for_gdb();

  clear_screen();

  // char *video_memory = (char *)0xb8000;
  // *VIDEO_MEMORY = 'X';
  // *VIDEO_MEMORY
  // *(VIDEO_MEMORY + 2) = '@';

  // for (int i=0; i<80; i++) {
  //   int x = i * 25 / 80;
  //   int y = i;
  //   set_char_at('X', 0xEE, y, x);  
  // }
}
