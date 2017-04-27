;
; Script 20: computer messages #6, Sarge in Erehwon-conversation
;

                include scriptm.s

                entrypoint ep1400
                entrypoint ep1401
                entrypoint ep1402
                entrypoint ep1403
                entrypoint sargeerehwon                 ;$1404
                entrypoint ep1405                       ;$1405
                entrypoint ep1406                       ;$1406


;-------------------------------------------------------------------------------
; $1400
;-------------------------------------------------------------------------------

ep1400:         lda #<ep1400t
                ldy #>ep1400t

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
ep1400t:        dc.b 1,0,1,     "FROM: TECH@CNTRL",0
                dc.b 1,1,1,     "TO: PRIESTS@CNTRL",0
                dc.b 1,3,1,     "THE SUPPORT SYSTEM FOR THE ELDER",0
                dc.b 1,4,1,     "COUNCIL DRAWS TOO MUCH POWER TO RUN",0
                dc.b 1,5,1,     "ON BATTERY BACKUP. IS THIS SOMETHING",0
                dc.b 1,6,1,     "TO LOOK AT, OR ARE WE SATISFIED AS IT",0
                dc.b 1,7,1,     "IS NOW?",0,$ff

;-------------------------------------------------------------------------------
; $1401
;-------------------------------------------------------------------------------

ep1401:         lda #<ep1401t
                ldy #>ep1401t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1401t:        dc.b 1,0,1,     "COLLECTED THOUGHTS OF ELDER PRIESTS",0

                dc.b 1,2,1,     "WE HAVE BEEN THERE ALWAYS .. AND",0
                dc.b 1,3,1,     "WILL ALWAYS BE.",0

                dc.b 1,5,1,     "THE AGENTS ARE WEAK! CRUSH THEM!",0

                dc.b 1,7,1,     "WE DEMAND THE PROCESS TO WORK.",0

                dc.b 1,9,1,     "THE BLACK OPS MIGHT HAVE LESS DIGNITY",0
                dc.b 1,10,1,     "THAN WE THOUGHT.",0

                dc.b 1,12,1,    "THE SCEPTRE MUST REMAIN AS ONE.",0
                dc.b 1,14,1,    "EXECUTE THE DISSIDENTS AND PUT THEIR",0
                dc.b 1,15,1,    "HEADS ON DISPLAY!",0

;-------------------------------------------------------------------------------
; $1402
;-------------------------------------------------------------------------------

ep1402:         lda #<ep1402t
                ldy #>ep1402t
                jmp compmsg

ep1402t:        dc.b 1,0,1,     "FROM: RESEARCH@CNTRL",0
                dc.b 1,1,1,     "TO: AHRIMAN@CNTRL",0

                                ;12345678901234567890123456789012345678
                dc.b 1,3,1,     "I AM JOYOUS TO REPORT THAT THE SECOND",0
                dc.b 1,4,1,     "ABDUCTEE WE GOT WAS VERY RESPONSIVE TO",0
                dc.b 1,5,1,     "THE PROCESS. WE MAY BEGIN TRANSFER",0
                dc.b 1,6,1,     "IN THE NEAR FUTURE.",0,$ff

;-------------------------------------------------------------------------------
; $1403
;-------------------------------------------------------------------------------

ep1403:         lda #<ep1403t
                ldy #>ep1403t
                jmp compmsg

ep1403t:        dc.b 1,0,1,     "FROM: AHRIMAN@CNTRL",0
                dc.b 1,1,1,     "TO: LILITH@BLACKOPS.INNER",0

                                ;12345678901234567890123456789012345678
                dc.b 1,3,1,     "I KNOW OF YOUR PLANS. YOUR WEAK",0
                dc.b 1,4,1,     "ASSASSIN WILL BE KILLED THE MOMENT HE",0
                dc.b 1,5,1,     "SETS HIS FOOT IN HERE. AND I PLAN TO",0
                dc.b 1,6,1,     "FAR OUTLAST YOU OR ANY OF YOUR",0
                dc.b 1,7,1,     "PATHETIC BLACK OPS. WE ARE WHO FOUNDED",0
                dc.b 1,8,1,     "THIS ORDER AND YOU WILL NEVER BE ABLE",0
                dc.b 1,9,1,     "TO REACH OUR LEVEL.",0,$ff

;-------------------------------------------------------------------------------
; $1404
;-------------------------------------------------------------------------------

sargeerehwon:   removetrigger ACT_SARGE
                plrsay l_se1
                say l_se2
                plrsay l_se3
                say l_se4
                stop

l_se1:          dc.b 34,"YOU WERE IN EREHWON AND ESCAPED?",34,0
l_se2:          dc.b 34,"YEAH.. JUMPED DOWN TO THE SEA FROM THE HELIPAD. BUT I'M SURE "
                dc.b "PART OF MY SANITY WAS LEFT THERE. THERE ARE SOME BLANKS "
                dc.b "IN MY MIND..",34,0
l_se3:          dc.b 34,"MEMORY ERASE? THAT'S SOMETHING I'VE EXPERIENCED AS WELL, BUT NOT IN EREHWON.",34,0
l_se4:          dc.b 34,"THE SCEPTRE ARE SKILLED IN PLAYING WITH THE MIND. MANY TECHNIQUES WERE "
                dc.b "DEVELOPED BY AN OFFICER CALLED LILITH, BEFORE SHE MOVED ON TO HIGHER COMMAND.",34,0


;-------------------------------------------------------------------------------
; $1405
;-------------------------------------------------------------------------------

ep1405:         lda #<ep1405t
                ldy #>ep1405t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1405t:        dc.b 1,0,1,     "FROM: POLITICS@GLOBALINF.INNER",0
                dc.b 1,1,1,     "TO: CMD@BLACKOPS.INNER",0

                dc.b 1,3,1,     "A VIOLENT INSURRECTION WILL BE NEEDED",0
                dc.b 1,4,1,     "IN THE NEAR FUTURE. STAY PREPARED.",0
                dc.b 1,5,1,     "THE TARGET COUNTRY WILL BE ANNOUNCED",0
                dc.b 1,6,1,     "LATER.",0,$ff

;-------------------------------------------------------------------------------
; $1406
;-------------------------------------------------------------------------------

ep1406:         lda #<ep1406t
                ldy #>ep1406t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1406t:        dc.b 1,0,1,     "FROM: DISINFO@GLOBALINF.INNER",0
                dc.b 1,1,1,     "TO: CMD@IACPROJECT.INNER",0

                dc.b 1,3,1,     "OUR COOPERATION PROJECT IS READY TO",0
                dc.b 1,4,1,     "BEGIN. CAMPAIGNS OF FEAR AND HATRED",0
                dc.b 1,5,1,     "TOWARDS SUPPOSED ALIEN LIFEFORMS WILL",0
                dc.b 1,6,1,     "BE SET TO COINCIDE WITH YOUR FLIGHTS.",0,$ff
                endscript


