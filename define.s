CONFIG_LENGTH   = 2                           ;Size of config in bytes

SCROLLROWS      = 21                          ;Amount of scrolling rows

NUMGAMES        = 3                             ;Savegames
NUMBLOCKS       = 128
NUMSPRFILES     = 31
NUMSPR          = 24
NUMSPRIRQ       = 16
NUMGRP          = 7                             ;Number of "groups" in game
NUMACT          = 20
NUMDEPACKSPR    = NUMACT
NUMCOMPLEXACT   = 7
NUMLEVELS       = 27                            ;Max. levels in game
NUMLVLACT       = 427
NUMLVLOBJ       = 128                           ;Max. objects in a level
NUMZONES        = 32                            ;Max. zones in a level
NUMRANDOMACT    = 16                            ;Random actor definitions
NUMPLOTBITS     = 80                            ;Boolean flags for plot state
NUMACTTRIGGER   = 32                            ;Maximum actortriggers
NUMWAYPOINTS    = 3                             ;Max. AI waypoints


NUMWEAPONS      = 24                          ;Max. different weapons
NUMBULLETS      = 24                          ;Max. different bullet types
NUMSPECDMG      = 5                           ;Max. special damage types
NUMITEMS        = 63                          ;Max. items (including weapons)

INVENTORYSIZE   = 48                          ;Player inventory size


FILE_SPRITE     = $05
FILE_SCRIPT     = $24
FILE_TITLE      = $42
FILE_MAP        = $43
FILE_FACES      = $44
FILE_MUSIC      = $45
FILE_LEVEL      = $52
FILE_ACTORS     = $6D
FILE_SAVE       = $70

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³Zeropage memory usage                                                        ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

savea           = $02                           ;Register storage for
savex           = $03                           ;interrupts
savey           = $04
irqtemp1        = $05
irqtemp2        = $06
irqirqcount     = $07
irqsprstart     = $08
irqsprend       = $09
irqirqstart     = $0a
irqirqend       = $0b
ntscdelay       = $0c

depacksprflag   = $0d
frameupdflag    = $0e
scrollx         = $0f                           ;Fine scrolling, with 3 bits
scrolly         = $10                           ;subpixel accuracy (0-63)
scrollsx        = $11                           ;Scrolling speed, with 3 bits
scrollsy        = $12                           ;subpixel accuracy
scrcounter      = $13                           ;Scrolling phase variable
blockx          = $14                           ;Upper-left corner position
blocky          = $15                           ;within a block (0-3)
mapx            = $16                           ;Upper-left corner within the
mapy            = $17                           ;map
screen          = $18                           ;Number of gamescreen (0 or 1)
numspr          = $19
sortsprstart    = $1a
sortsprend      = $1b
sortirqstart    = $1c
sortirqend      = $1d
temp1           = $1e
temp2           = $1f
temp3           = $20
temp4           = $21
temp5           = $22
temp6           = $23
temp7           = $24
tempadrlo       = $25
tempadrhi       = $26
sprsubxl        = $27
sprsubxh        = $28
sprsubyl        = $29
sprsubyh        = $2a
actlptrlo       = $2b                           ;Actor logic struct. pointer
actlptrhi       = $2c
actcapbits      = $2d

speedpos        = $2e                           ;Temp for actor move routines
speedneg        = $2f
accelpos        = $30
accelneg        = $31

targetxdist     = $2e                           ;AI routines
targetabsxdist  = $2f
targetydist     = $30
targetabsydist  = $31
targetycompare  = $32
targetactive    = $33
actreactmode    = $34

attackolddir    = $2e                           ;Extra temp variables used by
attackxmod      = $2f                           ;attack routines
ammotype        = $30
oldwf           = $31
cbcrestx        = $32
cbcresty        = $33

actdptrlo       = $2e                           ;Extra temp variables used by
actdptrhi       = $2f                           ;display routines
actfptrlo       = $30
actfptrhi       = $31

