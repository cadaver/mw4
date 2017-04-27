;
; MW4 Scriptfile 03: New game, Entrance to SCEPTRE, SCEPTRE train
;
                include scriptm.s               ;Script macros etc.

START_LEVEL     = $02                           ;Proper game start
START_X         = $01
START_Y         = $05
START_SCRIPT    = SCRIPT_INTROFADE
START_ACT       = ACT_IANCIVILIAN
NEEDEDCODES = 4

;START_LEVEL     = $03                           ;Start from Agency
;START_X         = $05
;START_Y         = $05
;START_SCRIPT    = SCRIPT_AGENCYSHORTCUT
;START_ACT       = ACT_IANCIVILIAN
;NEEDEDCODES = 4

;START_LEVEL     = $05                           ;Start from the Campus
;START_X         = $01
;START_Y         = $05
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 4

;START_LEVEL     = $06                           ;Start from Comm.Interception
;START_X         = $05
;START_Y         = $1d
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 4

;START_LEVEL     = $08                           ;Start from Erehwon
;START_X         = $07
;START_Y         = $0d
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 4

;START_LEVEL     = $0b                           ;Start from Reseach
;START_X         = $27                          ;(bossfight)
;START_Y         = $3d
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

;START_LEVEL     = $06                           ;Start next to the code in
;START_X         = $7a                           ;CommInt, require only one
;START_Y         = $05
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 4

;START_LEVEL     = $03                           ;Start from Agency, perform
;START_X         = $22                          ;the decoding right away
;START_Y         = $0f
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

;START_LEVEL     = $0e                          ;Start from outside mansion
;START_X         = $00
;START_Y         = $31
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

;START_LEVEL     = $0f                          ;Start from mansion
;START_X         = $04
;START_Y         = $0c
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

;START_LEVEL     = $11                          ;Start from Global Influence
;START_X         = $24
;START_Y         = $05
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

;START_LEVEL     = $12                          ;Start from Inner Sphere Hub
;START_X         = $3c
;START_Y         = $0f
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

;START_LEVEL     = $12                          ;Start from the teleport
;START_X         = $89
;START_Y         = $0a
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

;START_LEVEL     = $19                          ;Start from the final level
;START_X         = $02
;START_Y         = $05
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

;START_LEVEL     = $04                          ;Start from Goatforest
;START_X         = $ae
;START_Y         = $0e
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

;START_LEVEL     = $17                          ;Start from Sentinel Temple
;START_X         = $38
;START_Y         = $16
;START_SCRIPT    = SCRIPT_INTROFADE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

;START_LEVEL     = $17                          ;Start from exiting Sentinel mothership
;START_X         = $38
;START_Y         = $16
;START_SCRIPT    = SCRIPT_SENTINELREUNIONEND
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

;START_LEVEL     = $17                          ;Start from endsequence
;START_X         = $38
;START_Y         = $16
;START_SCRIPT    = SCRIPT_ENDSEQUENCE
;START_ACT       = ACT_IANAGENT
;NEEDEDCODES = 0

GPF_LIFT_ID = $01

TRAINSEQUENCE_LENGTH = 96
TRAIN_ACCEL     = $01
TRAIN_MAXSPEED  = $40
TRAIN_SOUND_DELAY = $04


                entrypoint mutant               ;300 - Mutant boss
                entrypoint trainstart           ;301 - SCEPTRE train system
                entrypoint trainrun             ;302 - SCEPTRE train running
                entrypoint liftgpf              ;303 - Malfunctioning lift
                entrypoint liftreset            ;304 - Lift reset button
                entrypoint entersceptre         ;305 - SCEPTRE is entered..
                entrypoint trainplatform        ;306 - Trainstation rant..
                entrypoint newgame              ;307 - Newgame
                entrypoint sceptrecodes         ;308 - SCEPTRE code sheets
                entrypoint techboss             ;309 - Techboss, IAC


;-------------------------------------------------------------------------------
; $0300 - Mutant
;-------------------------------------------------------------------------------

mutant:         choice T_APPEAR,mutant_appear
                choice T_REMOVE,mutant_remove
mutant_takedown:
                lda #NUMZONES-1
                sta zoneflash
                lda #12
                sta zonebg2+$15
                lda #15
                sta zonebg3+$15
                lda #ACT_MUTANT2
                jsr removeactortrigger
mutant_remove:  jmp playzonetune

