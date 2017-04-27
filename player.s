DIFF_EASY       = 0                             ;Difficulty levels
DIFF_MEDIUM     = 1
DIFF_HARD       = 2

STATUS_TITLE    = $00
STATUS_INGAME   = $01
STATUS_GAMEOVER = $80

PLR_STAT_LIMIT  = 4                             ;Maximum VIT & STR - 1

MAX_Y_SPEED     = 64


GRAVITY_ACCEL   = 6                             ;Default acceleration due to
                                                ;gravity - true Agents can
                                                ;change this midair for longer
                                                ;jumps :)
WALLFLIP_SPEED_REDUCE = 12                      ;How much wallflip reduces
                                                ;jump speed from the original


PLRFR_STAND     = 0
PLRFR_RUN       = 1
PLRFR_JUMP      = 7
PLRFR_DUCK      = 8
PLRFR_CLIMB     = 12
PLRFR_OUT       = 16
PLRFR_DOOR      = 18
PLRFR_SIT       = 19
PLRFR_MELEE     = 20
PLRFR_AIM       = 22
PLRFR_SHOOTHIP  = 25
PLRFR_MELEEBACK = 28
PLRFR_AIMBACK   = 30
PLRFR_SHOOTHIPBACK = 33

Z_DURATION       = 16

;-------------------------------------------------------------------------------
; THINKER_PLAYER
;
; Interactive character (joystick control).
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

thinker_player: lda playerscripted
                beq tplr_manual
                jmp thinker_mammal
tplr_manual:    lda joystick                    ;Because of C64's limitations,
                lsr                             ;UP & JUMP are the same for
                lda joystick                    ;the player
                bcc tplr_nojump
                ora #JOY_JUMP
tplr_nojump:    sta actctrl,x
                lda actbits,x
                and #$ff-AB_AUTOJUMP-AB_AUTOTURN-AB_AUTOTURNDONE
                sta actbits,x
                rts

;-------------------------------------------------------------------------------
; MOVE_HUMAN
;
; Generic human move routine
;
; Parameters:X:Actor number
;
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

mho_done:       lda actlastdmghp,x
                bmi mho_killed
                lda actt,x                      ;The comradeagent?
                cmp comradeagent
                bne mho_nowakeup
                jsr random                      ;Random chance to wake up
                bne mho_nowakeup
                jsr initcomplexactor_noweap     ;Reset everything!
                lda #JOY_DOWN                   ;Ducked
                sta actctrl,x
                lda #M_ALERT                    ;Use the alert scan delay to
                sta actmode,x                   ;stay ducked for a while
                jsr tm_initalert                ;(kludge!)
                jmp move_humanok
mho_nowakeup:   jsr random                      ;Spawn 'Z' marks
                and #$1f
                clc
                adc acttime,x
                sta acttime,x
                bcc mho_noz
                ldy #ACTI_LASTNPCBLT-1
                lda #ACTI_LASTNPCBLT
                jsr getfreeactor
                bcc mho_noz
                lda #ACT_ZSIGN
                jsr spawnactor
                lda #Z_DURATION
                sta acttime,y
                lda #-15*8
                jsr spawnymod
                lda actd,x
                asl
                lda #15*8
                bcs mho_initz
                lda #-15*8
mho_initz:      jsr spawnxmod
mho_noz:
mho_killed:     lda actfb,x
                and #AFB_DISAPPEAR
                beq mho_nodisappear
                inc actfd,x
                lda actfd,x
                cmp #$30
                bcc mho_nodisappear
                cmp #$40
                bcs mho_dodisappear
doflicker:      lda actdb,x
                ora #ADF_FLICKER
                sta actdb,x
mho_nolanding:
mho_nodisappear:rts
mho_dodisappear:jmp removeactor
mho_init:       lda #$00
                sta actfd,x
                jsr checklanding
                bcs mho_onground                ;If on ground, go directly
mho_noground:   jsr takedownymod
                lda temp7                       ;to final frame
                bne mho_setframe

