                processor 6502
                org $1000

KEY_UP          = $91
KEY_DOWN        = $11
KEY_ENTER       = $0d
KEY_SPACE       = $20


JOY_UP          = 1
JOY_DOWN        = 2
JOY_LEFT        = 4
JOY_RIGHT       = 8
JOY_FIRE        = 16

keypress        = $4c
keytype         = $4d
joystick        = $4e
prevjoy         = $4f
keyrowtbl       = $50
ntscflag        = $71



maptemp1        = $7c                           ;Extra temp variables used by
maptemp2        = $7d                           ;INITMAP. This is because
maptemp3        = $7e                           ;LOADFILERETRY automatically
maptemp4        = $7f                           ;calls it.

musiczpbase     = $02

scnkey          = $ff9f
getin           = $ffe4

                jsr relocatemusic
                lda #$08                        ;Set testbit on all channels
                sta $d404
                sta $d404+7
                sta $d404+14
                lda #$00                        ;Filter lowbyte
                sta $d415
                lda #$00
                sta joystick
                sta prevjoy
                sta keytype
                jsr initraster
                jmp instrstart

initraster:     sei
                lda #<raster
                sta $0314
                lda #>raster
                sta $0315
                lda #$fa-$10
                sta $d012
                lda $d011
                and #$7f                        ;Set high bit of raster
                sta $d011                       ;position (0)
                lda #$7f                        ;Set timer interrupt off
                sta $dc0d
                lda #$01                        ;Set raster interrupt on
                sta $d01a
                lda $dc0d                       ;Acknowledge timer interrupt
                cli
                rts

uninitraster:   sei
                lda #<$ea31
                sta $0314
                lda #>$ea31
                sta $0315
                lda #$00
                sta $d01a
                lda #$81
                sta $dc0d
                lda #$00
                sta $d404
                sta $d404+7
                sta $d404+14
                inc $d019
                cli
                rts

raster:         lda ntscdelay                   ;Handle NTSC delay
                sec
                sbc ntscflag
                bcs r_nontscdelay
                lda #$05
r_nontscdelay:  sta ntscdelay
                bcc r_skipmusic
                jsr music
r_skipmusic:    lda $d011
                bmi r_waitok
                lda $d012
                cmp #$fa
                bcc r_skipmusic

r_waitok:       inc rastercnt
                dec $d019
                jmp $ea81

instrstart:     lda #3
                sta $d011
                lda #8
                sta $d016
                lda #$98
                sta $d018
                lda $dd00
                and #$fc
                ora #$03
                sta $dd00
                lda #$3f
                sta finescroll
                ldx #$00
                lda #$0f
instrcolors:    sta $d800,x
                sta $d900,x
                sta $da00,x
                sta $db00,x
                dex
                bne instrcolors
                lda #<instrtext
                sta textptr
                lda #>instrtext
                sta textptr+1

                lda #-8*8
                sta scrollspeed
instrforced:    jsr waitraster
                jsr doscroll
                lda textptr
                cmp #<textstart
                bne instrforced
                lda textptr+1
                cmp #>textstart
                bne instrforced
                lda #0
                sta scrollspeed

instrloop:      jsr waitraster
                jsr doscroll
                jsr getcontrols
                jsr docontrol
                lda prevjoy
                bne instrnoexit
                lda joystick
                and #JOY_FIRE
                bne instrexit
instrnoexit:    lda keytype
                cmp #KEY_ENTER
                beq instrexit
                cmp #KEY_SPACE
                beq instrexit
                jmp instrloop

instrexit:      ldx #$0f
                ldy #$00
fadeout:        jsr waitraster
                stx vmastervolume+1
                iny
                cpy #$05
                bcc fadeout
                ldy #$00
                dex
                bpl fadeout
                lda #$20
                ldx #$00
exitclearscreen:sta $2400,x
                sta $2500,x
                sta $2600,x
                sta $2700,x
                inx
                bne exitclearscreen
                jsr uninitraster
                rts

waitraster:     lda rastercnt
waitraster2:    cmp rastercnt
                beq waitraster2
                rts

doscroll:       lda finescroll
                clc
                adc scrollspeed
                bmi dos_down
                cmp #$40
                bcs dos_up
dos_setd011:    sta finescroll
                lsr
                lsr
                lsr
                and #$07
                ora #$10
                sta $d011
                rts
dos_down:       and #$3f
                jsr dos_setd011
                lda textptr
                cmp #<textend
                bne dos_downok
                lda textptr+1
                cmp #>textend
                bne dos_downok
                lda #$00
                sta scrollspeed
                jmp dos_setd011
dos_downok:     lda textptr
                clc
                adc #40
                sta textptr
                lda textptr+1
                adc #0
                sta textptr+1
                jmp dos_drawtext

dos_up:         and #$3f
                jsr dos_setd011
                lda textptr
                cmp #<textstart
                bne dos_upok
                lda textptr+1
                cmp #>textstart
                bne dos_upok
                lda #$00
                sta scrollspeed
                lda #$3f
                jmp dos_setd011
dos_upok:       lda textptr
                sec
                sbc #40
                sta textptr
                lda textptr+1
                sbc #0
                sta textptr+1
dos_drawtext:   lda textptr
                sta dos_lda1+1
                sta dos_lda3+1
                sta dos_lda5+1
                sta dos_lda7+1
                clc
                adc #$80
                sta dos_lda2+1
                sta dos_lda4+1
                sta dos_lda6+1
                sta dos_lda8+1
                ldx textptr+1
                stx dos_lda1+2
                stx dos_lda2+2
                inx
                stx dos_lda3+2
                stx dos_lda4+2
                inx
                stx dos_lda5+2
                stx dos_lda6+2
                inx
                stx dos_lda7+2
                stx dos_lda8+2
                bcc dos_dtok
                inc dos_lda2+2
                inc dos_lda4+2
                inc dos_lda6+2
                inc dos_lda8+2
dos_dtok:       ldx #$00
dos_loop1:
dos_lda1:       lda $1000,x
                sta $2400,x
dos_lda2:       lda $1000,x
                sta $2480,x
                inx
                bpl dos_loop1
                ldx #$00
dos_loop2:
dos_lda3:       lda $1000,x
                sta $2500,x
dos_lda4:       lda $1000,x
                sta $2580,x
                inx
                bpl dos_loop2
                ldx #$00
dos_loop3:
dos_lda5:       lda $1000,x
                sta $2600,x
dos_lda6:       lda $1000,x
                sta $2680,x
                inx
                bpl dos_loop3
                ldx #$00
dos_loop4:
dos_lda7:       lda $1000,x
                sta $2700,x
