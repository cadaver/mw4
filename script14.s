                include scriptm.s

                entrypoint obskurius            ;$e00
                entrypoint exagent              ;$e01
                entrypoint goatmessage          ;$e02
                entrypoint exagent2             ;$e03

;-------------------------------------------------------------------------------
; $0e00 Meeting Lord Obskurius' disembodied head
;-------------------------------------------------------------------------------

oskip:          stop
obskurius:      removetrigger ACT_OBSKURIUSHEAD
                lda acthp,x                     ;Alive?
                beq oskip
                givepoints 10000
                plrsay l_o2
                say l_o3
                getbit PLOT_JOAN_MET
                jumptrue oskiplament
                plrsay l_o3b ;Some additional lamentation of the Agent
oskiplament:    plrsay l_o4
                say l_o5
                plrsay l_o6
                say l_o7
                setdomulti %00000111,l_o8m
                stop

l_o2:           dc.b 34,"LORD OBSKURIUS! THOSE BASTARDS DID THIS..?",34,0
l_o3:           dc.b 34,"ONLY I SURVIVED THE PREPARATION..",34,0
l_o3b:          dc.b 34,"THOSE PIGS.. JOAN - PERHAPS "
                dc.b "I'LL SEE YOU BEYOND. AND SATANAKHIA - NEVER KNEW YOU THAT WELL, BUT YOU'LL BE REMEMBERED..",34,0
l_o4:           dc.b 34,"BUT.. WHY WOULD THEY DO SUCH THING?",34,0
l_o5:           dc.b 34,"WANT TO PROLONG THEIR LIVES.. PERSONALITY TRANSFER - MUST MAKE SURE THE PROCESS IS FLAWLESS..",34,0
l_o6:           dc.b 34,"THE SCEPTRE PRIESTS?",34,0
l_o7:           dc.b 34,"NOW I HAVE ONE WISH. DISCONNECT ME. AND IF I WAS YOU, I'D KILL AS MANY AS I COULD..",34,0
l_o8m:          dc.w l_o8m0
                dc.w l_o8m1
                dc.w l_o8m2
l_o8m0:         dc.b 34,"I'LL SEE WHAT I CAN DO.",34,0
l_o8m1:         dc.b 34,"THAT'S NOT THE ANSWER.",34,0
l_o8m2:         dc.b 34,"NONE WILL BE SPARED.",34,0

;-------------------------------------------------------------------------------
; $0e01 Ex-Agent Rant
;-------------------------------------------------------------------------------

exagent:        lda actt+ACTI_PLAYER            ;This check just for hacking,
                cmp #ACT_IANAGENT               ;as it's normally impossible
                beq exagent_ok                  ;to be here as non-agent :)
                stop
exagent_ok:     removetrigger ACT_EXAGENT
                setbit PLOT_EXAGENT_RANT_LISTENED
                givepoints 5000
                say l_dis1
                plrsay l_dis2
                say l_dis3
                plrsay l_dis4
                say l_dis5
                setdomulti %00000011, l_dis6m
                ;choice 0,ea_norant
                choice 1,ea_rant
ea_norant:      say l_dis7
                stop
ea_rant:        say l_dis8
                plrsay l_dis9
                stop


l_dis1:         dc.b 34,"AN AGENT, I SEE.",34,0

l_dis2:         dc.b 34,"SHOULDN'T YOU KEEP YOUR VOICE DOWN?",34,0

l_dis3:         dc.b 34,"WHO'S LISTENING? SCEPTRE? I SAY, "
                dc.b "TO HELL WITH SCEPTRE. TO HELL WITH THE AGENTS. "
                dc.b "I WAS AN AGENT ONCE, BUT THEY'VE BETRAYED THEIR IDEALS.",34,0

l_dis4:         dc.b 34,"YOU'RE DRUNK.",34,0

l_dis5:         dc.b 34,"WANT TO HEAR WHAT I'VE GOT TO SAY?",34,0

l_dis6m:        dc.w l_dis6m0
                dc.w l_dis6m1
l_dis6m0:       dc.b 34,"NO THANKS, I'LL PASS.",34,0
l_dis6m1:       dc.b 34,"YEAH, GO AHEAD.",34,0

l_dis7:         dc.b 34,"YOUR LOSS.",34,0
l_dis8:         dc.b 34,"THE AGENTS THOUGHT THEY COULD WIN SCEPTRE WITH GUNS, AND CHALLENGED THEM. "
                dc.b "BUT THEY DIDN'T HAVE AN IDEA OF JUST HOW VAST SCEPTRE IS. "
                dc.b "THE AGENTS WILL BE ERASED OFF THE FACE OF THIS PLANET, ONE BY ONE. "
                dc.b "IN THE BEGINNING IT WAS DIFFERENT. WE WERE DOING CAREFULLY PLANNED MISSIONS "
                dc.b "TO GATHER EVIDENCE AND BRING IT TO THE PEOPLE. BUT THAT WASN'T ENOUGH FOR "
                dc.b "BLACKHAND AND OTHERS LIKE HIM. INSTEAD OF FREEDOM, METAL AND MIGHT, THEY WANTED BLOOD.",34,0

l_dis9:         dc.b 34,"FASCINATING.",34,0

;-------------------------------------------------------------------------------
; $0e02 Goat Infolink Message (unused)
;-------------------------------------------------------------------------------

goatmessage:    stop

;-------------------------------------------------------------------------------
; $0e03 Ex-Agent Rant #2 (after the Agent HQ fight, if listened original rant)
;-------------------------------------------------------------------------------

exagent2:       removetrigger ACT_EXAGENT
                say l_dis10
                setdomulti %00000011, l_dis11m
                ;choice 0,ea2_violent
                choice 1,ea2_nonviolent
ea2_violent:    say l_dis12m0
                stop
ea2_nonviolent: givepoints 10000
                say l_dis12m1
                plrsay l_dis13m1
                say l_dis14m1
                stop

l_dis10:        dc.b 34,"I CAN TELL YOU'VE SEEN WHAT IT'S LIKE TO BE AN AGENT. BETRAYALS, DEATH AND HATE. "
                dc.b "AND THERE WILL BE MORE.. UNTIL THAT ONE BULLET THAT'S FASTER THAN YOU.",34,0

l_dis11m:       dc.w l_dis11m0
                dc.w l_dis11m1
l_dis11m0:      dc.b 34,"DAMN RIGHT. THERE WILL BE MORE.",34,0
l_dis11m1:      dc.b 34,"ANY SUGGESTIONS, WISEGUY?",34,0

l_dis12m0:      dc.b 34,"THEN YOUR COURSE HAS BEEN SET. I WON'T BOTHER YOU ANYMORE.",34,0

l_dis12m1:      dc.b 34,"YOU'RE AN AXEMAN, RIGHT? IF I WAS YOU, I'D TRY THE OLDSCHOOL WAY ONCE MORE.",34,0
l_dis13m1:      dc.b 34,"WHAT DOES THAT IMPLY?",34,0
l_dis14m1:      dc.b 34,"FORM A TRUE AGENT METAL BAND TO LET THE TRUTH BE KNOWN WITH RAW ENERGY.",34,0

                endscript