mh_out:         lda #PLRFR_OUT
mh_outcommon:   sta temp7                       ;Baseframe
                lda #WF_NONE                    ;Reset weapon frame
                sta actwf,x
                lda #$00                        ;Reset attacking
                sta actattkd,x
                sta actbits,x
                lda actf1,x
                cmp temp7
                bcc mho_init
                sbc #$02
                cmp temp7
                bcs mho_init
                jsr mgrn_movecommon
                lda actbits,x
                and #AB_LANDED
                beq mho_nolanding
mho_onground:   lda #$00
                sta actsx,x
                lda temp7
                clc
                adc #$01
mho_setframe:   sta actf1,x
                sta actf2,x
                jmp mho_done

move_human_rmcheck:
                jsr removecheck
move_human:     lda acthp,x                     ;Dead/unconscious?
                beq mh_out
move_humanok:   jsr mh_domove
                jmp attack_human

mh_domove:      jsr getspeeds
                lda actbits,x                   ;Check jumping/climbing
                lsr
                bcs mh_jump
                lsr
                bcc mh_noclimb
                jmp mh_climb
mh_noclimb:     jmp mh_onground

mh_jump:        lda #PLRFR_JUMP
                sta actf1,x
                sta actf2,x
mh_jump2:       lda actcapbits                  ;Grabbing a ladder in mid-air
                and #ACB_CLIMB                  ;(Green Beret inspired)
                beq mh_nograb
                lda actctrl,x
                and #JOY_UP|JOY_FIRE
                cmp #JOY_UP
                bne mh_nograb
                lda actsy,x                     ;Cannot grab until Y-speed
                bpl mh_grabok                   ;"positive" enough
                cmp #-2*8                       ;(to prevent repetitive grab)
                bcc mh_nograb
mh_grabok:      lda #-4
                jsr getcharposinfooffset
                and #CI_CLIMB
                beq mh_nograb
                jmp mh_initclimb

mh_minimumgravity:
                ldy #$01
                bne mh_dogravity
mh_nograb:      ldy #GRAVITY_ACCEL
                lda actcapbits
                and #ACB_LEVITATE
                bne mh_minimumgravity
                lda actcapbits
                and #ACB_LONGJUMP
                beq mh_dogravity
                lda actsy,x                     ;When going up, jump can
                bpl mh_dogravity                ;be made longer by pressing
                lda actctrl,x                   ;joystick up
                and #JOY_JUMP
                beq mh_dogravity
                dey
                dey
                dey
mh_dogravity:   tya
                ldy #MAX_Y_SPEED
                jsr accactory

                lda actmovectrl,x               ;Moving right while jumping?
                and #JOY_RIGHT
                beq mh_nojright
                lda accelpos
                lsr                             ;Halve acceleration
                ldy speedpos
                jmp mh_jxcommon
mh_nojright:    lda actmovectrl,x               ;Moving left while jumping?
                and #JOY_LEFT
                beq mh_nojleft
                lda accelneg
                lsr
                ora #$80
                ldy speedneg
mh_jxcommon:    sta actd,x
                jsr accactorx                   ;Perform acceleration
mh_nojleft:     jsr checkjumpobst               ;Perform X-movement and check
                bcc mh_jnoobst                  ;and check obstacles

                lda actcapbits                  ;Wallflipping
                and #ACB_WALLFLIP
                beq mh_nowallflip
                lda #JOY_LEFT|JOY_UP|JOY_JUMP
                ldy actsx,x
                bpl mh_wallflipright
                lda #JOY_RIGHT|JOY_UP|JOY_JUMP
mh_wallflipright:
                cmp actctrl,x
                bne mh_nowallflip
                lda actsy,x                     ;Must be still going upwards
                bmi mh_wallflipok               ;when doing the wall-flip
                cmp #2*8                        ;Or down very slowly!
                bcs mh_nowallflip
