;
; MW4 Scriptfile 02: Map screen, city public terminals, street cops
;
                include scriptm.s               ;Script macros etc.

MAX_LOCATIONS = 10


                entrypoint mapscreen            ;200 - Map screen
                entrypoint term1                ;201 - Normal terminal
                entrypoint term2                ;202 - Hacked terminal
                entrypoint cop                  ;203 - Cop
                entrypoint weaponshop           ;204 - Weapon shop guy
                entrypoint bartender            ;205 - Bartender
                entrypoint breakin              ;206 - SCEPTRE breakin
                entrypoint axesmith             ;207 - Axesmith

;-------------------------------------------------------------------------------
; $0200 - Map/travel screen
;-------------------------------------------------------------------------------

mapscreen:      jsr cleartextscreen
                getbit PLOT_SADOK_MET
                jumpfalse mapscreen_nosadok
                lda #$7f                ;If Sadok met, transport
                sta temp7               ;him now to Ethereal Void..
                lda #ACT_SADOK
                jsr transportactor
mapscreen_nosadok:
                lda #$00
                ldx #FILE_MAP
                jsr makefilename
                lda #<map
                ldx #>map
                jsr loadfileretry
                jsr copycharset
                jsr beginfullscreen
                ldy scriptparam
                lda loc_plotbit,y               ;Set corresponding plotbit
                jsr setplotbit                  ;(allow select on mapscreen)

                lda #$0c
                sta rgscr_textbg3+1
                lda #$00                        ;Number of pic to draw
                sta temp6                       ;Maximum to select
                sta mapselectmax
ms_drawloop:    lda temp6                       ;Check if entry allowed
                clc                             ;(in plotbits)
                adc #PLOT_MAP_SUBCITY
                jsr checkplotbit
                beq ms_skip
                ldy mapselectmax
                lda temp6
                sta map_selecttbl,y
                lda map_postblhi,y
                ldx map_postbllo,y
                tay
                lda temp6
                jsr drawmappic
                inc mapselectmax
ms_skip:        inc temp6
                lda temp6
                cmp #MAX_LOCATIONS
                bcc ms_drawloop

                ldy scriptparam                 ;Default selection =
                lda loc_selecttbl,y             ;current location
                sta mapoldloc
                ldx #$00
ms_search:      cmp map_selecttbl,x
                beq ms_found
                inx
                bne ms_search
ms_found:       stx mapselect

                lda #SFX_SELECT
                jsr playsfx
ms_loop:        jsr menu_control
                inc mapflash
                lda mapflash
                lsr
                lsr
                and #$03
                tax
                lda map_flashtbl,x
                jsr ms_highlight
                lda temp1                       ;Selection
                and #JOY_FIRE
                bne ms_select
                lda temp1                       ;Movement
                ldy #$fe                        ;Up,down,left,right
                lsr
                bcs ms_move
                ldy #$02
                lsr
                bcs ms_move
                ldy #$ff
                lsr
                bcs ms_move
                ldy #$01
                lsr
                bcs ms_move
                bcc ms_loop
ms_select:      jsr cleartextscreen
                lda #PANELMC2
                sta rgscr_textbg3+1
                lda #SFX_SELECT
                jsr playsfx
                ldx mapselect
                lda map_selecttbl,x             ;What location was chosen
                cmp mapoldloc
                beq ms_samelevel
                ldy #$00
ms_search2:     cmp loc_selecttbl,y
                beq ms_found2
                iny
                bne ms_search2
ms_found2:      lda loc_dirtbl,y                ;Depends on direction?
                beq ms_dirok
                lda actd+ACTI_PLAYER            ;If player facing left,
                bpl ms_dirok                    ;choose the next table entry
                iny
ms_dirok:       sta actd+ACTI_PLAYER
                lda loc_objtblhi,y
                ora #$80                        ;Force level load
                tax
                lda loc_objtbllo,y
                jmp enterdoornum                ;And go there!
ms_samelevel:   lda actd+ACTI_PLAYER            ;Same level: only reload
                eor #$80                        ;map data but don't do
                sta actd+ACTI_PLAYER            ;anything else
                jmp endfullscreen_reload

ms_move:        lda #SFX_SELECT
                jsr playsfx
                sty ms_moveadd+1
                lda #$01
                jsr ms_highlight
                lda mapselect
                clc
