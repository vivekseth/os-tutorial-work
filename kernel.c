// void dummy_entrypoint(void) {
// }

void _start() {
  char *video_memory = (char *)0xb8000;
  *video_memory = 'X';
}