mh_wallflipok:  ldy #AD_JUMPSPEED
                lda (actlptrlo),y
                adc #WALLFLIP_SPEED_REDUCE      ;Carry = 1 after this
                sta actsy,x
                jsr reversexspeed
                sta actd,x
                jsr jumpsound
                jmp mh_jnoobst
mh_nowallflip:  lda #$00
                sta actsx,x
mh_jnoobst:     lda actsy,x
                bpl mh_noheadbump
                jsr moveactory
                jmp checkheadbump
mh_noheadbump:  jsr moveactory
                jsr checklanding
                bcc mh_notlanded
mh_landed:
                jsr walkingnoise
mh_setstandingframe:
                lda #PLRFR_STAND
                sta actf1,x
                sta actf2,x
mh_notlanded:   rts

mh_onground:    lda actmovectrl,x
                and #JOY_UP
                beq mh_noclimbup
                lda actctrl,x                           ;No climbing if
                and #JOY_FIRE                           ;fire held
                bne mh_noclimbup
                lda #-4
                jsr getcharposinfooffset
                and #CI_CLIMB
                beq mh_noclimbup
                lda actcapbits
                and #ACB_CLIMB
                beq mh_noclimbup
mh_initclimb:   lda #$80
                sta actxl,x
                lda actyl,x
                and #$c0
                sta actyl,x
                lda #PLRFR_CLIMB
                sta actf1,x
                sta actf2,x
                lda #$ff
                sta actfd,x
                lda #$00
                sta actsx,x
                sta actsy,x
                lda actbits,x
                and #255-AB_JUMP-AB_LANDED-AB_DUCK
                ora #AB_CLIMB
                sta actbits,x
                jmp nointerpolation

mh_noclimbup:   lda actmovectrl,x
                and #JOY_JUMP|JOY_LEFT|JOY_RIGHT
                cmp #JOY_JUMP+1
                bcc mh_nonewjump
                lda actprevctrl,x
                and #JOY_JUMP|JOY_FIRE
                bne mh_nonewjump
                lda actcapbits
                and #ACB_JUMP
                beq mh_nonewjump
                lda actbits,x                   ;Can't jump while ducking
                and #AB_DUCK
                bne mh_nonewjump
mh_jumpcommon:  jsr jumpsound
                jsr mh_initjump
                jmp mh_jump

mh_nonewjump:   lda actmovectrl,x
                and #JOY_DOWN
                beq mh_noduck
                lda actctrl,x                   ;No climbing if fire held
                and #JOY_FIRE
                bne mh_duck
                jsr getcharposinfo              ;Duck or climb?
                and #CI_CLIMB
                beq mh_duck
                lda actcapbits
                and #ACB_CLIMB
                beq mh_duck
                jmp mh_initclimb

mh_duck:
                cpx #ACTI_PLAYER                ;The player?
                bne mh_nopickup
                lda actprevctrl,x
                and #JOY_DOWN
                bne mh_nopickup
                jsr checkpickup                 ;Check picking up of items
mh_nopickup:


                lda actcapbits
                and #ACB_DUCK
                beq mh_noduck
                lda actbits,x
                ora #AB_DUCK
                sta actbits,x
                lsr speedpos                    ;Halve speed
                sec
                ror speedneg

                lda actmovectrl,x
                and #JOY_RIGHT
                beq mh_noduckr
                lda accelpos                    ;Direction = right
                ldy speedpos                    ;Max speed
                beq mh_noduckl
mh_duckcommon:  sta actd,x
                jsr accactorx                   ;Perform acceleration
                jmp mh_duckanim
mh_noduckr:     lda actmovectrl,x
                and #JOY_LEFT
                beq mh_noduckl
                lda accelneg                    ;Direction = right
                ldy speedneg                    ;Max speed
                bne mh_duckcommon
mh_noduckl:     lda #PLRFR_DUCK
                sta actf1,x
                sta actf2,x
                jmp mh_brake

