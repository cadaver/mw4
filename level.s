LLMODE_NORMAL = 0
LLMODE_NOPURGEABLE = 1


ADDACTOR_LEFT_LIMIT = 2
ADDACTOR_TOP_LIMIT = 1
ADDACTOR_RIGHT_LIMIT = 12
ADDACTOR_BOTTOM_LIMIT = 8

MEDIUMENEMYPROB = $d8



LA_LEVEL        = 0
LA_X            = 1                             ;Levelactor-structure
LA_Y            = 2
LA_FINE         = 3
LA_TYPE         = 4
LA_DATA         = 5                             ;Weapon/pickup amount
LA_NEXT         = 6

OB_NOACT        = 0
OB_MANUALACT    = 1
OB_MANUALACTDEACT = 2
OB_TRIGGERED    = 3
OB_CMDBIT1      = 4
OB_CMDBIT2      = 8
OB_CMDBIT3      = 16
OB_EATITEM      = 32
OB_AUTODEACT    = 64
OB_2BLOCKHIGH   = 128


NUMLVLOBJSEARCH = 32                            ;Amount of objects searched
                                                ;during frame

ADDELAY         = 16                            ;Auto-deactivate delay

DOORENTERDELAY  = 5                             ;Door entry delay
CONVDELAY       = 5                             ;Convo delay
DROPITEMDELAY   = 24                            ;To drop an item, must hold
                                                ;FIRE+UP for about second
DOORHINT_DURATION = 16

;-------------------------------------------------------------------------------
; LOADLEVEL
;
; Loads a level.
;
; Parameters: A:Level number
;             X:Mode (0 = normal  1 = do not remove/create purgeable actors)
; Returns: -
; Modifies: A,X,Y,temp1-temp7
;-------------------------------------------------------------------------------

ll_retry:       jsr closefile
                jsr retryprompt
                jmp ll_again

loadlevel:      sta levelnum
                stx ll_mode+1
                lda #$00                        ;Make sure no BG-animation
                sta frameupdflag                ;routine execution happens :)
                jsr cleartextscreen
ll_again:       ldx #FILE_LEVEL
                lda levelnum
                jsr makefilename
                lda #<map                       ;Load map/blocks/infos
                ldx #>map
                jsr loadfiledisk
                bcs ll_retry
                lda #<(chars+$200)              ;Load chars
                ldx #>(chars+$200)
                jsr loadfiledisk
                bcs ll_retry
                lda #<lvlobjx                   ;Load zoneinfo & objectinfo
                ldx #>lvlobjx
                jsr loadfiledisk
                bcs ll_retry

                lda levelnum                    ;Correct the object-state
                jsr getlvlobjstatptr            ;pointer
                lda #$00                        ;Assume zone 0 after loading
                jsr findzonenum                 ;a new level
                jsr initmap                     ;Init mappointer

                lda #NUMLVLOBJ-1
                sta aonum
ll_initobjanim: lda aonum                       ;Check if level objects are
                jsr getlvlobjstat               ;active; in that case set
                beq ll_initobjanimskip          ;their animation frame
                jsr ao_animate
ll_initobjanimskip:
                dec aonum
                bpl ll_initobjanim

ll_mode:        lda #$00
                beq ll_purgeableok
                jmp ll_skippurgeable
ll_purgeableok: sta levelalert                  ;Reset alert level
                lda #$ff                        ;Reset objectsystem
                sta lvlobjnum
                sta adobjnum
                lda #NUMZONES-1                 ;Reset flashing
                sta zoneflash
                jsr addact_reset                ;Remove old purgeable actors
ll_purgeactors: ldy #LA_LEVEL
                lda (lvlactptrlo),y             ;Level bit 7 set = purgeable
                bpl ll_purgenext
                lda #$7f
                sta (lvlactptrlo),y             ;Bogus levelnumber
                ldy #LA_TYPE
                lda #$00
                sta (lvlactptrlo),y             ;Clear type
ll_purgenext:   jsr addact_gotonext
                bcc ll_purgeactors
                ldx #NUMLVLOBJ-1                ;Create new purgeable actors
ll_raloop:      stx temp7
                lda lvlobjb,x                   ;Get levelactor bits
                and #$1c
                cmp #7*4                        ;Check for spawnpoint
                bne ll_ranext
                jsr random                      ;On $00-$d7, create actor
ll_enemyprobability: 
                cmp #MEDIUMENEMYPROB
                bcs ll_ranext
                ldy #$01                        ;Use actor 1
                lda #$00
                jsr gfa_found
                lda lvlobjd2,x                  ;And & add-values to limit
                sta ll_raadd+1                  ;useable actors from the list
                lda lvlobjd1,x
                sta ll_raand+1
                lda lvlobjx,x                   ;Setup coords
                sta actxh,y
                lda lvlobjy,x
                and #$7f
                sta actyh,y
                lda #$00
                sta actyl,y
                lda #$80
                sta actxl,y
                sta actpurgeable,y              ;Make purgeable
                tya
                tax
                jsr random                      ;Select random
                clc                             ;(type,weapon)-pair from list
ll_raand:       and #$00
ll_raadd:       adc #$00
                pha                             ;from list
                tay
                lda randomacttbl,y              ;Get actor type
                sta actt,x
                jsr initcomplexactor
                pla
                tay
                lda randomacttbl+NUMRANDOMACT,y ;Get actor weapon
                sta actwpn,x
                lda #M_PATROL                   ;Assume PATROL mode
                sta actmode,x
                jsr random                      ;Randomize direction
                sta actd,x
                jsr removelevelactor            ;Put to leveldata
ll_ranext:      ldx temp7
                dex
                bpl ll_raloop
ll_skippurgeable:
                rts

;-------------------------------------------------------------------------------
; INITMAP
;
; Calculates start addresses for each map-row (of current zone) and for each
; block.
;
; Parameters: -
; Returns: -
; Modifies: A,X
;-------------------------------------------------------------------------------

