;
; MW4 Scriptfile 12: Teleport & beyond
;

                include scriptm.s

                entrypoint code1                ;$c00
                entrypoint code2                ;$c01
                entrypoint code3                ;$c02
                entrypoint teleport             ;$c03
                entrypoint teleportdest         ;$c04
                entrypoint guardian             ;$c05
                entrypoint exitdoor             ;$c06
                entrypoint councildead          ;$c07
                entrypoint obskuriusterminal    ;$c08
                entrypoint generator1           ;$c09
                entrypoint generator2           ;$c0a
                entrypoint shutdownmsg          ;$c0b
                entrypoint iacnotify            ;$c0c
                entrypoint joanbeforeteleport   ;$c0d

;-------------------------------------------------------------------------------
; $0c00,$0c01,$0c02
;-------------------------------------------------------------------------------

code1:          jsr codestart
                lda #<code1text
                ldy #>code1text
                jsr printscreentext
                ldy #$00
codeend:        lda teleportcode,y
               ; sta teleportselect,y
                jsr mfn_sub                     ;Abuse the loader
                sta textscreen+4*40+10
                lda #MSGTIME_ETERNAL
                jsr waitforfire
                jmp endfullscreen

codestart:      jsr beginfullscreen
                jsr border
                lda #<codecommontext
                ldy #>codecommontext
                jmp printscreentext

code2:          jsr codestart
                lda #<code2text
                ldy #>code2text
                jsr printscreentext
                ldy #$01
                jmp codeend

code3:          jsr codestart
                lda #<code3text
                ldy #>code3text
                jsr printscreentext
                ldy #$02
                jmp codeend


                           ;12345678901234567890123456789012345678
code1text:      dc.b 1,1,1,"TO: CMD@GLOBALINF.INNER",0
                dc.b 28,3,1,"FIRST KEY,",0,$ff

                           ;12345678901234567890123456789012345678
code2text:      dc.b 1,1,1,"TO: CMD@BLACKOPS.INNER",0
                dc.b 28,3,1,"SECOND KEY,",0,$ff

                           ;12345678901234567890123456789012345678
code3text:      dc.b 1,1,1,"TO: CMD@IACPROJECT.INNER",0
                dc.b 28,3,1,"THIRD KEY,",0,$ff

codecommontext: dc.b 1,0,1,"FROM: PRIESTS@CNTRL",0
                dc.b 1,3,1,"YOU ARE ENTRUSTED WITH THE",0
                dc.b 1,4,1,"WHICH IS  .",0,$ff

;-------------------------------------------------------------------------------
; $0c03,$c04
;-------------------------------------------------------------------------------

teleport:       lda #ACT_EXOSKELETON    ;Is the Exoskeleton still alive?
                jsr findactor
                bcc teleport_ok
                lda #<lockdowntext
                ldx #>lockdowntext
                ldy #MSGTIME
                jmp printmsgax
teleport_ok:    lda #$80                ;Turn left towards console
                sta actd+ACTI_PLAYER
                jsr menu_inactivatecounter
                lda #$00
                sta tpselect
                jsr resetmessage
teleport_redraw:lda #SFX_SELECT
                jsr playsfx
                lda #<teleporttext
                ldy #>teleporttext
                jsr menutitle
                ldy tpselect
                ldx teleportcursortbl,y
                lda #37
                sta textscreen+21*40,x
                lda teleportselect
                jsr mfn_sub
                sta textscreen+21*40+50
                lda teleportselect+1
                jsr mfn_sub
                sta textscreen+21*40+53
                lda teleportselect+2
                jsr mfn_sub
                sta textscreen+21*40+56
teleport_loop:  jsr increaseclock
                jsr menu_control
                ldx tpselect
                lda temp1
                lsr
                bcs teleport_up
                lsr
                bcs teleport_down
                lsr
                bcs teleport_left
                lsr
                bcs teleport_right
                lda temp1
                and #JOY_FIRE
                bne teleport_select
                beq teleport_loop
teleport_up:    inc teleportselect,x
                lda teleportselect,x
                cmp #$0a
                bcc teleport_updownok
                lda #$00
teleport_updown:sta teleportselect,x
teleport_updownok:
                jmp teleport_redraw
teleport_down:  dec teleportselect,x
                bpl teleport_updownok
                lda #$09
                jmp teleport_updown
teleport_left:  dec tpselect
                lda tpselect
                bpl teleport_leftright
                lda #$04
teleport_leftright:
                sta tpselect
                jmp teleport_redraw
