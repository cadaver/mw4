;
; MW4 Scriptfile 11: Inner sphere
;

TRAINSEQUENCE_LENGTH = 96
TRAIN_ACCEL     = $01
TRAIN_MAXSPEED  = $40
TRAIN_SOUND_DELAY = $04

                include scriptm.s

                entrypoint donotfollow          ;$b00
                entrypoint donotfollow2         ;$b01
                entrypoint unused               ;$b02
                entrypoint innersphere          ;$b03
                entrypoint lilith1              ;$b04
                entrypoint lilith2              ;$b05
                entrypoint pyramid              ;$b06
                entrypoint trainstart           ;$b07
                entrypoint trainrun             ;$b08
                entrypoint sadokhint2           ;$b09

;-------------------------------------------------------------------------------
; $b00,$b01
;-------------------------------------------------------------------------------

donotfollow:    lda comradeagent
                cmp #ACT_JOANAGENT
                bne dnf_skip
                jsr findactor
                bcc dnf_skip
                lda acthp,x
                beq dnf_skip
                getbit PLOT_MELTDOWN_DONE
                jumptrue dnf_ok
                getbit PLOT_MELTDOWN_INITIATED
                jumptrue dnf_skip
dnf_ok:         lda #$00
                sta comradeagent
                sta acttarget,x
                lda #M_TURNTOTARGET
                sta actmode,x
                say dnf_text
                setscript SCRIPT_DONOTFOLLOW2
dnf_skip:       stop

dnf_text:       dc.b 34,"YOU GO AHEAD, I BELIEVE I'LL FIND ANSWERS BETTER "
                dc.b "IN THE INNER SPHERE. MEET ME AT THE PYRAMID IN THE HUB.",34,0

donotfollow2:   focus ACT_JOANAGENT
                bcc dnf2_transport
                ldy #ACTI_PLAYER
                jsr gettargetdistance
                lda actd,y
                eor targetxdist
                and #$80
                beq dnf2_goon
                lda targetabsxdist
                ora targetabsydist
                bne dnf2_goon
                say dnf2_text
                lda #ACT_JOANAGENT
                sta comradeagent
                stopscript
dnf2_goon:      stop

dnf2_transport: lda #$12
                sta temp7
                ldx #$46
                ldy #$16
                lda #ACT_JOANAGENT
                jsr transportactor
                ldy #LA_FINE            ;Turntoplayer
                lda #M_TURNTOTARGET*16+$02
                sta (lvlactptrlo),y
                stopscript
                stop

dnf2_text:      dc.b 34,"HAVING SECOND THOUGHTS?",34,0



;-------------------------------------------------------------------------------
; $0b03
;-------------------------------------------------------------------------------

unused:         stop

innersphere:    lda #$01                ;Set both triggers (do this only once)
                jsr setlvlobjstat
                lda #$2d
                jsr setlvlobjstat
                givepoints 10000
                plrsay l_innersphere
                stop

l_innersphere:  dc.b 34,"THE INNER SPHERE...",34,0

;-------------------------------------------------------------------------------
; $0b04
;-------------------------------------------------------------------------------

lilith1:        ldx #$01           ;Open IAC project door
                lda #$0b
                jsr activateobject
                jsr transmission
                saytrans l_lilith1
                plrsay l_lilith2
                lda #SCROLLCENTER_Y+40
                sta scrollcentery
                saytrans l_lilith3
                plrsay l_lilith4
                saytrans l_lilith7
lilithconvloop: setmultibyflags 4,PLOT_LILITH_MULTI0
                lda multichoices
                and #%00000111
                beq lilithconvdone
                domulti l_lilith8m
                setchoiceflag PLOT_LILITH_MULTI0 ;Allow each choice only once
                selectline l_lilith9m
                saytransnoptr
                lda choicenum
                cmp #$03
                beq lilithconvdone
                jmp lilithconvloop
lilithconvdone: lda #SCROLLCENTER_Y
                sta scrollcentery
                getbit PLOT_LILITH_MULTI1       ;Know if some are against priests
                bne lilithconvdone2
                setbit PLOT_AHRIMAN_MULTI2
lilithconvdone2:setscript SCRIPT_LILITH2
                stop