initmap:        lda limitu                      ;Startrow of zone
                ldy mapsizex                    ;Multiply with map number
                ldx #maptemp1
                jsr mulu
                lda maptemp1
                clc
                adc limitl                      ;Add startcolumn of zone
                sta maptemp1                    ;to get a value to subtract
                bcc im_ok1                      ;from the map pointer
                inc maptemp2
im_ok1:         lda mapptrlo                    ;Address of first maprow
                sec
                sbc maptemp1
                sta maptemp1
                lda mapptrhi
                sbc maptemp2
                sta maptemp2
                lda #<blocks                    ;Address of first block
                sta maptemp3
                lda #>blocks
                sta maptemp4
                ldx #$00                        ;The counter
im_loop:        lda maptemp2                    ;Store and increase maprow-
                sta maptblhi,x                  ;pointer
                lda maptemp1
                sta maptbllo,x
                clc
                adc mapsizex
                sta maptemp1
                bcc im_notover1
                inc maptemp2
im_notover1:    lda maptemp4                    ;Store and increase block-
                sta blktblhi,x                  ;pointer
                lda maptemp3
                sta blktbllo,x
                clc
                adc #$10
                sta maptemp3
                bcc im_notover2
                inc maptemp4
im_notover2:    inx                             ;Do 128 rows for the maptable
                bpl im_loop                     ;& blocktable
incspritetime:  ldx #NUMSPRFILES-1
                lda #$ff
im_sprfiletime: ldy sprfilebaseframe,x          ;Now increase the time counter
                beq imsft_skip                  ;on all spritefiles that are
                inc sprfiletime,x               ;in memory
                bne imsft_skip
                sta sprfiletime,x
imsft_skip:     dex
                bpl im_sprfiletime
                rts

;-------------------------------------------------------------------------------
; FINDZONEXY
; FINDZONENUM
;
; Finds the zone indicated by coordinates (or number) and copies the
; information necessary
; Parameters: A:Zone number (FINDZONENUM)
;             X,Y:X,Y pos (FINDZONEXY)
; Returns: -
; Modifies: A,X,Y,temp1-temp4
;-------------------------------------------------------------------------------

findzonexy:     stx temp1
                sty temp2
                jsr fz_resetptr
fzxy_loop:      lda temp1
                cmp zonel,x
                bcc fzxy_next
                cmp zoner,x
                bcs fzxy_next
                lda temp2
                cmp zoneu,x
                bcc fzxy_next
                cmp zoned,x
                bcc fz_found
fzxy_next:      jsr fz_next
                bpl fzxy_loop
                rts

findzonenum:    sta temp1
                jsr fz_resetptr
fzn_loop:       cpx temp1
                beq fz_found
                jsr fz_next
                bpl fzn_loop
                rts

fz_found:       stx zonenum
                lda zonel,x
                sta limitl
                lda zoner,x
                sta limitr
                sec
                sbc zonel,x
                sta mapsizex
                lda zoneu,x
                sta limitu
                lda zoned,x
                sta limitd
                rts

fz_resetptr:    ldx #$00                        ;Initial zone num
                lda #<map
                sta mapptrlo
                lda #>map
                sta mapptrhi
                rts

fz_next:        stx fz_restx+1
                lda zoned,x                     ;Get zone mapdata size
                sec
                sbc zoneu,x
                tay
                lda zoner,x
                sbc zonel,x
                ldx #temp3
                jsr mulu
                lda mapptrlo                    ;Advance to next zone
                clc
                adc temp3
                sta mapptrlo
                lda mapptrhi
                adc temp4
                sta mapptrhi
fz_restx:       ldx #$00
                inx
                lda zoneu,x                     ;Negative = unused zone
                rts

;-------------------------------------------------------------------------------
; FINDOBJECT
;
; Finds the object player is on.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,temp1-temp4
;-------------------------------------------------------------------------------

findobject:     ldx actxh+ACTI_PLAYER
                stx fo_plrx+1
                ldy actyh+ACTI_PLAYER
                dey
                sty fo_plry+1
                ldx lvlobjsearch
fo_loop:        lda lvlobjx,x
fo_plrx:        cmp #$00
                bne fo_next                     ;Carry=1 if equal for SBC
                lda lvlobjy,x
                and #$7f
fo_plry:        sbc #$00
                cmp #$02                        ;Above or at object
                bcc fo_found
fo_next:        inx
fo_endcmp:      cpx #NUMLVLOBJSEARCH
                bne fo_loop
                txa
                and #$7f
                sta lvlobjsearch
                bne fo_nowrap                   ;Search wrapped around?
                stx lvlobjnum                   ;Negative = no object
fo_nowrap:      clc
                adc #NUMLVLOBJSEARCH
                sta fo_endcmp+1                 ;New search for next frame
                rts
fo_found:       lda lvlobjb,x                   ;Spawnpoint
                and #$1c
                cmp #$1c
                beq fo_next                     ;Don't care about them
                stx lvlobjnum
                jsr checkformanual              ;Show sign for manually
                beq fo_nosign                   ;activated objects
                cmp #OB_MANUALACTDEACT
                beq fo_signok
                tya
                jsr getlvlobjstat               ;Do not show sign if active
                bne fo_nosign
                ldy lvlobjnum
fo_signok:      lda lvlobjx,y
                sta temp1
                lda lvlobjy,y
                and #$7f
                clc
                adc #$01
                sta temp2
                ldy #ACTI_LASTPLRBLT            ;Use last playerbullet for
                lda #ACTI_LASTPLRBLT            ;this purpose
                jsr getfreeactor
                bcc fo_nosign
                lda #ACT_DOORHINT
                jsr createactor
                lda temp1
                sta actxh,y
                lda temp2
                sta actyh,y
                lda actxl+ACTI_PLAYER
                sta actxl,y
                lda #DOORHINT_DURATION
                sta acttime,y
fo_nosign:      rts

;-------------------------------------------------------------------------------
; GETLVLOBJSTATPTR
;
; Gets levelobjectstatus-pointer (16 bytes for each level)
;
; Parameters: A:Level
; Returns: -
; Modifies: A,X,Y,temp1-temp2
;-------------------------------------------------------------------------------

