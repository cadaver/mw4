;
; MW4 Scriptfile 01: Title + common functions
;

                include scriptm.s               ;Script macros etc.

                entrypoint titleinit            ;100 - Titlescreen init
                entrypoint titlerun             ;101 - Titlescreen running
                entrypoint gamemenu             ;102 - Load/save menu
                entrypoint statusscreen         ;103 - Status screen
                entrypoint surgicalstation      ;104 - Surgical unit
                entrypoint recharger            ;105 - Battery recharger
                entrypoint useitems             ;106 - Use player items
                entrypoint unused               ;107 - unused
                entrypoint finalsurgical1       ;108 - Final level s.unit 1
                entrypoint finalrecharger1      ;109 - Final level rech. 1
                entrypoint finalsurgical2       ;10a - Final level s.unit 2
                entrypoint finalrecharger2      ;10b - Final level rech. 2

;-------------------------------------------------------------------------------
; $0100 - Title init
;-------------------------------------------------------------------------------

titleinit:      lda #PANELMC1                   ;Reset title colors
                sta rgscr_textbg2+1
                lda #PANELMC2
                sta rgscr_textbg3+1
                jsr resetmessage
                jsr cleartextscreen
                jsr initactors
                ldx #FILE_TITLE                 ;Load title logo / texts
                lda #STATUS_TITLE               ;0
                sta gameon
                sta titlereveal
                sta cheatindex
                jsr makefilename
                lda #<map
                ldx #>map
                jsr loadfileretry
                lda #$01                        ;Play titletune
                jsr playgametune
                lda #$60                        ;Reset BG anim
                sta bganimcode
                ldx #$00                        ;Copy title charset
ccs_loop:       lda map,x
                sta chars+$200,x
                lda map+$100,x
                sta chars+$300,x
                lda map+$200,x
                sta chars+$400,x
                inx
                bne ccs_loop
ti_logo:        lda map+$2b0,x               ;Draw logo
                sta textscreen+1*40,x
                lda map+$2b0+220,x
                sta textscreen+1*40+220,x
                inx
                cpx #220
                bcc ti_logo
                lda #<SCRIPT_TITLERUN        ;Set title runloop
                ldx #>SCRIPT_TITLERUN
                jsr execlatentscript
ti_resetptr:    lda #<(map+$470)             ;Reset title textptr.
                sta titleptrlo
                lda #>(map+$470)
                sta titleptrhi
unused:         rts

;-------------------------------------------------------------------------------
; $0101 - Title runloop
;-------------------------------------------------------------------------------

titlerun:       jsr random                      ;To make every(?) game different
                lda #$00
                sta $d020
                lda keytype
                bmi tr_nocheat

                ldy cheatindex                  ;Check cheatstring
                bne tr_cheatnotfirst            ;The 2 cheatstrings are stored
tr_cheatbegin:  cmp cheatstring,y               ;in interleaved fashion
                beq tr_cheatfound
                iny
tr_cheatnotfirst:
                cmp cheatstring,y
                bne tr_cheatwrong
tr_cheatfound:  iny                             ;Advance by 2 to go to the
                iny                             ;next letter of the string
                lda cheatstring,y               ;Check for endmark
                bpl tr_cheatcontinue
                lsr
                bcc tr_lifecheat
tr_ammocheat:   lda ah_limitedammo+1
                eor #$01
                sta ah_limitedammo+1
                bcs tr_cheatdonecommon

tr_lifecheat:   lda actl_agent+AD_DEFAULTHP
                eor #%11001110                  ;Toggle invulnerability
                sta actl_agent+AD_DEFAULTHP
tr_cheatdonecommon:
                inc $d020
tr_cheatwrong:  ldy #$00
tr_cheatcontinue:
                sty cheatindex
tr_nocheat:     ldy titlereveal                 ;Reveal logo by writing to
                cpy #40                         ;color-RAM
                beq tr_wait
                lda #217
                sta titledelay
                lda #$09
                sta colors+1*40,y
                sta colors+2*40,y
                sta colors+3*40,y
                sta colors+4*40,y
                sta colors+5*40,y
                sta colors+6*40,y
                sta colors+7*40,y
                sta colors+8*40,y
                sta colors+9*40,y
                sta colors+10*40,y
                sta colors+11*40,y
                lda #$01
                sta colors+14*40,y
                sta colors+15*40,y
                sta colors+16*40,y
                sta colors+17*40,y
                jsr tr_setptr
                lda (temp1),y                   ;Print lower part texts
                and #$3f
                sta textscreen+14*40,y
                jsr tr_add40
                sta textscreen+15*40,y
                jsr tr_add40
                sta textscreen+16*40,y
                jsr tr_add40
                sta textscreen+17*40,y
                inc titlereveal
