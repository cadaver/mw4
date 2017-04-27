                include extern.s                ;All MW4 symbols/vars/defines!
                processor 6502

                org scriptarea

                MAC givepoints
                lda #<{1}
                ldy #>{1}
                jsr addscore
                ENDM

                MAC saytrans
                lda #<{1}
                ldx #>{1}
                ldy #MSGTIME_ETERNAL
                jsr printmsgax
                jsr waitformessage
                ENDM

                MAC saytransnoptr
                ldy #MSGTIME_ETERNAL
                jsr printmsgax
                jsr waitformessage
                ENDM


                MAC jump
                lda #<{1}
                ldx #>{1}
                jmp execscript
                ENDM

                MAC jumpto
                lda #<{1}
                ldx #>{1}
                jmp execscript
                ENDM

                MAC setmultibyflags
                ldx #{1}
                lda #{2}
                jsr choicebyflags
                ENDM

                MAC setchoiceflag
                clc
                adc #{1}
                jsr setplotbit
                lda choicenum
                ENDM

                MAC setscript
                lda #<{1}
                ldx #>{1}
                jsr execlatentscript
                ENDM

                MAC stopscript
                jsr stoplatentscript
                ENDM

                MAC giveitem
                lda #SFX_PICKUP
                jsr playsfx
                ldx #{1}
                lda #{2}
                jsr additem
                ENDM

                MAC giveitemnosound
                ldx #{1}
                lda #{2}
                jsr additem
                ENDM

                MAC addmulti
                lda #{1}
                ora multichoices
                sta multichoices
                ENDM

                MAC clearmulti
                lda #$00
                sta multichoices
                ENDM

                MAC domulti
                ldx #<{1}
                ldy #>{1}
                jsr dochoice
                ENDM

                MAC setdomulti
                lda #{1}
                ldx #<{2}
                ldy #>{2}
                jsr setdochoice
                ENDM

                MAC setmulti
                lda #{1}
                sta multichoices
                ENDM


                MAC jumptrue
                bne {1}
                ENDM

                MAC jumpfalse
                beq {1}
                ENDM

                MAC checkbit
                lda #{1}
                jsr checkplotbit
                ENDM

                MAC getbit
                lda #{1}
                jsr checkplotbit
                ENDM

                MAC setbit
                lda #{1}
                jsr setplotbit
                ENDM

                MAC clearbit
                lda #{1}
                jsr clearplotbit
                ENDM


                MAC setcomrade
                lda #{1}
                sta comradeagent
                ENDM

                MAC setweapon
                ldx actrestx
                lda #ITEM_9MM_PISTOL
                sta actwpn,x
                ENDM

                MAC focus
                lda #{1}
                jsr findactor
                ENDM

                MAC settrigger
                lda #{3}
                sta temp1
                ldy #{1}
                lda #<{2}
                ldx #>{2}
                jsr setactortrigger
                ENDM

                MAC removetrigger
                lda #{1}
                jsr removeactortrigger
                ENDM

                MAC stop
                rts
                ENDM


                MAC entrypoint
                dc.w {1}
                ENDM

                MAC entryp
                dc.w {1}
                ENDM

                MAC choice
                SUBROUTINE actmacro
                cmp #{1}
                bne .1
                jmp {2}
.1:
                SUBROUTINE actmacroend
                ENDM

                MAC rnd
                jsr random
                and #{1}
                ENDM

                MAC selectline
                ldx #<{1}
                ldy #>{1}
                jsr selectlinesub
                ENDM

                MAC say
                lda #<{1}
                ldx #>{1}
                jsr speak
                ENDM

                MAC plrsay
                lda #<{1}
                ldx #>{1}
                jsr playerspeak
                ENDM

                MAC speak
                lda #<{1}
                ldx #>{1}
                jsr speak
                ENDM

                MAC plrspeak
                lda #<{1}
                ldx #>{1}
                jsr playerspeak
                ENDM

                MAC speaknoptr
                jsr speak
                ENDM

                MAC plrspeaknoptr
                jsr playerspeak
                ENDM

                MAC saynoptr
                jsr speak
                ENDM

                MAC plrsaynoptr
                jsr playerspeak
                ENDM


                MAC multi
                SUBROUTINE actmacro
                cmp #{1}
                bne .1
                jmp {2}
.1:
                SUBROUTINE actmacroend
                ENDM


                MAC endscript
endpoint:
                if endpoint > musicarea
                err
                endif
                ENDM
