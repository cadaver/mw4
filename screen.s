SCROLLCENTER_X  = 91
SCROLLCENTER_Y  = 158
CENTER_OFFSET   = 16

SPRMC1          = 10                             ;Sprite multicolors
SPRMC2          = 0
PANELMC1        = 11
PANELMC2        = 5

SCR_GAME1       = 0                             ;Screen numbers
SCR_GAME2       = 1
SCR_TEXT        = 2

SD_UPLEFT       = 0                             ;Possible screen shifting
SD_UP           = 1                             ;directions (when scrolling)
SD_UPRIGHT      = 2
SD_LEFT         = 3
SD_NOSHIFT      = 4
SD_RIGHT        = 5
SD_DOWNLEFT     = 6
SD_DOWN         = 7
SD_DOWNRIGHT    = 8

TEXT_D018       = $0e                           ;$d018 value for scorepanel

CI_GROUND       = 1                             ;Char info bits
CI_OBSTACLE     = 2
CI_CLIMB        = 4
CI_DOOR         = 8
CI_STAIRS       = 16
CI_SHELF        = 16
CI_SLOPE1       = 32
CI_SLOPE2       = 64
CI_SLOPE3       = 128
CI_LIFT         = 128

SC_DECISION     = 0
SC_SCREEN       = 1
SC_COLORS       = 2

;-------------------------------------------------------------------------------
; UPDATEFRAME
;
; Sorts sprites, copies the scrolling values & screen number for the raster
; interrupt and performs scrollwork.
;
; Parameters: -
; Returns: -
; Modifies: A,X
;-------------------------------------------------------------------------------

updateframe:    jsr sortsprites
                lda scrollx
                lsr
                lsr
                lsr
                ora #$10
                sta rgscr_newscrollx+1
                lda scrolly
                lsr
                lsr
                lsr
                ora #$10
                sta rgscr_newscrolly+1
                lda screen
                sta rgscr_newscreen+1
                lda scrcounter                  ;Have to wait for colorshift &
                and #SC_COLORS                  ;sprite depack
                ora depacksprflag
                beq uf_nowait
uf_wait:        lda $d012
                cmp #RASTER_PANEL_POS
                bcc uf_wait
                lda depacksprflag
                beq uf_nowait
                lda #$00
                sta depacksprflag
                jsr depacksprites
uf_nowait:      inc frameupdflag
                jmp scrollwork



;-------------------------------------------------------------------------------
; SCRIPTUPDATEFRAME
;
; Frame update for prolonged script execution, with stationary scrolling
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

scriptupdateframe:
                jsr getcontrols
                jsr updatepanel
                jsr drawactors
                jsr updateframe
                jsr scrolllogic
                jsr interpolateactors
                jsr updateframe
                jmp scrolllogic

;-------------------------------------------------------------------------------
; CLEARTEXTSCREEN
;
; Clears the textscreen and shows it.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

cleartextscreen:jsr sswc_wait
                lda #$02
                sta screen
                sta rgscr_newscreen+1
                lda #$57                        ;Set gamescreen blank
                sta rgscr_scry+1
                lda #$00                        ;No sprites
                sta rgscr_spronmask+1
                jsr cts_setcolors
                lda #$20
cts_loop2:      sta textscreen,x
                sta textscreen+$100,x
                sta textscreen+$200,x
                sta textscreen+$248,x
                inx
                bne cts_loop2
                inc frameupdflag
                jmp sl_noredraw                         ;Ensure lack of
                                                        ;screen shifting until
                                                        ;redrawn

cts_setcolors:  ldx #$00
cts_loop1:      sta colors,x
                sta colors+$100,x
                sta colors+$200,x
                sta colors+$248,x
                inx
                bne cts_loop1
                rts

sswc_wait:
sswc_loop1:     lda frameupdflag
                bne sswc_loop1
sswc_loop2:     lda $d011
                bpl sswc_loop2
                rts

;-------------------------------------------------------------------------------
; DRAWSCREEN
;
; Draws the whole gamescreen.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,temp1-temp6
;-------------------------------------------------------------------------------