tr_waitdone:    rts
tr_wait:        dec titledelay
                bne tr_waitdone
                lda #$00
                sta titlereveal
                lda titleptrlo
                clc
                adc #160
                sta titleptrlo
                bcc tr_notover
                inc titleptrhi
tr_notover:     jsr tr_setptr
                ldy #$00
                lda (temp1),y
                bpl tr_waitdone
                jmp ti_resetptr

tr_setptr:      lda titleptrlo
                sta temp1
                lda titleptrhi
                sta temp2
                rts

tr_add40:       lda temp1
                clc
                adc #40
                sta temp1
                bcc tr_add40ok
                inc temp2
tr_add40ok:     lda (temp1),y
                and #$3f
                rts

titleptrlo:     dc.b 0
titleptrhi:     dc.b 0
titlereveal:    dc.b 0
titledelay:     dc.b 0

cheatindex:     dc.b 0

cheatstring:    dc.b KEY_S,KEY_J        ;JCDENTON = unlimited life
                dc.b KEY_C,KEY_C        ;SCARECROW = unlimited reloads
                dc.b KEY_A,KEY_D
                dc.b KEY_R,KEY_E
                dc.b KEY_E,KEY_N
                dc.b KEY_C,KEY_T
                dc.b KEY_R,KEY_O
                dc.b KEY_O,KEY_N
                dc.b KEY_W,$80
                dc.b $81

;-------------------------------------------------------------------------------
; $0102 - Load/save menu
;-------------------------------------------------------------------------------

gamemenu:       ldy scriptparam
                bne gamemenuchoice
                lda #<gamemenutext1             ;Redraw menu
                ldy #>gamemenutext1
                jsr menu_titletext
                ldy gmselect
                ldx gamemenucursortbl,y
                lda #37
                sta textscreen+21*40,x
                ldx #29
                lda musicmode
                jsr menu_onofftext
                ldx #69
                lda soundmode
                jmp menu_onofftext

gamemenuchoice: lda gmselect                    ;Perform menu selection
                choice 0,gm_new
                choice 1,gm_load
                choice 2,gm_save
                choice 4,gm_music
                choice 5,gm_sound
                jmp gm_exit

gm_music:       lda musicmode                   ;Toggle music
                eor #$01
                sta musicmode
                jsr togglemusic
                jmp menu_redraw

gm_sound:       lda soundmode                   ;Toggle sound effects
                eor #$01
                sta soundmode
                jmp menu_redraw

gm_new:         jsr resetmessage                ;Start new game: select
gm_newredraw:   lda #SFX_SELECT                 ;difficulty
                jsr playsfx
                lda #<diffmenutext1
                ldy #>diffmenutext1
                jsr menu_titletext
                ldy dfselect
                ldx diffmenucursortbl,y
                lda #37
                sta textscreen+21*40,x
gm_newloop:     jsr menu_control
                lda temp1
                bmi gm_newgoback
                and #JOY_FIRE
                bne gm_newselect
gm_newnoselect: lda temp1
                lsr
                bcs gm_newleft
                lsr
                bcs gm_newright
                lsr
                bcs gm_newleft
                lsr
                bcs gm_newright
                jmp gm_newloop
gm_newleft:     dec dfselect
                jmp gm_newmovecommon
gm_newright:    inc dfselect
gm_newmovecommon:
                lda dfselect
                and #$03
                sta dfselect
                bpl gm_newredraw
gm_newgoback:   jsr menu_exitwithoutsound
                jmp menu_redraw
gm_newselect:   lda dfselect
                cmp #$03
                bcs gm_newgoback
                sta difficulty                  ;Store difficulty selection
                jumpto SCRIPT_NEWGAME           ;Game starts

gm_savefail:    jmp menu_redraw
gm_load:        lda #$00
                beq gm_savecommon
