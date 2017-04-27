T_APPEAR        = 1 ;OK                 ;Actor trigger types + response bits
T_REMOVE        = 2 ;OK
T_POSTATTACK    = 4 ;OK
T_TAKEDOWN      = 8 ;OK
T_NEAR          = 16;OK
T_CONV          = 32;OK

SCRIPT_TITLE    = $0100
SCRIPT_TITLERUN = $0101
SCRIPT_GAMEMENU = $0102
SCRIPT_STATUS   = $0103
SCRIPT_SURGICAL = $0104
SCRIPT_RECHARGER = $0105
SCRIPT_USEITEMS  = $0106

SCRIPT_MAPSCREEN = $0200
SCRIPT_TERM1     = $0201
SCRIPT_TERM2     = $0202
SCRIPT_COP       = $0203
SCRIPT_WEAPONSHOP = $0204
SCRIPT_BARTENDER = $0205
SCRIPT_BREAKIN = $0206
SCRIPT_AXESMITH = $0207

SCRIPT_MUTANT = $0300
SCRIPT_TRAINSTART = $0301
SCRIPT_TRAINRUN  = $0302
SCRIPT_LIFTGPF  = $0303
SCRIPT_LIFTRESET = $0304
SCRIPT_ENTERSCEPTRE = $0305
SCRIPT_TRAINPLATFORM = $0306
SCRIPT_NEWGAME = $0307
SCRIPT_SCEPTRECODES = $0308
SCRIPT_TECHBOSS = $0309
SCRIPT_IAC    = $0309

SCRIPT_JOANINTRO = $0400
SCRIPT_SATANAKHIAINTRO = $0401
SCRIPT_JOANCONV = $0402
SCRIPT_BATDEAD = $0403
SCRIPT_INTROFADE = $0404
SCRIPT_AGENTINTRO = $0405

SCRIPT_FARMCONTINUE = $500
SCRIPT_IACATTACK = $501
SCRIPT_IACATTACKCONT = $502
SCRIPT_IANDOWN = $503
SCRIPT_IACATTACKCONT2 = $504
SCRIPT_CLINICINTRO = $505
SCRIPT_AGENCYSHORTCUT = $506

SCRIPT_AGENTSLEAVE = $0600
SCRIPT_BRIEFING = $0601

SCRIPT_BRIEFINGCONTINUE = $0700
SCRIPT_SARGELEAVE = $0701
SCRIPT_SARGECONV = $0702
SCRIPT_SARGECONV2 = $0703

SCRIPT_BLACKHANDCONV = $0800
SCRIPT_AGENCYEXITDOOR = $0801
SCRIPT_BLACKHANDLEAVEINIT = $0802
SCRIPT_BLACKHANDLEAVE = $0803

SCRIPT_BLOWFISHCONV    = $0900
SCRIPT_LETTER = $0901
SCRIPT_SUHRIM1  = $0902
SCRIPT_SUHRIM2  = $0903
SCRIPT_SUHRIM3  = $0904

SCRIPT_CODESFOUND = $0a01
SCRIPT_BLACKOPS   = $0a02
SCRIPT_DECODING2  = $0a03
SCRIPT_BLACKHANDCOMBAT = $0a04
SCRIPT_BLOWFISHINTRO = $0a05
SCRIPT_BLOWFISHPATHSTART = $0a06
SCRIPT_BLOWFISHPATHRUN = $0a07
SCRIPT_SADOK_HINT = $0a08

SCRIPT_DONOTFOLLOW = $0b00
SCRIPT_DONOTFOLLOW2 = $0b01
SCRIPT_INNERSPHERE = $0b03
SCRIPT_LILITH1 = $0b04
SCRIPT_LILITH2 = $0b05
SCRIPT_PYRAMID = $0b06
SCRIPT_INNER_TRAIN_START = $0b07
SCRIPT_INNER_TRAIN_RUN = $0b08
SCRIPT_SADOK_HINT2 = $0b09

SCRIPT_INNERSPHERETRAIN = $0b07
SCRIPT_INNERSPHERETRAINRUN = $0b08