l_lilith1:      dc.b 34,"MAY I HAVE YOUR ATTENTION, AGENT?",34,0
l_lilith2:      dc.b 34,"WHO IS THIS?",34,0
l_lilith3:      dc.b 34,"COMMANDER OF THE BLACK OPS - LILITH. I'VE BEEN OBSERVING YOUR ACTIONS.",34,0
l_lilith4:      dc.b 34,"ANOTHER.. WHAT DO YOU WANT?",34,0
l_lilith7:      dc.b 34,"YOU MIGHT FIND ANSWERS TO YOUR QUESTIONS IN THE CENTRAL NODE.",34,0
l_lilith8m:     dc.w l_lilith8m0
                dc.w l_lilith8m1
                dc.w l_lilith8m2
                dc.w l_lilith8m3
l_lilith8m0:    dc.b 34,"YOU'RE OFFERING .. HELP?",34,0
l_lilith8m1:    dc.b 34,"WHAT'S THAT PLACE?",34,0
l_lilith8m2:    dc.b 34,"HOW DO I GET THERE?",34,0
l_lilith8m3:    dc.b 34,"I DON'T NEED YOUR ADVICE.",34,0

l_lilith9m:     dc.w l_lilith9m0
                dc.w l_lilith9m1
                dc.w l_lilith9m2
                dc.w l_lilith9m3
l_lilith9m0:    dc.b 34,"YOU HAVE CAUSED MUCH DAMAGE, BUT I HAVE NOTHING PERSONAL AGAINST YOU. IN FACT, I ALMOST SYMPATHIZE WITH YOUR QUEST.",34,0
l_lilith9m1:    dc.b 34,"IT'S WHERE THE PRIESTS RUN THIS ORGANIZATION. NOT EVERYONE IN SCEPTRE AGREES WITH THEIR WAYS. AND, I BELIEVE IT WAS HIGH PRIEST AHRIMAN WHO TOOK AN ESPECIAL INTEREST IN YOU.",34,0
l_lilith9m2:    dc.b 34,"IT'S REACHABLE ONLY VIA TELEPORTER. YOU WILL NEED A THREE-PART ACCESS CODE AND A CARD. BE SURE TO GET THE CODE RIGHT, OR YOU MIGHT BE SPLATTERED OVER A RANDOM LOCATION.",34,0
l_lilith9m3:    dc.b 34,"AS YOU WISH.",34,0

;-------------------------------------------------------------------------------
; $0b05
;-------------------------------------------------------------------------------

lilith2:        focus ACT_LILITHBYSTD
                bcc lilith2_done
                lda actyh,x
                sta waypointyh
                lda actxh,x
                sec
                sbc #$10
                sta waypointxh
                lda #WAYPOINT0
                sta acttarget,x
                lda #M_GOTO
                sta actmode,x
                lda actxh,x
                cmp #$3d
                bne lilith2_notdone
                lda actxl,x
                cmp #$40
                bcc lilith2_done
lilith2_notdone:stop

lilith2_done:   stopscript
                lda #25         ;Transport  to the escape tunnels
                sta temp7
                ldx #$7c
                ldy #$4d
                lda #ACT_LILITHBYSTD
                jsr transportactor
                ldy #LA_FINE
                lda #M_TURNTOTARGET*16+$02
                sta (lvlactptrlo),y
                ldy #LA_DATA
                lda #$80
                sta (lvlactptrlo),y
                stop

;-------------------------------------------------------------------------------
; $0b06
;-------------------------------------------------------------------------------

pyramid:        lda actsx+ACTI_PLAYER
                bne pyr_notducking
                lda actf1+ACTI_PLAYER
                cmp #PLRFR_DUCK
                bne pyr_notducking
                lda actd                ;Must face the Eye :)
                bpl pyr_notducking
                inc duckcount
                lda duckcount
                cmp #160
                bcc pyr_done
                lda #SFX_OBJECT
                jsr playsfx
                lda #$0e
                ldx #$01
                jsr activateobject
                focus ACT_JOANAGENT
                bcc pyr_skip
                say l_pyr
pyr_skip:       stop

pyr_notducking: lda #$00
                sta duckcount
pyr_done:       lda aonum               ;Allow to happen again
                jmp deactivateobject

duckcount:      dc.b 0

l_pyr:          dc.b 34,"IT OPENED..",34,0

;-------------------------------------------------------------------------------
; $0b07 - SCEPTRE train start
;-------------------------------------------------------------------------------

trainstart:     lda #$00
                sta traincounter
                sta trainanimdelay
                sta trainspeed
                lda aonum
                and #$01
                sta traindir
                jsr resetmessage
trainstart_nomeltdown:
                setscript SCRIPT_INNERSPHERETRAINRUN
                stop

;-------------------------------------------------------------------------------
; $0b08 - SCEPTRE train running
;-------------------------------------------------------------------------------