mutant_appear:  getbit PLOT_SCEPTRE_MUTANT_FIRSTTIME
                jumptrue mutant_skipmsg
                lda #<mutant_text
                ldx #>mutant_text
                ldy #MSGTIME
                jsr printmsgax
                setbit PLOT_SCEPTRE_MUTANT_FIRSTTIME
mutant_skipmsg: lda #$15
                sta zoneflash
                lda #$00
                sta zoneflashcount
                lda tunenum
                and #$fc
                ora #$03
                jmp playgametune

mutant_text:    dc.b "DANGER - EXPERIMENTAL LIFEFORM ESCAPED",0


;-------------------------------------------------------------------------------
; $0301 - SCEPTRE train start
;-------------------------------------------------------------------------------

trainstart:     lda #$00
                sta traincounter
                sta trainanimdelay
                sta trainspeed
                lda sourceobjnum
                and #$01
                sta traindir
                lda #<SCRIPT_TRAINRUN
                ldx #>SCRIPT_TRAINRUN
                jmp execlatentscript

;-------------------------------------------------------------------------------
; $0302 - SCEPTRE train running
;-------------------------------------------------------------------------------

trainrun:       lda trainspeed
                clc
                adc #TRAIN_ACCEL
                cmp #TRAIN_MAXSPEED
                bcc tr_speedok
                lda #TRAIN_MAXSPEED
tr_speedok:     sta trainspeed
                lda trainanimdelay
                clc
                adc trainspeed
                sta trainanimdelay
tr_animloop:    lda trainanimdelay
                cmp #TRAIN_MAXSPEED/2
                bcc tr_noanim
                sbc #TRAIN_MAXSPEED/2
                sta trainanimdelay
                jsr tr_anim
                jmp tr_animloop
tr_noanim:      inc traincounter
                lda traincounter
                cmp #TRAIN_SOUND_DELAY
                bne tr_nosound
                lda #SFX_TRAIN
                jsr playsfx
tr_nosound:     lda traincounter
                cmp #TRAINSEQUENCE_LENGTH
                bcc tr_nostop
                jsr stoplatentscript
                jsr cleartextscreen
                ldy sourceobjnum
                lda tr_desttbl-8,y
                sta ed_destdoor+1
                jmp ed_samelevel
tr_nostop:      rts

tr_anim:        ldy #$07
                lda traindir
                beq tr_animleft
tr_animright:   lda chars+$f5*8,y
                sta temp1
                lda chars+$f6*8,y
                sta chars+$f5*8,y
                lda chars+$f7*8,y
                sta chars+$f6*8,y
                lda chars+$f8*8,y
                sta chars+$f7*8,y
                lda chars+$f9*8,y
                sta chars+$f8*8,y
                lda chars+$fa*8,y
                sta chars+$f9*8,y
                lda chars+$fb*8,y
                sta chars+$fa*8,y
                lda chars+$fc*8,y
                sta chars+$fb*8,y
                lda temp1
                sta chars+$fc*8,y
                dey
                bpl tr_animright
                rts
tr_animleft:    lda chars+$fc*8,y
                sta temp1
                lda chars+$fb*8,y
                sta chars+$fc*8,y
                lda chars+$fa*8,y
                sta chars+$fb*8,y
                lda chars+$f9*8,y
                sta chars+$fa*8,y
                lda chars+$f8*8,y
                sta chars+$f9*8,y
                lda chars+$f7*8,y
                sta chars+$f8*8,y
                lda chars+$f6*8,y
                sta chars+$f7*8,y
                lda chars+$f5*8,y
                sta chars+$f6*8,y
                lda temp1
                sta chars+$f5*8,y
                dey
                bpl tr_animleft
                rts

tr_desttbl:     dc.b $0a,$0f
                dc.b $0c,$09
                dc.b $0e,$0b
                dc.b $08,$0d


;-------------------------------------------------------------------------------
; $0303 - Lift switch GPF
;-------------------------------------------------------------------------------

liftgpf:        lda #SFX_OBJECT
                jsr playsfx
                lda #PLOT_SCEPTRE_LIFT_GPF
                jsr checkplotbit
                bne liftgpf_ok
                lda #<liftgpf_text
                ldx #>liftgpf_text
                ldy #MSGTIME
                jmp printmsgax
liftgpf_ok:     lda #ACT_LIFT1                          ;Activate the lift
                ldx #GPF_LIFT_ID                        ;normally
                jmp ao_aaactorax

