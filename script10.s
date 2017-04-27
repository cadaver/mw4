;
; MW4 Scriptfile 10: Codes+betrayal, Blowfish intro
;

                include scriptm.s

                entrypoint unused               ;$a00
                entrypoint decoding             ;$a01
                entrypoint blackops             ;$a02
                entrypoint decoding2            ;$a03
                entrypoint blackhandcombat      ;$a04
                entrypoint blowfishintro        ;$a05
                entrypoint blowfishpathstart    ;$a06
                entrypoint blowfishpathrun      ;$a07
                entrypoint sadokhint            ;$a08

;-------------------------------------------------------------------------------
; $0a00
;-------------------------------------------------------------------------------

unused:         stop

;-------------------------------------------------------------------------------
; $0a01,$a03
;-------------------------------------------------------------------------------

decoding:
                say l_cf0
                lda #SFX_PICKUP
                jsr playsfx
                lda #ITEM_CODESHEET1
                jsr removeitem
                lda #ITEM_CODESHEET2
                jsr removeitem
                lda #ITEM_CODESHEET3
                jsr removeitem
                lda #ITEM_CODESHEET4
                jsr removeitem
                setscript SCRIPT_DECODING2
                settrigger ACT_BLACKHAND,SCRIPT_DECODING2,T_APPEAR
                stop

decoding2_stop: stopscript
decoding2_notyet:
                lda #$00
                sta agentdelay
decoding2_notyet2:
                stop
decoding2:      setscript SCRIPT_DECODING2
                focus ACT_BLACKHAND
                bcc decoding2_stop
                lda #$27
                sta waypointxh
                lda #$0f
                sta waypointyh
                lda #WAYPOINT0
                sta acttarget,x
                lda #M_GOTO
                sta actmode,x
                lda actxh,x
                cmp #$27
                bne decoding2_notyet
                inc agentdelay
                lda agentdelay
                cmp #25
                bcc decoding2_notyet2
                stopscript
                focus ACT_SARGE
                say l_cf1
                lda #SFX_POWERUP
                jsr playsfx
                lda #25
                jsr waitforfire
                say l_cf2
                focus ACT_BLACKHAND
                say l_cf3
                jsr beginfullscreen
                jsr border
                jsr cf_randomdata
                jsr cf_randomdata
                jsr cf_randomdata
                lda #SFX_TRANSMISSION
                jsr playsfx
                lda #<cf_decodedmsg
                ldy #>cf_decodedmsg
                jsr printscreentext
                lda #MSGTIME_ETERNAL
                jsr waitforfire
                jsr endfullscreen
                say l_cf4
                lda #SFX_TAKEDOWN
                jsr playsfx
                lda #$02
                sta agenttvscreen      ;Suhrim appears
                setbit PLOT_SUHRIM_SEEN
                saytrans l_cf5

                focus ACT_BLACKHAND
                lda #ITEM_9MM_SUBMACHINEGUN
                sta actwpn,x ;Blackhand has to reload first..
                stx sarge_target+1
                focus ACT_SARGE
                say l_cf6
                lda #$00
                sta agenttvscreen
                ldx actrestx
                stx bh_target+1

                lda #ACT_SARGETRAITOR
                sta actt,x
                jsr initcomplexactor
                lda #ITEM_SHOTGUN
                sta actwpn,x
                lda #M_COMBAT
                sta actmode,x
sarge_target:   lda #$00
                sta acttarget,x
                lda #0
                sta actf1,x
                sta actf2,x
                lda #$80
                sta actd,x
                lda #8                 ;Make sure there's bullets..
                sta actclip,x
                lda #2                 ;Fire once and then plan further
                sta actattklen,x       ;conspiracies..
                lda #JOY_FIRE+JOY_LEFT
                sta actctrl,x
                lda #<l_cf7
                ldx #>l_cf7
                ldy #MSGTIME
                jsr printmsgax

                settrigger ACT_BLACKHAND,SCRIPT_BLACKHANDCOMBAT,T_TAKEDOWN|T_CONV
                lda #ACT_BLACKHAND
                sta comradeagent
                getbit PLOT_BLACKHAND_WARNED
                jumpfalse nowarning
                focus ACT_BLACKHAND
                lda #30 ;Have full clip
                sta actclip,x
                lda #M_COMBAT
                sta actmode,x
bh_target:      lda #$00
                sta acttarget,x
                lda #JOY_FIRE+JOY_RIGHT         ;Duck and fire..
                sta actctrl,x
                lda actbits,x
                ora #AB_DUCK
                sta actbits,x
                lda #PLRFR_DUCK
                sta actf1,x
                sta actf2,x
                lda #JOY_DOWN
                sta actmovectrl,x
                lda #10
                sta actattklen,x
nowarning:

                lda tunenum                     ;Start fightmusic
                and #$fc
                ora #$03
                sta zonemusic
                sta zonemusic+1
                sta zonemusic+2
                sta zonemusic+3
                jsr playzonetune
                lda #$00
                sta agentdelay
                setscript SCRIPT_BLACKOPS       ;Set delay for the BlackOps
                                                ;bursting in
                getbit PLOT_EXAGENT_RANT_LISTENED ;If listened to the Ex-agent
                jumpfalse cf_noexagent            ;before, give another conv.
                settrigger ACT_EXAGENT,SCRIPT_EXAGENT2,T_CONV
