HP_INVINCIBLE   = $fe

DIR_STRAIGHT    = 0                               ;Attack directions
DIR_UP          = 1
DIR_DOWN        = 2

GRENADE_BRAKE   = 6                               ;Some constants for certain
GRENADE_RADIUS  = 2                               ;actor move routines
SHURIKEN_HITWALLTIME = 5
SHRAPNEL_COUNT  = 3

DMG_LETHAL      = $80                             ;Lethal damage
DMG_SPECIAL     = $f0                             ;Conditional/continuous damage

ITEM_NONE               = 0
ITEM_FISTS              = 1
ITEM_BATON              = 2
ITEM_KNIFE              = 3
ITEM_KATANA             = 4
ITEM_SHURIKEN           = 5
ITEM_FRAG_GRENADE       = 6
ITEM_PARASITE           = 7
ITEM_DARTGUN            = 8
ITEM_ELECTRONIC_STUN_GUN = 9
ITEM_9MM_PISTOL         = 10
ITEM_9MM_SILENCED_PISTOL = 11
ITEM_9MM_SUBMACHINEGUN  = 12
ITEM_44_MAGNUM_PISTOL   = 13
ITEM_SHOTGUN            = 14
ITEM_AUTO_SHOTGUN       = 15
ITEM_556_ASSAULT_RIFLE  = 16
ITEM_556_MACHINE_GUN    = 17
ITEM_762_SNIPER_RIFLE   = 18
ITEM_LASER_RIFLE        = 19
ITEM_FLAME_THROWER      = 20
ITEM_MISSILE_LAUNCHER   = 21
ITEM_GASFIST_MK2        = 22
ITEM_PSIONIC_RIFLE      = 23

ITEM_FIRST_NONWEAPON    = ITEM_DARTS

ITEM_DARTS              = 24
ITEM_9MM_AMMO           = 25
ITEM_44MAGNUM_AMMO      = 26
ITEM_12GAUGE_AMMO       = 27
ITEM_556_AMMO           = 28
ITEM_762_AMMO           = 29
ITEM_FUEL               = 30
ITEM_MISSILES           = 31
ITEM_CHARGE_CELLS       = 32
ITEM_PLUTONIUM          = 33
ITEM_MEDIKIT            = 34
ITEM_BATTERY            = 35
ITEM_BEER               = 36
ITEM_CREDITS            = 37

ITEM_FIRST_NOTPURGEABLE = ITEM_VITALITY_ENHANCEMENT ;"Important" / unique items start from here

ITEM_VITALITY_ENHANCEMENT = 38
ITEM_STRENGTH_ENHANCEMENT = 39
ITEM_BETA_ARMORSYSTEM   = 40
ITEM_GAMMA_ARMORSYSTEM  = 41
ITEM_DELTA_ARMORSYSTEM  = 42
ITEM_EPSILON_ARMORSYSTEM = 43
ITEM_AGENT_GEAR = 44
ITEM_MAINTENANCE_ACCESS = 45
ITEM_BASEMENT_ACCESS = 46
ITEM_ARMORY_ACCESS = 47
ITEM_TRAIN_ACCESS = 48
ITEM_CELL_ACCESS = 49
ITEM_SECURITY_ACCESS = 50 ;Suhrim's office
ITEM_LIFT_ACCESS = 51 ;Mansion lift
ITEM_REACTOR_ACCESS = 52 ;IAC facility reactor
ITEM_TELEPORT_ACCESS = 53 ;Teleport to central facility
ITEM_CODESHEET1 = 54
ITEM_CODESHEET2 = 55
ITEM_CODESHEET3 = 56
ITEM_CODESHEET4 = 57
ITEM_GENERATOR_ACCESS = 58 ;Final facility generator
ITEM_LEVER = 59         ;Missing lever to access Sentinel Temple
ITEM_CRYSTAL = 60       ;Triangular crystal to summon the Sentinels :)
ITEM_LETTER = 61        ;Mad Locust's letter in Erehwon cell
ITEM_FAKEAGENTGEAR = 62

BLT_FISTHIT     = 0
BLT_KNIFEHIT    = 1
BLT_KATANAHIT   = 2
BLT_BATONHIT    = 3
BLT_SHURIKEN    = 4
BLT_DART        = 5
BLT_GRENADE     = 6
BLT_PISTOL      = 7
BLT_SMG         = 8
BLT_SHOTGUN1    = 9
BLT_SHOTGUN2    = 10
BLT_AR          = 11
BLT_ASHOTGUN1   = 12
BLT_ASHOTGUN2   = 13
BLT_MG          = 14
BLT_SNIPER      = 15
BLT_LASER       = 16
BLT_FLAME       = 17
BLT_ELECTRICITY = 18
BLT_PLASMA      = 19
BLT_MISSILE     = 20
BLT_PSIONIC      = 21
BLT_PARASITE    = 22
BLT_STEALTHPISTOL = 23

SPDMG_DARTS     = 0
SPDMG_FLAME     = 1
SPDMG_TASER     = 2
SPDMG_PSIONIC    = 3
SPDMG_PARASITE  = 4

DMG_DART        = SPDMG_DARTS+DMG_SPECIAL
DMG_FLAME       = SPDMG_FLAME+DMG_SPECIAL
DMG_TASER       = SPDMG_TASER+DMG_SPECIAL
DMG_PSIONIC     = SPDMG_PSIONIC+DMG_SPECIAL
DMG_PARASITE    = SPDMG_PARASITE+DMG_SPECIAL
DMG_FISTS       = 4
DMG_KNIFE       = 6+DMG_LETHAL
DMG_BATON       = 7
DMG_9MMSUPPR    = 8+DMG_LETHAL
DMG_9MM         = 8+DMG_LETHAL
DMG_9MMAUTO     = 5+DMG_LETHAL
DMG_SHOTGUNMIN  = 5+DMG_LETHAL
DMG_AUTOSHOTGUN = 7+DMG_LETHAL  ;x2 (14)
DMG_SHOTGUN     = 9+DMG_LETHAL  ;x2 (18)
DMG_SHURIKEN    = 8+DMG_LETHAL
DMG_556MACHINEGUN = 7+DMG_LETHAL
DMG_556RIFLE    = 8+DMG_LETHAL
DMG_LASER       = 10+DMG_LETHAL
DMG_44MAGNUM    = 12+DMG_LETHAL
DMG_KATANA      = 12+DMG_LETHAL
DMG_GASFIST     = 16+DMG_LETHAL
DMG_762SNIPER   = 20+DMG_LETHAL
DMG_ROBOTKATANA = 20+DMG_LETHAL
DMG_GRENADE     = 30+DMG_LETHAL
DMG_SEEKER      = 40+DMG_LETHAL
DMG_MISSILE     = 40+DMG_LETHAL