getlvlobjstatptr:
                ldy #16
                ldx #temp1
                jsr mulu
                lda temp1
                clc
                adc #<lvlobjstatus
                sta lvlobjstatptrlo
                lda temp2
                adc #>lvlobjstatus
                sta lvlobjstatptrhi
                rts

;-------------------------------------------------------------------------------
; GETLVLOBJSTAT
;
; Gets status of level object in current level
;
; Parameters: A:Object number
; Returns: A:zero or nonzero (zeroflag set)
; Modifies: A,Y
;-------------------------------------------------------------------------------

getlvlobjstat:  jsr decodebit
                and (lvlobjstatptrlo),y
                rts

;-------------------------------------------------------------------------------
; SETLVLOBJSTAT
;
; Sets status of level object in current level to 1
;
; Parameters: A:Object number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

setlvlobjstat:  jsr decodebit
                ora (lvlobjstatptrlo),y
                sta (lvlobjstatptrlo),y
                rts

;-------------------------------------------------------------------------------
; CLEARLVLOBJSTAT
;
; Sets status of level object in current level to 0
;
; Parameters: A:Object number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

clearlvlobjstat:jsr decodebit
                eor #$ff
                and (lvlobjstatptrlo),y
                sta (lvlobjstatptrlo),y
                rts

decodebit:      pha
                and #$07
                tay
                lda keyrowbit,y
                eor #$ff
                sta db_value+1
                pla
                lsr
                lsr
                lsr
                tay
db_value:       lda #$00
                rts

;-------------------------------------------------------------------------------
; ACTIVATEOBJECT
;
; Tries activation of a level object
; (manual/auto activation must have been tested before)
;
; Parameters: X:Actor who is trying to activate
;             A:Object number
; Returns: C=1 successful
; Modifies: A,Y,tempregs
;-------------------------------------------------------------------------------

activateobject: stx actrestx
                sta aonum
                jsr getlvlobjstat               ;Check if already
                beq ao_notactive                ;active
                jmp ao_alreadyactive
ao_notactive:   ldy aonum
                cpx #ACTI_PLAYER                ;Player activating?
                bne ao_norequirements           ;(NPCs may activate
                                                ;any object without
                                                ;requirements)
                lda lvlobjr,y
                beq ao_norequirements
                bmi ao_anotherobject
ao_itemrequired:jsr finditem                    ;Test for item
                bcs ao_itemok
                ldy aonum
                lda lvlobjr,y                   ;Print "item required"
                jsr getitemname                 ;message
                ldy #MSGTIME
                jsr printmsgptr
                lda #MSG_REQUIRED
                jsr getmsgptr
                jsr ptw_continue
                lda #SFX_PICKUP
                jsr playsfx
ao_fail:        clc                             ;Not successful
ao_done:        ldx actrestx
                rts
ao_anotherobject:
                and #$7f                        ;Check for another object active
                jsr getlvlobjstat
                bne ao_norequirements
                beq ao_fail
ao_itemok:      ldy aonum                       ;Eat the item in question?
                lda lvlobjb,y
                and #OB_EATITEM
                beq ao_norequirements
                lda lvlobjr,y                   ;Decrement amount by one
                tay
                lda #$01
                jsr decreaseitem
ao_norequirements:
                lda aonum                       ;Set status to active
                jsr setlvlobjstat
                jsr ao_animate
                ldy aonum
                lda lvlobjb,y                   ;Auto-deactivate?
                and #OB_AUTODEACT
                beq ao_noautodeact
                lda adobjnum                    ;Another object already waiting
                bmi ao_notanother               ;for AD?
                jsr deactivateobject            ;Deactivate that right now
ao_notanother:  ldy aonum
                sty adobjnum
                lda #ADDELAY                    ;One second delay for AD
                sta adobjdelay
ao_noautodeact: lda lvlobjb,y                   ;Read action code
                lsr
                and #$0e
ao_doorok:      tax
                lda objactionjumptbl,x
                sta ao_jump+1
                lda objactionjumptbl+1,x
                sta ao_jump+2
ao_jump:        jsr $0000
ao_success:     sec                             ;Success
                jmp ao_done

ao_alreadyactive:
                ldy aonum
                lda lvlobjb,y                   ;Check for manual
                and #$03                        ;deactivation allowed
                cmp #$02
                bne ao_fail
                tya
                jsr deactivateobject
                jmp ao_success

ao_animate:     ldy aonum
                lda lvlobjy,y
                bpl ao_noanimation              ;Activation animation
                jsr ao_prepareanim
                jsr updateblock                 ;Update lower block
                ldy aonum
                lda lvlobjb,y                   ;Animation 2 blocks high?
                bpl ao_1blockhigh
                jsr ao_prepareanim              ;Update upper block
                dey
                jsr updateblock
ao_1blockhigh:
ao_noanimation: rts

ao_prepareanim: ldx lvlobjx,y
                lda lvlobjy,y
                and #$7f
                tay
                lda #$01                        ;Assume forward animation
ao_donothing:   rts


        ;Object execution routines
        ;Activate another object (in same level)

ao_aaobject:    lda lvlobjd1,y                  ;Destination object
                jsr getlvlobjstat               ;Already active?
                bne ao_aadeactivate
                ldy aonum
                lda lvlobjd1,y
                ldx actrestx                    ;Use same actor
                jmp activateobject
ao_aadeactivate:ldy aonum                       ;If already active, and
                lda lvlobjd1,y                  ;doesn't use autodeactivation,
                tay                             ;deactivation OK
                lda lvlobjb,y
                and #OB_AUTODEACT
                bne ao_donothing
                tya
                jmp deactivateobject

        ;Activate another actor (in same level)

ao_aaactor:     lda lvlobjd2,y                  ;Destination actor type
                ldx lvlobjd1,y                  ;Destination actor ident.