teleport_right: inc tpselect
                lda tpselect
                cmp #$05
                bcc teleport_leftright
                lda #$00
                beq teleport_leftright
teleport_select:lda #SFX_SELECT
                jsr playsfx
                lda tpselect
                cmp #$03
                bcc teleport_loop
                bne teleport_go
teleport_abort: jmp resetmessage

teleport_go:    jsr resetmessage
                jsr teleport_effect
                ldy #$02
teleport_compare:
                lda teleportselect,y
                cmp teleportcode,y
                bne teleport_fail
                dey
                bpl teleport_compare
teleport_success:
                givepoints 10000
                lda #$01
                sta zonebg1+1
                sta zonebg2+1
                sta zonebg3+1
                lda #$09
                jsr cts_setcolors
                lda #SFX_TASER
                jsr playsfx
                jsr scriptupdateframe
                jsr scriptupdateframe
                jsr cleartextscreen
                lda #SFX_EXPLOSION
                jsr playsfx
                setscript SCRIPT_TELEPORTDEST
                lda #$02
                sta tpdelay
                lda #$00
                sta actd+ACTI_PLAYER
                sta comradeagent        ;Doublecheck that no other Agent
                                        ;follows..
                lda #$40
                ldx #$19
                jmp enterdoornum

teleport_fail:  lda #$00
                sta acthp+ACTI_PLAYER
                sta actbatt+ACTI_PLAYER
                ldx #ACTI_PLAYER
                lda #-64
                jsr moveactorydirect
                lda #$08
                ldy #$3f
                jsr makebigexplosion
                lda #ACT_NONE
                sta actt+ACTI_PLAYER
                rts

teleport_effect:
                lda #ACT_DOORHINT
                jsr findactor
                bcc teleport_nodoorhint
                jsr removeactor
teleport_nodoorhint:
                lda #$40
                sta tpdelay
teleport_effectloop:
                ldx #NUMACT-1
teleport_effectmoveact:
                lda actt,x              ;Move the shrapnel only
                cmp #ACT_SHRAPNEL
                bne teleport_effectmoveskip
                jsr mvact_sub2
teleport_effectmoveskip:
                dex
                bpl teleport_effectmoveact
                jsr menu_control
                lda tpdelay
                lsr
                and #$03
                tax
                lda tpflashtbl1,x
                sta zonebg2+1
                lda tpflashtbl2,x
                sta actfls+ACTI_PLAYER
                sta zonebg1+1
                lda tpflashtbl3,x
                sta zonebg3+1
                jsr random
                cmp #$30
                bcs teleport_nosound
                lda #SFX_TASER
                jsr playsfx
                ldx #ACTI_PLAYER
                jsr makeshrapnel
                lda #-127
                jsr spawnymod
teleport_nosound:
                dec tpdelay
                bne teleport_effectloop
                rts

menutitle:      ldx #9
                jsr printpaneltext
                ldx #49
                jmp printpaneltextcont

lockdowntext:   dc.b "SENTRY ACTIVE - CONSOLE LOCKED DOWN",0

teleporttext:   dc.b "ENTER DESTINATION CODE",0
                dc.b "          ABORT  START",0

teleportcursortbl:
                dc.b 49,52,55,58,65

tpflashtbl1:      dc.b 11,14,15,14
tpflashtbl2:      dc.b 14,15,1,15
tpflashtbl3:      dc.b 15,1,1,1

tpdelay:        dc.b 0
tpselect:       dc.b 0

teleportdest:   ldx tpdelay
                bmi teleportdestdone
                cpx #$02
                bne td_skipsound
                lda #SFX_EXPLOSION
                jsr playsfx
td_skipsound:   lda tpflashtbl1,x
                sta zonebg3
                lda tpflashtbl2,x
                sta actfls+ACTI_PLAYER
                sta zonebg2
                lda tpflashtbl3,x
                sta zonebg1
                dec tpdelay
                stop
teleportdestdone:
                lda zonebg1+1
                sta zonebg1
                lda zonebg2+1
                sta zonebg2
                lda zonebg3+1
                sta zonebg3
                dec tpdelay
                lda tpdelay
                cmp #255-25
                beq teleportdestdone2
                stop
teleportdestdone2:
                lda #SFX_TRANSMISSION
                jsr playsfx
                saytrans l_tdd0
                plrsay l_tdd1
                stopscript
                stop

l_tdd0:         dc.b "PA VOICE - ",34,"INTRUDER DETECTED. TELEPORT SHUTTING DOWN.",34,0
l_tdd1:         dc.b 34,"GREAT. HOW WILL I GET OUT NOW?",34,0