WF_PISTOL       = 0
WF_SMG          = 3
WF_KNIFE        = 6
WF_KATANA       = 8
WF_FLAMETHR     = 13
WF_BATON        = 16
WF_SHOTGUN      = 20
WF_MISSILE      = 23
WF_SNIPER       = 26
WF_AR           = 29
WF_ASHOTGUN     = 29
WF_MG           = 32
WF_GASFIST      = 35
WF_PSIONIC      = 38
WF_DARTGUN      = 41
WF_NONE         = $7f

WD_DIRECTIONAL  = 1
WD_FROMHIP      = $80
WD_LOCKANIM     = $40


;-------------------------------------------------------------------------------
; ATTACK
;
; General attack routine for actors
;
; Parameters: X:Actor number
;             A:Direction (0=straight 1=up 2=down)
;             actwpn:weapon number
; Returns: C=1 attack successful
; Modifies: A,Y,temp1-7
;-------------------------------------------------------------------------------

attack:         sta attk_dir+1
                ldy #ACTI_FIRSTPLRBLT
                lda #ACTI_LASTPLRBLT+1
                cpx #ACTI_PLAYER                ;Player actor?
                beq cfb_player
                ldy #ACTI_FIRSTNPCBLT
                lda #ACTI_LASTNPCBLT+1
cfb_player:     sta cfb_cmp+1
                lda #$00
                sta temp1
cfb_loop:       lda actt,y                      ;Count free bullets
                bne cfb_next
                inc temp1
cfb_next:       iny
cfb_cmp:        cpy #$00
                bcc cfb_loop
                lda temp1
                beq attk_cancel                 ;Never perform an attack
                ldy actwpn,x                    ;where all bullets can't be
                cmp wpn_amounttbl,y             ;activated
                bcs attk_bulletsok
attk_cancel:    clc
                rts
attk_bulletsok: stx temp1                       ;Store actor number
                lda wpn_meleetbl,y
                sta attk_plrmeleecmp+1
                lda wpn_firstblttbl,y           ;Take the number of the first
                sta temp2                       ;bullet in the bullet table
                lda wpn_delaytbl,y              ;Attack delay
                sta actattkd,x
                lda wpn_dmgtbl,y                ;Melee bonus for player?
                cmp #DMG_SPECIAL                ;Not if using special damage
                bcs attk_nodmgmod
                cpx #ACTI_PLAYER
                bne attk_nodmgmod
attk_plrmeleecmp:
                ldy #$00
                beq attk_nodmgmod
                cmp #DMG_GRENADE                ;No bonus for grenade damage :)
                bcs attk_nodmgmod
                asl                             ;Store lethal bit
                php
attk_plrmeleemod:
                ldy #$00
                jsr punish_dmgmod
                plp
                ror                             ;Restore lethal bit
attk_nodmgmod:  sta attk_bltdmg+1
                ldy actwpn,x
                lda wpn_sfxtbl,y
                sta attk_soundnum+1
                lda wpn_noisetbl,y
                beq attk_nonoise
                jsr makenoise
attk_nonoise:   ldy #AD_ATTACKXMOD
                lda (actlptrlo),y               ;X-mod can't be larger than
                asl                             ;32 pixels
                asl
                asl
                sta attackxmod
                ldy #AD_ATTACKYMOD
                lda actbits,x                     ;Ducking?
                and #AB_DUCK
                beq attk_noduck
                ldy #AD_ATTACKYMODDUCK
attk_noduck:    lda #$00
                sta temp5
                lda (actlptrlo),y                  ;The Y-modification
                bpl attk_ymodpos
                dec temp5
attk_ymodpos:   asl
                rol temp5
                asl
                rol temp5
                asl
                rol temp5
                sta temp4
attk_bltloop:   ldy #ACTI_FIRSTPLRBLT
                lda #ACTI_LASTPLRBLT
                cpx #ACTI_PLAYER                ;Player actor?
                beq gfb_player
                ldy #ACTI_FIRSTNPCBLT
                lda #ACTI_LASTNPCBLT
gfb_player:     jsr getfreeactor                ;This always succeeds
                sty temp3                       ;Store bullet actor number
                txa                             ;Bullet's origin actor
                sta actorg,y
                lda actgrp,x                    ;Copy group
                sta actgrp,y
                lda actyl,x                     ;Copy & modify Y-coord
                sec
                sbc temp4
                sta temp6
                lda actyh,x
                sbc temp5
                sta temp7
                lda actd,x
                sta actd,y                      ;Copy direction
                bmi attk_bltxcopyleft
                lda actxl,x                     ;Copy X-coord
                clc
                adc attackxmod
                sta actxl,y
                lda actxh,x
                adc #$00
                sta actxh,y
                jmp attk_bltxcopydone
attk_bltxcopyleft:
                lda actxl,x                     ;Copy X-coord
                sec
                sbc attackxmod
                sta actxl,y
                lda actxh,x
                sbc #$00
                sta actxh,y
attk_bltxcopydone:
                tya
                tax
                ldy temp2
                lda blt_ymodtbllo,y
                pha
                clc                      ;Then perform the bullet's
                                             ;own Y-modification
                adc temp6
                sta actyl,x
                pla
                and #$80
                beq attk_ymodpos2
                ora #$7f