drawscreen:     jsr cleartextscreen                   ;Clear screen 0
                lda #$01                              ;(textscreen) and draw
                sta screen                            ;graphics on screen 1
                ldy mapy
                lda maptbllo,y
                sta temp3
                lda maptblhi,y
                sta temp4
                lda blocky
                asl
                asl
                ora blockx
                sta temp1
                sta temp2
                lda #$00
                sta ssdu_sta+1
                sta drsc_sta+1
                lda #>screen2
                sta ssdu_sta+2
                lda #>colors
                sta drsc_sta+2
                lda #SCROLLROWS
                sta temp6
drsc_loop:      jsr ssdu_common2
drsc_colorloop: lda vcolbuf,x
drsc_sta:       sta colors,x
                dex
                bpl drsc_colorloop
                lda ssdu_sta+1
                clc
                adc #40
                sta ssdu_sta+1
                sta drsc_sta+1
                bcc drsc_notover1
                inc ssdu_sta+2
                inc drsc_sta+2
drsc_notover1:  ldy temp1
                lda cpd_tbl,y
                bpl drsc_notover3
                pha
                lda temp3
                clc
                adc mapsizex
                sta temp3
                pla
                bcc drsc_notover3
                inc temp4
drsc_notover3:  and #$0f
                sta temp1
                sta temp2
                dec temp6                       ;All screen rows done?
                bne drsc_loop
                rts

;-------------------------------------------------------------------------------
; INITSCROLL
;
; Resets scrolling variables
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

setredraw:      lda #$03
                sta screen
initscroll:     lda #$00
                sta scrollsx
                sta scrollsy
                sta scrcounter
                jmp sl_calcsprsub


;-------------------------------------------------------------------------------
; SCROLLLOGIC
;
; Performs all calculations for scrolling, and makes preparations for
; SCROLLSCREEN/COLORS. This is a routine that allows freedirectional scrolling,
; with screen shifting max. every second frame.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

scrollinterpolate:
sl_newscrollx:  lda #$00                        ;Put the precalculated
                sta scrollx                     ;finescrollvalues into use
sl_newscrolly:  lda #$00
                sta scrolly                     ;Move to phase 2: color
                inc scrcounter                  ;scrolling
sl_calcsprsub:  lda scrollx
                lsr
                lsr
                lsr
                and #$01
                sta sspr_finescroll+1
                lda scrollx
                eor #$38
                and #$30
                sta temp1
                lda blockx
                ror
                ror
                ror
                and #$c0
                ora temp1
                sec
                sbc #248
                sta sprsubxl
                lda mapx
                sbc #0
                sta sprsubxh
                lda scrolly
                and #$38
                eor #$38
                sta temp1
                lda blocky
                ror
                ror
                ror
                and #$c0
                ora temp1
                sec
                sbc #176
                sta sprsubyl
                lda mapy
                sbc #1
                sta sprsubyh
                rts

scrolllogic:    lda mapx
                sta ub_oldmapx+1
                lda mapy
                sta ub_oldmapy+1
                lda blockx
                sta ub_oldblockx+1
                lda blocky
                sta ub_oldblocky+1
                lda screen
                cmp #$02
                bcc sl_ok
                beq sl_noredraw
                jsr drawscreen
sl_noredraw:    lda #SC_DECISION
                sta scrcounter
                rts

sl_ok:          lda scrcounter
                bne scrollinterpolate
                lda scrollx                     ;Phase 0: No shifting yet -
                sec                             ;limit scrolling inside the
                sbc scrollsx                    ;char (finescrolling) and
                bpl sl_ph0xok1                  ;make preparations for shifting
                lda #$00                        ;the screen.
sl_ph0xok1:     cmp #$40
                bcc sl_ph0xok2
                lda #$3f
sl_ph0xok2:     sta scrollx
                lda scrolly
                sec
                sbc scrollsy
                bpl sl_ph0yok1
                lda #$00
sl_ph0yok1:     cmp #$40
                bcc sl_ph0yok2
                lda #$3f
sl_ph0yok2:     sta scrolly
                jsr sl_calcsprsub
                ldx #SD_NOSHIFT                 ;Determine direction of shift
                lda scrolly                     ;and precalculate finescroll
                sec                             ;values for next frame
                sbc scrollsy
                bpl sl_ph0yok3
                pha
                lda mapy
                clc
                adc #$06
                cmp limitd
                bcc sl_noylimit1
                lda blocky
                cmp #$02
                bcc sl_noylimit1
                pla
                lda #$00
                sta scrollsy
                beq sl_ph0yok4
