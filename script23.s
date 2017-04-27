;
; Script 23: Sentinels
;

                include scriptm.s

                entrypoint ascension    ;$1700
                entrypoint ascensionrun ;$1701
                entrypoint sentinel1    ;$1702
                entrypoint sentinelteleport ;$1703
                entrypoint sentinel2    ;$1704
                entrypoint followagain  ;$1705
                entrypoint bridge       ;$1706
                entrypoint engine       ;$1707

;-------------------------------------------------------------------------------
;$1700
;-------------------------------------------------------------------------------

ascension:      givepoints 10000
                lda #SFX_POWERUP
                jsr playsfx
                lda #$1a
                ldx #$01                ;Activate beam
                jsr activateobject
                lda #$01
                sta playerscripted      ;Set player in scripted mode
                lda #M_IDLE
                sta actctrl+ACTI_PLAYER
                lda #$ff
                sta actlastdmgact+ACTI_PLAYER
                lda #$00
                sta agentdelay
                lda #-8
                sta agentcounter
                setscript SCRIPT_ASCENSIONRUN
ar_notyet:      stop

ascensionrun:   inc agentdelay
                lda agentdelay
                cmp #25                 ;Delay of one second, then weird things
                bcc ar_notyet           ;start happening
                bne ar_nosound
                lda #SFX_TRAIN
                jsr playsfx
ar_nosound:     lda #PLRFR_OUT
                sta actf1+ACTI_PLAYER
                sta actf2+ACTI_PLAYER
                lda #WF_NONE
                sta actwf+ACTI_PLAYER
                lda #AB_JUMP
                sta actbits+ACTI_PLAYER
                lda agentcounter
                sta actsy+ACTI_PLAYER
                dec agentcounter
                lda agentdelay
                cmp #75
                bcc ar_notyet
                lda #PLRFR_STAND
                sta actf1+ACTI_PLAYER
                sta actf2+ACTI_PLAYER
                lda #$00
                sta actd+ACTI_PLAYER
                sta playerscripted
                sta agentcounter
                sta actsy+ACTI_PLAYER
                settrigger ACT_SENTINEL,SCRIPT_SENTINEL1,T_NEAR|T_CONV
                setscript SCRIPT_SENTINELTELEPORT
                lda #$14           ;Deactivate beam
                jsr clearlvlobjstat
                lda #$15
                jsr clearlvlobjstat
                lda #$16
                jsr clearlvlobjstat
                lda #$17
                jsr clearlvlobjstat
                lda #$1a
                jsr clearlvlobjstat

                lda #$08
                ldx #$18
                jmp enterdoornum


;-------------------------------------------------------------------------------
;$1703
;-------------------------------------------------------------------------------

sentinelteleport:
                ldx agentcounter
                beq st_nosound
                lda #SFX_EXPLOSION
                jsr playsfx
st_nosound:     lda sttbl1,x
                sta zonebg1
                lda sttbl2,x
                sta zonebg2
                lda sttbl3,x
                sta zonebg3
                inc agentcounter
                lda agentcounter
                cmp #$03
                bcc st_notready
                lda #ACT_SENTINEL
                sta comradeagent
                stopscript
st_notready:    rts
sttbl1:         dc.b 1,3,12
sttbl2:         dc.b 1,1,3
sttbl3:         dc.b 1,1,1

;-------------------------------------------------------------------------------
;$1702
;-------------------------------------------------------------------------------

sentinel1:      lda #$00
                sta comradeagent
                lda #M_TURNTOTARGET
                sta actmode,x
                settrigger ACT_SENTINEL, SCRIPT_SENTINEL2, T_CONV
                say l_sen0
sentinel2_done: stop

sentinel2:      setmultibyflags 4,PLOT_SENTINEL_MULTI0
                beq sentinel2_done
                domulti l_sen1m
                setchoiceflag PLOT_SENTINEL_MULTI0 ;Allow each choice once
               ; choice 0,sentinel2_0
                choice 1,sentinel2_1
                choice 2,sentinel2_2
                choice 3,sentinel2_3
sentinel2_0:    say l_sen2
                plrsay l_sen3
                say l_sen4
                plrsay l_sen5
                say l_sen6
                stop
sentinel2_1:    say l_sen7
                setdomulti %00000011, l_sen8m
                selectline l_sen9m
                saynoptr
                stop
sentinel2_2:    say l_sen10
                stop
