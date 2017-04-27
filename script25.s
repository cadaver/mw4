;
; Script 25: Joan as Agent + Sabotage
;
                include scriptm.s

                entrypoint joanagent    ;$1900
                entrypoint joandeath    ;$1901
                entrypoint leftbutton   ;$1902
                entrypoint meltdowninit  ;$1903
                entrypoint meltdowncountdown ;$1904
                entrypoint computer ;$1905

;-------------------------------------------------------------------------------
;$1900
;-------------------------------------------------------------------------------

ja_down:        lda actlastdmghp,x              ;Dead?
                bpl ja_notdead
                setbit PLOT_JOAN_DEAD
                lda scriptf                     ;Continuous script executing?
                bne ja_noscript                 ;If yes, do not disturb
                lda #25
                sta agentdelay
                setscript SCRIPT_JOANDEATH      ;Then the lamentation after 1
ja_noscript:
ja_notdead:     stop                            ;sec. delay..

joanagent:      choice T_CONV,ja_conv
                choice T_TAKEDOWN,ja_down
ja_setcomrade:  lda #ACT_JOANAGENT
                sta comradeagent
ja_convskip:    stop

ja_getout:      say l_getout
                stop
l_getout:       dc.b 34,"HAVE TO GET OUT OF HERE!",34,0

ja_conv:        getbit PLOT_MELTDOWN_DONE
                jumptrue ja_convnoreactor
                getbit PLOT_MELTDOWN_INITIATED
                jumptrue ja_getout
                lda levelnum            ;In IAC level?
                cmp #22
                bne ja_convnoreactor
                lda zonenum             ;In reactor room?
                cmp #$0a
                bne ja_convnoreactor
                getbit PLOT_REACTOR_WEAKNESS
                jumpfalse ja_convnoreactor
                jmp ja_convreactor
ja_convnoreactor:
                jsr isincombat
                bcs ja_convskip
                jsr random
                and #$07
                selectline l_jarandom
                saynoptr
                stop
l_jarandom:     dc.w l_jarandom0
                dc.w l_jarandom1
                dc.w l_jarandom2
                dc.w l_jarandom3
                dc.w l_jarandom4
                dc.w l_jarandom5
                dc.w l_jarandom6
                dc.w l_jarandom7

l_jarandom0:    dc.b 34,"MAYBE OBSKURIUS AND SATANAKHIA ARE STILL ALIVE..",34,0
l_jarandom1:    dc.b 34,"DISGUSTING HOW SCEPTRE HAS TWISTED SENTINEL TECHNOLOGY FOR THEIR OWN USE.",34,0
l_jarandom2:    dc.b 34,"THE SENTINELS ARE AGAINST ALL VIOLENCE. BUT IS THERE A CHOICE, AGAINST SCEPTRE?",34,0
l_jarandom3:    dc.b 34,"THE SENTINELS SAID WE SHOULD REACH FOR HIGHER AWARENESS.",34,0
l_jarandom4:    dc.b 34,"WE'LL HAVE QUITE SOME EVIDENCE TO SHOW THE WORLD.",34,0
l_jarandom5:    dc.b 34,"THIS SHOULD INSPIRE ONE HELL OF A SONG.",34,0
l_jarandom6:    dc.b 34,"WHAT IS IT WITH THESE CONSPIRATORS? DON'T THEY HAVE BETTER THINGS TO DO?",34,0
l_jarandom7:    dc.b 34,"WE'LL MAKE IT THROUGH, DON'T YOU THINK?",34,0

ja_convreactor: getbit PLOT_REACTOR_DISCUSSION
                jumptrue ja_convreactor2
                setbit PLOT_REACTOR_DISCUSSION
                plrsay l_jareact0
                say l_jareact1
                plrsay l_jareact2
                say l_jareact3
                plrsay l_jareact4
                say l_jareact5
ja_convreactor2:say l_jareact6
                setdomulti %00000011, l_jareact7m
                choice 0,ja_reactorgoahead
ja_reactorcancel:
                lda #ACT_JOANAGENT
                sta comradeagent
                stop
ja_reactorgoahead:
                say l_jareact8
                lda #$00                ;Abort comradeagent-routine
                sta comradeagent
                lda #$6d                ;Joan takes right button
                sta waypointxh
                lda #$1f
                sta waypointyh
                focus ACT_JOANAGENT
                bcc ja_rgafail
                lda #M_GOTO
                sta actmode,x
                lda #WAYPOINT0
                sta acttarget,x