attk_ymodpos2:  adc temp7
                sta actyh,x
                lda actd,x                      ;And own X-modification
                bmi attk_bltmodleft
attk_bltmodright:
                lda actxl,x
                clc
                adc blt_xmodtbllo,y
                sta actxl,x
                lda actxh,x
                adc blt_xmodtblhi,y
                sta actxh,x
                lda blt_xspdtbl,y
                sta actsx,x
                jmp attk_bltmoddone
attk_bltmodleft:lda actxl,x
                sec
                sbc blt_xmodtbllo,y
                sta actxl,x
                lda actxh,x
                sbc blt_xmodtblhi,y
                sta actxh,x
                lda blt_xspdtbl,y
                jsr negate
                sta actsx,x
attk_bltmoddone:lda blt_actortbl,y              ;Actor type
                sta actt,x
attk_bltdmg:    lda #$00                        ;Damage
                sta acthp,x
                lda blt_timetbl,y               ;Duration
                sta acttime,x
                lda blt_removetbl,y             ;Remove flag
                sta actbits,x
attk_dir:       lda #DIR_STRAIGHT               ;Direction
                beq attk_bltstraight
                cmp #DIR_DOWN
                lda blt_yaimmodtbl,y
                bcs attk_bltdown
attk_bltup:     jsr negate
                jsr moveactorydirect
                lda blt_yaimfrtbl,y
                beq attk_bltupnoframe
                lda #DIR_UP
                sta actf1,x
attk_bltupnoframe:
                lda blt_yspdtbl,y
                sec
                sbc blt_yaimspdtbl,y
                jmp attk_bltyspddone
attk_bltstraight:
                lda blt_yspdtbl,y
                jmp attk_bltyspddone
attk_bltdown:   jsr moveactorydirect
                lda blt_yaimfrtbl,y
                beq attk_bltdownnoframe
                lda #DIR_DOWN
                sta actf1,x
attk_bltdownnoframe:
                lda blt_yspdtbl,y
                clc
                adc blt_yaimspdtbl,y
attk_bltyspddone:
                sta actsy,x
                lda #$ff
                sta actfd,x
                jsr getcharposinfo
                and #CI_OBSTACLE
                bne attk_bltinwall
                ldy temp2
                lda blt_nexttbl,y               ;Next bullet?
                beq attk_done
                sta temp2
                ldx temp1
                jmp attk_bltloop
attk_done:      ldx temp1
attk_soundnum:  lda #$00
                jsr playsfx
                sec
                rts
attk_bltinwall: jsr removeactor
                ldx temp1
                clc
                rts

;-------------------------------------------------------------------------------
; ATTACK_SIMPLE
;
; Attack handling of nonhuman actor (typically, gun turret or something)
; Doesn't reload or animate!
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y,temp1-7
;-------------------------------------------------------------------------------

attack_simple:  lda actattkd,x
                beq as_ok
                dec actattkd,x
as_nofire:      rts
as_ok:          lda actctrl,x
                and #JOY_FIRE
                beq as_nofire
                lda actctrl,x
                and #JOY_LEFT|JOY_RIGHT
                beq as_nofire
                and #JOY_LEFT
                beq as_notleft
                lda #$80
as_notleft:     sta actd,x
                ldy actwpn,x
                lda wpn_dirtbl,y
                ldy #$00
                lsr
                bcc as_straight
                lda actctrl,x
                and #JOY_UP|JOY_DOWN
                beq as_straight
                iny
                lda actctrl,x
                and #JOY_DOWN
                beq as_straight
                iny
as_straight:    tya
                jmp attack

;-------------------------------------------------------------------------------
; ATTACK_HUMAN
;
; Attack handling of a human actor
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y,temp1-7
;-------------------------------------------------------------------------------

ah_npcreload:   lda wpn_reloadtime1,y
                sta actattkd,x
                lda wpn_reloadsnd1,y            ;Play reload startsound
                jsr playsfx
                lda actclip,x
                clc
                adc wpn_reloadamount,y
                bcs ah_npcreloadover
                cmp itemmaxtbl,y
                bcc ah_npcreloadnotover
ah_npcreloadover:
                lda itemmaxtbl,y
ah_npcreloadnotover:
                sta actclip,x
                jmp ah_npcreloaddone

ah_autoreload:  lda temp1
                jsr finditem                    ;Try to find bullets
                bcs ah_ammofound                ;Bullets not found
ah_limitedammo: ldy #$01                        ;Ammocheat 0 = cheat on
                beq ah_maxammo
                jmp ah_noreload3
ah_ammofound:   lda invcounthi,y
                bne ah_maxammo
                lda invcountlo,y
                jmp ah_ammoready
ah_maxammo:     lda #255                        ;Maximum ammo that can be
ah_ammoready:   sty temp4                       ;loaded
                ldy actwpn,x
                pha
                lda wpn_reloadtime1,y
                sta actattkd,x
                lda wpn_reloadsnd1,y            ;Play reload startsound
                jsr playsfx
                pla
                cmp wpn_reloadamount,y
                bcc ah_ammoready2
                lda wpn_reloadamount,y
ah_ammoready2:  ldy invselect
                jsr addammo                     ;Add ammo to current item
                ldy temp4
                beq ah_npcreloaddone
                jsr decreaseammo                ;Decrease the ammo reserve
ah_npcreloaddone:lda #$01                       ;Reloading active
                sta actreload,x
                jmp ah_noattack2

ah_handlereload:sta temp1
                lda itemmaxtbl,y
                sta temp2
                cpx #ACTI_PLAYER
                beq ah_plrreload
                lda actclip,x
                beq ah_npcreload2
                cmp temp2                       ;Clip full?
                bcs ah_noreload3
                lda actreload,x
                beq ah_noreload
