void dummy_entrypoint(void) {
}

void main() {
  char *video_memory = (char *)0xb8000;
  *video_memory = 'X';
}
