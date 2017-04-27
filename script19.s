;
; Script 19: computer messages #5
;

                include scriptm.s

                entrypoint ep1300
                entrypoint ep1301
                entrypoint ep1302
                entrypoint ep1303
                entrypoint ep1304
                entrypoint ep1305


;-------------------------------------------------------------------------------
; $1300
;-------------------------------------------------------------------------------

ep1300:         lda #<ep1300t
                ldy #>ep1300t

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

ep1300t:        dc.b 1,0,1,     "FROM: LILITH@BLACKOPS.INNER",0
                dc.b 1,1,1,     "TO: RESEARCH@IACPROJECT.INNER",0

                                ;12345678901234567890123456789012345678
                dc.b 1,3,1,     "% AN INTRUDER MANAGED TO ACTIVATE THE",0
                dc.b 1,4,1,     "% CONTACT DEVICE AND WAS RAPTURED BY",0
                dc.b 1,5,1,     "% THE SENTINELS. I WILL NOW PERFORM",0
                dc.b 1,6,1,     "% SEPPUKU.",0
                dc.b 1,8,1,     "NO NEED. JUST ENSURE THAT THE CRYSTAL",0
                dc.b 1,9,1,     "IS SENT TO MY PRIVATE QUARTERS, SO",0
                dc.b 1,10,1,    "THAT THIS WON'T HAPPEN AGAIN.",0,$ff

;-------------------------------------------------------------------------------
; $1301
;-------------------------------------------------------------------------------

ep1301:         lda #<ep1301t
                ldy #>ep1301t
                jmp compmsg

ep1301t:        dc.b 1,0,1,     "FROM: PILOTS@IACPROJECT.INNER",0
                dc.b 1,1,1,     "TO: LILITH@BLACKOPS.INNER",0

                                ;12345678901234567890123456789012345678
                dc.b 1,3,1,     "ORIGINAL ORDERS FOR FLIGHT 3538 HAVE",0
                dc.b 1,4,1,     "BEEN DELETED FROM THE LOG. THOUGH",0
                dc.b 1,5,1,     "I'M AFRAID EVEN THE MODIFIED PLAN",0
                dc.b 1,6,1,     "DIDN'T SUCCEED ENTIRELY. I WILL NOW",0
                dc.b 1,7,1,     "SELF-TERMINATE, IF YOU SAY SO.",0,$ff

;-------------------------------------------------------------------------------
; $1302
;-------------------------------------------------------------------------------

ep1302:         lda #<ep1302t
                ldy #>ep1302t
                jmp compmsg

ep1302t:        dc.b 1,0,1,     "FROM: CMD@BLACKOPS.OUTER",0
                dc.b 1,1,1,     "TO: ARMORY@BLACKOPS.INNER",0

                                ;12345678901234567890123456789012345678
                dc.b 1,3,1,     "BECAUSE OF AMMUNITION SHORTAGE, THE",0
                dc.b 1,4,1,     "NEW RECRUITS HAVEN'T BEEN ABLE TO",0
                dc.b 1,5,1,     "TRAIN ON 5.56 CALIBER AUTOMATIC",0
                dc.b 1,6,1,     "WEAPONS. THE SITUATION IS GETTING OUT",0
                dc.b 1,7,1,     "OF HAND AND WE FEAR A MUTINY.",0,$ff

;-------------------------------------------------------------------------------
; $1303
;-------------------------------------------------------------------------------

ep1303:         lda #<ep1303t
                ldy #>ep1303t
                jmp compmsg

ep1303t:        dc.b 1,0,1,     "FROM: OPS@BLACKOPS.INNER",0
                dc.b 1,1,1,     "TO: CMD@BLACKOPS.INNER",0

                                ;12345678901234567890123456789012345678
                dc.b 1,3,1,     "IT OCCURRED TO ME THAT WE DON'T CANCEL",0
                dc.b 1,4,1,     "AS MUCH OPERATIVES AS WE COULD. DOES",0
                dc.b 1,5,1,     "THIS RESULT IN LOWERED STANDARDS? IN",0
                dc.b 1,6,1,     "THE IAC PROJECT A PILOT WAS EXECUTED",0
                dc.b 1,7,1,     "FOR FAILING AN ASSASINATION. YES, THIS",0
                dc.b 1,8,1,     "IS CRUEL AND MEAN, BUT ALSO TOTALLY",0
                dc.b 1,9,1,     "AWESOME.",0,$ff

;-------------------------------------------------------------------------------
; $1304
;-------------------------------------------------------------------------------

ep1304:         lda #<ep1304t
                ldy #>ep1304t
                jmp compmsg

ep1304t:        dc.b 1,0,1,     "S.C.E.P.T.R.E",0

                                ;12345678901234567890123456789012345678
                dc.b 1,2,1,     "WE ARE ELITE",0
                dc.b 1,3,1,     "WE STRIKE IN THE NIGHT",0
                dc.b 1,4,1,     "SEE FLASH OF STEEL",0
                dc.b 1,5,1,     "NO CHANCE TO FIGHT",0
                dc.b 1,7,1,     "SECTARIAN CHOSEN ELITE",0
                dc.b 1,8,1,     "PRIVILEGED TO RULE AND",0
                dc.b 1,9,1,     "EXTERMINATE!",0
                dc.b 1,11,1,    "WE TAKE SURVIVORS",0
                dc.b 1,12,1,    "TO TORTURE CAVES",0
                dc.b 1,13,1,    "EVEN IF YOU LIVE",0
                dc.b 1,14,1,    "YOU'LL NEVER BE THE SAME",0
                dc.b 1,16,1,    "WEAK AGENTS OF METAL CAN KISS",0
                dc.b 1,17,1,    "OUR ASS 'COS THEY WILL NEVER",0
                dc.b 1,18,1,    "ACHIEVE WHAT WE ARE!",0,$ff

;-------------------------------------------------------------------------------
; $1305
;-------------------------------------------------------------------------------

ep1305:         lda #<ep1305t
                ldy #>ep1305t
                jmp compmsg

ep1305t:        dc.b 1,0,1,     "BLACK OPS",0

                dc.b 1,2,1,     "TERMINATION, MUTILATION",0
                dc.b 1,3,1,     "INFORMATION EXTRACTION",0
                dc.b 1,4,1,     "DESECRATION, DENIGRATION",0
                dc.b 1,5,1,     "OF THE WEAK AGENCIES",0
                dc.b 1,6,1,     "WARFARE IN SECRET OR IN PUBLIC",0
                dc.b 1,7,1,     "ASSASINATION IN THE DARK OR",0
                dc.b 1,8,1,     "IN BROAD DAYLIGHT!",0

                                ;12345678901234567890123456789012345678
                dc.b 1,10,1,    "INFILTRATION, CORRUPTION",0
                dc.b 1,11,1,    "THEY'LL NEVER KNOW WHAT HIT THEM",0
                dc.b 1,12,1,    "ELIMINATION, ERADICATION",0
                dc.b 1,13,1,    "OF THE WEAK AGENCIES",0
                dc.b 1,14,1,    "SADISTIC OPERATIONS 'CROSS THE WORLD",0
                dc.b 1,15,1,    "SACRIFICIAL SUICIDE BOMBINGS",0
                dc.b 1,16,1,    "FOR OUR CAUSE!",0
                dc.b 1,18,1,    "WE ARE NOT AFRAID TO PUSH THE BUTTON!",0,$ff

                endscript