sl_noylimit1:   lda blocky
                adc #$01                        ;Carry = 0
                and #$03
                sta blocky
                bne sl_ph0ydownok
                inc mapy
sl_ph0ydownok:  pla
                ldx #SD_DOWN
                bne sl_ph0yok4
sl_ph0yok3:     cmp #$40
                bcc sl_ph0yok4
                pha
                lda mapy
                cmp limitu
                bne sl_noylimit2
                lda blocky
                bne sl_noylimit2
                pla
                lda #$00
                sta scrollsy
                lda #$3f
                bne sl_ph0yok4
sl_noylimit2:   lda blocky
                sbc #$01                        ;Carry = 1
                and #$03
                sta blocky
                cmp #$03
                bne sl_ph0yupok
                dec mapy
sl_ph0yupok:    pla
                ldx #SD_UP
sl_ph0yok4:     and #$3f
                sta sl_newscrolly+1
                lda scrollx                     ;Then horizontal
                sec
                sbc scrollsx
                bpl sl_ph0xok3
                pha
                lda mapx
                clc
                adc #$0a
                cmp limitr
                bcc sl_noxlimit1
                lda blockx
                cmp #$01
                bcc sl_noxlimit1
                pla
                lda #$00
                sta scrollsx
                beq sl_ph0xok4
sl_noxlimit1:   lda blockx
                adc #$01                        ;Carry = 0
                and #$03
                sta blockx
                bne sl_ph0xrightok
                inc mapx
sl_ph0xrightok: pla
                inx
                bpl sl_ph0xok4
sl_ph0xok3:     cmp #$40
                bcc sl_ph0xok4
                pha
                lda mapx
                cmp limitl
                bne sl_noxlimit2
                lda blockx
                cmp #$01
                bcs sl_noxlimit2
                pla
                lda #$00
                sta scrollsx
                lda #$3f
                bne sl_ph0xok4
sl_noxlimit2:   lda blockx
                sbc #$01                        ;Carry = 1
                and #$03
                sta blockx
                cmp #$03
                bne sl_ph0xleftok
                dec mapx
sl_ph0xleftok:  pla
                dex
sl_ph0xok4:     and #$3f
                sta sl_newscrollx+1
                stx ss_shiftdir+1
                cpx #SD_NOSHIFT
                beq sl_nophase1
                inc scrcounter
sw_nowork:
sl_nophase1:    rts

;-------------------------------------------------------------------------------
; SCROLLWORK
;
; Performs the "hard work" of scrolling; screen shifting & drawing new data.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,temp1-temp5
;-------------------------------------------------------------------------------

scrollwork:     lda scrcounter
                beq sw_nowork
                cmp #SC_SCREEN
                beq scrollscreen
                jmp scrollcolors

scrollscreen:   lda screen
                eor #$01
                sta screen
ss_shiftdir:    ldx #$00
                lda colorjmptbllo,x             ;Modify the color-jump
                sta sc_colorjump+1              ;already here
                lda colorjmptblhi,x
                sta sc_colorjump+2
                ldy shiftsrctbl,x
                lda screen
                bne ss_shift1
                jmp ss_shift2

ss_shift1:      lda drawjmptbllo,x
                sta ss_drawjump1+1
                lda drawjmptblhi,x
                sta ss_drawjump1+2
                lda shiftworktbl,x              ;source pointer
                sta ss_shiftcmp1+1
                lda shiftdesttbl,x
                tax
ss_shiftloop1:
N               SET 0
                REPEAT SCROLLROWS
                lda screen1-40+N*40,y
                sta screen2+N*40,x
N               SET N+1
                REPEND
                iny
                inx
ss_shiftcmp1:   cpx #$00
                beq ss_shiftdone1
                jmp ss_shiftloop1
ss_shiftdone1:
ss_drawjump1:   jmp $0000

ss_shift2:      lda drawjmptbllo,x
                sta ss_drawjump2+1
                lda drawjmptblhi,x
                sta ss_drawjump2+2
                lda shiftworktbl,x              ;source pointer
                sta ss_shiftcmp2+1
                lda shiftdesttbl,x
                tax