ao_aaactorax:   jsr findactortype
                bcc ao_donothing
                ldy aonum
                lda lvlobjy,y
                and #$7f
                adc #$00                        ;Carry=1, add 1
                cmp actyh,x                     ;Object above or below?
                beq ao_aaasamey
                bcc ao_aaaabove
ao_aaabelow:    lda #4                          ;Below
                bne ao_aaacommon
ao_aaasamey:    lda actyl,x                     ;On same position
                beq ao_donothing
ao_aaaabove:    lda #-4                         ;Above
ao_aaacommon:   sta actsy,x
                rts

        ;Reveal actor

ao_revealactor: lda lvlobjd2,y                  ;Dest. Y
                ora #$80                        ;Hidden flag
                ldx lvlobjd1,y
ao_revealcommon:jsr findactorxy
                bcc ao_revealfail
ao_revealloop:  lda (lvlactptrlo),y             ;Make actor visible
                and #$7f
                sta (lvlactptrlo),y
                jsr addact_withexec
                lda actmode,x                   ;Go directly to combat?
                cmp #M_ALERT
                bcc ao_revealskip
                lda #-16                        ;Perform an "attack leap"
                sta actsy,x                     ;so that it doesn't have
                lda speedpos                    ;to be scripted
                ldy actd,x
                bpl ao_attackleapok
                lda speedneg
ao_attackleapok:sta actsx,x

ao_revealskip:  jsr faxy_loop                   ;Continue for more actors?
                bcs ao_revealloop
ao_revealfail:  rts

        ;Reveal actor in current location and activate another object

ao_revealcurrent:
                lda lvlobjy,y
                ora #$80
                ldx lvlobjx,y
                jsr ao_revealcommon
                ldy aonum
                jmp ao_aaobject

        ;Execute script

ao_execscript:  lda lvlobjd1,y                  ;Entrypoint
                ldx lvlobjd2,y
                jmp execscript


;-------------------------------------------------------------------------------
; DEACTIVATEOBJECT
;
; Tries deactivation of a level object
; (whether that's actually allowed must have been tested before)
;
; Parameters: A:Object number
; Returns: -
; Modifies: A,X,Y,tempregs
;-------------------------------------------------------------------------------

deactivateobject:sta donum
                jsr getlvlobjstat               ;Check if already
                beq do_done                     ;deactivated
                lda donum
                jsr clearlvlobjstat             ;Clear status
                ldy donum
                lda lvlobjy,y
                bpl do_noanimation              ;Activation animation
                jsr ao_prepareanim

                jsr updateblock2                 ;Update lower block
                ldy donum
                lda lvlobjb,y                   ;Animation 2 blocks high?
                bpl do_1blockhigh
                jsr ao_prepareanim              ;Update upper block
                dey
                jsr updateblock2
do_1blockhigh:
do_done:
do_noanimation: rts

;-------------------------------------------------------------------------------
; PROCESSOBJECT
;
; Handles autodeactivation of objects & trigger-objects, manual activation of
; objects, activation of NPCs and dropping items, gameover sequence,
; comradeagent
;
; Parameters: -
; Returns: -
; Modifies: Everything
;-------------------------------------------------------------------------------

processobject:  lda acthp+ACTI_PLAYER           ;Player alive?
                bne po_playeralive
                lda actt+ACTI_PLAYER            ;Is the player an Agent?
                beq po_gameoverok
                cmp #ACT_IANAGENT               ;(nonagent forms are allowed
                bne po_notagent                 ;to "die" without gameover)
po_gameoverok:  lda gameon
                cmp #STATUS_INGAME
                bne po_notagent
setgameover:    lda #STATUS_GAMEOVER
                sta gameon
                lda tunenum                     ;Set gameover music
                and #$fc
                ora #$02
                jmp playgametune
po_notagent:    rts
po_playeralive:
                lda msgtime                     ;If no message, print item
                bne po_skipitemname             ;names as encountered
                ldy itemsearch
                ldx #ACTI_PLAYER
                lda actt,y
                cmp #ACT_ITEM
                bne po_itemnamenext
                jsr checkcollision
                bcc po_itemnamenext
                lda actf1,y
                cmp itemnamedisplay
                beq po_skipitemname
                sta itemnamedisplay
                jsr getitemname
                jsr printmsgcont
                jmp po_skipitemname
po_itemnamenext:inc itemsearch
                lda itemsearch
                cmp #ACTI_LASTITEM+1
                bcc po_itemnamenowrap
                lda #ACTI_FIRSTITEM
                sta itemsearch
                lda itemnamedisplay
                beq po_skipitemname
                jsr resetmessage
po_itemnamenowrap:
po_skipitemname:
                jsr checkjoydown                ;Check item use
                bne po_nouse
                ldy invselect
                ldx invtype,y
                lda itemammoweighttbl,x             ;Don't call the script for
                bpl po_nouse                    ;no reason
                lda #<SCRIPT_USEITEMS
                ldx #>SCRIPT_USEITEMS
                jsr execscript
po_nouse:       lda comradeagent
                beq po_nocomradeagent
                jsr findactor
                bcc po_nocomradeagent
                lda acthp,x                     ;Dead?
                beq po_nocomradeagent
                ldy ph_start+1
                bne po_comradearmorok
                jsr getactptr
                ldy #AD_DEFAULTBATT
                lda actbatt,x                   ;Armor at maximum?
                cmp (actlptrlo),y
                beq po_comradearmorok
                inc actbatt,x                   ;If not, increase slowly
po_comradearmorok:
                lda acthptime,x                 ;Make comrade agent auto-heal
                bne po_comradehealok            ;over time
                lda #1
                sta acthptime,x
                sta acthpdelta,x
po_comradehealok:
                lda actmode,x
                cmp #M_PATROL+1                 ;Don't interrupt if in combat
                bcs po_nocomradeagent
                lda #M_GOTO                     ;Follow player
                sta actmode,x
                lda #ACTI_PLAYER
                sta acttarget,x
po_nocomradeagent:
                ldy npcsearch                   ;for neartrigger search
                iny
                cpy #ACTI_LASTNPC+1
                bcc po_nonpcwrap
                ldy #ACTI_FIRSTNPC