ah_npcreload2:  jmp ah_npcreload
ah_plrreload:   lda actclip,x                   ;Out of ammo?
                beq ah_autoreload
                cmp temp2                       ;Clip full?
                bcs ah_noreload3
                lda actreload,x                 ;Continued auto-reload?
                beq ah_nocontinue               ;(shotgun)
                lda actctrl,x                   ;If fire+dir held down, break
                and #JOY_FIRE                   ;auto-reload to be able to
                beq ah_autoreload               ;fire
                lda actctrl,x
                and #JOY_LEFT|JOY_RIGHT
                bne ah_noreload4
                jmp ah_autoreload
ah_nocontinue:  jsr checkjoydown
                bne ah_noreload2
                jmp ah_autoreload
ah_noreload3:   lda actreload,x
                beq ah_noreload2
                ldy actwpn,x                    ;Play reload endsound
                lda wpn_reloadtime2,y
                sta actattkd,x
                lda wpn_reloadsnd2,y
                jsr playsfx
ah_noreload4:   lda #$00
                sta actreload,x
ah_noreload2:   ldy actwpn,x
ah_noreload:    jmp ah_ok

attack_human:   cpx #ACTI_PLAYER
                bne ah_notplayer
                ldy invselect                   ;Update weapon & ammo from
                lda levelnum
                cmp #24                         ;Sentinel level?
                beq ah_sentinellevel            ;No guns :)
                lda invcountlo,y                ;the inventory
                sta actclip,x
                lda invtype,y
                cmp #ITEM_FIRST_NONWEAPON
                bcc ah_wpnok
ah_sentinellevel:
                lda #$00
ah_wpnok:       sta actwpn,x
                jmp ah_modeok
ah_notplayer:   lda actmode,x                   ;Don't show weapon when
                cmp #M_SIT                      ;sitting
                bne ah_modeok
                jmp ah_noweap
ah_modeok:      lda actd,x                      ;Save original direction
                sta attackolddir
                jsr ah_convertdir
                ldy actwpn,x
                lda itemammotbl,y
                sta ammotype
                lda actattkd,x                  ;Decrement attack delay as
                bne ah_delay                    ;necessary
ah_nodelay:     lda ammotype                    ;Check if weapon can be reloaded
                beq ah_ok
                bmi ah_ok
                jmp ah_handlereload
ah_delay:       dec actattkd,x
ah_ok:          tya                             ;Get actor weapon number
                bne ah_ok2
ah_noweap:      lda #WF_NONE                    ;No weapon
                sta actwf,x
                rts
ah_ok2:         lda actreload,x                 ;No attack while reloading
                bne ah_noattack                 ;(so that reload animation
                                                ;stays)
                lda actctrl,x
                and #JOY_FIRE
                beq ah_noattack
                lda actctrl,x
                and #JOY_LEFT|JOY_RIGHT
                cmp #JOY_RIGHT
                beq ah_attackright
                cmp #JOY_LEFT
                bne ah_noattack
ah_attackleft:  lda #$80
                bne ah_attackdirdone
ah_attackright: lda #$00
ah_attackdirdone:
                sta actd,x
                jsr ah_convertdir
                lda wpn_meleetbl,y              ;A melee weapon?
                bne ah_melee
                jmp ah_firearm
ah_melee:       lda actattkd,x
                bmi ah_nonewmelee
                beq ah_newmelee
                jsr ah_restoreolddir
                jmp ah_noattack
ah_newmelee:    lda #$83                        ;Initiate new melee attack
                sta actattkd,x
ah_nonewmelee:  cmp #$81                        ;Spawn the melee "bullet" now
                bcc ah_meleeattack
                beq ah_meleeattackbefore        ;Show the "strike frame", but
                                                ;don't attack yet
ah_nomeleestrike:
                lda wpn_meleetbl,y              ;Else, show the "prepare to
                clc                             ;strike" frame
                adc #PLRFR_MELEE-1
                sta actf2,x
                lda wpn_prepfrtbl,y
                adc temp6                       ;Add dir to weapon frame
                sta actwf,x
                jmp ah_fireskip
ah_meleeattack: lda #$00
                sta actattkd,x
ah_meleeattackbefore:
                jmp ah_firearm

ah_noattack2:   ldy actwpn,x
ah_noattack:    lda actattkd,x                  ;Abort melee attack
                bpl ah_nomeleeabort             ;Punish this by giving the
                lda wpn_delaytbl,y              ;normal weapon delay :)
                sta actattkd,x
ah_nomeleeabort:lda wpn_idlefrtbl,y             ;No attack - display idle
                ldy actreload,x                 ;weapon frame
                beq ah_noreloadanim
                ldy actwpn,x
                lda wpn_prepfrtbl,y
ah_noreloadanim:clc
                adc temp6
                sta actwf,x
                lda actf1,x
                cmp #PLRFR_CLIMB                ;While climbing, don't show
                bcc ah_noclimb                  ;the weapon
ah_resetanim:   lda #WF_NONE
                sta actwf,x
                lda actf1,x
                sta actf2,x
ah_animok:      rts
ah_noclimb:     ldy actwpn,x
                lda wpn_dirtbl,y                ;Lock animation?
                and #WD_LOCKANIM                ;(flamethrower)
                beq ah_animok
                lda #PLRFR_SHOOTHIP
                sta actf2,x
                rts

ah_firearm:     lda actwf,x
                sta oldwf
                lda wpn_dirtbl,y                ;Does weapon have dirs?
                lsr
                bcc ah_firestraight             ;No, fire always straight
                lda actctrl,x
                and #JOY_UP|JOY_DOWN
                beq ah_firestraight
                lda actctrl,x
                and #JOY_UP
                beq ah_firedown
ah_fireup:      lda #DIR_UP
                sta temp7
                lda #PLRFR_AIM+DIR_UP
                sta actf2,x
                lda wpn_upfrtbl,y
                jmp ah_firecommon
ah_firedown:    lda #DIR_DOWN
                sta temp7
                lda #PLRFR_AIM+DIR_DOWN
                sta actf2,x
                lda wpn_downfrtbl,y
                jmp ah_firecommon
ah_firestraight:lda #DIR_STRAIGHT
                sta temp7
                lda #PLRFR_AIM
                sta actf2,x
                lda wpn_attkfrtbl,y
