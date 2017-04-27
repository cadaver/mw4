#define KEY_TRACKER 0
#define KEY_DMC 1

#define FORMAT_SID 0
#define FORMAT_PRG 1
#define FORMAT_BIN 2

#define CMD_ARPEGGIO 0
#define CMD_PORTAUP 1
#define CMD_PORTADOWN 2
#define CMD_TONEPORTA 3
#define CMD_VIBRATO 4
#define CMD_SETFILTER 5
#define CMD_SETSUSTAIN 6
#define CMD_SETTEMPO 7

#define EDIT_PATTERN 0
#define EDIT_ORDERLIST 1
#define EDIT_INSTRUMENT 2
#define EDIT_NAMES 3

#define MAX_DIRFILES 4096
#define MAX_FILENAME 60
#define MAX_FILT 64
#define MAX_STR 32
#define MAX_INSTR 32
#define MAX_CHN 3
#define MAX_PATT 208
#define MAX_WAVELEN 127
#define MAX_INSTRNAMELEN 16
#define MAX_PATTROWS 80
#define MAX_SONGLEN 254
#define MAX_SONGS 32

#define REPEAT 0xd0
#define TRANSDOWN 0xe0
#define TRANSUP 0xf0
#define LOOPSONG 0xff

#define ENDPATT 0xff
#define KEYOFF 0x5e
#define REST 0x5f

#define DEFAULTBUFFER 200
#define DEFAULTMIXRATE 44100

#define PGUPDNREPEAT 4

#define VISIBLEPATTROWS 19
#define VISIBLEORDERLIST 11
#define VISIBLEWAVEROWS 7
#define VISIBLEFILES 15

typedef struct
{
  unsigned char ad;
  unsigned char sr;
  unsigned char pulse;
  unsigned char pulseadd;
  unsigned char pulselimitlow;
  unsigned char pulselimithigh;
  unsigned char filtertype;
  unsigned char wavetableindex;
  unsigned char name[MAX_INSTRNAMELEN];
} INSTR;

typedef struct
{
  char name[MAX_FILENAME];
  int attribute;
} DIRENTRY;

typedef struct
{
  unsigned char opcode;
  int length;
} INSTRUCTION;

typedef struct
{
  unsigned char trans;
  unsigned char instrnum;
  unsigned char note;
  unsigned char newnote;
  unsigned char pattptr;
  unsigned char pattnum;
  unsigned char songptr;
  unsigned char repeat;
  unsigned short freq;
  unsigned char wave;
  unsigned char wavetable;
  unsigned char waveinstr;
  unsigned short pulse;
  unsigned char pulsedir;
  unsigned char arpcount;
  unsigned char command;
  unsigned char cmddata;
  unsigned char tick;
  unsigned char tempo;
  unsigned char mute;
  unsigned char hardrestarttimer;
  unsigned char advance;
} CHN;

void playroutine(void);

