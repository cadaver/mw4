;
; Script 26: Result of the sabotage, other things nearing the end..
;

                include scriptm.s

                entrypoint destruction    ;$1a00
                entrypoint destructionrun ;$1a01
                entrypoint joanfinal ;$1a02
                entrypoint endsequence ;$1a03
                entrypoint lilithend    ;$1a04
                entrypoint lilithfight ;$1a05
                entrypoint joandeath2 ;$1a06

;-------------------------------------------------------------------------------
;$1a00
;-------------------------------------------------------------------------------

destruction:    jsr removeallactors
                lda #22                         ;Load IAC level
                ldx #LLMODE_NORMAL
                jsr loadlevel
                lda #ACT_OBSERVER               ;Player as invisible
                sta actt+ACTI_PLAYER            ;observer
                lda #$00                        ;Don't switch music
                sta zonemusic+2
                sta actd+ACTI_PLAYER            ;Face right
                sta actgrp+ACTI_PLAYER          ;Belong to civilians..
                sta agentcounter
                sta agentdelay
                sta comradeagent
                setscript SCRIPT_DESTRUCTIONRUN
                lda #$56                ;Transport into the middle of
                ldx #22                 ;destruction..
                jmp enterdoornum

;-------------------------------------------------------------------------------
;$1a01
;-------------------------------------------------------------------------------

destructionrun: ldy agentdelay
                beq dr_colorok
                dec agentdelay
dr_colorok:     ldx zonenum
                lda expltbl1,y
                sta zonebg1,x
                lda expltbl2,y
                sta zonebg2,x
                lda expltbl3,y
                sta zonebg3,x
                jsr random
                cmp #$80
                bcs dr_noexpl
                lda #$03
                sta agentdelay
                ldx #NUMCOMPLEXACT-1 ;Kill all actors
killall:        lda acthp,x
                beq killallskip
                lda actgrp,x
                bmi killallskip ;Except lift
                lda #$ff        ;Dead!
                sta actlastdmghp,x
                jsr killactor
killallskip:    dex
                bne killall ;Don't kill player :)
                jsr random
                and #$07
                sec
                adc mapx
                sta bigexplxh
                jsr random
                and #$03
                sec
                adc mapy
                sta bigexplyh
                lda #$00
                sta bigexplxl
                sta bigexplyl
                lda #3
                sta bigexplcount
                lda #$7f
                sta bigexplradius
dr_noexpl:      inc agentcounter
                lda agentcounter
                cmp #25*4               ;Show 4 seconds of total destruction
                bcs dr_done
                rts
dr_done:        ldx #ACTI_PLAYER
                lda #ACT_IANAGENT
                sta actt,x
                lda #GRP_AGENTS
                sta actgrp,x            ;Belong to agents again..
                lda #$80
                sta actd,x
                stopscript
                lda #$0a                ;Transport back..
                ldx #$12
                jmp enterdoornum

expltbl1:       dc.b $00,$0b,$0c,$0f
expltbl2:       dc.b $0b,$0c,$0f,$01
expltbl3:       dc.b $0c,$0f,$01,$01


;-------------------------------------------------------------------------------
;$1a02
;-------------------------------------------------------------------------------

joanfinal:      choice T_APPEAR,jf_setcomrade
                choice T_NEAR,jf_finalconv
                choice T_REMOVE,jf_removecomrade
                choice T_TAKEDOWN,jf_down
                stop
jf_removecomrade:
                lda actxh+ACTI_PLAYER    ;If player exiting left in the
                bne jf_rcskip           ;escapetunnel, do not follow
                sta comradeagent        ;(possibility of sprite memory
jf_rcskip:      stop                    ;allocator running out)

jf_down:        setbit PLOT_JOAN_DEAD
                setscript SCRIPT_JOANDEATH2 ;Different lamentation at the end
                stop

jf_setcomrade:  lda #ACT_JOANAGENT
                sta comradeagent
                stop
jf_finalconv:   lda actsy,x     ;Wait for hitting ground
                bne jf_finalconvskip
                settrigger ACT_JOANAGENT,SCRIPT_JOANFINAL,T_APPEAR|T_REMOVE|T_TAKEDOWN
                say l_jf0
                plrsay l_jf1
                say l_jf2
                plrsay l_jf3
                say l_jf4
