LIFTABOVELIMIT  = -2*8
LIFTBELOWLIMIT  = 10*8

LIFTSPEED       = 2*8

;-------------------------------------------------------------------------------
; MOVE_ZSIGN
;
; 'Z' sign move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_zsign:     dec acttime,x
                bne mz_ok
                jmp removeactor
mz_ok:          lda #-8                         ;Moves upwards slowly
                jsr moveactorydirect
                lda acttime,x
                and #$07
                tay
                lda actxl,x
                and #$c0
                ora xwavetbl,y
                sta actxl,x
mb_ok:          rts

;-------------------------------------------------------------------------------
; MOVE_LIFT
;
; Lift move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_lift:      lda actsy,x
                bmi ml_up
                bne ml_down
                jsr removecheck                         ;Speed zero: can be
                rts                                     ;removed

ml_up:          lda #-1
                jsr getcharposinfooffset
                bpl ml_upslow
ml_upnormal:    lda #-LIFTSPEED
ml_movecommon:  jmp moveactorydirect
ml_upslow:      lda #-LIFTSPEED/2
ml_moveslowcommon:
                jsr moveactorydirect
                lda actyl,x
                and #$38
                beq ml_stop
                rts
ml_stop:        lda #$00
                sta actsy,x
                rts

ml_down:        lda #$01
                jsr getcharposinfooffset
                bpl ml_downslow
ml_downnormal:  lda #LIFTSPEED
                bne ml_movecommon
ml_downslow:    lda #LIFTSPEED/2
                bne ml_moveslowcommon

thinker_lift:   ldy #ACTI_PLAYER                ;Is player at lift controls?
                jsr gettargetdistance
                lda targetabsxdist
                ora targetabsydist
                bne tl_noactivation
                lda actcounter                  ;Activation counter right?
                cmp #$01
                bne tl_noactivation
                lda #CONVDELAY+1                ;Skip activation counter
                sta actcounter                  ;past conversation
                lda #SFX_OBJECT
                jsr playsfx
                lda actxh,y                     ;Left side = up
                cmp actxh,x                     ;Right side = down
                lda #-1
                bcc tl_up
                lda #1
tl_up:          sta temp1                       ;Check that lift shaft
                jsr getcharposinfooffset        ;extends above/below
                bpl tl_noactivation
                lda temp1
                sta actsy,x
mdh_noremove:
tl_noactivation:rts

;-------------------------------------------------------------------------------
; MOVE_DOORHINT
; MOVE_BALLOON
;
; Doorhint + caption balloon move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_doorhint:  lda actxl+ACTI_PLAYER
                sta actxl,x
                lda actxh+ACTI_PLAYER
                sta actxh,x
                lda acttime,x
                cmp #DOORHINT_DURATION/2+1
                bcs mdh_flashok
                lda #$80
                sta actfls,x
mdh_flashok:
move_balloon:   dec acttime,x
                bne mdh_noremove
                jmp removeactor

;-------------------------------------------------------------------------------
; MOVE_STATIONARY
;
; Stationary character (remove check only)
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_stationary:jsr removecheck
move_stationary_noremove:
                rts

;-------------------------------------------------------------------------------
; MOVE_TURRET
;
; Gun turret move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_turret:    jsr removecheck
                lda #3                 ;Number of explosions
                ldy #$1f                ;Maximum radius of explosions
                jsr checkbigexplosion
                ldy #$00
                lda actctrl,x
                and #JOY_FIRE
                beq mt_noanim
                lda actctrl,x
                and #JOY_UP
                beq mt_notup
                iny
mt_notup:       lda actctrl,x
                and #JOY_DOWN
                beq mt_notdown
                ldy #$02
mt_notdown:     tya
                sta actf1,x
                sta actf2,x
mt_noanim:      jmp attack_simple

checkbigexplosion:sta temp1
                lda acthp,x
                bne cbe_ok
                lda temp1
makebigexplosion:
                sta bigexplcount
                sty bigexplradius
                lda #ACT_EXPLOSION
                jsr mblt_transform
cbe_common:     jsr takedownymod
                lda actxl,x
                sta bigexplxl
                lda actyl,x
                sta bigexplyl
                lda actxh,x
                sta bigexplxh
                lda actyh,x
                sta bigexplyh
                pla
                pla
cbe_ok:         rts

;-------------------------------------------------------------------------------
; MOVE_SECURITYBOT
;
; Robot move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_securitybot:
                jsr removecheck
                lda #8                  ;Number of explosions
                ldy #$7f                ;Maximum radius of explosions
                jsr checkbigexplosion
                jsr msb_domove
                jmp attack_simple

msb_domove:     jsr getspeeds
                lda actbits,x
                lsr
                bcc msb_nofly
                jmp mgrn_movecommon