dos_lda8:       lda $1000,x
                sta $2780,x
                inx
                bpl dos_loop4
                rts

dc_keyup:       lda #6*8
                sta scrollspeed
                rts
dc_keydown:     lda #-6*8
                sta scrollspeed
                rts

docontrol:      lda keypress
                cmp #KEY_UP
                beq dc_keyup
                cmp #KEY_DOWN
                beq dc_keydown
                lda joystick
                and #JOY_DOWN
                beq dc_notup
dc_up:          lda scrollspeed
                bpl dc_upok
                cmp #-6*8
                beq dc_notdown
                bcc dc_notdown
dc_upok:        dec scrollspeed
                dec scrollspeed
                rts
dc_notup:       lda joystick
                and #JOY_UP
                beq dc_brake
dc_down:        lda scrollspeed
                bmi dc_downok
                cmp #6*8
                bcs dc_notdown
dc_downok:      inc scrollspeed
                inc scrollspeed
dc_notdown:     rts

dc_brake:       lda scrollspeed
                beq dc_notdown
                bmi dc_downok
                bpl dc_upok

;-------------------------------------------------------------------------------
; GETCONTROLS
;
; Reads joystick + scans the keyboard.
;
; Parameters: -
; Returns: -
; Modifies: A
;-------------------------------------------------------------------------------

getcontrols:    lda #$ff
                sta $dc00
                lda joystick
                sta prevjoy
                lda $dc00
                eor #$ff
                and #JOY_UP|JOY_DOWN|JOY_LEFT|JOY_RIGHT|JOY_FIRE
                sta joystick
                jsr scnkey
                jsr getin
                sta keytype
                sta keypress
                rts

;-------------------------------------------------------------------------------
; GETFIRECLICK
;
; Checks if fire button has been pressed shortly.
;
; Parameters: -
; Returns: C=0 not pressed, C=1 pressed
; Modifies: A
;-------------------------------------------------------------------------------

getfireclick:   clc
                lda prevjoy
                and #JOY_FIRE
                bne gfc_not
                lda joystick
                and #JOY_FIRE
                beq gfc_not
                sec
gfc_not:        rts

;-------------------------------------------------------------------------------
;Playroutine
;-------------------------------------------------------------------------------

music_silence:  rts

music:          ldx #$ff                        ;Nonzero = disallow music
                bne music_silence
vinitsongnum:   ldy #$03
                bmi vchnloop
                txa
                ldx #21
vclearloop:     sta vchnsongpos-1,x
                dex
                bne vclearloop
                sta musiczpbase+3
                lda #$01
                sta musiczpbase+2
                lda #$ff
                sta vinitsongnum+1
                jsr vinitchn
                ldx #$07
                jsr vinitchn
                ldx #$0e
vinitchn:       tya
                sta vchnsongnum,x
                iny
                dec vchncounter,x
                rts

vfreqmod:       inc vchnwavedelay,x
                bne vfreqmod_ok
                lda vchnwavestored,x
                sta vchnwavepos,x
vfreqmod_ok:    lda vchnfreqlo,x
                clc
                adc vchnfreqmodlo,x
                sta vchnfreqlo,x
                sta $d400,x
                lda vchnfreqhi,x
                adc vchnfreqmodhi,x
                jmp vsetfreqhi

vchnloop:       jsr vchnexec
                ldx #$07
                jsr vchnexec
                ldx #$0e
vchnexec:       ldy vchnsfx,x
                beq vnosfx
                jmp vsfxexec
vnosfx:         ldy vchnwavepos,x
                beq vfreqmod
vwavetblminusaccess1:
                lda vwavetbl-1,y
                beq vhrnote
                cmp #$02
                beq vsetsr
                bcc vlegatonote
                cmp #$90
                bcc vwavechange
                beq vnowavechange

vnewfreqmod:    sta vchnwavedelay,x
vnexttblminusaccess1:
                lda vnexttbl-1,y
                sta vchnwavestored,x
vnotetblminusaccess1:
                lda vnotetbl-1,y
                asl
                sta vchnfreqmodlo,x
                lda #$00
                sta vchnwavepos,x
                bcc vfreqmodpos
                lda #$ff
vfreqmodpos:    asl vchnfreqmodlo,x
                rol
                sta vchnfreqmodhi,x
                jmp vwavedone

vhrnote:        jsr vmusic_hr2
vnexttblminusaccess2:
vlegatonote:    lda vnexttbl-1,y
                beq vskipfilt
                sta musiczpbase+2
                lda #$00
                sta musiczpbase+3
vnotetblminusaccess2:
vskipfilt:      lda vnotetbl-1,y
                beq vskippulse
                sta vchnpulsepos,x
                lda #$00
                sta vchnpulse,x
                lda #$01
                sta vchnpulsetime,x
vskippulse:     inc vchnwavepos,x
                jmp vreloadcounter

vwavetblaccess1:
vsetsr:         lda vwavetbl,y
                sta $d404,x
vnotetblminusaccess3:
                lda vnotetbl-1,y
                sta $d405,x
vnexttblminusaccess3:
                lda vnexttbl-1,y
                sta $d406,x
                iny
                bne vnowavechange
vwavechange:    sta $d404,x
vnexttblminusaccess4:
vnowavechange:  lda vnexttbl-1,y
                sta vchnwavepos,x
vnotetblminusaccess4:
                lda vnotetbl-1,y
                asl
                bcs vabsnote
                adc vchnnote,x
vabsnote:       tay
                lda vfreqtbl-26,y
                sta vchnfreqlo,x
                sta $d400,x
                lda vfreqtbl-25,y
vsetfreqhi:     sta $d401,x
                sta vchnfreqhi,x
vwavedone:      inc vchncounter,x
                bne vnonewnote

vgetnewnote:    ldy vchnpattnum,x
vpatttblloaccess:
                lda vpatttbllo,y
                clc
                adc #<musicarea
                sta musiczpbase
vpatttblhiaccess:
                lda vpatttblhi,y
                adc #>musicarea
                sta musiczpbase+1
                ldy vchnpattpos,x
                lda (musiczpbase),y
                cmp #$c0                        ;Duration?
                bcc vnoduration
                sta vchnduration,x
                iny
                lda (musiczpbase),y
vnoduration:    cmp #$60
                bcs vnotewithwave
                cmp #$5b
                bcc vnotewithoutwave
                beq vrest
vcommand:       and #$07
                sta vcmdsta+1
                iny
                lda vchnsfx,x                           ;Skip command if
                bne vrest                               ;sound effect playing
                lda (musiczpbase),y
vcmdsta:        sta $d400,x
                bcs vrest
vnotewithoutwave:
                adc vchntrans,x
                asl
                sta vchnnote,x
                lda vchnwavepreset,x
                bne vsetpos
