;
; MW4 Scriptfile 07: Agent briefing part2
;

                include scriptm.s               ;Script macros etc.

                entrypoint briefingcontinue     ;700
                entrypoint sargeleave           ;701
                entrypoint sargeconv            ;702
                entrypoint sargeconv2           ;703


;-------------------------------------------------------------------------------
; $0700
;-------------------------------------------------------------------------------

briefingcontinue:
                focus ACT_BLACKHAND
                say l_brief16
                plrsay l_brief17
                say l_brief18
                focus ACT_SARGE
                say l_brief19
                focus ACT_BLACKHAND
                say l_brief20
                setdomulti %00000011,l_brief21m
                selectline l_brief22m
                saynoptr
                plrsay l_brief23
                say l_brief24
                plrsay l_brief25
                focus ACT_SARGE
                say l_brief26
                focus ACT_BLACKHAND
                say l_brief27
                lda #$00
                sta agentcounter
                sta agentdelay
                settrigger ACT_BLACKHAND,SCRIPT_BLACKHANDCONV,T_CONV
                setscript SCRIPT_SARGELEAVE
                stop

l_brief16:      dc.b 34,"THE MESSAGE PROVES THAT SCEPTRE WAS INVOLVED, AND WE SUSPECT THEY AREN'T TOO PLEASED.",34,0
l_brief17:      dc.b 34,"YOU'RE SAYING, THEY ARRANGED THAT .. ATTACK?",34,0
l_brief18:      dc.b 34,"THAT'D BE EXTREME SPECULATION. BUT IN ANY CASE, WE KNOW THEY HAVE TAKEN AN INTEREST IN YOU.",34,0
l_brief19:      dc.b 34,"THAT MEANS, YOU AREN'T SAFE ANYWHERE IN THE WORLD.",34,0
l_brief20:      dc.b 34,"SO WE SUGGEST YOU BECOME AN AGENT.",34,0

l_brief21m:     dc.w l_brief21m0
                dc.w l_brief21m1
l_brief21m0:    dc.b 34,"AND WORK FOR YOU?",34,0
l_brief21m1:    dc.b 34,"WHAT DOES THAT INCLUDE?",34,0

l_brief22m:     dc.w l_brief22m0
                dc.w l_brief22m1
l_brief22m0:    dc.b 34,"I DIDN'T SAY THAT. WE ARE A VERY FREE-FORM ORGANIZATION. TAKE THE AGENT GEAR FOR YOUR PROTECTION, AND PROCEED AS YOU SEE BEST.",34,0
l_brief22m1:    dc.b 34,"TAKE THE AGENT GEAR TO IMPROVE YOUR CHANCES OF SURVIVAL, AND PROCEED AS YOU WISH. WE HAVE ONLY A FEW SUGGESTIONS.",34,0

l_brief23:      dc.b 34,"HOW SHOULD I START?",34,0
l_brief24:      dc.b 34,"ONE OF OUR AGENTS, BLOWFISH, HAS BEEN OBSERVING AN ALLEGED SCEPTRE FACILITY LOCATED AT AN UNIVERSITY CAMPUS. TO CONTACT HER WOULD BE A GOOD START.",34,0
l_brief25:      dc.b 34,"WON'T YOU DO ANYTHING?",34,0
l_brief26:      dc.b 34,"WE WILL HELP YOU FROM HERE. WE'RE NOT THAT YOUNG ANYMORE - FIELD OPS WOULD LIKELY GET US KILLED.",34,0

l_brief27:      dc.b 34,"NOW, ANY QUESTIONS? SARGE WILL PREPARE YOUR GEAR IN THE ARMORY.",34,0

;-------------------------------------------------------------------------------
; $0701
;-------------------------------------------------------------------------------

sargeleave:     lda agentcounter
                choice 0,sl_sargepressbutton
                choice 1,sl_sargeleave
                stop

sl_sargepressbutton:
                focus ACT_SARGE
                bcc sl_end
                lda #$1a
                sta waypointxh
                lda #$0e
                sta waypointyh
                lda #M_GOTO
                sta actmode,x
                lda #WAYPOINT0
                sta acttarget,x
                lda actxh,x
                cmp #$1a
                beq sl_spbok
                rts
