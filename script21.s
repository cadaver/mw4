;
; Script file 21, previous villains :)
;

                include scriptm.s

                entrypoint drultrashred         ;$1500
                entrypoint ironfist             ;$1501

;-------------------------------------------------------------------------------
; $1500
;-------------------------------------------------------------------------------

drultrashred:   getbit PLOT_ULTRASHRED_MAINCONV
                jumptrue dr_skipmain
                jsr dr_mainconv
dr_skipmain:    getbit PLOT_ULTRASHRED_LYRIC
                jumpfalse dr_skiplyric
                getbit PLOT_ULTRASHRED_LYRICCONV
                jumptrue dr_skiplyric
                jsr dr_lyricconv
dr_skiplyric:   stop

dr_mainconv:    givepoints 10000
                setbit PLOT_ULTRASHRED_MAINCONV
                say l_dr1
                plrsay l_dr2
                say l_dr3
                setdomulti %00000011,l_dr4m
                selectline l_dr5m
                saynoptr
                say l_dr6
                plrsay l_dr7
                say l_dr8
                getbit PLOT_JOAN_DEAD
                jumptrue dr_end3
                getbit PLOT_JOAN_MET
                jumptrue dr_end2
dr_end1:        plrsay l_dr9a
                say l_dr10a
                stop
dr_end2:        plrsay l_dr9b
                say l_dr10b
                stop
dr_end3:        plrsay l_dr9c
                say l_dr10c
                stop

l_dr1:          dc.b 34,"WE MEET AGAIN. WHAT A STRANGE TWIST OF FATE.",34,0
l_dr2:          dc.b 34,"DR.ULTRASHRED.. YOU WORK FOR THE SCEPTRE NOW? OR SHOULD I SAY, AGAIN?",34,0
l_dr3:          dc.b 34,"THEY GOT ME SOON AFTER MY ASYLUM ESCAPE, "
                dc.b "AND FORCED ME TO WORK DOWN HERE. BUT I DON'T COMPLAIN, "
                dc.b "THIS TIME MY RESEARCH IS BENEFICIAL FOR THE WHOLE MANKIND.",34,0
l_dr4m:         dc.w l_dr4m0
                dc.w l_dr4m1
l_dr4m0:        dc.b 34,"WHAT ARE YOU RESEARCHING NOW?",34,0
l_dr4m1:        dc.b 34,"AN INSANE GENIUS IS NOT TO BE WASTED.",34,0

l_dr5m:         dc.w l_dr5m0
                dc.w l_dr5m1
l_dr5m0:        dc.b 34,"THIS PROJECT INVESTIGATES DRUGS WITH VERY SPECIFIC EFFECTS. "
                dc.b "I BELIEVE THEY WILL UNLOCK THE FULL POTENTIAL OF THE HUMAN MIND.",34,0
l_dr5m1:        dc.b 34,"AH, A COMPLIMENT. YES, I FIGURED OUT THAT TOO.",34,0

l_dr6:          dc.b 34,"BUT WHAT BRINGS YOU HERE? I SEE YOU WEAR AN 'AGENT' COAT.",34,0
l_dr7:          dc.b 34,"JUST SEARCHING FOR SOME TRUTH.",34,0

l_dr8:          dc.b 34,"I SEE. WHERE'S JOAN?",34,0

l_dr9a:         dc.b 34,"PRESUMEDLY DISSECTED BY ALIENS.",34,0

l_dr10a:        dc.b 34,"THAT.. WOULD BREAK MY HEART. AH, I'M SORRY, I FORGOT HOW YOU MUST FEEL.",34,0

l_dr9b:         dc.b 34,"RESEARCHING THE INNER SECRETS OF SCEPTRE.",34,0
l_dr10b:        dc.b 34,"TELL HER TO BE CAREFUL. THESE PEOPLE ARE CAPABLE OF "
                dc.b "INSANE AND BLASPHEMOUS ACTS.",34,0

l_dr9c:         dc.b 34,"KILLED IN ACTION.",34,0
l_dr10c:        dc.b 34,"THAT IS TERRIBLE.. BY SCEPTRE? THEY MUST PAY.",34,0

dr_lyricconv:   setbit PLOT_ULTRASHRED_LYRICCONV
                plrsay l_drl1
                say l_drl2
                stop

l_drl1:         dc.b 34,"IS THAT LYRIC YOURS?",34,0
l_drl2:         dc.b 34,"YES. I'M NOT TOO PROUD.",34,0

;-------------------------------------------------------------------------------
; $1501
;-------------------------------------------------------------------------------

ironfist:       givepoints 10000
                removetrigger ACT_IRONFIST
                say l_if1
                plrsay l_if2
                say l_if3
                setdomulti %00000011, l_if4m
               ; choice 0,if_end1
                choice 1,if_end2
if_end1:        say l_if5
                stop
if_end2:        say l_if6
                plrsay l_if7
                say l_if8
                stop

l_if1:          dc.b 34,"YOU? YOUR TEAM DIDN'T HAVE THE DECENCY "
                dc.b "TO SHOOT ME THEN, AND THIS IS WHERE I ENDED UP.",34,0
l_if2:          dc.b 34,"GENERAL IRONFIST - SCEPTRE DIDN'T WANT YOU TO TALK?",34,0
l_if3:          dc.b 34,"MY SUICIDE WAS FAKED BEFORE THE COURT MARTIAL COULD START. "
                dc.b "THEY WANT TO CONDUCT PSYCHOLOGICAL STUDIES ON ME.",34,0
l_if4m:         dc.w l_if4m0
                dc.w l_if4m1
l_if4m0:        dc.b 34,"THIS PLACE IS QUITE RIGHT FOR YOU.",34,0
l_if4m1:        dc.b 34,"TO LEARN FROM YOUR FAILURE?",34,0

l_if5:          dc.b 34,"AND I SEE YOU'VE BECOME AN AGENT. THERE'S NO DOUBT "
                dc.b "THE AGENTS ARE TERRORISTS. JUST A STEP FORWARD FROM "
                dc.b "WHAT YOU WERE DOING BEFORE. COMMITTING MURDERS, "
                dc.b "DESTROYING OTHERS' PROPERTY, THINKING YOU'RE "
                dc.b "DOING SOMETHING GOOD..",34,0

l_if6:          dc.b 34,"THINK OF MY PLANS AS A TRAINING MISSION GONE WRONG. "
                dc.b "BUT SCEPTRE HAS MUCH LARGER SCHEMES.. "
                dc.b "IT GOES BEYOND THE GOOD VS. EVIL-THINKING THAT IS "
                dc.b "YOUR LIMIT.",34,0

l_if7:          dc.b 34,"YOU KNOW NOTHING OF MY LIMITS.",34,0

l_if8:          dc.b 34,"I'VE VIEWED YOUR MEMORY DUMP.",34,0

                endscript
