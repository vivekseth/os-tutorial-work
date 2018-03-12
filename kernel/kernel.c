#include <kernel/util.h>
#include <drivers/screen.h>
#include <kernel/debug.h>
#include <kernel/util.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

struct ModeAttributes {
  unsigned char supported:1;
  unsigned char reserved:1;
  unsigned char ttySupported:1;
  unsigned char colorType:1;
  
  unsigned char modeType:1;
  unsigned char vgaCompatible:1;
  unsigned char windowedMemoryAvailable:1;
  unsigned char linearFrameBufferAvailable:1;

  unsigned char doubleScanAvailale:1;
  unsigned char interlacedModeAvailable:1;
  unsigned char tripleBufferingModeAvailable:1;
  unsigned char stereoModeAvailable:1;

  unsigned char dualDisplaySupport:1;
  unsigned char reserved2:3;
};

struct VbeModeInfoBlock {
   struct ModeAttributes modeAttributes;
   uint8_t winAAttr;
   uint8_t winBAttr;
   uint16_t winGranularity;
   uint16_t winSize;
} __attribute__((packed));


void _start() {
  struct VbeModeInfoBlock *modeInfoPtr = (struct VbeModeInfoBlock *)0x2000;
  print_bytes(modeInfoPtr, 2, 1);

  if (modeInfoPtr->modeAttributes.colorType) {
    kprint("YES\n");
  }
  else {
    kprint("NO\n"); 
  }

  char numStr[10];
  int_to_ascii(modeInfoPtr->winGranularity, numStr);
  numStr[9] = 0;
  kprint(numStr);
  kprint("\n");
}
