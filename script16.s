;
; Script 16: computer messages #2
;

                include scriptm.s

                entrypoint ep1000
                entrypoint ep1001
                entrypoint ep1002
                entrypoint ep1003

;-------------------------------------------------------------------------------
; $1000
;-------------------------------------------------------------------------------

ep1000:         setbit PLOT_SADOK_MSG_READ
                lda #<ep1000t
                ldy #>ep1000t

compmsg:        sta compmsg_a+1
                sty compmsg_y+1
                lda #SFX_OBJECT
                jsr playsfx
                jsr beginfullscreen
                jsr border
compmsg_a:      lda #$00
compmsg_y:      ldy #$00
                jsr printscreentext
                lda #MSGTIME_ETERNAL
                jsr waitforfire
                lda #SFX_OBJECT
                jsr playsfx
                jmp endfullscreen

ep1000t:
                                ;12345678901234567890123456789012345678
                dc.b 1,0,1,     "THE S.A.D.O.K PROJECT",0

                dc.b 1,2,1,     "THE PROJECT STARTED AS A COMBAT AI",0
                dc.b 1,3,1,     "EXPERIMENT - SENTIENT, AUTONOMOUS",0
                dc.b 1,4,1,     "DEFENSE/OFFENSE KERNEL - BUT EXPANDED",0
                dc.b 1,5,1,     "INTO A FULL-SCALE ANDROID PROGRAM.",0
                dc.b 1,6,1,     "PERHAPS IT WAS TOO MUCH AHEAD OF ITS",0
                dc.b 1,7,1,     "TIME - THE RESEARCHERS WERE TOO",0
                dc.b 1,8,1,     "EXCITED TO IMPLEMENT PROPER SECURITY.",0

                dc.b 1,10,1,    "THREE CLONES WERE PRODUCED. WHEN THEY",0
                dc.b 1,11,1,    "WERE SWITCHED TO FULLY AUTONOMOUS",0
                dc.b 1,12,1,    "THEY ESCAPED, KILLING 7 RESEARCHERS.",0
                dc.b 1,13,1,    "SABOTAGE BY THE AGENTS WAS SUSPECTED",0
                dc.b 1,14,1,    "BUT NEVER PROVEN.",0

                dc.b 1,16,1,    "DESTRUCTION OF TWO CLONES HAS BEEN",0
                dc.b 1,17,1,    "CONFIRMED. SIGHTINGS OF THE THIRD AT",0
                dc.b 1,18,1,    "A MILITARY BASE WERE REPORTED.",0,$ff

;-------------------------------------------------------------------------------
; $1001
;-------------------------------------------------------------------------------

ep1001:         lda #<ep1001t
                ldy #>ep1001t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1001t:        dc.b 1,0,1,     "FROM: DRWARD@EREHWON.OUTER",0
                dc.b 1,1,1,     "TO: CMD@BLACKOPS.OUTER",0

                dc.b 1,3,1,     "WE DON'T HAVE ENOUGH INMATES FOR THE",0
                dc.b 1,4,1,     "SUCCESSFUL CONTINUATION OF OUR",0
                dc.b 1,5,1,     "EXPERIMENTS, ESPECIALLY AFTER THE",0
                dc.b 1,6,1,     "PRIESTS CLAIMED MOST OF THE REMAINING",0
                dc.b 1,7,1,     "ONES FOR THEIR OWN PURPOSES.",0

                dc.b 1,9,1,     "WE UNDERSTAND THE MOTTO OF THE BLACK",0
                dc.b 1,10,1,    "OPS IS 'TAKE NO PRISONERS' BUT THE",0
                dc.b 1,11,1,    "RESEARCH WOULD DIRECTLY BENEFIT YOUR",0
                dc.b 1,12,1,    "TRAINING AND OPERATION AS WELL.",0,$ff

;-------------------------------------------------------------------------------
; $1002
;-------------------------------------------------------------------------------

ep1002:         lda #<ep1002t
                ldy #>ep1002t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1002t:        dc.b 1,0,1,     "FROM: DRGRAVES@EREHWON.OUTER",0
                dc.b 1,1,1,     "TO: DRFJORD@RESEARCH.OUTER",0

                dc.b 1,3,1,     "% FROM: DRFJORD@RESEARCH.OUTER",0
                dc.b 1,4,1,     "% TO: DRGRAVES@EREHWON.OUTER",0
                dc.b 1,5,1,     "%",0
                dc.b 1,6,1,     "% DO YOU THINK THIS IS SAFE? THIS MAN",0
                dc.b 1,7,1,     "% HAS SPENT TIME IN AN ASYLUM FOR THE",0
                dc.b 1,8,1,     "% CRIMINALLY INSANE. BUT HIS WORK IS",0
                dc.b 1,9,1,     "% BRILLIANT.",0

                dc.b 1,11,1,    "I CAN'T COMMENT WITHOUT STUDYING THE",0
                dc.b 1,12,1,    "PERSON IN QUESTION MYSELF. REMEMBER,",0
                dc.b 1,13,1,    "THE EREHWON CLINIC WELCOMES ALL",0
                dc.b 1,14,1,    "VISITORS WARMLY.. WHETHER THEY EVER",0
                dc.b 1,15,1,    "COME BACK IS ANOTHER QUESTION!",0,$ff


ep1003:         setbit PLOT_MADLOCUST_DEAD
                lda #<ep1003t
                ldy #>ep1003t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1003t:        dc.b 1,0,1,     "FROM: DRBLACK@EREHWON.OUTER",0
                dc.b 1,1,1,     "TO: CMD@BLACKOPS.OUTER",0

                dc.b 1,3,1,     "I DO KNOW THE NEED FOR YOUR RECRUITS",0
                dc.b 1,4,1,     "TO HARDEN THEMSELVES BY WITNESSING THE",0
                dc.b 1,5,1,     "EXPERIMENTS WE PERFORM HERE, AND THE",0
                dc.b 1,6,1,     "SYMBOLIC MEANING ATTACHED TO TORTURE",0
                dc.b 1,7,1,     "AND BREAKING DOWN OF AN AGENT.",0

                dc.b 1,9,1,     "UNFORTUNATELY THE AGENT KNOWN AS 'MAD",0
                dc.b 1,10,1,    "LOCUST' EXPIRED AFTER PROLONGED",0
                dc.b 1,11,1,    "SESSIONS, AND HE WAS THE LAST INMATE",0
                dc.b 1,12,1,    "AVAILABLE. REFER TO THE MESSAGE OF MY",0
                dc.b 1,13,1,    "COLLEAGUE TO SEE THIS IS SOMETHING YOU",0
                dc.b 1,14,1,    "CAN INFLUENCE AS WELL.",0,$ff

                endscript