ah_firecommon:  clc
                adc temp6                       ;Add dir to weapon frame
                sta actwf,x
                lda wpn_dirtbl,y                ;Fired from hip?
                bpl ah_notfromhip               ;(Infernal Machinegun)
                lda actf2,x
                adc #$03
                sta actf2,x
ah_notfromhip:  lda actattkd,x                  ;Ready to fire?
                ora actreload,x
                bne ah_fireskip
                lda ammotype                    ;Weapon uses ammo?
                bmi ah_noammocheck
                lda actclip,x
                beq ah_fireskip
                lda temp7
                jsr attack
                bcc ah_fireskip
                cpx #ACTI_PLAYER                ;If player, decrease inventory
                bne ah_noinvdec
                ldy invselect
                lda #$01
                jsr decreaseammo
                jmp ah_attackdone
ah_noinvdec:    lda ammotype                    ;Grenades/shuriken etc.
                beq ah_noclipdec                ;unlimited for NPCs
                dec actclip,x
ah_noclipdec:   jmp ah_attackdone

ah_noammocheck: lda temp7
                jsr attack
                bcc ah_fireskip                 ;Successful firing?
ah_attackdone:  ldy actwpn,x                    ;Does the weapon have a
ah_fireskip:    lda attackolddir                ;Was the attack backwards?
                eor actd,x
                bpl ah_notbackwards
                lda actf2,x
                clc
                adc #$08
                sta actf2,x
ah_restoreolddir:
                lda attackolddir
                sta actd,x

ah_convertdir:  and #$80
                sta temp6                       ;Convert direction to $00,$80
ah_notbackwards:rts

;-------------------------------------------------------------------------------
; CHECKJOYDOWN
;
; Checks if player has pressed FIRE+DOWN (use item & reload weapon)
;
; Parameters:
; Returns: Z=1 has pressed, Z=0 has not
; Modifies: A,Y
;-------------------------------------------------------------------------------

checkjoydown:   lda actprevctrl+ACTI_PLAYER
                and #JOY_FIRE|JOY_DOWN|JOY_LEFT|JOY_RIGHT
                cmp #JOY_FIRE
                bne cjd_not
                lda actctrl+ACTI_PLAYER
                and #JOY_FIRE|JOY_DOWN|JOY_LEFT|JOY_RIGHT
                cmp #JOY_FIRE|JOY_DOWN
mp_nocoll:
cjd_not:        rts

;-------------------------------------------------------------------------------
; MOVE_PARASITE
;
; Parasite movement
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_parasite:  lda actf1,x
                eor #$01
                sta actf1,x
                jsr checkjumpobst
                bcc mp_noreverse
                jsr reversexspeed
                sta actsx,x
mp_noreverse:   lda actsy,x
                sta temp1
                lda #GRAVITY_ACCEL
                ldy #MAX_Y_SPEED
                jsr accactory
                jsr moveactory
                jsr checklanding
                bcc mp_nolanding
                jsr random
                and #$03
                bne mp_nolanding
mp_jumphigh:    lda #SFX_PARASITE
                jsr playsfx
                lda #-6*8
                sta actsy,x
mp_nolanding:   dec acttime,x
                beq mp_disappear
                lda #$00
                sta actbits,x
                jsr checkbulletcoll
                bcc mp_nocoll
                jmp cbc_punish
mp_disappear:   lda #ACT_SMOKECLOUD
                jsr mblt_transform
                lda #SFX_DAMAGE
                jmp playsfx

;-------------------------------------------------------------------------------
; MOVE_GRENADE
;
; Grenade & item movement
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_item:      lda #$00
                sta actfls,x
                jsr removecheck

mgrn_movecommon:
                jsr checkjumpobst
                bcc mgrn_noreverse
                ldy #$01
                jsr reversexspeed
                jsr asr
                sta actsx,x
mgrn_noreverse: jsr moveactory
                lda actsy,x
                sta temp1
                bmi mgrn_checkceiling
                ldy #AD_AIJUMP+1                ;If has AI, no bouncing
                lda (actlptrlo),y               ;(human bodies)
                bne mgrn_nobounce
                lda #CI_GROUND|CI_SHELF
                jsr checklandingspecial
                bcc mgrn_nolanding

                lda actt,x                      ;Make enemies scared of
                cmp #ACT_GRENADE                ;bouncing grenade
                bne mgrn_noalert
                lda #NOISE_MODERATE
                jsr makenoise
mgrn_noalert:

                lda temp1                       ;Bounce upwards
                lsr
                eor #$ff
                clc
                adc #GRAVITY_ACCEL/2+1
                bpl mgrn_onground
                sta actsy,x
                lda #$00                        ;Clear landing bit
                sta actbits,x
                ldy #$01
                lda actsx,x                     ;Halve speed
                jsr asr
                sta actsx,x
                lda #-1                       ;Lift off the ground
                jmp moveactorydirect
mgrn_onground:  lda #GRENADE_BRAKE              ;Brake grenade on ground
                jmp brakeactorx
mgrn_checkceiling:
                lda #-1
                jsr getcharposinfooffset
                clc
                and #CI_OBSTACLE
                beq mgrn_nolanding
                lda #$00
                sta actsy,x
mgrn_nolanding: cpx #NUMCOMPLEXACT
                bcs mgrn_stdaccel
                lda actcapbits                  ;For flying actors,
                and #ACB_FLY                    ;use its own acceleration
                beq mgrn_stdaccel
                ldy #AD_CLIMBSPEED
                lda (actlptrlo),y
                bne mgrn_accelok
mgrn_stdaccel:  lda #GRAVITY_ACCEL
mgrn_accelok:   ldy #MAX_Y_SPEED
                jmp accactory

move_grenade:   jsr checkbulletcoll             ;Explode grenade if it
                bcs mgrn_explode                ;hits someone
                dec acttime,x
                beq mgrn_explode
                jmp mgrn_movecommon