vnotewithwave:  beq vwaveonly
                sbc #$61
                adc vchntrans,x               ;Adds one too much (C=1)
                asl
                sta vchnnote,x
vwaveonly:      iny
                lda (musiczpbase),y
                sta vchnwavepreset,x
vsetpos:        sta vchnwavepos,x
vrest:          iny
                lda (musiczpbase),y
                beq vendpatt
                tya
vendpatt:       sta vchnpattpos,x
                rts

vnonewnote:     bmi vpulseexec
vreloadcounter: lda vchnpattpos,x
                bne vnonewpatt
                ldy vchnsongnum,x
vsongtblloaccess:
                lda vsongtbllo,y
                clc
                adc #<musicarea
                sta musiczpbase
vsongtblhiaccess:
                lda vsongtblhi,y
                adc #>musicarea
                sta musiczpbase+1
                ldy vchnsongpos,x
                lda (musiczpbase),y
                bpl vnotrans
                sta vchntrans,x
                iny
                lda (musiczpbase),y
vnotrans:       sta vchnpattnum,x
                iny
                lda (musiczpbase),y
                beq vsongloop
vnoloop:        tya
                bne vloopcommon
vsongloop:      iny
                lda (musiczpbase),y
vloopcommon:    sta vchnsongpos,x

vnonewpatt:     lda vchnduration,x
                sta vchncounter,x
                rts

vpulseexec:     txa
                bne vfiltdone
                ldy musiczpbase+2
                beq vfiltdone
                dec musiczpbase+3
                bmi vfirstfilt
                bne vfiltadd
vfiltnextminusaccess1:
vnextfilt:      lda vfiltnexttbl-1,y
                sta musiczpbase+2
                tay
vfilttimeminusaccess1:
vfirstfilt:     lda vfilttimetbl-1,y
                bmi vsetfilt
                sta musiczpbase+3
                bpl vfiltctrl
vsetfilt:       and #$70
                sta vfiltctrl+1
                lda #$01
                sta musiczpbase+3
vfilttimeminusaccess2:
                lda vfilttimetbl-1,y
vresonance:     ora #$f0
                sta $d417
vfiltaddminusaccess1:
                lda vfiltaddtbl-1,y
                bne vstorefilt
vfiltadd:       lda musiczpbase+4
                clc
vfiltaddminusaccess2:
                adc vfiltaddtbl-1,y
vstorefilt:     sta musiczpbase+4
                sta $d416
vfiltctrl:      lda #$00
vmastervolume:  ora #$0f
                sta $d418

vfiltdone:      ldy vchnpulsepos,x
                beq vnextchn
                dec vchnpulsetime,x
                bmi vnextpulse
                clc
vpulseaddminusaccess1:
                lda vpulseaddtbl-1,y
                adc vchnpulse,x
                adc #$00
                sta vchnpulse,x
                ldy vchnsfx,x                   ;Perform pulsemod, but do not
                bne vnextchn                    ;store the result, with SFX on
vstorepulse2:   sta $d402,x
                sta $d403,x
vnextchn:       rts
vpulsenextminusaccess1:
vnextpulse:     lda vpulsenexttbl-1,y
                sta vchnpulsepos,x
                tay
vpulsetimeminusaccess1:
                lda vpulsetimetbl-1,y
                sta vchnpulsetime,x
                rts

vsfxexec:       lda vchnsfxptrlo,x
                sta musiczpbase
                lda vchnsfxptrhi,x
                sta musiczpbase+1
                cpy #$03
                bcs vsfxexec_initdone
                jsr vmusic_hr
                tay
                lda (musiczpbase),y
                jsr vstorepulse2
                iny
                inc vchnsfx,x
                bne vsfxexec_done
vsfxexec_initdone:
                lda (musiczpbase),y
                bne vsfxexec_noend
vsfxexec_end:   jsr vmusic_hr2                ;Terminate sound effect execution
                sta vchnsfx,x                 ;and make sure, by hardrestart,
                sta vchnwavepos,x             ;that no "wrong" sounds are
                sta vchnwavestored,x          ;made by the music
                jmp vwavedone
vsfxexec_noend: asl
                sta vsfxexec_resty+1
                iny
                lda (musiczpbase),y                ;Then take a look at the coming
                beq vsfxexec_nowavechange     ;byte
                cmp #$82                      ;Is it a waveform or a note?
                bcs vsfxexec_nowavechange
                iny
vsfxexec_wavechange:
                sta $d404,x
vsfxexec_nowavechange:
                tya
                sta vchnsfx,x
                ldy #$01
                lda (musiczpbase),y
                sta $d405,x
                iny
                lda (musiczpbase),y
                sta $d406,x
vsfxexec_resty: ldy #$00
                lda vfreqtbl-24,y             ;Get frequency
                sta $d400,x
                lda vfreqtbl-23,y
                sta $d401,x
vsfxexec_done:  jmp vwavedone

vmusic_hr:      lda #$00
vmusic_hr2:     sta $d404,x
                sta $d405,x
                sta $d406,x
rel_donothing:  rts

;-------------------------------------------------------------------------------
; RELOCATEMUSIC
;
; Modifies playroutine addresses to reflect the current song(s) loaded. This
; uses the same zeropage addresses as MUSIC (the playroutine itself), so don't
; call it while this is running!
;-------------------------------------------------------------------------------

;musicdata+0 = songtable len (1/2)
;musicdata+1 = patttable len (1/2)
;musicdata+2 = wavetable len
;musicdata+3 = pulsetable len
;musicdata+4 = filttable len

;Relocation codes:
;0 = unchanged
;1 = don't subtract one
;2,4,6,8,10 = add length
;Negative = quit

REL_UNCHANGED_MINUS = $00
REL_UNCHANGED       = $01
REL_SONGTBL_MINUS   = $02
REL_SONGTBL         = $03
REL_PATTTBL_MINUS   = $04
REL_PATTTBL         = $05
REL_WAVETBL_MINUS   = $06
REL_WAVETBL         = $07
REL_PULSETBL_MINUS  = $08
REL_PULSETBL        = $09
REL_FILTTBL_MINUS   = $0a
REL_FILTTBL         = $0b
REL_END             = $80

relocatemusic:  lda #<(musicarea+5)
                sta maptemp1
                lda #>(musicarea+5)
                sta maptemp2
                ldx #$00
rel_loop:       lda reladrtbllo,x
                sta maptemp3
                lda reladrtblhi,x
                sta maptemp4
                lda reladdtbl,x
                bmi rel_done
                lsr
                php
                beq rel_unchanged
                tay
                lda maptemp1
                clc