gm_save:        lda gameon                      ;Only allow save in game
                cmp #STATUS_INGAME              ;(not title or gameover)
                bne gm_savefail
                lda #$01
gm_savecommon:  sta gm_savemode+1
                jsr resetmessage
gm_saveredraw:  lda #SFX_SELECT
                jsr playsfx
                lda #<savemenutext1
                ldy #>savemenutext1
                ldx gm_savemode+1
                bne gm_savemsgok
                lda #<loadmenutext1
                ldy #>loadmenutext1
gm_savemsgok:   ldx #9
                jsr printpaneltext
                lda #<savemenutext2
                ldy #>savemenutext2
                ldx #49
                jsr printpaneltext
                ldy sgselect
                ldx savemenucursortbl,y
                lda #37
                sta textscreen+21*40,x
gm_saveloop:    jsr menu_control
                lda temp1
                bmi gm_savegoback
                and #JOY_FIRE
                bne gm_saveselect
gm_savenoselect:lda temp1
                lsr
                bcs gm_saveleft
                lsr
                bcs gm_saveright
                lsr
                bcs gm_saveleft
                lsr
                bcs gm_saveright
                jmp gm_saveloop
gm_savegoback:  jsr menu_exitwithoutsound
                jmp menu_redraw
gm_saveleft:    dec sgselect
                bpl gm_saveredraw
                lda #NUMGAMES
                sta sgselect
                bne gm_saveredraw
gm_saveright:   inc sgselect
                lda sgselect
                cmp #NUMGAMES+1
                bcc gm_saveredraw
                lda #$00
                sta sgselect
                beq gm_saveredraw
gm_saveselect:  lda sgselect
                cmp #NUMGAMES                   ;Cancel
                bcs gm_savegoback
                ldx #FILE_SAVE
                jsr makefilename
gm_savemode:    ldy #$00
                beq gm_doload
gm_dosave:      lda #<(-(saveareaend-saveareastart))
                sta zp_dest_lo
                lda #>(-(saveareaend-saveareastart))
                sta zp_dest_hi
                lda #<saveareastart
                ldx #>saveareastart
                jsr showdisk
                jsr savefile
gm_failload:    jsr hidedisk
                jsr initmap
                jmp menu_continuegame
gm_doload:      jsr showdisk                    ;Try to load savefile
                jsr openfile
                lda #<saveareastart
                sta alo
                lda #>saveareastart
                sta ahi
                jsr getbyte                     ;Get first byte
                bcs gm_failload                 ;Error!
                pha
                jsr cleartextscreen
                pla
                ldy #$00
gm_loadloop:    sta (alo),y
                jsr getbyte                     ;Get next byte
                bcs gm_loaddone
                iny
                bne gm_loadloop
                inc ahi
                bne gm_loadloop
gm_loaddone:    jsr hidedisk
                lda #UPD_ITEM|UPD_AMMO|UPD_SCORE        ;Update all
                sta panelupdateflag
                ldx #$7f                                ;Backup zone colors
gm_backupcols:  lda zonebg1,x                           ;to screen2
                sta screen2,x
                dex
                bpl gm_backupcols
                lda levelnum
                ldx #LLMODE_NOPURGEABLE
                jsr loadlevel
                ldx #$7f
gm_restorecols: lda screen2,x                           ;Restore zone colors
                sta zonebg1,x                           ;now
                dex
                bpl gm_restorecols
                ldx #NUMACT-1
                lda #$00
gm_resetactsize:sta actsizex,x                  ;Reset actor variables that
                sta actsizeup,x                 ;aren't saved
                sta actsizedown,x
                sta actfls,x
                dex
                bpl gm_resetactsize

                lda actt+ACTI_PLAYER            ;If not an Agent yet, the cheat
                cmp #ACT_IANAGENT               ;is insignificant
                bne gm_nocheat

                lda acthp+ACTI_PLAYER           ;If cheat switched off,
                cmp actl_agent+AD_DEFAULTHP     ;reflect this
                bcc gm_nohealthreset
                lda actl_agent+AD_DEFAULTHP
                sta acthp+ACTI_PLAYER
gm_nohealthreset:                               ;If cheat switched on,
                lda actl_agent+AD_DEFAULTHP     ;reflect also this
                bpl gm_nocheat
                sta acthp+ACTI_PLAYER
