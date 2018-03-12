#include <kernel/util.h>
#include <drivers/screen.h>
#include <kernel/debug.h>
#include <kernel/util.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

struct VbeInfoBlock {
   char VbeSignature[4];             // == "VESA"
   uint16_t VbeVersion;                 // == 0x0300 for VBE 3.0
   uint16_t OemStringPtr[2];            // isa vbeFarPtr
   uint8_t Capabilities[4];
   uint16_t VideoModePtr[2];         // isa vbeFarPtr
   uint16_t TotalMemory;             // as # of 64KB blocks
} __attribute__((packed));

int count_video_modes(char *ptr) {
  uint16_t *modes = (uint16_t *)ptr;

  int count = 0;
  int found_end = 0;
  while (found_end != 1) {
    count += 1;
    modes += 1;
    if (*(modes) == 0xFFFF) {
      found_end = 1;
    }
  }
  return count;
}

int look_for_mode(uint16_t *modes, int len, uint16_t target_mode) {
  for (int i=0; i<len; i++) {
    uint16_t m = modes[i];
    if (m == target_mode) {
      return 1;
    }
  }
  return 0;
}


void _start() {
  clear_screen();

  struct VbeInfoBlock *vbePtr = (struct VbeInfoBlock *)0x2000;
  char str[5];
  memory_copy(vbePtr->VbeSignature, str, 4);
  str[4] = 0;
  kprint(str);

  kprint("\n");

  int video_mode_count = count_video_modes(vbePtr->VideoModePtr[0]);
  char count_str[10];
  count_str[9] = 0;
  int_to_ascii(video_mode_count, count_str);

  if (look_for_mode((uint16_t *)vbePtr->VideoModePtr[0], video_mode_count, 0x010F)) {
    kprint("YES\n");
  }
  else {
    kprint("NO\n");
  }

  if (look_for_mode((uint16_t *)vbePtr->VideoModePtr[0], video_mode_count, 0x81FF)) {
    kprint("YES\n");
  }
  else {
    kprint("NO\n");
  }

  if (look_for_mode((uint16_t *)vbePtr->VideoModePtr[0], video_mode_count, 0x010A)) {
    kprint("YES\n");
  }
  else {
    kprint("NO\n");
  }

  if (look_for_mode((uint16_t *)vbePtr->VideoModePtr[0], video_mode_count, 0x010B)) {
    kprint("YES\n");
  }
  else {
    kprint("NO\n");
  }

  if (look_for_mode((uint16_t *)vbePtr->VideoModePtr[0], video_mode_count, 0x010C)) {
    kprint("YES\n");
  }
  else {
    kprint("NO\n");
  }



  // kprint(count_str);
  // kprint("\n");
  // print_bytes((char *)(vbePtr->VideoModePtr[0]), 48, 2);

  // wait_for_debugger();

  // kprint("Hello!\n");
  // kprint("\n");
  // kprint("Welcome to my kernel.\n");
  // kprint("\n");
  // kprint("Use kprint() to print strings\n");

  // for (int i=0; i<100; i++) {
  //   char str[10];
  //   int_to_ascii(i, str);
  //   kprint(str);
  //   kprint("\n");
  // }
}
