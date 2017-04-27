;
; Script 15: computer messages #1
;

                include scriptm.s

                entrypoint epf00
                entrypoint epf01
                entrypoint unused
                entrypoint epf03
                entrypoint unused
                entrypoint epf05
                entrypoint epf06
                entrypoint epf07
                entrypoint epf08
                entrypoint epf09
                entrypoint epf0a

;-------------------------------------------------------------------------------
; $0f00
;-------------------------------------------------------------------------------

unused:         stop

epf00:            lda #<epf00t
                ldy #>epf00t

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
                               ;12345678901234567890123456789012345678
epf00t:           dc.b 1,0,1,    "FROM: CMD@COMMINT.OUTER",0
                dc.b 1,1,1,    "TO: CMD@OUTER",0

                dc.b 1,3,1,    "WE KNOW THAT MOST OF THE PERSONNEL",0
                dc.b 1,4,1,    "HATE THE PYRAMID RITUAL, SO I HAVE AN",0
                dc.b 1,5,1,    "IDEA TO PLACE THE DOCUMENTS TO THE",0
                dc.b 1,6,1,    "ALTAR ROOMS. THIS WAY THE CONFLICTING",0
                dc.b 1,7,1,    "HIGH-LEVEL SECURITY DEMANDS CAN BE",0
                dc.b 1,8,1,    "CONVENIENTLY FULFILLED.",0,$ff

;-------------------------------------------------------------------------------
; $0f01
;-------------------------------------------------------------------------------

epf01:            jsr random
                and #$07
                ora #$30
                sta epf01t_digit
                lda #<epf01t
                ldy #>epf01t
                jmp compmsg

                               ;12345678901234567890123456789012345678
epf01t:           dc.b 1,0,1,    "MAIN INFORMATION FILTERING STATION",0

                dc.b 1,2,1,    "ONLINE",0
                dc.b 1,3,1,    "CPU USAGE 2"
epf01t_digit:     dc.b "0 PERCENT",0,$ff

;-------------------------------------------------------------------------------
; $0f03
;-------------------------------------------------------------------------------

epf03:            lda #<epf03t
                ldy #>epf03t
                jmp compmsg

                               ;12345678901234567890123456789012345678
epf03t:           dc.b 1,0,1,    "LONG-TERM DATA STORAGE 1",0

                dc.b 1,2,1,    "ONLINE",0
                dc.b 1,3,1,    "USAGE 20 PERCENT",0,$ff

;-------------------------------------------------------------------------------
; $0f05
;-------------------------------------------------------------------------------

epf05:            lda #<epf05t
                ldy #>epf05t
                jmp compmsg

                               ;12345678901234567890123456789012345678
epf05t:           dc.b 1,0,1,    "MEDIA INTERCEPTION STATION",0

                dc.b 1,2,1,    "CURRENT INTERCEPTIONS",0
                dc.b 1,3,1,    "1162 LIVE BATTLEFIELD FEED -",0
                dc.b 1,4,1,    "     REPLACE AUDIO/VIDEO",0

                dc.b 1,6,1,    "UPCOMING INTERCEPTIONS",0
                dc.b 1,7,1,    "1165 PRESIDENT'S SPEECH -",0
                dc.b 1,8,1,    "     REPLACE AUDIO",0,$ff

;-------------------------------------------------------------------------------
; $0f06
;-------------------------------------------------------------------------------

epf06:            lda #<epf06t
                ldy #>epf06t
                jmp compmsg

                               ;12345678901234567890123456789012345678
epf06t:           dc.b 1,0,1,    "FROM: CAMPUSSECURITY@SCEPTREGW",0
                dc.b 1,1,1,    "TO: SECURITY@OUTER",0

                dc.b 1,3,1,    "BE ADVISED THAT SECURITY WAS BREACHED",0
                dc.b 1,4,1,    "ON THE TOP LEVEL. AN AGENT MAY BE",0
                dc.b 1,5,1,    "HEADED FOR YOUR FACILITY. USE CAUTION.",0,$ff

;-------------------------------------------------------------------------------
; $0f07
;-------------------------------------------------------------------------------