gm_nocheat:

                jsr setplayerstatus             ;Set correct damage subtract
                jsr resetmessage
                lda tunenum                     ;Restart the tune that should
                jsr playgametune                ;be playing
                jmp centerplayer                ;Go back to game

gm_exit:        jsr resetmessage
gm_exitredraw:  lda #SFX_SELECT
                jsr playsfx
                lda #<exitmenutext1
                ldy #>exitmenutext1
                jsr menu_titletext
                ldy qtselect
                ldx exitmenucursortbl,y
                lda #37
                sta textscreen+21*40,x
gm_exitloop:    jsr menu_control
                lda temp1
                bmi gm_exitgoback
                and #JOY_FIRE
                bne gm_exitselect
gm_exitnoselect:lda temp1
                lsr
                bcs gm_exitleft
                lsr
                bcs gm_exitright
                lsr
                bcs gm_exitleft
                lsr
                bcs gm_exitright
                jmp gm_exitloop
gm_exitleft:    dec qtselect
                bpl gm_exitredraw
                lda #$01
                sta qtselect
                bne gm_exitredraw
gm_exitright:   inc qtselect
                lda qtselect
                cmp #$02
                bcc gm_exitredraw
                lda #$00
                sta qtselect
                beq gm_exitredraw
gm_exitgoback:  jsr menu_exitwithoutsound
                jmp menu_redraw
gm_exitselect:  lda qtselect
                bne gm_exitgoback
                lda gameon                      ;End game, or exit to OS?
                beq gm_exittoos
gm_endgame:     lda #$00                        ;Reset choice to "new game"
                sta gmselect
                jumpto SCRIPT_TITLE             ;Go back to title

gm_exittoos:    lda #$36                        ;Kernal on
                sta $01
                lda $d011                       ;Blank screen
                and #$0f
                sta $d011
                jmp 64738                       ;Reset!

menu_printnumber:
                sta temp3                       ;Subroutine to print a 2 digit
                stx maptemp1                    ;number
                jsr convert8bits
                lda temp4
                ldx maptemp1
                jmp printbcddigits

menu_healthbar: asl
                asl
                jmp drawhealthbar2

menu_onofftext: cmp #$01                        ;Print either 'on' or 'off'
                lda #<offtext
                ldy #>offtext
                bcc menu_onofftext2
                lda #<ontext
                ldy #>ontext
menu_onofftext2:jmp printpaneltext

menu_titletext: ldx #9
                jsr printpaneltext
                ldx #49
                jmp printpaneltextcont


gamemenutext1:  dc.b " START  SAVE  MUSIC:",0
gamemenutext2:  dc.b " LOAD   QUIT  SOUND:",0
gamemenucursortbl:
                dc.b 9,49,16,56,22,62

loadmenutext1:  dc.b "LOAD GAME:",0
savemenutext1:  dc.b "SAVE GAME:",0

savemenutext2:  dc.b " 1  2  3  CANCEL",0
savemenucursortbl:
                dc.b 49,52,55,58

diffmenutext1:  dc.b "SELECT DIFFICULTY:",0
diffmenutext2:  dc.b " EASY MED HARD CANCEL",0

diffmenucursortbl:
                dc.b 49,54,58,63

exitmenutext1:  dc.b "CONFIRM QUIT:",0
exitmenutext2:  dc.b " YES  NO",0
exitmenucursortbl:
                dc.b 49,54

ontext:         dc.b "Y",0
offtext:        dc.b "N",0

;-------------------------------------------------------------------------------
; $0103 - Status screen
;-------------------------------------------------------------------------------

statusscreen:   lda #<statustext1
                ldy #>statustext1
                jsr menu_titletext
                lda carrylo                     ;Rotate highest bit
                rol                             ;to bit 0 for rounding
                rol                             ;weight upwards
                and #$01
                clc
                adc carryhi
                ldx #15
                jsr menu_printnumber
                lda carrymax                    ;Print carrying max. amount
                ldx #18
                jsr menu_printnumber
                lda ti_hours                    ;Print game time
                ldx #23
                jsr menu_printnumber
                lda ti_minutes
                ldx #26
                jsr menu_printnumber
                lda ti_seconds
                ldx #29
                jsr menu_printnumber
                lda #3
                sta dhb_nohalf+1
                tay
                lda #$0b