ms_moveadd:     adc #$00
                bmi ms_moveover2
                cmp mapselectmax
                bcs ms_moveover1
ms_moveok:      sta mapselect
                jmp ms_loop
ms_moveover2:   lda mapselectmax
                sec
                sbc #$01
                bcs ms_moveok
ms_moveover1:   lda #$00
                beq ms_moveok

ms_highlight:   pha
                ldy mapselect
                lda map_postbllo,y
                sta alo
                lda map_postblhi,y
                and #$03
                ora #>colors
                sta ahi
                pla
                ldy #6
                ldx #20
                jsr ms_hlsub
                ldy #46
                ldx #60
                jsr ms_hlsub
                ldy #86
                ldx #100
ms_hlsub:       stx ms_hlcmp+1
ms_hlloop:      sta (alo),y
                iny
ms_hlcmp:       cpy #$00
                bcc ms_hlloop
                rts

copycharset:    lda #$60                        ;Reset BG anim
                sta bganimcode
                ldy #$00                        ;Copy title charset
                sty alo
                sty tempadrlo
                lda #>map
                sta ahi
                lda #>(chars+$200)
                sta tempadrhi
                ldx #$05
ccs_loop:       lda (alo),y
                sta (tempadrlo),y
                iny
                bne ccs_loop
                inc ahi
                inc tempadrhi
                dex
                bne ccs_loop
ccs_lastloop:   lda (alo),y
                sta (tempadrlo),y
                iny
                cpy #$f8
                bcc ccs_lastloop
                rts

drawmappic:     stx temp1
                stx temp3
                sty temp2
                ldx #alo
                ldy #60
                jsr mulu
                lda alo
                clc
                adc #<(map+$800)
                sta alo
                lda ahi
                adc #>(map+$800)
                sta ahi
                lda temp2
                and #$03
                ora #>colors
                sta temp4
                lda #$03
                sta temp5
dmp_loop:       ldy #$00
dmp_loop2:      lda (alo),y
                cpy #$06
                bcs dmp_letters
                sta (temp1),y
                tax
                lda map+$5a0-$40,x
                jmp dmp_ok
dmp_letters:    and #$3f
                sta (temp1),y
                lda #$01
dmp_ok:         sta (temp3),y
                iny
                cpy #20
                bcc dmp_loop2
                lda alo
                adc #20-1
                sta alo
                bcc dmp_notover1
                inc ahi
dmp_notover1:   lda temp1
                clc
                adc #40
                sta temp1
                sta temp3
                bcc dmp_notover2
                inc temp2
                inc temp4
dmp_notover2:   dec temp5
                bne dmp_loop
                rts

map_postbllo:   dc.b <(textscreen+0)
                dc.b <(textscreen+20)
                dc.b <(textscreen+160)
                dc.b <(textscreen+180)
                dc.b <(textscreen+320)
                dc.b <(textscreen+340)
                dc.b <(textscreen+480)
                dc.b <(textscreen+500)
                dc.b <(textscreen+640)
                dc.b <(textscreen+660)

map_postblhi:   dc.b >(textscreen+0)
                dc.b >(textscreen+20)
                dc.b >(textscreen+160)
                dc.b >(textscreen+180)
                dc.b >(textscreen+320)
                dc.b >(textscreen+340)
                dc.b >(textscreen+480)
                dc.b >(textscreen+500)
                dc.b >(textscreen+640)
                dc.b >(textscreen+660)


map_flashtbl:   dc.b 1,3,6,3

map_selecttbl:  ds.b 10,0

loc_selecttbl:  dc.b 0,0,1,1,2,2,4,5,5,6,6,7,8,9,3

loc_plotbit:    dc.b PLOT_MAP_SUBCITY
                dc.b PLOT_MAP_SUBCITY
                dc.b PLOT_MAP_FARM
                dc.b PLOT_MAP_FARM
                dc.b PLOT_MAP_AGENTHQ
                dc.b PLOT_MAP_AGENTHQ
                dc.b PLOT_MAP_COMMINT
                dc.b PLOT_MAP_RESEARCH
                dc.b PLOT_MAP_RESEARCH
                dc.b PLOT_MAP_TRAINING
                dc.b PLOT_MAP_TRAINING
                dc.b PLOT_MAP_MANSION
                dc.b PLOT_MAP_IAC
                dc.b PLOT_MAP_COMMAND
                dc.b PLOT_MAP_FOREST