ss_shiftloop2:
N               SET 0
                REPEAT SCROLLROWS
                lda screen2-40+N*40,y
                sta screen1+N*40,x
N               SET N+1
                REPEND
                iny
                inx
ss_shiftcmp2:   cpx #$00
                beq ss_shiftdone2
                jmp ss_shiftloop2
ss_shiftdone2:
ss_drawjump2:   jmp $0000

ss_drawupleft:  jsr ss_drawup
                jmp ss_drawleft

ss_drawupright: jsr ss_drawup
                jmp ss_drawright

ss_drawdownright:jsr ss_drawdown

ss_drawright:   ldx mapy                        ;Draw new blocks to the right
                lda maptbllo,x
                sta temp3
                lda maptblhi,x
                sta temp4
                lda mapx
                clc
                adc #$09
                tax
                lda blockx
                clc
                adc #$02
                cmp #$04
                bcc ssdr_not1
                and #$03
                inx
ssdr_not1:      sta temp1
                txa
                clc
                adc temp3
                sta temp3
                bcc ssdr_not2
                inc temp4
ssdr_not2:      lda #38
                bne ssdl_common

ss_drawdownleft:jsr ss_drawdown

ss_drawleft:    ldx mapy                     ;Draw new blocks to the left
                lda maptbllo,x
                sta temp3
                lda maptblhi,x
                sta temp4
                lda mapx
                clc
                adc temp3
                sta temp3
                bcc sc_dlcalcdone
                inc temp4
sc_dlcalcdone:  lda blockx
                sta temp1
                lda #$00
ssdl_common:    sta ssdl_sta+1
                lda #39
                sta ssdl_sta2+1
                ldx screen
                lda scradrtblhi,x
                sta ssdl_sta+2
                lda #>colors
                sta ssdl_sta2+2
                lda #SCROLLROWS-1
                sta temp5
                lda blocky
                asl
                asl
                ora temp1
                ldx #$00
ssdl_getblock:  sta temp2
                ldy #$00
                lda (temp3),y
                tay
                lda blktbllo,y
                sta ssdl_lda+1
                lda blktblhi,y
                sta ssdl_lda+2
                lda blkcoltbl,y
                sta ssdl_color+1
                ldy temp2
                clc
ssdl_lda:       lda $1000,y
ssdl_sta:       sta $1000,x
ssdl_color:     lda #$00
ssdl_sta2:      sta colors,x
                dec temp5
                bmi ssdl_ready
                txa
                adc #40
                tax
                bcc ssdl_not2
                inc ssdl_sta+2
                inc ssdl_sta2+2
                clc
ssdl_not2:      lda cpd_tbl,y
                tay
                bpl ssdl_lda
ssdl_block:     lda temp3
                adc mapsizex
                sta temp3
                bcc ssdl_not3
                inc temp4
ssdl_not3:      lda temp1
                jmp ssdl_getblock
ss_drawdonothing:
ssdl_ready:     rts

ss_drawdown:    ldx screen                      ;Draw new blocks to the
                lda #<(screen1+SCROLLROWS*40-40);bottom of the screen
                sta ssdu_sta+1
                lda scradrtblhi,x
                ora #>(SCROLLROWS*40-40)
                sta ssdu_sta+2
                lda mapy
                clc
                adc #$05
                tax
                lda blocky
                ;adc #$01
                ;cmp #$04
                ;bcc ssdu_common
                ;and #$03
                ;inx
                ;bcs ssdu_common
                bcc ssdu_common

ss_drawup:      ldx screen
                lda #$00
                sta ssdu_sta+1
                lda scradrtblhi,x
                sta ssdu_sta+2
                ldx mapy                        ;Draw new blocks to the
                lda blocky                      ;top of the screen
ssdu_common:    ldy maptbllo,x
                sty temp3
                ldy maptblhi,x
                sty temp4
                asl
                asl
                ora blockx
                sta temp2
ssdu_common2:   ldx #$00
                ldy mapx
ssdu_getblock:  lda (temp3),y
                iny
                sty temp5
                tay
                lda blktbllo,y
                sta ssdu_lda+1
                lda blktblhi,y
                sta ssdu_lda+2
                lda blkcoltbl,y
                sta ssdu_color+1
                ldy temp2