jf_finalconvskip:
                stop

l_jf0:          dc.b 34,"DID I MISS SOMETHING? THE TELEPORT SHUT DOWN.",34,0
l_jf1:          dc.b 34,"I SAW THE MOST SECTARIAN ELITE.. AND LORD OBSKURIUS' HEAD.",34,0
l_jf2:          dc.b 34,"OH.. SOME CRUEL EXPERIMENT?",34,0
l_jf3:          dc.b 34,"YEAH. MAY HE AND SATANAKHIA REST IN PEACE. "
                dc.b "BUT HOW DID YOU GET HERE?",34,0
l_jf4:          dc.b 34,"RESEARCHED SOME SCEPTRE ARCHIVES, AND FOUND TUNNELS THAT WEREN'T SUPPOSED TO GO ANYWHERE. THE EXIT IS UP AHEAD.",34,0

;-------------------------------------------------------------------------------
; $1a03
;-------------------------------------------------------------------------------

endsequence:    setscript SCRIPT_ENDSEQUENCERUN
                removetrigger ACT_BLOWFISH      ;Remove triggers as necessary..
                jsr cleartextscreen
                lda #SPRF_ENEMYAGENT
                jsr purgesprites
                lda #SPRF_PRIEST
                jsr purgesprites
                lda #SPRF_HOVERCAR
                jsr loadsprites ;Precache..
                lda #SPRF_BLOWFISH
                jsr loadsprites
                lda #$01
                sta agentdelay
                sta agentcounter
                sta playerscripted
                lda #$ff                        ;Make sure player hates no-one
                sta actlastdmgact+ACTI_PLAYER
                lda #ACT_JOANAGENT              ;Check Joan: Forced addition
                ldx #ITEM_9MM_SUBMACHINEGUN      ;if necessary (missed the lift)
                jsr findactortype
                bcc es_skipja
                lda acthp,x                     ;If alive, remove weapon to
                beq es_skipja                   ;ease multiplexer's pain and
                lda #$00                        ;join the agent band..
                sta actwpn,x
                setbit PLOT_JOAN_JOIN

es_skipja:      lda #$00
                sta actmode+ACTI_PLAYER
                sta actbits+ACTI_PLAYER
                sta actctrl+ACTI_PLAYER
                ldx #$1a
                jmp enterdoornum ;Transport to endsequence

;-------------------------------------------------------------------------------
; $1a04
;-------------------------------------------------------------------------------

lilith_nonexistent:
                stop
lilithend:      focus ACT_LILITHBYSTD
                bcc lilith_nonexistent
                givepoints 10000
                say l_end0
                getbit PLOT_AHRIMAN_DEAD
                beq lilith_anotdead
                plrsay l_end1b
                say l_end2b
                jmp lilith_common
lilith_anotdead:plrsay l_end1a
                say l_end2a
lilith_common:  plrsay l_end3
                say l_end4
                setdomulti %00000011,l_end5m
                choice 0,lilith_surrender
                ;choice 1,lilith_fight
lilith_fight:   say l_end6b
lilith_fight2:  ldx actrestx
                lda #ACT_LILITH
                sta actt,x
                jsr initcomplexactor
                lda #ITEM_LASER_RIFLE
                sta actwpn,x
                lda #20
                sta actclip,x
                settrigger ACT_LILITH,SCRIPT_LILITHFIGHT,T_APPEAR|T_TAKEDOWN|T_REMOVE
                stop
lilith_surrender:
                focus ACT_JOANAGENT
                bcc lilith_alone
                jmp lilith_withjoan

lilith_alone:   focus ACT_LILITHBYSTD
                say l_end6a
                lda #ACT_IANCIVILIAN
                sta actt+ACTI_PLAYER
                lda #$00
                sta actbatt+ACTI_PLAYER
                sta plrarmor
                lda #SFX_OBJECT
                jsr playsfx
                lda #ACTI_LASTITEM              ;Try to get free actor
                ldy #ACTI_FIRSTITEM
                jsr getfreeactor
                bcc lilith_dropitem_done
                ldx #ACTI_PLAYER                ;Drop fakeitem (agent gear)
                lda #ACT_ITEM
                jsr spawnactor
                lda #-15*8                      ;Let the item fall from air
                jsr spawnymod
                lda #ITEM_FAKEAGENTGEAR
                sta actf1,y