ja_rgafail:     rts

l_jareact0:     dc.b 34,"THERE MIGHT BE A WAY TO BLOW UP THIS REACTOR.",34,0
l_jareact1:     dc.b 34,"GO AHEAD.",34,0
l_jareact2:     dc.b 34,"IF BOTH CIRCUITS ARE FLUSHED AT THE SAME TIME, SOMETHING MIGHT HAPPEN.",34,0
l_jareact3:     dc.b 34,"WE PRESS THESE BUTTONS AT THE EXACT SAME MOMENT?",34,0
l_jareact4:     dc.b 34,"THAT'S WHAT I'D GUESS.",34,0
l_jareact5:     dc.b 34,"AND AFTER THAT, WE GET THE HELL OUT OF HERE.",34,0
l_jareact6:     dc.b 34,"SHOULD WE DO IT NOW?",34,0
l_jareact7m:    dc.w l_jareact7m0
                dc.w l_jareact7m1
l_jareact7m0:   dc.b 34,"LET'S TRY IT.",34,0
l_jareact7m1:   dc.b 34,"I'M NOT READY YET.",34,0
l_jareact8:     dc.b 34,"I'LL TAKE THE RIGHT.",34,0
l_jareact9:     dc.b 34,"1.. 2.. 3.. NOW!",34,0

l_janotmanual:  dc.b 34,"NOTHING'S HAPPENING.",34,0

;-------------------------------------------------------------------------------
;$1901
;-------------------------------------------------------------------------------

joandeath:      lda acthp+ACTI_PLAYER   ;Player must be alive..
                beq jd_stop
                dec agentdelay
                bne jd_notyet
                plrsay l_jd0
                plrsay l_jd1
jd_stop:        stopscript
jd_notyet:      stop

l_jd0:          dc.b 34,"JOAN! NO..",34,0
l_jd1:          dc.b 34,"THEY WILL REGRET THIS..",34,0

;-------------------------------------------------------------------------------
;$1902
;-------------------------------------------------------------------------------

leftbutton:     lda aonum       ;Make sure: left button
                cmp #$21
                bne sabotagefail
                getbit PLOT_MELTDOWN_INITIATED
                jumptrue sabotagefail   ;Already melting down..
                focus ACT_JOANAGENT
                bcc sabotagefail
                lda actxh,x ;Standing at the button?
                cmp #$6d
                bne sabotagefail
                lda actyh,x
                cmp #$1f
                bne sabotagefail
                plrsay l_jareact9
                ldx actrestx
                lda #$22
                jsr activateobject
                lda reactormode         ;Both manual override?
                and reactormode+1
                bne sabotage_manualok
                say l_janotmanual
                jmp sabotagefail

sabotage_manualok:
                givepoints 10000
                lda #50                 ;Two seconds to PA announce
                sta meltdowndelay
                lda #ACT_JOANAGENT
                sta comradeagent        ;Follow!
                setbit PLOT_MELTDOWN_INITIATED
                setscript SCRIPT_MELTDOWNINIT
                clearbit PLOT_MAP_ALLOWED ;Mapentry not allowed
                                        ;(player wouldn't get far away enough
                                        ;from the blast, anyway)
                lda #SFX_SHUTDOWN
                jsr playsfx
sabotagefail:   lda #SFX_OBJECT
                jmp playsfx

;-------------------------------------------------------------------------------
;$1903
;-------------------------------------------------------------------------------

mdi_ok:         stop
meltdowninit:   dec meltdowndelay
                bne mdi_ok
                lda #SFX_TRANSMISSION
                jsr playsfx
                saytrans mdi_text
                lda #2
                sta meltdownmin
                lda #0
                sta meltdownsec
                setscript SCRIPT_MELTDOWNCOUNTDOWN
                stop

mdi_text:       dc.b "PA VOICE - ",34,"REACTOR UNSTABLE. 2 MINUTES TO MELTDOWN.",34,0

;-------------------------------------------------------------------------------
;$1904
;-------------------------------------------------------------------------------

meltdowncountdown:
                lda levelnum    ;Check for escape from blast radius
                cmp #18         ;(only possible escape is the Hub)
                bne mdcd_goon

