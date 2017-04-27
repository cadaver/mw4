;
; Script 24: Sentinels continued
;


                include scriptm.s

                entrypoint agent        ;$1800
                entrypoint reunion      ;$1801
                entrypoint reunionrun   ;$1802
                entrypoint reunionend   ;$1803
                entrypoint backattemple ;$1804

;-------------------------------------------------------------------------------
;$1800
;-------------------------------------------------------------------------------

agent:          lda #ACT_SENTINEL
                jsr findactor
                bcc agentskip
                say l_agent
                plrsay l_agent2
                say l_agent3
                plrsay l_agent4
                say l_agent5
                stop
agentskip:      lda aonum
                jmp clearlvlobjstat

l_agent:        dc.b 34,"CURIOUSLY, YOU ARE THE SECOND VISITOR TO ARRIVE IN SIMILAR OUTFIT.",34,0
l_agent2:       dc.b 34,"OUTFIT OF AN AGENT?",34,0
l_agent3:       dc.b 34,"SUBJECT ARRIVED IN AGITATED STATE AND IS RESTING NOW.",34,0
l_agent4:       dc.b 34,"WHERE?",34,0
l_agent5:       dc.b 34,"ON THE UPPER LEVEL TO THE RIGHT.",34,0

;-------------------------------------------------------------------------------
;$1801,$1802
;-------------------------------------------------------------------------------

reunion:        removetrigger ACT_SENTINEL
                plrsay l_r0
                lda #$01
                sta playerscripted
                lda #$00
                sta comradeagent ;The "Grey" will *not* follow to temple!!
                focus ACT_SENTINEL
                bcc r_sskip
                lda #M_TURNTOTARGET
                sta actmode,x
r_sskip:        lda #$35
                sta waypointxh
                lda #$0d
                sta waypointyh
                lda #HM_HORIZ
                sta acthomemode+ACTI_PLAYER
                lda #$00
                sta actbits+ACTI_PLAYER
                sta agentcounter
                lda #WAYPOINT0
                sta acttarget+ACTI_PLAYER
                lda #M_GOTO
                sta actmode+ACTI_PLAYER
                setscript SCRIPT_SENTINELREUNIONRUN
rr_notyet:      stop

reunionrun:     lda actxh+ACTI_PLAYER
                cmp #$35
                bcc rr_notyet

                inc agentcounter
                lda agentcounter
                choice 5, rr_1
                choice 15, rr_2
                choice 22, rr_2b
                choice 30, rr_3
                choice 35, rr_4
                choice 45, rr_5
                choice 50, rr_6
                choice 55, rr_end
                stop

rr_1:           givepoints 10000
                plrsay l_r1
                stop

rr_2:           lda #M_FREE
                sta actmode+ACTI_PLAYER
                lda #JOY_RIGHT|JOY_DOWN
                sta actctrl+ACTI_PLAYER
                stop

rr_2b:          ;lda #JOY_DOWN
                ;sta actctrl+ACTI_PLAYER
                lda #$00
                sta actctrl+ACTI_PLAYER
                lda #PLRFR_SIT
                sta actf1+ACTI_PLAYER
                sta actf2+ACTI_PLAYER
                stop

rr_3:           plrsay l_r2
                plrsay l_r3
                stop

rr_4:           plrsay l_r4
                stop

rr_5:           focus ACT_JOANLEVITATE
                lda #1
                sta actf1,x
                stop

rr_6:           focus ACT_JOANLEVITATE
                say l_r5
                say l_r6
                plrsay l_r7
                say l_r8
                plrsay l_r9
                say l_r9b
                plrsay l_r9c
                say l_r10
                plrsay l_r11
                stop

reunionend:
rr_end:         stopscript
                lda #$17
                sta temp7
                ldx #$3c
                ldy #$16
                lda #ACT_JOANLEVITATE
                jsr transportactor
                ldy #LA_TYPE
                lda #ACT_JOANAGENT
                sta (lvlactptrlo),y
                ldy #LA_DATA
                lda #ITEM_9MM_SUBMACHINEGUN ;Have SMG, face right
                sta (lvlactptrlo),y
                jsr cleartextscreen
                lda #<returntext
                ldy #>returntext
                jsr fadeintext
                lda #$80
                sta actd+ACTI_PLAYER
                setscript SCRIPT_BACKATTEMPLE
                lda #$00
                sta playerscripted
                sta actf1+ACTI_PLAYER
                sta actf2+ACTI_PLAYER
                sta actctrl+ACTI_PLAYER
                setbit PLOT_JOAN_MET
                lda actl_agent+AD_DEFAULTHP ;Restore player HP
                sta acthp+ACTI_PLAYER
                lda #$1b ;Return to Temple
                ldx #$17
                jmp enterdoornum

                stop

