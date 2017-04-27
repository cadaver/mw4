;
; MW4 Scriptfile 08: Agent briefing end / leaving HQ
;

                include scriptm.s               ;Script macros etc.

                entrypoint blackhandconv        ;$800
                entrypoint agencyexitdoor       ;$801
                entrypoint blackhandleaveinit   ;$802
                entrypoint blackhandleave       ;$803

;-------------------------------------------------------------------------------
; $0800
;-------------------------------------------------------------------------------

blackhandconv:  getbit PLOT_BLACKHAND_GOODLUCK_DONE
                jumptrue bhc_normal
                lda actt+ACTI_PLAYER            ;Agent?
                cmp #ACT_IANAGENT
                bne bhc_normal
bhc_goodluck:   settrigger ACT_BLACKHAND,SCRIPT_BLACKHANDCONV,T_CONV ;Revert back to manual
                setbit PLOT_BLACKHAND_GOODLUCK_DONE ;Wish good luck only once
                say l_bch2
                plrsay l_bch3
                stop

bhc_normal:     getbit PLOT_SARGE_EREHWON
                jumpfalse bhc_noerehwon
                getbit PLOT_BLACKHAND_WARNED
                jumptrue bhc_noerehwon
                setbit PLOT_BLACKHAND_WARNED
                givepoints 10000
                plrsay l_bche0
                say l_bche1
                plrsay l_bche2
                say l_bche3
                stop

bhc_noerehwon:  setmultibyflags 5,PLOT_BLACKHAND_MULTI0
                beq bhc_none
                domulti l_bch0m
                setchoiceflag PLOT_BLACKHAND_MULTI0 ;Allow each choice only once
                selectline l_bch1m
                saynoptr
bhc_none:       stop

l_bch0m:        dc.w l_bch0m0
                dc.w l_bch0m1
                dc.w l_bch0m2
                dc.w l_bch0m3
                dc.w l_bch0m4
l_bch0m0:       dc.b 34,"WHY AM I DOING THIS?",34,0
l_bch0m1:       dc.b 34,"HOW LONG HAVE YOU BEEN AN AGENT?",34,0
l_bch0m2:       dc.b 34,"WHAT METAL HAS TO DO WITH AGENTS?",34,0
l_bch0m3:       dc.b 34,"HOW DOES SCEPTRE OPERATE?",34,0
l_bch0m4:       dc.b 34,"HOW DO I FIND BLOWFISH?",34,0

l_bch1m:        dc.w l_bch1m0
                dc.w l_bch1m1
                dc.w l_bch1m2
                dc.w l_bch1m3
                dc.w l_bch1m4

l_bch1m0:       dc.b 34,"IT'S NATURAL TO HAVE DOUBTS. YOU'RE HOLDING UP "
                dc.b "ADMIRABLY CONSIDERING WHAT YOU'VE JUST GONE THROUGH. I CAN "
                dc.b "ONLY SPEAK FOR MYSELF, BUT "
                dc.b "I'D SURE AS HELL WANT TO LOOK FOR THE TRUTH. ALSO, DON'T "
                dc.b "WANT TO GIVE TOO MUCH HOPE, BUT IT'S POSSIBLE YOUR "
                dc.b "FRIENDS ARE STILL ALIVE.",34,0

l_bch1m1:       dc.b 34,"TWENTY YEARS. WE BOTH HAVE BEEN IN FROM THE START. ONCE THERE WERE TENS "
                dc.b "OF US, BUT MANY WERE KILLED OR CAPTURED BY SCEPTRE.",34,0

l_bch1m2:       dc.b 34,"THOUGHT YOU'D ASK. OUR ORIGINAL PURPOSE WAS TO SPREAD "
                dc.b "INFORMATION ON CONSPIRACIES THROUGH METAL MUSIC, BUT THAT DIDN'T PROVE EFFICIENT, "
                dc.b "SO WE HAD TO TRY OTHER METHODS. "
                dc.b "NOT ALL AGENTS HAD MUSICAL TENDENCIES THOUGH. I NEVER PLAYED "
                dc.b "ANYTHING, BUT KNEW HOW TO USE MY VOICE.",34,0