rel_lda:        adc musicarea-1,y
                sta maptemp1
                lda maptemp2
                adc #$00
                sta maptemp2
rel_unchanged:  plp
                ldy #$01
                lda maptemp1
                sbc #$00
                sta (maptemp3),y
                iny
                lda maptemp2
                sbc #$00
                sta (maptemp3),y
                inx
                bne rel_loop
rel_done:       lda #$00
                sta music+1 ;Allow music now
                rts

ntscdelay:      dc.b 5

finescroll:     dc.b 0
scrollspeed:    dc.b 0
rastercnt:      dc.b 0
textptr:        dc.w 0

vchnsongpos:    dc.b 0
vchnpattnum:    dc.b 0
vchnpattpos:    dc.b 0
vchntrans:      dc.b 0
vchncounter:    dc.b 0
vchnwavepos:    dc.b 0
vchnwavestored: dc.b 0

                dc.b 0,0,0,0,0,0,0
                dc.b 0,0,0,0,0,0,0

vchnwavepreset: dc.b 0
vchnwavedelay:  dc.b 0
vchnsongnum:    dc.b 0
vchnpulse:      dc.b 0
vchnpulsepos:   dc.b 0
vchnpulsetime:  dc.b 0
vchnnote:       dc.b 0

                dc.b 0,0,0,0,0,0,0
                dc.b 0,0,0,0,0,0,0

vchnduration:   dc.b 0
vchnfreqlo:     dc.b 0
vchnfreqhi:     dc.b 0
vchnfreqmodlo:  dc.b 0
vchnfreqmodhi:  dc.b 0
vchnsfx:        dc.b 0
vchnunused:     dc.b 0

                dc.b 0,0,0,0,0,0,0
                dc.b 0,0,0,0,0,0,0

vchnsfxptrlo    = vchnfreqmodlo
vchnsfxptrhi    = vchnfreqmodhi




vsongtbllo:
vsongtblhi:
vpatttbllo:
vpatttblhi:
vwavetbl:
vnotetbl:
vnexttbl:
vpulsetimetbl:
vpulseaddtbl:
vpulsenexttbl:
vfilttimetbl:
vfiltaddtbl:
vfiltnexttbl:

vfreqtbl:       dc.w $022a,$024a,$026d,$0292,$02b9,$02e3,$030f,$033e,$036f,$03a3,$03db,$0415
                dc.w $0454,$0495,$04db,$0525,$0573,$05c7,$061e,$067c,$06de,$0747,$07b6,$082b
                dc.w $08a8,$092b,$09b7,$0a4b,$0ae7,$0b8e,$0c3d,$0cf8,$0dbd,$0e8e,$0f6c,$1057
                dc.w $1150,$1257,$136e,$1496,$15cf,$171c,$187b,$19f0,$1b7b,$1d1d,$1ed8,$20ae
                dc.w $22a0,$24af,$26dd,$292d,$2b9f,$2e38,$30f7,$33e0,$36f6,$3a3b,$3db1,$415d
                dc.w $4540,$495e,$4dbb,$525a,$573f,$5c70,$61ef,$67c1,$6ded,$7476,$7b63,$82ba
                dc.w $8a80,$92bc,$9b76,$a4b4,$ae7f,$b8e0,$c3de,$cf83,$dbda,$e8ed,$f6c7,$ffff

reladrtbllo:    dc.b <vsongtblloaccess
                dc.b <vsongtblhiaccess
                dc.b <vpatttblloaccess
                dc.b <vpatttblhiaccess
                dc.b <vwavetblminusaccess1
                dc.b <vwavetblaccess1
                dc.b <vnotetblminusaccess1
                dc.b <vnotetblminusaccess2
                dc.b <vnotetblminusaccess3
                dc.b <vnotetblminusaccess4
                dc.b <vnexttblminusaccess1
                dc.b <vnexttblminusaccess2
                dc.b <vnexttblminusaccess3
                dc.b <vnexttblminusaccess4
                dc.b <vpulsetimeminusaccess1
                dc.b <vpulseaddminusaccess1
                dc.b <vpulsenextminusaccess1
                dc.b <vfilttimeminusaccess1
                dc.b <vfilttimeminusaccess2
                dc.b <vfiltaddminusaccess1
                dc.b <vfiltaddminusaccess2
                dc.b <vfiltnextminusaccess1

reladrtblhi:    dc.b >vsongtblloaccess
                dc.b >vsongtblhiaccess
                dc.b >vpatttblloaccess
                dc.b >vpatttblhiaccess
                dc.b >vwavetblminusaccess1
                dc.b >vwavetblaccess1
                dc.b >vnotetblminusaccess1
                dc.b >vnotetblminusaccess2
                dc.b >vnotetblminusaccess3
                dc.b >vnotetblminusaccess4
                dc.b >vnexttblminusaccess1
                dc.b >vnexttblminusaccess2
                dc.b >vnexttblminusaccess3
                dc.b >vnexttblminusaccess4
                dc.b >vpulsetimeminusaccess1
                dc.b >vpulseaddminusaccess1
                dc.b >vpulsenextminusaccess1
                dc.b >vfilttimeminusaccess1
                dc.b >vfilttimeminusaccess2
                dc.b >vfiltaddminusaccess1
                dc.b >vfiltaddminusaccess2
                dc.b >vfiltnextminusaccess1

reladdtbl:      dc.b REL_UNCHANGED
                dc.b REL_SONGTBL
                dc.b REL_SONGTBL
                dc.b REL_PATTTBL
                dc.b REL_PATTTBL_MINUS
                dc.b REL_UNCHANGED
                dc.b REL_WAVETBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_WAVETBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_WAVETBL_MINUS
                dc.b REL_PULSETBL_MINUS
                dc.b REL_PULSETBL_MINUS
                dc.b REL_PULSETBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_FILTTBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_FILTTBL_MINUS
                dc.b REL_END


                org $2000
                incbin bg/scoresc2.chr

                org $2800
                ds.b 1024,$20

musicarea:      incbin music/title.bin

                     ;0123456789012345678901234567890123456789
