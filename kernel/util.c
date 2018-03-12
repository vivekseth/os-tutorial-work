#include <kernel/util.h>

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