ssdu_lda:       lda $1000,y
ssdu_sta:       sta screen1,x
ssdu_color:     lda #$00
                sta vcolbuf,x
                inx
                cpx #39
                bcs ssdu_ready
                lda cpr_tbl,y
                tay
                bpl ssdu_lda
                and #$0f
                sta temp2
                ldy temp5
                jmp ssdu_getblock
ss_donothing:
sc_donothing:
ssdu_ready:     rts

scrollcolors:   lda #SC_DECISION
                sta scrcounter
sc_colorjump:   jmp $0000

sc_downleft:    jsr sc_down
                jmp sc_left

sc_downright:   jsr sc_down
                jmp sc_right

sc_upleft:      jsr sc_up
sc_left:        lda #$02
                sec
                sbc blockx
                and #$03
                tax
                tay
                iny
                stx temp1
                sty temp2
                clc
sc_leftloop1:   jsr sc_horizcommon
                txa
                adc #$04
                tax
                tay
                iny
                cpy #39
                bcc sc_leftloop1
                cpy #40
                bne sc_leftdone
                ldx #39
                ldy #0
                jmp sc_horizcommon
sc_leftdone:    rts

sc_upright:     jsr sc_up
sc_right:       lda #$04
                sec
                sbc blockx
                and #$03
                tay
                tax
                inx
                stx temp1
                sty temp2
                clc
sc_rightloop1:  jsr sc_horizcommon
                tya
                adc #$04
                tay
                tax
                inx
                cpx #39
                bcc sc_rightloop1
                bne sc_rightdone
                ldy #38
                jmp sc_horizcommon
sc_rightdone:   rts

sc_horizcommon:
N               set 0
                repeat SCROLLROWS
                lda colors+N*40,x
                sta colors+N*40,y
N               set N+1
                repend
                rts

sc_up:          ldx blocky
                lda sc_upjumptbllo,x
                sta sc_upjump+1
                lda sc_upjumptblhi,x
                sta sc_upjump+2
                ldx #38
sc_upjump:      jmp $0000

sc_up0:         lda colors+2*40,x
                sta colors+3*40,x
                lda colors+6*40,x
                sta colors+7*40,x
                lda colors+10*40,x
                sta colors+11*40,x
                lda colors+14*40,x
                sta colors+15*40,x
                lda colors+18*40,x
                sta colors+19*40,x
                dex
                bpl sc_up0
                rts

sc_up1:         lda colors+1*40,x
                sta colors+2*40,x
                lda colors+5*40,x
                sta colors+6*40,x
                lda colors+9*40,x
                sta colors+10*40,x
                lda colors+13*40,x
                sta colors+14*40,x
                lda colors+17*40,x
                sta colors+18*40,x
                dex
                bpl sc_up1
                rts

sc_up2:         lda colors+0*40,x
                sta colors+1*40,x
                lda colors+4*40,x
                sta colors+5*40,x
                lda colors+8*40,x
                sta colors+9*40,x
                lda colors+12*40,x
                sta colors+13*40,x
                lda colors+16*40,x
                sta colors+17*40,x
                ;lda colors+20*40,x
                ;sta colors+21*40,x
                dex
                bpl sc_up2
                rts

sc_up3:         lda vcolbuf,x
                sta colors+0*40,x
                lda colors+3*40,x
                sta colors+4*40,x
                lda colors+7*40,x
                sta colors+8*40,x
                lda colors+11*40,x
                sta colors+12*40,x
                lda colors+15*40,x
                sta colors+16*40,x
                lda colors+19*40,x
                sta colors+20*40,x
                dex
                bpl sc_up3
                rts

sc_down:        ldx blocky
                lda sc_downjumptbllo,x
                sta sc_downjump+1
                lda sc_downjumptblhi,x
                sta sc_downjump+2
                ldx #38
sc_downjump:    jmp $0000

sc_down0:       lda colors+1*40,x
                sta colors+0*40,x
                lda colors+5*40,x
                sta colors+4*40,x
                lda colors+9*40,x
                sta colors+8*40,x
                lda colors+13*40,x
                sta colors+12*40,x
                lda colors+17*40,x
                sta colors+16*40,x
                lda vcolbuf,x
                sta colors+20*40,x
                dex
                bpl sc_down0
                rts