cf_noexagent:   

                settrigger ACT_BARTENDER,SCRIPT_SADOK_HINT,T_NEAR
                settrigger ACT_AXESMITH,SCRIPT_SADOK_HINT2,T_NEAR
                settrigger ACT_SADOK,SCRIPT_SADOK,T_APPEAR|T_NEAR|T_CONV
                setbit PLOT_MAP_MANSION ;Mansion known now..
                stop

cf_randomdata:  lda #$05
                sta cf_randomstring+1
cf_loop:        ldx #21
cf_loop2:       jsr random
                and #$1f
                beq cf_loop2
                cmp #27
                bcc cf_charok
                adc #(48-27)-1
cf_charok:      sta cf_randomstring+3,x
                dex
                bpl cf_loop2
                lda #<cf_randomstring
                ldy #>cf_randomstring
                jsr printscreentext
                inc cf_randomstring+1
                lda cf_randomstring+1
                cmp #11
                bcc cf_loop
                lda #8
                jmp waitforfire

cf_randomstring:dc.b 9,5,1,"                      ",0,$ff

cf_decodedmsg:  dc.b 9,5,1,"TO: MAJESTIC FOUR     ",0
                dc.b 9,6,1,"                      ",0
                dc.b 9,7,1,"YOU ARE ENTRUSTED     ",0
                dc.b 9,8,1,"WITH THE INNER SPHERE ",0
                dc.b 9,9,1,"ACCESS POINT - MANSION",0
               dc.b 9,10,1,"AT N47.342 E10.451    ",0,$ff


l_cf0:          dc.b 34,"LET'S SCAN ALL THE CODE SHEETS AND SEE WHAT WE'LL FIND OUT.",34,0

l_cf1:          dc.b 34,"SCANNING NOW...",34,0

l_cf2:          dc.b 34,"DONE. I'LL TRY SOME STANDARD DECRYPTION ALGORITHMS, OK?",34,0

l_cf3:          dc.b 34,"GO AHEAD.",34,0

l_cf4:          dc.b 34,"INNER SPHERE.. ACCORDING TO WHAT LITTLE INFO WE HAVE, THAT'S WHERE THE SCEPTRE HIGH-LEVEL COMMAND OPERATES. IT MIGHT BE WORTH INVESTIGATING..",34,0

l_cf5:          dc.b 34,"THE SCEPTRE IS GRATEFUL FOR THE FREE SECURITY AUDIT YOU GAVE. UNFORTUNATELY, NOW YOU MUST DIE. WOTAN MIT UNS!",34,0

l_cf6:          dc.b 34,"WOTAN MIT UNS. YES - MUST..",34,0

l_cf7:          dc.b 34,"KILL!",34,0

;-------------------------------------------------------------------------------
; $0a02
;-------------------------------------------------------------------------------

blackops:       inc agentdelay
                lda agentdelay
                cmp #75                 ;Three seconds
                bcs blackops_attack
                stop
blackops_attack:stopscript
                lda #SPRF_COMMANDO      ;Preload commandos
                jsr loadsprites


                lda #SFX_DAMAGE
                jsr playsfx
                lda #$17                ;Open ventilation grates
                ldx #$01
                jsr activateobject
                lda #$18
                ldx #$01
                jsr activateobject
                lda #$8f                ;Third commando
                ldx #$06
                jsr ao_revealcommon

                stop

;-------------------------------------------------------------------------------
; $0a04
;-------------------------------------------------------------------------------

blackhandcombat:;choice T_TAKEDOWN,bhc_down
                choice T_CONV,bhc_conv
bhc_down:       setbit PLOT_BLACKHAND_DEAD
                removetrigger ACT_BLACKHAND
                stop

bhc_conv:       jsr isincombat
                bcs bhc_convskip
                jsr random
                and #$03
                selectline l_bhc
                saynoptr
bhc_convskip:   stop

l_bhc:          dc.w l_bhc0
                dc.w l_bhc1
                dc.w l_bhc2
                dc.w l_bhc3

l_bhc0:         dc.b 34,"THIS PLACE HAS BEEN COMPROMISED.",34,0
l_bhc1:         dc.b 34,"DAMN, SHOULD HAVE KNOWN..",34,0
l_bhc2:         dc.b 34,"SCEPTRE WILL PAY FOR THIS..",34,0
l_bhc3:         dc.b 34,"YOU'D BETTER GET OUT OF HERE.",34,0

;-------------------------------------------------------------------------------
; $0a05
;-------------------------------------------------------------------------------

blowfishintro:  setbit PLOT_BLOWFISH_MET
                setbit PLOT_BLACKHAND_MULTI4 ;Disable "How do I find..."
                givepoints 5000
                say l_bfish0
                settrigger ACT_BLOWFISH,SCRIPT_BLOWFISHPATHSTART,T_APPEAR
                lda #$00
                sta blowfishwaypoint
                sta blowfishdelay
                ;Fall through
