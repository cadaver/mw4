;
; Script 17: computer messages #3
;

                include scriptm.s

                entrypoint ep1100
                entrypoint ep1101
                entrypoint ep1102
                entrypoint ep1103
                entrypoint ep1104
                entrypoint ep1105
                entrypoint ep1106

;-------------------------------------------------------------------------------
; $1100
;-------------------------------------------------------------------------------

ep1100:         getbit PLOT_SARGE_EREHWON
                jumptrue ep1100_skip
                setbit PLOT_SARGE_EREHWON
                settrigger ACT_SARGE,SCRIPT_SARGEEREHWON,T_CONV
ep1100_skip:    lda #<ep1100t
                ldy #>ep1100t

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

ep1100t:
                                ;12345678901234567890123456789012345678

                dc.b 1,0,1,     "FROM: SECURITY@EREHWON.OUTER",0
                dc.b 1,1,1,     "TO: SUHRIM@MANSION.INNER",0

                dc.b 1,3,1,     "I MUST INFORM THAT THE INMATE KNOWN AS",0
                dc.b 1,4,1,     "SARGE ESCAPED SOME TIME AGO. THE",0
                dc.b 1,5,1,     "PHRASE-RESPONSE TRAINING WAS STILL",0
                dc.b 1,6,1,     "UNDERWAY WHEN THIS HAPPENED. ASK THE",0
                dc.b 1,7,1,     "DOCTORS FOR FURTHER DETAILS.",0,$ff

;-------------------------------------------------------------------------------
; $1101
;-------------------------------------------------------------------------------

ep1101:         lda #<ep1101t
                ldy #>ep1101t
                jmp compmsg

ep1101t:
                                ;12345678901234567890123456789012345678

                dc.b 1,0,1,     "FROM: LILITH@BLACKOPS.INNER",0
                dc.b 1,1,1,     "TO: ALL@EREHWON.OUTER",0

                dc.b 1,3,1,     "THE PRISONER THAT HAS ARRIVED IS OF",0
                dc.b 1,4,1,     "HIGH RANK AND THUS TO BE TREATED WELL.",0
                dc.b 1,5,1,     "THE TREATMENTS THAT ARE EXPRESSLY",0
                dc.b 1,6,1,     "FORBIDDEN ARE LISTED AS AN ATTACHMENT.",0
                dc.b 1,7,1,     "FAILURE TO COMPLY WILL RESULT IN A",0
                dc.b 1,8,1,     "VISIT OF THE BLACK OPS.",0,$ff

;-------------------------------------------------------------------------------
; $1102
;-------------------------------------------------------------------------------

ep1102:         lda #<ep1102t
                ldy #>ep1102t
                jmp compmsg

                               ;12345678901234567890123456789012345678
ep1102t:        dc.b 1,0,1,    "FROM: SECURITY@EREHWON.OUTER",0
                dc.b 1,1,1,    "TO: SECURITY@OUTER",0
                dc.b 1,3,1,    "% BE ADVISED THAT SECURITY WAS",0
                dc.b 1,4,1,    "% BREACHED ON THE TOP LEVEL. AN AGENT",0
                dc.b 1,5,1,    "% MAY BE HEADED FOR YOUR FACILITY. USE",0
                dc.b 1,6,1,    "% CAUTION.",0
                dc.b 1,8,1,    "WHAT, WE HAVE ANOTHER INTRUDER? WELL,",0
                dc.b 1,9,1,    "HUNTING DOWN AN AGENT IS ALWAYS SOME-",0
                dc.b 1,10,1,   "THING TO LOOK FORWARD TO.",0,$ff

;-------------------------------------------------------------------------------
; $1103
;-------------------------------------------------------------------------------

ep1103:         lda #<ep1103t
                ldy #>ep1103t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1103t:        dc.b 1,0,1,     "WE ARE OBSERVING YOU. WE KNOW YOUR",0
                dc.b 1,1,1,     "EVERY MOVE. THERE WILL BE NO ESCAPE",0
                dc.b 1,2,1,     "FOR YOU NOW OR EVER.",0,$ff

;-------------------------------------------------------------------------------
; $1104
;-------------------------------------------------------------------------------

ep1104:         lda #<ep1104t
                ldy #>ep1104t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1104t:        dc.b 1,0,1,     "FROM: PRIESTS@CNTRL",0
                dc.b 1,1,1,     "TO: ALL@INNER, ALL@OUTER",0

                dc.b 1,3,1,     "DO NOT DESPISE THE RITUAL! WE DO SEE",0
                dc.b 1,4,1,     "THAT YOUR DAYS ARE BUSY, BUT YOU WOULD",0
                dc.b 1,5,1,     "BE WISE TO NOT UNDERESTIMATE THE",0
                dc.b 1,6,1,     "SYMBOLIC MIGHT OF THE PYRAMID. TO",0
                dc.b 1,7,1,     "PROPERLY PERFORM THE RITUAL, KNEEL ON",0
                dc.b 1,8,1,     "THE RIGHT SIDE, FACING THE EYE,",0
                dc.b 1,9,1,     "CHANTING THE SACRED VERSES, UNTIL",0
                dc.b 1,10,1,    "ENLIGHTENMENT IS ATTAINED.",0,$ff

;-------------------------------------------------------------------------------
; $1105
;-------------------------------------------------------------------------------

ep1105:         lda #<ep1105t
                ldy #>ep1105t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1105t:        dc.b 1,0,1,     "FROM: ENVIROMENT@GLOBALINF.INNER",0
                dc.b 1,1,1,     "TO: ALL@RESEARCH.OUTER",0

                dc.b 1,3,1,     "WE WANT TO CONGRATULATE EVERYONE",0
                dc.b 1,4,1,     "INVOLVED WITH THE MUTANT SPECIES",0
                dc.b 1,5,1,     "PROJECTS. THROUGH THEIR INSERTION,",0
                dc.b 1,6,1,     "PREMATURE CONCERN OF ENVIROMENTAL",0
                dc.b 1,7,1,     "CATACLYSMS HAS ARISEN, WHICH IN TURN",0
                dc.b 1,8,1,     "WILL SPEED UP THE DEVELOPMENT OF",0
                dc.b 1,9,1,     "SCIENCE IN AREAS WE DO NOT DIRECTLY",0
                dc.b 1,10,1,    "WISH TO CONTROL.",0,$ff

;-------------------------------------------------------------------------------
; $1106
;-------------------------------------------------------------------------------

ep1106:         lda #<ep1106t
                ldy #>ep1106t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1106t:        dc.b 1,0,1,     "FROM: SUHRIM@MANSION.INNER",0
                dc.b 1,1,1,     "TO: SECURITY@INNER",0

                dc.b 1,3,1,     "THE AGENT HAS BEEN SEEN HEADING FOR",0
                dc.b 1,4,1,     "THE MANSION. I DON'T EXPECT MYSELF OR",0
                dc.b 1,5,1,     "MY PERSONNEL TO FAIL BUT YOU MIGHT",0
                dc.b 1,6,1,     "WANT TO PREPARE JUST IN CASE.",0,$ff

                endscript