loc_dirtbl:     dc.b $01
                dc.b $01
                dc.b $01
                dc.b $01
                dc.b $01
                dc.b $01
                dc.b $00
                dc.b $01
                dc.b $01
                dc.b $01
                dc.b $01
                dc.b $00
                dc.b $00
                dc.b $00
                dc.b $00

loc_objtbllo:   dc.b $0b
                dc.b $0c
                dc.b $0c
                dc.b $1d
                dc.b $11
                dc.b $12
                dc.b $14
                dc.b $09
                dc.b $0a
                dc.b $06
                dc.b $07
                dc.b $05
                dc.b $08
                dc.b $05
                dc.b $13

loc_objtblhi:   dc.b $00
                dc.b $00
                dc.b $02
                dc.b $02
                dc.b $04
                dc.b $04
                dc.b $05
                dc.b $0a
                dc.b $0a
                dc.b $0c
                dc.b $0c
                dc.b $0e
                dc.b $15
                dc.b $14
                dc.b $04

mapselect:      dc.b 0
mapselectmax:   dc.b 0
mapflash:       dc.b 0
mapoldloc:      dc.b 0

;-------------------------------------------------------------------------------
; $0201 - Sub-City Public Terminal
;-------------------------------------------------------------------------------

term1:          jsr term_begincommon
                lda #PLOT_SCEPTRE_ENTERED
                jsr checkplotbit
                beq term1_normal
                lda #PLOT_SCEPTRE_MESSAGE_DISPLAYED
                jsr checkplotbit
                bne term1_normal
                jmp term1_hacked

term1_normal:   lda #<term1_text
                ldy #>term1_text
term1_textcommon:
                jsr printscreentext
term1_endcommon:lda #MSGTIME_ETERNAL
                jsr waitforfire
                jmp endfullscreen

termtitle:      jsr border
                lda #<term_text
                ldy #>term_text
                ldx #$01
                jmp printscreentext

                         ;12345678901234567890123456789012345678
term_text:      dc.b 1,0,1,"SUB-CITY PUBLIC INFORMATION TERMINAL",0
                dc.b $ff
term1_text:     dc.b 1,2,1,"UNTIL RIOTING AND GANG WARS CAN BE",0
                dc.b 1,3,1,"BROUGHT UNDER CONTROL, CITIZENS ARE",0
                dc.b 1,4,1,"ADVISED TO AVOID UNNECESSARY STAYING",0
                dc.b 1,5,1,"ON THE STREETS, ESPECIALLY AT NIGHT.",0
                dc.b 1,7,1,"ADDITIONAL POLICE UNITS HAVE BEEN",0
                dc.b 1,8,1,"DISPACTCHED FOR YOUR SAFETY.",0,$ff

term1_hacked:   lda #PLOT_SCEPTRE_MESSAGE_DISPLAYED
                jsr setplotbit  ;Display only once
                lda #1
                sta term1_hackedtext
                lda #2
                sta term1_hackedtext+1
                lda #$05
                sta temp7
term1_loop:     lda #<term1_hackedtext
                ldy #>term1_hackedtext
                ldx #$01
                jsr printscreentext
                inc term1_hackedtext
                inc term1_hackedtext+1
                dec temp7
                bne term1_loop
                jmp term1_endcommon

term1_hackedtext:
                dc.b 1,2,1,"SCEPTRE HAS FOUND YOU!",0
                dc.b $ff

;-------------------------------------------------------------------------------
; $0202 - Sub-City Public Terminal hacked by ?? (near police station)
;-------------------------------------------------------------------------------

term2:          jsr term_begincommon
                lda #<term2_text
                ldy #>term2_text
                jmp term1_textcommon

term_begincommon:
                lda #SFX_OBJECT
                jsr playsfx
                jsr beginfullscreen
                jmp termtitle

                         ;12345678901234567890123456789012345678
term2_text:     dc.b 1,2,1,"THIS TERMINAL WAS H4X0RED AND R00TED",0
                dc.b 1,3,1,"BY AKUMA/DA YAKUZAS!!!",0,$ff

;-------------------------------------------------------------------------------
; $0203 - Cop actortrigger
;-------------------------------------------------------------------------------

cop:            choice T_CONV,cop_conv
                choice T_TAKEDOWN,cop_takedown
cop_cancel:     rts