menu_barcolorloop:
                sta colors+22*40+11,y
                sta colors+22*40+18,y
                sta colors+22*40+27,y
                dey
                bne menu_barcolorloop
                lda plrvit
                clc
                adc #$01
                ldx #52
                jsr menu_healthbar
                lda plrstr
                clc
                adc #$01
                ldx #59
                jsr menu_healthbar
                lda plrarmor
                ldx #68
                jmp menu_healthbar

statustext1:    dc.b "CARRY   /  KG   :  :",0
statustext2:    dc.b "VIT    STR    ARMOR",0

;-------------------------------------------------------------------------------
; $0104 - Surgical station
;-------------------------------------------------------------------------------

surgicalstation:jsr menu_inactivatecounter
                ldx #ACTI_PLAYER
                jsr mh_setdoorframe
                lda #3
                sta ss_select
ss_redraw2:     jsr resetmessage
ss_redraw:      lda #<ss_text
                ldy #>ss_text
                jsr menu_titletext
                lda #SFX_SELECT
                jsr playsfx
                ldy ss_select
                ldx ss_cursortbl,y
                lda #37
                sta textscreen+21*40,x
ss_loop:        jsr increaseclock
                jsr menu_control
                lda temp1
                bmi ss_exit
                and #JOY_FIRE
                bne ss_choose
                lda temp1
                lsr
                bcs ss_left
                lsr
                bcs ss_right
                lsr
                bcs ss_left
                lsr
                bcs ss_right
                jmp ss_loop
ss_choose:      ldx #ACTI_PLAYER
                lda ss_select
                choice 0,ss_heal
                choice 1,ss_vit
                choice 2,ss_str
ss_exit:        jsr mh_setstandingframe
                jmp menu_exit

ss_left:        lda #$ff
                bne ss_moveok
ss_right:       lda #$01
ss_moveok:      clc
                adc ss_select
                and #$03
                sta ss_select
ssh_notok:      jmp ss_redraw

ss_heal:        lda acthp,x
                cmp #HP_AGENT
                bcs ssh_notok
                lda acthptime,x                 ;Do not interrupt previous
                beq ssh_ok                      ;healing
                bpl ssh_notok
ssh_ok:         lda #(HP_AGENT)/12             ;Restore full hitpoints
                sta acthpdelta,x
                lda #12
                sta acthptime,x
                lda #SFX_HYPO
                jsr playsfx
                jmp ss_exit

ss_vit:         lda #SFX_SELECT
                jsr playsfx
                lda #ITEM_VITALITY_ENHANCEMENT
                jsr finditem
                bcc ss_noenhancement
                inc plrvit
ss_enhcommon:   jsr setplayerstatus
                lda #SFX_HYPO                   ;Sound & remove from
                jsr useitems_common             ;inventory
ss_successful:  lda #<ss_successtext
                ldx #>ss_successtext
ss_msgcommon:   ldy #MSGTIME_ETERNAL
                jsr printmsgax
                jsr waitformessage
                jmp ss_redraw
ss_noenhancement:
                lda #<ss_notext
                ldx #>ss_notext
                bne ss_msgcommon

ss_str:         lda #SFX_SELECT
                jsr playsfx
                lda #ITEM_STRENGTH_ENHANCEMENT
                jsr finditem
                bcc ss_noenhancement
                inc plrstr
                jmp ss_enhcommon


ss_text:        dc.b "SELECT PROCEDURE:",0
                dc.b " HEAL  VIT  STR  EXIT",0
ss_successtext: dc.b "UPGRADE INSTALLED",0
ss_notext:      dc.b "NO UPGRADE AVAILABLE",0

ss_cursortbl:   dc.b 49,55,60,65

ss_select:      dc.b 0

;-------------------------------------------------------------------------------
; $0105 - Energy recharger
;-------------------------------------------------------------------------------

recharger:      ldx #ACTI_PLAYER
                lda plrarmor                    ;Has armor at all?
                beq rc_notok
                lda actbatt,x
                cmp #HP_AGENT
                bcs rc_notok
                lda #HP_AGENT/24
                sta plrbattdelta
                lda #24
                sta plrbatttime
                jsr mh_setdoorframe
                lda #SFX_POWERUP
                jsr playsfx
                lda #<recharger_text
                ldx #>recharger_text
                ldy #MSGTIME
                jmp printmsgax
