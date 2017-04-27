;
; MW4 Scriptfile 04: Intro (The Farm)
;
                include scriptm.s               ;Script macros etc.

                entrypoint joanintro            ;400
                entrypoint satanakhiaintro      ;401
                entrypoint joanconv             ;402
                entrypoint batdead              ;403
                entrypoint introfade            ;404
                entrypoint agentintro           ;405

;-------------------------------------------------------------------------------
; $0404
;-------------------------------------------------------------------------------

introfade:      lda #<introtext
                ldy #>introtext
                jsr fadeintext
                settrigger ACT_JOANCIVILIAN,SCRIPT_JOANINTRO,T_NEAR
                jmp centerplayer                ;Begin game!

                          ;0123456789012345678901234567890123456789
introtext:      dc.b 6,9, 0,"ON THE OUTSKIRTS OF SUB-CITY",0
                dc.b 4,10,0,"3 WEEKS AFTER THE EVENTS OF ",34,"MW3",34,0
                dc.b $ff

;-------------------------------------------------------------------------------
; $0400
;-------------------------------------------------------------------------------

joanintro:
                lda #$0b                                ;Band room has lights
                sta zonebg2+$05
                setcomrade ACT_JOANCIVILIAN           ;Will follow
                settrigger ACT_JOANCIVILIAN,SCRIPT_JOANCONV,T_CONV ;Change trigger
                settrigger ACT_SATANAKHIA,SCRIPT_SATANAKHIAINTRO,T_NEAR
                settrigger ACT_LORDOBSKURIUS,SCRIPT_SATANAKHIAINTRO,T_NEAR
                settrigger ACT_BAT,SCRIPT_BATDEAD,T_TAKEDOWN
                plrsay l_intro1
                say l_intro2
                plrsay l_intro3
                say l_intro4
                setdomulti %00000011, l_introchoice
               ;choice 0,joanintro_keeppistol
                choice 1,joanintro_getpistol
joanintro_keeppistol:
                setweapon ITEM_9MM_PISTOL               ;Set NPC weapon
                jmp joanintro_endcommon
joanintro_getpistol:
                giveitem ITEM_9MM_PISTOL,0
                giveitemnosound ITEM_9MM_AMMO,15
                jsr joanintro_setalliance               ;Set 'beast' group
joanintro_endcommon:                                    ;alliance..
                say l_intro5
                stop

l_intro1:       dc.b 34,"WHAT'S THIS ALL ABOUT?",34,0
l_intro2:       dc.b 34,"LORD OBSKURIUS DIDN'T TELL. JUST CALLED AND "
                dc.b "ASKED US TO SHOW UP.",34,0
l_intro3:       dc.b 34,"TROUBLE?",34,0
l_intro4:       dc.b 34,"MAYBE NOT, BUT THERE WERE WEIRD NOISES ON THE BACKGROUND - "
                dc.b "SOUNDED LIKE PIGS. I HAVE A PISTOL JUST IN CASE. "
                dc.b "WANT IT?",34,0
l_intro5:       dc.b 34,"LET'S GO.",34,0

l_introchoice:  dc.w l_introchoice0
                dc.w l_introchoice1

l_introchoice0: dc.b 34,"NO, KEEP IT.",34,0
l_introchoice1: dc.b 34,"YEAH, IF YOU INSIST.",34,0

;-------------------------------------------------------------------------------
; $0402
;-------------------------------------------------------------------------------

joanconv:       checkbit PLOT_JOAN_SHOT_BAT
                jumpfalse joanconv2     ;Random barks
                plrsay l_batdead1
                jsr isincombat          ;In the middle of "hunt"?
                bcc joanconv_nocombat
                say l_batdead3
                jmp joanconv_batdeadcommon
joanconv_nocombat:
                say l_batdead2
joanconv_batdeadcommon:
                removetrigger ACT_BAT
                clearbit PLOT_JOAN_SHOT_BAT
joanintro_setalliance:
                lda alliance+GRP_AGENTS    ;Make Agents friendly towards beasts
                ora #%01000000          ;so won't happen again :)
                sta alliance+GRP_AGENTS
                stop

joanconv2:      rnd 3
                selectline l_conv
                saynoptr
                stop

l_conv:         dc.w l_conv0
                dc.w l_conv1
                dc.w l_conv2
                dc.w l_conv3

l_batdead1:     dc.b 34,"IS IT NECESSARY TO SHOOT THEM?",34,0
l_batdead2:     dc.b 34,"GUESS NO..",34,0
l_batdead3:     dc.b 34,"COME ON, JUST THIS ONE.",34,0

l_conv0:        dc.b 34,"THIS PLACE IS SORT OF CREEPY.",34,0
l_conv1:        dc.b 34,"HE COULD HAVE TOLD WHAT THIS WAS ABOUT.",34,0
l_conv2:        dc.b 34,"THIS BETTER BE IMPORTANT.",34,0
l_conv3:        dc.b 34,"PIG SOUNDS - WHY?",34,0

;-------------------------------------------------------------------------------
; $0403
;-------------------------------------------------------------------------------

