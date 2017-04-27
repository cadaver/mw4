/*
 * GoatTracker Instrument -> NinjaTracker sound effect convertor
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "endian.h"
#include "goattrk.h"

int main(int argc, char **argv);
unsigned char swapnybbles(unsigned char n);
void outputbyte(unsigned char c);

int covert = 0;
int bytecount = 0;
FILE *handle;
FILE *out;

int main(int argc, char **argv)
{
  int c,d;
  int prevwave = 0xff;
  int prevwave2 = 0xff;
  int prevnote = 0xff;

  unsigned char ident[4] = {0};
  unsigned char wavetable[MAX_WAVELEN*2];
  INSTR instr;

  if (argc < 3)
  {
    printf("Usage: INS2SND <instrumentfile> <sourcecodefile> <options>\n"
           "-c Produce output in CovertScript format\n\n"
           "Takes a GoatTracker instrument and outputs the corresponding sound effect data\n"
           "as source code. Things that can't be converted and will result in an error:\n"
           "- Waveforms greater than $81\n"
           "- Relative notes\n"
           "- Wavetable longer than 128 bytes\n"
           "- Absolute notes C-0 & C#0\n"
           "Things that will be lost in conversion:\n"
           "- Wavetable loops\n"
           "- Pulsewidth modulation\n"
           "- Filter settings\n");
    return 1;
  }

  handle = fopen(argv[1], "rb");
  if (!handle)
  {
          printf("ERROR: Can't open instrumentfile\n");
          return 1;
  }

  fread(ident, 4, 1, handle);
  if (!memcmp(ident, "GTI!", 4))
  {
    int loadbytes;

    instr.ad = fread8(handle);
    instr.sr = fread8(handle);
    instr.pulse = fread8(handle);
    instr.pulseadd = fread8(handle);
    instr.pulselimitlow = fread8(handle);
    instr.pulselimithigh = fread8(handle);
    instr.filtertype = fread8(handle);
    instr.wavetableindex = fread8(handle);
    fread(&instr.name, MAX_INSTRNAMELEN, 1, handle);
    loadbytes = instr.wavetableindex;
    instr.wavetableindex = 1;
    memset(wavetable, 0, MAX_WAVELEN*2);
    fread(wavetable, loadbytes, 1, handle);
    fclose(handle);
  }
  else
  {
          printf("ERROR: File is not a GoatTracker instrument!\n");
          return 1;
  }

  out = fopen(argv[2], "wt");
  if (!out)
  {
          printf("ERROR: Can't write to output file.\n");
          return 1;
  }

  if (argc > 3)
  {
    for (c = 3; c < argc; c++)
    {
      if (((argv[c][0] == '-') || (argv[c][0] == '/')) && (strlen(argv[c]) > 1))
      {
        int ch = tolower(argv[c][1]);
        switch(ch)
        {
          case 'c':
          covert = 1;
          break;
        }
      }
    }
  }

  d = 0;
  outputbyte(swapnybbles(instr.pulse & 0xfe));
  d++;
  outputbyte(instr.ad);
  d++;
  outputbyte(instr.sr);
  d++;

  for (c = 0; c < MAX_WAVELEN; c++)
  {
    if (wavetable[c*2] == 0xff)
    {
      outputbyte(0);
      d++;
      break;
    }
    if (wavetable[c*2+1] < 0x82)
    {
      printf("ERROR: Relative note or absolute C-0, C#0 found\n");
      fclose(out);
      return 1;
    }
    if (wavetable[c*2] > 0x81)
    {
      printf("ERROR: Waveform greater than $81 found\n");
      fclose(out);
      return 1;
    }
    {
      prevnote = wavetable[c*2+1];
      prevwave = wavetable[c*2];
    }
    {
      outputbyte(wavetable[c*2+1]);
      d++;
      if ((wavetable[c*2]) && (wavetable[c*2] != prevwave2))
      {
        prevwave2 = wavetable[c*2];
        outputbyte(wavetable[c*2]);
        d++;
      }
    }
  }
  if (d > 256)
  {
    fclose(out);
    printf("ERROR: Sound effect exceeds 256 bytes\n");
    return 1;
  }
  fclose(out);
  return 0;
}

void outputbyte(unsigned char c)
{
  if (!covert)
  {
    if (!bytecount)
    {
      fprintf(out, "        dc.b ");
    }
    else fprintf(out, ",");
    fprintf(out, "$%02X", c);
    bytecount++;
    if (bytecount == 16)
    {
      bytecount = 0;
      fprintf(out, "\n");
    }
  }
  else
  {
    if (bytecount)
    {
      fprintf(out,",");
    }
    if (bytecount == 16)
    {
      fprintf(out,"\n");
      bytecount = 0;
    }
    bytecount++;
    fprintf(out, "0x%02x", c);
  }
}

unsigned char swapnybbles(unsigned char n)
{
  unsigned char highnybble = n >> 4;
  unsigned char lownybble = n & 0xf;

  return (lownybble << 4) | highnybble;
}