l_r0:           dc.b 34,"JOAN - HOW..?",34,0
l_r1:           dc.b 34,"BUT ANSWERS CAN WAIT.",34,0
l_r2:           dc.b 34,"GLAD TO SEE YOU, ANGEL.",34,0
l_r3:           dc.b 34,"I MEAN, AGENT.",34,0
l_r4:           dc.b 34,"I BET YOU'VE GONE THROUGH CRAZY SHIT.",34,0
l_r5:           dc.b 34,"UH... YOU TOO.",34,0
l_r6:           dc.b 34,"I'M SURE YOU WANT TO HEAR HOW I GOT HERE.",34,0
l_r7:           dc.b 34,"THERE'S NO HURRY.",34,0
l_r8:           dc.b 34,"ANYWAY, "
                dc.b "OUR SATANIST FRIENDS WERE TAKEN. AFTER THE CRAFT "
                dc.b "LOST ME, I RETURNED, JUST IN TIME TO SEE THOSE AGENTS "
                dc.b "PUT YOU INTO A BODY BAG. I FOLLOWED, BUT COULD ONLY GET TO "
                dc.b "THEIR ARMORY. I TOOK THE AGENT GEAR, "
                dc.b "SOME GUNS AND TOOK OFF. FOUND OUT I COULD PLAY BACK RECORDINGS MADE "
                dc.b "BY THE PREVIOUS OWNER, AND SAW THE SAME TRIANGLE-EYE SYMBOL AS "
                dc.b "ON THE CRAFT. IT WAS BY PURE CHANCE I WAS ABLE TO IDENTIFY THE ENTRANCE TO SCEPTRE'S "
                dc.b "SYSTEM. AFTER MANY TWISTS AND TURNS I ENDED UP AT THE TEMPLE. "
                dc.b "WITH BLACK OPS CLOSING IN ON ME, I TOOK THE CRYSTAL..",34,0
l_r9:           dc.b 34,"QUITE A STORY. SO.. YOU THOUGHT I WAS DEAD?",34,0
l_r9b:          dc.b 34,"POSSIBLY.. I JUST REMEMBER I HAD NO IDEA WHO TO TRUST, AND THINKING I HAD TO KEEP RUNNING..",34,0
l_r9c:          dc.b 34,"I KNOW THE FEELING.",34,0
l_r10:          dc.b 34,"BUT IT'S PAST NOW. ANYWAY, WHILE I WAS RESTING, THE SENTINELS TOLD ME THEIR IDEAS. "
                dc.b "I GUESS THEY HAVE TOLD YOU SOMETHING AS WELL?",34,0
l_r11:          dc.b 34,"YEAH, AND DON'T QUITE KNOW WHAT TO THINK.",34,0

returntext:     dc.b 9,9, 0,"BACK ON EARTH, LATER..",0,$ff

;-------------------------------------------------------------------------------
;$1c02
;-------------------------------------------------------------------------------

backattemple:   focus ACT_JOANAGENT
                say l_bat0
                plrsay l_bat1
                say l_bat2
                plrsay l_bat3
                say l_bat4
                lda #ACT_JOANAGENT
                sta comradeagent
                settrigger ACT_JOANAGENT,SCRIPT_JOANAGENT,T_CONV|T_APPEAR|T_TAKEDOWN
                stopscript
                stop

l_bat0:         dc.b 34,"THEY SENT US BACK INSIDE THE TEMPLE.",34,0
l_bat1:         dc.b 34,"WE'RE IN QUITE DEEP THIS TIME.",34,0
l_bat2:         dc.b 34,"RIGHT. BUT I'M NOT AFRAID. AT LEAST NOT ANYMORE.",34,0
l_bat3:         dc.b 34,"THE SENTINELS?",34,0
l_bat4:         dc.b 34,"THEY MIGHT BRING CHANGE.. IF WE LET THEM.",34,0

                endscript
