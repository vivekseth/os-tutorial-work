#define MAX_ROWS 25
#define MAX_COLS 80

void clear_screen(void);

void kprint(char *message);

void kprint_char_at(char c, char f, int row, int col);

void _colorize_screen();
