PLOT_MAP_ALLOWED        = 0                    ;Allowed to travel via mapscreen
PLOT_MAP_SUBCITY        = 1                    ;Individual locations
PLOT_MAP_FARM           = 2
PLOT_MAP_AGENTHQ        = 3
PLOT_MAP_FOREST         = 4
PLOT_MAP_COMMINT        = 5
PLOT_MAP_RESEARCH       = 6
PLOT_MAP_TRAINING       = 7
PLOT_MAP_MANSION        = 8
PLOT_MAP_IAC            = 9
PLOT_MAP_COMMAND        = 10

PLOT_SCEPTRE_ENTERED    = 11                    ;SCEPTRE infiltrated
PLOT_SCEPTRE_MESSAGE_DISPLAYED = 12             ;Dataterm message displayed
PLOT_SCEPTRE_LIFT_GPF   = 13                    ;Lift reset in Comm.Int
PLOT_SCEPTRE_MUTANT_FIRSTTIME = 14              ;Mutant escape displayed
PLOT_SCEPTRE_CODE1_FOUND = 15                   ;Codes from all 4 Outer Sphere
PLOT_SCEPTRE_CODE2_FOUND = 16                   ;facilities
PLOT_SCEPTRE_CODE3_FOUND = 17
PLOT_SCEPTRE_CODE4_FOUND = 18

PLOT_BLACKHAND_MULTI0 = 19                      ;Allow each multichoice once
PLOT_BLACKHAND_MULTI1 = 20
PLOT_BLACKHAND_MULTI2 = 21
PLOT_BLACKHAND_MULTI3 = 22
PLOT_BLACKHAND_MULTI4 = 23
PLOT_BLACKHAND_GOODLUCK_DONE = 24
PLOT_BLACKHAND_WARNED = 25                      ;Know of Sarge been in Erehwon
PLOT_BLACKHAND_DEAD = 26

PLOT_SARGE_EREHWON = 27

PLOT_EXAGENT_RANT_LISTENED = 28

PLOT_BLOWFISH_MET = 29
PLOT_BLOWFISH_MULTI0 = 30
PLOT_BLOWFISH_MULTI1 = 31
PLOT_BLOWFISH_MULTI2 = 32

PLOT_MADLOCUST_LETTER = 33
PLOT_MADLOCUST_DEAD = 34

PLOT_SUHRIM_SEEN = 35

PLOT_LILITH_MULTI0 = 36
PLOT_LILITH_MULTI1 = 37
PLOT_LILITH_MULTI2 = 38
PLOT_LILITH_MULTI3 = 39

PLOT_AHRIMAN_MULTI0 = 40
PLOT_AHRIMAN_MULTI1 = 41
PLOT_AHRIMAN_MULTI2 = 42
PLOT_AHRIMAN_MULTI3 = 43
PLOT_AHRIMAN_MULTI4 = 44
PLOT_AHRIMAN_MULTI5 = 45
PLOT_AHRIMAN_MULTI6 = 46

PLOT_GENERATOR1_OFFLINE = 47
PLOT_GENERATOR2_OFFLINE = 48
PLOT_OBSKURIUS_OFFLINE = 49

PLOT_ULTRASHRED_LYRIC = 50
PLOT_ULTRASHRED_MAINCONV = 51
PLOT_ULTRASHRED_LYRICCONV = 52

PLOT_SENTINEL_MULTI0 = 53
PLOT_SENTINEL_MULTI1 = 54
PLOT_SENTINEL_MULTI2 = 55
PLOT_SENTINEL_MULTI3 = 56

PLOT_REACTOR_WEAKNESS = 57
PLOT_REACTOR_DISCUSSION = 58
PLOT_MELTDOWN_INITIATED = 59
PLOT_MELTDOWN_DONE = 60

PLOT_JOAN_SHOT_BAT = 61
PLOT_JOAN_MET = 62                              ;Reunion at the Sentinel ship
PLOT_JOAN_CONFLICT = 63                         ;Argument over Agent evidence
PLOT_JOAN_DEAD = 64

PLOT_SADOK_MSG_READ = 65
PLOT_SADOK_MULTI0 = 66
PLOT_SADOK_MULTI1 = 67
PLOT_SADOK_MULTI2 = 68
PLOT_SADOK_MULTI3 = 69
PLOT_SADOK_HINT = 70
PLOT_SADOK_MET = 71

PLOT_JOAN_JOIN = 72                             ;Agent band lineup
PLOT_GOAT_JOIN = 73
PLOT_SADOK_JOIN = 74

PLOT_AHRIMAN_DEAD = 75

;-------------------------------------------------------------------------------
; CHECKPLOTBIT
; GETPLOTBIT
;
; Gets status of plotbit
;
; Parameters: A:Plotbit number (0-255)
; Returns: A:0 or 1
; Modifies: A,Y
;-------------------------------------------------------------------------------