cop_conv:       jsr isincombat                  ;Don't speak if in combat
                bcs cop_cancel
                lda alliance+GRP_COPS           ;Don't speak if hostile
                and #%00000010                  ;to player
                beq cop_cancel
                rnd 3
                selectline l_cop
                jmp speak

l_cop:          dc.w l_cop0
                dc.w l_cop1
                dc.w l_cop2
                dc.w l_cop3

l_cop0:         dc.b 34,"STAY OUT OF TROUBLE.",34,0
l_cop1:         dc.b 34,"THIS CITY HAS BECOME A WARZONE.",34,0
l_cop2:         dc.b 34,"WHAT ARE YOU DOING OUT AT THIS TIME?",34,0
l_cop3:         dc.b 34,"IT ISN'T SAFE. YOU SHOULD BE INSIDE.",34,0

cop_takedown:   lda actlastdmgact2,x            ;Player responsible?
                cmp #ACTI_PLAYER
                bne cop_notplayer
                lda alliance+GRP_COPS           ;Remove agents from
                and #%11111101                  ;alliance-friendly list
                sta alliance+GRP_COPS
cop_notplayer:  rts

;-------------------------------------------------------------------------------
; $0204 - Weaponshop
;-------------------------------------------------------------------------------

weaponshop:     lda #$00
                sta wpnselect
                sta wpnfirst
                lda #15*4
                sta wpnlast
wpn_common:     ldx #ACTI_PLAYER
                jsr mh_setdoorframe
                jsr menu_inactivatecounter
wpn_redraw:     lda #SFX_SELECT
wpn_redraw2:    jsr playsfx
                jsr resetmessage
                ldx wpnselect
                lda wpn_tbl,x           ;Take item num
                bne wpn_noexittext
                lda #<wpn_exittext
                ldx #>wpn_exittext
                ldy #MSGTIME_ETERNAL
                jsr printmsgax
                lda #$00
                beq wpn_costok
wpn_noexittext: jsr getitemname
                ldy #MSGTIME_ETERNAL
                jsr printmsgptr
                ldx wpnselect
                lda wpn_tbl+1,x         ;Take amount
                beq wpn_noamount        ;If zero, skip
                sta temp3
                jsr convert8bits
                ldx #29
                lda temp4
                jsr printbcddigits
wpn_noamount:   ldx wpnselect
                lda wpn_tbl+2,x         ;Price
wpn_costok:     sta temp3
                jsr convert8bits
                ldx #49
                lda #<wpn_cost
                ldy #>wpn_cost
                jsr printpaneltext
                ldx #54
                jsr wpn_print3numbers
wpn_noitem:     ldx #60
                lda #<wpn_credits
                ldy #>wpn_credits
                jsr printpaneltext
                lda #$00
                sta temp2               ;Assume zero credits
                sta temp3
                lda #ITEM_CREDITS
                jsr finditem
                bcc wpn_zero
                lda invcountlo,y
                sta temp2
                lda invcounthi,y
                sta temp3
wpn_zero:       lda #$ff
                ldy temp3
                bne wpn_enoughcredits   ;255+ credits is enough to buy anything
                lda temp2
wpn_enoughcredits:sta wpn_creditscheck+1
                jsr convert16bits
                ldx #68
                jsr wpn_print3numbers
wpn_loop:       jsr menu_control
                lda temp1
                and #$80
                bne wpn_exit
                lda temp1
                and #JOY_FIRE
                bne wpn_select
                lda temp1
                lsr
                bcs wpn_up
                lsr
                bcs wpn_down
                lsr
                bcs wpn_up
                lsr
                bcs wpn_down
                bcc wpn_loop
wpn_select:     ldy wpnselect
                lda wpn_tbl,y
                beq wpn_exit
wpn_creditscheck:
                lda #$00                        ;Enough credits?
                cmp wpn_tbl+2,y
                bcc wpn_fail
                lda wpn_tbl+1,y                 ;Has ammo?
                bne wpn_itemok
                lda wpn_tbl,y
                jsr finditem                    ;Don't buy same weapon twice
                bcs wpn_fail
wpn_itemok:     ldy wpnselect
                ldx wpn_tbl,y                   ;Type and add-amount
                lda wpn_tbl+1,y
                jsr additem                     ;Try adding
                bcc wpn_fail                    ;Inventory full perhaps
                ldy wpnselect
                lda wpn_tbl+2,y                 ;Decrease credits by price
                ldy #ITEM_CREDITS
                jsr decreaseitem
                lda #SFX_OBJECT
                jmp wpn_redraw2
