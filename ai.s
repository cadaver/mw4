GRP_BYSTANDER   = 0
GRP_AGENTS      = 1
GRP_SCEPTRE     = 2
GRP_COPS        = 3
GRP_CRIMINAL1   = 4
GRP_CRIMINAL2   = 5
GRP_BEASTS      = 6
GRP_LIFT        = 128                   ;Lift platforms

LEVELALERT_MAX  = 32
LEVELALERT_MOD  = 10

RM_NOATTACK     = 0                     ;Reaction modes: how should react to
RM_SELFDEFENSE  = 1                     ;opposing groups
RM_ONSIGHT      = 2

HM_HORIZ        = 0                     ;Pathfinding modes
HM_VERT         = 1
HM_FREEDOWN     = 2
HM_FREEUP       = 3

M_IDLE          = 0                     ;AI modes
M_TURNLEFT      = 1
M_TURNRIGHT     = 2
M_TURNTOTARGET  = 3
M_FREE          = 4
M_SIT           = 5
M_ANIM          = 6
M_GOTO          = 7
M_SPARSEARCH    = 8
M_PATROL        = 9
M_ALERT         = 10
M_SPAR          = 11
M_COMBAT        = 12

NOISE_SILENT    = 1
NOISE_MEDIUM    = 2
NOISE_MODERATE  = 2
NOISE_LOUD      = 3

D_LEFT          = $80                           ;Directions
D_RIGHT         = $00

JUMPTHRESHOLD   = 3*8                           ;Minimum speed required
                                                ;for AI jumps in combat
JUMPDISTTHRESHOLD = 5

MAXSTEPS        = 10                            ;Max. steps to checking
                                                ;target route

NOISETHRESHOLD  = 4                             ;Moderate noise alerts actors
                                                ;max. 4 blocks away

EXITFREEMODEPROB = $20                          ;Free mode exit probability
                                                ;(GOTO state)

ENEMYITEMSPEED  = -4*8

WAYPOINT0       = $80
WAYPOINT1       = $81
WAYPOINT2       = $82
WAYPOINT3       = $83
WAYPOINT4       = $84
WAYPOINT5       = $85
WAYPOINT6       = $86
WAYPOINT7       = $87


TARGETTING_MAXYDIST = 4

MAX_CONV_XDIST  = 2

MEDIKIT_DROP_PROBABILITY = $1d  ;SCEPTRE
CREDITS_DROP_PROBABILITY = $30  ;Thugs/cops

FARTURN_PROBABILITY = $80
NEWTARGET_PROBABILITY = $80
CLIMB_PROBABILITY = $c0

;-------------------------------------------------------------------------------
; THINKER_MAMMAL
;
; Main AI for NPCs (Ninjas are mammals)
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

thinker_mammal:
tm_ok:          ldy #AD_REACTMODE
                lda (actlptrlo),y
                sta actreactmode
                ldy acttarget,x
                bpl tm_nowaypoint
                lda #$80                        ;Middle of the block
                sec
                sbc actxl,x
                lda waypointxh-$80,y
                sbc actxh,x
                sta targetxdist
                bpl tm_wpxok
                eor #$ff
tm_wpxok:       sta targetabsxdist
                lda waypointyh-$80,y
                sec
                sbc actyh,x
                sta targetydist
                bpl tm_wpyok
                eor #$ff
tm_wpyok:       sta targetabsydist
                lda #$00
                sta maptemp2
                lda waypointyh-$80,y
                bpl tm_waypointok

tm_nowaypoint:  lda actt,y
                beq tm_targetinactive
                lda actgrp,y
                bpl tm_targetok
                lda #$00
tm_targetok:
tm_targetinactive:
                sta targetactive
                jsr gettargetdistance
                lda actmode,x                   ;In combat, use actual Y
                cmp #M_COMBAT
                bne tm_uselast
tm_usecurrent:  lda actyl,y
                sta maptemp2
                lda actyh,y
                bpl tm_waypointok
tm_uselast:     lda actlastgroundyl,y           ;Otherwise, use last Y
                sta maptemp2                    ;(pathfinding)
                lda actlastgroundyh,y

tm_waypointok:  sec
                sbc actyh,x
                bne tm_compareok2
                lda actyl,x
                and #$c0
                lsr
                sta maptemp1
                lda maptemp2
                and #$c0
                lsr
                sec
tm_cmpsbc2:     sbc maptemp1
tm_compareok2:  sta targetycompare
                lda actmode,x
                asl
                tay
                lda tm_modejumptbl,y
                sta tm_modejump+1
                lda tm_modejumptbl+1,y
                sta tm_modejump+2
tm_modejump:    jmp tm_idle

;-------------------------------------------------------------------------------
; SIT state
;-------------------------------------------------------------------------------

tm_sit:         jsr tmi_checkinfront
                lda #PLRFR_SIT
                sta actf1,x
                sta actf2,x
                lda #$00
                sta actsx,x
                sta actctrl,x
tm_anim:        rts

;-------------------------------------------------------------------------------
; FREE state
;-------------------------------------------------------------------------------

tm_free:        rts

;-------------------------------------------------------------------------------
; TURNLEFT state
;-------------------------------------------------------------------------------

tm_turnleft:    lda #D_LEFT
tm_turndone2:   sta actd,x
tm_turndone:    lda #M_IDLE
                sta actmode,x
tmi_cifnotargetting:
tm_none:        rts

;-------------------------------------------------------------------------------
; TURNRIGHT state
;-------------------------------------------------------------------------------

tm_turnright:   lda #D_RIGHT
                bpl tm_turndone2

;-------------------------------------------------------------------------------
; TURNTOTARGET state
;-------------------------------------------------------------------------------

tm_turntotarget:lda #$00
                sta actctrl,x
                lda targetxdist
                sta actd,x
                rts

;-------------------------------------------------------------------------------
; IDLE state
;-------------------------------------------------------------------------------

