;
; Script 27: Endsequence
;
                include scriptm.s

                entrypoint endsequencerun

es_ready3:      stop
es_ready2:      inc agentcounter
                lda agentcounter
                cmp #80
                bcc es_ready3
                lda #$00
                sta agentcounter
                lda #<SCRIPT_FINALSCREENRUN
                ldx #>SCRIPT_FINALSCREENRUN
                jmp execlatentscript

;-------------------------------------------------------------------------------
; $1b00
;-------------------------------------------------------------------------------

endsequencerun: lda agentdelay
                bne es_notready
                jmp es_ready2
es_notready:
                lda #$00                ;Hide player's gun to ease
                sta invselect           ;the multiplexer
                sta actwpn+ACTI_PLAYER
                inc agentdelay
                lda agentdelay
                choice 5,es_playerrun
                choice 55,es_convos1
                choice 62,es_runfarther
                choice 80,es_hc
                choice 90,es_stop
                choice 95,es_hc2
                choice 120,es_hc3
                choice 140,es_hc4
                choice 160,es_blowfish
                choice 180,es_blowfishrant
                choice 185,es_iantakeoff
                choice 198,es_jatakeoff
                choice 215,es_takeoff
                choice 230,es_level
                choice 250,es_upagain
es_ready:       stop

es_takeoff:     focus ACT_BLOWFISH
                jsr removeactor
                focus ACT_JOANAGENT
                bcc es_toskipjoan
                jsr removeactor
es_toskipjoan:  focus ACT_HOVERCAR
                lda #JOY_RIGHT+JOY_UP
                sta actctrl,x
                lda actt+ACTI_PLAYER
                cmp #ACT_IANAGENT
                bne es_skiptakeoff
                lda #ACT_OBSERVER
                sta actt+ACTI_PLAYER
                lda #8
                sta scrollsx
es_skiptakeoff: stop

es_level:       focus ACT_HOVERCAR
                lda #JOY_RIGHT
                sta actctrl,x
                stop

es_upagain:
                focus ACT_HOVERCAR
                lda #JOY_RIGHT|JOY_UP
                sta actctrl,x
es_skiprun:     stop

es_jatakeoff:
                focus ACT_JOANAGENT
                bcc es_jatakeoffskip
                lda #JOY_LEFT
                sta actctrl,x
                lda #M_FREE
                sta actmode,x
es_jatakeoffskip:
                stop

es_iantakeoff:
                lda actt+ACTI_PLAYER
                cmp #ACT_IANAGENT
                bne es_skiprun
es_playerrun:   lda #7
                sta waypointxh
                lda #6
                sta waypointyh
                lda #WAYPOINT0
                sta acttarget+ACTI_PLAYER
                lda #M_GOTO
                sta actmode+ACTI_PLAYER
                stop

es_convos1alone:plrsay l_alone0
                stop

es_convos1:     focus ACT_JOANAGENT
                bcc es_convos1alone
                getbit PLOT_JOAN_CONFLICT
                jumpfalse es_c1noconflict
                say l_cnf0
                plrsay l_cnf1
                say l_cnf4
                stop
es_c1noconflict:
                getbit PLOT_MELTDOWN_DONE
                jumpfalse es_c1nomeltdown
                say l_md0
                plrsay l_md1
                say l_md2
                stop
es_c1nomeltdown:
                plrsay l_neg0
                say l_neg1
                stop

es_runfarther:  lda #$b
                sta waypointxh
                stop

es_stop:        focus ACT_HOVERCAR
                stx temp1
                lda #M_TURNTOTARGET
                sta actmode+ACTI_PLAYER
                stx acttarget+ACTI_PLAYER
                stop

es_hc:          ldy #NUMCOMPLEXACT-2
                lda #$00
                jsr gfa_found
                lda #ACT_HOVERCAR
                jsr createactor
                tya
                tax
                jsr initcomplexactor
                lda #$10
                sta actxh,x
                lda #$3
                sta actyh,x
                lda #M_FREE
                sta actmode,x
                lda #JOY_LEFT
                sta actctrl,x
                stop



es_hc2:         focus ACT_HOVERCAR
                stx temp1
                lda #JOY_LEFT|JOY_UP
                sta actctrl,x
                focus ACT_JOANAGENT
                bcc es_jaskip
                lda #M_TURNTOTARGET
                sta actmode,x
                lda temp1
                sta acttarget,x
                lda #$00
                sta comradeagent
es_jaskip:
                stop
es_hc3:         focus ACT_HOVERCAR
                lda #JOY_LEFT
                sta actctrl,x
                stop
es_hc4:         focus ACT_HOVERCAR
                lda #$00
                sta actctrl,x
                stop
es_blowfish:    focus ACT_HOVERCAR
                ldy #NUMCOMPLEXACT-1
                lda #$00
                jsr gfa_found
                lda #ACT_BLOWFISH
                jsr spawnactor
                lda #$00
                sta actd,y
                tya
                tax
                jsr initcomplexactor
                lda #3*8
                sta actsx,x
                stop


es_blowfishrant:focus ACT_BLOWFISH
                plrsay l_bf0
                say l_bf1
                focus ACT_JOANAGENT
                bcc es_bfalone
                jmp es_bfwithjoan
