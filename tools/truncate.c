#include <stdio.h>

int main(int argc, char **argv)
{
        int buffer[65536];
        int length;

        FILE *in = fopen(argv[1], "rb");
        sscanf(argv[2], "%d", &length);

        fread(buffer, 1, length, in);
        fclose(in);
        in = fopen(argv[1], "wb");
        fwrite(buffer, 1, length, in);
        fclose(in);
}