msb_nofly:
                lda actctrl,x               ;Move player right?
                and #JOY_RIGHT
                beq msb_notr
                lda accelpos                    ;Direction = right
                ldy speedpos                    ;Max speed
                bne msb_runcommon
                beq msb_stand
msb_notr:       lda actctrl,x
                and #JOY_LEFT
                beq msb_stand
                lda accelneg                    ;Direction = left
                ldy speedneg                    ;Max speed
                bne msb_runcommon

msb_stand:      jmp mh_stand
msb_runcommon:  sta actd,x
                jsr accactorx                   ;Perform acceleration
                lda #0
                ldy #4
                jmp mh_animcommon

;-------------------------------------------------------------------------------
; MOVE_SPIDERBOT
;
; Robot move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_spiderbot: jsr removecheck
                lda #4                  ;Number of explosions
                ldy #$3f                ;Maximum radius of explosions
                jsr checkbigexplosion
                jsr mh_domove
                jmp attack_simple

;-------------------------------------------------------------------------------
; MOVE_MINICOPTER
;
; Minicopter move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_minicopter:jsr removecheck
                lda acthp,x
                bne mmc_ok
                lda #8                   ;Number of explosions
                ldy #$7f                ;Maximum radius of explosions
                sta bigexplcount
                sty bigexplradius
                lda #PLRFR_OUT
                sta actf1,x
                sta actf2,x
                lda #$80                ;Make sure it's lethal damage..
                sta actlastdmghp,x
                lda #ACT_GRUNT1         ;The pilot drops to the ground..
                sta actt,x
                jsr cbe_common

mmc_ok:         lda actf1,x
                eor #$01
                sta actf1,x
mmc_ok2:        jsr mmc_domove
                jmp attack_simple

mmc_domove:     jsr getspeeds
                jsr mgrn_movecommon
                lda actsy,x
                bmi mmc_yspeedok
                cmp speedpos
                bcc mmc_yspeedok
                lda speedpos
                sta actsy,x
mmc_yspeedok:   lda actctrl,x
                and #JOY_UP
                bne mmc_up
                lda actt,x
                cmp #ACT_HOVERCAR
                beq mmc_hovercar
                jsr random
                cmp #$10
                bcs mmc_noresetlb
                lda actbits,x
                and #$ff-AB_LANDED
                sta actbits,x
mmc_noresetlb:  lda actbits,x
                and #AB_LANDED
                bne mmc_up
mmc_hovercar:   ldy #AD_JUMPSPEED
                lda (actlptrlo),y
                sta temp1
                jsr getcharposinfooffset
                and #CI_GROUND|CI_OBSTACLE
                bne mmc_up
                dec temp1
                lda temp1
                jsr getcharposinfooffset
                and #CI_GROUND|CI_OBSTACLE
                beq mmc_notup
mmc_up:         ldy #AD_CLIMBSPEED              ;Overcome free downwards accel.
                lda accelneg
                sec
                sbc (actlptrlo),y
                ldy speedneg
                jsr accactory
mmc_notup:      lda actctrl,x
                and #JOY_RIGHT
                beq mmc_notr
                lda accelpos                    ;Direction = right
                ldy speedpos                    ;Max speed
                bne mmc_accelcommon
mmc_noaccel:    ldy #AD_BRAKEACCEL
                lda (actlptrlo),y
                jmp brakeactorx
mmc_notr:       lda actctrl,x
                and #JOY_LEFT
                beq mmc_noaccel
                lda accelneg                    ;Direction = left
                ldy speedneg                    ;Max speed
mmc_accelcommon:sta actd,x
                jmp accactorx

;-------------------------------------------------------------------------------
; MOVE_IAC
;
; IAC Interceptor move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_iac:
                lda #12                 ;Number of explosions
                ldy #$ff                ;Maximum radius of explosions
                jsr checkbigexplosion
                jmp mmc_ok

;-------------------------------------------------------------------------------
; MOVE_EXOSKELETON
;
; Exoskeleton move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_exoskeleton:                       ;(boss, no removecheck)
                lda #10                 ;Number of explosions
                ldy #$7f                ;Maximum radius of explosions
                jsr checkbigexplosion
                lda #DMG_ROBOTKATANA          ;Use a fearful katana attack
                sta wpn_dmgtbl+ITEM_KATANA
                jsr move_humanok
                lda #DMG_KATANA
                sta wpn_dmgtbl+ITEM_KATANA
                rts

;-------------------------------------------------------------------------------
; MOVE_SEEKER
;
; Seeker droid
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_seeker:    txa                     ;Make sure the origin of damage
                sta actorg,x            ;is not "player" (else comradeagent
                                        ;will get mad)
                jsr removecheck
                lda acthp,x
                beq mse_explode
                jsr checkbulletcoll
                bcs mse_explode