lilith_dropitem_done:
                lda #$3b
                ldx #$01
                jmp activateobject ;Call elevator

l_end0:         dc.b 34,"WE MEET AGAIN. YOU HAVE BEEN EFFECTIVE.",34,0
l_end1a:        dc.b 34,"BUT YOU WANTED AHRIMAN DEAD? GUESS I DISAPPOINTED.",34,0
l_end1b:        dc.b 34,"AHRIMAN GOT WHAT HE DESERVED.",34,0
l_end2a:        dc.b 34,"DOESN'T MATTER. I SAW YOU CUT THE POWER - THE LOSS OF THE COUNCIL WILL BE DEVASTATING TO THE PRIESTS. THERE WILL BE CHANGES.",34,0
l_end2b:        dc.b 34,"YES.. I'M SURE YOU GOT YOUR REVENGE. AND IT WILL LEAD TO CHANGES. THE DELUSIONAL PRIESTS WILL LOSE THEIR POWER.",34,0
l_end3:         dc.b 34,"AND WHAT NOW?",34,0
l_end4:         dc.b 34,"I NEED YOUR AGENT GEAR - THE EVIDENCE IT HAS RECORDED. THEN YOU ARE FREE TO GO.",34,0
l_end5m:        dc.w l_end5m0
                dc.w l_end5m1
l_end5m0:       dc.b 34,"YOU CAN HAVE IT.",34,0
l_end5m1:       dc.b 34,"OVER MY DEAD BODY.",34,0
l_end6a:        dc.b 34,"WISE CHOICE. I WILL CALL THE EXIT ELEVATOR. UNLESS YOU ATTEMPT FURTHER "
                dc.b "ATTACKS AGAINST US, I WILL ENSURE YOU WILL BE LEFT "
                dc.b "ALONE. AND AS FOR TELLING STORIES - "
                dc.b "YOU'D BE JUST ANOTHER CONSPIRACY THEORIST.",34,0
l_end6b:        dc.b 34,"TOO BAD - I COULD HAVE GIVEN YOU A FUTURE.",34,0

lilith_withjoan:setbit PLOT_JOAN_CONFLICT
                say l_wj0
                focus ACT_LILITHBYSTD
                say l_wj1
                focus ACT_JOANAGENT
                say l_wj2
                focus ACT_LILITHBYSTD
                say l_wj3
                plrsay l_wj4
                focus ACT_LILITHBYSTD
                say l_wj5
                jmp lilith_fight2

l_wj0:          dc.b 34,"ARE YOU INSANE?",34,0
l_wj1:          dc.b 34,"HE'S CHOOSING THE ONLY SANE ALTERNATIVE.",34,0
l_wj2:          dc.b 34,"YOU WILL NEVER HAVE MINE.",34,0
l_wj3:          dc.b 34,"IF YOU CAN'T PERSUADE THIS YOUNG LADY, WE HAVE A PROBLEM.",34,0
l_wj4:          dc.b 34,"UNLIKELY.",34,0
l_wj5:          dc.b 34,"THEN I'M WASTING MY TIME.",34,0


;-------------------------------------------------------------------------------
; $1a05
;-------------------------------------------------------------------------------

lilithfight:    choice T_APPEAR,lilith_appear
                choice T_REMOVE,lilith_remove
lilith_takedown:
                lda #ITEM_LASER_RIFLE
                sta actwpn,x    ;Make sure laser rifle gets dropped
                lda actt,x
                jsr removeactortrigger
lilith_remove:  jmp playzonetune

lilith_appear:  lda tunenum
                and #$fc
                ora #$03
                jmp playgametune

;-------------------------------------------------------------------------------
; $1a06
;-------------------------------------------------------------------------------

joandeath2:     plrsay l_jd0
                stopscript
                stop

l_jd0:          dc.b 34,"NOT THIS CLOSE..!",34,0

                endscript