tm_idle:        lda actbits,x                   ;Finish climbing
                and #AB_CLIMB                   ;before going fully idle
                beq tmi_noclimb
tm_goto:        jsr tm_goto2
                jmp tmi_checkinfront

tmi_noclimb:    lda #$00
                sta actctrl,x
tmi_checkinfront:
                lda actwpn,x                    ;If no weapon, no targetting
                beq tmi_cifnotargetting
                lda actfb,x
                and #AFB_REACTVISUAL
                beq tmi_checkhate
                lda actreactmode
                cmp #RM_ONSIGHT                 ;Shoot all enemy groups on
                bcc tmi_checkhate               ;sight?
                jsr randomcomplexact
                sta temp1
                tay
                lda actt,y
                beq tmi_checkhate
                jsr gettargetdistance
                lda targetxdist                 ;Must be facing target
                eor actd,x
                and #$80
                bne tmi_checkhate
                lda targetabsxdist              ;Must be within patrol radius
                bne tmi_notzerodist
                lda targetabsydist              ;Zero X-dist a special case:
                bne tmi_checkhate               ;if above or below, can't see
tmi_notzerodist:lda targetabsxdist
                ldy #AD_PATROLRADIUS
                cmp (actlptrlo),y
                bcs tmi_checkhate
                ldy temp1
                lda acthp,y
                bne tmi_enemy
tmi_body:       lda actfb,x                     ;A body, yes...
                and #AFB_REACTBODIES
                beq tmi_checkhate
                lda actgrp,y                    ;React only to bodies
                cmp actgrp,x                    ;of same group
                bne tmi_checkhate
                jsr tma_checktgtroute
                bcc tmi_checkhate
                jmp tmc_gotoalert

tmi_enemy:      lda actgrp,y                    ;(Never target bystanders)
                ;beq tmi_checkhate
                bmi tmi_checkhate
                cmp actgrp,x
                beq tmi_checkhate               ;Don't target own group

                tay                             ;Alliance check
                lda keyrowbit,y
                eor #$ff
                ldy actgrp,x
                and alliance,y
                bne tmi_checkhate

tmi_enemyok:    lda targetabsydist              ;Must not be far in Y-dist
                cmp #TARGETTING_MAXYDIST
                bcs tmi_checkhate
                ldy temp1
                jsr tma_checktgtroute           ;Check route to target
                bcc tmi_stayidle
                lda temp7
                sta acttarget,x                 ;Enemy found!
                bcs tmi_gotohate
tmi_checkhate:  clc
                lda actreactmode                ;No attack, even in self-
                beq tmi_stayidle                ;defense?
                lda actlastdmgact,x             ;Damage caused by an actor?
                bmi tmi_stayidle
                sta acttarget,x                 ;Hate that actor!
                lda #$ff
                sta actlastdmgact,x
tmi_gotohate:   lda #M_COMBAT
                sta actmode,x
                lda #HM_HORIZ
                sta acthomemode,x
                txa
                sta actroutecheck,x             ;Reset routecheck counter
                lda #$00
                sta actattklen,x
                sec
tmi_stayidle:   rts

;-------------------------------------------------------------------------------
; ALERT state
;-------------------------------------------------------------------------------

tm_alert:       lda actattklen,x
                bne tma_noinit
tm_initalert:   jsr randomcomplexact
                sta acttarget,x
                lda #NUMCOMPLEXACT              ;Go through this many actors
                sta actattklen,x
tma_flagofhate: rts
tma_noinit:     jsr tmi_checkhate               ;A direct attack? -
                bcs tma_flagofhate              ;check "flag of hate" :)
                ldy acttarget,x
                lda actt,y
                beq tma_next
                lda acthp,y                     ;Don't target already beaten
                beq tma_next                    ;targets
                jsr gettargetdistance
                lda targetabsxdist
                ldy #AD_ALERTRADIUS             ;Outside alert radius?
                cmp (actlptrlo),y
                bcs tma_next
                ldy acttarget,x
                sty temp1
                jsr tmi_enemy
                bcs tma_nonext
tma_next:       inc acttarget,x                 ;Target not OK, check next
                lda acttarget,x
                cmp #NUMCOMPLEXACT
                bcc tma_nowrap
                lda #$00
                sta acttarget,x
tma_nowrap:     dec actattklen,x                ;Was this the last?
                lda actattklen,x
                beq tma_last
tma_nonext:     rts

tma_gotopatrol:
tma_last:       lda #M_PATROL                   ;Move to Patrol mode
                sta actmode,x
                lda #T_POSTATTACK               ;Execute post-attack script
                jsr actortrigger
tma_clearab:    lda actbits,x
                and #255-AB_AUTOTURNDONE-AB_HITWALL
                sta actbits,x
                rts

tma_checktgtroute:
                sty temp7
                lda actxh,x                     ;Store the original pos
                sta temp1
                lda actyh,x
                sta temp2
                lda actyh,y
                sta temp3
                lda actyl,x
                bmi tma_routeskipdec1
                dec temp2                       ;Lift both Y-positions up
tma_routeskipdec1:                              ;one block, when on top of
                lda actt,y                      ;a block
                cmp #ACT_CEILTURRET
                beq tma_routeskipdec2           ;Exception for the ceiling turret
                lda actyl,y
                bmi tma_routeskipdec2
                dec temp3
tma_routeskipdec2:
                lda #MAXSTEPS                   ;Maximum target distance
                sta temp4
tma_routeloop:  ldy temp7                       ;Then move to the target,
                lda actxh,y                     ;checking obstacles along
                cmp temp1                       ;the way
                beq tma_xok
                bcc tma_xleft
                inc temp1
tma_ycheck2:    lda temp3
                cmp temp2
                beq tma_check
                bcc tma_yup2
tma_ydown2:     inc temp2
                jmp tma_check
tma_yup2:       dec temp2
                jmp tma_check
tma_xleft:      dec temp1
                jmp tma_ycheck2