sentinel2_3:    say l_sen11
                plrsay l_sen12
                stop

l_sen0:         dc.b 34,"GREETINGS, HUMAN. YOU ACTIVATED THE CONTACT SIGNAL. WE ARE THE SENTINELS - WHAT YOU HAVE SEEN "
                dc.b "BEFORE HAVE BEEN JUST CRUDE IMITATIONS.",34,0

l_sen1m:        dc.w l_sen1m0
                dc.w l_sen1m1
                dc.w l_sen1m2
                dc.w l_sen1m3

l_sen1m0:       dc.b 34,"YOU DON'T DISSECT PEOPLE?",34,0
l_sen1m1:       dc.b 34,"WHAT'S YOUR INTENTION?",34,0
l_sen1m2:       dc.b 34,"WHAT'S THIS PLACE?",34,0
l_sen1m3:       dc.b 34,"HOW DO YOU KNOW WHAT I'VE SEEN?",34,0

l_sen2:         dc.b 34,"IT WOULD BE AGAINST OUR POLICY.",34,0
l_sen3:         dc.b 34,"SURELY YOU MUST DO SOMETHING?",34,0
l_sen4:         dc.b 34,"YES, WE HAVE OUR OWN EXPERIMENTS. BUT WE RETURN ORIGINAL SUBJECTS IN GOOD CONDITION.",34,0
l_sen5:         dc.b 34,"WHAT ARE YOU DOING EXACTLY?",34,0
l_sen6:         dc.b 34,"WE ARCHIVE DNA, AND PERFORM HYBRIDIZATION EXPERIMENTS, FOR THE CASE YOUR KIND MANAGES TO WIPE OUT ITSELF.",34,0

l_sen7:         dc.b 34,"WE ARE HERE TO ASSIST AND GUIDE YOUR KIND. UNFORTUNATELY "
                dc.b "THE ENTITY YOU KNOW AS SCEPTRE HAS BEEN WORKING AGAINST OUR GOALS.",34,0

l_sen8m:        dc.w l_sen8m0
                dc.w l_sen8m1

l_sen8m0:       dc.b 34,"BUT THEY ARE MERE HUMANS.",34,0
l_sen8m1:       dc.b 34,"WHAT IF WE REFUSE TO BE GUIDED?",34,0

l_sen9m:        dc.w l_sen9m0
                dc.w l_sen9m1

l_sen9m0:       dc.b 34,"YES, BUT THEY ARE SKILLED IN SPREADING FALSE INFORMATION, NUMBING AND CLOSING MINDS. THE FLIGHTS THEY PERFORM USING IMITATIONS OF OUR CRAFT ARE ESPECIALLY DAMAGING.",34,0
l_sen9m1:       dc.b 34,"FROM OUR EXTRAPOLATIONS - GOING AHEAD ON YOUR CURRENT PATH WILL LEAD TO SERIOUS CATACLYSMS.",34,0

l_sen10:        dc.b 34,"THIS IS A MEDIUM-SIZED SENTINEL CRAFT. THERE ARE SEVERAL OF THEM IN ORBIT OF THE EARTH.",34,0

l_sen11:        dc.b 34,"WE HAVE AN ABILITY TO READ AND INTERPRET BRAIN PATTERNS.",34,0
l_sen12:        dc.b 34,"HMM.. FROM DISTANCE? THAT'S SOMEHOW DISTURBING.",34,0

;-------------------------------------------------------------------------------
;$1705
;-------------------------------------------------------------------------------

followagain:    lda #ACT_SENTINEL
                sta comradeagent
                stop

;-------------------------------------------------------------------------------
;$1706
;-------------------------------------------------------------------------------

bridge:         lda #ACT_SENTINEL
                jsr findactor
                bcc bridgeskip
                say l_bridge
                stop
bridgeskip:     lda aonum
                jmp clearlvlobjstat


;-------------------------------------------------------------------------------
;$1707
;-------------------------------------------------------------------------------

engine:         lda #ACT_SENTINEL
                jsr findactor
                bcc bridgeskip
                say l_engine
                stop

l_engine:       dc.b 34,"HERE IS OUR PROPULSION DEVICE. ITS PRINCIPLE IS YET ABOVE YOUR UNDERSTANDING.",34,0
l_bridge:       dc.b 34,"HERE IS THE BRIDGE. WE STEER THE CRAFT BY THOUGHT.",34,0

                endscript