mgrn_nobounce:  jsr checklanding
                bcc mgrn_nolanding
                rts

mgrn_explode:   lda #GRENADE_RADIUS
mgrn_explodecommon:
                jsr areaeffect                  ;Area damage
mgrn_explodecommonnodmg:
                lda #SFX_EXPLOSION
                jsr playsfx
mgrn_shrapnel:  lda #NOISE_LOUD
                jsr makenoise
                lda #SHRAPNEL_COUNT             ;Shrapnel counter
                sta temp1
mgrn_sloop:     jsr makeshrapnel
                dec temp1
                bne mgrn_sloop
mgrn_sdone:     lda #ACT_EXPLOSION
                jmp mblt_transform

makeshrapnel:   ldy #ACTI_FIRSTPLRBLT+2
                lda #ACTI_LASTNPCBLT
                jsr getfreeactor
                bcc msquit
                lda #ACT_SHRAPNEL
                jsr spawnactor
                jsr random
                and #$3f
                sec
                sbc #$50
                sta actsy,y
                jsr random
                and #$7f                        ;Random X-speed
                sec
                sbc #$40
                sta actsx,y
msquit:         rts


;-------------------------------------------------------------------------------
; MOVE_SHURIKEN
;
; Shuriken movement
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_shuriken:  lda acthp,x                             ;Collided?
                bne mshr_flight
                jsr mgrn_nolanding
                jmp mshr_ok2

mshr_flight:    jsr getcharposinfo
                and #CI_OBSTACLE
                beq mshr_ok
mshr_hitwall:   lda #$00
                sta acthp,x
                lda #SHURIKEN_HITWALLTIME
                sta acttime,x
                jsr random
                and #$1f                        ;Random upwards Y-speed
                ora #$e0
                sta actsy,x
                ldy #$02
                jsr reversexspeed
                jsr asr
                sta actsx,x
mshr_ok:        jsr checkbulletcoll
                bcs mshr_punish
mshr_ok2:       dec acttime,x                           ;Bullet duration
                beq mblt_disappear
                jsr moveactorx
                jmp moveactory
mshr_done:      rts
mshr_punish:    jmp cbc_punish

;-------------------------------------------------------------------------------
; MOVE_MELEEHIT
;
; "Virtual" melee bullet. Very minimal "move-routine" :)
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_meleehit:  jsr checkbulletcoll
                bcs mshr_punish
                dec acttime,x                           ;Bullet duration
                beq mblt_disappear
mmh_done:       rts

;-------------------------------------------------------------------------------
; MOVE_BULLET
;
; Bullet movement with background collision detection
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_bulletflash:
                lda #ACT_STEALTHBULLET
                jmp mblt_transform

move_flame:     ldy #3
                lda #4                          ;Last frame
                jsr weaponanimation
                bcs mblt_disappear
                bcc move_bullet

move_laser:
move_bullet:
move_dart:      jsr getcharposinfo
                and #CI_OBSTACLE
                bne mblt_stop
                jsr checkbulletcoll
                bcs mshr_punish
                dec acttime,x                           ;Bullet duration
                bmi mblt_shotgun
                beq mblt_disappear
mblt_normal:    jsr moveactorx
                jmp moveactory
mblt_stop:      lda #ACT_SMOKECLOUD
mblt_transform: sta actt,x
                lda #$00
                sta actf1,x
                sta actfd,x
mblt_done:      rts
mblt_disappear: jmp removeactor
mblt_shotgun:   lda acttime,x
                cmp #$80
                beq mblt_disappear
                lsr
                bcc mblt_normal
                                                ;For shotguns - reduce dmg.
                lda acthp,x                     ;each second frame, don't drop
                cmp #DMG_SHOTGUNMIN             ;below minimum
                beq mblt_normal
                dec acthp,x
                bne mblt_normal

;-------------------------------------------------------------------------------
; MOVE_SMOKECLOUD
; MOVE_EXPLOSION
; MOVE_MUZZLEFLASH
;
; Various animation-based actor move routines
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_shrapnel:  jsr mgrn_nolanding              ;Acceleration
                jsr moveactorx
                jsr moveactory
move_smokecloud:ldy #2                          ;Delay
                lda #2                          ;Last frame
move_bltanim:   jsr weaponanimation
                bcs mblt_disappear
                rts


move_explosion: ldy #2                          ;Delay
                lda #5                          ;Last frame
                bne move_bltanim

move_muzzleflash:
                ldy #2
                lda #1
                bne move_bltanim

;-------------------------------------------------------------------------------
; MOVE_MISSILE
;
; Missile movement
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_missile:   lda actsx,x
                asl
                lda #16
                ldy #15*8
                bcc mm_acchorizdone
                lda #-16
                ldy #-15*8
mm_acchorizdone:jsr accactorx
                lda actsy,x
                beq mm_accvertdone
                asl
                lda #8
                ldy #15*4
                bcc mm_accvertok
                lda #-8
                ldy #-15*4
mm_accvertok:   jsr accactory
mm_accvertdone: inc actfd,x
                lda actfd,x
                and #$01
                bne mm_nosmoke
                ldy #ACTI_FIRSTPLRBLT+2
                lda #ACTI_LASTNPCBLT
                jsr getfreeactor
                bcc mm_nosmoke
                lda #ACT_SMOKECLOUD
                jsr spawnactor
                lda #$ff
                sta actfd,y
mm_nosmoke:     lda actxh,x                     ;Missile off map?
                cmp limitl
                bcc mm_remove
                cmp limitr
                bcc mm_noremove
mm_remove:      jmp removeactor
mm_noremove:    lda actsy,x                     ;If missile going down, do
                bmi mm_nolandcheck              ;landingcheck
                beq mm_nolandcheck
                jsr checklanding
                bcs mm_explode
mm_nolandcheck: jsr getcharposinfo              ;Otherwise do only obstacle-
                and #CI_OBSTACLE                ;check
                bne mm_explode
mm_nobgcoll:    jsr checkbulletcoll
                bcs mm_explode
                jsr moveactorx
                jmp moveactory