;-------------------------------------------------------------------------------
; $0c05
;-------------------------------------------------------------------------------

guardian:       choice T_APPEAR,guardian_appear
                choice T_REMOVE,guardian_remove
guardian_takedown:
                lda actt,x
                jsr removeactortrigger
guardian_remove:
                jmp playzonetune

guardian_appear:lda tunenum
                and #$fc
                ora #$03
                jmp playgametune

;-------------------------------------------------------------------------------
; $0c06
;-------------------------------------------------------------------------------

exitdoor:       lda #SFX_OBJECT
                jsr playsfx
                saytrans exitdoortext
                stop

exitdoortext:   dc.b "EMERGENCY EXIT TUNNEL",0

;-------------------------------------------------------------------------------
; $0c07
;-------------------------------------------------------------------------------

councildead:    lda #$00
                sta acthp,x
                rts

;-------------------------------------------------------------------------------
; $0c08
;-------------------------------------------------------------------------------

ot_offline:     lda #SFX_OBJECT
                jsr playsfx
                lda #<ot_offlinetext
                ldx #>ot_offlinetext
                ldy #MSGTIME
                jmp printmsgax

obskuriusterminal:
                jsr menu_inactivatecounter
                jsr resetmessage
                getbit PLOT_OBSKURIUS_OFFLINE
                bne ot_offline
                lda #<ot_text
                ldy #>ot_text
                jsr shutdownsub
                beq ot_skip
                lda #SFX_SHUTDOWN
                jsr playsfx
                ldx #$01
                lda #$1c
                jsr activateobject
                lda #ACT_OBSKURIUSHEAD
                jsr findactor
                bcc ot_skip
                lda #$00
                sta acthp,x     ;Obskurius dies..
                setbit PLOT_OBSKURIUS_OFFLINE
ot_skip:        rts



shutdownsub:    sta ot_redrawptrl+1
                sty ot_redrawptrh+1
                lda #$00
                sta otselect
ot_redraw:      lda #SFX_SELECT
                jsr playsfx
ot_redrawptrl:  lda #<ot_text
ot_redrawptrh:  ldy #>ot_text
                ldx #9
                jsr printpaneltext
                lda #<ot_choicetext
                ldy #>ot_choicetext
                ldx #49
                jsr printpaneltext
                ldy otselect
                ldx otcursortbl,y
                lda #37
                sta textscreen+21*40,x
ot_loop:        jsr increaseclock
                jsr menu_control
                lda temp1
                and #$0f
                bne ot_move
                lda temp1
                and #JOY_FIRE
                bne ot_select
                beq ot_loop
ot_move:        lda otselect
                eor #$01
                sta otselect
                jmp ot_redraw
ot_exit:        jsr resetmessage
                lda #$00
                rts
ot_select:      lda #SFX_SELECT
                jsr playsfx
                lda otselect
                beq ot_exit
                jsr ot_confirm
                bne ot_exit
                jsr resetmessage
                lda #$01
                rts

ot_confirm:     lda #$01        ;Assume "no"
                sta otselect
                jsr menu_inactivatecounter
                jsr resetmessage
otc_redraw:     lda #SFX_SELECT
                jsr playsfx
                lda #<otc_text
                ldy #>otc_text
                jsr menutitle
                ldy otselect
                ldx otccursortbl,y
                lda #37
                sta textscreen+21*40,x
otc_loop:       jsr increaseclock
                jsr menu_control
                lda temp1
                and #$0f
                bne otc_move
                lda temp1
                and #JOY_FIRE
                bne otc_select
                beq otc_loop
otc_move:       lda otselect
                eor #$01
                sta otselect
                jmp otc_redraw
otc_select:     jsr resetmessage
                lda otselect
                rts

ot_offlinetext: dc.b "OFFLINE",0

ot_text:        dc.b "EXPERIMENTAL STATION",0
ot_choicetext:  dc.b " EXIT  SHUTDOWN",0

otc_text:       dc.b "CONFIRM SHUTDOWN",0
                dc.b " YES  NO",0

otcursortbl:    dc.b 49,55
otccursortbl:   dc.b 49,54

otselect:       dc.b 0

;-------------------------------------------------------------------------------
; $0c09,$0c0a,$0c0b
;-------------------------------------------------------------------------------

generator1_offline:
                jmp ot_offline

cbo_skip:
g1_skip:        rts
generator1:
                jsr menu_inactivatecounter
                jsr resetmessage
                getbit PLOT_GENERATOR1_OFFLINE
                bne generator1_offline
                lda #<gtext1
                ldy #>gtext1
                jsr shutdownsub
                beq g1_skip
                givepoints 10000
                lda #SFX_SHUTDOWN
                jsr playsfx
                setbit PLOT_GENERATOR1_OFFLINE
