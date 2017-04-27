RASTER_GSCREEN  = 0                             ;Raster interrupt numbers
RASTER_PANEL    = 1
RASTER_SPRITE   = 2

RASTER_GSCREEN_POS = 16                         ;Positions for the raster
RASTER_PANEL_POS = 212
RASTER_PANEL2_POS = 221

;-------------------------------------------------------------------------------
; RASTER_IDLE
;
; Interrupt used while loading with Kernal routines (fastloader off mode)
;
; Parameters: -
; Returns: -
; Modifies: -
;-------------------------------------------------------------------------------

raster_idle:    lda fastloadstatus              ;Fake-IRQload mode?
                bmi raster_redirect

                jsr music_silence               ;Returns with A=0 X=1
                sta frameupdflag                ;Reset frameupdateflag
                stx music+1                     ;Disable music until next
                inc $d019                       ;full update
                jmp $ea81

;-------------------------------------------------------------------------------
; RASTER_REDIRECT
;
; Interrupt used for fake-IRQloading
;
; Parameters: -
; Returns: -
; Modifies: -
;-------------------------------------------------------------------------------

raster_redirect:
                ldx $01
                lda #$35                        ;Note: this will necessarily have overhead,
                sta $01                         ;which means that the sensitive IRQs like
                lda #>rr_return                 ;the panel-split should take extra advance
                pha
                lda #<rr_return
                pha
                php
                jmp ($fffe)
rr_return:      stx $01
                jmp $ea81

;-------------------------------------------------------------------------------
; RASTER_PANEL
;
; Scorepanel raster interrupt. Handles score/gamescreen split
;
; Parameters: -
; Returns: -
; Modifies: -
;-------------------------------------------------------------------------------

raster_panel:   sta savea
rpanel_wait:    lda $d012
                cmp #RASTER_PANEL_POS+1
                bcc rpanel_wait
                bit $00
                nop
rpanel_sety:    lda #$17                        ;Stabilize Y-scrolling
                sta $d011                       ;immediately
                cmp #$57
                beq rpanel_badline
                nop
                pha
                pla
                pha
                pla
                pha
                pla
                pha
                pla
rpanel_badline: lda #$57
                sta $d011
                lda #TEXT_D018                  ;Set textscreen screen ptr.
                sta $d018                       ;and charset
                lda #EMPTYFRAME
                sta screen1+$3f8
                sta screen1+$3f9
                sta screen1+$3fa
                sta screen1+$3fb
                sta screen1+$3fc
                sta screen1+$3fd
                sta screen1+$3fe
                sta screen1+$3ff
                lda #<raster_panel2             ;Set vector & raster position
                sta $fffe                       ;for next IRQ
                lda #>raster_panel2
                sta $ffff
                lda fileopen                    ;If file open, do not chain IRQ but busy-wait here
                bne rpanel2_direct
                lda #RASTER_PANEL2_POS
                sta $d012
                lda savea
                dec $d019
                rti

;-------------------------------------------------------------------------------
; RASTER_PANEL2
;
; Scorepanel raster interrupt. Plays also music/sfx.
;
; Parameters: -
; Returns: -
; Modifies: -
;-------------------------------------------------------------------------------

raster_panel2:  sta savea
rpanel2_direct: stx savex
                sty savey
rpanel2_wait:   lda $d012
                cmp #RASTER_PANEL2_POS+1
                bcc rpanel2_wait
                lda #$18
                sta $d016                       ;X-scrolling in place
                lda #$00
                sta $d015                       ;Sprites off
                sta $d021
                lda #PANELMC1
                sta $d022
                lda #PANELMC2
                sta $d023
                lda #<raster_gscreen            ;Set vector & raster position
                sta $fffe                       ;for next IRQ
                lda #>raster_gscreen
                sta $ffff
                lda #RASTER_GSCREEN_POS
                sta $d012
                lda #$17                        ;Screen visible
                sta $d011
                cld
                lda ntscdelay
                beq rpanel2_musicdelay
rpanel2_musicok:jsr music
rpanel2_musicdelay:
                lda fileopen                    ;SCPU to fast mode now -
                bne rpanel2_skipturbo           ;suggested by Stefan Gutsch
                sta $d07b
rpanel2_skipturbo:
                jmp rgscr_endraster

;-------------------------------------------------------------------------------
; RASTER_SPRITE
;
; Sprite multiplexer
;
; Parameters: -
; Returns: -
; Modifies: -
;-------------------------------------------------------------------------------

rspr_loadrdone2:jmp rspr_loadrdone
rspr_loadr0:    lda sortsprf,x
rspr_loadf0:    sta screen1+$3ff
                lda sortsprc,x
                sta $d02e
                lda sortsprx,x
                sta $d00e
                lda sortsprd010,x
                sta $d010
                dey
                beq rspr_loadrdone2
