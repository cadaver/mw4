#include <stdio.h>
#include <stdlib.h>
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

unsigned char mask[256];
unsigned char color[256];
signed char reversehotspotx[256];
signed char hotspotx[256];
signed char hotspoty[256];
signed char connectspotx[256];
signed char connectspoty[256];
unsigned spriteaddress[256];
int sliceoffset[] = {0,1,2,21,22,23,42,43,44};

int main(int argc, char **argv)
{
  SPRHEADER tempheader;
  int datacount = 0;
  int frameindex = 0;
  int frame = 0;
  int c = 0;
  int length;
  FILE *handle;
  FILE *handle2;
  FILE *handle3;
  handle = fopen(argv[1], "rb");
  handle2 = fopen(argv[2], "wt");
  handle3 = fopen(argv[3], "wb");
  if (!handle) return 1;
  if (!handle2) return 1;
  if (!handle3) return 1;
  fseek(handle, 0, SEEK_END);
  length = ftell(handle);

  if (argc < 4)
  {
    printf("Usage: sprconv2 <infile> <header.s> <data>\n");
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

    mask[frame] = (tempheader.slicemask) & 0xff;
    color[frame] = (tempheader.slicemask >> 9) & 15;
    reversehotspotx[frame] = tempheader.reversehotspotx / 2;
    hotspotx[frame] = tempheader.hotspotx / 2;
    hotspoty[frame] = tempheader.hotspoty;
    connectspotx[frame] = tempheader.connectspotx / 2;
    connectspoty[frame] = tempheader.connectspoty;
    spriteaddress[frame] = datacount;

    for (slice = 0; slice < 9; slice++)
    {
      if (tempheader.slicemask & (1 << slice))
      {
        int slicey;
        for (slicey = 0; slicey < 7; slicey++)
        {
          fwrite8(handle3, fread8(handle));
          datacount++;
        }
      }
    }
    frameindex++;
    frame++;
    if (ftell(handle) >= length) break;
    if (frame > 255) break;
  }
  fclose(handle);
  fclose(handle3);

  fprintf(handle2, "dspr_adrlo:");
  for (c = 0; c < frame; c++)
  {
    if (c & 15) fprintf(handle2, ",");
    else fprintf(handle2,"\n                dc.b ");
    fprintf(handle2, "$%02x", spriteaddress[c]&0xff);
  }
  fprintf(handle2, "\n");

  fprintf(handle2, "dspr_adrhi:");
  for (c = 0; c < frame; c++)
  {
    if (c & 15) fprintf(handle2, ",");
    else fprintf(handle2,"\n                dc.b ");
    fprintf(handle2, "$%02x", spriteaddress[c] >> 8);
  }
  fprintf(handle2, "\n");

  fprintf(handle2, "dspr_color:");
  for (c = 0; c < frame; c++)
  {
    if (c & 15) fprintf(handle2, ",");
    else fprintf(handle2,"\n                dc.b ");
    fprintf(handle2, "$%02x", color[c]&0xff);
  }
  fprintf(handle2, "\n");

  fprintf(handle2, "dspr_mask:");
  for (c = 0; c < frame; c++)
  {
    if (c & 15) fprintf(handle2, ",");
    else fprintf(handle2,"\n                dc.b ");
    fprintf(handle2, "$%02x", mask[c]&0xff);
  }
  fprintf(handle2, "\n");

  fprintf(handle2, "dspr_hotspotx:");
  for (c = 0; c < frame; c++)
  {
    if (c & 15) fprintf(handle2, ",");
    else fprintf(handle2,"\n                dc.b ");
    fprintf(handle2, "$%02x", (-hotspotx[c])&0xff);
  }
  fprintf(handle2, "\n");

  fprintf(handle2, "dspr_reversehotspotx:");
  for (c = 0; c < frame; c++)
  {
    if (c & 15) fprintf(handle2, ",");
    else fprintf(handle2,"\n                dc.b ");
    fprintf(handle2, "$%02x", (-reversehotspotx[c])&0xff);
  }
  fprintf(handle2, "\n");


  fprintf(handle2, "dspr_hotspoty:");
  for (c = 0; c < frame; c++)
  {
    if (c & 15) fprintf(handle2, ",");
    else fprintf(handle2,"\n                dc.b ");
    fprintf(handle2, "$%02x", (-hotspoty[c])&0xff);
  }
  fprintf(handle2, "\n");

  fclose(handle2);
  return 0;
}