epf07:            lda #<epf07t
                ldy #>epf07t
                jmp compmsg

                               ;12345678901234567890123456789012345678
epf07t:           dc.b 1,0,1,    "FROM: DRFJORD@RESEARCH.OUTER",0
                dc.b 1,1,1,    "TO: ALL@RESEARCH.OUTER",0
                dc.b 1,3,1,    "% FROM: DRTORSK@SCEPTREGW",0
                dc.b 1,4,1,    "% TO: DRFJORD@RESEARCH.OUTER",0
                dc.b 1,5,1,    "%",0
                dc.b 1,6,1,    "% WE HAVE SENT YOU AN ADULT MALE OF",0
                dc.b 1,7,1,    "% THE SERIES 2 EXPERIMENTAL SPECIES",0
                dc.b 1,8,1,    "% FOR OBSERVATION.",0

                               ;12345678901234567890123456789012345678
                dc.b 1,10,1,   "AND I ASK, WHY WAS THIS APPROVED? WE",0
                dc.b 1,11,1,   "ALREADY HAVE A SHORTAGE OF SPACE. MAY",0
                dc.b 1,12,1,   "I REMIND THAT THIS FACILITY IS STILL",0
                dc.b 1,13,1,   "PRIMARILY FOR CHEMICAL / WEAPONS TECH.",0
                dc.b 1,14,1,   "RESEARCH.",0,$ff

;-------------------------------------------------------------------------------
; $0f08
;-------------------------------------------------------------------------------

epf08:            lda #<epf08t
                ldy #>epf08t
                jmp compmsg

                               ;12345678901234567890123456789012345678
epf08t:           dc.b 1,0,1,    "FROM: CMD@BLACKOPS.OUTER",0
                dc.b 1,1,1,    "TO: CHEM@RESEARCH.OUTER",0

                dc.b 1,3,1,    "INSERTION OF THE AGENT INTO THE",0
                dc.b 1,4,1,    "WATER SUPPLY OF THE FIRST TEST CITY",0
                dc.b 1,5,1,    "WAS SUCCESSFULLY PERFORMED IN OUR",0
                dc.b 1,6,1,    "EXERCISE. A SUBSEQUENT INCREASE IN",0
                dc.b 1,7,1,    "VIOLENCE AND RIOTING WAS OBSERVED.",0,$ff

;-------------------------------------------------------------------------------
; $0f09
;-------------------------------------------------------------------------------

epf09:            lda #<epf09t
                ldy #>epf09t
                jmp compmsg

                               ;12345678901234567890123456789012345678
epf09t:           dc.b 1,0,1,    "FROM: DRGREY@RESEARCH.OUTER",0
                dc.b 1,1,1,    "TO: CMD@BLACKOPS.INNER",0

                dc.b 1,3,1,    "THE POWER OUTPUT, AND THUS DAMAGE",0
                dc.b 1,4,1,    "CAPABILITY OF THE GAS-FIST WAS GREATLY",0
                dc.b 1,5,1,    "INCREASED BY SUBSTITUTING A MINIATURE",0
                dc.b 1,6,1,    "REACTOR FOR THE POWER SUPPLY. WEIGHT",0
                dc.b 1,7,1,    "WAS ALSO REDUCED. WE CALL THIS THE",0
                dc.b 1,8,1,    "GAS-FIST MK2. USER DOSE MEASUREMENTS",0
                dc.b 1,9,1,    "ARE IN PROGRESS.",0,$ff

;-------------------------------------------------------------------------------
; $0f0a
;-------------------------------------------------------------------------------

epf0a:          setbit PLOT_ULTRASHRED_LYRIC
                lda #<epf0at
                ldy #>epf0at
                jmp compmsg

                               ;12345678901234567890123456789012345678
epf0at:           dc.b 1,0,1,    "UNFINISHED METAL LYRIC",0

                dc.b 1,2,1,    "EYE IN THE PYRAMID SETS YOUR FATE",0
                dc.b 1,3,1,    "TO ESCAPE IS FAR TOO LATE",0
                dc.b 1,4,1,    "WITH USELESS HATRED YOU NOW BURN",0
                dc.b 1,5,1,    "YET YOU KNOW THERE'S NO RETURN",0,$ff

                endscript