l_bch1m3:       dc.b 34,"THEY EXERT DIRECT AND INDIRECT CONTROL ON POLITICS, COMMERCE AND MEDIA. "
                dc.b "FROM TIME TO TIME THEY ALSO USE TERROR TACTICS THROUGH "
                dc.b "THEIR BLACK OPS TROOPS.",34,0

l_bch1m4:       dc.b 34,"WE'LL INFORM HER OF YOUR ARRIVAL. YOU WILL LIKELY MEET IN THE "
                dc.b "UNIVERSITY LOBBY.",34,0

l_bch2:         dc.b 34,"I SEE YOU'RE READY TO GO. THE EXIT DOOR CAMERA WILL "
                dc.b "NOW RECOGNIZE YOU, LETTING YOU IN AND OUT FREELY. TRY "
                dc.b "TO STAY ALIVE, AND IF YOU FIND ANYTHING SIGNIFICANT - "
                dc.b "PLEASE LET US KNOW.",34,0
l_bch3:         dc.b 34,"I'LL TRY.",34,0

l_bche0:        dc.b 34,"DID YOU KNOW SARGE SPENT TIME IN EREHWON?",34,0
l_bche1:        dc.b 34,"HE NEVER TOLD THAT.. I ONLY KNEW HE DISAPPEARED ONCE FOR A BIT LONGER TIME.",34,0
l_bche2:        dc.b 34,"THERE WAS SOMETHING ABOUT 'PHRASE-RESPONSE TRAINING'. MAYBE YOU SHOULD WATCH OUT.",34,0
l_bche3:        dc.b 34,"I WILL. THANKS.",34,0

;-------------------------------------------------------------------------------
; $0801
;-------------------------------------------------------------------------------

agencyexitdoor: lda #SFX_OBJECT
                jsr playsfx
                lda actt+ACTI_PLAYER    ;Allow entry if Agent
                cmp #ACT_IANAGENT
                bne aed_noentry
                checkbit PLOT_MAP_ALLOWED
                jumptrue aed_skip
                settrigger ACT_BLACKHAND,SCRIPT_BLACKHANDCONV,T_CONV ;Revert back to manual
                setbit PLOT_BLACKHAND_GOODLUCK_DONE
                setbit PLOT_MAP_COMMINT
                setbit PLOT_MAP_ALLOWED ;Allow mapscreen
aed_skip:       ldx #ACTI_PLAYER
                lda #$0d
                jmp activateobject

aed_noentry:    lda #<aed_text
                ldx #>aed_text
                ldy #MSGTIME
                jmp printmsgax

aed_text:       dc.b "AGENT NOT IDENTIFIED - ACCESS DENIED",0

;-------------------------------------------------------------------------------
; $0802
;-------------------------------------------------------------------------------

blackhandleaveinit:
                lda comradeagent
                cmp #ACT_BLACKHAND
                bne bhc_nearskip
                focus ACT_BLACKHAND
                bcc bhc_nearskip
                say l_bchl0
                plrsay l_bchl1
                lda #$00
                sta comradeagent
                removetrigger ACT_BLACKHAND
                setscript SCRIPT_BLACKHANDLEAVE
bhc_nearskip:   stop

;-------------------------------------------------------------------------------
; $0803
;-------------------------------------------------------------------------------

blackhandleave: focus ACT_BLACKHAND
                bcc bhl_exit
                lda #M_FREE
                sta actmode,x
                lda #JOY_RIGHT
                sta actctrl,x
                lda actxh,x
                cmp #$23
                bne bhl_notyet
                lda actxl,x
                cmp #$e0
                bcc bhl_notyet
bhl_exit:       lda #$7f                ;Transport to ethereal void :)
                sta temp7
                lda #ACT_BLACKHAND
                jsr transportactor
                stopscript
bhl_notyet:     stop

l_bchl0:        dc.b 34,"THIS PLACE CAN'T BE USED AS AN HQ ANYMORE. YOU GO AHEAD, I WILL GO "
                dc.b "IN ONE LAST TIME TO MAKE ARRANGEMENTS. TAKE CARE OF YOURSELF - WE'LL MEET AGAIN.",34,0
l_bchl1:        dc.b 34,"YOU TOO.",34,0

                endscript