sc_down1:       lda colors+4*40,x
                sta colors+3*40,x
                lda colors+8*40,x
                sta colors+7*40,x
                lda colors+12*40,x
                sta colors+11*40,x
                lda colors+16*40,x
                sta colors+15*40,x
                lda colors+20*40,x
                sta colors+19*40,x
                dex
                bpl sc_down1
                rts

sc_down2:       lda colors+3*40,x
                sta colors+2*40,x
                lda colors+7*40,x
                sta colors+6*40,x
                lda colors+11*40,x
                sta colors+10*40,x
                lda colors+15*40,x
                sta colors+14*40,x
                lda colors+19*40,x
                sta colors+18*40,x
                dex
                bpl sc_down2
                rts

sc_down3:       lda colors+2*40,x
                sta colors+1*40,x
                lda colors+6*40,x
                sta colors+5*40,x
                lda colors+10*40,x
                sta colors+9*40,x
                lda colors+14*40,x
                sta colors+13*40,x
                lda colors+18*40,x
                sta colors+17*40,x
                ;lda vcolbuf,x
                ;sta colors+21*40,x
                dex
                bpl sc_down3
                rts


;-------------------------------------------------------------------------------
; GETCHARPOSINFOXY
; GETCHARPOSINFOXY2
;
; Gets charinfo from actor's position, with both X & Y offset
;
; Parameters: X:Actor number, A:Y offset in chars (positive or negative)
;             Y:X offset in chars (positive or negative)
;
; Returns: A:charinfo
; Modifies: Y,tempadr
;-------------------------------------------------------------------------------

getcharposinfoxy3:
                lda temp3
getcharposinfoxy:
                sta maptemp3
                sty maptemp4
                lda actyl,x
                rol
                rol
                rol
                and #$03
                clc
                adc maptemp3
                sta maptemp1
                bpl gcpixy_pos
gcpixy_neg:     lsr
                lsr
                ora #$c0
                bne gcpixy_common
gcpixy_pos:     lsr
                lsr
gcpixy_common:  clc
                adc actyh,x
                tay
                lda maptbllo,y
                sta tempadrlo
                lda maptblhi,y
                sta tempadrhi
                lda actxl,x
                rol
                rol
                rol
                and #$03
                clc
                adc maptemp4
                tay
                and #$03
                sta maptemp2
                tya
                bpl gcpixy_pos2
gcpixy_neg2:    lsr
                lsr
                ora #$c0
                bne gcpixy_common2
gcpixy_pos2:    lsr
                lsr
gcpixy_common2: clc
                adc actxh,x
                tay
                cpy limitl
                bcc gcpi_out
                cpy limitr
                bcs gcpi_out
                lda maptemp1
                and #$03
                asl
                asl
                ora maptemp2
gcpi_common:    pha
                lda (tempadrlo),y               ;Take block from map
                tay
                lda blktbllo,y
                sta tempadrlo
                lda blktblhi,y
                sta tempadrhi
                sty cst_blocknum+1
                pla
                tay
                lda (tempadrlo),y
                tay
                lda charinfo,y                  ;Take blockinfo
                rts

;-------------------------------------------------------------------------------
; GETCHARPOSINFO
;
; Gets charinfo from actor's position
;
; Parameters: X:Actor number
; Returns: A:charinfo
; Modifies: Y,tempadr
;-------------------------------------------------------------------------------

getcharposinfo: ldy actyh,x
                lda maptbllo,y
                sta tempadrlo
                lda maptblhi,y
                sta tempadrhi
                ldy actxh,x
                cpy limitl                      ;Check that we are within the
                bcc gcpi_out                    ;map
                cpy limitr
                bcs gcpi_out
                lda actyl,x
                and #$c0
                sta maptemp1
                lda actxl,x
                lsr
                lsr
                ora maptemp1
                lsr
                lsr
                lsr
                lsr
                jmp gcpi_common
gcpi_out:       lda #CI_OBSTACLE                ;Checking from outside the
                rts                             ;map results in an obstacle