mse_common:     lda actfd,x
                adc #$01
                and #$0f
                sta actfd,x
                lsr
                lsr
                sta actf1,x
                jmp mmc_domove

mse_explode:    lda #DMG_SEEKER
                sta acthp,x
                lda #GRENADE_RADIUS-1
                jmp mgrn_explodecommon           ;Explode like a grenade

;-------------------------------------------------------------------------------
; MOVE_MUTANT
;
; Mutantbeast move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_mutant:    jsr removecheck
move_mutant_noremove:
                lda acthp,x
                bne mm_hpok
                lda #5                  ;Takedown frame
                jmp mh_outcommon
mm_hpok:        jsr mm_domove
                ;lda actt,x              ;Ensure classic mutant always faces motion dir
                ;cmp #ACT_MUTANT1
                ;bne mm_dirok
                ;lda actsx,x
                ;beq mm_dirok
                ;and #$80
                ;sta actd,x
mm_dirok:       jmp attack_simple

mm_domove:      jsr getspeeds
                lda actbits,x
                lsr
                bcc mm_nofly
                lda #4                      ;Jump/fall frame
                sta actf1,x
                jmp mgrn_movecommon

mm_nofly:       lda actctrl,x               ;Check for init of jump
                and #JOY_JUMP|JOY_LEFT|JOY_RIGHT
                cmp #JOY_JUMP+1
                bcc mm_nonewjump
                lda actprevctrl,x
                and #JOY_JUMP
                bne mm_nonewjump
mm_randomjumpinit:
                lda speedpos            ;Give always max.speed for jumps
                ldy actd,x
                bpl mm_jumpspdok
                lda speedneg
mm_jumpspdok:
                sta actsx,x
                jsr mh_initjump
                jmp mgrn_movecommon
mm_nonewjump:   lda actt,x              ;Mutant boss moves normally. MW classic mutant only jumps
                cmp #ACT_MUTANT1
                beq mm_stationary
                jmp msb_nofly

mm_stationary:  inc actfd,x
                lda actfd,x
                lsr
                lsr
                lsr
                and #$01
                sta actf1,x
                lda #$00
                sta actsx,x
                jsr random              ;Will jump randomly
                cmp #$10
                bcc mm_randomjumpinit
mm_norandomjump:jmp mgrn_movecommon

;-------------------------------------------------------------------------------
; MOVE_HOVERCAR
;
; Agency Hovercar move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_hovercar:  jsr removecheck
                lda #10                 ;Number of explosions
                ldy #$7f                ;Maximum radius of explosions
                jsr checkbigexplosion
mhc_ok:         lda actfd,x
                eor #$01
                and #$01
                sta actfd,x
                lda #2
                ldy actsx,x
                beq mhc_frameok
                lda #0
                ldy actd,x
                bpl mhc_frameok
                lda #4
mhc_frameok:    ora actfd,x
                sta actf1,x
                jmp mmc_ok2

;-------------------------------------------------------------------------------
; MOVE_BAND
;
; Band move routine (animation)
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_band:      jsr removecheck
                inc actfd,x
                lda actfd,x
                lsr
                and #$03
                sta actf1,x
mhd_done:       rts

;-------------------------------------------------------------------------------
; MOVE_HEAD
;
; Floating head
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_head:      jsr removecheck
                lda acthp,x
                beq mh_dead
                jmp floating
mh_dead:        lda actfd,x     ;Wait until returns to upmost position
                lsr
                and #$07
                beq mhd_done
                bne floating

;-------------------------------------------------------------------------------
; MOVE_LEVITATE
;
; Levitating Agent
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_levitate:  jsr removecheck
floating:       inc actfd,x
                lda actfd,x
                lsr
                and #$07
                tay
                lda xwavetbl,y
                lsr
                sta temp1
                lda actyl,x
                and #$c0
                ora temp1
                sta actyl,x
                rts

;-------------------------------------------------------------------------------
; MOVE_BAT
;
; Bat move routine
;
; Parameters: X:Actor number
; Returns: -
; Modifies: A,Y
;-------------------------------------------------------------------------------

move_bat:       jsr removecheck
                lda acthp,x
                bne mbt_ok
                lda #$80                ;No 'Z' marks
                sta actlastdmghp,x
                lda #4                  ;Takedown frame
                jmp mh_outcommon
mbt_ok:         jsr random              ;Make random clicking sounds
                cmp #$fe
                bcc mbt_nosound
                lda #SFX_BAT
                jsr playsfx
mbt_nosound:    jmp mse_common
