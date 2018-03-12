#include <kernel/util.h>
#include <drivers/screen.h>

void _str_reverse(char *str, int len);

void memory_copy(char *source, char *dest, int nbytes) {
    int i;
    for (i = 0; i < nbytes; i++) {
        *(dest + i) = *(source + i);
    }
}

/**
 * K&R implementation
 */
void int_to_ascii(int n, char str[]) {
    int i, sign;
    if ((sign = n) < 0) n = -n;
    i = 0;
    do {
        str[i++] = n % 10 + '0';
    } while ((n /= 10) > 0);

    if (sign < 0) str[i++] = '-';
    str[i] = '\0';

    _str_reverse(str, i);

    /* TODO: implement "reverse" */
}

// assumes str[len] = '\0';
void _str_reverse(char *str, int len) {
    int start = 0;
    int end = len - 1;
    while (start < end) {
        char c = str[end];
        str[end] = str[start];
        str[start] = c;

        start += 1;
        end -= 1;
    }
}


char half_byte_to_char(char hb) {
    if (hb < 10) {
        return hb + '0';
    }
    else {
        return (hb - 10) + 'A';
    }
}

void byte_to_str(char b, char *str) {
    str[0] = half_byte_to_char(b >> 4);
    str[1] = half_byte_to_char(b & 0x0F);
}

void print_bytes(char *source, int num_bytes, int num_columns) {
    kprint("\n");

    int num_rows = (num_bytes / num_columns) + 1;
    char *src_ptr = source;

    for (int row=0; row<num_rows; row++) {
        for (int col=0; col<num_columns; col++) {
            if ((src_ptr - source) >= num_bytes) {
                return;
            }

            char str[4];
            byte_to_str(*src_ptr, str);
            str[2] = 0;
            str[3] = 0;            
            kprint(str);

            src_ptr += 1;
        }
        kprint("\n");
    }
}