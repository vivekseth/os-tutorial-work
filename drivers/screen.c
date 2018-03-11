#include <drivers/screen.h>
#include <drivers/ports.h>

#include <kernel/debug.h>

#define VGA_FRAME_ADDRESS (char*)0xB8000
#define VGA_FRAME_MAX_COLUMNS 80
#define VGA_FRAME_MAX_ROWS 25

#define VGA_CRTC_ADDR_REG 0x3D4
#define VGA_CRTC_DATA_REG 0x3D5

#define VGA_CRTC_INDEX_CURSOR_HIGH 0xE
#define VGA_CRTC_INDEX_CURSOR_LOW 0xF

#define VGA_FORMAT_WHITE_ON_BLACK 0x0F
#define VGA_FORMAT_RED_ON_WHITE 0xF4



// Private API Header

int _get_cursor_row(int location);

int _get_cursor_column(int location);

int _create_cursor_location(int row, int col);

int _get_cursor_location(void);

void _set_cursor_location(int position);

int _kprint_char(char c, char f, int location);

char _create_format_code(char fc, char bc);

// Public API Implementation

void clear_screen(void) {
  char *framebuffer = VGA_FRAME_ADDRESS;
  for (int i=0; i<(VGA_FRAME_MAX_COLUMNS * VGA_FRAME_MAX_ROWS); i++) {
    int fb_offset = 2 * i;
    framebuffer[fb_offset] = 0x0;
    framebuffer[fb_offset+1] = VGA_FORMAT_WHITE_ON_BLACK;
  }
  _set_cursor_location(0);
}

void kprint(char *message) {
  int cursor_location = _get_cursor_location();
  char c = *message;
  while(c) {
    cursor_location = _kprint_char(c, VGA_FORMAT_WHITE_ON_BLACK, cursor_location);
    message = message + 1;
    c = *message;
  }
  _set_cursor_location(cursor_location);
}

void kprint_char_at(char c, char f, int row, int col) {
  int location = _create_cursor_location(row, col);
  
  char *framebuffer = VGA_FRAME_ADDRESS;
  int fb_offset = location * 2;
  framebuffer[fb_offset] = c; 
  framebuffer[fb_offset+1] = f;
}

void _colorize_screen() {
  clear_screen();
  int cursor_location = _get_cursor_location();

  int code = 0;
  for (int y=0; y<25; y++) {
    for (int x=0; x<80; x++) {
      char f = code / 16;
      char b = code % 16;
      cursor_location = _kprint_char('@', _create_format_code(f, b), _create_cursor_location(y, x));
      code = (code + 1) % (16 * 16);
    }
  }

  _set_cursor_location(cursor_location);
}

// Private API Implementation

char _create_format_code(char fc, char bc) {
  return ((fc & 0xF) << 4) + (bc & 0xF);
}

int _get_cursor_row(int location) {
  return location / 80;
}

int _get_cursor_column(int location) {
  return location % 80;
}

int _create_cursor_location(int row, int col) {
  return (row * 80) + col;
}

// Prints character and increments cursor location
int _kprint_char(char c, char f, int location) {
  char *framebuffer = VGA_FRAME_ADDRESS;

  int new_location;
  if (c == '\n') {    
    int row = _get_cursor_row(location);
    new_location = _create_cursor_location(row + 1, 0);
  }
  else {
    int fb_offset = location * 2;
    framebuffer[fb_offset] = c; 
    framebuffer[fb_offset+1] = f;
    new_location = location + 1;
  }

  return new_location;
}

void _set_cursor_location(int position) {
  int low_byte = position & 0xFF;
  int high_byte = position >> 8;

  port_byte_out(VGA_CRTC_ADDR_REG, VGA_CRTC_INDEX_CURSOR_HIGH);
  port_byte_out(VGA_CRTC_DATA_REG, high_byte);
  
  port_byte_out(VGA_CRTC_ADDR_REG, VGA_CRTC_INDEX_CURSOR_LOW);
  port_byte_out(VGA_CRTC_DATA_REG, low_byte);
}

int _get_cursor_location(void) {
  int position = 0;
  
  port_byte_out(VGA_CRTC_ADDR_REG, VGA_CRTC_INDEX_CURSOR_HIGH);
  position = port_byte_in(VGA_CRTC_DATA_REG) << 8;
  
  port_byte_out(VGA_CRTC_ADDR_REG, VGA_CRTC_INDEX_CURSOR_LOW);
  position += port_byte_in(VGA_CRTC_DATA_REG);
  
  return position;
}
