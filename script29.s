;
; Script 29: Goat, Sadok
;

                include scriptm.s

                entrypoint goat                 ;$1d00
                entrypoint goatend              ;$1d01
                entrypoint goatendrun           ;$1d02
                entrypoint goatiac              ;$1d03
                entrypoint goat2                ;$1d04
                entrypoint goat3                ;$1d05
                entrypoint sadok                ;$1d06
                entrypoint goat4                ;$1d07

;-------------------------------------------------------------------------------
; $1d00 Goat conversation
;-------------------------------------------------------------------------------

goat:           settrigger ACT_GOATIAC,SCRIPT_GOATIAC,T_APPEAR|T_TAKEDOWN
                givepoints 10000
                say l_goat1
                plrsay l_goat2
                say l_goat3
                setdomulti %00000011,l_goat4m
                ;choice 0, goat_1
                choice 1, goat_2
goat_1:         say l_goat5a
                plrsay l_goat5
                say l_goat6
                jmp goat_common
goat_2:         say l_goat7
                plrsay l_goat10
goat_common:    plrsay l_goat11
                say l_goat12
                plrsay l_goat13
                say l_goat14
                plrsay l_goat15
                settrigger ACT_GOAT,SCRIPT_GOAT2,T_NEAR
                                    ;Spawn enemy troops + IAC
                lda #$36
                jsr activateobject
                lda #10
                sta agentdelay
                setscript SCRIPT_GOAT3
                stop

l_goat1:        dc.b 34,"IAN? HOW DID YOU FIND HERE? I TOLD NO-ONE.",34,0
l_goat2:        dc.b 34,"YOU MIGHT BE IN DANGER.",34,0
l_goat3:        dc.b 34,"I THINK I CAN DEFEND MYSELF. "
                dc.b "IF THE MILITARY TYPES TRY AGAIN..",34,0

l_goat4m:       dc.w l_goat4m0
                dc.w l_goat4m1
l_goat4m0:      dc.b 34,"A CULT, SCEPTRE, WAS BEHIND THEM.",34,0
l_goat4m1:      dc.b 34,"I WAS ATTACKED BY AN ALIEN CRAFT.",34,0

l_goat5a:       dc.b 34,"A CULT? CURIOUS.",34,0
l_goat5:        dc.b 34,"THEY ARE OPPOSED BY THE AGENTS OF METAL, WHOM I HAVE JOINED.",34,0
l_goat6:        dc.b 34,"EVEN MORE CURIOUS.",34,0

l_goat7:        dc.b 34,"I'VE HAD MY SUSPICIONS OF THEIR EXISTENCE..",34,0
l_goat10:       dc.b 34,"AFTERWARDS I JOINED THE AGENTS OF METAL, WHO EXPLORE CONSPIRACIES AND UNNATURAL PHENOMENA.",34,0

l_goat11:       dc.b 34,"YOU MIGHT FIND THIS GROUP INTERESTING.",34,0
l_goat12:       dc.b 34,"DON'T KNOW, I'M QUITE FED UP WITH PEOPLE.",34,0
l_goat13:       dc.b 34,"I WON'T TRY TO FORCE YOU.",34,0
l_goat14:       dc.b 34,"BY THE WAY, THERE'S SOME THINGS INSIDE "
                dc.b "FROM OUR LAST TRIP. YOU MIGHT HAVE USE "
                dc.b "FOR THEM.",34,0
l_goat15:       dc.b 34,"THANKS.",34,0