liftgpf_text:   dc.b "SWITCH GENERAL PROTECTION FAULT",0

;-------------------------------------------------------------------------------
; $0304 - Lift reset
;-------------------------------------------------------------------------------

liftreset:      lda #SFX_OBJECT
                jsr playsfx
                lda #PLOT_SCEPTRE_LIFT_GPF
                jmp setplotbit

;-------------------------------------------------------------------------------
; $0305 - Enter SCEPTRE
;-------------------------------------------------------------------------------

entersceptre:   givepoints 10000
                setbit PLOT_SCEPTRE_ENTERED
                getbit PLOT_BLACKHAND_DEAD
                jumptrue es_abort
                jsr transmission
                plrsay l_enter1
                saytrans l_enter2
                saytrans l_enter3
es_abort:       stop


l_enter1:       dc.b 34,"I'M AT A TRIANGLE-WITH-EYE SIGN.",34,0
l_enter2:       dc.b "BLACKHAND - ",34,"THAT'S THE SIGN OF SCEPTRE. GOOD WORK, "
                dc.b "YOU'RE INSIDE.",34,0
l_enter3:       dc.b "SARGE - ",34,"WHILE YOU'RE THERE, YOU MIGHT COME ACROSS "
                dc.b "BIOTECHNICAL MODIFICATIONS - UPGRADES - THAT IMPROVE YOUR "
                dc.b "STRENGTH AND VITALITY. IF YOU DON'T HAVE A PROBLEM WITH "
                dc.b "MESSING WITH YOUR BODY, USE THE HEALING MACHINES TO "
                dc.b "INSTALL THEM. ALSO LOOK FOR ARMOR UPGRADES.",34,0

;-------------------------------------------------------------------------------
; $0306 - SCEPTRE train platform
;-------------------------------------------------------------------------------

trainplatform:  lda #$12                        ;Disable the other trigger
                jsr setlvlobjstat
                lda #$13
                jsr setlvlobjstat
                setbit PLOT_SCEPTRE_ENTERED
                givepoints 10000
                getbit PLOT_BLACKHAND_DEAD
                jumptrue tp_abort
                jsr transmission
                plrsay l_platform1
                saytrans l_platform2
tp_abort:       stop

l_platform1:    dc.b 34, "THIS LOOKS LIKE A TRAIN PLATFORM.",34,0
l_platform2:    dc.b "BLACKHAND - ",34,"IF OUR RESEARCH IS CORRECT, THE TUNNELS CONNECT TO OTHER SCEPTRE FACILITIES. IT'S THE SO-CALLED OUTER SPHERE.",34,0

;-------------------------------------------------------------------------------
; $0307 - New game
;-------------------------------------------------------------------------------

newgame:        jsr resetmessage
                jsr cleartextscreen
                jsr stoplatentscript

                jsr initactors                  ;Remove all actors
                lda #$00                        ;Load initial levelactors
                ldx #FILE_ACTORS
                jsr makefilename
                lda #<lvlactarea
                ldx #>lvlactarea
                jsr loadfileretry

                lda #NUMLEVELS-1                ;Reset status of all objects
                sta temp7
newgame_objloop:lda temp7                       ;in all levels
                jsr getlvlobjstatptr
                ldy #15
                lda #$00
newgame_objloop2:
                sta (lvlobjstatptrlo),y
                dey
                bpl newgame_objloop2
                dec temp7
                bpl newgame_objloop

                ldx #(NUMPLOTBITS/8)-1         ;Reset all boolean flags
newgame_plotbitloop:
                sta plotbits,x
                dex
                bpl newgame_plotbitloop

                lda #STATUS_INGAME
                sta gameon
                lda #$00                        ;Clear score + other things
                ldx #lastgamevar-firstgamevar-1
clearstatloop:  sta firstgamevar,x
                dex
                bpl clearstatloop
                jsr setscoreupdate
                jsr setplayerstatus             ;Set player damage subtract

                ldy #$02
initcode:       jsr random                      ;Random teleport code in
                and #$0f                        ;each game
                cmp #$0a
                bcs initcode
                sta teleportcode,y
                dey
                bpl initcode

                ldx #NUMGRP-1                   ;Initial group alliances
initalliance:   lda initalliancetbl,x
                sta alliance,x
                dex
                bpl initalliance

                jsr removeactortriggers         ;Reset all actortriggers
                ldy #$00
                ldx #$00