batdead:        ldy actlastdmgact2,x
                lda actt,y
                cmp #ACT_JOANCIVILIAN           ;Check if she's responsible :)
                bne batdeadok
                setbit PLOT_JOAN_SHOT_BAT
batdeadok:      stop

;-------------------------------------------------------------------------------
; $0401
;-------------------------------------------------------------------------------

satanakhiaintro:
                lda alliance+GRP_AGENTS         ;After the intro allies attack
                ora #%01000000                  ;beasts only in selfdefense
                sta alliance+GRP_AGENTS
                givepoints 5000
                removetrigger ACT_JOANCIVILIAN
                removetrigger ACT_BAT
                removetrigger ACT_SATANAKHIA
                say l_sata0
                plrsay l_sata1
                focus ACT_JOANCIVILIAN
                setcomrade ACT_NONE             ;Joan stays for now
                lda #M_IDLE
                sta actmode,x
                say l_sata2
                focus ACT_LORDOBSKURIUS
                say l_sata3
                focus ACT_SATANAKHIA
                say l_sata4
                plrsay l_sata5
                focus ACT_LORDOBSKURIUS
                say l_sata6
                focus ACT_SATANAKHIA
                say l_sata7
                focus ACT_LORDOBSKURIUS
                say l_sata8
                focus ACT_JOANCIVILIAN
                say l_sata9
                focus ACT_LORDOBSKURIUS
                say l_sata10
                removetrigger ACT_LORDOBSKURIUS
                removetrigger ACT_SATANAKHIA
                jsr removeallactors
                lda #$03                        ;Load Agency level
                ldx #LLMODE_NORMAL
                jsr loadlevel
                lda #$05                        ;Make intro music continue
                sta zonemusic+$03               ;here
                ldx #ACTI_PLAYER
                lda #ACT_OBSERVER               ;Player as invisible
                sta actt,x                      ;observer
                lda #$00
                sta actd,x                      ;Face right
                jsr initcomplexactor
                lda #<agenttext
                ldy #>agenttext
                jsr fadeintext
                settrigger ACT_BLACKHAND,SCRIPT_AGENTINTRO,T_NEAR
                lda #$15
                ldx #$03
                jmp enterdoornum

l_sata0:        dc.b 34,"WELCOME! TO THE FARM RUINS AGAIN.",34,0
l_sata1:        dc.b 34,"SATANAKHIA AND LORD OBSKURIUS - THE DEVILS THEMSELVES.",34,0
l_sata2:        dc.b 34,"BUT WHY THAT MYSTERY, AND THE PIG SOUNDS?",34,0
l_sata3:        dc.b 34,"TO GET INTO THE RIGHT SPIRIT.",34,0
l_sata4:        dc.b 34,"DO YOU FEEL IT? THE PRESENCE OF SLAUGHTERED PIG SPIRITS?",34,0
l_sata5:        dc.b 34,"AH, COME ON.",34,0
l_sata6:        dc.b 34,"OK, LET'S GET SERIOUS. SEE, KOPROLOGIST LEFT US TO PURSUE OTHER GOALS.",34,0
l_sata7:        dc.b 34,"WE DON'T REALLY CARE, BUT THAT LEFT US WITHOUT A GUITARIST.",34,0
l_sata8:        dc.b 34,"SO WE THOUGHT, TWO WOULD BE MORE .. EVIL. INTERESTED?",34,0
l_sata9:        dc.b 34,"IT'S TEMPTING .. MAYBE THIS TIME THE CONSPIRACIES WOULDN'T GET IN THE WAY.",34,0
l_sata10:       dc.b 34,"I TAKE THAT AS YES.",34,0

agenttext:      dc.b 4,9,0,"MEANWHILE IN AN UNKNOWN LOCATION",0,$ff

;-------------------------------------------------------------------------------
; $0405
;-------------------------------------------------------------------------------

agentintro:     focus ACT_SARGE
                say l_agent1
                focus ACT_BLACKHAND
                say l_agent2
                focus ACT_SARGE
                say l_agent3
                focus ACT_BLACKHAND
                say l_agent4
                removetrigger ACT_BLACKHAND
                settrigger ACT_SATANAKHIA,SCRIPT_FARMCONTINUE,T_NEAR
                ldx #ACTI_PLAYER
                lda #ACT_IANCIVILIAN            ;Player back in normal form
                sta actt,x
                jsr initcomplexactor
                lda #$80
                sta actd,x                      ;Player facing left
                lda #$00                        ;Stop
                sta actsx,x
                jsr removeallactors
                lda #$02                        ;Load the Farm again
                ldx #LLMODE_NORMAL
                jsr loadlevel
                lda #$0b                        ;Band room has lights
                sta zonebg2+$05                 ;(again)
                lda #$0f
                ldx #$02
                jmp enterdoornum

l_agent1:       dc.b 34,"THE SATELLITE LINK IS BACK UP.",34,0
l_agent2:       dc.b 34,"DO WE HAVE ANYTHING?",34,0
l_agent3:       dc.b 34,"YES. I'M TRACKING AN IAC.",34,0
l_agent4:       dc.b 34,"WHERE IS IT HEADED?",34,0

                endscript