po_nonpcwrap:   sty npcsearch
                jsr checkfornpc
                bcs po_npcnext
                tya                             ;Invoke neartrigger now
                tax
                lda #T_NEAR
                jsr actortrigger
po_npcnext:     ldy lvlobjnum
                bmi po_trigdone
                lda lvlobjb,y
                and #$03
                cmp #OB_TRIGGERED               ;Trigger?
                bne po_trigdone
                ldx #ACTI_PLAYER
                tya
                jsr activateobject
po_trigdone:    lda adobjnum                    ;Autodeactivate: Any object?
                bmi po_addone
                dec adobjdelay                  ;Decrement delay
                bne po_addone
                jsr deactivateobject
                lda #$ff
                sta adobjnum
po_addone:      lda actmovectrl+ACTI_PLAYER     ;No activation etc. if moving
                and #JOY_LEFT|JOY_RIGHT
                bne po_resetcounter
                lda actctrl+ACTI_PLAYER
                and #JOY_FIRE|JOY_UP|JOY_DOWN|JOY_LEFT|JOY_RIGHT
                cmp #JOY_FIRE|JOY_UP
                bne po_resetcounter
                lda actcounter
                bmi po_nocounter
                inc actcounter
                ldy lvlobjnum
                bmi po_noobject                 ;Negative = no object at all
                lda lvlobjb,y
                and #$1c                        ;Mode NONE
                beq po_noobject
                lda lvlobjb,y                   ;Triggered object is of no
                and #$03                        ;interest :)
                cmp #OB_TRIGGERED
                beq po_noobject
                lda actcounter                  ;If counter = 1, try manual
                cmp #$02                        ;activation/deactivation
                bcs po_nomanual
                jsr checkformanual
                beq po_manualdone
                tya
                ldx #ACTI_PLAYER
                jsr activateobject
                bcc po_nocounter                ;No sound if failed
                jsr checkfordoor
                beq po_sounddoor
                cmp #$06*4                      ;No sound if scripted
                beq po_nosound
                bne po_soundok
po_sounddoor:   lda lvlobjy,y
                bpl po_nosound                  ;No sound if a door without
po_soundok:     lda #SFX_OBJECT                 ;animation (open hallways etc.)
                jsr playsfx
po_nosound:
po_nocounter:
po_manualdone:  rts
po_resetcounter:lda #$00
                sta actcounter
                rts
po_nomanual:    jsr checkfordoor                ;If counter > 1, try door entry
                bne po_nodoor
                tya
                jsr getlvlobjstat
                beq po_nodoor
                ldx #ACTI_PLAYER
                lda #-1                         ;Must be actual door chars
                jsr getcharposinfooffset        ;for door enter animation,
                and #CI_DOOR                    ;otherwise it's probably a
                beq po_sidedoor                 ;side door (no animation)
                jsr mh_setdoorframe
po_sidedoor2:   lda actcounter
                cmp #DOORENTERDELAY
                bcc po_doordone
                jmp enterdoor
po_sidedoor:    jsr getcharposinfo
                and #CI_DOOR
                bne po_sidedoor2
po_doordone:    rts
po_noobject:
po_nodoor:      lda actcounter                  ;Check for conversation
                cmp #CONVDELAY
                bne po_notalk
                ldy #ACTI_LASTNPC
po_talksearch:  jsr checkfornpc                 ;Go through all NPCs
                bcs po_talknext
                lda targetxdist              ;Must be facing player
                eor actd+ACTI_PLAYER
                and #$80
                bne po_talknext


                tya
                tax                             ;If there are multiple NPCs,
                lda #T_CONV                     ;all their conversations
                jsr actortrigger                ;will be triggered one after
                ldy actrestx                    ;another :)
po_talknext:    dey
                bne po_talksearch

po_notalk:      lda actcounter                  ;Check for dropping items
                cmp #DROPITEMDELAY
                bcc po_doordone
                jmp dropitem                    ;Try dropping

checkfordoor:   ldy lvlobjnum                   ;from level/zone to another)
                lda lvlobjb,y                   ;Active door can be entered
                and #$1c
                cmp #$01*4
cfd_done:       rts

checkformanual: ldy lvlobjnum
                lda lvlobjb,y                   ;Check activation bits
                and #$03
                beq cfm_done
                cmp #OB_TRIGGERED               ;1,2 valid values
edm_done:
cfm_done:       rts

checkfornpc:    ldx #ACTI_PLAYER
                lda actbits+ACTI_PLAYER         ;Fail if flying
                lsr
                bcs cfnpc_fail
                lda actt,y                      ;Exists?
                beq cfnpc_fail
                lda acthp,y                     ;Is alive?
                beq cfnpc_fail
                jsr gettargetdistance
                lda targetabsxdist              ;Must be near for
                cmp #MAX_CONV_XDIST
                bcs cfnpc_fail2                 ;conversation
                lda targetabsydist
                bne cfnpc_fail
                rts                             ;Carry 0=NPC OK for conv/
cfnpc_fail:     sec                             ;neartrigger
cfnpc_fail2:    rts

;-------------------------------------------------------------------------------
; ENTERDOOR
; ENTERDOORNUM
;
; Player door entry
;
; Parameters: AX: 16bit door number (ENTERDOORNUM only)
; Returns: -
; Modifies: A,X,Y,tempregs
;-------------------------------------------------------------------------------

enterdoornum:   sta ed_destdoor+1
                txa
                jmp ed_anylevel




enterdoor_map:  lda #PLOT_MAP_ALLOWED           ;Map entry allowed yet?
                jsr checkplotbit
                beq edm_done                    ;No
                lda ed_destdoor+1               ;Door lowbyte as script param.
                sta scriptparam
                lda #<SCRIPT_MAPSCREEN
                ldx #>SCRIPT_MAPSCREEN
                jmp execscript

enterdoor:      ldy lvlobjnum
                sty sourceobjnum
                lda lvlobjd1,y
                sta ed_destdoor+1
                lda lvlobjd2,y                  ;Check destination level
                bmi enterdoor_map