rc_notok:       rts

recharger_text: dc.b "ARMOR RECHARGING..",0

;-------------------------------------------------------------------------------
; $0106 - Use player items
;-------------------------------------------------------------------------------

useitems:       ldy invselect
                lda invtype,y
                choice ITEM_MEDIKIT, usemedikit
                choice ITEM_BATTERY, usebattery
                choice ITEM_BEER, usebeer
                choice ITEM_AGENT_GEAR, usegear
                choice ITEM_LETTER, useletter
                cmp #ITEM_BETA_ARMORSYSTEM
                bcc ui_noarmor
                cmp #ITEM_EPSILON_ARMORSYSTEM+1
                bcs ui_noarmor
                jmp usearmor
ua_skipmsg
ua_notbetter:
ui_noarmor:     rts

useletter:      jumpto SCRIPT_LETTER

usearmor:       sec
                sbc #ITEM_BETA_ARMORSYSTEM-2
                cmp plrarmor                    ;Must be better or equal as
                bcc ua_notbetter                ;previous
usegear2:       sta plrarmor
                jsr setplayerstatus
                lda #0                          ;New armor starts from zero
                sta actbatt+ACTI_PLAYER
                lda #HP_AGENT/24
                sta plrbattdelta                ;But charges to maximum
                lda #24
                sta plrbatttime
                jsr usepowerup_common           ;Sound + decrease ammo
                lda plrarmor                    ;First Agent gear?
                cmp #$01
                beq ua_skipmsg
                lda #<armortext
                ldx #>armortext
                ldy #MSGTIME
                jmp printmsgax

usemedikit:     lda acthp+ACTI_PLAYER
                cmp #HP_AGENT
                bcs ub_notok
                lda acthptime+ACTI_PLAYER       ;Do not interrupt previous
                beq umk_ok                      ;healing
                bmi umk_ok
ub_notok:       rts
umk_ok:         lda #(HP_AGENT/2)/6            ;Restore half of hitpoints
                sta acthpdelta+ACTI_PLAYER
                lda #6
                sta acthptime+ACTI_PLAYER
                lda #SFX_HYPO
                jmp useitems_common

usebeer:        lda #(HP_AGENT/3)/6             ;Beer restores 1/3 hitpoints
                sta acthpdelta+ACTI_PLAYER      ;and can be consumed any time :)
                lda #6
                sta acthptime+ACTI_PLAYER
                bne usepowerup_common

usegear:        lda #$01
                jsr usegear2                    ;Exec certain script when
                lda #<SCRIPT_SARGECONV2         ;wearing the Agent gear
                ldx #>SCRIPT_SARGECONV2         ;(in latent mode)
                jmp execlatentscript

usebattery:     lda plrarmor                    ;Has armor at all?
                beq ub_notok
                lda actbatt+ACTI_PLAYER
                cmp #HP_AGENT
                bcs ub_notok
                lda plrbatttime                 ;Do not interrupt previous
                beq ub_ok                       ;power-up
                lda plrbattdelta
                bpl ub_notok
ub_ok:          lda #(HP_AGENT/2)/12
                sta plrbattdelta
                lda #12
                sta plrbatttime
usepowerup_common:
                lda #SFX_POWERUP
useitems_common:jsr playsfx
                lda #$01                        ;Decrement item amount by one
                jmp decreaseammo

armortext:      dc.b "ARMORSYSTEM INSTALLED",0

;-------------------------------------------------------------------------------
; $0107 - unused
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; $0108,9,a,b Final level rechargers (dependant on facility power)
;-------------------------------------------------------------------------------

finalsurgical1: getbit PLOT_GENERATOR1_OFFLINE
                bne offline
                jmp surgicalstation
finalrecharger1:getbit PLOT_GENERATOR1_OFFLINE
                bne offline
                jmp recharger
finalsurgical2: getbit PLOT_GENERATOR2_OFFLINE
                bne offline
                jmp surgicalstation
finalrecharger2:getbit PLOT_GENERATOR2_OFFLINE
                bne offline
                jmp recharger

offline:        lda #SFX_OBJECT
                jsr playsfx
                lda #<offlinetext
                ldx #>offlinetext
                ldy #MSGTIME
                jmp printmsgax

offlinetext:    dc.b "OFFLINE",0

                endscript