;-------------------------------------------------------------------------------
; GETCHARPOSINFOOFFSET
;
; Gets charinfo from actor's position, with a certain Y offset
;
; Parameters: X:Actor number, A:Y offset in chars (positive or negative)
; Returns: A:charinfo
; Modifies: Y,tempadr
;-------------------------------------------------------------------------------

getcharposinfooffset:
                sta maptemp1
                lda actyl,x
                rol
                rol
                rol
                and #$03
                clc
                adc maptemp1
                tay
                and #$03
                sta maptemp1
                tya
                bpl gcpio_pos
gcpio_neg:      lsr
                lsr
                ora #$c0
                bne gcpio_common
gcpio_pos:      lsr
                lsr
gcpio_common:   clc
                adc actyh,x
                tay
                lda maptbllo,y
                sta tempadrlo
                lda maptblhi,y
                sta tempadrhi
                ldy actxh,x
                cpy limitl
                bcc gcpi_out
                cpy limitr
                bcs gcpi_out
                lda actxl,x
                rol
                and #$80
                ora maptemp1
                rol
                rol
                jmp gcpi_common

;-------------------------------------------------------------------------------
; UPDATEBLOCK
;
; Updates a block on the map, if it's visible.
;
; Parameters: A:Change to block (deltavalue)
;             X,Y:Map position
; Modifies: A,X,Y,temp regs
;-------------------------------------------------------------------------------

ub_done2:       rts
ub_outside:     lda zonenum                     ;For restoring original zone
                sta ub_origzone+1
                jsr findzonexy                  ;Find zone by coords
                lda temp5
                sec
                sbc limitl
                sta temp5
                lda temp6
                sbc limitu
                ldy mapsizex
                ldx #alo
                jsr mulu
                lda alo
                clc
                adc mapptrlo
                sta alo
                lda ahi
                adc mapptrhi
                sta ahi
                jsr ub_modify
ub_origzone:    lda #$00
                jmp findzonenum

updateblock2:   lda #$ff
updateblock:    sta temp7
                stx temp5
                sty temp6
                cpx limitl                      ;Outside current zone?
                bcc ub_outside
                cpx limitr
                bcs ub_outside
                cpy limitu
                bcc ub_outside
                cpy limitd
                bcs ub_outside
                lda maptbllo,y
                sta alo
                lda maptblhi,y
                sta ahi
                jsr ub_modify
                tya
                sec
ub_oldmapx:     sbc #$00
                cmp #11
                bcs ub_done2
                asl
                asl
                sec
ub_oldblockx:   sbc #$00
                sta temp3
                lda temp6
                sec
ub_oldmapy:     sbc #$00
                cmp #7
                bcs ub_done
                asl
                asl
                sec
ub_oldblocky:   sbc #$00
                sta temp4
                ldy temp7
                lda blktbllo,y
                sta ub_lda+1
                lda blktblhi,y
                sta ub_lda+2
;                lda blkcoltbl,y
;                sta ub_lda2+1
                ldx screen
                cpx #$02
                bcs ub_done
                lda scradrtblhi,x
                sta temp6
                ldx #$00
ub_row:         ldy temp4
                cpy #SCROLLROWS
                bcs ub_skiprow
                stx maptemp1
                ldx #temp1
                lda #40
                jsr mulu
                ldx maptemp1
                lda temp1
                sta ub_sta+1
               ; sta ub_sta2+1
                lda temp2
              ;  pha
                ora temp6
                sta ub_sta+2
              ;  pla
              ;  ora #>colors
              ;  sta ub_sta2+2
                ldy temp3
ub_column:      cpy #39
                bcs ub_skipcolumn
ub_lda:         lda $1000,x
ub_sta:         sta screen1,y
;ub_lda2:        lda #$00
;ub_sta2:        sta colors,y
ub_skipcolumn:  iny
                inx
                txa
                and #$03
                bne ub_column
ub_nextrow:     inc temp4
                cpx #$10
                bcc ub_row
ub_done:        rts
ub_skiprow:     txa
                adc #$03                        ;Carry = 1
                tax
                bne ub_nextrow

ub_modify:      ldy temp5
                lda temp7
                clc
                adc (alo),y
                sta (alo),y                     ;Update block on map
                sta temp7
                rts