mm_explode:     jmp mgrn_explode

move_psionic:   inc actf1,x
                lda actf1,x
                cmp #$03
                bne ml_ok
                lda #$00
                sta actf1,x
ml_ok:          jmp move_bullet

;-------------------------------------------------------------------------------
; WEAPONANIMATION
;
; General subroutine for one-sprite oneshot animation
;
; Parameters: X:Actor number
;             Y:Frame delay
;             A:Number of frames to play
; Returns: C=1 when animation finished, otherwise C=0
; Modifies: A,temp1,temp2
;-------------------------------------------------------------------------------

weaponanimation:sty temp1
                sta temp2
                inc actfd,x
                lda actfd,x
                cmp temp1
                bcc wa_done
                lda #$00
                sta actfd,x
                lda actf1,x
                adc #$00                        ;Carry = 1 from the BNE
                sta actf1,x
                cmp temp2
wa_done:        rts

;-------------------------------------------------------------------------------
; AREAEFFECT
;
; Checks explosion radius for all NPCs, and punishes them as necessary.
;
; Parameters: X:Actor number
;             A:Radius of explosion in blocks
; Returns: -
; Modifies: A,Y,temp registers,acthp,actsx
;-------------------------------------------------------------------------------

areaeffect:     sta ae_cmp+1
                lda acthp,x
                sta ae_origdmg+1
                ldy #NUMCOMPLEXACT-1
ae_loop:        lda actgrp,y                    ;Bystanders are invulnerable
                beq ae_next
                bmi ae_next
                cmp actgrp,x                    ;and friendly fire is not
                beq ae_next                     ;permitted
                lda #15*8
                sta temp2                       ;Impulse
                jsr gettargetdistance
                lda targetydist                 ;If Y-distance >0
                beq ae_noydistneg               ;decrement it by one because
                bmi ae_noydistneg               ;enemies/player have height
                dec targetabsydist
ae_noydistneg:
                lda targetxdist
                bpl ae_impulsepos
                lda #-15*8
                sta temp2
ae_impulsepos:  lda targetabsxdist              ;Take the greater of X &
                cmp targetabsydist              ;Y distance
                bcs ae_xdistgreater
                lda targetabsydist
ae_xdistgreater:
ae_cmp:         cmp #$00                        ;Too far away?
                bcs ae_next
                sta temp1
ae_origdmg:     lda #$00                        ;If grenade damage is nonlethal,
                bpl ae_dmgdone                  ;don't mess with it
                and #$7f
ae_lsrloop:     dec temp1
                bmi ae_lsrdone
                lsr                             ;Reduce damage with distance
                bpl ae_lsrloop
ae_lsrdone:     ora #$80
                sta acthp,x
ae_dmgdone:     lda actd,y                      ;Make sure there's no
                eor #$80                        ;surprise benefit
                sta actd,x
                jsr cbc_punish
ae_next:        dey
                bpl ae_loop
                rts

;-------------------------------------------------------------------------------
; CHECKBULLETCOLL
;
; Checks collision of bullet. To be called from the bullet's move routine.
;
; Parameters: X:Actor number
; Returns: C=0 no collision, C=1 collision (Y:Victim)
; Modifies: A,Y,temp registers
;-------------------------------------------------------------------------------

checkbulletcoll:lda acthp,x                     ;Skip if can't cause damage
                beq cbc_nodmg
                ldy #NUMCOMPLEXACT-1
ctch_loop:      lda actgrp,y                    ;Bystanders are invulnerable
                beq ctch_next
                bmi ctch_next
                cmp actgrp,x                    ;and friendly fire is not
                beq ctch_next                   ;permitted
                jsr checkcollision
                bcs ctch_collide
ctch_next:      dey
                bpl ctch_loop
cbc_nodmg:      clc
ctch_collide:   rts

cbc_punish:     sty cbcrestx
                stx cbcresty
                ldx cbcrestx
                ldy cbcresty
                lda actfb,x                     ;A heavy actor (robot or
                and #AFB_HEAVY                  ;plump Agent) receives no
                bne cbc_noimpulse               ;impulse
                lda actsx,y
                bmi cbc_impulseleft
cbc_impulseright:
                lda actsx,x
                bmi cbc_irok
                cmp #2*8
                bcs cbc_noimpulse
cbc_irok:       lda actsx,y
                lsr
                lsr
                lsr
                clc
                adc actsx,x
                jmp cbc_impulseok
cbc_impulseleft:lda actsx,x
                bpl cbc_ilok
                cmp #-2*8
                bcc cbc_noimpulse
cbc_ilok:       lda actsx,y
                lsr
                lsr
                lsr
                ora #$e0
                clc
                adc actsx,x
cbc_impulseok:  sta actsx,x
cbc_noimpulse:
                lda actorg,y
                sta actlastdmgact2,x
                sta actlastdmgact,x
                tay                             ;Store origin actor type
                lda actt,y
                sta cbc_originactt+1

                ldy cbcresty
                lda actbits,y                   ;Shall the bullet be removed?
                bne cbc_noremove
                sta actt,y
cbc_noremove:   lda acthp,y
                cmp #DMG_SPECIAL
                bcs cbc_specialdmg
                cpx #ACTI_PLAYER                ;Surprise attack from the back?
                beq cbc_nosurprise              ;(never for player)
                lda actfb,x
                bpl cbc_noboss                  ;A boss enemy?
cbc_originactt: lda #$00                        ;Can not be surprised
                cmp comradeagent                ;and comradeagent's attacks
                bne cbc_nosurprise              ;are only 50% effective
                lda acthp,y
                lsr
                cmp #$40
                bcc cbc_dopunish
                eor #$c0                        ;Preserve lethal bit
                bcs cbc_dopunish

cbc_noboss:
                and #AFB_ORGANIC                ;Only for organic enemies
                beq cbc_nosurprise
                lda actmode,x                   ;No benefit if alert
                cmp #M_PATROL+1
                bcs cbc_nosurprise
                lda actd,x                      ;No benefit if not from behind
                eor actd,y
                and #$80
                bne cbc_nosurprise
                lda acthp,y                     ;Double damage
                asl
                bcc cbc_dopunish
                ora #$80                        ;Preserve lethal bit
                bne cbc_dopunish
cbc_nosurprise: lda acthp,y

cbc_dopunish:   jsr punish                      ;Punish actor X
cbc_punishcommon:
cbc_soundcount: lda #$00                        ;Sound already played?
                bne cbc_done
                lda #SFX_DAMAGE                 ;Damage sound
                sta cbc_soundcount+1
cbc_sfx:        jsr playsfx
cbc_done:       ldx cbcresty                    ;Restore bullet's actor index
                lda #$00
                sta acthp,x
                ldy cbcrestx                    ;Restore target's actor index
                sec
                rts
cbc_specialdmg: and #$0f
                tay                             ;Index to special damage table
                lda actfb,x                     ;Special damage might not be
                and specdmgcondition,y          ;effective against all actors
                beq cbc_done
                lda specdmgtime,y
                beq cbc_skipprolong
                sta acthptime,x
                lda specdmgdelta,y
                sta acthpdelta,x
cbc_skipprolong:lda specdmgarmor,y              ;Bypass armor?
                lsr
                lda specdmginitial,y            ;Initial damage
                bcc cbc_dopunish
                jsr punish_noarmor
                jmp cbc_punishcommon

;-------------------------------------------------------------------------------
; PUNISH
; PUNISH_NOARMOR
;
; Punishes actor (deals damage)
;
; Parameters: A:Amount of damage (8th bit:lethal damage)
;             X:Actor number.
; Returns: -
; Modifies: A,Y,temp3-temp4
;-------------------------------------------------------------------------------

punish_noarmor: pha
                lda actbatt,x
                sta pna_restbatt+1
                lda #$00
                sta actbatt,x
                pla
                jsr punish
pna_restbatt:   lda #$00
                sta actbatt,x
                rts

punish_skip:    lda #$01                        ;Actor flashing for
                sta actfls,x                    ;oldschool effect :)
                rts

