;
; MW4 Scriptfile 06: Agent briefing
;

                include scriptm.s               ;Script macros etc.

                entrypoint agentsleave          ;600
                entrypoint briefing             ;601


;-------------------------------------------------------------------------------
; $0600
;-------------------------------------------------------------------------------

agentsleave:    lda agentcounter
                choice 0,al_sargepressbutton
                choice 1,al_agentsleave
                stop

al_sargepressbutton:
                focus ACT_SARGE
                bcc al_end
                lda #$08
                sta waypointxh
                lda #$05
                sta waypointyh
                lda #M_GOTO
                sta actmode,x
                lda #WAYPOINT0
                sta acttarget,x
                lda actxh,x
                cmp #$08
                beq al_spbok
                rts
al_spbok:       lda #$00                        ;If door isn't open..
                jsr getlvlobjstat               ;(V1.1)
                bne al_spbskipbutton
                lda #$01                        ;Press door open button
                jsr activateobject
                lda #SFX_OBJECT
                jsr playsfx
al_spbskipbutton:
                inc agentcounter
al_wait:        rts

al_agentsleave: inc agentdelay
                lda agentdelay
                cmp #12
                bcc al_wait
                lda #$09
                sta waypointxh
                focus ACT_SARGE
                bcc al_end
                lda #M_GOTO
                sta actmode,x
                lda #WAYPOINT0
                sta acttarget,x
                focus ACT_BLACKHAND
                bcc al_end
                lda #M_GOTO
                sta actmode,x
                lda #WAYPOINT0
                sta acttarget,x
                lda actxh,x
                cmp #$09
                beq al_end
                rts

al_end:         stopscript
                settrigger ACT_BLACKHAND, SCRIPT_BRIEFING, T_NEAR|T_CONV
                lda #$03
                sta temp7
                lda #ACT_BLACKHAND
                ldx #$28
                jsr al_endcommon
                lda #ACT_SARGE
                ldx #$25
                ldy #$0f
                jsr al_endcommon
                stop

al_endcommon:   ldy #$0f
                jsr transportactor
                ldy #LA_FINE            ;Turntoplayer & facing left
                lda #M_TURNTOTARGET*16+$02
                sta (lvlactptrlo),y
                ldy #LA_DATA
                lda #$80
                sta (lvlactptrlo),y
                rts


;-------------------------------------------------------------------------------
; $0601
;-------------------------------------------------------------------------------

briefing:       removetrigger ACT_BLACKHAND
                say l_brief1
                setdomulti %00000111,l_briefm
                choice 0,briefask0
                choice 1,briefask1
                jmp briefcommon

l_brief1:       dc.b 34,"THERE YOU ARE. I ASSUME YOU HAVE QUESTIONS.",34,0
l_briefm:       dc.w l_briefm0
                dc.w l_briefm1
                dc.w l_briefm2

l_briefm0:      dc.b 34,"WHY DID YOU BRING ME HERE?",34,0
l_briefm1:      dc.b 34,"IS THE EARTH UNDER AN ALIEN ATTACK?",34,0
l_briefm2:      dc.b 34,"JUST TELL ME WHAT I NEED TO KNOW.",34,0

briefask0:      focus ACT_SARGE
                say l_briefm02
                plrsay l_briefm03
                jmp briefcommon

l_briefm02:     dc.b 34,"NORMALLY WE JUST ANONYMOUSLY NOTIFY THE AUTHORITIES OF IAC ATTACK SURVIVORS..",34,0
l_briefm03:     dc.b 34,"BUT..?",34,0

briefask1:      focus ACT_SARGE
                say l_briefm11
                plrsay l_briefm12
                focus ACT_BLACKHAND
                say l_briefm13
                jmp briefcommon

l_briefm11:     dc.b 34,"NO. FROM OUR INVESTIGATIONS OF THE IAC PHENOMENOM "
                dc.b "WE KNOW THESE ATTACKS HAPPEN FROM TIME TO TIME.",34,0
l_briefm12:     dc.b 34,"I JUST HAD BAD LUCK?",34,0
l_briefm13:     dc.b 34,"IT MIGHT NOT BE THAT SIMPLE.",34,0