mh_noduck:      lda actbits,x
                and #255-AB_DUCK
                sta actbits,x
                lda actmovectrl,x               ;Move player right?
                and #JOY_RIGHT
                beq mh_notr
                lda accelpos                    ;Direction = right
                ldy speedpos                    ;Max speed
                bne mh_runcommon
                beq mh_stand
mh_notr:        lda actmovectrl,x
                and #JOY_LEFT
                beq mh_stand
                lda accelneg                    ;Direction = left
                ldy speedneg                    ;Max speed
                bne mh_runcommon

mh_stand:       lda actf1,x                     ;Any of the special frames?
                cmp #PLRFR_OUT                  ;(sit, face door etc.)
                bcs mh_brake
                jsr mh_setstandingframe
mh_brake:       ldy #AD_BRAKEACCEL
                lda (actlptrlo),y                ;If joystick centered,
                jsr brakeactorx                 ;brake speed
                jmp mh_noframe

mh_duckanim:    lda #PLRFR_DUCK
                ldy #PLRFR_DUCK+4
                bne mh_animcommon
mh_runcommon:   sta actd,x
                jsr accactorx                   ;Perform acceleration
mh_runanim:     lda #PLRFR_RUN
                ldy #PLRFR_RUN+6

mh_animcommon:  sta temp1
                sty temp2
                lda actsx,x
                asl
                bcc mh_spdpos
                eor #$ff
                adc #$00
                clc
mh_spdpos:      adc #$20
                adc actfd,x
                sta actfd,x
                bcc mh_nofootstep
                cpx #ACTI_PLAYER
                bne mh_nowalknoise
                lda actf1,x
                cmp #PLRFR_RUN
                beq mh_walknoise
                cmp #PLRFR_RUN+3                ;Noise for player walking
                bne mh_nowalknoise
mh_walknoise:   jsr walkingnoise2
mh_nowalknoise: sec
mh_nofootstep:  jsr mh_animation2
mh_noframe:     jsr checksideobst               ;Perform X-movement and
                bcc mh_noobst                   ;check obstacles
                lda #$00
                sta actsx,x
                sta actfd,x
                ldy #PLRFR_STAND                ;Set standing/ducking
                lda actbits,x                   ;baseframe when hit obstacle
                and #AB_DUCK
                beq mh_obstnoduck
                ldy #PLRFR_DUCK
mh_obstnoduck:  tya
                sta actf1,x
                sta actf2,x
                cpx #ACTI_PLAYER
                bne mh_nosidedoor
                lda lvlobjnum
                bmi mh_nosidedoor
                jsr getcharposinfo
                and #CI_DOOR                   ;Walked into a "side door"?
                beq mh_nosidedoor              ;(for horizontal movement)
                lda actd,x                     ;Never go backwards
                eor acthitwalld,x              ;(knocked by gunfire etc.)
                and #$80
                bne mh_nosidedoor
                jsr checkfordoor
                bne mh_nosidedoor
                lda lvlobjnum                  ;Activate the object now
                jsr activateobject
                lda #DOORENTERDELAY            ;Force/fake the door entry :)
                sta actcounter
                lda #JOY_FIRE+JOY_UP
                sta actctrl,x
                lda #$00
                sta actmovectrl,x
mh_nosidedoor:

mh_noobst:      lda actmovectrl,x
                and #JOY_UP                     ;If holding joystick in
                beq mh_csnormal                 ;the up direction, up will
                jsr checkstairs_preferup        ;be preferred direction in
                bcs mh_nofall                   ;stairs
                bcc mh_initfall
mh_csnormal:    jsr checkstairs                 ;Check that there's ground
                bcs mh_nofall                   ;under feet

mh_initfall:    lda actbits,x                   ;Automatic jumping for NPCs?
                and #AB_AUTOJUMP
                beq mh_noautojump
                lda actctrl,x
                ora #JOY_JUMP
                sta actctrl,x
                lda actsx,x
                jsr negate
                jsr moveactorxdirect
                jmp mh_jumpcommon