tma_xok:        lda temp3
                cmp temp2
                beq tma_routeok                 ;Carry = 1!
                bcc tma_yup2
                bcs tma_ydown2
tma_routeok:    rts
tma_check:      jsr tma_checkblockmiddle
                and #CI_OBSTACLE
                bne tma_routenotok
                dec temp4
                bne tma_routeloop
tma_routenotok: clc
                rts

tma_checkblockmiddle:
                lda #$06
tma_checkblockmiddle2:
                sta tma_param+1
tma_checkblockmiddle3:
                ldy temp2
                lda maptbllo,y
                sta tempadrlo
                lda maptblhi,y
                sta tempadrhi
                ldy temp1
                lda (tempadrlo),y               ;Take block from map
                tay
                lda blktbllo,y
                sta tempadrlo
                lda blktblhi,y
                sta tempadrhi
tma_param:      ldy #$06                        ;Check from middle of block
                lda (tempadrlo),y               ;Take char from block
                tay
                lda charinfo,y                  ;Take char's charinfo
                rts

;-------------------------------------------------------------------------------
; PATROL state
;-------------------------------------------------------------------------------

tm_patrol:      lda actbits,x                   ;Finish climbing
                and #AB_CLIMB                   ;if on stairs
                beq tmp_noclimb
                jmp tm_goto2
tmp_noclimb:    jsr tmi_checkinfront            ;Check enemy in front of eyes
                bcs tmp_hate                    ;+direct attack
                lda actattklen,x
                bne tmp_standing
                jsr random                      ;Random chance of going idle

                ldy #AD_PATROLIDLEPROB
                cmp (actlptrlo),y
                bcs tmp_noidle

                jsr random
                and #$1f
                ldy #AD_PATROLIDLETIME
                adc (actlptrlo),y
                sta actattklen,x
                jsr random
                cmp #FARTURN_PROBABILITY
                bcc tmp_turn2
tmp_noidle:     lda actbits,x                   ;Hit wall?
                and #AB_AUTOTURNDONE|AB_HITWALL
                bne tmp_turn
                lda actd,x                      ;Left or right?
                bmi tmp_left
tmp_right:      lda #JOY_RIGHT
tmp_dirok:      sta actctrl,x
tmp_ok:         lda actbits,x                   ;Patrolling is simple :)
                ora #AB_AUTOTURN
                sta actbits,x
tmp_hate:       rts
tmp_left:       lda #JOY_LEFT
                bne tmp_dirok
tmp_turn:       lda actd,x                      ;If actor has already turned
                eor acthitwalld,x               ;away from obstacle, do not
                and #$80                        ;reverse/jump
                bne tmp_ok
tmp_turn2:      jsr tm_reverse_nofreemode
                jsr tma_clearab
                jmp tmp_ok
tmp_standing:   dec actattklen,x
                lda #$00
                sta actctrl,x
                rts

;-------------------------------------------------------------------------------
; SPARSEARCH state
;-------------------------------------------------------------------------------

tm_sparsearch:  rts

;                lda acttarget,x
;                clc
;                adc #$01
;                cmp #NUMCOMPLEXACT
;                bcc tm_ssok
;                lda #$00
;tm_ssok:        sta acttarget,x
;                tay
;                sta temp1
;                cpx temp1
;                beq tms_notfound
;                lda actt,y
;                beq tms_notfound
;                lda acthp,y
;                beq tms_notfound
;                lda actmode,y
;                cmp #M_SPAR
;                bne tms_nomode
;                txa
;                cmp acttarget,y
;                beq tms_targetok
;                bne tms_notfound
;tms_nomode:     cmp #M_SPARSEARCH               ;Must be willing to spar
;                bne tms_notfound
;tms_modeok:     jsr tma_checktgtroute
;                bcc tms_notfound
;tms_targetok:   lda #M_SPAR
;                sta actmode,x
;                sta actmode,y
;                txa
;                sta acttarget,y
;                rts
;tms_notfound:   jmp tm_patrol

;-------------------------------------------------------------------------------
; SPAR state
;-------------------------------------------------------------------------------

tm_spar:        rts

;                jsr tm_combat                   ;Sparring uses normal combat
;                lda actmode,x                   ;code, in addition ALERT
;                cmp #M_ALERT                    ;state must be converted to
;                bne tms_ok                      ;SPARSEARCH
;                lda #M_SPARSEARCH
;                sta actmode,x
;tms_ok:         rts

;-------------------------------------------------------------------------------
; COMBAT state
;-------------------------------------------------------------------------------

tmc_ducking:    ldy actwpn,x
                lda targetabsxdist              ;If target has escaped
                cmp wpn_npcmaxdist,y            ;weapon range and going away,
                bcc tmc_nottoofar               ;stand up
                jsr tmc_checktargetaway
                bpl tmc_duckstand
tmc_nottoofar:  jsr tmc_checktargetfiring
                bcs tmc_keepducked
                ldy actwpn,x
                lda targetabsxdist
                cmp wpn_npcmindist,y            ;If target is too close,
                bcc tmc_duckstand               ;must stand up
                lda targetabsydist              ;If target far above/below
                bne tmc_duckstand               ;must stand up
tmc_keepducked: lda #JOY_DOWN                   ;Otherwise, keep ducked
                sta actctrl,x
                lda targetxdist                 ;Face always target when
                sta actd,x                      ;ducked
                jsr random                      ;Attack while ducking?
                ldy #AD_DUCKEXITPROB
                cmp (actlptrlo),y
                bcs tmc_duckstand
                ldy #AD_DUCKATTACKPROB
                cmp (actlptrlo),y
                bcs tmc_duckdone
                jmp tmc_attacknofreemode
tmc_duckdone:   rts
tmc_duckstand:  lda #$00                        ;Release joystick
                sta actctrl,x
                rts

tm_combat:      lda actlastdmgact,x             ;Damage caused by an actor?
                bmi tmc_noreaction
                jsr random
                cmp #NEWTARGET_PROBABILITY
                bcs tmc_noreaction
                lda actlastdmgact,x
                sta acttarget,x                 ;Hate that actor!
                lda #$ff
                sta actlastdmgact,x
