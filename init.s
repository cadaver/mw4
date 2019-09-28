                org scriptarea

NUMWEAPONATTRIB = 21                              ;Number of attributes in the
NUMBULLETATTRIB = 12                              ;definitions (for loading)
NUMITEMATTRIB   = 5
NUMSPECDMGATTRIB = 5

;-------------------------------------------------------------------------------
; MW4 New Engine - initialization (discardable)
;-------------------------------------------------------------------------------

entrypoint:     ldx #$ff
                txs

initweapons:    ldx #$00
ld_loop:        jsr ld_getbyte
                tay
                bmi ld_loopdone
                jsr dw_common
                jmp ld_loop
ld_loopdone:    inx
                cpx #$04
                bcc ld_loop

                lda #ACTI_FIRSTITEM
                sta itemsearch
                lda #1
                sta targetframes
                lda #0
                sta scrollcenterx
                sta scrollcentery

initvideo:      lda $d011
                bpl initvideo
                and #$0f
                sta $d011                       ;Blank screen
                lda #$00
                sta $d020
                sta $d01b                       ;Sprites on top of BG
                sta $d017                       ;Sprite Y-expand off
                sta $d415                       ;Filter lowbyte
                sta joystick                    ;Control reset
                sta prevjoy
                sta keypress
                sta keytype
                lda #$08                        ;Set testbit on all channels
                sta $d404
                sta $d404+7
                sta $d404+14
                lda #$ff                        ;Set all sprites multicolor
                sta $d01c
                sta $d001
                sta $d003
                sta $d005
                sta $d007
                sta $d009
                sta $d00b
                sta $d00d
                sta $d00f
                sta $d015                       ;All sprites on and to the bottom
iv_sprwait1:    lda $d011                       ;Wait for one frame
                bmi iv_sprwait1
iv_sprwait2:    lda $d011
                bpl iv_sprwait2
                lda #$00                        ;Sprites off now
                sta $d015
                lda #SPRMC1
                sta $d025                       ;Set sprite multicolor 1
                lda #SPRMC2
                sta $d026                       ;Set sprite multicolor 2
                lda $dd00                       ;Set game videobank
                and #$fc
                sta $dd00
                lda #$38
                sta scrollx
                sta scrolly
                lda #<cleartextscreen
                sta krnon_ctsjump+1
                lda #>cleartextscreen
                sta krnon_ctsjump+2

initsprites:    sei
                lda #$34
                sta $01
                lda #$00
                sta rgscr_spronmask+1
                sta frameupdflag
                sta depacksprflag
                sta irqsprstart
                sta irqirqstart
                sta sortsprstart
                sta sortsprend
                sta sortirqstart
                sta sortirqend
                sta numspr
                sta maptemp1
                tax
                lda #LASTSPRITEFRAME-FIRSTSPRITEFRAME   ;Init free sprite count
                sta freesprites
is_copyfontloop:lda menutextchars,x             ;Copy charset to its ingame
                sta textchars,x                 ;place
                lda menutextchars+$100,x
                sta textchars+$100,x
                inx
                bne is_copyfontloop
                ldx #$3f                        ;Make empty spriteframe
is_emptyfrloop: sta $c000+EMPTYFRAME*64,x
N               set 0
                repeat NUMDEPACKSPR             ;Clear depacksprites
                sta $c000+FIRSTDEPACKFRAME*64+64*N,x
N               set N+1
                repend
                dex
                bpl is_emptyfrloop
                
                ldx #NUMDEPACKSPR-1
is_dsprloop:    lda #$ff                        ;Reset depacksystem
                sta dsprf,x
                sta dsprprevf,x
                dex
                bpl is_dsprloop
                lda #$36
                sta $01
                cli
                ldx #$00
is_spradrloop:  lda dspr_adrlo,x                 ;Add baseaddress to
                clc                             ;depack-spritepointers
                adc #<depacksprdata
                sta dspr_adrlo,x
                lda dspr_adrhi,x
                adc #>depacksprdata
                sta dspr_adrhi,x
                inx
                cpx #(dspr_adrhi-dspr_adrlo)
                bcc is_spradrloop

                ldx #NUMSPR
is_loop:        txa                             ;Create initial sprite order
                sta sortorder,x
                lda #$ff
                sta spry,x
                dex
                bpl is_loop
                jsr initscroll

initraster:     sei
                lda #$35
                sta $01
                lda #<raster_idle
                sta $0314
                lda #>raster_idle
                sta $0315
                lda #<raster_panel
                sta $fffe
                lda #>raster_panel
                sta $ffff
                lda #RASTER_PANEL_POS
                sta $d012
                lda #$60
                sta bganimcode
                lda #$7f                        ;Set timer interrupt off
                sta $dc0d
                lda #$01                        ;Set raster interrupt on
                sta $d01a
                lda $dc0d                       ;Acknowledge timer interrupt
                cli

                jsr cleartextscreen

