#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "endian.h"

typedef struct
{
  short slicemask;
  signed char hotspotx;
  signed char reversehotspotx;
  signed char hotspoty;
  signed char connectspotx;
  signed char reverseconnectspotx;
  signed char connectspoty;
} SPRHEADER;

unsigned char color[256];
signed char hotspotx[256];
signed char hotspoty[256];
signed char connectspotx[256];
signed char connectspoty[256];
unsigned char spritedata[16384];
int sliceoffset[] = {0,1,2,21,22,23,42,43,44};
void flipspr(unsigned char *dest, unsigned char *src);

void flipspr(unsigned char *dest, unsigned char *src)
{
        int y,x;
        for (y = 0; y < 21; y++)
        {
                for (x = 0; x < 3; x++)
                {
                        unsigned char sb, db;
                        sb = src[y*3+x];
                        db = (((sb & 0x03) << 6) |
                              ((sb & 0x0c) << 2) |
                              ((sb & 0x30) >> 2) |
                              ((sb & 0xc0) >> 6));
                        dest[y*3+2-x] = db;
                }
        }
}

int main(int argc, char **argv)
{
  SPRHEADER tempheader;
  unsigned char fliptemp[64];

  int frameindex = 0;
  int frame = 0;
  int c = 0;
  int length;
  FILE *handle;
  handle = fopen(argv[1], "rb");
  if (!handle) return 1;
  fseek(handle, 0, SEEK_END);
  length = ftell(handle);

  if (argc < 4)
  {
    printf("Usage: sprconv <infile> <header> <data>\n");
    return 1;
  }
  for (;;)
  {
    int slice;
    unsigned offset;

    fseek(handle, frameindex*2+3, SEEK_SET);
    offset = freadle16(handle);
    offset += 3;
    fseek(handle, offset, SEEK_SET);

    tempheader.slicemask = freadle16(handle);
    tempheader.hotspotx = fread8(handle);
    tempheader.reversehotspotx = fread8(handle);
    tempheader.hotspoty = fread8(handle);
    tempheader.connectspotx = fread8(handle);
    tempheader.reverseconnectspotx = fread8(handle);
    tempheader.connectspoty = fread8(handle);

    color[frame] = (tempheader.slicemask >> 9) & 15;
    hotspotx[frame] = tempheader.hotspotx / 2;
    hotspoty[frame] = tempheader.hotspoty;
    connectspotx[frame] = tempheader.connectspotx / 2;
    connectspoty[frame] = tempheader.connectspoty;

    for (slice = 0; slice < 9; slice++)
    {
      if (tempheader.slicemask & (1 << slice))
      {
        int slicey;
        for (slicey = 0; slicey < 7; slicey++)
        {
          spritedata[frame * 64 + sliceoffset[slice] + slicey * 3] = fread8(handle);
        }
      }
      else
      {
        int slicey;
        for (slicey = 0; slicey < 7; slicey++)
        {
          spritedata[frame * 64 +
          sliceoffset[slice] + slicey * 3] = 0;
        }
      }
    }
    frameindex++;
    frame++;
    if (ftell(handle) >= length) break;
    if (frame > 255) break;
  }
  fclose(handle);

  handle = fopen(argv[2], "wb");
  if (!handle) return 1;

  fwrite8(handle, frame); // Amount of frames first
  for (c = 0; c < frame; c++)
  {
    fwrite8(handle, color[c]);
    fwrite8(handle, -hotspotx[c]);
    fwrite8(handle, -hotspoty[c]);
    fwrite8(handle, connectspotx[c]);
    fwrite8(handle, connectspoty[c]);
  }
  fclose(handle);

  for (c = 1; c < frame; c++)
  {
        int d;

        flipspr(fliptemp, &spritedata[64*c]);

        spritedata[64*c+63] = 0; // Assume no flipping
        for (d = 0; d < c; d++)
        {
                if (spritedata[64*d+63] == 0) // If sourcesprite isn't flipped
                {
                        if (!memcmp(fliptemp, &spritedata[64*d], 63))
                        {
                                memset(&spritedata[64*c],0,63);
                                spritedata[64*c+63] = d+1; // Source frame to use in flipping
                                printf("Flip duplicate of sprite %d found at %d\n", d,c);
                                break;
                        }
                }
        }
  }

  for (c = 0; c < frame; c++)
  {
    unsigned char tempspr[64];
    int d, e;

    memcpy(tempspr, &spritedata[64*c], 64);

    for (d = 0; d < 3; d++)
    {
      for (e = 0; e < 21; e++)
      {
        spritedata[64*c+d*21+e] = tempspr[e*3+d];
      }
    }
  }

  handle = fopen(argv[3], "wb");
  if (!handle) return 1;
  fwrite(spritedata, 1, frame * 64, handle);
  fclose(handle);

  return 0;
}