mdcd_exit:      jsr resetmessage
                givepoints 10000
                setbit PLOT_MELTDOWN_DONE
                lda #$0b ;Close IAC project door
                jsr deactivateobject
                lda #PLOT_MAP_IAC ;Can't go there, the place's destroyed! :)
                jsr clearplotbit
                setbit PLOT_MAP_ALLOWED ;Mapentry allowed again
                focus ACT_JOANAGENT
                bcc mdcd_mia            ;Missing in action
                say l_mdcdmadeit
                jmp mdcd_skip
mdcd_mia:       setbit PLOT_JOAN_DEAD
                plrsay l_mdcdalone
mdcd_skip:      jumpto SCRIPT_DESTRUCTION


mdcd_nosec:     stop
mdcd_goon:      lda levelnum
                cmp #22 ;Alerts begin flashing in IAC project..
                bne mdcd_noflash
                lda meltdownmin         ;Time has run out, allow deadwhiteness :)
                bmi mdcd_noflash
                lda zonenum
                sta zoneflash
mdcd_noflash:   inc meltdowndelay
                lda meltdowndelay
                cmp #25
                bcc mdcd_nosec
                lda #$00
                sta meltdowndelay
                dec meltdownsec
                bpl mdcd_timedone
                lda #59
                sta meltdownsec
                dec meltdownmin
                bpl mdcd_timedone
                lda #$00
                sta meltdownsec
                jmp mdcd_dieinexplosion
mdcd_timedone:  jsr resetmessage
                lda meltdownmin
                ora #$30
                sta textscreen+21*40+9
                lda #":"
                sta textscreen+21*40+10
                lda meltdownsec
                ldy #10
                ldx #temp1
                jsr divu
                tay
                lda temp1
                ora #$30
                sta textscreen+21*40+11
                tya
                ora #$30
                sta textscreen+21*40+12
                rts
mdcd_dieinexplosion:
                jsr resetmessage
                lda meltdownmin
                cmp #$fe
                beq mdcd_die2
                ldx zonenum
                lda #$0c        ;All is deadwhite..
                sta zonebg1,x
                lda #$0f
                sta zonebg2,x
                lda #$01
                sta zonebg3,x
                lda #NUMZONES-1
                sta zoneflash
                lda #SFX_EXPLOSION
                jsr playsfx
                ldx #NUMCOMPLEXACT-1 ;Kill all actors
killall:        lda acthp,x
                beq killallskip
                lda actgrp,x
                bmi killallskip ;Except lift
                lda #$ff        ;Dead!
                sta actlastdmghp,x
                jsr killactor
killallskip:    dex
                bpl killall
mdcd_dieskip:   rts
mdcd_die2:      jsr cleartextscreen ;All is black..
                stopscript
                stop

l_mdcdmadeit:   dc.b 34,"WE MADE IT.",34,0
l_mdcdalone:    dc.b 34,"JOAN.. IT'LL BE YOUR FUNERAL PYRE.",34,0

;-------------------------------------------------------------------------------
;$1905
;-------------------------------------------------------------------------------

computer:       ldx #$00
                lda aonum
                cmp #$53
                beq leftcomputer
                inx
leftcomputer:   stx compnum
                txa
                clc
                adc #"1"
                sta comptext+8
                jsr menu_inactivatecounter
                jsr resetmessage
comp_redraw:    lda #SFX_SELECT
                jsr playsfx
                lda #<comptext
                ldy #>comptext
                ldx #9
                jsr printpaneltext
                ldx #49
                jsr printpaneltextcont
                ldx compnum
                ldy reactormode,x
                ldx compcursortbl,y
                lda #37
                sta textscreen+21*40,x
comp_loop:      jsr menu_control
                lda temp1
                and #$80+JOY_FIRE
                bne comp_exit
                lda temp1
                and #$0f
                beq comp_loop
comp_move:      ldx compnum
                lda reactormode,x
                eor #$01
                sta reactormode,x
                jmp comp_redraw
comp_exit:      lda #SFX_SELECT
                jsr playsfx
                jmp resetmessage

compcursortbl:  dc.b 49,60
compnum:        dc.b 0

comptext:       dc.b "CIRCUIT 1 OPERATION",0
                dc.b " AUTOMATIC  MANUAL",0


                endscript