ed_anylevel:    pha
                jsr cleartextscreen             ;Clear textscreen now so that
                jsr removeallactors             ;current door closing not shown,
                pla
                cmp levelnum
                beq ed_samelevel
                and #$7f
                pha
                lda adobjnum                    ;If level change, must
                bmi ed_noautodeact              ;complete previous auto-
                jsr deactivateobject            ;deactivation
                lda #$ff
                sta adobjnum
ed_noautodeact: pla
                ldx #LLMODE_NORMAL
                jsr loadlevel
ed_samelevel:
ed_destdoor:    lda #$00                        ;Destination object
                sta aonum
                jsr getlvlobjstat
                bne ed_skipactivate             ;Activate destination if not
                lda aonum
                ldx #$01                        ;already active
                jsr activateobject
ed_skipactivate:ldy aonum                       ;And go there
                lda lvlobjx,y
                sta actxh+ACTI_PLAYER
                lda lvlobjy,y
                and #$7f
                clc
                adc #$01
                sta actyh+ACTI_PLAYER
                lda #$80
                sta actxl+ACTI_PLAYER
                lda #$00
                sta actyl+ACTI_PLAYER
                lda #PLRFR_STAND
                sta actf1+ACTI_PLAYER
                sta actf2+ACTI_PLAYER
                jsr getplayerzone
                ldx #ACTI_PLAYER
                lda #-3
                sta temp1
ed_checkgroundhigher:
                lda temp1
                jsr getcharposinfooffset
                lsr
                bcs ed_cghfound
                inc temp1
                bne ed_checkgroundhigher
                beq ed_cghnotfound
ed_cghfound:    lda #-8*8
                jsr moveactorydirect
                inc temp1
                bne ed_cghfound
ed_cghnotfound:
                ldx levelnum
                stx temp7
                lda comradeagent                ;If comradeagent, transport
                beq ed_nocomradeagent           ;near player
                ldx actxh+ACTI_PLAYER
                ldy actyh+ACTI_PLAYER
                jsr transportactor
ed_nocomradeagent:
                jsr playzonetune                ;Play zonemusic
                jsr centerplayer                ;Center & display player
                jmp dropitem_done               ;Reset activation-counter

;-------------------------------------------------------------------------------
; ADDALLACTORS
;
; Adds all leveldata actors
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,tempregs
;-------------------------------------------------------------------------------

addallactors:   jsr addact_reset
aaa_loop:       jsr addactors
                lda lvlactptrhi                 ;Wait until pointer wraps
                cmp #>lvlactarea
                bne aaa_loop
aaa_not:        rts

;-------------------------------------------------------------------------------
; ADDACTORS
;
; Adds leveldata actors
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,tempregs
;-------------------------------------------------------------------------------

addactors:      lda scrollsx
                cmp #-1*8                       ;Use wider area whenever
                lda mapx                        ;screen scrolls
                sbc #ADDACTOR_LEFT_LIMIT
                bcs addact_ok1
                lda #$00
addact_ok1:     cmp limitl
                bcs addact_ok1b
                lda limitl
addact_ok1b:    sta addact_leftlimit+1          ;Left border
                sta rmcheck_leftlimit+1
                lda scrollsx
                cmp #1*8+1
                lda mapx
                adc #ADDACTOR_RIGHT_LIMIT
                bcc addact_ok2
                lda #$ff
addact_ok2:     cmp limitr
                bcc addact_ok2b
                lda limitr
addact_ok2b:    sta addact_rightlimit+1         ;Right border
                sta rmcheck_rightlimit+1
                lda scrollsy
                cmp #-1*8
                lda mapy
                sbc #ADDACTOR_TOP_LIMIT
                bcs addact_ok3
                lda #$00
addact_ok3:     cmp limitu
                bcs addact_ok3b
                lda limitu
addact_ok3b:    sta addact_toplimit+1           ;Top border
                sta rmcheck_toplimit+1
                lda scrollsy
                cmp #1*8+1
                lda mapy
                adc #ADDACTOR_BOTTOM_LIMIT
                bpl addact_ok4
                lda #$7f
addact_ok4:     cmp limitd
                bcc addact_ok4b
                lda limitd
addact_ok4b:    sta addact_bottomlimit+1        ;Bottom border
                sta rmcheck_bottomlimit+1
                lda levelnum
                sta addact_lvlcheck+1

addactors_again2:
                ldy #LA_LEVEL
addact_loop:    lda (lvlactptrlo),y             ;Check level
                and #$7f                        ;Mask purgeable bit away
addact_lvlcheck:cmp #$00
                bne addact_next
                iny
                lda (lvlactptrlo),y             ;Check X
addact_leftlimit:
                cmp #$00
                bcc addact_next2
addact_rightlimit:
                cmp #$00
                bcs addact_next2
                iny
                lda (lvlactptrlo),y             ;Check Y
addact_toplimit:
                cmp #$00
                bcc addact_next2
addact_bottomlimit:
                cmp #$00
                bcs addact_next2
                jsr addact_withexec
addact_next2:   ldy #LA_LEVEL
addact_next:    lda lvlactptrlo
                clc
                adc #LA_NEXT
                sta lvlactptrlo
                bcc addact_loop
addact_inchi:   inc lvlactptrhi                 ;Stop when highbyte changes
                lda lvlactptrhi                 ;Test for wraparound
                cmp #>lvlactareaend
                bcc addact_nowrap
addact_reset:   lda #<lvlactarea
                sta lvlactptrlo
                lda #>lvlactarea
                sta lvlactptrhi
addact_nowrap:  rts

addact_withexec:jsr addact_sub
                bcc addact_nowrap
                jsr getactptr
                jmp mvact_sub                   ;Execute one frame of AI &
                                                ;movement

addact_gotonext:
                lda lvlactptrlo
                clc
                adc #LA_NEXT
                sta lvlactptrlo
                bcc addact_nowrap
                bcs addact_inchi

