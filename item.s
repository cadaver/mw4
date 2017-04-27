TEXTJUMP        = $80

AMMO_NONE       = $00                           ;Special ammo definitions
AMMO_INFINITE   = $80

MENU_ACTIVE     = $01
MENU_NOTACTIVE  = $00

PANEL_ROWS      = 2                             ;Dimensions of the statuspanel
PANEL_COLUMNS   = 40

MENU_DELAY      = 15                            ;How many 1/25ths of seconds
                                                ;the firebutton must be held
                                                ;down for the menu
MENU_MOVEDELAY  = 2

MM_INVENTORY    = 0
MM_GAMEMENU     = 1
MM_STATUS       = 2


HEALTHBAR_LENGTH = 6

UPD_ITEM        = 1                             ;Panelupdate bits
UPD_AMMO        = 2
UPD_SCORE       = 4

MSG_PICKEDUP    = 0
MSG_REQUIRED    = 1
MSG_FILEERROR   = 2
MSG_FIRSTITEMNAME = 3

MSGTIME         = 50                            ;2 seconds
MSGTIME_ETERNAL = $ff

PAUSE_OFF       = 0
PAUSE_ON        = 1                             ;Achieved with Runstop
PAUSE_MENU      = 2                             ;Inventory screen
PAUSE_STATUS    = 3                             ;Status screen

;-------------------------------------------------------------------------------
; ADDSCORE
;
; Adds score to player.
;
; Parameters: A:Lowbyte
;             Y:Highbyte
; Returns: -
; Modifies: A
;-------------------------------------------------------------------------------

addscore:       clc
                adc score
                sta score
                tya
                adc score+1
                sta score+1
                bcc setscoreupdate
                inc score+2
setscoreupdate: lda #UPD_SCORE
setupdate:      ora panelupdateflag
                sta panelupdateflag
                rts
;-------------------------------------------------------------------------------
; SORTUPDATEINV
; UPDATEINVENTORY
;
; Update inventory (with & without sorting)
;
; Parameters: -
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

sortupdateinv:  jsr sortinventory
updateinventory:
setitemupdate:  lda #UPD_ITEM|UPD_AMMO
                bne setupdate



;-------------------------------------------------------------------------------
; CALCWEIGHT
;
; Calculates weight of all items carried by player
;
; Parameters: -
; Returns: -
; Modifies: A,Y,tempadr,alo-ahi
;-------------------------------------------------------------------------------

calcweight:     stx tempadrhi
                lda #$00
                sta carrylo
                sta carryhi
                ldy #INVENTORYSIZE-1
cw_loop:        ldx invtype,y
                beq cw_next
                lda itemweighttbl,x
                sta alo
                lda #$00
                sta ahi
                lda #$07
                jsr cw_multiplyadd
                lda invcountlo,y
                sta alo
                lda invcounthi,y
                sta ahi
                lda itemammoweighttbl,x
                and #$7f
                beq cw_next
                jsr cw_multiplyadd
cw_next:        dey
                bpl cw_loop
                ldx tempadrhi
                rts

cw_multiplyadd: sta tempadrlo
cw_maloop:      asl alo
                rol ahi
                dec tempadrlo
                bne cw_maloop
                lda carrylo
                adc alo
                sta carrylo
                lda carryhi
                adc ahi
                sta carryhi
                rts

;-------------------------------------------------------------------------------
; DROPITEM
;
; Tries to drop the current item
;
; Parameters: -
; Returns: -
; Modifies: A,Y,temp1-temp4
;-------------------------------------------------------------------------------

dropitem:       jsr updateinventory
                lda #ACTI_LASTITEM              ;Try to get free actor
                ldy #ACTI_FIRSTITEM
                jsr getfreeactor
                bcc dropitem_done
                sty dropitem_actornum+1

                lda levelnum                    ;Can't drop anything in Sentinel
                cmp #24                         ;level (can't return there)
                beq dropitem_done

                ldy invselect
                lda invtype,y                   ;Empty item & fists
                cmp #ITEM_FISTS+1               ;can't be dropped
                bcc dropitem_done

                tax
                lda itemammotbl,x               ;Has ammo?
                bmi dropitem_noammo
                beq dropitem_noammo
                tax
                lda invcountlo,y
                beq dropitem_noammo
                pha
                lda #$00                        ;Put ammo back to inventory
                sta invcountlo,y
                pla
                jsr additem