instrtext:      dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
textstart:      dc.b "                                        "
                dc.b "  Metal Warrior 4:Agents of Metal V1.2  "
                dc.b "                                        "
                dc.b "   A Covert Bitops production in 2012   "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "              INSTRUCTIONS              "
                dc.b "                                        "
                dc.b "    Use joystick or arrows to scroll,   "
                dc.b "    press FIRE/SPACE/RETURN to exit.    "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "1. HARDWARE REQUIREMENTS                "
                dc.b "                                        "
                dc.b "Required:                               "
                dc.b "- C64 or C128 (in C64 mode)             "
                dc.b "- Disk drive or hard disk               "
                dc.b "                                        "
                dc.b "Optional:                               "
                dc.b "- Joystick (highly recommended)         "
                dc.b "- SuperCPU (eliminates any slowdown)    "
                dc.b "                                        "
                dc.b "Inbuilt fastloader supports the 1541,   "
                dc.b "1571, 1581, CMD FD, CMD HD and IDE64    "
                dc.b "drives. By switching the fastloader off,"
                dc.b "any drive can be used.                  "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "2. LOADING                              "
                dc.b "                                        "
                dc.b "To load MW4:Agents of Metal, make sure  "
                dc.b "disk side 1 is in drive and type:       "
                dc.b "LOAD",34,"MW4",34,",8                             "
                dc.b "RUN                                     "
                dc.b "                                        "
                dc.b "(Replace 8 with your device number as   "
                dc.b "necessary.)                             "
                dc.b "                                        "
                dc.b "You will be presented with the startup  "
                dc.b "menu, where you can toggle the fast-    "
                dc.b "loader and loading picture options. Use "
                dc.b "cursor keys + RETURN, or joystick in    "
                dc.b "port 2 to move and toggle options.      "
                dc.b "                                        "
                dc.b "Select 'LOAD THE GAME' to go on. When   "
                dc.b "the game main part has been loaded you  "
                dc.b "will be asked to insert disk side 2.    "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "2.1 HARD DISK INSTALLATION              "
                dc.b "                                        "
                dc.b "MW4:Agents of Metal is not copyprotected"
                dc.b "- to install on a hard disk, copy the   "
                dc.b "files from both sides of the MW4 disk to"
                dc.b "a hard disk directory. The file '01' on "
                dc.b "both sides is the fastloader and needs  "
                dc.b "to be copied only once.                 "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "2.2 TIPS FOR EMULATOR USERS             "
                dc.b "                                        "
                dc.b "For fastest loading, switch off 'true   "
                dc.b "drive emulation' but let the fastloader "
                dc.b "stay on. This behaves similarly as IDE64"
                dc.b "loading: there are no graphics/sound    "
                dc.b "interruptions and the loading speed is  "
                dc.b "optimal.                                "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "3. PROLOGUE                             "
                dc.b "                                        "
                dc.b "Three weeks after the events depicted in"
                dc.b "'Metal Warrior 3', two figures stand at "
                dc.b "the gates of a deserted farm..          "
                dc.b "                                        "
                dc.b "Led by a phone call consisting of       "
                dc.b "ominous pig grunts & squeals, and the   "
                dc.b "voice of the maniacal bassist/vocalist  "
                dc.b "LORD OBSKURIUS, they have been asked to "
                dc.b "arrive at this place for reasons        "
                dc.b "unknown.                                "
                dc.b "                                        "
                dc.b "They are IAN SMITH (artist name yet     "
                dc.b "undecided) and JOAN ALDER (aka PHANTASM)"
                dc.b "who were, on several occasions in the   "
                dc.b "past, drawn into violent conflict with  "
                dc.b "a powerful military conspiracy.         "
                dc.b "                                        "
                dc.b "With the conspiracy revealed and brought"
                dc.b "into justice, they should now be free to"
                dc.b "live together in peace, wielding their  "
                dc.b "axes only in symbolic combat against the"
                dc.b "evils of the future world.              "
                dc.b "                                        "
                dc.b "But things are about to get weird.. The "
                dc.b "Agents of Metal are about to enter the  "
                dc.b "picture.                                "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "4. INITIATION                           "
                dc.b "                                        "
                dc.b "You as the player are asked to assume   "
                dc.b "the control of IAN on his journey to the"
                dc.b "unknown. As the story begins he is his  "
                dc.b "usual self but an Initiation and        "
                dc.b "Transformation into Agent form awaits.. "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "5. CONTROLS                             "
                dc.b "                                        "
                dc.b "The game is controlled by joystick in   "
                dc.b "port 2, or by the keys                  "
                dc.b "                                        "
                dc.b "      Q W E                             "
                dc.b "      A   D + SHIFT as fire button      "
                dc.b "      Z X C                             "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "5.1 CONTROLS WITHOUT FIRE BUTTON        "
                dc.b "                                        "
                dc.b "                Climb up                "
                dc.b "      Jump left         Jump right      "
                dc.b "     Walk left     +     Walk right     "
                dc.b "     Sneak left         Sneak right     "
                dc.b "       Crouch/Climb down/Pick up        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "5.2 CONTROLS WITH FIRE BUTTON           "
                dc.b "                                        "
                dc.b "           Interact/Drop item           "
                dc.b "   Attack up-l.         Attack up-r.    "
                dc.b "   Attack left     +     Attack right   "
                dc.b " Attack down-l.         Attack down-r.  "
                dc.b "    Use inventory item/Reload weapon    "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "5.3 SPECIAL MANEUVERS                   "
                dc.b "                                        "
                dc.b "To go up stairs instead of down, hold   "
                dc.b "down up-direction first before moving   "
                dc.b "joystick left/right.                    "
                dc.b "                                        "
                dc.b "To jump away from a ladder, push the    "
                dc.b "joystick up diagonally.                 "
                dc.b "                                        "
                dc.b "To perform a 'wall-flip' while jumping, "
                dc.b "push joystick up and to the direction   "
                dc.b "opposite to the wall at the moment you  "
                dc.b "hit the wall.                           "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "5.4 ITEM MANIPULATION                   "
                dc.b "                                        "
                dc.b "To pick up an item, crouch at it        "
                dc.b "(joystick DOWN; you are near enough when"
                dc.b "the item's name is displayed). If you   "
                dc.b "cannot pick up an item, you likely have "
                dc.b "reached your carrying capacity. See the "
                dc.b "STATUS SCREEN if this is the case.      "
                dc.b "                                        "
                dc.b "To drop an unnecessary item, select it  "
                dc.b "from the inventory and hold FIRE+UP for "
                dc.b "1 second. If the screen is already full "
                dc.b "of items (4 is the limit), you must go  "
                dc.b "somewhere else. When a firearm is       "
                dc.b "dropped, any ammunition held in it is   "
                dc.b "moved to the ammunition reserve.        "
                dc.b "                                        "
                dc.b "To 'use' the currently selected item,   "
                dc.b "press FIRE+DOWN. Examples of items that "
                dc.b "can be used are first aid kits,         "
                dc.b "armor rechargers, and the 'Agent gear'  "
                dc.b "you receive soon after game start!      "
                dc.b "Firearms are reloaded this way, also.   "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "6. INGAME STATUS DISPLAY                "
                dc.b "                                        "
                dc.b "The bottom left part of the screen shows"
                dc.b "your score, current weapon/item selected"
                dc.b "and ammunition remaining.               "
                dc.b "                                        "
                dc.b "For firearms, the ammunition display is "
                dc.b "split in two. Left side shows rounds in "
                dc.b "magazine and right side shows number of "
                dc.b "magazines remaining.                    "
                dc.b "                                        "
                dc.b "For melee weapons, INF (infinite) is    "
                dc.b "displayed.                              "
                dc.b "                                        "
                dc.b "The bottom right part shows your health "
                dc.b "(H) and armor power (A) meters.         "
                dc.b "                                        "
                dc.b "Keep an eye on the health meter; when it"
                dc.b "falls to zero you are defeated and the  "
                dc.b "game is over.                           "
                dc.b "                                        "
                dc.b "The armor power bar will be displayed   "
                dc.b "only after receiving your Agent gear.   "
                dc.b "The armor will take most of the damage  "
                dc.b "as long as it has some power left.      "
                dc.b "                                        "
                dc.b "To replenish health, use first aid kits."
                dc.b "To replenish armor power, use armor     "
                dc.b "rechargers.                             "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "7. MENU SYSTEM                          "
                dc.b "                                        "
                dc.b "Hold down the FIRE button for 1/2       "
                dc.b "seconds or press SPACE to pause and     "
                dc.b "access the main menu.                   "
                dc.b "                                        "
                dc.b "The main menu is divided into 3 sub-    "
                dc.b "screens: GAME MENU, INVENTORY, STATUS.  "
                dc.b "To move between them, push joystick     "
                dc.b "left/right. To move within a subscreen, "
                dc.b "push joystick up/down. To activate a    "
                dc.b "menu item, press the fire button.       "
                dc.b "                                        "
                dc.b "To leave the menu, press SPACE.         "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "7.1 GAME MENU                           "
                dc.b "                                        "
                dc.b "Before a game is started, only the GAME "
                dc.b "MENU is accessible.                     "
                dc.b "                                        "
                dc.b "NEW GAME                                "
                dc.b "- Start a new game. You are presented   "
                dc.b "  with a difficulty level selection:    "
                dc.b "                                        "
                dc.b "  EASY   - Reduced damage to player,    "
                dc.b "           carrying capacity 25kg       "
                dc.b "                                        "
                dc.b "  MEDIUM - Normal damage to player,     "
                dc.b "           carrying capacity 20kg       "
                dc.b "                                        "
                dc.b "  HARD   - Extra damage to player,      "
                dc.b "           more enemies, carrying       "
                dc.b "           capacity 15kg                "
                dc.b "                                        "
                dc.b "LOAD GAME                               "
                dc.b "- Load an existing game.                "
                dc.b "                                        "
                dc.b "SAVE GAME                               "
                dc.b "- Save the current game. Select a slot  "
                dc.b "  between 1-3. Remember to save often to"
                dc.b "  be able to continue in the case you're"
                dc.b "  defeated!                             "
                dc.b "                                        "
                dc.b "QUIT GAME                               "
                dc.b "- End game and return to title screen,  "
                dc.b "  or if not in game, end session and    "
                dc.b "  return to the BASIC prompt. You are   "
                dc.b "  asked to confirm.                     "
                dc.b "                                        "
                dc.b "MUSIC Y/N                               "
                dc.b "- Toggles whether music will be played. "
                dc.b "  With music off you will hear more     "
                dc.b "  sound effects, such as footsteps.     "
                dc.b "                                        "
                dc.b "SOUND Y/N                               "
                dc.b "- Toggles whether sound effects will be "
                dc.b "  played.                               "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "7.2 INVENTORY                           "
                dc.b "                                        "
                dc.b "Here you can select the current item    "
                dc.b "(weapons, first aid kits etc.) in use.  "
                dc.b "Press FIRE or SPACE to confirm & return "
                dc.b "to game.                                "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "7.3 STATUS SCREEN                       "
                dc.b "                                        "
                dc.b "The STATUS SCREEN displays your total   "
                dc.b "game time, weight of items carried, and "
                dc.b "three status bars:                      "
                dc.b "                                        "
                dc.b "VIT   - Vitality                        "
                dc.b "STR   - Strength                        "
                dc.b "ARMOR - Armorsystem class               "
                dc.b "                                        "
                dc.b "With higher vitality, the health bar    "
                dc.b "will deplete slower from damage.        "
                dc.b "                                        "
                dc.b "Higher strength increases your carrying "
                dc.b "capacity, so that more weapons and      "
                dc.b "supplies can be carried at a time. Your "
                dc.b "melee attacks and thrown weapons        "
                dc.b "also become more powerful.              "
                dc.b "                                        "
                dc.b "A higher armorsystem class means that   "
                dc.b "the armor can stop more damage before   "
                dc.b "requiring to be recharged.              "
                dc.b "                                        "
                dc.b "Vitality & strength upgrades can be     "
                dc.b "found in enemy installations. Use       "
                dc.b "Surgical Units to install these. Armor  "
                dc.b "upgrades can also be found; these can be"
                dc.b "installed simply by selecting from the  "
                dc.b "inventory and using (FIRE+DOWN).        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "8. INTERACTION                          "
                dc.b "                                        "
                dc.b "There are several ways to interact with "
                dc.b "the game world. All of them are         "
                dc.b "activated by pressing FIRE+UP.          "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "8.1 CONVERSATION                        "
                dc.b "                                        "
                dc.b "You need to stand near and face the     "
                dc.b "person you wish to talk to, and hold    "
                dc.b "FIRE+UP for about 1/4 seconds.          "
                dc.b "                                        "
                dc.b "If no conversation begins, this means   "
                dc.b "simply that there's nothing important to"
                dc.b "say at the moment - you might want to   "
                dc.b "come back later. Also, if the person is "
                dc.b "engaged in combat, you must wait.       "
                dc.b "                                        "
                dc.b "At times you are able to choose your    "
                dc.b "reply from multiple choices; this is    "
                dc.b "indicated by arrows in the message      "
                dc.b "window and a question mark above your   "
                dc.b "character's head. Press joystick UP/DOWN"
                dc.b "to see choices and FIRE button to       "
                dc.b "select.                                 "
                dc.b "                                        "
                dc.b "Sometimes conversations are also        "
                dc.b "triggered automatically when you are    "
                dc.b "near a person.                          "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "8.2 GAME WORLD OBJECTS                  "
                dc.b "                                        "
                dc.b "When you're standing at an object that  "
                dc.b "can be interacted with, an arrow will   "
                dc.b "flash at your character's feet.         "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "8.2.1 DOORS, SWITCHES, CLOSETS          "
                dc.b "                                        "
                dc.b "To enter a door, stand in front of it   "
                dc.b "and hold FIRE+UP for about 1/4 seconds. "
                dc.b "Some doors need to be opened or unlocked"
                dc.b "first by using a nearby switch or       "
                dc.b "keycard lock.                           "
                dc.b "                                        "
                dc.b "To operate a switch or lock, stand in   "
                dc.b "front of it and press FIRE+UP. Any item "
                dc.b "required will be inserted automatically."
                dc.b "                                        "
                dc.b "Closets might contain ammunition,       "
                dc.b "weapons or other useful items. press    "
                dc.b "FIRE+UP to open and reveal any items.   "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "8.2.2 COMPUTER TERMINALS                "
                dc.b "                                        "
                dc.b "Press FIRE+UP to read the contents of   "
                dc.b "the screen. They are displayed either   "
                dc.b "in the main game screen or in the       "
                dc.b "message window. Sometimes you might also"
                dc.b "be presented with a control interface   "
                dc.b "similar to the game menu.               "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "8.2.3 RECHARGERS AND SURGICAL UNITS     "
                dc.b "                                        "
                dc.b "These fixed units can be used to regain "
                dc.b "lost armor power or health. Press FIRE+ "
                dc.b "UP to operate. The surgical unit        "
                dc.b "presents you with an interface:         "
                dc.b "                                        "
                dc.b "HEAL - Restore all health               "
                dc.b "VIT  - Install vitality upgrade         "
                dc.b "STR  - Install strength upgrade         "
                dc.b "EXIT - Return to game                   "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "8.2.4 ELEVATORS                         "
                dc.b "                                        "
                dc.b "To go up on an elevator, press FIRE+UP  "
                dc.b "while standing on its left half. To go  "
                dc.b "down, press FIRE+UP while standing on   "
                dc.b "the right half. An elevator call button "
                dc.b "can usually be found next to an elevator"
                dc.b "shaft.                                  "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "9. THE MAP SCREEN                       "
                dc.b "                                        "
                dc.b "When you exit an area you are presented "
                dc.b "with a map screen to choose your next   "
                dc.b "destination. Use the joystick to move   "
                dc.b "and FIRE to select.                     "
                dc.b "                                        "
                dc.b "New locations are added to the map as   "
                dc.b "you learn of their existence. Note that "
                dc.b "you need to locate and use the ground   "
                dc.b "level exit of each enemy installation   "
                dc.b "before you can return to it simply via  "
                dc.b "the map screen.                         "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "10. WEAPONS & AMMUNITION                "
                dc.b "                                        "
                dc.b "There are 21 different kinds of weapons "
                dc.b "in the game, and of course your trusty  "
                dc.b "fists to fall back upon.                "
                dc.b "                                        "
                dc.b "Note that by picking up every weapon you"
                dc.b "encounter you will likely reach your    "
                dc.b "carrying capacity quickly.              "
                dc.b "                                        "
                dc.b "Common ammunition types and uses:       "
                dc.b "                                        "
                dc.b "9mm       - Pistols, Submachine gun     "
                dc.b ".44       - .44 Magnum pistol           "
                dc.b "5.56      - Automatic rifles            "
                dc.b "7.62      - Sniper rifle                "
                dc.b "12 gauge  - Shotguns                    "
                dc.b "Darts     - Dart gun                    "
                dc.b "Batteries - Electronic stun gun         "
                dc.b "                                        "
                dc.b "Any experimental weapons that you       "
                dc.b "encounter might require their own kinds "
                dc.b "of ammunition.                          "
                dc.b "                                        "
                dc.b "The weapons with non-lethal effect are: "
                dc.b "                                        "
                dc.b "- Fists                                 "
                dc.b "- Baton                                 "
                dc.b "- Dart gun                              "
                dc.b "- Electronic stun gun                   "
                dc.b "                                        "
                dc.b "Some weapons (such as the dart gun) may "
                dc.b "have a prolonged damage effect, that the"
                dc.b "armor does not protect against. You will"
                dc.b "notice this when the health bar starts  "
                dc.b "to decrease even if you have armor left,"
                dc.b "and your character flashes. Using a     "
                dc.b "first aid kit stops this.               "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "11. AGENT HINTS & TACTICS               "
                dc.b "                                        "
                dc.b "Enemies detect you by sight and sound.  "
                dc.b "When you crouch-walk (sneak), they will "
                dc.b "not hear you.                           "
                dc.b "                                        "
                dc.b "Enemies might be expecting you when     "
                dc.b "there has been gunfire or other loud    "
                dc.b "noises just before. It might be         "
                dc.b "beneficial to let things calm down      "
                dc.b "before proceeding.                      "
                dc.b "                                        "
                dc.b "Reloading in the middle of combat can   "
                dc.b "prove fatal. Therefore it is often wise "
                dc.b "to ensure beforehand (use FIRE+DOWN to  "
                dc.b "reload) that you have a fresh           "
                dc.b "magazine.                               "
                dc.b "                                        "
                dc.b "A damage bonus is added to surprise     "
                dc.b "attacks from behind (for example, a     "
                dc.b "guard might go down with one blow of the"
                dc.b "Baton).                                 "
                dc.b "                                        "
                dc.b "If you're running low on ammo, you can  "
                dc.b "buy more from the city. 5.56 & 7.62     "
                dc.b "calibers now also available!            "
                dc.b "                                        "
                dc.b "An Agent might not necessarily have to  "
                dc.b "kill; double points are awarded for non-"
                dc.b "lethal defeat of an enemy.              "
                dc.b "                                        "
                dc.b "Good luck on your adventure!            "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "12. VERSION HISTORY                     "
                dc.b "                                        "
                dc.b "V1.1                                    "
                dc.b "                                        "
                dc.b "- 1581,CMD FD,CMD HD support added for  "
                dc.b "  the fastloader                        "
                dc.b "- Sprites not turned off while loading  "
                dc.b "- Hard difficulty added                 "
                dc.b "- Difficulty affects carrying capacity  "
                dc.b "- Added and improved sidequests         "
                dc.b "- Some weapon balance adjustments       "
                dc.b "- Shotgun damage varies with distance   "
                dc.b "- 5.56 & 7.62 ammo available from shop  "
                dc.b "- Improved pathfinding AI               "
                dc.b "- Loading picture edited                "
                dc.b "                                        "
                dc.b "V1.2                                    "
                dc.b "                                        "
                dc.b "- REU/SuperRAM buffering replaced with  "
                dc.b "  IDE64 compatible IRQ-loading          "
                dc.b "- Improved loading speed                "
                dc.b "- Level graphics adjustments            "
                dc.b "- Game balance adjustments              "
                dc.b "- Melee damage bonus based on strength  "
                dc.b "- Mutant enemy replaced with the classic"
                dc.b "  variant from MW1-3                    "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "13. CREDITS & COPYRIGHT                 "
                dc.b "                                        "
                dc.b "Agent concept:                          "
                dc.b "LIONEL GENDRE & LASSE \\RNI             "
                dc.b "                                        "
                dc.b "Programming, graphics & sound:          "
                dc.b "LASSE \\RNI                             "
                dc.b "                                        "
                dc.b "Additional programming:                 "
                dc.b "PER OLOFSSON,WOLFRAM SANG,CHRISTOPH     "
                dc.b "THELEN (diskdrive code)                 "
                dc.b "MAGNUS LIND (Exomizer)                  "
                dc.b "                                        "
                dc.b "Music:                                  "
                dc.b "HARRI AHOLA,LIONEL GENDRE,PAAVO H[RK\NEN"
                dc.b "JUHA JAAKKOLA,ANSSI J[[SKEL[INEN,ANTTI  "
                dc.b "KIVILAHTI,BAS KOOY,JUHO KOTILA,DENNIS   "
                dc.b "MOTT,DANIEL WUIS,LASSE \\RNI            "
                dc.b "                                        "
                dc.b "Covert Bitops homepage:                 "
                dc.b "http://covertbitops.c64.org             "
                dc.b "                                        "
                dc.b "Copyright (C) 2002-2012 by the authors. "
                dc.b "All rights reserved.                    "
                dc.b "                                        "
                dc.b "Redistribution and use in source and    "
                dc.b "binary forms, with or without           "
                dc.b "modification, are permitted provided    "
                dc.b "that the following conditions are met:  "
                dc.b "                                        "
                dc.b "1. Redistributions of source code must  "
                dc.b "   retain the above copyright notice,   "
                dc.b "   this list of conditions and the      "
                dc.b "   following disclaimer.                "
                dc.b "2. Redistributions in binary form must  "
                dc.b "   reproduce the above copyright notice,"
                dc.b "   this list of conditions and the      "
                dc.b "   following disclaimer in the          "
                dc.b "   documentation and/or other materials "
                dc.b "   provided with the distribution.      "
                dc.b "3. The name of the author may not be    "
                dc.b "   used to endorse or promote products  "
                dc.b "   derived from this software without   "
                dc.b "   specific prior written permission.   "
                dc.b "                                        "
                dc.b "THIS SOFTWARE IS PROVIDED BY THE AUTHOR "
                dc.b "''AS IS'' AND ANY EXPRESS OR IMPLIED    "
                dc.b "WARRANTIES, INCLUDING, BUT NOT LIMITED  "
                dc.b "TO, THE IMPLIED WARRANTIES OF           "
                dc.b "MERCHANTABILITY AND FITNESS FOR A       "
                dc.b "PARTICULAR PURPOSE ARE DISCLAIMED. IN NO"
                dc.b "EVENT SHALL THE AUTHOR BE LIABLE FOR ANY"
                dc.b "DIRECT, INDIRECT, INCIDENTAL, SPECIAL,  "
                dc.b "EXEMPLARY, OR CONSEQUENTIAL DAMAGES     "
                dc.b "(INCLUDING, BUT NOT LIMITED TO,         "
                dc.b "PROCUREMENT OF SUBSTITUTE GOODS OR      "
                dc.b "SERVICES; LOSS OF USE, DATA, OR PROFITS;"
                dc.b "OR BUSINESS INTERRUPTION) HOWEVER CAUSED"
                dc.b "AND ON ANY THEORY OF LIABILITY, WHETHER "
                dc.b "IN CONTRACT, STRICT LIABILITY, OR TORT  "
                dc.b "(INCLUDING NEGLIGENCE OR OTHERWISE)     "
                dc.b "ARISING IN ANY WAY OUT OF THE USE OF    "
                dc.b "THIS SOFTWARE, EVEN IF ADVISED OF THE   "
                dc.b "POSSIBILITY OF SUCH DAMAGE.             "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "14. THANKS FOR AGENT EVIDENCE           "
                dc.b "                                        "
                dc.b "Betatesting:                            "
                dc.b "MAT ALLEN,RICHARD BAYLISS,ROMAN CHLEBEC,"
                dc.b "J\RG DR\GE,MICHAEL DURRER,MATHIEU FAES, "
                dc.b "ANDREW FISHER,JOHAN FORSL\F,LIONEL      "
                dc.b "GENDRE,PAAVO H[RK\NEN,JOHAN IJZERMAN,   "
                dc.b "MILO MUNDT,KARL-JOHAN NILSSON,SIMON     "
                dc.b "QUERNHORST,LAZE RISTOSKI,LUIGI VICARI   "
                dc.b "                                        "
                dc.b "Fastloaders/drivecoding:                "
                dc.b "MARKO M[KELA,KRZYSZTOF MATULA,MAGNUS    "
                dc.b "LIND,NATHAN SMITH,GUNNAR RUTHENBERG,    "
                dc.b "KOVACS BALAZS,WOLFRAM SANG,CHRISTOPH    "
                dc.b "THELEN                                  "
                dc.b "                                        "
                dc.b "SuperCPU programming:                   "
                dc.b "STEFAN GUTSCH                           "
                dc.b "                                        "
                dc.b "Extra RAM programming:                  "
                dc.b "WOLFRAM SANG                            "
textend:        dc.b "                                        "
                dc.b "Discussions & suggestions:              "
                dc.b "BRIAN BAGNALL,RICHARD BAYLISS,JAN       "
                dc.b "B\TTCHER,ROMAN CHLEBEC,J\RG DR\GE,      "
                dc.b "MICHAEL DURRER,PAAVO H[RK\NEN,JASON     "
                dc.b "KELK,KALLE NIEMITALO,OLLI NIEMITALO +   "
                dc.b "many more                               "
                dc.b "                                        "
                dc.b "Primary Agent inspiration:              "
                dc.b "AGENT STEEL (the band)                  "
                dc.b "DEUS EX (the game)                      "
                dc.b "                                        "
                dc.b "The composers of the music in this game "
                dc.b "come from the 'tracked metalscene',     "
                dc.b "see http://www.trackedaggression.com    "
                dc.b "                                        "
                dc.b "Special thanks to all betatesters,      "
                dc.b "without whom many infernal bugs would   "
                dc.b "have remained.                          "
                dc.b "                                        "
                dc.b "Greetings to all C64 users, sceners,    "
                dc.b "artists & webmasters etc. You rule the  "
                dc.b "world!                                  "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "

instrend:
                if instrend > $c000
                err
                endif