msgtime         = $35                           ;Message system counter
choicenum       = $36                           ;Multichoice routine
textwindowrow   = $37                           ;Text window params.
textwindowcolumn = $38
textwindowleft  = $39
textwindowright = $3a
freesprites     = $3b                           ;Free sprites counter

alo             = $3c                           ;Accumulator for multiplication
ahi             = $3d
aonum           = $3e
donum           = $3f
limitl          = $40
limitr          = $41
limitu          = $42
limitd          = $43
lvlactptrlo     = $44                           ;Level actor search pointer
lvlactptrhi     = $45
lvlobjstatptrlo = $46                           ;Pointer to level object status
lvlobjstatptrhi = $47                           ;bits
actrestx        = $48
actresty        = $49

textptrlo       = $4a
textptrhi       = $4b

keypress        = $4c
keytype         = $4d
joystick        = $4e
prevjoy         = $4f
keyrowtbl       = $50
sortorder       = $58

ntscflag        = $71
reuaddrlo       = $72                           ;REU address
reuaddrhi       = $73
loadtempreg     = $74
bufferstatus    = $75                           ;Bytes in REU/fastload buffer
fileopen        = $76                           ;File open indicator
fastloadstatus  = $77                           ;Fastloader active indicator

zp_len_lo       = $78
zp_src_lo       = $79
zp_src_hi       = $7a
zp_bits_lo      = $7b
zp_bits_hi      = $7c
zp_bitbuf       = $7d
zp_dest_lo      = $7e
zp_dest_hi      = $7f

maptemp1        = $7c                           ;Extra temp variables used by
maptemp2        = $7d                           ;INITMAP. This is because
maptemp3        = $7e                           ;LOADFILERETRY automatically
maptemp4        = $7f                           ;calls it.
itemsearch      = $80
targetframes    = $81
scrollcenterx   = $82
scrollcentery   = $83
mapptrlo        = $84
mapptrhi        = $85
mapsizex        = $86
dmgmullo        = $87
dmgmulhi        = $88

musiczpbase     = $fb

sprx            = $c0
spry            = $d8

sortsprx        = $0100
sortspry        = $0130
sortsprd010     = $0160

sprf            = $0200
sprc            = $0218
spract          = $0230
actfb           = $0248

sprfilebaseframe = $02a7
sprfileframes    = $02c7
sprfiletime      = $02e7

maincodestart   = $0334

randomareastart = $2000
randomareaend   = $4000

scriptarea      = $9700
musicarea       = $9f00
depackbuffer    = $a700
blktbllo        = $a700
blktblhi        = $a780
loadbuffer      = $a800
maptbllo        = $a800
maptblhi        = $a880
map             = $a900
randomacttbl    = $b600
bganimcode      = $b620
blocks          = $b680
blkcoltbl       = $be80
charinfo        = $bf00
textscreen      = $c000
screen1         = $c000
screen2         = $c400
menutextchars   = $d000
chars           = $f800
textchars       = $f800
colors          = $d800

bootcodestart   = $c780
loadpicdata     = $d800

reustatus       = $df00         ;REU registers
command         = $df01
c64base         = $df02
reubase         = $df04
translen        = $df07
irqmask         = $df09
control         = $df0A

status          = $90           ;Kernal zeropage variables
messages        = $9d
fa              = $ba

scnkey          = $ff9f
ciout           = $ffa8         ;Kernal routines
listen          = $ffb1
second          = $ff93
unlsn           = $ffae
acptr           = $ffa5
chkin           = $ffc6
chkout          = $ffc9
chrin           = $ffcf
chrout          = $ffd2
ciout           = $ffa8
close           = $ffc3
open            = $ffc0
setmsg          = $ff90
setnam          = $ffbd
setlfs          = $ffba
clrchn          = $ffcc
getin           = $ffe4
load            = $ffd5
save            = $ffd8

                MAC choice
                SUBROUTINE actmacro
                cmp #{1}
                bne .1
                jmp {2}
.1:
                SUBROUTINE actmacroend
                ENDM