dropitem_noammo:
                ldy invselect
                lda invtype,y
                sta temp2
                lda invcountlo,y
                sta temp3
                lda invcounthi,y
                sta temp4

dropitem_actornum:ldy #$00
                ldx #ACTI_PLAYER
                lda #ACT_ITEM
                jsr spawnactor
                lda #-15*8                      ;Let the item fall from air
                jsr spawnymod
                lda temp2
                sta actf1,y                     ;Store item type
                cmp #ITEM_FIRST_NOTPURGEABLE    ;Guns, ammo etc. are purgeable
                bcs dropitem_notpurgeable
                lda #$80
                sta actpurgeable,y
dropitem_notpurgeable:
                lda temp4
                beq dropitem_nomsb
                lda #$ff                        ;If highbyte, "truncate" to 255
                bne dropitem_amountok           ;(nasty :))
dropitem_nomsb: lda temp3
dropitem_amountok:
                sta acthp,y                     ;Store item amount
                ldy invselect
                jsr decammo_remove              ;Remove the item now
                lda #$00
                sta actreload+ACTI_PLAYER       ;Cancel any reloading

dropitem_done:  lda #$ff                        ;Make counter negative
                sta actcounter                  ;(no further drop/activate etc.
                rts                             ;stuff until FIRE+UP released)

;-------------------------------------------------------------------------------
; FINDITEM
;
; Tries to find an item of certain type from the player's inventory
;
; Parameters: A:Item type
; Returns: C=1 item found (Y:Inventory index), C=0 not found (A also 0)
; Modifies: Y
;-------------------------------------------------------------------------------

finditem:       ldy #INVENTORYSIZE-1
fi_loop:        cmp invtype,y
                beq fi_found                    ;Carry=1
                dey
                bpl fi_loop
                clc
                lda #$00
fi_found:       rts

;-------------------------------------------------------------------------------
; SORTINVENTORY
;
; Sorts items to ascending order. Uses horrible bubblesort :-)
;
; Parameters: -
; Returns: -
; Modifies: A
;-------------------------------------------------------------------------------

sortinventory:  stx maptemp1
                sty maptemp2
                ldx #$00
sortinvloop1:   lda invtype+1,x                 ;When outer loop reaches the
                bne sortinvnotdone              ;end, we're done
                stx invsize                     ;Store inventory length
sortinvrestx:   ldx maptemp1
sortinvresty:   ldy maptemp2
                rts
sortinvnotdone: txa
                tay                             ;Inner loop begins one row
                iny                             ;lower
sortinvloop2:   lda invtype,y
                beq sortinvinnerend
                cmp invtype,x
                bcc sortinvswap
sortinvswapdone:iny
                bne sortinvloop2
sortinvinnerend:inx
                bne sortinvloop1

sortinvswap:    cpx invselect                   ;If currently selected
                bne sortinvnosswap1             ;item must be swapped we
                sty invselect                   ;follow it
                beq sortinvsswap
sortinvnosswap1:cpy invselect
                bne sortinvnosswap2
                stx invselect
sortinvsswap:
sortinvnosswap2:lda invtype,x
                pha
                lda invtype,y
                sta invtype,x
                pla
                sta invtype,y
                lda invcountlo,x
                pha
                lda invcountlo,y
                sta invcountlo,x
                pla
                sta invcountlo,y
                lda invcounthi,x
                pha
                lda invcounthi,y
                sta invcounthi,x
                pla
                sta invcounthi,y
                jmp sortinvswapdone


;-------------------------------------------------------------------------------
; ADDAMMO
;
; Adds ammo to item
;
; Parameters: A:Amount to add
;             Y:Inventory index
; Returns: A:Amount that was really added
; Modifies: A,Y,temp1-temp3
;-------------------------------------------------------------------------------

