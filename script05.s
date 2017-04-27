;
; MW4 Scriptfile 05: Intro continues
;

                include scriptm.s               ;Script macros etc.

                entrypoint farmcontinue         ;500
                entrypoint iacattack            ;501
                entrypoint iacattackcont        ;502
                entrypoint iandown              ;503
                entrypoint iacattackcont2       ;504
                entrypoint clinicintro          ;505
                entrypoint agencyshortcut       ;506

;-------------------------------------------------------------------------------
; $0500
;-------------------------------------------------------------------------------

farmcontinue:   removetrigger ACT_SATANAKHIA
                focus ACT_LORDOBSKURIUS
                say l_sata11
                focus ACT_JOANCIVILIAN
                lda #$80                ;Turn towards Lord Obskurius
                sta actd,x

                say l_sata12
                focus ACT_LORDOBSKURIUS
                say l_sata13
                focus ACT_JOANCIVILIAN
                say l_sata14
                focus ACT_SATANAKHIA
                say l_sata15
                focus ACT_LORDOBSKURIUS
                say l_sata16
                lda #SFX_OBJECT                 ;Electricity shuts down..
                jsr playsfx
                lda #$00
                sta zonebg2+$05
lightloop:      pha
                tay
                lda lighttbl,y
                ldx #ACTI_PLAYER+1
                jsr activateobject              ;Shut down lights
                pla
                clc
                adc #$01
                cmp #$09
                bne lightloop
                lda #25                         ;Some delay
                jsr waitforfire
                say l_sata17
                focus ACT_SATANAKHIA
                say l_sata18
                focus ACT_LORDOBSKURIUS
                jsr turntoplayer
                focus ACT_SATANAKHIA
                jsr turntoplayer
                focus ACT_JOANCIVILIAN
                jsr turntoplayer
                plrsay l_sata19
                stop

turntoplayer:   lda #M_TURNTOTARGET
                sta actmode,x
                lda #ACTI_PLAYER
                sta acttarget,x
                stop


l_sata11:       dc.b 34,"TIME TO PLAY EVIL MUSIC. SOME SONG WE ALL KNOW?",34,0
l_sata12:       dc.b 34,"TORMENTOR?",34,0
l_sata13:       dc.b 34,"WHICH ONE? THERE'S QUITE A LOT OF THEM.",34,0
l_sata14:       dc.b 34,"THE ONE ON THE 1ST CYBERPRIEST DEMO? I REMEMBER YOU PLAYED IT AS WELL.",34,0
l_sata15:       dc.b 34,"AH, THAT ONE. IT'S SERIOUSLY EVIL.",34,0
l_sata16:       dc.b 34,"I MIGHT EVEN REMEMBER THE LYRICS.",34,0
l_sata17:       dc.b 34,"DAMN - THE FUSE BLEW.",34,0
l_sata18:       dc.b 34,"THE FUSE BOX IS OUTSIDE TO THE RIGHT. THERE SHOULD BE SPARES. ANYONE CARE TO CHECK IT?",34,0
l_sata19:       dc.b 34,"I CAN DO THAT.",34,0
lighttbl:       dc.b $0d,$11,$15,$16,$17,$18,$19,$1a,$1b

;-------------------------------------------------------------------------------
; $0501
;-------------------------------------------------------------------------------

iacattack:      lda actt+ACTI_PLAYER            ;If player is an Agent,
                cmp #ACT_IANAGENT               ;skip the attack..
                beq iacattack_skip
                lda #ACTI_LASTNPC+1
                ldy #ACTI_FIRSTNPC
                jsr getfreeactor                ;This must succeed :)
                                                ;or we don't deal with the
                                                ;consequences..
                lda #ACT_IAC
                jsr createactor
                tya
                tax
                jsr initcomplexactor
                lda #$5a+$06
                sta actxh,x
                lda #$05-$03
                sta actyh,x
                lda #$80                ;Face left
                sta actd,x
                sta actpurgeable,x      ;Purged on level exit
                lda #M_COMBAT
                sta actmode,x
                lda #-40                ;Move to left with max.speed
                sta actsx,x
                lda #24                 ;Move down
                sta actsy,x
                lda #ITEM_LASER_RIFLE
                sta actwpn,x
                lda #100                ;Unnatural clip size
                sta actclip,x
                lda #11                 ;Set colors..
                sta zonebg2+$06
                lda #5
                sta zonebg3+$06
                setscript SCRIPT_IACATTACKCONT
iacattack_skip: stop

;-------------------------------------------------------------------------------
; $0502
;-------------------------------------------------------------------------------

iacattackcont:  lda acthp+ACTI_PLAYER   ;When hitpoints drop just a bit,
                beq iaccont_ok
                cmp #HP_AGENT           ;go down immediately (to not need
                beq iaccont_ok          ;to mess with damage table)
                lda #SFX_TAKEDOWN
                jsr playsfx
                lda #$00
                sta acthp+ACTI_PLAYER
                sta actgrp+ACTI_PLAYER
                lda #-24                        ;Give upwards speed
                sta actsy+ACTI_PLAYER
                jmp iandown
