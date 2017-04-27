;-------------------------------------------------------------------------------
; MW4 start
;-------------------------------------------------------------------------------


KEY_UP          = $91
KEY_DOWN        = $11

JOY_UP          = 1
JOY_DOWN        = 2
JOY_LEFT        = 4
JOY_RIGHT       = 8
JOY_FIRE        = 16


                processor 6502
                include define.s
                include loadsym.s
                include mw4sym.s

                org bootcodestart

;-------------------------------------------------------------------------------
; START
;
; Bootpart entrypoint
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

start:          lda #$36
                sta $01
                ldx #$00
                stx $d015                       ;Sprites off
                stx $d020                       ;Black screen (ture) :)
                stx $d021

copyloader:
N               set 0
                repeat 5
                lda loader+N*$100,x
                sta maincodestart+N*$100,x
N               set N+1
                repend
                inx
                bne copyloader
                cli
                jsr initloader
                jsr loadconfig
                jsr configscreen

continueloading:lda configmodified
                beq saveconfig_skip
saveconfig:     lda #<(-CONFIG_LENGTH)
                ldx #>(-CONFIG_LENGTH)
                sta zp_dest_lo
                stx zp_dest_hi
                lda #$30                      ;Filename 0
                sta filename
                sta filename+1
                lda #<usefastload
                ldx #>usefastload
                jsr savefile
saveconfig_skip:                

                jsr initfastload                ;Init fastload if necessary
                lda #$02
                jsr makefilename_direct
                lda useloadpic
                beq skiploadpic
                lda #<loadpicdata
                ldx #>loadpicdata
                jsr loadfile
                bcs skiploadpic
copyloadpic_wait:
                lda $d011
                bpl copyloadpic_wait
                and #$0f
                sta $d011
                ldx #$00
                ldy #$04
                sei
                lda #$34
                sta $01
copyloadpic:    lda loadpicdata+$0400,x
                inc $01
copyloadpicsta: sta colors,x
                dec $01
                inx
                bne copyloadpic
                inc copyloadpic+2
                inc copyloadpicsta+2
                dey
                bne copyloadpic
                lda #$36
                sta $01
                cli
                stx $d021
                lda #$18
                sta $d016
                lda #$68
                sta $d018
                lda #$3b
                sta $d011
skiploadpic:    lda #$04
                jsr makefilename_direct         ;Mainpart filename
                lda #<loadercodeend
                ldx #>loadercodeend
                jsr loadfile
                bcc ok
                lda $d011
                and #$0f
                sta $d011
                jmp 64738                       ;Reset if can't be loaded
ok:             jmp entrypoint

;-------------------------------------------------------------------------------
; LOADCONFIG
;
; Loads the loader configuration (fastload, loadpic)
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

loadconfig:     jsr openfile
                ldx #$00
lc_loop:        jsr getbyte
                bcs lc_end
                sta tempconfig,x
                inx
                bne lc_loop
lc_end:         ldx #CONFIG_LENGTH-1
lc_loop2:       lda tempconfig,x
                sta usefastload,x
                dex
                bpl lc_loop2
                rts

;-------------------------------------------------------------------------------
; CONFIGSCREEN
;
; Displays the config screen
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

configscreen:   ldx #$00
cs_clearloop:   lda #$20
                sta screen1,x
                sta screen1+$100,x
                sta screen1+$200,x
                sta screen1+$300,x
                lda #$01
                sta colors,x
                sta colors+$100,x
                sta colors+$200,x
                sta colors+$300,x
                inx
                bne cs_clearloop
                lda $dd00
                and #$fc
                sta $dd00
                lda #$06
                sta $d022
                lda #$04
                sta $d018
                lda #$08
                sta $d016
                lda #$5b
                sta $d011
                ldx #$00
cs_textloop:    lda configtext,x
                and #$3f
                sta screen1+8*40,x
                lda configtext+160,x
                and #$3f
                sta screen1+8*40+160,x
                inx
                cpx #160
                bcc cs_textloop
cs_loop:        ldx #$00
                ldy #$00
cs_printonoff:  lda usefastload,y
                sty temp1
                tay
                lda #15
                sta screen1+10*40+34,x
                lda onofftext2,y
                sta screen1+10*40+35,x
                lda onofftext3,y
                sta screen1+10*40+36,x
                txa
                clc
                adc #40
                tax
                ldy temp1
                iny
                cpy #$02
                bcc cs_printonoff
cs_wait:        lda $d011
                bmi cs_wait
cs_wait2:       lda $d011
                bpl cs_wait2
                lda #$40
                jsr cs_colorbar

                lda joystick
                sta prevjoy
                lda #$ff
                sta $dc00
                lda $dc00
                eor #$ff
                and #JOY_UP|JOY_DOWN|JOY_LEFT|JOY_RIGHT|JOY_FIRE
                sta joystick
                ldy prevjoy
                bne cs_nojoystick
                lsr
                bcs cs_up
                lsr
                bcs cs_down
                lsr
                lsr
                lsr
                bcs cs_select
cs_nojoystick:  jsr getin
                cmp #KEY_UP
                bne cs_notup
cs_up:          lda #$00
                cmp selection
                lda selection
                sbc #$00
cs_movecommon:  pha
                lda #$00
                jsr cs_colorbar
                pla
                sta selection
                jmp cs_loop
cs_notup:       cmp #KEY_DOWN
                bne cs_notdown
cs_down:        lda #$02
                cmp selection
                lda selection
                adc #$00
                bcc cs_movecommon
cs_notdown:     cmp #13
                beq cs_select
                cmp #32
                beq cs_select
                jmp cs_wait
cs_select:      lda prevjoy
                bne cs_wait
                ldx selection
                cpx #$02
                bcc cs_toggle
                bne cs_seeinstr
                rts
cs_seeinstr:    jsr initfastload
                lda #$03
                jsr makefilename_direct         ;Instructions filename
                lda #<$1000
                ldx #>$1000
                jsr loadfile
                bcs cs_skipinstr                ;Skip if not found
                jsr $1000                       ;(nonessential)
cs_skipinstr:   jmp configscreen

cs_toggle:      lda usefastload,x
                eor #$01
                sta usefastload,x
                lda #$01
                sta configmodified
                jmp cs_loop

cs_colorbar:    sta temp2
                lda selection
                cmp #$02
                adc #$00
                asl
                asl
                asl
                sta temp1
                asl
                asl
                adc temp1
                tax
                ldy #34
cs_cbloop:      lda screen1+10*40+3,x
                and #$3f
                ora temp2
                sta screen1+10*40+3,x
                inx
                dey
                bne cs_cbloop
                rts

                     ;0123456789012345678901234567890123456789
configtext:     dc.b " MW4 AGENTS OF METAL V1.2 CONFIGURATION "
                dc.b "                                        "
                dc.b "   FASTLOADER 1541/81/FD/HD/IDE64       "
                dc.b "   SHOW LOADING PICTURE                 "
                dc.b "                                        "
                dc.b "   LOAD THE GAME                        "
                dc.b "   VIEW INSTRUCTIONS                    "
                dc.b "                                        "

onofftext2:     dc.b $06,$0e
onofftext3:     dc.b $06,$20

selection:      dc.b 2
tempconfig:     dc.b 1,1
configmodified: dc.b 0

loader:         incbin loader.bin
loaderend:
                org menutextchars

                incbin bg/scorescr.chr


