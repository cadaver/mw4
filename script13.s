;
; MW4 Scriptfile 13: Ahriman
;

                include scriptm.s

                entrypoint ahriman      ;$d00
                entrypoint ahrimanfight ;$d01

;-------------------------------------------------------------------------------
; $0d00
;-------------------------------------------------------------------------------

ahriman:        removetrigger ACT_AHRIMANBYSTD
                settrigger ACT_AHRIMAN,SCRIPT_AHRIMANFIGHT,T_APPEAR|T_REMOVE|T_TAKEDOWN
                setbit PLOT_AHRIMAN_MULTI1
                focus ACT_AHRIMANBYSTD
                say l_a0
                setdomulti %00000111,l_a1m
                cmp #2
                beq ahrimanskip
                selectline l_a2m
                saynoptr
ahrimanskip:    say l_a3
ahrimanloop:    setmultibyflags 7,PLOT_AHRIMAN_MULTI0
                domulti l_a8m
                setchoiceflag PLOT_AHRIMAN_MULTI0 ;Allow each choice only once
                selectline l_a9m
                saynoptr
                lda choicenum
                cmp #$00
                bne ahriman_skip2
                clearbit PLOT_AHRIMAN_MULTI1
ahriman_skip2:
                lda choicenum
                cmp #$04
                bne ahriman_skip
                plrsay l_a10
                say l_a11
ahriman_skip:   lda choicenum
                cmp #$06
                bne ahrimanloop

                ldx actrestx
                lda #ACT_AHRIMAN
                sta actt,x
                jsr initcomplexactor_noweap
                jmp ahriman_appear

l_a0:           dc.b 34,"YOU'VE MADE IT THIS FAR. QUITE ADMIRABLE. BUT I'M SURE "
                dc.b "YOU HAVE NO IDEA OF SCEPTRE'S TRUE PURPOSE. PERHAPS YOU "
                dc.b "THINK WE'RE JUST PERFORMING RANDOM ACTS OF EVIL? "
                dc.b "CONSPIRACY FOR CONSPIRACY'S SAKE?",34,0
l_a1m:          dc.w l_a1m0
                dc.w l_a1m1
                dc.w l_a1m2
l_a1m0:         dc.b 34,"YOU'RE .. AHRIMAN?",34,0
l_a1m1:         dc.b 34,"IT HAS LOOKED LIKE THAT SO FAR.",34,0
l_a1m2:         dc.b 34,"JUST GO AHEAD.",34,0

l_a2m:          dc.w l_a2m0
                dc.w l_a2m1
l_a2m0:         dc.b 34,"YES. HIGH PRIEST AHRIMAN.",34,0
l_a2m1:         dc.b 34,"I WAS SURE YOUR PERSPECTIVE WOULD BE LIMITED.",34,0

l_a3:           dc.b 34,"FOR CENTURIES, WE HAVE EXISTED TO "
                dc.b "MAINTAIN BALANCE AND ENSURE MANKIND STAYS "
                dc.b "IN CONTROL. "
                dc.b "YOU MIGHT BE AWARE OF THE SENTINELS. THEY WANT TO "
                dc.b "'GUIDE' US, BUT THE TRUTH IS, WE REMAIN INFERIOR TO THEM. "
                dc.b "DON'T BE DECEIVED, THEIR PURPOSE IS TO ENSLAVE.",34,0

l_a8m:          dc.w l_a6
                dc.w l_a8m0
                dc.w l_a8m1
                dc.w l_a8m2
                dc.w l_a8m3
                dc.w l_a8m4
                dc.w l_a8m5

l_a6:           dc.b 34,"YOU ORDERED THE FAKE ALIEN ATTACK.",34,0
l_a8m0:         dc.b 34,"YOU SHOULD'VE SENT THE BLACK OPS.",34,0
l_a8m1:         dc.b 34,"A FEW INNOCENTS DOESN'T MATTER?",34,0
l_a8m2:         dc.b 34,"SOME IN SCEPTRE WANT TO GET RID OF YOU.",34,0
l_a8m3:         dc.b 34,"WHAT'S THIS 'PROCESS' ABOUT?",34,0
l_a8m4:         dc.b 34,"YOU'RE NOT OFFERING ME A DEAL?",34,0
l_a8m5:         dc.b 34,"LET'S GET THIS OVER WITH.",34,0

l_a9m:          dc.w l_a7
                dc.w l_a9m0
                dc.w l_a9m1
                dc.w l_a9m2
                dc.w l_a9m3
                dc.w l_a9m4
                dc.w l_a9m5

l_a7:           dc.b 34,"YES. BUT SEEMS I CANNOT TRUST MY OWN - THE ORDERS WERE "
                dc.b "CHANGED TO LEAVE YOU BEHIND, ALIVE. A PITY, YOUR HEAD "
                dc.b "MIGHT HAVE BEEN USEFUL.",34,0
l_a9m0:         dc.b 34,"WHERE'S THE IMAGINATION IN THAT? THAT'S WHAT LILITH WOULD HAVE DONE.",34,0
l_a9m1:         dc.b 34,"THEY SHOULD'VE CHOSEN THEIR COMPANY BETTER. THOUGH ONE OF THEM PROVED TO BE MOST COMPATIBLE..",34,0
l_a9m2:         dc.b 34,"AND YOU ARE HAPPY TO BE THEIR EXECUTIONER? AND GAIN WHAT? HAVE NO DOUBT, THEY WILL BETRAY YOU.",34,0
l_a9m3:         dc.b 34,"THE DEDICATED ELDER PRIESTS HAVE "
                dc.b "AGREED TO HAVE THEIR HEAD SEPARATED SO THEY CAN SERVE US LONGER. TECHNOLOGY "
                dc.b "ALLOWS THE METABOLISM TO BE SLOWED DOWN, BUT YET THERE ARE LIMITS. THE PROCESS MIGHT OVERCOME THIS.",34,0
l_a9m4:         dc.b 34,"WHY SHOULD I? I KNOW YOU'RE A MUSICIAN AND A REBEL, WHO CAN'T COMPREHEND OUR VISION. AND AS FOR RAW POWER, WE ALREADY HAVE ENOUGH.",34,0
l_a9m5:         dc.b 34,"YES.. I AGREE.",34,0

l_a10:          dc.b 34,"YOU WANT TO BECOME IMMORTAL.",34,0
l_a11:          dc.b 34,"TO BE ABLE TO SERVE MANKIND LONGER.",34,0
;-------------------------------------------------------------------------------
; $0d01
;-------------------------------------------------------------------------------

ahrimanfight:   choice T_APPEAR,ahriman_appear
                choice T_REMOVE,ahriman_remove
ahriman_takedown:
                lda #ITEM_GASFIST_MK2
                sta actwpn,x    ;Make sure gasfist gets dropped
                lda actlastdmghp,x
                bpl ahriman_notdead
                setbit PLOT_AHRIMAN_DEAD
ahriman_notdead:
                lda actt,x
                jsr removeactortrigger
ahriman_remove: jmp playzonetune

ahriman_appear:lda tunenum
                and #$fc
                ora #$03
                jmp playgametune

                endscript
