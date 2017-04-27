#include <stdio.h>
#include <stdlib.h>

unsigned char m1[128];
unsigned char m2[128];
unsigned char m3[128];
unsigned char m4[128];
unsigned char m5[128];
unsigned char m6[128];

int main(int argc, unsigned char **argv)
{
        FILE *in;
        FILE *out;
        int c;

        if (argc < 2) return 1;
        printf("Processing %s\n", argv[1]);
        in = fopen(argv[1], "rb");
        fread(m1, 1, 128, in);
        fread(m2, 1, 128, in);
        fread(m3, 1, 128, in);
        fread(m4, 1, 128, in);
        fread(m5, 1, 128, in);
        fread(m6, 1, 128, in);

        fclose(in);

        for (c = 0; c < 128; c++)
        {
                if (m4[c])
                {
                        if (m4[c] < 128)
                        {
                          printf("Object %02x has item requirement %02x\n", c, m4[c]);
                          if (m3[c] & 32) printf("- Item will be eaten\n");
                        }
                        else
                        {
                          printf("Object %02x has object requirement %02x\n", c, m4[c]-128);
                        }
                }
        }
        return 0;
}