sl_spbok:       lda #$0a                        ;Skip if door open
                jsr getlvlobjstat
                bne sl_spbskip
                lda #$0b                        ;Press door open button
                jsr activateobject
                lda #SFX_OBJECT
                jsr playsfx
sl_spbskip:     inc agentcounter
sl_wait:        rts

sl_sargeleave:  inc agentdelay
                lda agentdelay
                cmp #12
                bcc sl_wait
                lda #$19
                sta waypointxh
                focus ACT_SARGE
                bcc sl_end
                lda #M_GOTO
                sta actmode,x
                lda #WAYPOINT0
                sta acttarget,x
                lda actxh,x
                cmp #$19
                beq sl_end
                rts

sl_end:         stopscript
                settrigger ACT_SARGE, SCRIPT_SARGECONV, T_NEAR|T_CONV
                lda #$03
                sta temp7
                lda #ACT_SARGE
                ldx #$35
                ldy #$05
                jsr transportactor
                ldy #LA_FINE            ;Sitting & facing right
                lda #M_SIT*16+$03
                sta (lvlactptrlo),y
                ldy #LA_DATA
                lda #$00
                sta (lvlactptrlo),y
                rts

;-------------------------------------------------------------------------------
; $0702
;-------------------------------------------------------------------------------

sargeconv:      removetrigger ACT_SARGE
                ldx #ACTI_FIRSTITEM
                jsr removelevelactor
                ldy #ACTI_FIRSTITEM
                lda #ACT_ITEM
                jsr createactor
                lda #ITEM_AGENT_GEAR            ;Create agentgear on table
                sta actf1,y
                lda #1
                sta acthp,y
                lda #$36
                sta actxh,y
                lda #$04
                sta actyh,y
                lda #$80
                sta actxl,y
                sta actyl,y
                focus ACT_SARGE
                say l_sarge1
                plrsay l_sarge2
                say l_sarge3
                plrsay l_sarge4
                stop

l_sarge1:       dc.b 34,"HERE'S YOUR GEAR. THE COAT HAS AN ELECTRO-MAGNETIC ARMOR SYSTEM. "
                dc.b "AS LONG AS IT HAS POWER, IT WILL REDUCE THE IMPACT OF PROJECTILES.",34,0
l_sarge2:       dc.b 34,"AND WHEN IT RUNS OUT?",34,0
l_sarge3:       dc.b 34,"YOU HAVE TO USE EITHER A PORTABLE OR FIXED RECHARGER. THERE'S A FIXED ONE ON THE WALL. "
                dc.b "OF COURSE, SOONER OR LATER AN AGENT'S GOING TO GET HURT. NOTICED THE MACHINE "
                dc.b "IN THE CLINIC? THOSE WILL HEAL YOUR INJURIES.",34,0
l_sarge4:       dc.b 34,"NICE TO KNOW.",34,0

;-------------------------------------------------------------------------------
; $0703
;-------------------------------------------------------------------------------

sargeconv2:     jsr stoplatentscript
                givepoints 5000
                lda #ACT_IANAGENT       ;The metamorphosis!!!
                sta actt+ACTI_PLAYER
                lda actl_agent+AD_DEFAULTHP ;Set correct HP (cheat may be
                sta acthp+ACTI_PLAYER   ;in effect)
                focus ACT_SARGE         ;Don't talk if offscreen :)
                bcc sargesayskip
                say l_sarge5
sargesayskip:   settrigger ACT_BLACKHAND,SCRIPT_BLACKHANDCONV,T_NEAR|T_CONV
                stop ;Blackhand will react now automatically

l_sarge5:       dc.b 34,"NOW YOU'RE AN AGENT. THOSE SUNGLASSES RECORD VISUALS AND SOUND FROM YOUR TRAVELS, "
                dc.b "AND CONTAIN A TWO-WAY COMMUNICATION DEVICE. ALL YOU NEED NOW IS WEAPONS. THERE ISN'T "
                dc.b "TERRIBLY MUCH IN THOSE CLOSETS, BUT IT'S BETTER THAN NOTHING.",34,0

                endscript