wpn_fail:       lda #SFX_DAMAGE
                jsr playsfx
                jmp wpn_loop

wpn_exit:       lda #SFX_SELECT
                jsr playsfx
                jsr resetmessage
                ldx #ACTI_PLAYER
                jmp mh_setstandingframe

wpn_up:         lda wpnselect
                sbc #$04
                bcc wpn_upover
                cmp wpnfirst
                bcs wpn_upok
wpn_upover:     lda wpnlast
                sec
                sbc #$04
wpn_upok:       sta wpnselect
                jmp wpn_redraw
wpn_down:       lda wpnselect
                adc #$03
                cmp wpnlast
                bcc wpn_upok
                lda wpnfirst
                jmp wpn_upok

wpn_print3numbers:
                lda temp5
                jsr printbcddigit
                lda temp4
                jmp printbcddigits

wpnselect:      dc.b 0
wpnfirst:       dc.b 0
wpnlast:        dc.b 0

wpn_cost:       dc.b "COST:",0
wpn_credits:    dc.b "CREDITS:",0
wpn_exittext:   dc.b "EXIT",0

wpn_tbl:        dc.b ITEM_9MM_PISTOL,0,25,0             ;Weaponshop items
                dc.b ITEM_ELECTRONIC_STUN_GUN,0,30,0
                dc.b ITEM_SHOTGUN,0,40,0
                dc.b ITEM_DARTGUN,0,50,0
                dc.b ITEM_44_MAGNUM_PISTOL,0,50,0
                dc.b ITEM_FRAG_GRENADE,1,5,0
                dc.b ITEM_CHARGE_CELLS,10,5,0
                dc.b ITEM_9MM_AMMO,15,5,0
                dc.b ITEM_12GAUGE_AMMO,10,5,0
                dc.b ITEM_44MAGNUM_AMMO,10,7,0
                dc.b ITEM_556_AMMO,15,7,0
                dc.b ITEM_762_AMMO,10,10,0
                dc.b ITEM_DARTS,10,10,0
                dc.b ITEM_MEDIKIT,1,10,0
                dc.b 0,0,0,0

                dc.b ITEM_BEER,1,2,0                    ;Hades Club items
                dc.b 0,0,0,0

;-------------------------------------------------------------------------------
; $0205 - Bartender
;-------------------------------------------------------------------------------

bartender:      lda #15*4
                sta wpnselect
                sta wpnfirst
                lda #17*4
                sta wpnlast
                jmp wpn_common

;-------------------------------------------------------------------------------
; $0206 - Breakin in Ian's home by SCEPTRE grunts
;-------------------------------------------------------------------------------

breakin:        lda #PLOT_SCEPTRE_ENTERED
                jsr checkplotbit
                bne breakin_ok
                lda aonum
                jmp deactivateobject    ;Let trigger happen again later
                                        ;when we're ready :)

breakin_ok:     lda #SPRF_GRUNT         ;Preload
                jsr loadsprites
                lda #SFX_GLASS
                jsr playsfx
                ldx #$01                ;Break glass, unhide grunts
                lda #$07
                jsr activateobject
                ldx #$01
                lda #$08
                jmp activateobject

;-------------------------------------------------------------------------------
; $0207 - Axesmith
;-------------------------------------------------------------------------------

axesmith:       givepoints 5000
                say l_as1
                plrsay l_as2
                say l_as3
                plrsay l_as4
                say l_as5
                removetrigger ACT_AXESMITH
                stop

l_as1:          dc.b 34,"HEY IAN. QUIET HERE, SEEMS THE RIOTING HAS SCARED PEOPLE INSIDE. "
                dc.b "YOU DON'T LOOK TOO HAPPY..?",34,0
l_as2:          dc.b 34,"EVERYTHING WAS FINE A MOMENT AGO. THEN IT TOOK A TURN FOR THE WORSE. A LOT WORSE.",34,0
l_as3:          dc.b 34,"IT'S BEST I DON'T ASK FOR DETAILS?",34,0
l_as4:          dc.b 34,"I'D APPRECIATE THAT.",34,0
l_as5:          dc.b 34,"TAKE CARE.",34,0

                endscript