trainrun:       lda trainspeed
                clc
                adc #TRAIN_ACCEL
                cmp #TRAIN_MAXSPEED
                bcc tr_speedok
                lda #TRAIN_MAXSPEED
tr_speedok:     sta trainspeed
                lda trainanimdelay
                clc
                adc trainspeed
                sta trainanimdelay
tr_animloop:    lda trainanimdelay
                cmp #TRAIN_MAXSPEED/2
                bcc tr_noanim
                sbc #TRAIN_MAXSPEED/2
                sta trainanimdelay
                jsr tr_anim
                jmp tr_animloop
tr_noanim:      inc traincounter
                lda traincounter
                cmp #TRAIN_SOUND_DELAY
                bne tr_nosound
                lda #SFX_TRAIN
                jsr playsfx
tr_nosound:     lda traincounter
                cmp #TRAINSEQUENCE_LENGTH
                bcc tr_nostop
                jsr stoplatentscript
                getbit PLOT_MELTDOWN_DONE
                bne trainrun_nomeltdown
                getbit PLOT_MELTDOWN_INITIATED
                beq trainrun_nomeltdown
                setscript SCRIPT_MELTDOWNCOUNTDOWN ;Let it finish now..
trainrun_nomeltdown:

                jsr cleartextscreen
                ldy aonum
                lda traindir
                eor #$01
                ror
                ror
                sta actd+ACTI_PLAYER
                lda tr_desttbllo-$14,y
                ldx tr_desttblhi-$14,y
                jmp enterdoornum
tr_nostop:      rts

tr_anim:        ldy #$07
                lda traindir
                beq tr_animleft
tr_animright:   lda chars+$f5*8,y
                sta temp1
                lda chars+$f6*8,y
                sta chars+$f5*8,y
                lda chars+$f7*8,y
                sta chars+$f6*8,y
                lda chars+$f8*8,y
                sta chars+$f7*8,y
                lda chars+$f9*8,y
                sta chars+$f8*8,y
                lda chars+$fa*8,y
                sta chars+$f9*8,y
                lda chars+$fb*8,y
                sta chars+$fa*8,y
                lda chars+$fc*8,y
                sta chars+$fb*8,y
                lda temp1
                sta chars+$fc*8,y
                dey
                bpl tr_animright
                rts
tr_animleft:    lda chars+$fc*8,y
                sta temp1
                lda chars+$fb*8,y
                sta chars+$fc*8,y
                lda chars+$fa*8,y
                sta chars+$fb*8,y
                lda chars+$f9*8,y
                sta chars+$fa*8,y
                lda chars+$f8*8,y
                sta chars+$f9*8,y
                lda chars+$f7*8,y
                sta chars+$f8*8,y
                lda chars+$f6*8,y
                sta chars+$f7*8,y
                lda chars+$f5*8,y
                sta chars+$f6*8,y
                lda temp1
                sta chars+$f5*8,y
                dey
                bpl tr_animleft
                rts

tr_desttbllo:   dc.b $00
                dc.b $06
                dc.b $0b
                dc.b $06
tr_desttblhi:   dc.b $13
                dc.b $12
                dc.b $12
                dc.b $16

;-------------------------------------------------------------------------------
; $0b09 - Axesmith's Sadok hint
;-------------------------------------------------------------------------------

sadokhint2:     getbit PLOT_SADOK_HINT
                jumptrue sh_skippoints
                setbit PLOT_SADOK_HINT
                lda #$02                        ;Make Sadok visible at the Farm
                sta temp7
                lda #ACT_SADOK
                ldx #$57
                ldy #$05
                jsr transportactor                   
                givepoints 10000                ;Give points only once
sh_skippoints:  say l_sh1
                plrsay l_sh2
                say l_sh3
                getbit PLOT_SADOK_MET
                selectline l_sh4m
                plrspeaknoptr
                removetrigger ACT_AXESMITH
                stop

l_sh1:          dc.b 34,"I THINK I'VE SEEN A GHOST.",34,0
l_sh2:          dc.b 34,"WHY?",34,0
l_sh3:          dc.b 34,"SADOK. HE SHOULD BE DEAD, RIGHT? YET A GUY LOOKING "
                dc.b "JUST LIKE HIM BURST IN HERE AND LEFT YOU A MESSAGE. TO "
                dc.b "MEET HIM AT 'THE FARM'.",34,0

l_sh4m:         dc.w l_sh4m0
                dc.w l_sh4m1

l_sh4m0:        dc.b 34,"I DON'T LIKE THIS.",34,0
l_sh4m1:        dc.b 34,"ALREADY MET HIM. NOT A GHOST, JUST AN ANDROID..",34,0

                endscript