mh_noautojump:  lda actbits,x
                and #AB_AUTOTURN
                beq mh_noautoturn
                lda actsx,x                     ;If speed already 0, there's
                beq mh_noautoturn               ;no sense..
                lda actbits,x
                ora #AB_AUTOTURNDONE
                sta actbits,x
                lda actsx,x
                sta acthitwalld,x
                jsr negate
                jsr moveactorxdirect            ;Return actor back from the
                lda #$00                        ;abyss and reset X-speed
                sta actsx,x
                rts

mh_initjump:    lda #-1                         ;Lift actor just off the
                jsr moveactorydirect            ;ground to prevent bg.coll. bug
                ldy #AD_JUMPSPEED
                lda (actlptrlo),y
mh_noautoturn:  sta actsy,x
                lda actbits,x
                and #255-AB_CLIMB-AB_LANDED
                ora #AB_JUMP
                sta actbits,x
mh_nofall:      rts

mh_climb:       jsr storelastgroundy
                lda actmovectrl,x
                and #JOY_UP
                bne mh_climbup
                jmp mh_climbnotup
mh_climbup:     lda actcapbits                  ;Check for exiting the ladder
                and #ACB_JUMP                   ;by jumping
                beq mh_cunojump
                lda actctrl,x
                and #JOY_FIRE
                bne mh_cunojump
                lda actprevctrl,x
                and #JOY_JUMP
                bne mh_cunojump
                lda actmovectrl,x
                and #JOY_JUMP|JOY_LEFT|JOY_RIGHT
                cmp #JOY_JUMP+1
                bcc mh_cunojump
                cmp #JOY_RIGHT|JOY_JUMP
                lda speedpos
                bcs mh_cujumpright
                lda speedneg
mh_cujumpright: sta actsx,x
                sta actd,x
                jmp mh_jumpcommon

mh_cunojump:    lda actyl,x
                and #$20
                bne mh_climbupok
                lda #-4
                jsr getcharposinfooffset
                and #CI_CLIMB
                beq mh_climbdone
mh_climbupok:   ldy #-4*8
mh_climbcommon: sty temp3
                ldy #AD_CLIMBSPEED
                lda (actlptrlo),y
                clc
                adc actfd,x
                sta actfd,x
                bcc mh_climbdone
                lda #PLRFR_CLIMB
                ldy #PLRFR_CLIMB+4
                jsr mh_animation
                lda actf1,x
                and #$01
                bne mh_climbnosound
                jsr walkingnoise
mh_climbnosound:lda temp3
                jsr moveactorydirect
                jsr nointerpolation
mh_climbdone:   lda #$00                        ;Reset X-speed
                sta actsx,x
                lda actyl,x
                and #$20
                bne mh_climbnoexit
                lda actctrl,x
                and #JOY_FIRE
                bne mh_climbnoexit
                lda actmovectrl,x
                and #JOY_LEFT+JOY_RIGHT         ;Exit ladder?
                beq mh_climbnoexit
                jsr getcharposinfo
                lsr
                bcc mh_climbnoexit
                lda actyl,x
                and #$c0
                sta actyl,x
                lda actbits,x
                and #$ff-AB_CLIMB
                sta actbits,x
                jmp mh_stand
mh_climbnoexit: rts

mh_climbnotup:  lda actmovectrl,x
                and #JOY_DOWN
                beq mh_climbdone
                jsr getcharposinfo
                and #CI_CLIMB
                beq mh_climbdone
                ldy #4*8
                bne mh_climbcommon

mh_animation:   sta temp1
                sty temp2
mh_animation2:  lda actf1,x
                adc #$00
                cmp temp1
                bcc mh_animreset
                cmp temp2
                bcc mh_animnoreset
mh_animreset:   lda temp1
mh_animnoreset: sta actf1,x
                sta actf2,x
nojumpsound:
wn_nonoise:     rts

walkingnoise:   cpx #ACTI_PLAYER
                bne wn_nonoise
walkingnoise2:  lda #NOISE_SILENT
                jsr makenoise
                lda #SFX_FOOTSTEP