inittriggerloop:
                lda inittriggertbl,x
                beq inittriggerdone
                sta attype,y
                lda inittriggertbl+1,x
                sta atscriptep,y
                lda inittriggertbl+2,x
                sta atscriptf,y
                lda inittriggertbl+3,x
                sta atmask,y
                iny
                txa
                clc
                adc #$04
                tax
                bne inittriggerloop
inittriggerdone:

initinventory:  ldy #INVENTORYSIZE-1            ;Clear all inventory slots
                lda #$00
ii_loop:        sta invtype,y
                sta invcountlo,y
                sta invcounthi,y
                dey
                bpl ii_loop
                sta invselect
                ldx #ITEM_FISTS                 ;Never leave home without fists :)
                jsr additem
                ldx #ITEM_CREDITS
                lda #20                         ;Some credits..
                jsr additem

                lda #PLOT_MAP_SUBCITY           ;Allowed locations to travel
                jsr setplotbit
                lda #PLOT_MAP_FARM
                jsr setplotbit

        ;
        ; Code for testing shortcuts!
        ;

                if START_ACT = ACT_IANAGENT     ;Player is an Agent already;
                lda #1                          ;Give armor
                sta plrarmor
                lda #PLOT_MAP_ALLOWED           ;Give locations to visit
                jsr setplotbit
                lda #PLOT_MAP_AGENTHQ
                jsr setplotbit
                ldx #ITEM_44_MAGNUM_PISTOL      ;Give weapon
                lda #8
                jsr additem
                ldx #ITEM_44MAGNUM_AMMO
                lda #8
                jsr additem
                lda #$7f                        ;Transport bandmembers away
                sta temp7                       ;from the Farm, to not have
                lda #ACT_JOANCIVILIAN           ;weird effects
                jsr transportactor
                lda #ACT_SATANAKHIA
                jsr transportactor
                lda #ACT_LORDOBSKURIUS
                jsr transportactor
                jsr setplayerstatus
                endif
                if NEEDEDCODES = 0              ;Setup the decode scene
                jsr setdecodetrigger            ;right away
                endif

                lda #START_LEVEL                ;Load starting level
                ldx #LLMODE_NORMAL
                jsr loadlevel
                ldy #ACTI_PLAYER                ;Create player actor
                lda #START_ACT
                jsr createactor
                tya
                tax
                lda #START_X                    ;Set starting location
                sta actxh,x
                lda #START_Y
                sta actyh,x
                jsr initcomplexactor
                lda #$00
                sta actd,x                      ;Facing right
                jsr getplayerzone
                jsr playzonetune                ;Start zone music
                jumpto START_SCRIPT             ;Go to starting script

inittriggertbl: dc.b ACT_STREETCOP,<SCRIPT_COP,>SCRIPT_COP,T_TAKEDOWN+T_CONV
                dc.b ACT_WEAPONSHOP,<SCRIPT_WEAPONSHOP,>SCRIPT_WEAPONSHOP,T_CONV
                dc.b ACT_TECHBOSS,<SCRIPT_TECHBOSS,>SCRIPT_TECHBOSS,T_APPEAR|T_TAKEDOWN|T_REMOVE
                dc.b ACT_EXOSKELETON,<SCRIPT_EXOSKELETON,>SCRIPT_EXOSKELETON,T_APPEAR|T_TAKEDOWN|T_REMOVE
                dc.b ACT_MUTANT2,<SCRIPT_MUTANT,>SCRIPT_MUTANT,T_APPEAR|T_TAKEDOWN|T_REMOVE
                dc.b ACT_BARTENDER,<SCRIPT_BARTENDER,>SCRIPT_BARTENDER,T_CONV
                dc.b ACT_BLOWFISH,<SCRIPT_BLOWFISHINTRO,>SCRIPT_BLOWFISHINTRO,T_NEAR|T_CONV
                dc.b ACT_AXESMITH,<SCRIPT_AXESMITH,>SCRIPT_AXESMITH,T_CONV
                dc.b ACT_EXAGENT,<SCRIPT_EXAGENT,>SCRIPT_EXAGENT,T_CONV
                dc.b ACT_SUHRIMBYSTD,<SCRIPT_SUHRIM1,>SCRIPT_SUHRIM1,T_APPEAR
                dc.b ACT_OBSKURIUSHEAD,<SCRIPT_OBSKURIUS,>SCRIPT_OBSKURIUS,T_CONV|T_NEAR
                dc.b ACT_ULTRASHRED,<SCRIPT_DRULTRASHRED,>SCRIPT_DRULTRASHRED,T_CONV
                dc.b ACT_IRONFIST,<SCRIPT_IRONFIST,>SCRIPT_IRONFIST,T_CONV|T_NEAR
                dc.b ACT_GOAT,<SCRIPT_GOAT,>SCRIPT_GOAT,T_CONV|T_NEAR
                dc.b 0