tmc_noreaction: lda actattklen,x
                beq tmc_newattack
                dec actattklen,x
                bne tmc_attackgoing
                lda #$00                        ;After attack, reset the
                sta actctrl,x                   ;joystick control
                jmp tmc_noduck2
tmc_attackgoing:rts
tmc_newattack:  lda actbits,x
                and #255-AB_AUTOTURN-AB_AUTOJUMP
                sta actbits,x
                lda targetactive                ;If target inactive, go back
                bne tmc_active                  ;to ALERT mode
tmc_gotoalert:  lda #$00
                sta actattklen,x
                lda #M_ALERT
                sta actmode,x
                rts

tmc_active:     inc actroutecheck,x
                lda actroutecheck,x
                ldy #AD_BOREDTIME               ;See if got bored
                cmp (actlptrlo),y
                bcc tmc_notbored
                jmp tmc_targetlost
tmc_notbored:   and #$07
                bne tmc_routedone               ;Time for routecheck?
                ldy acttarget,x
                jsr tma_checktgtroute
                bcc tmc_routedone
                lda #$00
                sta actroutecheck,x

tmc_routedone:  lda actctrl,x
                and #JOY_DOWN
                beq tmc_notducking
tmc_noduck2:    lda actbits,x                   ;NPC ducking?
                and #AB_DUCK
                beq tmc_notducking
                jmp tmc_ducking
tmc_notducking: ldy actwpn,x
                lda wpn_npcmaxdist,y            ;Is a melee weapon?
                ldy #AD_ATTACKPROB              ;(note: grenades and shurikens
                cmp #$03                        ;are "melee" weapons because
                bcs tmc_normalattack            ;of their throwing animation
                ldy #AD_MELEEPROB               ;but they're still ranged,
tmc_normalattack:                               ;that's why wpn_meleetbl is
                jsr random                      ;not used)
                cmp (actlptrlo),y
                bcs tmc_noattack
                lda actattkd,x                  ;Don't attack if there's
                bne tmc_donothing               ;still attack delay left
                beq tmc_attack                  ;in the weapon
tmc_noattack:   pha
                jsr tmc_checktargetfiring       ;Target firing increases
                pla                             ;chance of evasive action
                ldy #AD_DUCKPROB
                bcc tmc_notfiring
                iny
tmc_notfiring:  cmp (actlptrlo),y
                bcs tmc_duck
tmc_donothing:  jmp tm_goto2

tmc_duck:       lda actbits,x                   ;Do not duck if climbing
                and #AB_CLIMB
                bne tmc_noduck
                lda targetabsydist              ;Do not duck if target
                beq tmc_checkjump               ;far above/below
                bne tmc_noduck
tmc_nojump:     lda actcapbits                  ;Do not duck if can't
                and #ACB_DUCK
                beq tmc_noduck
                ldy actwpn,x
                lda targetabsxdist
                cmp wpn_npcmindist,y            ;Do not duck if target within
                bcc tmc_noduck                  ;the minimum distance
                cmp wpn_npcmaxdist,y            ;Do not duck if target beyond
                bcc tmc_duckok                  ;the maximum distance and
                jsr tmc_checktargetaway
                bpl tmc_noduck                  ;going away
tmc_duckok:     lda #JOY_DOWN
                sta actctrl,x
tmc_noduck:     rts
tmc_checkjump:  lda actcapbits                  ;Do not jump if can't
                and #ACB_JUMP
                beq tmc_nojump
                ldy #AD_JUMPPROB                ;Random chance for jump
                jsr random
                cmp (actlptrlo),y
                bcs tmc_nojump
                lda targetxdist                 ;Do not jump if not facing
                eor actsx,x                     ;target
                and #$80
                bne tmc_nojump
                lda targetabsxdist              ;Do not jump if ridiculously
                cmp #JUMPDISTTHRESHOLD          ;far away
                bcs tmc_nojump
tmc_cjspeedok:  jmp tm_jump

tmc_cancelattack3:
                jmp tmc_cancelattack
                
tmc_attack:     lda (actlptrlo),y
                lda acthomemode,x               ;This will turn the NPC
                cmp #HM_FREEDOWN                ;towards the target, if was
                bcc tmc_attacknofreemode        ;in free mode
                lda #HM_VERT
                sta acthomemode,x
tmc_attacknofreemode:
                lda actctrl,x
                sta temp4
                ldy actwpn,x
                lda wpn_npcattacktime,y
                sta actattklen,x

                lda actroutecheck,x             ;Cancel attack if no route
                cmp #$08                        ;to target
                bcs tmc_cancelattack3

                lda targetabsxdist
                cpy #ITEM_KATANA                ;Katana special case
                bne tmc_nokatana                ;at distance 1
                cmp #1
                bne tmc_nokatana
                lda actsx,x                     ;Moving towards target?
                beq tmc_cancel_checkturn
                eor targetxdist
                and #$80
                bne tmc_cancel_checkturn
                beq tmc_attacknofreemode2

tmc_nokatana:   cmp wpn_npcmaxdist,y
                bcs tmc_cancel_checkturn
                cmp wpn_npcmindist,y
                bcs tmc_attacknofreemode2
                jmp tmc_freemode
tmc_attacknofreemode2:
                lda targetxdist                 ;Target on left or right?
                asl
                lda #JOY_FIRE+JOY_RIGHT
                bcc tmc_attackdirok
                lda #JOY_FIRE+JOY_LEFT
tmc_attackdirok:sta actctrl,x
                lda wpn_meleetbl,y              ;A melee weapon?
                beq tmc_nomelee
                lda actbits,x                   ;Melee attacks are generally
                and #AB_CLIMB                   ;useless while climbing
                bne tmc_cancelattack
                lda wpn_npcmaxdist,y
                cmp #$03                        ;A throwing weapon?
                bcs tmc_nomelee                 ;Do not use melee code then
                lda targetydist                 ;Target must be close in Y-dir
                beq tmc_meleeok
                cmp #$ff
                bne tmc_cancelattack