iaccont_ok:     stop

;-------------------------------------------------------------------------------
; $0503
;-------------------------------------------------------------------------------

iandown:        setscript SCRIPT_IACATTACKCONT2
                lda #$00
                sta iaccounter
                focus ACT_IAC
                bcc iandown_skipctrl
                lda #GRP_BYSTANDER              ;Safety to control Joan's
                sta actgrp,x                    ;hate... (if has pistol)
                lda #M_FREE
                sta actmode,x
                lda #JOY_UP|JOY_LEFT                     ;IAC goes away
                sta actctrl,x
iandown_skipctrl:
                removetrigger ACT_IANCIVILIAN
                stop

;-------------------------------------------------------------------------------
; $0504
;-------------------------------------------------------------------------------

iacattackcont2: inc iaccounter
                bne iac2_counterok
                lda #$ff
                sta iaccounter
iac2_counterok:
                lda iaccounter
                choice 35,iac2_transportjoan
                choice 36,iac2_setdir1
                choice 50,iac2_transportsatanakhia
                choice 51,iac2_setdir2
                choice 70,iac2_transportlordobskurius
                choice 71,iac2_setdir3
                choice 75,iac2_satanakhiarant
                choice 85,iac2_joancrouch
                choice 90,iac2_joanrant
                choice 120,iac2_satanakhiarun
                choice 145,iac2_blindinglight
                stop
iac2_transportjoan:
                focus ACT_IAC                   ;If IAC there, remove
                bcc iac2_tjnoiac
                jsr removeactor
iac2_tjnoiac:   lda #$09                        ;Normalize colors
                sta zonebg2+$06
                lda #$0c
                sta zonebg3+$06
                lda actxh+ACTI_PLAYER           ;Set waypoints
                sta waypointxh
                clc
                adc #$02
                sta waypointxh+1
                sec
                sbc #$03
                sta waypointxh+2
                lda #$05
                sta waypointyh
                sta waypointyh+1
                sta waypointyh+2
                jsr iac2_transcommon
                lda #ACT_JOANCIVILIAN
                jmp transportactor
iac2_transportsatanakhia:
                jsr iac2_transcommon
                lda #ACT_SATANAKHIA
                jmp transportactor
iac2_transportlordobskurius:
                jsr iac2_transcommon
                lda #ACT_LORDOBSKURIUS
                jmp transportactor

iac2_transcommon:
                lda #$02                        ;Levelnum
                sta temp7
                lda mapx
                sec
                sbc #$01
                cmp #$54
                bcs iac2_tjxok
                lda #$54
iac2_tjxok:     tax
                ldy #5
                rts

iac2_setdir1:   focus ACT_JOANCIVILIAN
                lda #WAYPOINT0
                sta acttarget,x
                lda #M_GOTO
                sta actmode,x
iac2_skip1:     rts

iac2_setdir2:   focus ACT_SATANAKHIA
                lda #WAYPOINT1
                sta acttarget,x
                lda #M_GOTO
                sta actmode,x
iac2_skip2:     rts

iac2_setdir3:   focus ACT_LORDOBSKURIUS
                lda #WAYPOINT2
                sta acttarget,x
                lda #M_GOTO
                sta actmode,x
iac2_skip3:     rts

iac2_satanakhiarant:
                focus ACT_SATANAKHIA
                say l_iac0
                stop

iac2_joancrouch:focus ACT_JOANCIVILIAN
                ldy #$00
                jsr gettargetdistance
                lda targetxdist
                sta actd,x
                lda #M_FREE
                sta actmode,x
                lda #JOY_DOWN
                sta actctrl,x                   ;Crouch
                stop

iac2_joanrant:  focus ACT_JOANCIVILIAN
                say l_iac1
                stop

iac2_satanakhiarun:
                lda #11                 ;Set colors again..
                sta zonebg2+$06
                lda #5
                sta zonebg3+$06
                focus ACT_SATANAKHIA
                say l_iac2
                lda #$7f
                sta waypointxh
                sta waypointxh+1
                sta waypointxh+2
                focus ACT_SATANAKHIA
                lda #M_GOTO
                sta actmode,x
                focus ACT_LORDOBSKURIUS
                lda #M_GOTO
                sta actmode,x
                stop

