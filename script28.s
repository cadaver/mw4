;
; Script 28: Sadok
;

                include scriptm.s

                entrypoint sadok2               ;$1c00

;-------------------------------------------------------------------------------
; $1c00 Sadok conversation #2
;-------------------------------------------------------------------------------

sadok2_appear:  lda #ACTI_PLAYER
                sta acttarget,x
                lda #M_GOTO
                sta actmode,x
                stop

sadok2:         choice T_APPEAR,sadok2_appear
                setmultibyflags 4,PLOT_SADOK_MULTI0
                beq sadok2_none
                domulti l_sadok11m
                setchoiceflag PLOT_SADOK_MULTI0 ;Allow each choice only once
                ;choice 0,sadok2_0
                choice 1,sadok2_1
                choice 2,sadok2_2
                choice 3,sadok2_3
sadok2_0:       say l_sadok12m0
                plrsay l_sadok13m0
                say l_sadok14m0
                plrsay l_sadok15m0
                say l_sadok16m0
sadok2_none:    stop
sadok2_1:       say l_sadok12m1
                plrsay l_sadok13m1
                say l_sadok14m1
                stop
sadok2_2:       say l_sadok12m2
                plrsay l_sadok13m2
                say l_sadok14m2
                plrsay l_sadok15m2
                say l_sadok16m2
sadok2_agentmetal:
                getbit PLOT_SADOK_JOIN
                jumptrue sadok2_alreadyjoined
                say l_sadok17m2
                setdomulti %00000011,l_sadok17m
                choice 1,sadok2_agree
sadok2_disagree:say l_sadok18m0
                removetrigger ACT_SADOK
                focus ACT_SADOK
                lda #M_TURNTOTARGET
                sta actmode,x
                stop
sadok2_agree:   say l_sadok18m1
                setbit PLOT_SADOK_JOIN
sadok2_alreadyjoined:
                stop

sadok2_3:       say l_sadok12m3
                plrsay l_sadok13m3
                say l_sadok14m3
                plrsay l_sadok15m3
                say l_sadok16m3
                plrsay l_sadok17m3
                say l_sadok18m3
                plrsay l_sadok19m3
                say l_sadok20m3
                jmp sadok2_agentmetal
                stop


l_sadok11m:     dc.w l_sadok11m0
                dc.w l_sadok11m1
                dc.w l_sadok11m2
                dc.w l_sadok11m3

l_sadok11m0:    dc.b 34,"WHY DID YOU WANT TO MEET ME?",34,0
l_sadok11m1:    dc.b 34,"WHERE WERE YOU DAMAGED?",34,0
l_sadok11m2:    dc.b 34,"YOU GOT ME INTO THIS MESS.",34,0
l_sadok11m3:    dc.b 34,"EXPLAIN THE CYBERPRIEST SPLIT.",34,0

l_sadok12m0:    dc.b 34,"I HAVE STUDIED SEVERAL IAC ATTACKS, AND "
                dc.b "IT SEEMS THEY NEVER FAIL THEIR OBJECTIVES.",34,0
l_sadok13m0:    dc.b 34,"AND YET I'M ALIVE?",34,0
l_sadok14m0:    dc.b 34,"PRECISELY. IT SEEMS INTENTIONAL.",34,0
l_sadok15m0:    dc.b 34,"FOR WHAT REASON? IS THE SCEPTRE INVOLVED?",34,0
l_sadok16m0:    dc.b 34,"INSUFFICIENT DATA TO ANSWER. BUT WHATEVER IS BEHIND THIS, "
                dc.b "IT MUST BE AN ATTEMPT TO MANIPULATE YOU.",34,0

l_sadok12m1:    dc.b 34,"I WAS AT THE MILITARY BASE WHERE YOU AND JOAN WERE HELD CAPTIVE.",34,0
l_sadok13m1:    dc.b 34,"IT DIDN'T OCCUR TO YOU TO FREE US?",34,0
l_sadok14m1:    dc.b 34,"THERE WERE SEVERAL BLACK OPS. I "
                dc.b "KNEW MY COMBAT AI WAS NOT UP TO THE TASK. INSTEAD I OBSERVED AND PLANTED "
                dc.b "THE DECRYPTION KEY - I HOPE IT WAS USEFUL. ON MY WAY OUT, "
                dc.b "I WAS NOTICED AND FIRED UPON.",34,0

l_sadok12m2:    dc.b 34,"BUT YOU HAVE NOW REALIZED YOUR POTENTIAL "
                dc.b "AND HAVE ACCESS TO HIGHLY PRIVILEGED INFORMATION.",34,0
l_sadok13m2:    dc.b 34,"I NEVER ASKED FOR THAT.",34,0
l_sadok14m2:    dc.b 34,"YOU HAVE ALSO MET MANY OUTSTANDING PERSONS.",34,0
l_sadok15m2:    dc.b 34,"BAD THINGS TEND TO HAPPEN TO THEM.",34,0
l_sadok16m2:    dc.b 34,"I RECOMMEND TO NOT BLAME YOURSELF.",34,0
l_sadok17m2:    dc.b 34,"BY THE WAY, I WOULD BE "
                dc.b "HONOURED TO PLAY METAL WITH YOU AGAIN IN THE FUTURE.",34,0

l_sadok17m:     dc.w l_sadok17m0
                dc.w l_sadok17m1

l_sadok17m0:    dc.b 34,"I CAN'T SAY THE SAME.",34,0
l_sadok17m1:    dc.b 34,"SO WOULD I. FOR THE OLD TIMES.",34,0

l_sadok18m0:    dc.b 34,"SADLY, I COULD FORESEE THIS RESPONSE.",34,0
l_sadok18m1:    dc.b 34,"YOU AGREE? EXCELLENT.",34,0


l_sadok12m3:    dc.b 34,"THERE IS NOT MUCH TO EXPLAIN. TO NOT RAISE "
                dc.b "SUSPICION, I TOOK PART IN YOUR CONFLICTS. "
                dc.b "BUT I ALSO HAD TO DEVISE A "
                dc.b "WAY TO CONTINUE MY MISSION.",34,0

l_sadok13m3:    dc.b 34,"SO YOU CONTACTED ME. BUT.. "
                dc.b "DID YOU ALLOW YOURSELF TO BE DESTROYED ON PURPOSE?",34,0

l_sadok14m3:    dc.b 34,"YES. IT WAS NECESSARY TO SEE HOW YOU WOULD MANAGE "
                dc.b "ON YOUR OWN.",34,0

l_sadok15m3:    dc.b 34,"AND YOU KNEW JOAN WOULD FOLLOW ME?",34,0

l_sadok16m3:    dc.b 34,"THAT WOULD HAVE BEEN BEYOND MY PREDICTION LOGIC. BUT "
                dc.b "I KNEW SHE HAD AGENT POTENTIAL AS WELL.",34,0

l_sadok17m3:    dc.b 34,"YOU'RE QUITE A BASTARD.",34,0

l_sadok18m3:    dc.b 34,"YET I CAN NEVER REACH HUMAN LEVEL IN THAT.",34,0

l_sadok19m3:    dc.b 34,"WHAT ABOUT FAUSTUS? HE DISAPPEARED SOON AFTERWARDS.",34,0

l_sadok20m3:    dc.b 34,"A BLACK OPS UNIT INVESTIGATING MY TRAIL TOOK HIM OUT.",34,0

                endscript