tmc_meleeok:    lda targetycompare
                bne tmc_nomeleestraight
                ldy acttarget,x
                lda actbits,y
                and #AB_DUCK
                beq tmc_firestraightjmp
                jmp tmc_lowattack
tmc_firestraightjmp:jmp tmc_firestraight
tmc_nomeleestraight:                            ;Attack above or below
                bmi tmc_highattack2             ;if there's some Y-distance
                jmp tmc_lowattack               ;and weapon gives possibility
tmc_highattack2:jmp tmc_highattack
tmc_cancel_checkturn:
                lda actbits,x                   ;Never turn in ladders!!!
                and #AB_CLIMB
                bne tmc_cancelattack
                jsr random
                cmp #FARTURN_PROBABILITY
                bcs tmc_cancelattack
                lda targetxdist
                sta actd,x
                lda actcapbits                  ;Immobile enemies (turrets)
                bne tmc_cancelattack            ;fall back to ALERT
                jmp tmc_gotoalert
tmc_cancelattack:
                lda #$00
                sta actattklen,x
                lda temp4                       ;Restore old control
                sta actctrl,x
                rts
tmc_freemode:   lda actbits,x                   ;Don't change to free mode
                and #AB_CLIMB                   ;while on a ladder
                bne tmc_nofreemode
                lda targetydist                 ;No free mode if target far
                bne tmc_nofreemode              ;in Y-dir
                jsr random
                and #$01
                ora #HM_FREEDOWN
                sta acthomemode,x
tmc_nofreemode: jmp tm_goto2

tmc_nomelee:    ;lda actd,x                      ;Firing behind?
                ;eor targetxdist
                ;and #$80
                ;beq tmc_notbehind
                ;lda actbits,x                   ;and jumping at the same time?
                ;and #AB_JUMP
                ;bne tmc_cancelattack            ;Too evil, cancel

tmc_notbehind:  lda actreload,x                 ;No attacks while reloading
                bne tmc_cancelattack
                lda targetycompare
                bne tmc_notlevel
                lda actbits,x                   ;If on the same level with
                and #AB_JUMP                    ;target and jumping, should
                beq tmc_firestraight            ;attack downwards
                jmp tmc_lowattack
tmc_notlevel:   bmi tmc_firestraightorup
                jmp tmc_firedown

tmc_firestraightorup:
                lda actbits,x
                and #AB_DUCK
                beq tmc_straightorup_noboss
                lda actfb,x                     ;If is a ducking boss and target
                bpl tmc_straightorup_noboss     ;is above at the wpn. minimum
                lda targetabsxdist              ;distance, fire up
                cmp wpn_npcmindist,y
                beq tmc_fireup


tmc_straightorup_noboss:
                lda targetabsydist              ;Must be sufficiently high above
                beq tmc_firestraight

tmc_fireup:     ;cmp #$fc
                ;bcc tmc_cancelattack
                lda wpn_dirtbl,y
                lsr
                bcc tmc_cancelattack
                ldy acttarget,x
                lda actt,y                      ;Special case for the seekers
                cmp #ACT_SEEKER
                bne tmc_noseeker
                lda targetabsydist
                beq tmc_firestraight
tmc_noseeker:   lda actxh,y                     ;If target stands on obstacle,
                sta temp1                       ;do not fire up (looks silly)
                lda actyh,y
                sta temp2
                jsr tma_checkblockmiddle
                and #CI_OBSTACLE
                beq tmc_highattack
                jmp tmc_cancelattack
tm_setjoyup:
tmc_highattack: lda actctrl,x
                ora #JOY_UP
                sta actctrl,x
                rts

tmc_lowattackjump:jmp tmc_lowattack
tmc_firestraight:
                lda targetycompare              ;If target even slightly
                bmi tmc_noactortypechecks       ;above, skip these checks
                ldy acttarget,x
                lda actt,y
                cmp #ACT_SPIDERBOT              ;Fire down for the
                beq tmc_lowattackjump           ;spiderbot (short enemy)
                cmp #ACT_FLOORTURRET            ;Same for floor turret
                beq tmc_lowattackjump
                cmp #ACT_MUTANT1                ;and for the mutant
                beq tmc_lowattackjump
tmc_noactortypechecks:
                lda actyh,y
                cmp actyh,x
                bne tmc_firestraightok
                lda actyl,y                     ;If on the same block, but
                sbc actyl,x                     ;2 chars or more below,
                bcc tmc_firestraightok          ;fire down
                cmp #$80
                bcs tmc_lowattackjump
tmc_firestraightok:
                lda actbits,y                   ;If firing straight and player
                and #AB_DUCK                    ;has ducked, duck at a certain
                beq tmc_firestraight2           ;probability
                lda actbits,x
                and #AB_DUCK
                bne tmc_firestraight2
                lda actcapbits
                and #ACB_DUCK
                beq tmc_firestraight2
                jsr random
                ldy #AD_DUCKEVASIVEPROB                ;(at a certain probability)
                cmp (actlptrlo),y
                bcc tmc_firestraight2
                lda temp4
                ora #JOY_DOWN
                sta temp4
                jmp tmc_cancelattack
tmc_firestraight2:
                rts
tmc_firestraight3:
                ;lda actfb,x
                ;bpl tmc_firestraight2
                ;;lda targetycompare              ;Final check: (if not going
                ;bne tmc_firestraight2           ;to duck, only for bosses)
                ;ldy actwpn,x
                ;lda targetabsxdist              ;If target is level & exactly at
                ;cmp wpn_npcmindist,y            ;weapon minimum distance,
                ;beq tmc_lowattack               ;fire down
                ;rts