drawpanel:      lda #UPD_SCORE|UPD_ITEM|UPD_AMMO ;Next time the panel will
                sta panelupdateflag             ;be updated fully, if it's
                lda #$00                        ;the score/textmode
                sta plrprevhp
                sta plrprevbatt
                sta msgtime

                ldx #39
dp_loop1:       lda #$20
                sta textscreen+21*40,x
                sta textscreen+22*40,x
                sta textscreen+23*40,x
                lda #$01
                sta colors+21*40,x
                sta colors+22*40,x
                lda #$09
                sta colors+23*40,x
                dex
                bne dp_loop1

                ldx #29
                stx textscreen+21*40
                inx
                stx textscreen+22*40
                inx
                stx textscreen+23*40
                ldx #62
                stx textscreen+23*40+39
                lda #$09
                sta colors+21*40
                sta colors+22*40
                sta colors+23*40
                sta colors+23*40+39
                ldx #38
dp_loop2:       lda #60
                sta textscreen+23*40,x
                dex
                bne dp_loop2
                ldx #29
                stx textscreen+21*40+8
                stx textscreen+21*40+31
                inx
                stx textscreen+22*40+8
                stx textscreen+22*40+31
                ldx #61
                stx textscreen+23*40+8
                stx textscreen+23*40+31
                lda #$08
                sta colors+22*40+1                ;Weapon indicator colors
                sta colors+22*40+2
                lda #$09
                sta colors+21*40+8
                sta colors+22*40+8
                sta colors+21*40+31
                sta colors+22*40+31
                ldx #33
dp_loop3:       sta colors+21*40,x                ;Healthbar colors
                sta colors+22*40,x
                inx
                cpx #39
                bcc dp_loop3

                lda #"H"-64                       ;Healthbar letters
                sta textscreen+21*40+32
                lda #"A"-64
                sta textscreen+22*40+32
                lda #9
                sta textwindowleft
                lda #31
                sta textwindowright
                jsr cleartextwindow
                jsr updatepanel
                jsr resetmessage

                lda #$00                     ;Load first musicfile
                ldx #FILE_MUSIC              ;to see we have the side 2
                jsr makefilename
sidechange_again:
                lda #<musicarea              ;Disk change loop
                ldx #>musicarea
                jsr loadfiledisk
                beq sidechange_ok
                lda #<sidechange_text
                ldx #>sidechange_text
                ldy #MSGTIME_ETERNAL
                jsr printmsgax
                jsr retryprompt_nomessage    ;Wait for fire
                jmp sidechange_again
sidechange_ok:  jsr relocatemusic

                jsr resetmessage
                jsr menu_inactivatecounter
                lda #SPRF_COMMON                ;Load common sprites
                jsr loadsprites
                ldx #$ff
                txs
                lda #>(mainloop-1)              ;Push mainloop address
                pha
                lda #<(mainloop-1)
                pha
                lda #<SCRIPT_TITLE              ;Init titlescreen & jump to
                ldx #>SCRIPT_TITLE              ;mainloop afterwards (this
                jmp execscript                  ;code is overwritten)

dw_common:      lda dwlotbl,x
                sta alo
                lda dwhitbl,x
                sta ahi
                lda dwnumtbl,x
                sta temp1
                lda dwaddtbl,x
                sta temp2
dw_loop:        jsr ld_getbyte
                sta (alo),y
                dec temp1
                beq dw_ready
                lda alo
                clc
                adc temp2
                sta alo
                bcc dw_loop
                inc ahi
                bne dw_loop
dw_ready:       rts

ld_getbyte:     lda wpndefs
                inc ld_getbyte+1
                bne ld_gbok
                inc ld_getbyte+2
ld_gbok:        rts

dwlotbl:        dc.b <wpn_noisetbl, <blt_xmodtbllo, <itemaddtbl, <specdmgcondition
dwhitbl:        dc.b >wpn_noisetbl, >blt_xmodtbllo, >itemaddtbl, >specdmgcondition
dwnumtbl:       dc.b NUMWEAPONATTRIB, NUMBULLETATTRIB, NUMITEMATTRIB, NUMSPECDMGATTRIB
dwaddtbl:       dc.b NUMWEAPONS, NUMBULLETS, NUMITEMS, NUMSPECDMG

sidechange_text:
                dc.b "PLEASE INSERT DISK SIDE 2 AND PRESS FIRE",0

initend:
                if initend > musicarea
                err
                endif