checkbothoffline:
                getbit PLOT_GENERATOR1_OFFLINE
                beq cbo_skip
                getbit PLOT_GENERATOR2_OFFLINE
                beq cbo_skip
                ldx #$11
cbo_zoneloop:   lda zonebg2,x      ;Plunge into darkness
                sta zonebg1,x
                lda zonebg3,x
                sta zonebg2,x
                lda #$00
                sta zonebg3,x
                dex
                bpl cbo_zoneloop
                lda #$38        ;Open exit, kill the council
                jsr cbo_activate
                lda #$33
                jsr cbo_activate
                lda #$34
                jsr cbo_activate
                lda #$35
                jsr cbo_activate
                lda #$36
                jsr cbo_activate
                lda #$1c
                jsr cbo_activate ;Obskurius dies also..
                settrigger ACT_OBSKURIUSHEAD,SCRIPT_COUNCILDEAD,T_APPEAR
                settrigger ACT_COUNCILHEADM,SCRIPT_COUNCILDEAD,T_APPEAR
                settrigger ACT_COUNCILHEADF,SCRIPT_COUNCILDEAD,T_APPEAR
                getbit PLOT_JOAN_MET
                beq cbo_skip2
                lda #25
                sta temp7
                ldx #$3e                        ;Appearance at the escape
                ldy #$1f                        ;tunnel
                lda #ACT_JOANAGENT
                jsr transportactor
                settrigger ACT_JOANAGENT,SCRIPT_JOANFINAL,T_NEAR|T_APPEAR|T_REMOVE|T_TAKEDOWN
cbo_skip2:      lda #$00
                sta agentdelay
                setscript SCRIPT_SHUTDOWNMSG
                rts

cbo_activate:   ldx #$01
                jmp activateobject

generator2_offline:
                jmp ot_offline
generator2:
                jsr menu_inactivatecounter
                jsr resetmessage
                getbit PLOT_GENERATOR2_OFFLINE
                bne generator2_offline
                lda #<gtext2
                ldy #>gtext2
                jsr shutdownsub
                beq g2_skip
                givepoints 10000
                lda #SFX_SHUTDOWN
                jsr playsfx
                setbit PLOT_GENERATOR2_OFFLINE
                jmp checkbothoffline
g2_skip:        rts

gtext1:         dc.b "POWER GENERATOR 1",0

gtext2:         dc.b "POWER GENERATOR 2",0

shutdownmsg:    inc agentdelay
                lda agentdelay
                cmp #25
                bcc sdm_skip
                stopscript
                lda #SFX_TRANSMISSION
                jsr playsfx
                saytrans sdm_text
sdm_skip:       stop
sdm_text:       dc.b "PA VOICE - ",34,"POWER FAILURE - EMERGENCY EXIT OPEN.",34,0

;-------------------------------------------------------------------------------
; $0c0c
;-------------------------------------------------------------------------------

iacnotify:      lda #$4e
                jsr setlvlobjstat
                lda #$4f
                jsr setlvlobjstat
                lda #$50
                jsr setlvlobjstat
                lda #$51
                jsr setlvlobjstat       ;Deactivate rest of triggers
                givepoints 10000
                plrsay l_iacmsg
                stop
l_iacmsg:       dc.b 34,"THAT'S THE SAME KIND OF CRAFT THAT ATTACKED ME..",34,0

;-------------------------------------------------------------------------------
; $0c0d
;-------------------------------------------------------------------------------

joanbeforeteleport:
                focus ACT_EXOSKELETON ;Exoskeleton still alive?
                bcs jbt_skip
                focus ACT_JOANAGENT
                bcc jbt_skip
                lda acthp,x
                beq jbt_skip
                lda comradeagent        ;Conversation done?
                beq jbt_skip
                removetrigger ACT_JOANAGENT
                lda #M_TURNTOTARGET
                sta actmode,x
                plrsay l_grc1
                say l_grc2
                plrsay l_grc3
                say l_grc4
                lda #$00
                sta comradeagent
jbt_skip:       stop

l_grc1:         dc.b 34,"THIS WILL TAKE US TO THE CENTRAL FACILITY.",34,0
l_grc2:         dc.b 34,"A TELEPORT?",34,0
l_grc3:         dc.b 34,"DO YOU OPPOSE IF I GO FIRST?",34,0
l_grc4:         dc.b 34,"JUST BE CAREFUL.",34,0





                endscript
