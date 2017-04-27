;
; Script file 22, Blowfish
;

                include scriptm.s

                entrypoint blowfishconv2 ;$1600

;-------------------------------------------------------------------------------
; $1600 - Blowfish conversation #2
;-------------------------------------------------------------------------------

bfc2_madlocustcommon:setbit PLOT_MAP_FOREST
                givepoints 10000
                stop

bfc2_goatcommon:
                say l_bfishg1
                plrsay l_bfishg2
                lda #SFX_PICKUP
                jsr playsfx
                say l_bfishg3
                plrsay l_bfishg4
                say l_bfishg5
                stop

bfc2_madlocust2:
                jsr bfc2_madlocustcommon
                plrsay l_bfishml5
                say l_bfishml6
                plrsay l_bfishml7
                say l_bfishml8
                jmp bfc2_goatcommon

bfc2_madlocust1:
                jsr bfc2_madlocustcommon
                plrsay l_bfishml1
                say l_bfishml2
                plrsay l_bfishml3
                say l_bfishml4
                jmp bfc2_goatcommon


blowfishconv2:  getbit PLOT_MAP_FOREST ;Mad Locust sidequest done?
                bne bfc2_nomadlocust
                getbit PLOT_BLOWFISH_MULTI2
                beq bfc2_nomadlocust
                getbit PLOT_MADLOCUST_DEAD
                bne bfc2_madlocust2
                getbit PLOT_MADLOCUST_LETTER
                bne bfc2_madlocust1

bfc2_nomadlocust:
                setmultibyflags 3,PLOT_BLOWFISH_MULTI0
                beq bfc2_none
                domulti l_bfish11m
                setchoiceflag PLOT_BLOWFISH_MULTI0 ;Allow each choice once
                choice 1,bfc2_1
                choice 2,bfc2_2
bfc2_0:         say l_bfish12
                plrsay l_bfish13
                say l_bfish14
bfc2_none:      stop
bfc2_1:         say l_bfish15
                plrsay l_bfish16
                say l_bfish17
                plrsay l_bfish18
                stop
bfc2_2:         say l_bfish19
                setdomulti %00000011,l_bfish20m
                selectline l_bfish21m
                saynoptr
                say l_bfish22
                getbit PLOT_MADLOCUST_DEAD
                bne bfc2_24
                getbit PLOT_MADLOCUST_LETTER
                bne bfc2_24
                plrsay l_bfish23
                stop
bfc2_24:        plrsay l_bfish24
                jmp blowfishconv2

l_bfish11m:     dc.w l_bfish11m0
                dc.w l_bfish11m1
                dc.w l_bfish11m2
l_bfish11m0:    dc.b 34,"WE IN TURN SPY ON SCEPTRE, RIGHT?",34,0
l_bfish11m1:    dc.b 34,"SO YOU'RE A SYSADMIN?",34,0
l_bfish11m2:    dc.b 34,"HOW DID YOU BECOME AN AGENT?",34,0

l_bfish12:      dc.b 34,"THEY COMMUNICATE MAINLY BY SATELLITES. FROM TIME TO TIME WE MANAGE TO "
                dc.b "DECRYPT SOME OF THE MESSAGES, BUT OF COURSE WE CAN NEVER KNOW..",34,0
l_bfish13:      dc.b 34,"KNOW WHAT?",34,0
l_bfish14:      dc.b 34,"IF THEY GIVE US EXACTLY WHAT THEY WANT US TO KNOW.",34,0

l_bfish15:      dc.b 34,"YEAH. I GUESS IT REQUIRES A PECULIAR CHARACTER. MOST OF THE "
                dc.b "TIME I UNDERSTAND THESE MACHINES BETTER THAN HUMANS. "
                dc.b "ALSO, THEY DON'T RETALIATE WHEN I SCREAM AND CURSE AT THEM.",34,0
l_bfish16:      dc.b 34,"INTERESTING.",34,0
l_bfish17:      dc.b 34,"AND YOU? YOU DO SOMETHING IN ADDITION TO BEING AN AGENT?",34,0
l_bfish18:      dc.b 34,"WELL, I'M A MUSICIAN.",34,0

l_bfish19:      dc.b 34,"MY BROTHER, WHO WENT BY THE NAME MAD LOCUST, INITIATED ME TO THE AGENT BUSINESS. BUT HE WAS "
                dc.b "CAPTURED BY SCEPTRE AND SENT TO A PLACE CALLED EREHWON.",34,0
l_bfish20m:     dc.w l_bfish20m0
                dc.w l_bfish20m1
l_bfish20m0:    dc.b 34,"I'M SORRY TO HEAR THAT.",34,0
l_bfish20m1:    dc.b 34,"WHAT'S THAT PLACE?",34,0
l_bfish21m:     dc.w l_bfish21m0
                dc.w l_bfish21m1
l_bfish21m0:    dc.b 34,"THANKS TO HIM, I KNOW A LOT MORE OF HOW THIS ROTTEN WORLD IS GOVERNED.",34,0
l_bfish21m1:    dc.b 34,"LEGEND TELLS IT'S A COMBINED PRISON AND INSANE ASYLUM.",34,0
l_bfish22:      dc.b 34,"ANYWAY, IF YOU COME ACROSS THAT PLACE, AND FIND ANY INFO ON HIM, I'D BE GLAD TO KNOW.",34,0
l_bfish23:      dc.b 34,"I'LL LOOK INTO IT.",34,0
l_bfish24:      dc.b 34,"I'VE COME ACROSS SOME INFO.",34,0

l_bfishml1:     dc.b 34,"I FOUND A LETTER WRITTEN BY MAD LOCUST.",34,0
l_bfishml2:     dc.b 34,"FROM A CELL IN EREHWON?",34,0
l_bfishml3:     dc.b 34,"YES. IT WAS EMPTY.",34,0
l_bfishml4:     dc.b 34,"THEN HE'S PROBABLY DEAD.",34,0

l_bfishml5:     dc.b 34,"I HAVE NEWS. BUT NOT GOOD.",34,0
l_bfishml6:     dc.b 34,"YES? I'M PREPARED.",34,0
l_bfishml7:     dc.b 34,"MAD LOCUST WAS EXPERIMENTED ON FOR A WHILE, UNTIL HE DIED.",34,0
l_bfishml8:     dc.b 34,"I'M.. NOT SURPRISED.",34,0

l_bfishg1:      dc.b 34,"ANYWAY, I'VE BEEN DOING SOME DIGGING AS WELL. YOU KNOW A GUY CALLED GOAT?",34,0
l_bfishg2:      dc.b 34,"YEAH. WE KICKED SOME ASS, BUT AFTER THAT HE WENT BACK "
                dc.b "TO THE WOODS AND I DON'T KNOW EXACTLY WHERE.",34,0
l_bfishg3:      dc.b 34,"THIS SATELLITE IMAGE REVEALED HIS NEW LOCATION. WOULD SCEPTRE BE INTERESTED?",34,0
l_bfishg4:      dc.b 34,"LIKELY..",34,0
l_bfishg5:      dc.b 34,"MAYBE YOU SHOULD WARN HIM.",34,0

                endscript