rspr_loadr1:    lda sortsprf+1,x
rspr_loadf1:    sta screen1+$3fe
                lda sortsprc+1,x
                sta $d02d
                lda sortsprx+1,x
                sta $d00c
                lda sortsprd010+1,x
                sta $d010
                dey
                beq rspr_loadrdone2
rspr_loadr2:    lda sortsprf+2,x
rspr_loadf2:    sta screen1+$3fd
                lda sortsprc+2,x
                sta $d02c
                lda sortsprx+2,x
                sta $d00a
                lda sortsprd010+2,x
                sta $d010
                dey
                beq rspr_loadrdone2
rspr_loadr3:    lda sortsprf+3,x
rspr_loadf3:    sta screen1+$3fc
                lda sortsprc+3,x
                sta $d02b
                lda sortsprx+3,x
                sta $d008
                lda sortsprd010+3,x
                sta $d010
                dey
                beq rspr_loadrdone
rspr_loadr4:    lda sortsprf+4,x
rspr_loadf4:    sta screen1+$3fb
                lda sortsprc+4,x
                sta $d02a
                lda sortsprx+4,x
                sta $d006
                lda sortsprd010+4,x
                sta $d010
                dey
                beq rspr_loadrdone
rspr_loadr5:    lda sortsprf+5,x
rspr_loadf5:    sta screen1+$3fa
                lda sortsprc+5,x
                sta $d029
                lda sortsprx+5,x
                sta $d004
                lda sortsprd010+5,x
                sta $d010
                dey
                beq rspr_loadrdone
rspr_loadr6:    lda sortsprf+6,x
rspr_loadf6:    sta screen1+$3f9
                lda sortsprc+6,x
                sta $d028
                lda sortsprx+6,x
                sta $d002
                lda sortsprd010+6,x
                sta $d010
                dey
                beq rspr_loadrdone
rspr_loadr7:    lda sortsprf+7,x
rspr_loadf7:    sta screen1+$3f8
                lda sortsprc+7,x
                sta $d027
                lda sortsprx+7,x
                sta $d000
                lda sortsprd010+7,x
                sta $d010
                dey
                beq rspr_loadrdone
                txa
                adc #$08
                tax
                jmp rspr_loadr0

rspr_loadrdone: ldx irqirqcount
                inx
                cpx irqirqend
                bcs rspr_alldone
                stx irqirqcount
rspr_firstirq:  lda sprirqstart,x
                and #$07
                tay
                lda rspr_yjumptbl,y
                sta rspr_yjump+1
                lda rspr_rjumptbl,y
                sta rspr_rjump+1
                lda sprirqstart,x
                and #$f8
                sta irqtemp1
                lda sprirqamount,x
                sta irqtemp2
                lda sprirqline,x
                sbc irqtemp2
                sbc fileopen
                sta $d012
                sbc #$03                        ;Carry = 1
                cmp $d012                       ;Late from next sprite-IRQ?
                bcc rspr_direct
                lda savea
                ldx savex
                ldy savey
                dec $d019                       ;Acknowledge IRQ
                rti
rspr_alldone:   lda #RASTER_PANEL_POS
                sbc fileopen
                sbc #$03                        ;Carry = 1
                cmp $d012                       ;Late from the scorepanel IRQ?
                bcc rspr_latepanel
                jmp rgscr_gotopanel
rspr_latepanel: ldx savex
                ldy savey
                jmp rpanel_wait

raster_sprite:  cld
                sta savea
                stx savex
                sty savey
rspr_direct:    ldx irqtemp1
                ldy irqtemp2
rspr_yjump:     jmp rspr_loady0

rspr_loady0:    lda sortspry,x
                sta $d00f
                dey
                beq rspr_loadydone
rspr_loady1:    lda sortspry+1,x
                sta $d00d
                dey
                beq rspr_loadydone
rspr_loady2:    lda sortspry+2,x
                sta $d00b
                dey
                beq rspr_loadydone
rspr_loady3:    lda sortspry+3,x
                sta $d009
                dey
                beq rspr_loadydone
rspr_loady4:    lda sortspry+4,x
                sta $d007
                dey
                beq rspr_loadydone
rspr_loady5:    lda sortspry+5,x
                sta $d005
                dey
                beq rspr_loadydone
rspr_loady6:    lda sortspry+6,x
                sta $d003
                dey
                beq rspr_loadydone
rspr_loady7:    lda sortspry+7,x
                sta $d001
                dey
                beq rspr_loadydone
                txa
                clc
                adc #$08
                tax
                jmp rspr_loady0
