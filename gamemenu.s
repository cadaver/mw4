;-------------------------------------------------------------------------------
; MENU
;
; Game main menu activation
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,everything :)
;-------------------------------------------------------------------------------

menu:           lda actattkd+ACTI_PLAYER            ;No activation while in
                bne menu_inactivatecounter          ;combat
                lda keytype                         ;Spacebar = instant
                cmp #KEY_SPACE                      ;activation
                beq menu_activate
                lda joystick
                and #JOY_FIRE
                beq menu_paused
                lda joystick
                and #JOY_LEFT|JOY_RIGHT|JOY_UP|JOY_DOWN
                bne menu_inactivatecounter
                lda menucounter
                bmi menu_paused3
                ldy gameon                         ;Activate immediately
                beq menu_activate                  ;if not in game
                bmi menu_activate
                cmp #MENU_DELAY
                bcs menu_activate
                adc #$01
                bcc menu_paused2

menu_inactivatecounter:
                lda #$ff
                bne menu_paused2
menu_paused:    lda #$00
menu_paused2:   sta menucounter
menu_paused3:   rts

menu_activate:  jsr menu_inactivatecounter      ;Reset delaycounter
                lda #$00
                sta actreload+ACTI_PLAYER       ;Cancel any reloading
                jsr resetmessage
                jsr calcweight
                lda #MM_GAMEMENU                ;If game over, start in
                ldy gameon                      ;gamemenu. Else in
                cpy #STATUS_INGAME              ;inventory
                bne menu_notingame
                lda #MM_INVENTORY
menu_notingame: sta menumode

menu_redraw:    lda #SFX_SELECT
                jsr playsfx
                lda menumode
                choice MM_INVENTORY,menu_redrawinventory
                choice MM_GAMEMENU,menu_redrawgamemenu
menu_redrawstatus:
                lda #<SCRIPT_STATUS
                ldx #>SCRIPT_STATUS
                jsr execscript
                jmp menu_active

menu_redrawgamemenu:
                lda #<SCRIPT_GAMEMENU
                ldx #>SCRIPT_GAMEMENU
                ldy #$00                ;0 - redraw
                jsr execscriptwithparam
                jmp menu_active

menu_redrawinventory:
                jsr checkinvview
                dec textwindowright         ;Leave room for the arrows
                lda #$00
                sta textwindowrow
                lda #PANEL_ROWS
                sta temp7
                lda invview
                sta temp6
menu_redrawloop:lda textwindowleft          ;Draw 2 rows of inventory
                sta textwindowcolumn
                ldy temp6
                lda #32
                cpy invselect
                bne menu_noarrow
                lda #37
menu_noarrow:   jsr ptw_printchar
                lda invtype,y
                jsr getitemname
                jsr ptw_continue
                jsr ptw_clearrestofrow
                inc textwindowrow
                inc temp6
                dec temp7
                bne menu_redrawloop
                inc textwindowright
                lda invselect
                ldx invsize
                ldy #$00
                jsr drawarrows
                jmp menu_active

menu_select:    lda menumode
                cmp #MM_GAMEMENU
                bne menu_exit
                lda #<SCRIPT_GAMEMENU
                ldx #>SCRIPT_GAMEMENU
                ldy #$01                ;1 - decision
                jmp execscriptwithparam
menu_exit:      lda #SFX_SELECT
                jsr playsfx
menu_exitwithoutsound:
menu_continuegame:
                lda #$ff                              ;Inactivate counter
                sta menucounter
                jmp resetmessage
menu_active:    jsr menu_control
                lda temp1
                bmi menu_exit
                and #JOY_FIRE
                bne menu_select
                lda temp1
                lsr
                bcs menu_moveup
                lsr
                bcs menu_movedown
                lsr
                bcs menu_moveleft
                lsr
                bcs menu_moveright
menu_movedone:  jmp menu_active
menu_moveup:    lda menumode
                beq menu_moveupinv
                cmp #MM_GAMEMENU
                bne menu_movedone
                dec gmselect
                bpl menu_movecommon
                lda #$05
                sta gmselect
                bne menu_movecommon
menu_moveupinv: lda invselect
                beq menu_movedone
                dec invselect
menu_movecommon:jsr setitemupdate
                jmp menu_redraw
menu_movedown:  lda menumode
                beq menu_movedowninv
                cmp #MM_GAMEMENU
                bne menu_movedone
                inc gmselect
                lda gmselect
                cmp #$06
                bcc menu_movecommon
                lda #$00
                sta gmselect
                beq menu_movecommon
menu_movedowninv:
                lda invselect
                cmp invsize
                bcs menu_movedone
                inc invselect
                jmp menu_movecommon
menu_moveleft:  lda gameon
                cmp #STATUS_INGAME
                bne menu_movedone
                dec menumode
                bpl menu_mlok
                lda #MM_STATUS
                sta menumode
menu_mlok:
menu_leftrightcommon:
                jsr resetmessage
                lda #$80                        ;Have to center joystick
                sta menucounter
                bne menu_movecommon
menu_moveright: lda gameon
                cmp #STATUS_INGAME
                bne menu_movedone
                inc menumode
                lda menumode
                cmp #MM_STATUS+1
                bcc menu_leftrightcommon
                lda #MM_INVENTORY
                sta menumode
                bcs menu_leftrightcommon



;-------------------------------------------------------------------------------
; MENU_CONTROL
;
; Common control subroutine for menus
;
; Parameters: -
; Returns: temp1 = joystick, or highbit set if space pressed
; Modifies: A,X,Y,everything :)
;-------------------------------------------------------------------------------

menu_control:   lda scriptf                     ;Allow the title runloop
                ldx scriptep                    ;to run here
                cmp #<SCRIPT_TITLERUN
                bne mc_noscript
                cpx #>SCRIPT_TITLERUN
                bne mc_noscript
                jsr execscript
mc_noscript:    jsr scriptupdateframe
                lda #$00                        ;Assume: no control
                sta temp1
                lda keytype
                cmp #KEY_SPACE
                beq mc_exit
                lda prevjoy
                bne mc_nodelayreset
                sta menucounter                     ;If joystick centered,
                lda joystick                        ;reset movedelay &
                and #JOY_FIRE                       ;check for exit
                bne mc_select
mc_nodelayreset:lda menucounter
                beq mc_moveok
                bmi mc_done
                dec menucounter
                jmp mc_done
mc_moveok:      lda joystick
                and #$0f
                beq mc_select
                ldy #MENU_MOVEDELAY
                sty menucounter
mc_select:      sta temp1
mc_done:        rts
mc_exit:        lda #$80
                bne mc_select