;-------------------------------------------------------------------------------
; $1d01 Goat escort ends (similar to Joan's donotfollow routine in script11.s)
;-------------------------------------------------------------------------------

goatend:        lda comradeagent
                cmp #ACT_GOAT
                bne ge_skip
                jsr findactor
                bcc ge_skip
                lda acthp,x
                beq ge_skip
ge_ok:          removetrigger ACT_GOAT
                lda #$00
                sta comradeagent
                sta acttarget,x
                setbit PLOT_GOAT_JOIN
                lda #M_TURNTOTARGET
                sta actmode,x
                say l_goatend1
                plrsay l_goatend2
                setscript SCRIPT_GOATENDRUN
ge_skip:        stop

l_goatend1:     dc.b 34,"I'LL MAKE IT FROM HERE. SAY, WE MEET "
                dc.b "SOMETIME LATER TO DISCUSS MORE?",34,0
l_goatend2:     dc.b 34,"MY THOUGHTS EXACTLY. MEANWHILE, KEEP A GUN AT HAND.",34,0

;-------------------------------------------------------------------------------
; $1d02 Goat escort ends - runloop
;-------------------------------------------------------------------------------

goatendrun:     focus ACT_GOAT        ;As soon as Goat disappears from
                bcs ger_notransport   ;screen, transport to unknown dimension..

ger_transport:  lda #$7f              ;(nonexistent level)
                sta temp7
                lda #ACT_GOAT
                jsr transportactor
                stopscript
ger_notransport:stop

;-------------------------------------------------------------------------------
; $1d03 - IAC appear/remove/destroy
;-------------------------------------------------------------------------------

goatiac:        choice T_TAKEDOWN,goatiac_takedown
goatiac_appear: lda #$03                   ;Set bossmusic both inside & outside
                ldy #$05                   ;Green glow
                bne goatsetzone_common

goatiac_takedown:
                lda #ACT_GOATIAC           ;Remove IAC trigger (not needed)
                jsr removeactortrigger
                jsr goat4                  ;Set comradestatus
                lda #$01
                ldy #$0c                   ;Green glow disappears..
goatsetzone_common:
                ora zonemusic+$06
                sta zonemusic+$07
                sta zonemusic+$08
                sty zonebg3+$07
                sty zonebg3+$08
                jmp playzonetune

;-------------------------------------------------------------------------------
; $1d04 Goat conversation after seeing the IAC
;-------------------------------------------------------------------------------

goat2:          focus ACT_GOATIAC           ;Wait until IAC offscreen/destroyed
                bcs goat2_notyet
                lda bigexplcount            ;Wait until explosion is over
                bne goat2_notyet
                settrigger ACT_GOAT,SCRIPT_GOAT4,T_APPEAR
                focus ACT_GOAT
                plrsay l_goat16
                say l_goat17

;-------------------------------------------------------------------------------
; $1d07 Goat appear trigger - reset comradestatus
;-------------------------------------------------------------------------------

goat4:          lda #ACT_GOAT
                sta comradeagent
goat2_notyet:   stop

l_goat16:       dc.b 34,"JUST LIKE THE CRAFT THAT ATTACKED ME.",34,0
l_goat17:       dc.b 34,"DAMN. I'M NOT STAYING.",34,0

;-------------------------------------------------------------------------------
; $1d05 Goat shouts "Incoming!"
;-------------------------------------------------------------------------------

goat3:          dec agentdelay
                bne goat3_notyet
                lda #<l_goat18
                ldx #>l_goat18
                ldy #MSGTIME
                jsr printmsgax
                stopscript
goat3_notyet:   stop

l_goat18:       dc.b 34,"INCOMING!",34,0

;-------------------------------------------------------------------------------
; $1d06 Sadok first conversation
;-------------------------------------------------------------------------------

sadok_appear:   lda #ACTI_PLAYER
                sta acttarget,x
                lda #M_GOTO
                sta actmode,x
                stop

sadok:          choice T_APPEAR,sadok_appear
sadok_conv:     ;Remaining conversations not auto-triggered
                settrigger ACT_SADOK,SCRIPT_SADOK2,T_APPEAR|T_CONV
                setbit PLOT_SADOK_MET
                givepoints 10000
                plrsay l_sadok1
                getbit PLOT_SADOK_MSG_READ
                jumpfalse sadok_nomsg
sadok_msg:      plrsay l_sadok2a
                say l_sadok3a
                jmp sadok_common
sadok_nomsg:    plrsay l_sadok2b
                say l_sadok3b
sadok_common:   say l_sadok4
                plrsay l_sadok5
                say l_sadok6
                plrsay l_sadok7
                say l_sadok8
                plrsay l_sadok9
                say l_sadok10
                stop

l_sadok1:       dc.b 34,"SADOK..? WHAT IS THIS?",34,0

l_sadok2a:      dc.b 34,"YOU'RE NOT HUMAN?",34,0
l_sadok2b:      dc.b 34,"YOU DIED ONCE OR TWICE.",34,0

l_sadok3a:      dc.b 34,"CORRECT.",34,0
l_sadok3b:      dc.b 34,"YOU COULD SAY THAT.",34,0

l_sadok4:       dc.b 34,"I AM SCEPTRE'S EXPERIMENTAL ANDROID, LAST CLONE OUT "
                dc.b "OF THREE, REPROGRAMMED BY THE AGENTS.",34,0

l_sadok5:       dc.b 34,"REPROGRAMMED FOR WHAT?",34,0

l_sadok6:       dc.b 34,"TO SEEK OUT POTENTIAL AGENTS.",34,0

l_sadok7:       dc.b 34,"SO THE BAND, BEFRIENDING ME AND OTHERS, WAS JUST "
                dc.b "A SCHEME?",34,0

l_sadok8:       dc.b 34,"MY PROGRAMMING ALLOWS ME TO GENUINELY "
                dc.b "ENJOY THIS MUSIC-FORM, AS WELL AS YOUR COMPANY. "
                dc.b "YOU MAY FIND IT STRANGE THAT AN ANDROID CAN HAVE SUCH "
                dc.b "THOUGHTS.",34,0

l_sadok9:       dc.b 34,"YOU BEHAVE DIFFERENTLY NOW.",34,0

l_sadok10:      dc.b 34,"AS YOU HAVE BECOME AN AGENT, I NO LONGER HAVE "
                dc.b "TO HIDE THE TRUTH. ALSO, "
                dc.b "I HAVE BEEN DAMAGED AND CPU POWER IS BEING DIVERTED "
                dc.b "FROM CERTAIN SUBROUTINES.",34,0

                endscript