checkplotbit:
getplotbit:     jsr decodebit
                and plotbits,y
                beq gpb_ok
                lda #$01
gpb_ok:         rts

;-------------------------------------------------------------------------------
; SETPLOTBIT
;
; Sets status of plotbit to 1
;
; Parameters: A:Plotbit number (0-255)
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

setplotbit:     jsr decodebit
                ora plotbits,y
                sta plotbits,y
                rts

;-------------------------------------------------------------------------------
; CLEARPLOTBIT
;
; Sets status of plotbit to 0
;
; Parameters: A:Plotbit number (0-255)
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

clearplotbit:   jsr decodebit
                eor #$ff
                and plotbits,y
                sta plotbits,y
                rts

;-------------------------------------------------------------------------------
; BEGINFULLSCREEN
; ENDFULLSCREEN
;
; Begins/ends fullscreen special scene (mapscreen, computer terminal etc.)
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

beginfullscreen:jsr menu_inactivatecounter
                jsr resetmessage
                jmp cleartextscreen

endfullscreen_reload:
                lda levelnum
                ldx #LLMODE_NOPURGEABLE
                jsr loadlevel
endfullscreen:  jmp centerplayer

;-------------------------------------------------------------------------------
; ISINCOMBAT
;
; Is actor in alert/combat status?
;
; Parameters: X:Actor number
; Returns: C=1 yes
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

isincombat:     ldx actrestx
                lda actmode,x
                cmp #M_ALERT
                rts

;-------------------------------------------------------------------------------
; SELECTLINESUB
;
; Selects line from a list indexed by 16bit pointers
;
; Parameters: A:Line number, XY pointer to list
; Returns: AX:Pointer to line
; Modifies: A,X,Y,alo
;-------------------------------------------------------------------------------

selectlinesub:  stx alo
                sty ahi
                asl
                tay
                iny
                lda (alo),y
                tax
                dey
                lda (alo),y
                rts

;-------------------------------------------------------------------------------
; SPEAK
;
; Speaks a line and waits for player to read it
;
; Parameters: AX:Pointer to line, actrestx: actor speaking it
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

playerspeak:    jsr printmsgeternalax
                ldx #ACTI_PLAYER
                beq speak_common

speak:          jsr printmsgeternalax
                ldx actrestx
speak_common:   jsr displayballoon
                jsr waitformessage
removeballoon:  ldx #NUMACT-1
rbloop:         lda actt,x
                cmp #ACT_BALLOON
                beq rbfound
                dex
                bpl rbloop
                rts
rbfound:        jmp removeactor

displayballoon: ldy #ACTI_FIRSTITEM              ;Get actor for speech balloon
speak_getactor: lda actt,y                      ;(reuse if possible)
                beq speak_found
                cmp #ACT_BALLOON
                beq speak_found
                iny
                cpy #ACTI_LASTNPCBLT
                bcc speak_getactor
                bcs speak_noactor
speak_found:    lda #$00
                jsr gfa_found
                lda #ACT_BALLOON
                jsr spawnactor
                lda #$00
                sta temp3
                lda actsizeup,x
                asl
                rol temp3
                asl
                rol temp3
                asl
                sta temp2
                rol temp3
                lda actyl,y
                sbc temp2
                sta actyl,y
                lda actyh,y
                sbc temp3
                sta actyh,y
                lda #$01
                sta acttime,y
                clc
speak_noactor:  rts

;-------------------------------------------------------------------------------
; BORDER
;
; Border for computer screens etc.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

border:         lda #$00
                sta temp1
                sta temp3
                lda #>textscreen
                sta temp2
                lda #>colors
                sta temp4
                ldy #$00
                ldx #19
brd_loop:       lda #30
                jsr brd_store
                lda temp1
                clc
                adc #40
                sta temp1
                sta temp3
                bcc brd_notover
                inc temp2
                inc temp4
brd_notover:    dex
                bne brd_loop
                lda #31
                jsr brd_store
brd_loop2:      iny
                lda #60
                jsr brd_store
                cpy #38
                bcc brd_loop2
                iny
                lda #62
brd_store:      sta (temp1),y
                lda #$09
                sta (temp3),y
                rts

;-------------------------------------------------------------------------------
; FINDACTOR
;
; Finds actor with certain type
;
; Parameters: A:Actor type that's searched
; Returns: C=1 found, with X index. Also saved to actrestx
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

findactor:      ldx #NUMACT-1
faloop:         cmp actt,x
                beq fafound
                dex
                bne faloop
                clc
                rts
fafound:        stx actrestx
                rts

;-------------------------------------------------------------------------------
; CHOICEBYFLAGS
;
; Allow choices if corresponding plotbits are zero
;
; Parameters: X:Number of choices
;             A:First plotbit
; Returns: choicenum
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