iac2_blindinglight:
                lda #$01
                sta zonebg1+$06
                sta zonebg2+$06
                sta zonebg3+$06
                jsr cts_setcolors
                lda #SFX_TASER
                jsr playsfx
                jsr scriptupdateframe
                jsr scriptupdateframe
                jsr cleartextscreen
                lda #SFX_EXPLOSION
                jsr playsfx
                jsr stoplatentscript

                lda #$7f                        ;Very nonexistent level
                sta temp7
                lda #ACT_JOANCIVILIAN
                jsr transportactor
                lda #ACT_SATANAKHIA
                jsr transportactor
                lda #ACT_LORDOBSKURIUS
                jsr transportactor              ;Transfer bandmates to another
                                                ;dimension :)
                lda #25                         ;wait one second
                jsr waitforfire
                jsr removeallactors
                lda #$03                        ;Load Agency level
                ldx #LLMODE_NORMAL
                jsr loadlevel
                lda #<introtext3
                ldy #>introtext3
                jsr fadeintext
                ldx #ACTI_PLAYER
                jsr initcomplexactor            ;Init player (restore HP etc.)
                jsr removeallactors
                lda #PLRFR_SIT
                sta actf1+ACTI_PLAYER
                lda #$00
                sta actf2+ACTI_PLAYER
                lda #$00                        ;Facing right
                sta actd+ACTI_PLAYER
                sta actxl+ACTI_PLAYER
                sta actyl+ACTI_PLAYER
                lda #$05
                sta actxh+ACTI_PLAYER
                sta actyh+ACTI_PLAYER

agencyshortcut: lda #$03
                sta temp7
                lda #ACT_SARGE                  ;Transport the Agents
                ldx #$06
                ldy #$05
                jsr transportactor
                ldy #LA_FINE                    ;Standing
                lda #M_IDLE*16+$02
                sta (lvlactptrlo),y
                ldy #LA_DATA                    ;Facing left
                lda #$80
                sta (lvlactptrlo),y
                lda #ACT_BLACKHAND
                ldx #$07
                ldy #$05
                jsr transportactor
                ldy #LA_DATA                    ;Facing left
                lda #$80
                sta (lvlactptrlo),y
                settrigger ACT_SARGE,SCRIPT_CLINICINTRO,T_NEAR
                jsr playzonetune
                jmp centerplayer

l_iac0:         dc.b 34,"WHAT THE HELL WAS THAT?",34,0
l_iac1:         dc.b 34,"IAN, ARE YOU OK?",34,0
l_iac2:         dc.b 34,"IT'S COMING BACK - RUN!",34,0

introtext3:     dc.b 16,9, 0,"LATER...",0
                dc.b $ff

;-------------------------------------------------------------------------------
; $0505
;-------------------------------------------------------------------------------

clinicintro:    settrigger ACT_IAC,SCRIPT_IAC,T_APPEAR|T_REMOVE|T_TAKEDOWN
                removetrigger ACT_SARGE ;Subsequent IACs play bossmusic
                focus ACT_SARGE
                say l_clinic1
                focus ACT_BLACKHAND
                say l_clinic2
                plrsay l_clinic3
                say l_clinic4
                plrsay l_clinic5
                focus ACT_SARGE
                say l_clinic6
                plrsay l_clinic7
                focus ACT_BLACKHAND
                say l_clinic8
                focus ACT_SARGE
                say l_clinic9
                plrsay l_clinic10
                focus ACT_BLACKHAND
                say l_clinic11
                focus ACT_SARGE
                say l_clinic12
                focus ACT_BLACKHAND
                say l_clinic13
                lda #$00
                sta agentcounter
                sta agentdelay
                setscript SCRIPT_AGENTSLEAVE
                stop

l_clinic1:      dc.b 34,"HE'S AWAKE.",34,0
l_clinic2:      dc.b 34,"GOOD.",34,0
l_clinic3:      dc.b 34,"WHERE AM I?",34,0
l_clinic4:      dc.b 34,"IN THE AGENTS OF METAL TEMPORARY HQ. I'M BLACKHAND AND HE'S SARGE.",34,0
l_clinic5:      dc.b 34,"AGENTS .. METAL. REAL FUNNY. WHAT HAPPENED TO ME?",34,0
l_clinic6:      dc.b 34,"YOU WERE ATTACKED BY AN IAC - IDENTIFIED ALIEN CRAFT.",34,0
l_clinic7:      dc.b 34,"AND MY FRIENDS?",34,0
l_clinic8:      dc.b 34,"THERE WAS JUST YOU AT THE SITE.",34,0
l_clinic9:      dc.b 34,"IN SIMILAR CASES LATELY, MISSING PERSONS HAVE BEEN FOUND LATER .. DISSECTED.",34,0
l_clinic10:     dc.b 34,"GULP..",34,0
l_clinic11:     dc.b 34,"I'M SORRY. WE AGENTS LIKE TO STATE THE FACTS.",34,0
l_clinic12:     dc.b 34,"YOU MUST BE CONFUSED, BUT IT'LL GET CLEAR SOON.",34,0
l_clinic13:     dc.b 34,"YES - TAKE YOUR TIME. WHEN YOU FEEL READY, SEE US IN THE CONTROL ROOM.",34,0


                endscript