rspr_loadydone:
rspr_reloadx:   ldx irqtemp1
rspr_reloady:   ldy irqtemp2
rspr_rjump:     jmp rspr_loadr0

                if (rspr_loady0 & $ff00) != (rspr_loady7 & $ff00)
                    err
                endif

                if (rspr_loadr0 & $ff00) != (rspr_loadr7 & $ff00)
                    err
                endif

;-------------------------------------------------------------------------------
; RASTER_GSCREEN
;
; Gamescreen raster interrupt.
;
; Parameters: -
; Returns: -
; Modifies: -
;-------------------------------------------------------------------------------

raster_gscreen: cld
                sta savea
                stx savex
                sty savey
                lda ntscdelay                   ;Handle NTSC delay
                sec
                sbc ntscflag
                bcs rgscr_nontscdelay
                lda #$05
rgscr_nontscdelay:
                sta ntscdelay
                lda targetframes
                and #$03
                adc #$00
                sta targetframes
                lda frameupdflag                ;New frame?
                beq rgscr_screen
                jsr bganimcode                  ;Do BG-animation
rgscr_nobganim: lda #$00
                sta frameupdflag
rgscr_newscrollx:lda #$00
                sta rgscr_scrx+1
rgscr_newscrolly:lda #$00
                sta rgscr_scry+1
rgscr_newscreen:lda #$00
                sta rgscr_screen+1
                lda sortsprstart
                sta irqsprstart
                lda sortirqstart
                sta irqirqstart
                lda sortirqend
                sta irqirqend
                lda sortsprend
                sta irqsprend
                sec
                sbc sortsprstart
                tax
                cpx #$09                        ;More than 8 sprites?
                bcc rgscr_notover8
                ldx #$08
rgscr_notover8: lda sprontbl,x
                sta rgscr_spronmask+1
rgscr_screen:   ldy #$02
                lda d018tbl,y                   ;Correct screendata ptr
                sta $d018
                lda frameptrtbl,y               ;Frames must go to the
                sta rspr_loadf0+2               ;correct screen
                sta rspr_loadf1+2
                sta rspr_loadf2+2
                sta rspr_loadf3+2
                sta rspr_loadf4+2
                sta rspr_loadf5+2
                sta rspr_loadf6+2
                sta rspr_loadf7+2
                cpy #$02                        ;Textscreen?
                bcc rgscr_gamescreen
rgscr_textscreen:
                ldx #$00                        ;No sprites
rgscr_textbg1:  lda #$00
                sta $d021
rgscr_textbg2:  lda #PANELMC1
                sta $d022
rgscr_textbg3:  lda #PANELMC2
                sta $d023
                lda #$18                        ;Reset scrolling
                ldy #$17
                bne rgscr_common
rgscr_gamescreen:
rgscr_zonenum:  ldx #$00
                lda zonebg1,x
                sta $d021
                lda zonebg2,x
                sta $d022
                lda zonebg3,x
                sta $d023
rgscr_scrx:     lda #$17                        ;Set gamescreen scrolling
rgscr_scry:     ldy #$17
rgscr_spronmask:ldx #$00
rgscr_common:   sta $d016
                sty $d011
                tya
                ora #$07
                cpy #$15
                bne rgscr_nobadline
                ora #$40
rgscr_nobadline:sta rpanel_sety+1
                stx $d015
                sta $d07a                       ;SCPU to slow mode
                txa
                bne rgscr_notzerospr            ;Are there sprites to be
                                                ;displayed?
                sta fastload_maxspry+1          ;If no sprites, can load anywhere
rgscr_gotopanel:lda #<raster_panel              ;Set vector & raster position
                sta $fffe                       ;for next IRQ
                lda #>raster_panel
                sta $ffff
                lda #RASTER_PANEL_POS
                sec
                sbc fileopen
                sta $d012
rgscr_endraster:
                lda savea
                ldx savex
                ldy savey
                dec $d019                       ;Acknowledge IRQ
                rti
rgscr_notzerospr:
                ldx irqsprstart
                lda sortspry,x                  ;Find out min/max sprite Y coords
                sec                             ;for the fastloader
                sbc #$04
                sta fastload_minspry+1
                ldx irqsprend
                lda sortspry-1,x
                adc #22
                sta fastload_maxspry+1
                ldx irqirqstart
                stx irqirqcount
                lda #RASTER_GSCREEN_POS
                sta sprirqline,x
                lda #<raster_sprite             ;Jump to the first sprite-IRQ
                sta $fffe                       ;right away
                lda #>raster_sprite
                sta $ffff
                jmp rspr_firstirq