addact_checklevel:
                ldy #LA_LEVEL
                lda (lvlactptrlo),y
                and #$7f
                cmp levelnum
addact_fail2:   rts

addact_sub:     ldy #LA_TYPE
                lda (lvlactptrlo),y             ;Zero type shouldn't be
                beq addact_nowrap               ;possible, but test anyway
                bpl addact_actor
                jmp addact_item
addact_actor:   lda #ACTI_LASTNPC
                ldy #ACTI_FIRSTNPC
                jsr getfreeactor
                bcc addact_fail2
                tya
                tax
                ldy #LA_TYPE
                lda (lvlactptrlo),y
                sta actt,x                      ;Type
                jsr addact_pos
                jsr initcomplexactor
                ldy #LA_DATA
                lda (lvlactptrlo),y             ;Highbit = direction
                sta actd,x
                and #$7f                        ;Weapon
                sta actwpn,x
                tay
                lda itemmaxtbl,y                ;Load NPC weapon fully
                sta actclip,x
                ldy #LA_FINE
                lda (lvlactptrlo),y             ;Get actor mode
                lsr
                lsr
                lsr
                lsr
                cmp #14
                bcc addact_notdead
                cmp #15                         ;14=unconscious
                lda #$00                        ;15=dead
                sta acthp,x
                sta actgrp,x                    ;Bodies can't be shot
                ror
                sta actlastdmghp,x              ;Set dead/unconscious flag
                jmp addact_modedone             ;Done!
addact_notdead: cmp #M_PATROL
                bne addact_nopatrol
                pha                             ;If levelalert > 0, PATROL
                lda levelalert                  ;turns into ALERT mode
                cmp #$01                        ;(scan for enemies upon
                pla                             ;appearing)
                adc #$00
addact_nopatrol:sta actmode,x
addact_modedone:
                lda actt,x                      ;Typically, the purpose of
                cmp comradeagent                ;a comradeagent's appear-trigger
                beq addact_done                 ;is to reinit comrade status.
                                                ;This can be skipped to
                                                ;reduce disk thrashing

                lda #T_APPEAR                   ;Execute APPEAR trigger now
                jsr actortrigger

addact_done:    ldy #LA_LEVEL                   ;Store purgeable flag
                lda (lvlactptrlo),y
                and #$80
                sta actpurgeable,x
                lda #$7f
                sta (lvlactptrlo),y             ;Mark as removed
                ldy #LA_TYPE
                lda #$00
                sta (lvlactptrlo),y
                sec                             ;Successful add
addact_fail:    rts

addact_item:    lda #ACTI_LASTITEM
                ldy #ACTI_FIRSTITEM
                jsr getfreeactor
                bcc addact_fail
                tya
                tax
                lda #ACT_ITEM
                sta actt,x
                ldy #LA_TYPE
                lda (lvlactptrlo),y
                and #$7f
                sta actf1,x                     ;Item type
                ldy #LA_DATA                    ;Item pickup amount
                lda (lvlactptrlo),y
                cmp #$ff                        ;$ff=use default
                bne addact_itemaddok
                ldy actf1,x
                lda itemaddtbl,y
addact_itemaddok:
                sta acthp,x
                jsr addact_pos
                jmp addact_done

addact_pos:     ldy #LA_X
                lda (lvlactptrlo),y
                sta actxh,x
                ldy #LA_Y
                lda (lvlactptrlo),y
                sta actyh,x
                ldy #LA_FINE
                lda (lvlactptrlo),y
                ror
                ror
                ror
                and #$c0
                sta actxl,x
                lda (lvlactptrlo),y
                asl
                asl
                asl
                asl
                and #$c0
                sta actyl,x
                rts

;-------------------------------------------------------------------------------
; REMOVECHECK
;
; Check for removing an actor back to leveldata (going off-screen)
; Note: this is meant to be called from actor move subroutine, it pops 2 bytes
; off stack if the actor is removed!
;
; Parameters: X:Actor number
; Returns: If actor removed it doesn't return at all
; Modifies: A,X,Y,tempregs
;-------------------------------------------------------------------------------

removecheck:    lda actxh,x
rmcheck_leftlimit:
                cmp #$00
                bcc rmcheck_ok
rmcheck_rightlimit:
                cmp #$00
                bcs rmcheck_ok
                lda actyh,x
rmcheck_toplimit:
                cmp #$00
                bcc rmcheck_ok
rmcheck_bottomlimit:
                cmp #$00
                bcs rmcheck_ok
rla_noactor:    rts
rmcheck_ok:     pla
                pla
                jmp removelevelactor

;-------------------------------------------------------------------------------
; REMOVEACTOR
; REMOVELEVELACTOR
;
; Removes current actor "properly"
; REMOVELEVELACTOR puts actor back to leveldata.
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y,temp1-temp4
;-------------------------------------------------------------------------------

removelevelactor:
                lda actt,x
                beq rla_noactor
                cpx #ACTI_LASTLEVELDATA+1
                bcs removeactor
                lda actlvlptrlo,x
                sta temp1
                lda actlvlptrhi,x
                sta temp2
                lda #(NUMLVLACT*6)/256+1
                sta temp3
                lda #$f0
                sta rla_opcode
                ldy #LA_LEVEL
rla_search:     lda (temp1),y                   ;Search for free actor, start
                cmp #$7f                        ;from original pos (BEQ, search
rla_opcode:     beq rla_found                   ;for levelnum $7f)
                lda temp1
                clc
                adc #LA_NEXT
                sta temp1
                bcc rla_search
                dec temp3
                bne rla_nomodify
                lda #$b0                        ;If going round & round,
                sta rla_opcode                  ;allow any purgeable actor
rla_nomodify:   inc temp2                       ;to be overwritten (BCS, levelnum
                lda temp2                       ;>= $7f)
                cmp #>lvlactareaend
                bcc rla_search
                lda #<lvlactarea
                sta temp1
                lda #>lvlactarea
                sta temp2
                bne rla_search