;-------------------------------------------------------------------------------
; $0a06
;-------------------------------------------------------------------------------

blowfishpathstart:
                setscript SCRIPT_BLOWFISHPATHRUN
                stop

l_bfish0:       dc.b 34,"YOU MUST BE THE GUY. I'M BLOWFISH, BUT WE CAN'T SPEAK HERE. FOLLOW ME.",34,0

;-------------------------------------------------------------------------------
; $0a07
;-------------------------------------------------------------------------------

blowfishpathquit:
                stopscript              ;Quit if Blowfish goes offscreen
                stop

blowfishpathrun:
                focus ACT_BLOWFISH
                bcc blowfishpathquit
                lda blowfishdelay
                beq blowfishnowait
                dec blowfishdelay
                stop
blowfishnowait: ldy blowfishwaypoint
                lda bfy,y                ;Special action?
                beq blowfishalldone
                bpl blowfishpathnormal   ;No, normal waypoint
                lda bfx,y
                bmi blowfishenter
                jsr getlvlobjstat       ;Skip if already active (V1.1)
                bne blowfishobjskip
                ldy blowfishwaypoint
                lda bfx,y
                jsr activateobject
                lda #DOORENTERDELAY     ;Some delay after activation
                sta blowfishdelay
                lda #SFX_OBJECT
                jsr playsfx
blowfishobjskip:inc blowfishwaypoint
                stop
blowfishalldone:
                lda #M_TURNTOTARGET
                sta actmode,x
                lda #$00
                sta acttarget,x
                settrigger ACT_BLOWFISH,SCRIPT_BLOWFISHCONV,T_NEAR|T_CONV
                stopscript
blowfishenterwait:
                stop

blowfishenter:  and #$7f
                tay
                lda levelnum            ;Move within same level
                sta temp7
                lda lvlobjd1,y          ;Take destination lowbyte
                tay                     ;(door within level)
                ldx lvlobjx,y           ;Take dest X
                lda lvlobjy,y
                and #$7f
                clc
                adc #$01
                tay                     ;Dest Y
                lda #ACT_BLOWFISH
                inc blowfishwaypoint    ;Increment for next time
                jmp transportactor      ;Do transport

blowfishpathnormal:                     ;Normal navigation
                sta waypointyh
                lda bfx,y
                sta waypointxh
                lda #M_GOTO
                sta actmode,x
                lda #WAYPOINT0
                sta acttarget,x
                lda actxh,x             ;Check for reaching target
                cmp waypointxh
                bne blowfishpathskip
                lda actyh,x             ;Check for reaching target
                cmp waypointyh
                bne blowfishpathskip
                inc blowfishwaypoint    ;Next waypoint
blowfishpathskip:stop

bfx:            dc.b $3c
                dc.b $05 ;Activate
                dc.b $85 ;Enter
                dc.b $07
                dc.b $03
                dc.b $07
                dc.b $03
                dc.b $07
                dc.b $03
                dc.b $07
                dc.b $03
                dc.b $0a ;Activate
                dc.b $8a ;Enter
                dc.b $17
                dc.b $0c ;Activate
                dc.b $8c ;Enter
                dc.b $24
                dc.b $00

bfy:            dc.b $0c
                dc.b $80 ;Special
                dc.b $80 ;Special
                dc.b $1b
                dc.b $1b
                dc.b $18
                dc.b $18
                dc.b $15
                dc.b $15
                dc.b $12
                dc.b $12
                dc.b $80 ;Special
                dc.b $80 ;Special
                dc.b $13
                dc.b $80 ;Special
                dc.b $80 ;Special
                dc.b $13
                dc.b $00

;-------------------------------------------------------------------------------
; $0a08
;-------------------------------------------------------------------------------

sadokhint:      getbit PLOT_SADOK_HINT
                jumptrue sh_skippoints
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
                jumptrue sh_old
                getbit PLOT_SADOK_HINT
                jumptrue sh_old
                setbit PLOT_SADOK_HINT
                plrsay l_sh4
                say l_sh5
sh_commonend:   settrigger ACT_BARTENDER,SCRIPT_BARTENDER,T_CONV ;Restore normal script
                stop
sh_old:         plrsay l_sh4b
                jmp sh_commonend

l_sh1:          dc.b 34,"YOU ARE IAN? A MESSAGE WAS LEFT FOR YOU.",34,0
l_sh2:          dc.b 34,"WHAT IS IT?",34,0
l_sh3:          dc.b 34,"A 'PARTNER IN CRIME' IS WAITING AT 'THE FARM'.",34,0
l_sh4:          dc.b 34,"WHAT DID THE GUY LOOK LIKE?",34,0
l_sh5:          dc.b 34,"DRESSED IN BLACK, AND HAD PART OF HIS FACE COVERED.",34,0

l_sh4b:         dc.b 34,"YEAH, I KNOW.",34,0

                endscript