addammo:        sta temp1
                stx temp3
                ldx invtype,y
                lda itemmaxtbl,x
                sec
                sbc invcountlo,y
                sta temp2                       ;How much we can add
               ; lda itemmaxtbl,x                ;If max = 255, we can add
               ; cmp #$ff                        ;infinitely (only weight is the
               ; beq addammo_all                 ;limit)
                lda temp2
                cmp temp1
                bcs addammo_all
                sta temp1
addammo_all:    lda invcountlo,y
                clc
                adc temp1
                sta invcountlo,y
              ;  lda invcounthi,y
              ;  adc #$00
              ;  sta invcounthi,y
                ldx temp3
                jsr updateinventory
                lda temp1
                rts

;-------------------------------------------------------------------------------
; REMOVEITEM
;
; Removes an item from inventory
;
; Parameters: A:Item number
; Returns: C=1 success, C=0 failure (item didn't exist)
; Modifies: A,Y,temp1
;-------------------------------------------------------------------------------

removeitem:     jsr finditem
                bcc ri_done
                jsr decammo_remove
                sec
ri_done:        rts

;-------------------------------------------------------------------------------
; DECREASEITEM
;
; Decreases ammo of certain item
;
; Parameters: A:Amount of decrease
;             Y:Item type
; Returns: -
; Modifies: A,Y (if item must be removed),temp1
;-------------------------------------------------------------------------------

decreaseitem:   sta di_amount+1
                tya
                jsr finditem
                bcc ri_done
di_amount:      lda #$00

;-------------------------------------------------------------------------------
; DECREASEAMMO
;
; Decreases ammo of item
;
; Parameters: A:Amount of decrease
;             Y:Inventory index
; Returns: -
; Modifies: A,Y (if item must be removed),temp1
;-------------------------------------------------------------------------------

decreaseammo:   sta temp1
                lda invcountlo,y
                sec
                sbc temp1
                sta invcountlo,y
                lda invcounthi,y
                sbc #$00
                sta invcounthi,y
decammo_notover:ora invcountlo,y
                bne decammo_notzero
                stx maptemp1
                ldx invtype,y
                lda itemammotbl,x
decammo_restx:  ldx maptemp1                    ;If item has ammo that is
                cmp #$00                        ;different type, do not remove
                bne decammo_dontremove          ;(can be reloaded)

decammo_remove: sty temp1
rmitem_loop:    lda invtype+1,y
                sta invtype,y
                lda invcountlo+1,y
                sta invcountlo,y
                lda invcounthi+1,y
                sta invcounthi,y
                iny
                cpy #INVENTORYSIZE
                bcc rmitem_loop
                ldy temp1
                cpy invselect                   ;Is it the selected item?
                beq decammo_selected
                bcs decammo_notselected
decammo_selected:
                lda invselect
                beq decammo_notselected
                dec invselect
decammo_notselected:
                jmp sortupdateinv
decammo_dontremove:
decammo_notzero:
                jmp updateinventory

;-------------------------------------------------------------------------------
; CHECKPICKUP
;
; Checks for player picking up items. Will pick only one at a time.
;
; Parameters: X:Player actor number
; Returns: -
; Modifies: A,Y,temp1-temp7
;-------------------------------------------------------------------------------

checkpickup:    stx actrestx
                ldy #ACTI_FIRSTITEM
cpu_loop:       sty actresty
                lda actt,y              ;This really is an item?
                cmp #ACT_ITEM
                beq cpu_righttype
cpu_next:       ldx actrestx
                ldy actresty
                iny                     ;Go to next item until all checked
                cpy #ACTI_LASTITEM+1
                bcc cpu_loop
                rts

cpu_righttype:  jsr checkcollision
                bcc cpu_next            ;No collision
                sty actresty            ;Store Y
                ldx actf1,y             ;Get item type
                lda acthp,y             ;Get item amount
                jsr additem
                bcc cpu_next            ;Pickup failed (inventory full)
cpu_pickedup:   stx cpu_itemnum+1
                lda #MSG_PICKEDUP       ;Print the "picked up..." text
                ldy #MSGTIME
                jsr printmsg
                lda #SFX_PICKUP
                jsr playsfx
                ldy actresty
                lda #ACT_NONE           ;Remove item from ground
                sta actt,y
cpu_itemnum:    lda #$00
                jsr getitemname
                jsr ptw_continue        ;Continue the message with item name
                ldx actrestx
                rts

;-------------------------------------------------------------------------------
; ADDITEM
;
; Adds an item to player inventory
;
; Parameters: A: Amount
;             X: Item type
; Returns: C=1 Add successful, C=0 inventory full or max.amount carried
;          X: Real type of item added
; Modifies: A,Y,temp1-temp2
;-------------------------------------------------------------------------------

additem:        stx temp1
                sta temp2
                ldy #$00                ;Search empty space or same item from
ai_search:      lda invtype,y           ;inventory
                beq ai_found
                cmp temp1
                beq ai_sameitem
                iny
                cpy #INVENTORYSIZE
                bcc ai_search
ai_notok:       clc                     ;Inventory full
                rts
ai_found:       jsr ai_backup
                txa
                sta invtype,y
                lda temp2
                sta invcountlo,y
                lda #$00
                sta invcounthi,y
                jmp ai_ok
ai_noammo2:     lda itemmaxtbl,x
                cmp #$ff
                beq ai_nolimit
                cmp temp2
                bcc ai_limit
ai_nolimit:     lda temp2
ai_limit:       sta invcountlo,y
ai_ok:          jsr calcweight
                lda carryhi
                cmp carrymax
                bcc ai_weightok
                jsr ai_restore                  ;Weight limit
ai_zeroammo:    clc
                rts
ai_weightok:    jsr sortupdateinv
                ldx temp1
                sec                     ;Add succeeded
                rts
ai_sameitem:    jsr ai_backup
                lda itemammotbl,x       ;Does the item have ammo (like a pistol
                beq ai_noammo           ;etc.)
                bmi ai_noammo           ;Infinite ammo?
ai_sameitemammo:tax
                lda temp2               ;Then add to the ammo storage instead
                beq ai_zeroammo
                jmp additem
ai_noammo:      jsr ai_checkmax
                bcc ai_notfull
ai_cmok:        clc                     ;Max.amount already
                rts
ai_notfull:     lda invcountlo,y
                clc
                adc temp2
                sta invcountlo,y
                lda invcounthi,y
                adc #$00
                sta invcounthi,y
                jsr ai_checkmax
                bcc ai_ok
                lda itemmaxtbl,x
                sta invcountlo,y
                lda #$00
                sta invcounthi,y
                jmp ai_ok

ai_checkmax:    lda itemmaxtbl,x
                cmp #$ff
                beq ai_cmok
                lda invcounthi,y
                cmp #$01
                bcc ai_checkmaxlo
                rts
ai_checkmaxlo:  lda invcountlo,y
                cmp itemmaxtbl,x
                rts

ai_backup:      sty ai_restore+1
                lda invtype,y
                sta ai_restoretype+1
                lda invcountlo,y
                sta ai_restorecountlo+1
                lda invcounthi,y
                sta ai_restorecounthi+1
                rts

ai_restore:     ldy #$00
ai_restoretype: lda #$00
                sta invtype,y
ai_restorecountlo:
                lda #$00
                sta invcountlo,y
ai_restorecounthi:
                lda #$00
                sta invcounthi,y
                jmp calcweight


;-------------------------------------------------------------------------------
; UPDATEPANEL
;
; Draws changes in the score panel.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,temp1-7
;-------------------------------------------------------------------------------

updatepanel:    lda panelupdateflag
                and #UPD_SCORE
                beq up_noscore
                ldx #$02
up_copyscore:   lda score,x
                sta temp1,x
                dex
                bpl up_copyscore
                jsr convert24bits
                ldx #1
                lda temp7
                jsr printbcddigit
                lda temp6
                jsr printbcddigits
                lda temp5
                jsr printbcddigits
                lda temp4
                jsr printbcddigits
up_noscore:     lda #HEALTHBAR_LENGTH
                sta dhb_nohalf+1
                ldx #32
                lda acthp+ACTI_PLAYER
                cmp plrprevhp
                beq up_nohealth
                sta plrprevhp
                jsr drawhealthbar
up_nohealth:
up_healthdone:  ldx #72
                lda actbatt+ACTI_PLAYER
                cmp plrprevbatt
                beq up_nobattery
                sta plrprevbatt
                jsr drawhealthbar
up_nobattery:
up_batterydone: lda panelupdateflag
                and #UPD_ITEM
                beq up_skipitem
                ldx invselect
                ldy invtype,x                   ;Take selected item
                lda actd_item+ADS_FRAMES,y      ;Take associated spriteframe
                tax
                lda dspr_adrlo,x                ;Draw 2 slices from the
                sta alo                         ;packed itemsprite
                lda dspr_adrhi,x
                sta ahi
                lda dspr_mask,x
                lsr
                sta temp3
                ldx #$00
                ldy #$00
                jsr up_charsprslice
                inx
                lsr temp3
                jsr up_charsprslice
                ldy #40                         ;Draw the item onscreen
                sty textscreen+22*40+1
                iny
                sty textscreen+22*40+2

up_skipitem:    lda panelupdateflag
                and #UPD_AMMO
                bne up_doammo
                jmp up_skipammo
up_doammo:      ldy invselect
                ldx invtype,y
                lda itemammotbl,x               ;Take ammo type
                bmi up_ammoinfinite
                beq up_ammodirect
up_ammoclip:    ldy itemmaxtbl,x                ;Clip size
                sty temp3
                jsr finditem                    ;Try to find ammo item
                bcc up_noclips
                lda temp3                       ;Take ammo remaining,
                sbc #$01                        ;add clipsize-1
                clc
                adc invcountlo,y
                sta temp1
                lda invcounthi,y
                adc #$00
                sta temp2
up_ammopredivide:                               ;Pre-divide until ammo fits
                lda temp2                       ;in 8 bits
                beq up_apddone
                lsr temp3
                bcc up_apdskip
                inc temp3
up_apdskip:     lsr temp2
                ror temp1
                jmp up_ammopredivide
up_apddone:     lda temp1
                ldy temp3
                ldx #temp1
                jsr divu                        ;Divide ammo by clip size
                lda temp1
up_noclips:     sta temp3
                jsr convert8bits
                ldx #46
                lda temp4
                jsr printbcddigits
                ldy invselect                   ;Ammo remaining in gun
                lda invcountlo,y
                sta temp3
                jsr convert8bits
                ldx #43                         ;Print the ammo
                lda temp4
                jsr printbcddigits
                lda #"/"
                sta textscreen+22*40+5
                jmp up_skipammo

up_ammodirect:  lda invcountlo,y
                sta temp2
                lda invcounthi,y
                sta temp3
                jsr convert16bits
                ldx #45                         ;Print the ammo
                lda temp5
                jsr printbcddigit
                lda temp4
                jsr printbcddigits
                jmp up_skipammo2
up_ammoinfinite:lda #<infammotext
                ldy #>infammotext
                ldx #45
                jsr printpaneltext
up_skipammo2:   lda #" "
                sta textscreen+22*40+3
                sta textscreen+22*40+4
up_skipammo:    lda #$00
                sta panelupdateflag
up_messages:    lda msgtime
                bne up_domessages
                lda msgcont
                beq up_nomsgcont
                jsr printmsgcont
up_msgtimereload:
                lda #$00
                sta msgtime
                rts
up_domessages:  cmp #$ff
                sbc #$00
                bne up_noclear
                jsr cleartextwindow
                lda #$00
up_noclear:     sta msgtime
up_nomessages:
up_nomsgcont:   rts

up_charsprslice:lda #$07
                sta temp1
upcss_full:     lda #$00
                bcc upcss_empty
                lda (alo),y
                iny
upcss_empty:    sta textchars+40*8+1,x
                inx
                dec temp1
                bne upcss_full
                rts


;-------------------------------------------------------------------------------
; DRAWHEALTHBAR
;
; Draws a health bar to the text panel.
;
; Parameters: A:Health (0-48)
;             X:Offset in the text panel
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

drawhealthbar:  inx
drawhealthbar2: cmp #HP_INVINCIBLE
                bcc dhb_notinvincible
                clc
                lda #48
dhb_notinvincible:
                adc #$03
                lsr
                lsr
                lsr
                sta temp1
                tay                                 ;Amount of full chars
                beq dhb_nofull
                lda #42
                jsr dhb_sub
dhb_nofull:     bcc dhb_nohalf
                lda #43
                sta textscreen+21*40,x
                inx
                inc temp1
dhb_nohalf:     lda #HEALTHBAR_LENGTH               ;Fill rest with space
                sec
                sbc temp1
                tay
                beq dhb_noempty
                lda #32
dhb_sub:        sta textscreen+21*40,x
                inx
                dey
                bne dhb_sub
dhb_noempty:    rts

;-------------------------------------------------------------------------------
; CONVERT8BITS
; CONVERT16BITS
; CONVERT24BITS
;
; Converts a binary number to BCD.
;
; Parameters: temp1-temp3: binary number (24bits)
;             temp2-temp3 (16bits)
;             temp3 (8bits)
; Returns: temp4-temp7: BCD number
; Modifies: A,X
;-------------------------------------------------------------------------------

convert8bits:   ldx #8
                bne convert_common

convert16bits:  ldx #16
                bne convert_common

convert24bits:  ldx #24
convert_common: sed
                lda #$00
                sta temp4
                sta temp5
                sta temp6
                sta temp7
c24b_loop:      asl temp1                       ;Rotate binary number to left
                rol temp2                       ;and add decimal number to
                rol temp3                       ;itself to convert
                lda temp4
                adc temp4
                sta temp4
                lda temp5
                adc temp5
                sta temp5
                lda temp6
                adc temp6
                sta temp6
                lda temp7
                adc temp7
                sta temp7
                dex
                bne c24b_loop
                cld
                rts

;-------------------------------------------------------------------------------
; PRINTBCDDIGIT
; PRINTBCDDIGITS
;
; Prints BCD numbers to the text panel.
;
; Parameters: A:Number
;             X:Offset in the text panel
; Returns: X autoincremented
; Modifies: A,X
;-------------------------------------------------------------------------------

printbcddigits: pha
                lsr
                lsr
                lsr
                lsr
                ora #$30
                sta textscreen+21*40,x
                inx
                pla
printbcddigit:  and #$0f
                ora #$30
                sta textscreen+21*40,x
                inx
                rts

;-------------------------------------------------------------------------------
; PRINTMSG
; PRINTMSGAX
; PRINTMSGPTR
;
; Prints a message to the text window.
;
; Parameters: A:Message number (or pointer ready in textptr - PRINTMSGPTR)
;             A,X:Message pointer (PRINTMSGAX)
;             Y:Message time on screen ($ff = eternal)
; Returns: A=1 if text did not fit on one screen
; Modifies: A,X,Y,possibly temp regs
;-------------------------------------------------------------------------------

printmsgeternalax:ldy #MSGTIME_ETERNAL
printmsgax:     sta textptrlo
                stx textptrhi
                jmp printmsgptr

printmsg:       jsr getmsgptr
printmsgptr:    sty msgtime
                sty up_msgtimereload+1
printmsgcont:   jsr cleartextwindow
                jsr printtextwindow
                lda #$00
                rol
                sta msgcont
                rts

getitemname:    clc
                adc #MSG_FIRSTITEMNAME
getmsgptr:      asl
                tax
                lda msgtbl,x
                sta textptrlo
                lda msgtbl+1,x
                sta textptrhi
                rts

;-------------------------------------------------------------------------------
; RESETMESSAGE
;
; Resets the message window.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

resetmessage:   lda #$00
                sta itemnamedisplay
                sta msgtime
                sta msgcont

;-------------------------------------------------------------------------------
; CLEARTEXTWINDOW
;
; Clears the text window.
;
; Parameters: -
; Returns: -
; Modifies: A,X
;-------------------------------------------------------------------------------

cleartextwindow:ldx textwindowleft
ptw_clear:      lda #$20
                sta textscreen+21*40,x
                sta textscreen+22*40,x
                lda #$01
                sta colors+21*40,x
                sta colors+22*40,x
                inx
                cpx textwindowright
                bcc ptw_clear
                rts


;-------------------------------------------------------------------------------
; PRINTTEXTWINDOW
;
; Prints text to the "text window", taking care of not going over it with too
; long words
;
; Parameters: textptr:text address
; Returns: C=1 text did not fit
; Modifies: A,X,Y,maptemp1-maptemp3
;-------------------------------------------------------------------------------

printtextwindow:lda #$00
                sta textwindowrow
                lda textwindowleft
                sta textwindowcolumn
ptw_continue:   lda textwindowright
                ldy #PANEL_ROWS-2               ;Display one char less on the
                cpy textwindowrow               ;last row, to make room for the
                                                ;text continuation indicator
                sbc #$00
                sta maptemp1
                ldx textwindowcolumn
                lda textptrlo
                sta maptemp2
                lda textptrhi
                sta maptemp3
ptw_wordlength: jsr ptw_getchar
                cmp #$00
                beq ptw_wldone
                cmp #$20
                beq ptw_wldone
                inx
                cmp #"-"
                bne ptw_wordlength
ptw_wldone:     lda maptemp2
                sta textptrlo
                lda maptemp3
                sta textptrhi
                cpx maptemp1
                beq ptw_ok
                bcc ptw_ok
                inc textwindowrow
                lda textwindowrow
                cmp #PANEL_ROWS
                bcc ptw_ok2
ptw_didnotfit:  ldx textwindowright
                lda #37
                jmp drawdownarrow2
ptw_ok2:        lda textwindowleft
                sta textwindowcolumn
ptw_ok:         ldx textwindowrow
                lda textrowtbl,x
                sta ptw_sta+1
                ldx textwindowcolumn            ;Multiply row by 40
ptw_wordloop:   jsr ptw_getchar
                cmp #$00
                beq ptw_ready
                cpx textwindowright
                inx
                bcs ptw_skipsta
                and #$3f
ptw_sta:        sta textscreen+21*40-1,x
ptw_skipsta:    cmp #$20
                beq ptw_ready
                cmp #"-"
                bne ptw_wordloop
ptw_ready:      stx textwindowcolumn
                cmp #$01
                bcs ptw_continue
                rts                             ;Carry 0 = text fits on screen

ptw_getchar:    ldy #$00
                lda (textptrlo),y
                bmi ptw_textjump
                inc textptrlo
                bne ptw_incdone
                inc textptrhi
ptw_incdone:    rts
ptw_textjump:   iny
                lda (textptrlo),y
                pha
                iny
                lda (textptrlo),y
                sta textptrhi
                pla
                sta textptrlo
                jmp ptw_getchar

ptw_printchar:  pha
                ldx textwindowrow
                lda textrowtbl,x
                sta ptw_pcsta+1
                inc textwindowcolumn
                ldx textwindowcolumn            ;Multiply row by 40
                pla
ptw_pcsta:      sta textscreen+21*40-1,x
                rts

ptw_clearrestofrow:
                lda #$20
                jsr ptw_printchar
                cpx textwindowright
                bcc ptw_clearrestofrow
                rts

;-------------------------------------------------------------------------------
; PRINTPANELTEXT
; PRINTPANELTEXTCONT
;
; Prints null-terminated text to the scorepanel.
;
; Parameters: A,Y:Text address (PRINTPANELTEXT only)
;             X:Offset in the text panel
; Returns: X and textpointer autoincremented
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

printpaneltext: sta alo
                sty ahi
printpaneltextcont:
                ldy #$00
pt_loop:        lda (alo),y
                beq pt_done
                and #$3f
                sta textscreen+21*40,x
                inx
                iny
                bne pt_loop
pt_done:        tya
pt_done2:       sec                             ;Add one more to skip zero
                adc alo
                sta alo
                bcc pt_notover
                inc ahi
pst_done:
pt_notover:     rts


;-------------------------------------------------------------------------------
; PRINTSCREENTEXT
;
; Prints formatted text to the screen
;
; Parameters: A,Y:textpointer
; Returns: Textpointer autoincremented
; Modifies: A,X,Y
;-------------------------------------------------------------------------------


printscreentext:sta alo
                sty ahi
pst_beginnextrow:
                ldy #$00
                lda (alo),y             ;Get X coord
                bmi pst_done            ;Negative quits
                sta temp5
                iny
                lda (alo),y             ;Get Y coord
                ldy #40
                ldx #temp1
                jsr mulu
                ldy #$02                ;Get color
                lda (alo),y
                sta pst_color+1
                lda temp1
                clc
                adc temp5
                sta temp1
                sta temp3
                lda temp2
                adc #>textscreen
                sta temp2
                and #$03
                ora #>colors
                sta temp4
                lda #$02
                jsr pt_done2
                ldy #$00
pst_loop:       lda (alo),y
                beq pst_nextrow
                cmp #64
                bcc pst_ok
                sbc #64
pst_ok:         sta (temp1),y
pst_color:      lda #$01
                sta (temp3),y
                iny
                bne pst_loop
pst_nextrow:    jsr pt_done
                jmp pst_beginnextrow

;-------------------------------------------------------------------------------
; CHECKINVVIEW
;
; Checks if inventory view must be adjusted to show the current item correctly.
;
; Parameters: -
; Returns: -
; Modifies: A
;-------------------------------------------------------------------------------

checkinvview:   lda invselect
                sec
                sbc invview
                bpl chkinvv_nottoolow
chkinvv_toolow: lda invselect
                bpl chkinvv_ok
chkinvv_nottoolow:
                cmp #PANEL_ROWS
                bcc chkinvv_nottoohigh
chkinvv_toohigh:lda invselect
                sbc #PANEL_ROWS-1
chkinvv_ok:     sta invview
chkinvv_nottoohigh:
                rts

;-------------------------------------------------------------------------------
; DRAWARROWS
;
; Draws the menu/conversation choice selection arrows.
;
; Parameters: A:Current choice
;             X:Maximum number of choices-1
;             Y:First choice
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

drawarrows:     stx maptemp1
                sty maptemp2
                tay
                ldx textwindowright
                lda #32
                cpy maptemp2
                beq da_notup
                lda #35
da_notup:       sta textscreen+21*40-1,x
                lda #32
                cpy maptemp1
                bcs da_notdown
drawdownarrow:  lda #36
drawdownarrow2:
da_notdown:     sta textscreen+22*40-1,x
                rts

;-------------------------------------------------------------------------------
; SETPLAYERSTATUS
;
; Sets vitality, strength & armor modifiers, and levitation status
;
; Parameters: -
; Returns: -
; Modifies: A,X
;-------------------------------------------------------------------------------

setplayerstatus:ldx difficulty
                lda enemyprobtbl,x
                sta ll_enemyprobability+1
                lda baseplrdmgmodtbl,x          ;Set player armor damage mod
                sec
                sbc plrarmor
                adc #$00                        ;C=1
                sta punish_plrarmormod+1
                lda baseplrdmgmodtbl,x          ;Set player vitality damage mod
                sec
                sbc plrvit
                sta punish_plrvitalitymod+1
                lda plrstr                      ;Calculate melee damage
                clc                             ;multiplier (with strength 4
                adc #BASE_MELEEDMGMOD           ;1,5x maximum)
                sta attk_plrmeleemod+1
                lda plrstr
                clc                             ;Player carrying limit =
                adc #4                          ;(5+strength-difficulty)*5
                sbc difficulty
                tax
                lda #4
sps_strloop:    adc #5
                dex
                bpl sps_strloop
                sta carrymax
                rts

sps_submodify:  ldx difficulty                  ;Easy & hard = 1x damage decrement,
                cpx #DIFF_MEDIUM                ;normal = 2x damage decrement
                bne sps_subok
                asl
sps_subok:      rts