punish:         sta actlastdmghp,x
                and #$7f
                cpx #ACTI_PLAYER                ;In Easy mode halve all damage toward player
                bne punish_nomodify
punish_player:  ldy difficulty    
                bne punish_nomodify
punish_modify:  lsr
                clc
                adc #$01
punish_nomodify:ldy acthp,x                     ;Hitpoints already 0?
                beq punish_skip
                cpy #HP_INVINCIBLE              ;Invincibility?
                beq punish_skip
                sta temp3
                lsr                             ;The armor takes 3/4 of the
                lsr                             ;damage
                sta temp4
                lda temp3
                sec
                sbc temp4
                cmp actbatt,x                   ;Higher than armor level?
                bcc punish_battok
                lda actbatt,x
punish_battok:  sta temp4                       ;This is the amount of damage
                cpx #ACTI_PLAYER                ;the armor "soaks up"
                bne punish_notplayer1
punish_plrarmormod:
                ldy #$00                        ;But the amount reduced from
                jsr punish_dmgmod               ;player's armor meter is modified
punish_notplayer1:                              ;according to armorsystem class
                jsr negate
                clc
                adc actbatt,x
                bpl punish_battsubok
                lda #$00                        ;Protect against overflow on
punish_battsubok:                               ;Hard difficulty
                sta actbatt,x
                jsr getactptr
                lda temp3
                sec
                sbc temp4
                cpx #ACTI_PLAYER
                bne punish_notplayer2
punish_plrvitalitymod:
                ldy #$00                        ;Modify health damage according to
                jsr punish_dmgmod               ;player's vitality
punish_notplayer2:
                sta temp3
                lda acthp,x                     ;Then subtract the rest from
                sec                             ;hitpoints
                sbc temp3
                beq punish_zerohp
                bcs punish_notneg
punish_zerohp:


                lda actgrp,x                    ;SCEPTRE drop medikits/batteries
                cmp #GRP_AGENTS                 ;agents always drop weapon
                beq es_noitemchange             ;others drop weapon or credits
                cmp #GRP_SCEPTRE
                beq es_sceptre
es_normal:      jsr random
                cmp #CREDITS_DROP_PROBABILITY
                bcs es_noitemchange
                lsr
                lsr
                adc #$03                        ;Drop 3+ credits
                sta itemaddtbl+ITEM_CREDITS
                lda #ITEM_CREDITS
                bne es_batteryok
es_sceptre:     jsr random
                cmp #MEDIKIT_DROP_PROBABILITY
                bcs es_noitemchange
                and #$01                        ;Chance of morphing into
                adc #ITEM_MEDIKIT               ;medikit/battery
es_batteryok:   tay
                sta actwpn,x
es_noitemchange:

                lda #T_TAKEDOWN                 ;Takedown trigger
                jsr actortrigger
                jsr enemyscore                  ;Score for takedown
                ldy #AD_TDSOUND                 ;Sound effect
                lda (actlptrlo),y
                jsr playsfx
killactor:      lda #-24                        ;Give upwards speed
                sta actsy,x
                lda #$00                        ;Put actor to the Bystander
                sta actgrp,x                    ;group
                sta acthptime,x
                sta acthpdelta,x
punish_notneg:  sta acthp,x
                jmp punish_skip

punish_dmgmod:  ora #$00                        ;Zero in - zero out
                beq pdmgmod_zero
                stx pdmgmod_restx+1             ;Multiply damage by multiplier
                ldx #dmgmullo                   ;in y (8 = unchanged, 4 = half)
                jsr mulu
                lda dmgmullo
                lsr dmgmulhi                    ;Then divide by 8
                ror
                lsr dmgmulhi
                ror
                lsr dmgmulhi
                ror
                adc #$00                        ;Round upwards
                bne pdmgmod_notzero
                lda #$01                        ;Ensure at least 1 pt. damage
pdmgmod_notzero:
pdmgmod_restx:  ldx #$00
pdmgmod_zero:   rts