briefcommon:    focus ACT_BLACKHAND
                say l_brief2
                focus ACT_SARGE
                say l_brief3
                plrsay l_brief4
                focus ACT_BLACKHAND
                say l_brief5
                plrsay l_brief6
                focus ACT_SARGE
                say l_brief7
                focus ACT_BLACKHAND
                say l_brief8
                focus ACT_SARGE
                lda #$01
                sta agenttvscreen       ;Show pic on screen
                say l_brief9
                jsr beginfullscreen
                ldx #FILE_FACES
                lda #$00
                jsr makefilename
                lda #<(chars+$200)
                ldx #>(chars+$200)
                jsr loadfileretry

                lda #$09
                sta rgscr_textbg2+1
                lda #$0a
                sta rgscr_textbg3+1

                jsr border
                lda #<message
                ldy #>message
                jsr printscreentext
                lda #MSGTIME_ETERNAL
                jsr waitforfire
                jsr endfullscreen_reload

                lda #PANELMC1
                sta rgscr_textbg2+1
                lda #PANELMC2
                sta rgscr_textbg3+1

                lda #$00
                sta agenttvscreen       ;Picture off
                focus ACT_BLACKHAND
                say l_brief10
                setdomulti %00000011,l_brief11m
                choice 1,brief_skipexplanation
                say l_brief12
                plrsay l_brief13
                say l_brief14
                focus ACT_SARGE
                say l_brief15
brief_skipexplanation:
                jumpto SCRIPT_BRIEFINGCONTINUE

l_brief2:       dc.b 34,"WE HAVE OBSERVED YOUR ACTIONS FOR SOME TIME.",34,0
l_brief3:       dc.b 34,"VERY IMPRESSIVE.",34,0
l_brief4:       dc.b 34,"IF SO, WHY DIDN'T YOU CONTACT ME EARLIER?",34,0
l_brief5:       dc.b 34,"BECAUSE WITH KNOWLEDGE COMES THE DANGER.",34,0
l_brief6:       dc.b 34,"KNOWLEDGE OF YOU?",34,0
l_brief7:       dc.b 34,"OF THE SCEPTRE. OUR SWORN ENEMIES.",34,0
l_brief8:       dc.b 34,"SECTARIAN CHOSEN ELITE PRIVILEGED TO RULE AND EXTERMINATE. A VAST SECRET ORGANIZATION.",34,0
l_brief9:       dc.b 34,"THIS MESSAGE WAS INTERCEPTED FROM THEIR NETWORKS YESTERDAY.",34,0
l_brief10:      dc.b 34,"DO YOU HAVE AN IDEA WHAT THIS MEANS?",34,0

l_brief11m:     dc.w l_brief11m0
                dc.w l_brief11m1
l_brief11m0:    dc.b 34,"ENLIGHTEN ME.",34,0
l_brief11m1:    dc.b 34,"I THINK I DO.",34,0

l_brief12:      dc.b 34,"YOUR INVOLVEMENT IN DIFFERENT PHASES OF THE MILITARY CONSPIRACY. CASE NUMBERS INCREASE WITH TIME.",34,0
l_brief13:      dc.b 34,"BUT EACH OF US WAS INVOLVED FROM THE START.",34,0
l_brief14:      dc.b 34,"IT LISTS 'ACTIVE' INVOLVEMENT ONLY.",34,0
l_brief15:      dc.b 34,"IN OTHER WORDS, BLOWING SHIT UP.",34,0

message:        dc.b 1,0,9,114+64,115+64,116+64,117+64,118+64,0
                dc.b 1,1,9,119+64,120+64,121+64,122+64,123+64,0
                dc.b 1,2,9,124+64,125+64,126+64,127+64,128+64,0
                dc.b 1,3,9,129+64,130+64,131+64,132+64,133+64,0
                dc.b 1,4,9,134+64,135+64,136+64,137+64,138+64,0

                dc.b 7,0,1,"NAME:   IAN SMITH",0
                dc.b 7,1,1,"CASES:  3265, 3281",0
                dc.b 7,2,1,"THREAT: SEVERE",0

                dc.b 1,6,9,89+64,90+64,91+64,92+64,93+64,0
                dc.b 1,7,9,94+64,95+64,96+64,97+64,98+64,0
                dc.b 1,8,9,99+64,100+64,101+64,102+64,103+64,0
                dc.b 1,9,9,104+64,105+64,106+64,107+64,108+64,0
                dc.b 1,10,9,109+64,110+64,111+64,112+64,113+64,0

                dc.b 7,6,1,"NAME:   JOAN ALDER AKA PHANTASM",0
                dc.b 7,7,1,"CASES:  3270, 3281",0
                dc.b 7,8,1,"THREAT: SEVERE",0

                dc.b 1,12,9,64+64,65+64,66+64,67+64,68+64,0
                dc.b 1,13,9,69+64,70+64,71+64,72+64,73+64,0
                dc.b 1,14,9,74+64,75+64,76+64,77+64,78+64,0
                dc.b 1,15,9,79+64,80+64,81+64,82+64,83+64,0
                dc.b 1,16,9,84+64,85+64,86+64,87+64,88+64,0

                dc.b 7,12,1,"NAME:   ERIK STEIN AKA GOAT",0
                dc.b 7,13,1,"CASES:  3281",0
                dc.b 7,14,1,"THREAT: SEVERE",0

                dc.b 1,18,1,"AUTHORIZATION TO PROCEED GRANTED.",0,$ff
                endscript

