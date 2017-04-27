JOY_UP          = 1
JOY_DOWN        = 2
JOY_LEFT        = 4
JOY_RIGHT       = 8
JOY_FIRE        = 16
JOY_JUMP        = 32

KEY_DEL         = 0
KEY_RETURN      = 1
KEY_CURSORLR    = 2
KEY_F7          = 3
KEY_F1          = 4
KEY_F3          = 5
KEY_F5          = 6
KEY_CURSORUD    = 7
KEY_3           = 8
KEY_W           = 9
KEY_A           = 10
KEY_4           = 11
KEY_Z           = 12
KEY_S           = 13
KEY_E           = 14
KEY_SHIFT1      = 15
KEY_5           = 16
KEY_R           = 17
KEY_D           = 18
KEY_6           = 19
KEY_C           = 20
KEY_F           = 21
KEY_T           = 22
KEY_X           = 23
KEY_7           = 24
KEY_Y           = 25
KEY_G           = 26
KEY_8           = 27
KEY_B           = 28
KEY_H           = 29
KEY_U           = 30
KEY_V           = 31
KEY_9           = 32
KEY_I           = 33
KEY_J           = 34
KEY_0           = 35
KEY_M           = 36
KEY_K           = 37
KEY_O           = 38
KEY_N           = 39
KEY_PLUS        = 40
KEY_P           = 41
KEY_L           = 42
KEY_MINUS       = 43
KEY_COLON       = 44
KEY_DOUBLECOLON = 45
KEY_AT          = 46
KEY_COMMA       = 47
KEY_POUND       = 48
KEY_ASTERISK    = 49
KEY_SEMICOLON   = 50
KEY_HOME        = 51
KEY_SHIFT2      = 52
KEY_EQUALS      = 53
KEY_ARROWU      = 54
KEY_SLASH       = 55
KEY_1           = 56
KEY_ARROWL      = 57
KEY_CTRL        = 58
KEY_2           = 59
KEY_SPACE       = 60
KEY_CBM         = 61
KEY_Q           = 62
KEY_RUNSTOP     = 63
KEY_NONE        = $ff

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

;-------------------------------------------------------------------------------
; SCANKEYS
;
; Reads keyboard.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,temp1
;-------------------------------------------------------------------------------

scankeys:       lda #$ff
                sta keytype
                ldy #$07
sk_rowloop:     ldx keyrowbit,y
                stx $dc00
                ldx $dc01
                stx keyrowtbl,y
                cpx #$ff
                beq sk_rowempty
                tya
sk_rowempty:    dey
                bpl sk_rowloop
                tax
                bmi sk_nokey
                asl
                asl
                asl
                sta temp1
                ldy #$07
                lda keyrowtbl,x
sk_colloop:     asl
                bcc sk_keyfound
                dey
                bpl sk_colloop
sk_keyfound:    tya
                ora temp1
                cmp keypress
                beq sk_samekey
                sta keytype
                sta keypress
sk_samekey:

;-------------------------------------------------------------------------------
; KEYCONTROL
;
; "Joystick" control with keyboard, with keys Q W E and SHIFT for fire.
;                                             A   D
;                                             Z X C
;
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

keycontrol:     ldx #$09
kcloop:         ldy kcrownum,x
                lda keyrowtbl,y
                and kcrowand,x
                beq kcpressed
kcnext:         dex
                bpl kcloop
                rts
kcpressed:      lda joystick
                ora kcjoybits,x
                sta joystick
                bne kcnext
sk_nokey:       sta keypress
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