initalliancetbl:dc.b #%01111111                  ;Bystander hates none
                dc.b #%00001011                  ;Agents hate all except cops
                dc.b #%01000101                  ;SCEPTRE hates all except beasts
                dc.b #%00001111                  ;Cops hate criminals
                dc.b #%00010101                  ;Criminals hate cops, agents
                dc.b #%00100101                  ;and the opposing group but FEAR SCEPTRE!
                dc.b #%01000000                  ;Beasts hate all

;-------------------------------------------------------------------------------
; $0308 - SCEPTRE codes
;-------------------------------------------------------------------------------

sceptrecodes:   getbit PLOT_BLACKHAND_DEAD      ;Check for bizarre possibility
                jumptrue sc_abort               ;as result of hacking..

                lda aonum                       ;Let this trigger happen
                jsr deactivateobject            ;again, and again..
                lda #PLOT_SCEPTRE_CODE1_FOUND
                sta temp1
                lda #ITEM_CODESHEET1
                sta temp2
sc_checkloop:   lda temp1                       ;Check all 4 codes
                jsr checkplotbit
                bne sc_skipcheck
                lda temp2
                jsr finditem
                bcc sc_skipcheck
                lda temp1
                jsr setplotbit
                jmp sc_newcode
sc_skipcheck:   inc temp1
                inc temp2
                lda temp1
                cmp #PLOT_SCEPTRE_CODE1_FOUND+4
                bcc sc_checkloop
sc_abort:       stop

sc_newcode:     inc codesfound
                lda codesfound
                choice NEEDEDCODES,sc_msg4
                choice 1,sc_msg1
                choice 2,sc_msg2
                stop

sc_msg1:        givepoints 10000
                jsr transmission
                plrsay l_scmsg10
                saytrans l_scmsg11
                stop
sc_msg2:        jsr transmission
                plrsay l_scmsg20
                saytrans l_scmsg21
                stop
sc_msg4:        givepoints 10000
                jsr transmission
                plrsay l_scmsg40
                saytrans l_scmsg41
setdecodetrigger:
                settrigger ACT_BLACKHAND,SCRIPT_CODESFOUND,T_NEAR|T_CONV
                lda #$03
                sta temp7
                ldx #$26
                ldy #$0f
                lda #ACT_BLACKHAND
                jsr transportactor
                ldx #$28
                ldy #$0f
                lda #ACT_SARGE
                jsr transportactor
                ldy #LA_FINE            ;Sitting
                lda #M_SIT*16+$03
                sta (lvlactptrlo),y
                stop

l_scmsg10:      dc.b 34,"I'VE FOUND SOME KIND OF A CODE.",34,0
l_scmsg11:      dc.b "BLACKHAND - ",34,"INTERESTING, I DON'T HAVE AN IDEA OF IT SO FAR, BUT KEEP LOOKING.",34,0

l_scmsg20:      dc.b 34,"ANOTHER CODE. SIMILAR TO THE FIRST.",34,0
l_scmsg21:      dc.b "BLACKHAND - ",34,"HMM.. LIKE PIECES IN A PUZZLE, PERHAPS.",34,0

l_scmsg40:      dc.b 34,"NOW I HAVE CODES FROM ALL FOUR FACILITIES.",34,0
l_scmsg41:      dc.b "BLACKHAND - ",34,"AND I HAVE AN IDEA. PLEASE COME BACK TO HQ.",34,0

;-------------------------------------------------------------------------------
; $0309 - Technician boss, IAC, other simple bosses
;-------------------------------------------------------------------------------

techboss:       choice T_APPEAR,techboss_appear
                choice T_REMOVE,techboss_remove
techboss_takedown:
                lda actt,x
                jsr removeactortrigger
                lda actt,x
                cmp #ACT_TECHBOSS
                bne techboss_remove
                lda #ITEM_BASEMENT_ACCESS
                sta actwpn,x                    ;Drop keycard
techboss_remove:jmp playzonetune

techboss_appear:lda tunenum
                and #$fc
                ora #$03
                jmp playgametune


                endscript