tmc_firedown:   ;cmp #$03
                ;bcs tmc_cancelattack2
                lda wpn_dirtbl,y
                lsr
                bcc tmc_cancelattack2
                lda actxh,x                     ;If actor stands on obstacle,
                sta temp1                       ;do not fire below (looks silly)
                lda actd,x
                bmi tmc_firedownleft
                inc temp1
                inc temp1                       ;(the obstacle must extend two
                bcs tmc_firedownok              ;blocks left/right, so ramps
tmc_firedownleft:                               ;don't affect this)
                dec temp1
                dec temp1
tmc_firedownok: lda actyh,x
                sta temp2
                jsr tma_checkblockmiddle
                and #CI_OBSTACLE
                bne tmc_cancelattack2
tmc_lowattack:
tmc_jumpattack: lda actctrl,x
                ora #JOY_DOWN
                sta actctrl,x
tmc_alldone:    rts
tmc_cancelattack2:
                jmp tmc_cancelattack

tmc_targetlost: jmp tmc_gotoalert

tmc_checktargetaway:
                ldy acttarget,x                 ;Check if target has turned
                lda actd,x                      ;away
                eor targetxdist
                rts

tmc_checktargetfiring:
                ldy acttarget,x
                lda actctrl,y
                and #JOY_FIRE+JOY_LEFT+JOY_RIGHT
                cmp #JOY_FIRE+1
                bcc tmc_cttdone
                clc
                lda actwpn,y                    ;Check firing within range
                tay
                lda wpn_meleetbl,y              ;If melee weapon, definitely
                bne tmc_cttdone                 ;*don't* duck!
                lda wpn_npcmaxdist,y
                cmp targetabsxdist
tmc_cttdone:    rts

;-------------------------------------------------------------------------------
; GOTO state
;-------------------------------------------------------------------------------

tm_jump:        lda actbits,x
                and #255-AB_LANDED-AB_AUTOTURN-AB_HITWALL-AB_AUTOTURNDONE
                sta actbits,x
                lda #JOY_JUMP
                ldy actd,x
                bmi tm_jumpleft
                ora #JOY_RIGHT
                jmp tm_jumpok
tm_jumpleft:    ora #JOY_LEFT
tm_jumpok:      sta actctrl,x
                rts

tm_goto2:       lda actbits,x
                and #AB_JUMP|AB_CLIMB
                beq tm_walk
                and #AB_JUMP
                bne tm_jump

tm_climb:       lda actmode,x                   ;Switch dir only in GOTO
                cmp #M_GOTO                     ;mode
                beq tm_newclimbdir
tm_climbnogoto: lda actctrl,x                   ;If joystick has been centered,
                and #JOY_UP|JOY_DOWN            ;have to find new dir
                bne tm_climbok2
                lda actclimbctrl,x
                and #JOY_UP|JOY_DOWN
                beq tm_newclimbdir
                sta actctrl,x
                rts
tm_newclimbdir: lda targetxdist                 ;Also turn towards target
                beq tm_climbnoturn
                sta actd,x
tm_climbnoturn: lda #JOY_UP
                ldy targetycompare
                beq tm_climbok2
                bmi tm_climbup
                lda #JOY_DOWN
tm_climbup:     sta actclimbctrl,x
                ldy targetydist
                iny                             ;Stop if close to target
                cpy #$02                        ;in goto mode and at the
                bcs tm_climbnotclose            ;same X-pos
                ldy actmode,x
                cpy #M_GOTO
                bne tm_climbnotclose
                ldy targetabsxdist
                bne tm_climbnotclose
                lda #$00
                sta actctrl,x
                rts
tm_climbnotclose:
                sta actctrl,x
tm_climbok2:    lda actctrl,x                   ;Make sure ladders will be
                and #255-JOY_RIGHT-JOY_LEFT     ;exited..
                ldy actmode,x
                cpy #M_SPAR                     ;..if in combat mode
                bcs tm_climbprepareexit
                ldy targetabsxdist              ;..if target has X-distance
                bne tm_climbprepareexit
                ldy targetabsydist              ;..or Y-distance is zero
                bne tm_climbok3
tm_climbprepareexit:
                ora #JOY_RIGHT
                ldy actd,x
                bpl tm_climbok3
                eor #JOY_RIGHT|JOY_LEFT
tm_climbok3:    sta actctrl,x
tm_climbok:     rts

tm_walk:        lda actxh,x
                cmp actlastladderxh,x
                beq tm_walkok
                lda #$ff
                sta actlastladderxh,x
tm_walkok:      lda actctrl,x
                and #255-JOY_UP-JOY_JUMP-JOY_DOWN
                sta actctrl,x
                ldy acthomemode,x
                bne tm_homein_nohoriz
                jmp tm_homein_horiz
tm_homein_nohoriz:
                cpy #HM_FREEDOWN
                bcc tm_homein_vert

tm_homein_free: lda actmode,x
                cmp #M_SPAR
                bcs tm_freenoexit
                lda targetxdist                 ;If reached target X-pos, exit
                beq tm_gotovert2                ;free mode
tm_freenoexit:  jsr random                      ;Random chance of exiting the
                cmp #EXITFREEMODEPROB           ;"free" mode back to vertical
                bcc tm_gotovert2                ;mode
                tya
                and #$01
                bne tm_up
                jmp tm_down
tm_gotovert2:   jmp tm_gotovert

tm_homein_vert: lda actbits,x                   ;If landed, turn to target
                and #AB_LANDED
                beq tm_notlanded
                lda actbits,x
                and #255-AB_LANDED
                sta actbits,x
                jmp tm_turntowardstarget
tm_notlanded:   lda targetxdist
                bmi tm_checktoofarleft
                cmp #8
                bcc tm_ctfok
                lda #$00
                sta actd,x
                beq tm_ctfok
tm_checktoofarleft:
                cmp #-9
                bcs tm_ctfok
                lda #$80
                sta actd,x
tm_ctfok:       lda targetycompare
                beq tm_exitvertmode
                bpl tm_down
tm_up:          jsr tm_setjoyup
                jsr getcharposinfo
                and #CI_STAIRS
                beq tm_upnostairs
                jsr turntoupstairs              ;Turn in stairs only if
tm_upnostairs:  lda actcapbits                  ;necessary
                and #ACB_CLIMB
                beq tm_upnoclimb
                lda #-4
                jsr getcharposinfooffset
                and #CI_CLIMB
                beq tm_upnoclimb
                lda actlastladderxh,x           ;Don't climb the same ladder
                cmp actxh,x                     ;twice without doing something
                beq tm_upnoclimb2               ;else meanwhile
                ;lda actmode,x                   ;In combat mode climbing doesn't
                ;cmp #M_SPAR                     ;happen always
                ;bcc tm_upnocombat
                ;jsr random
                ;cmp #CLIMBPROB
                ;bcs tm_upnoclimb2
tm_upnocombat:  lda #JOY_UP
                bne tm_climbstartcommon
tm_upnoclimb2:  lda actctrl,x
                and #255-JOY_UP
                sta actctrl,x
tm_upnoclimb:   jmp tm_moveforward
tm_exitvertmode:lda #HM_HORIZ
                sta acthomemode,x
                jmp tm_turntowardstarget
tm_down:        jsr getcharposinfo
                and #CI_STAIRS
                beq tm_downnostairs
                jsr turntodownstairs            ;Turn in stairs only if
tm_downnostairs:                                ;necessary
                lda actcapbits
                and #ACB_CLIMB
                beq tm_downnoclimb
                jsr getcharposinfo
                and #CI_CLIMB
                beq tm_downnoclimb
                lda actlastladderxh,x           ;Don't climb the same ladder
                cmp actxh,x                     ;twice without doing something
                beq tm_downnoclimb              ;else meanwhile
                ;lda actmode,x                   ;In combat mode climbing doesn't
                ;cmp #M_SPAR                     ;happen always
                ;bcc tm_downnocombat
                ;jsr random
                ;cmp #CLIMBPROB
                ;bcs tm_downnoclimb
tm_downnocombat:lda #JOY_DOWN
tm_climbstartcommon:
                sta actctrl,x
                sta actclimbctrl,x
                lda actxh,x
                sta actlastladderxh,x
                lda #HM_HORIZ
                sta acthomemode,x
                rts
tm_downnoclimb:
tm_moveforward: lda actd,x                      ;Go forward
                bmi tm_left
                bpl tm_right

tm_gotovert:    lda #HM_VERT
                sta acthomemode,x
tm_turntowardstarget:
                lda targetxdist
                sta actd,x
tm_reachedwaypoint:
                lda #$00
                sta actctrl,x
                rts

tm_homein_horiz:
                lda targetycompare
                bne tm_gotovert
                lda #$ff                        ;Apparently found the target, so
                sta actlastladderxh,x           ;reset the last ladder-check
                lda actmode,x                   ;Combat mode?
                cmp #M_SPAR
                bcc tm_horiznocombat
                lda targetxdist
                sta actd,x
                lda targetabsxdist
                bne tm_horiznofreemode
                jsr random                      ;Change to "free" homing mode
                and #$01                        ;if passed too close to the
                ora #HM_FREEDOWN                ;target in combat mode
                sta acthomemode,x
                jmp tm_checkfall

tm_horiznocombat:
                ldy acttarget,x                 ;Waypoint or actor?
                bpl tm_horiznowaypoint
                lda actxh,x
                cmp waypointxh-$80,y
                beq tm_reachedwaypoint
                lda targetxdist
                bmi tm_left
                bpl tm_right
tm_horiznowaypoint:
                lda #$02
                sta temp3
                lda actsy,y                     ;Actor on lift?
                cmp #$01
                bne tm_notatlift
                dec temp3                       ;Move then closer
tm_notatlift:   lda targetabsxdist
                cmp temp3
                bcc tm_turntowardstarget
tm_horiznofreemode:
                lda targetxdist
                bmi tm_left
tm_right:       lda actctrl,x
                and #255-JOY_LEFT
                ora #JOY_RIGHT
                sta actctrl,x
                jmp tm_checkfall
tm_left:        lda actctrl,x
                and #255-JOY_RIGHT
                ora #JOY_LEFT
                sta actctrl,x

tm_checkfall:   lda actbits,x                    ;By default use neither
                and #255-AB_AUTOJUMP-AB_AUTOTURN ;"automatic" mechanism
                sta actbits,x
                lda acthomemode,x               ;In free mode (patrolling, for
                cmp #HM_FREEDOWN                ;example) use autoturn
                bcs tm_cfreverse
                lda acthomemode,x               ;In free mode upwards, jump
                cmp #HM_FREEUP                  ;to prevent falling
                beq tm_cfjump

                lda targetxdist                 ;In other modes, turn if
                eor actd,x                      ;about to fall and going to
                and #$80                        ;wrong direction
                bne tm_cfreverse
                lda targetycompare              ;If going into the right
                bmi tm_cfjump
                beq tm_cfjump                   ;direction, either fall or jump
                bpl tm_nofall
tm_cfreverse:   lda actbits,x
                ora #AB_AUTOTURN
                bne tm_cfcommon
tm_cfjump:      lda actcapbits
                and #ACB_JUMP
                beq tm_cfreverse
                lda actbits,x
                ora #AB_AUTOJUMP
tm_cfcommon:    sta actbits,x
tm_nofall:      lda actbits,x                   ;Hit an obstacle or automatic
                sta temp1                       ;turning performed
                and #AB_HITWALL|AB_AUTOTURNDONE
                bne tm_cfobstacle
tm_cfdone:      rts
tm_cfobstacle:
                lda actbits,x
                and #255-AB_HITWALL-AB_AUTOTURNDONE
                sta actbits,x
                lda temp1
                and #AB_AUTOTURNDONE            ;If it was the autoturn, do not
                bne tm_cfmanualreverse          ;jump
                lda actd,x                      ;If actor has already turned
                eor acthitwalld,x               ;away from obstacle, do not
                and #$80                        ;reverse/jump
                bne tm_cfdone
                lda actcapbits
                and #ACB_JUMP                   ;If can't jump, have to reverse
                beq tm_cfmanualreverse          ;anyway

                ldy #1
                lda actd,x
                bpl tm_cfobstacleright
                ldy #-1
tm_cfobstacleright:
                lda #-4                         ;Check if there's a high
                jsr getcharposinfoxy            ;obstacle
                and #CI_OBSTACLE
                bne tm_cfmanualreverse
                lda #$00                        ;"Cheating": make sure the
                sta actprevctrl,x               ;jump starts correctly
                jmp tm_jump
tm_cfmanualreverse:
                lda acthomemode,x
                cmp #HM_HORIZ
                bne tm_reverse_nofreemode
                jsr random                      ;Change to "free" homing mode
                and #$01                        ;if was in horizontal mode
                ora #HM_FREEDOWN
                sta acthomemode,x
tm_reverse_nofreemode:
                jsr reverseactor                ;Hit a wall
                lda #$00
                sta actctrl,x
                rts

;-------------------------------------------------------------------------------
; GETTARGETDISTANCE
;
; Calculates signed & absolute distances of actors
;
; Parameters: X:Actor number, Y:Target
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

gettargetdistance:
                lda actxl,y                     ;Find out the distance to
                sec                             ;target
                sbc actxl,x
                lda actxh,y
                sbc actxh,x
                sta targetxdist
                bpl gtd_distok
                eor #$ff
gtd_distok:     sta targetabsxdist
                lda actyl,y
                sec
                sbc actyl,x
                lda actyh,y
                sbc actyh,x
                sta targetydist
                bpl gtd_distok2
                eor #$ff
gtd_distok2:    sta targetabsydist
es_noitem:      rts

;-------------------------------------------------------------------------------
; ENEMYSCORE
;
; Scoring for defeating the enemy
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y,temp1-temp3
;-------------------------------------------------------------------------------

enemyscore:     txa                             ;Player doesn't drop anything
                beq es_noitem
es_notplayer:   lda actt,x                      ;The comradeagent?
                cmp comradeagent
                bne es_nocomrade
                lda actlastdmghp,x              ;If only knocked out, do not
                bpl es_noitem                   ;drop weapon (will be needed!)
es_nocomrade:   lda actlastdmgact2,x            ;Player responsible?
                bne es_noplayer
                ldy #AD_TDSCORE+1               ;Increment score
                lda (actlptrlo),y
                sta temp1
                dey
                lda (actlptrlo),y
                ldy actlastdmghp,x              ;Using non-lethal methods?
                bmi es_lethaldmg
                asl                             ;Double score
                rol temp1
es_lethaldmg:   ldy temp1
                jsr addscore
es_noplayer:    ldy actwpn,x                    ;Did have a weapon?
                cpy #ITEM_FISTS+1               ;(fists aren't counted)
                bcc es_noitem
                lda actfb,x                     ;Robots/beasts don't drop
                and #AFB_HUMANOID               ;anything
                beq es_noitem
                lda itemaddtbl,y
                sta es_clip+1
es_nocheck:     ldy #ACTI_FIRSTITEM
                lda #ACTI_LASTITEM
                jsr getfreeactor
                bcs es_itemok
                stx es_restx+1
                ldx #ACTI_LASTITEM              ;Remove the last item and
                jsr removelevelactor            ;try again (this item might be
es_restx:       ldx #$00                        ;important, like a key or
                ldy #ACTI_LASTITEM              ;something)
es_itemok:      lda #ACT_ITEM
                jsr spawnactor
                lda #-8*8
                jsr spawnymod
                lda actwpn,x
                sta actf1,y
                cmp #ITEM_FIRST_NOTPURGEABLE    ;Unimportant?
                bcs es_notpurge
                lda #$80                        ;Set purgeable flag
                sta actpurgeable,y
es_notpurge:    lda #ENEMYITEMSPEED             ;Give substantial upwards speed
                sta actsy,y                     ;to the item
es_clip:        lda #$00
                sta acthp,y
                rts

;-------------------------------------------------------------------------------
; MAKENOISE
;
; Alerts NPCs to noise made by current actor.
;
; Parameters: A:Noise level (1-3)
;             X:Actor number (position is important)
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

makenoise:      cmp #$03                        ;Loud noise - alert all?
                bcs mn_alertall
                cmp #$02
                lda #NOISETHRESHOLD
                bcs mn_distok
                lda #NOISETHRESHOLD/2
mn_distok:      sta maptemp1
                ldy #NUMCOMPLEXACT-1
mn_alertloop:   lda actt,y
                beq mn_alertnext
                lda actgrp,y
                beq mn_alertnext                ;Don't alert same group
                bmi mn_alertnext
                cmp actgrp,x
                beq mn_alertnext
                lda actfb,y
                and #AFB_REACTNOISE
                beq mn_alertnext
                lda actmode,y
                cmp #M_ALERT
                bcs mn_alertnext
                jsr gettargetdistance
                clc
                adc targetabsxdist
mn_cmp:         cmp maptemp1
                bcs mn_alertnext
                lda #$00
                sta actattklen,y
                lda #M_ALERT
                sta actmode,y
mn_alertnext:   dey
                bpl mn_alertloop
mn_noalert:     rts

mn_alertall:    lda levelalert                  ;Loud noise increases level
                adc #LEVELALERT_MOD-1           ;alertness, for a while
                cmp #LEVELALERT_MAX
                bcs mn_alertok
                lda #LEVELALERT_MAX
mn_alertok:     sta levelalert
                lda #$ff
                bne mn_distok

randomcomplexact:
                jsr random
                and #$07
                if NUMCOMPLEXACT<8
                cmp #NUMCOMPLEXACT
                bcs randomcomplexact
                endif
                rts