SCRIPT_CODE1 = $0c00
SCRIPT_CODE2 = $0c01
SCRIPT_CODE3 = $0c02
SCRIPT_TELEPORT = $0c03
SCRIPT_TELEPORTDEST = $0c04
SCRIPT_EXOSKELETON = $0c05
SCRIPT_EXITDOOR = $0c06
SCRIPT_COUNCILDEAD = $0c07
SCRIPT_OBSKURIUSTERM = $0c08
SCRIPT_GENERATOR1 = $c09
SCRIPT_GENERATOR2 = $c0a
SCRIPT_SHUTDOWNMSG = $c0b
SCRIPT_IACNOTIFY = $c0c
SCRIPT_JOANBEFORETELEPORT = $c0d

SCRIPT_AHRIMAN = $0d00
SCRIPT_AHRIMANFIGHT = $0d01

SCRIPT_OBSKURIUS = $0e00
SCRIPT_EXAGENT  = $0e01
SCRIPT_EXAGENT2 = $0e03

SCRIPT_SARGEEREHWON = $1404

SCRIPT_DRULTRASHRED = $1500
SCRIPT_IRONFIST = $1501

SCRIPT_BLOWFISHCONV2 = $1600

SCRIPT_ASCENSION = $1700
SCRIPT_ASCENSIONRUN = $1701
SCRIPT_SENTINEL1 = $1702
SCRIPT_SENTINELTELEPORT = $1703
SCRIPT_SENTINEL2 = $1704
SCRIPT_SENTINELFOLLOW = $1705
SCRIPT_SENTINELBRIDGE = $1706
SCRIPT_SENTINELENGINE = $1707

SCRIPT_SENTINELAGENT = $1800
SCRIPT_SENTINELREUNION = $1801
SCRIPT_SENTINELREUNIONRUN = $1802
SCRIPT_SENTINELREUNIONEND = $1803
SCRIPT_BACKATTEMPLE = $1804

SCRIPT_JOANAGENT = $1900
SCRIPT_JOANDEATH = $1901
SCRIPT_LEFTBUTTON = $1902
SCRIPT_MELTDOWNINIT = $1903
SCRIPT_MELTDOWNCOUNTDOWN = $1904
SCRIPT_REACTORCOMPUTER = $1905

SCRIPT_DESTRUCTION =  $1a00
SCRIPT_DESTRUCTIONRUN =  $1a01
SCRIPT_JOANFINAL = $1a02
SCRIPT_ENDSEQUENCE = $1a03
SCRIPT_LILITHEND    = $1a04
SCRIPT_LILITHFIGHT = $1a05
SCRIPT_JOANDEATH2 = $1a06

SCRIPT_ENDSEQUENCERUN = $1b00

SCRIPT_SADOK2 = $1c00

SCRIPT_GOAT = $1d00
SCRIPT_GOATEND = $1d01
SCRIPT_GOATENDRUN = $1d02
SCRIPT_GOATIAC = $1d03
SCRIPT_GOAT2 = $1d04
SCRIPT_GOAT3 = $1d05
SCRIPT_SADOK = $1d06
SCRIPT_GOAT4 = $1d07

SCRIPT_FINALSCREEN = $1e00
SCRIPT_FINALSCREENRUN = $1e01

;-------------------------------------------------------------------------------
; SETACTORTRIGGER
;
; Sets or modifies an actor trigger
;
; Parameters: A:Script entrypoint
;             X:Script file
;             Y:Actor num
;             temp1:bitmask (what events to respond to)
; Returns: C=1 if actor triggers full
; Modifies: A,X,Y,temp regs
;-------------------------------------------------------------------------------

setactortrigger:sta temp2
                tya
                jsr at_search                   ;Either search for existing,
                cpy #NUMACTTRIGGER              ;or create new
                bcs sat_full
                sta attype,y
                lda temp2
                sta atscriptep,y
                txa
                sta atscriptf,y
                lda temp1
                sta atmask,y
                clc
sat_full:       rts

at_search:      ldy #$00
                sta at_searchcmp+1
                pha
