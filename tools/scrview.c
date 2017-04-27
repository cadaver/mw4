#include <stdio.h>
#include <stdlib.h>

char m1[128];
char m2[128];
char m3[128];
char m4[128];
char m5[128];
char m6[128];

int main(int argc, char **argv)
{
        FILE *in;
        int c;

        if (argc < 2) return 1;
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
                if ((m3[c] & 0x1c) == 6*4)
                {
                        printf("Scripted object %d found with param %02x%02x\n", c, m6[c], m5[c]);
                }
        }

        return 0;
}