choicebyflags:  sta temp1
                lda #$00
                pha
                lda #$01
                sta temp2
cbf_loop:       lda temp1
                jsr getplotbit
                bne cbf_skip            ;Skip if one
                pla
                ora temp2
                pha
cbf_skip:       inc temp1
                asl temp2
                dex
                bne cbf_loop
                pla
                sta multichoices
                rts

;-------------------------------------------------------------------------------
; DOCHOICE
;
; Perform actual multichoice selection
;
; Parameters: XY:Multichoice pointer list
;             A:Available choices (SETDOCHOICE only)
; Returns: A:Player's selection
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

setdochoice:    sta multichoices
dochoice:       stx dc_x+1
                sty dc_y+1

                ldx #ACTI_PLAYER
                jsr displayballoon
                bcs dc_balloonskip
                lda #$01                ;Question mark
                sta actf1,y
dc_balloonskip:

                ldy #$00                ;Start with lowest available choice
                lda multichoices
dc_initloop:    lsr
                bcs dc_initdone
                iny
                bne dc_initloop
dc_initdone:    sty choicenum
                sty choicemin
                ldy #$07
                lda multichoices
dc_initloop2:   asl                     ;Store highest available choice
                bcs dc_initdone2
                dey
                bpl dc_initloop2
dc_initdone2:   sty choicemax

                jsr menu_inactivatecounter
dc_redraw:      lda #SFX_SELECT
                jsr playsfx
                lda choicenum
dc_x:           ldx #$00
dc_y:           ldy #$00
                jsr selectlinesub
                dec textwindowright
                jsr printmsgeternalax          ;Print the choice
                inc textwindowright
                lda choicenum
                ldx choicemax
                ldy choicemin
                jsr drawarrows
dc_loop:        jsr increaseclock
                jsr menu_control
                lda temp1
                and #JOY_FIRE
                bne dc_done
                lda temp1
                lsr
                bcs dc_up
                lsr
                bcs dc_down
                lsr
                bcs dc_up
                lsr
                bcs dc_down
                jmp dc_loop
dc_done:        lda #SFX_SELECT
                jsr playsfx
                ldx dc_x+1
                ldy dc_y+1
                lda choicenum
                jsr selectlinesub
                jsr playerspeak
                lda #$00
                sta multichoices
                lda choicenum
                rts
dc_up:          lda choicenum
                cmp choicemin
                beq dc_loop
dc_uploop:      dec choicenum
                lda choicenum
                jsr decodebit
                and multichoices
                beq dc_uploop
                jmp dc_redraw
dc_down:        lda choicenum
                cmp choicemax
                beq dc_loop
dc_downloop:    inc choicenum
                lda choicenum
                jsr decodebit
                and multichoices
                beq dc_downloop
                jmp dc_redraw

;-------------------------------------------------------------------------------
; FADEINTEXT
;
; Shows a text for 5 seconds, with fadein/out. Text must be on rows 9 & 10.
;
; Parameters: AY:Formatted text ptr
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------
fadeintext:     jsr printscreentext
                lda #6
                jsr introfadesub
                lda #3
                jsr introfadesub
                lda #1
                jsr introfadesub
                lda #125
                jsr waitforfire
                lda #3
                jsr introfadesub
                lda #6
                jsr introfadesub
                lda #0
introfadesub:   sta ifs_loop+1
                jsr scriptupdateframe
                jsr scriptupdateframe
                ldx #79
ifs_loop:       lda #$00
                sta colors+9*40,x
                dex
                bpl ifs_loop
                rts

;-------------------------------------------------------------------------------
; TRANSMISSION
;
; Prints the "Agent transmission" text & plays sound (used many times in
; scripts)
;
; Parameters: -
; Returns: -
; Modifies: Lots :)
;-------------------------------------------------------------------------------

transmission:   lda #<transmissiontext
                ldx #>transmissiontext
                jsr printmsgeternalax
                lda #SFX_TRANSMISSION
                jsr playsfx

;-------------------------------------------------------------------------------
; WAITFORMESSAGE
;
; Waits for a message (continue with fire/space)
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,everything :)
;-------------------------------------------------------------------------------

waitformessage: jsr menu_inactivatecounter
wfm_loop:       lda msgtime
                ora msgcont                     ;Wait for all screens displayed
                beq wfm_done
                jsr increaseclock
                jsr menu_control
                lda temp1
                and #$80+JOY_FIRE
                beq wfm_loop
                lda #$00
                sta msgtime
                beq wfm_loop
wfm_done:       jmp resetmessage

        ;A=time to wait, or $ff eternal

waitforfire:    sta msgtime
                jsr menu_inactivatecounter
wff_loop:       jsr increaseclock
                jsr menu_control
                lda msgtime
                beq wff_quit
                lda temp1
                and #$80+JOY_FIRE
                beq wff_loop
                lda #$00
                sta msgtime
wff_quit:       rts