at_searchloop:  lda attype,y                   ;Last trigger? (end of list)
                beq at_searchfail
at_searchcmp:   cmp #$00
                beq at_searchfound             ;C=1
                iny
                bne at_searchloop
at_searchfail:  clc
at_searchfound: pla
                rts

;-------------------------------------------------------------------------------
; REMOVEACTORTRIGGERS
;
; Removes all actor triggers.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,temp regs
;-------------------------------------------------------------------------------

removeactortriggers:
                ldy #NUMACTTRIGGER-1
                lda #$00
rats_loop:      sta attype,y
                dey
                bne rats_loop
rat_done:       rts

;-------------------------------------------------------------------------------
; REMOVEACTORTRIGGER
;
; Removes a certain actor trigger. After this, list needs to be shifted up
; in memory
;
; Parameters: A:Actor type
; Returns: -
; Modifies: A,X,Y,temp regs
;-------------------------------------------------------------------------------

removeactortrigger:
                jsr at_search
                bcc rat_done
rat_loop:       lda attype+1,y
                sta attype,y
                lda atscriptep+1,y
                sta atscriptep,y
                lda atscriptf+1,y
                sta atscriptf,y
                lda atmask+1,y
                sta atmask,y
                iny
                cpy #NUMACTTRIGGER
                bcc rat_loop
at_fail:        rts

;-------------------------------------------------------------------------------
; ACTORTRIGGER
;
; Starts an actor trigger routine
;
; Parameters: A:Type of trigger / message byte to the actor
;             X:Current actor
; Returns: -
; Modifies: A,Y,actrestx,possibly masses of temp regs
;-------------------------------------------------------------------------------

actortrigger:   sta scriptparam
                stx at_restx+1
                stx actrestx
                lda gameon                      ;Do not execute actortriggers
                cmp #STATUS_INGAME              ;after gameover
                bne at_fail
                lda actt,x                      ;Get actor type

                jsr at_search                   ;Search for actortrigger
                bcc at_cancel                   ;No trigger found
                lda atmask,y                    ;Check if should respond
                and scriptparam                 ;(to reduce unnecessary
                beq at_cancel                   ;loading for nonexistent
                lda atscriptep,y                ;actions)
                ldx atscriptf,y
                jsr execscript
at_cancel:
at_restx:       ldx #$00                        ;Make sure this is restored
                rts

;-------------------------------------------------------------------------------
; EXECSCRIPT
; EXECSCRIPTWITHPARAM
;
; Executes a script. Can also be used from a script to load the next part
;
; Parameters: A:Script entrypoint
;             X:Script file
;             Y:Parameter/data for script (EXECSCRIPTWITHPARAM)
; Returns: -
; Modifies: A,X,Y,possibly masses of temp regs
;-------------------------------------------------------------------------------

execscriptwithparam:
                sty scriptparam
execscript:     cpx #$00                        ;0 = no action
                beq es_done
                pha
                cpx scriptfilenum               ;Already loaded?
                beq es_skipload
                stx scriptfilenum
                txa
                ldx #FILE_SCRIPT-1
                jsr makefilename
                lda #<scriptarea
                ldx #>scriptarea
                jsr loadfileretry
                lda #$00                        ;Disable continued message
                sta msgcont                     ;(as it might no longer be in
                                                ;memory)
es_skipload:    pla                             ;Entrypoint
                asl
                tay
                lda scriptarea,y
                sta es_scriptjump+1
                lda scriptarea+1,y
                sta es_scriptjump+2
                lda scriptparam                 ;Script parameter
                ldx actrestx                    ;Possible actor that called
                                                ;script
es_scriptjump:  jmp $1000
es_done:        rts

;-------------------------------------------------------------------------------
; EXECLATENTSCRIPT
; STOPLATENTSCRIPT
;
; Sets or stops latent/continuous script for execution
;
; Parameters: A:Script entrypoint
;             X:Script file
; Returns: -
; Modifies: A,X,Y,possibly masses of temp regs
;-------------------------------------------------------------------------------

stoplatentscript:
                ldx #$00
execlatentscript:
                sta scriptep
                stx scriptf
                rts