rla_found:      jsr rla_sub
rla_common:     sta temp3
rla_posfine:    lda actxl,x
                lsr
                lsr
                sta temp4
                lda actyl,x
                and #$c0
                ora temp4
                lsr
                lsr
                lsr
                lsr
                ora temp3
                ldy #LA_FINE
                sta (temp1),y
removeactor:    lda #ACT_NONE
                sta actt,x
                sta actdb,x                     ;Make sure there's no
                sta actgrp,x
                rts                             ;incorrect interpolation

rla_sub:        ldy #LA_LEVEL                   ;Level, X-high, Y-high
                lda levelnum
                ora actpurgeable,x              ;Merge purgeable bit
                sta (temp1),y
                iny
                lda actxh,x
                sta (temp1),y
                iny
                lda actyh,x
                sta (temp1),y
                ldy #LA_TYPE
                lda actt,x                      ;Item?
                cmp #ACT_ITEM
                beq rla_item
                sta (temp1),y                   ;Type

                lda #T_REMOVE                   ;Remove trigger
                jsr actortrigger

                lda actd,x                      ;Merge with direction
                and #$80
                ora actwpn,x
                ldy #LA_DATA
                sta (temp1),y
                lda acthp,x                     ;Dead?
                bne rla_alive
                lda actlastdmghp,x
                asl
                lda #14
                adc #$00
                bne rla_modeready2
rla_alive:      lda actmode,x                   ;Transform COMBAT into PATROL
                cmp #M_COMBAT                   ;mode
                bne rla_modeready1
                lda #M_PATROL
rla_modeready1: cmp #M_SPAR                     ;Transform SPAR into SPARSEARCH
                bne rla_modeready2
                lda #M_SPARSEARCH
rla_modeready2: asl
                asl
                asl
                asl
                rts

rla_item:       lda actf1,x
                ora #$80
                sta (temp1),y                   ;Type (with high bit set)
                ldy #LA_DATA
                lda acthp,x                     ;Pickup amount
                cmp #$ff                        ;255 means default so
                bcc rla_itemok                  ;must be changed to 254
                sbc #$01
rla_itemok:     sta (temp1),y
                lda #$00
                rts

;-------------------------------------------------------------------------------
; REMOVEALLACTORS
;
; Removes all actors (except player), returning them to leveldata.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

removeallactors:ldx #NUMACT-1
raa_loop:       lda actt,x
                beq raa_skip
                jsr removelevelactor
raa_skip:       dex
                bne raa_loop
                                                ;Reset big explosion
                stx bigexplcount
                rts

;-------------------------------------------------------------------------------
; FINDACTORTYPE
;
; Finds an actor with certain type from either onscreen or from leveldata
; (forced addition) Possibly very slow!
;
; Parameters: A:Type
;             X:Identification byte (weapon)
; Returns: C=1, actornumber in X if successful
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

findactortype:  sta fat_cmp1a+1
                sta fat_cmp1b+1
                stx fat_cmp2a+1
                stx fat_cmp2b+1
                jsr fat_findonscreen
                bcs fat_success
                jsr addact_reset
fat_loop:       jsr addact_checklevel
                bne fat_next
                ldy #LA_TYPE
                lda (lvlactptrlo),y
fat_cmp1a:      cmp #$00
                bne fat_next
                iny
                lda (lvlactptrlo),y
                and #$7f
fat_cmp2a:      cmp #$00
                beq fat_found
fat_next:       jsr addact_gotonext
                bcc fat_loop
fat_fail:       clc
fat_success:    rts

fat_found:      jsr addact_sub
                bcc fat_fail
fat_findonscreen:
                ldx #NUMCOMPLEXACT-1
fat_fosloop:    lda actt,x
fat_cmp1b:      cmp #$00
                bne fat_fosnext
                lda actwpn,x
fat_cmp2b:      cmp #$00
                beq fat_success
fat_fosnext:    dex
                bpl fat_fosloop
                bmi fat_fail

;-------------------------------------------------------------------------------
; TRANSPORTACTOR
;
; Transports an actor to another place.
;
; Parameters: A:Type
;             X:New X coord high
;             Y:New Y coord high
;             temp7:New level
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

transportactor: stx temp5
                sty temp6
                sta ta_cmp+1
                jsr findactor
                bcc ta_notonscreen
                jsr removelevelactor
ta_notonscreen: jsr addact_reset
ta_loop:        ldy #LA_TYPE
                lda (lvlactptrlo),y
ta_cmp:         cmp #$00
                beq ta_found
                jsr addact_gotonext
                bcc ta_loop
                rts                             ;C=1 not found
ta_found:       ldy #LA_FINE                    ;Do not move dead/unconscious
                lda (lvlactptrlo),y
                cmp #14*16
                bcs ta_skip                     ;C=1 not ok
                and #$f0                        ;Center fine pos.
                ora #$02
                sta (lvlactptrlo),y
                ldy #LA_LEVEL
                lda temp7
                sta (lvlactptrlo),y             ;New level
                iny
                lda temp5
                sta (lvlactptrlo),y             ;X
                iny
                lda temp6
                sta (lvlactptrlo),y             ;Y
                                                ;C=0 ok
ta_skip:        rts

;-------------------------------------------------------------------------------
; FINDACTORXY
;
; Finds an actor with certain X,Y from leveldata. Possibly very slow!
;
; Parameters: A:Y coordinate
;             X:X coordinate
; Returns: C=1 if successful (lvlactptr contains address)
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

findactorxy:    sta faxy_cmp2+1
                stx faxy_cmp1+1
                jsr addact_reset
faxy_loop:      jsr addact_checklevel
                bne faxy_next
                iny
                lda (lvlactptrlo),y                     ;Check X
faxy_cmp1:      cmp #$00
                bne faxy_next
                iny
                lda (lvlactptrlo),y                     ;Check Y
faxy_cmp2:      cmp #$00
                beq faxy_found                          ;Equal -> carry=1
faxy_next:      jsr addact_gotonext
                bcc faxy_loop
faxy_fail:      clc
faxy_found:     rts