es_bfalone:     lda actt+ACTI_PLAYER
                cmp #ACT_IANAGENT
                bne es_blowfishtraitor
                focus ACT_BLOWFISH
                say l_bfg0
                plrsay l_bfg1
                say l_bfg2
                plrsay l_bfg3
                say l_bfg4
                plrsay l_bfg5
es_bfend:       focus ACT_BLOWFISH
                say l_bfend
                getbit PLOT_BLACKHAND_DEAD
                jumptrue es_nobfend2
                say l_bfend2    ;Blackhand is expecting..
es_nobfend2:    stop
es_blowfishtraitor:
                say l_bft0
                plrsay l_bft1
                say l_bft2
                plrsay l_bft3
                say l_bft4
                stop

es_bfwithjoan:  lda #$80
                sta actd,x
                focus ACT_JOANAGENT
                say l_bfja1
                focus ACT_BLOWFISH
                say l_bfja2
                plrsay l_bfja3
                say l_bfja4
                focus ACT_JOANAGENT
                say l_bfja5
                focus ACT_BLOWFISH
                say l_bfja6
                getbit PLOT_MELTDOWN_DONE
                jumptrue es_bfja_sentinels
                plrsay l_bfja7
                jmp es_bfend
es_bfja_sentinels:
                focus ACT_JOANAGENT
                say l_bfja8
                jmp es_bfend

l_md0:          dc.b 34,"THERE'LL BE NO MORE FAKE ALIEN FLIGHTS.",34,0
l_md1:          dc.b 34,"WILL THE SENTINELS SHOW THEMSELVES NOW?",34,0
l_md2:          dc.b 34,"NOT RIGHT NOW, BUT IN TIME THEY WILL.",34,0

l_cnf0:         dc.b 34,"WHAT WERE YOU THINKING?",34,0
l_cnf1:         dc.b 34,"OUR FUTURE. NOW IT'S CERTAIN WE'LL RUN FOREVER.",34,0
l_cnf4:         dc.b 34,"BUT IF WE MAKE ENOUGH NOISE, THEY CAN'T TOUCH US WITHOUT PROVING THAT THEY EXIST..?",34,0

l_neg0:         dc.b 34,"NEVER NEGOTIATE WITH SCEPTRE.",34,0
l_neg1:         dc.b 34,"YEAH.",34,0

l_alone0:       dc.b 34,"OUTSIDE AT LAST.",34,0

l_bf0:          dc.b 34,"BLOWFISH..?",34,0
l_bf1:          dc.b 34,"THE CENTRAL NODE SENT A POWERFUL TRANSMISSION AS IT SHUT DOWN. THAT'S HOW I FOUND YOU.",34,0

l_bfg0:         dc.b 34,"DID YOU FIND WHAT YOU WERE LOOKING FOR?",34,0
l_bfg1:         dc.b 34,"GUESS SO..",34,0
l_bfg2:         dc.b 34,"SOON THE WHOLE WORLD WILL SHARE THAT KNOWLEDGE. "
                dc.b "SCEPTRE WILL BE POWERLESS TO STOP.",34,0
l_bfg3:         dc.b 34,"WILL THAT BE.. THEIR DOWNFALL?",34,0
l_bfg4:         dc.b 34,"IT'S REALLY UP TO THE PEOPLE.",34,0
l_bfg5:         dc.b 34,"MAYBE THEY WON'T BELIEVE.",34,0
l_bfend:        dc.b 34,"WE'LL SEE. NOW, I SUGGEST WE LIFT OFF.",34,0
l_bfend2:       dc.b 34,"BY THE WAY, BLACKHAND HAS CHOSEN THE NEW HQ LOCATION. HE WANTS TO SEE YOU.",34,0

l_bft0:         dc.b 34,"BUT WHERE IS YOUR AGENT GEAR?",34,0
l_bft1:         dc.b 34,"GAVE IT AWAY.",34,0
l_bft2:         dc.b 34,"WHAT? THE EVIDENCE..",34,0
l_bft3:         dc.b 34,"THINK WHAT YOU WILL. I DON'T CARE THAT MUCH.",34,0
l_bft4:         dc.b 34,"DAMN YOU, FALSE AGENT.",34,0

l_bfja1:        dc.b 34,"WE HAVEN'T MET BEFORE - I'M SORT OF A SELF-INITIATED AGENT.",34,0
l_bfja2:        dc.b 34,"WELCOME ABOARD.",34,0
l_bfja3:        dc.b 34,"WE HAVE THE EVIDENCE, WHAT HAPPENS NOW?",34,0
l_bfja4:        dc.b 34,"THE IDEA IS TO GET IT INTO PUBLIC CIRCULATION AS SOON AS POSSIBLE.",34,0
l_bfja5:        dc.b 34,"IT'S WHAT SCEPTRE FEARS MOST, RIGHT?",34,0
l_bfja6:        dc.b 34,"WE DON'T KNOW HOW PEOPLE WILL REACT.",34,0
l_bfja7:        dc.b 34,"THEY CAN'T JUST DENY IT.. OR CAN THEY?",34,0
l_bfja8:        dc.b 34,"WELL, IT WON'T BE THE LAST SURPRISE.",34,0
                endscript