wn_check:       ldy musicmode                   ;Do not play jump/footstep
                bne wn_nonoise                  ;sounds when music is on
                jmp playsfx

jumpsound:      cpx #ACTI_PLAYER
                bne nojumpsound
                lda #SFX_JUMP
                bne wn_check

getspeeds:      lda actctrl,x                   ;Use the last joystick position
                tay
                and #JOY_FIRE                   ;without fire for movement
                bne mh_movectrlok
                tya
                sta actmovectrl,x
mh_movectrlok:  ldy #AD_SPEEDPOS
                lda (actlptrlo),y                ;Take speed, acceleration
                sta speedpos
                iny
                lda (actlptrlo),y
                sta speedneg
                iny
                lda (actlptrlo),y
                sta accelpos
                iny
                lda (actlptrlo),y
                sta accelneg
                rts

takedownymod:   ldy #AD_TDYMOD                  ;Takedown Y-mod
                lda (actlptrlo),y
                jsr moveactorydirect
                jmp nointerpolation

;-------------------------------------------------------------------------------
; GETPLAYERZONE
;
; Finds player's zone and does necessary init
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,tempregs,map-tempregs
;-------------------------------------------------------------------------------

getplayerzone:  ldx actxh+ACTI_PLAYER
                ldy actyh+ACTI_PLAYER
                jsr findzonexy
                jmp initmap

;-------------------------------------------------------------------------------
; CENTERPLAYER
;
; Centers player on screen and redraws it
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y,tempregs,map-tempregs
;-------------------------------------------------------------------------------

centerplayer:   jsr getplayerzone
                lda #$38
                sta scrollx
                sta scrolly
                lda #SCROLLCENTER_Y
                sta scrollcentery
                lda actd+ACTI_PLAYER
                bmi cplr_left
                lda #SCROLLCENTER_X-CENTER_OFFSET
                sta scrollcenterx
                lda #$04
                sta cplr_xsub+1
                bne cplr_ok2
cplr_left:      lda #SCROLLCENTER_X+CENTER_OFFSET
                sta scrollcenterx
                lda #$06
                sta cplr_xsub+1
cplr_ok2:       ldx #$00
                ldy #$01
                lda limitr
                sec
                sbc #$0a
                sta cplr_notleft+1
                lda actxl+ACTI_PLAYER
                rol
                rol
                rol
                and #$03
                clc
                adc #$01
                cmp #$04
                and #$03
                sta blockx
                lda actxh+ACTI_PLAYER
                adc #$00
                sec
cplr_xsub:      sbc #$05
                bcc cplr_xover
                cmp limitl
                bcs cplr_notleft
cplr_xover:     stx blockx
                lda limitl
                bcc cplr_notright
cplr_notleft:   cmp #$00
                bcc cplr_notright
                stx scrollx
                sty blockx
                lda cplr_notleft+1
cplr_notright:  sta mapx
                lda limitd
                sec
                sbc #$06
                sta cplr_notup+1
                lda actyl+ACTI_PLAYER
                rol
                rol
                rol
                and #$03
                clc
                adc #$03
                cmp #$04
                and #$03
                sta blocky
                lda actyh+ACTI_PLAYER
                adc #$00
                sec
                sbc #$04
                bcc cplr_yover
                cmp limitu
                bcs cplr_notup
cplr_yover:     stx blocky
                lda limitu
                bcc cplr_notdown
cplr_notup:     cmp #$00
                bcc cplr_notdown
                stx scrolly
                iny
                sty blocky
                lda cplr_notup+1
cplr_notdown:   sta mapy
                lda #$ff                        ;Reset object search
                sta lvlobjnum
                lda zonenum                     ;Set raster interrupt
                sta rgscr_zonenum+1             ;zone colors
                jsr addallactors
                jsr moveactors
                jmp setredraw

mh_setdoorframe:
                lda #PLRFR_DOOR
                sta actf1,x
                sta actf2,x
                lda #WF_NONE
                sta actwf,x
                rts
