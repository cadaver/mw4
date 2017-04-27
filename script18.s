;
; Script 18: computer messages #4
;

                include scriptm.s

                entrypoint ep1200
                entrypoint ep1201
                entrypoint ep1202
                entrypoint ep1203
                entrypoint ep1204
                entrypoint ep1205

;-------------------------------------------------------------------------------
; $1200
;-------------------------------------------------------------------------------

ep1200:         lda #<ep1200t
                ldy #>ep1200t

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

ep1200t:
                                ;12345678901234567890123456789012345678
                dc.b 1,0,1,     "FROM: SECURITY@GLOBALINF.INNER",0
                dc.b 1,1,1,     "TO: ALL@GLOBALINF.INNER",0

                dc.b 1,3,1,     "SECURITY ROBOTS HAVE BEEN INSTALLED.",0
                dc.b 1,4,1,     "WE DO NOT TAKE RESPONSIBILITY OF DEATH",0
                dc.b 1,5,1,     "OR INJURY TO THOSE WHO FAILED TO TURN",0
                dc.b 1,6,1,     "UP WHEN THE ID DATABASE WAS UPDATED.",0,$ff

;-------------------------------------------------------------------------------
; $1201
;-------------------------------------------------------------------------------

ep1201:         lda #<ep1201t
                ldy #>ep1201t
                jmp compmsg

ep1201t:
                                ;12345678901234567890123456789012345678
                dc.b 1,0,1,     "FROM: BOFH@GLOBALINF.INNER",0
                dc.b 1,1,1,     "TO: ALL@GLOBALINF.INNER",0

                dc.b 1,3,1,     "UNAUTHORIZED ENTERTAINMENT SOFTWARE",0
                dc.b 1,4,1,     "WAS DELETED AND CORRESPONDING ACCOUNTS",0
                dc.b 1,5,1,     "LOCKED. NEXT TIME, CONSEQUENCES WILL",0
                dc.b 1,6,1,     "BE MORE SEVERE.",0,$ff

;-------------------------------------------------------------------------------
; $1202
;-------------------------------------------------------------------------------

ep1202:         jsr random
                and #$03
                ora #$30
                sta ep1202t_digit
                lda #<ep1202t
                ldy #>ep1202t
                jmp compmsg

                               ;12345678901234567890123456789012345678
ep1202t:        dc.b 1,0,1,    "INNER SPHERE - OUTER SPHERE GATEWAY",0

                dc.b 1,2,1,    "ONLINE",0
                dc.b 1,3,1,    "CPU USAGE 1"
ep1202t_digit:  dc.b "0 PERCENT",0,$ff

;-------------------------------------------------------------------------------
; $1203
;-------------------------------------------------------------------------------

ep1203:         lda #<ep1203t
                ldy #>ep1203t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1203t:        dc.b 1,0,1,     "IAC FLIGHT LOG",0

                dc.b 1,2,1,     "CODE PURPOSE              RESULT",0
                dc.b 1,4,1,     "3524 ABDUCTION            SUCCESS",0
                dc.b 1,5,1,     "3527 CATTLE MUTILATION    SUCCESS",0
                dc.b 1,6,1,     "3528 CROP CIRCLES         SUCCESS",0
                dc.b 1,7,1,     "3529 DEPOSIT OF BODYPARTS SUCCESS",0
                dc.b 1,8,1,     "3531 ASSASINATION         FAILURE 1",0
                dc.b 1,9,1,     "3533 ABDUCTION            SUCCESS",0
                dc.b 1,10,1,    "3535 ASSASINATION         SUCCESS 2",0
                dc.b 1,11,1,    "3537 DESTRUCTION/PANIC    SUCCESS",0
                dc.b 1,12,1,    "3538 DELETED              DELETED",0
                dc.b 1,13,1,    "3539 CROP CIRCLES         SUCCESS",0
                dc.b 1,14,1,    "3540 ASSASINATION         IN PROGRESS",0

                dc.b 1,16,1,    "1 PILOT IN QUESTION WAS EXECUTED",0
                dc.b 1,17,1,    "2 REPEAT ATTEMPT SUCCESSFUL",0,$ff

;-------------------------------------------------------------------------------
; $1204
;-------------------------------------------------------------------------------

ep1204:         lda #<ep1204t
                ldy #>ep1204t
                jsr compmsg
                getbit PLOT_REACTOR_WEAKNESS
                jumptrue ep1204skip
                setbit PLOT_REACTOR_WEAKNESS
                focus ACT_JOANAGENT
                bcc ep1204skip
                plrsay ep1204t2
ep1204skip:     stop

ep1204t2:       dc.b 34,"THIS GIVES ME AN IDEA..",34,0

                                ;12345678901234567890123456789012345678
ep1204t:        dc.b 1,0,1,     "FROM: POWERPLANT@IACPROJECT.INNER",0
                dc.b 1,1,1,     "TO: CMD@IACPROJECT.INNER",0

                dc.b 1,3,1,     "NO UNAUTHORIZED PERSONNEL ARE TO ENTER",0
                dc.b 1,4,1,     "THE POWER PLANT. OTHERWISE, WE WILL",0
                dc.b 1,5,1,     "EXECUTE THEM PERSONALLY.",0

                dc.b 1,7,1,     "IF THERE'S SERIOUS CONTAMINATION IN",0
                dc.b 1,8,1,     "THE COOLANT SYSTEM, IT MAY BE SWITCHED",0
                dc.b 1,9,1,     "TO MANUAL OVERRIDE AND FLUSHED. BUT",0
                dc.b 1,10,1,    "THE TWO CIRCUITS ARE NEVER TO BE",0
                dc.b 1,11,1,    "FLUSHED EXACTLY AT THE SAME TIME.",0
                dc.b 1,13,1,    "ALSO, ONE ACCESS CARD IS MISSING. I",0
                dc.b 1,14,1,    "FIND THIS UNACCEPTABLE FOR AN INNER",0
                dc.b 1,15,1,    "SPHERE FACILITY.",0,$ff

;-------------------------------------------------------------------------------
; $1205
;-------------------------------------------------------------------------------

ep1205:         lda #<ep1205t
                ldy #>ep1205t
                jmp compmsg

                                ;12345678901234567890123456789012345678
ep1205t:        dc.b 1,0,1,     "TO: ALL@IACPROJECT.INNER",0
                dc.b 1,1,1,     "FROM: AHRIMAN@CNTRL",0

                dc.b 1,3,1,     "GOOD WORK ON THE PSIONIC RIFLE AND",0
                dc.b 1,4,1,     "ALSO ON THE LEVITATION DEVICE. NEVER",0
                dc.b 1,5,1,     "FORGET THE VALUE OF WHAT YOU DO. THE",0
                dc.b 1,6,1,     "FLIGHTS CLARIFY THE SENTINELS' REAL",0
                dc.b 1,7,1,     "INTENTIONS IN A GRAPHIC WAY.",0

                dc.b 1,9,1,     "WE HAVE ONE SUGGESTION. THE SENTINEL",0
                dc.b 1,10,1,    "TEMPLE SHOULD BE SEALED PERMANENTLY AS",0
                dc.b 1,11,1,    "SOON AS THE REVERSE-ENGINEERING WORK",0
                dc.b 1,12,1,    "IS COMPLETE.",0,$ff

                endscript
