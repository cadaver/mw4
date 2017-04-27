musicarea = $c000

REL_UNCHANGED_MINUS = $00
REL_UNCHANGED       = $01
REL_SONGTBL_MINUS   = $02
REL_SONGTBL         = $03
REL_PATTTBL_MINUS   = $04
REL_PATTTBL         = $05
REL_WAVETBL_MINUS   = $06
REL_WAVETBL         = $07
REL_PULSETBL_MINUS  = $08
REL_PULSETBL        = $09
REL_FILTTBL_MINUS   = $0a
REL_FILTTBL         = $0b
REL_END             = $80


musiczpbase     = $fb

maptemp1        = $7c
maptemp2        = $7d
maptemp3        = $7e
maptemp4        = $7f

                org $1000
                processor 6502

                jmp init
                jmp play

init:           cmp #34
                bcc initsong
                pha
                lda #34
                jsr initsong    ;Init silence
                pla
                ldx #$00                        ;X=channel index
psfx_chnok2:    sec
                sbc #34
                asl                             ;A=sound number
                tay
                lda #$01
                sta vchnsfx,x
                lda sfxtbl,y
                sta vchnsfxptrlo,x
                lda sfxtbl+1,y
                sta vchnsfxptrhi,x
                rts

initsong:       tax
                lda songremaptbl,x
                pha
                lsr
                and #$fe
                tay
                lda songadrtbl,y
                sta maptemp1
                lda songadrtbl+1,y
                sta maptemp2
                lda #<musicarea
                sta maptemp3
                lda #>musicarea
                sta maptemp4
                ldy #$00
                ldx #$08
initsong_copy:  lda (maptemp1),y
                sta (maptemp3),y
                iny
                bne initsong_copy
                inc maptemp2
                inc maptemp4
                dex
                bne initsong_copy
                jsr relocatemusic
                pla
                and #$03
                sta maptemp1
                asl
                adc maptemp1
                sta vinitsongnum+1  ;Init tune num
                rts

relocatemusic:  lda #<(musicarea+5)
                sta maptemp1
                lda #>(musicarea+5)
                sta maptemp2
                ldx #$00
rel_loop:       lda reladrtbllo,x
                sta maptemp3
                lda reladrtblhi,x
                sta maptemp4
                lda reladdtbl,x
                bmi rel_done
                lsr
                php
                beq rel_unchanged
                tay
                lda maptemp1
                clc
rel_lda:        adc musicarea-1,y
                sta maptemp1
                lda maptemp2
                adc #$00
                sta maptemp2
rel_unchanged:  plp
                ldy #$01
                lda maptemp1
                sbc #$00
                sta (maptemp3),y
                iny
                lda maptemp2
                sbc #$00
                sta (maptemp3),y
                inx
                bne rel_loop
rel_done:       rts



play:           ldx #$00
vinitsongnum:   ldy #$03
                bmi vchnloop
                txa
                ldx #21
vclearloop:     sta vchnsongpos-1,x
                dex
                bne vclearloop
                sta musiczpbase+3
                lda #$01
                sta musiczpbase+2
                lda #$ff
                sta vinitsongnum+1
                jsr vinitchn
                ldx #$07
                jsr vinitchn
                ldx #$0e
vinitchn:       tya
                sta vchnsongnum,x
                iny
                dec vchncounter,x
                rts

vfreqmod:       inc vchnwavedelay,x
                bne vfreqmod_ok
                lda vchnwavestored,x
                sta vchnwavepos,x
vfreqmod_ok:    lda vchnfreqlo,x
                clc
                adc vchnfreqmodlo,x
                sta vchnfreqlo,x
                sta $d400,x
                lda vchnfreqhi,x
                adc vchnfreqmodhi,x
                jmp vsetfreqhi

vchnloop:       jsr vchnexec
                ldx #$07
                jsr vchnexec
                ldx #$0e
vchnexec:       ldy vchnsfx,x
                beq vnosfx
                jmp vsfxexec
vnosfx:         ldy vchnwavepos,x
                beq vfreqmod
vwavetblminusaccess1:
                lda vwavetbl-1,y
                beq vhrnote
                cmp #$02
                beq vsetsr
                bcc vlegatonote
                cmp #$90
                bcc vwavechange
                beq vnowavechange

vnewfreqmod:    sta vchnwavedelay,x
vnexttblminusaccess1:
                lda vnexttbl-1,y
                sta vchnwavestored,x
vnotetblminusaccess1:
                lda vnotetbl-1,y
                asl
                sta vchnfreqmodlo,x
                lda #$00
                sta vchnwavepos,x
                bcc vfreqmodpos
                lda #$ff
vfreqmodpos:    asl vchnfreqmodlo,x
                rol
                sta vchnfreqmodhi,x
                jmp vwavedone

vhrnote:        jsr vmusic_hr2
vnexttblminusaccess2:
vlegatonote:    lda vnexttbl-1,y
                beq vskipfilt
                sta musiczpbase+2
                lda #$00
                sta musiczpbase+3
vnotetblminusaccess2:
vskipfilt:      lda vnotetbl-1,y
                beq vskippulse
                sta vchnpulsepos,x
                lda #$00
                sta vchnpulse,x
                lda #$01
                sta vchnpulsetime,x
vskippulse:     inc vchnwavepos,x
                jmp vreloadcounter

vwavetblaccess1:
vsetsr:         lda vwavetbl,y
                sta $d404,x
vnotetblminusaccess3:
                lda vnotetbl-1,y
                sta $d405,x
vnexttblminusaccess3:
                lda vnexttbl-1,y
                sta $d406,x
                iny
                bne vnowavechange
vwavechange:    sta $d404,x
vnexttblminusaccess4:
vnowavechange:  lda vnexttbl-1,y
                sta vchnwavepos,x
vnotetblminusaccess4:
                lda vnotetbl-1,y
                asl
                bcs vabsnote
                adc vchnnote,x
vabsnote:       tay
                lda vfreqtbl-26,y
                sta vchnfreqlo,x
                sta $d400,x
                lda vfreqtbl-25,y
vsetfreqhi:     sta $d401,x
                sta vchnfreqhi,x
vwavedone:      inc vchncounter,x
                bne vnonewnote

vgetnewnote:    ldy vchnpattnum,x
vpatttblloaccess:
                lda vpatttbllo,y
                clc
vmusicarealo:   adc #<musicarea
                sta musiczpbase
vpatttblhiaccess:
                lda vpatttblhi,y
vmusicareahi:   adc #>musicarea
                sta musiczpbase+1
                ldy vchnpattpos,x
                lda (musiczpbase),y
                cmp #$c0                        ;Duration?
                bcc vnoduration
                sta vchnduration,x
                iny
                lda (musiczpbase),y
vnoduration:    cmp #$60
                bcs vnotewithwave
                cmp #$5b
                bcc vnotewithoutwave
                beq vrest
vcommand:       and #$07
                sta vcmdsta+1
                iny
                lda vchnsfx,x                           ;Skip command if
                bne vrest                               ;sound effect playing
                lda (musiczpbase),y
vcmdsta:        sta $d400,x
                bcs vrest
vnotewithoutwave:
                adc vchntrans,x
                asl
                sta vchnnote,x
                lda vchnwavepreset,x
                bne vsetpos
vnotewithwave:  beq vwaveonly
                sbc #$61
                adc vchntrans,x               ;Adds one too much (C=1)
                asl
                sta vchnnote,x
vwaveonly:      iny
                lda (musiczpbase),y
                sta vchnwavepreset,x
vsetpos:        sta vchnwavepos,x
vrest:          iny
                lda (musiczpbase),y
                beq vendpatt
                tya
vendpatt:       sta vchnpattpos,x
                rts

vnonewnote:     bmi vpulseexec
vreloadcounter: lda vchnpattpos,x
                bne vnonewpatt
                ldy vchnsongnum,x
vsongtblloaccess:
                lda vsongtbllo,y
                clc
vmusicarealo2:  adc #<musicarea
                sta musiczpbase
vsongtblhiaccess:
                lda vsongtblhi,y
vmusicareahi2:  adc #>musicarea
                sta musiczpbase+1
                ldy vchnsongpos,x
                lda (musiczpbase),y
                bpl vnotrans
                sta vchntrans,x
                iny
                lda (musiczpbase),y
vnotrans:       sta vchnpattnum,x
                iny
                lda (musiczpbase),y
                beq vsongloop
vnoloop:        tya
                bne vloopcommon
vsongloop:      iny
                lda (musiczpbase),y
vloopcommon:    sta vchnsongpos,x

vnonewpatt:     lda vchnduration,x
                sta vchncounter,x
                rts

vpulseexec:     txa
                bne vfiltdone
                ldy musiczpbase+2
                beq vfiltdone
                dec musiczpbase+3
                bmi vfirstfilt
                bne vfiltadd
vfiltnextminusaccess1:
vnextfilt:      lda vfiltnexttbl-1,y
                sta musiczpbase+2
                tay
vfilttimeminusaccess1:
vfirstfilt:     lda vfilttimetbl-1,y
                bmi vsetfilt
                sta musiczpbase+3
                bpl vfiltctrl
vsetfilt:       and #$70
                sta vfiltctrl+1
                lda #$01
                sta musiczpbase+3
vfilttimeminusaccess2:
                lda vfilttimetbl-1,y
vresonance:     ora #$f0
                sta $d417
vfiltaddminusaccess1:
                lda vfiltaddtbl-1,y
                bne vstorefilt
vfiltadd:       lda musiczpbase+4
                clc
vfiltaddminusaccess2:
                adc vfiltaddtbl-1,y
vstorefilt:     sta musiczpbase+4
                sta $d416
vfiltctrl:      lda #$00
vmastervolume:  ora #$0f
                sta $d418

vfiltdone:      ldy vchnpulsepos,x
                beq vnextchn
                dec vchnpulsetime,x
                bmi vnextpulse
                clc
vpulseaddminusaccess1:
                lda vpulseaddtbl-1,y
                adc vchnpulse,x
                adc #$00
                sta vchnpulse,x
                ldy vchnsfx,x                   ;Perform pulsemod, but do not
                bne vnextchn                    ;store the result, with SFX on
vstorepulse2:   sta $d402,x
                sta $d403,x
vnextchn:       rts
vpulsenextminusaccess1:
vnextpulse:     lda vpulsenexttbl-1,y
                sta vchnpulsepos,x
                tay
vpulsetimeminusaccess1:
                lda vpulsetimetbl-1,y
                sta vchnpulsetime,x
                rts

vsfxexec:       lda vchnsfxptrlo,x
                sta musiczpbase
                lda vchnsfxptrhi,x
                sta musiczpbase+1
                cpy #$03
                bcs vsfxexec_initdone
                jsr vmusic_hr
                tay
                lda (musiczpbase),y
                jsr vstorepulse2
                iny
                inc vchnsfx,x
                bne vsfxexec_done
vsfxexec_initdone:
                lda (musiczpbase),y
                bne vsfxexec_noend
vsfxexec_end:   jsr vmusic_hr2                ;Terminate sound effect execution
                sta vchnsfx,x                 ;and make sure, by hardrestart,
                sta vchnwavepos,x             ;that no "wrong" sounds are
                sta vchnwavestored,x          ;made by the music
                jmp vwavedone
vsfxexec_noend: asl
                sta vsfxexec_resty+1
                iny
                lda (musiczpbase),y                ;Then take a look at the coming
                beq vsfxexec_nowavechange     ;byte
                cmp #$82                      ;Is it a waveform or a note?
                bcs vsfxexec_nowavechange
                iny
vsfxexec_wavechange:
                sta $d404,x
vsfxexec_nowavechange:
                tya
                sta vchnsfx,x
                ldy #$01
                lda (musiczpbase),y
                sta $d405,x
                iny
                lda (musiczpbase),y
                sta $d406,x
vsfxexec_resty: ldy #$00
                lda vfreqtbl-24,y             ;Get frequency
                sta $d400,x
                lda vfreqtbl-23,y
                sta $d401,x
vsfxexec_done:  jmp vwavedone

vmusic_hr:      lda #$00
vmusic_hr2:     sta $d404,x
                sta $d405,x
                sta $d406,x
rel_donothing:  rts




vchnsongpos:    dc.b 0
vchnpattnum:    dc.b 0
vchnpattpos:    dc.b 0
vchntrans:      dc.b 0
vchncounter:    dc.b 0
vchnwavepos:    dc.b 0
vchnwavestored: dc.b 0

                dc.b 0,0,0,0,0,0,0
                dc.b 0,0,0,0,0,0,0

vchnwavepreset: dc.b 0
vchnwavedelay:  dc.b 0
vchnsongnum:    dc.b 0
vchnpulse:      dc.b 0
vchnpulsepos:   dc.b 0
vchnpulsetime:  dc.b 0
vchnnote:       dc.b 0

                dc.b 0,0,0,0,0,0,0
                dc.b 0,0,0,0,0,0,0

vchnduration:   dc.b 0
vchnfreqlo:     dc.b 0
vchnfreqhi:     dc.b 0
vchnfreqmodlo:  dc.b 0
vchnfreqmodhi:  dc.b 0
vchnsfx:        dc.b 0
vchnunused:     dc.b 0

                dc.b 0,0,0,0,0,0,0
                dc.b 0,0,0,0,0,0,0

vchnsfxptrlo    = vchnfreqmodlo
vchnsfxptrhi    = vchnfreqmodhi

vsongtbllo:
vsongtblhi:
vpatttbllo:
vpatttblhi:
vwavetbl:
vnotetbl:
vnexttbl:
vpulsetimetbl:
vpulseaddtbl:
vpulsenexttbl:
vfilttimetbl:
vfiltaddtbl:
vfiltnexttbl:

vfreqtbl:       dc.w $022a,$024a,$026d,$0292,$02b9,$02e3,$030f,$033e,$036f,$03a3,$03db,$0415
                dc.w $0454,$0495,$04db,$0525,$0573,$05c7,$061e,$067c,$06de,$0747,$07b6,$082b
                dc.w $08a8,$092b,$09b7,$0a4b,$0ae7,$0b8e,$0c3d,$0cf8,$0dbd,$0e8e,$0f6c,$1057
                dc.w $1150,$1257,$136e,$1496,$15cf,$171c,$187b,$19f0,$1b7b,$1d1d,$1ed8,$20ae
                dc.w $22a0,$24af,$26dd,$292d,$2b9f,$2e38,$30f7,$33e0,$36f6,$3a3b,$3db1,$415d
                dc.w $4540,$495e,$4dbb,$525a,$573f,$5c70,$61ef,$67c1,$6ded,$7476,$7b63,$82ba
                dc.w $8a80,$92bc,$9b76,$a4b4,$ae7f,$b8e0,$c3de,$cf83,$dbda,$e8ed,$f6c7,$ffff

reladrtbllo:    dc.b <vsongtblloaccess
                dc.b <vsongtblhiaccess
                dc.b <vpatttblloaccess
                dc.b <vpatttblhiaccess
                dc.b <vwavetblminusaccess1
                dc.b <vwavetblaccess1
                dc.b <vnotetblminusaccess1
                dc.b <vnotetblminusaccess2
                dc.b <vnotetblminusaccess3
                dc.b <vnotetblminusaccess4
                dc.b <vnexttblminusaccess1
                dc.b <vnexttblminusaccess2
                dc.b <vnexttblminusaccess3
                dc.b <vnexttblminusaccess4
                dc.b <vpulsetimeminusaccess1
                dc.b <vpulseaddminusaccess1
                dc.b <vpulsenextminusaccess1
                dc.b <vfilttimeminusaccess1
                dc.b <vfilttimeminusaccess2
                dc.b <vfiltaddminusaccess1
                dc.b <vfiltaddminusaccess2
                dc.b <vfiltnextminusaccess1

reladrtblhi:    dc.b >vsongtblloaccess
                dc.b >vsongtblhiaccess
                dc.b >vpatttblloaccess
                dc.b >vpatttblhiaccess
                dc.b >vwavetblminusaccess1
                dc.b >vwavetblaccess1
                dc.b >vnotetblminusaccess1
                dc.b >vnotetblminusaccess2
                dc.b >vnotetblminusaccess3
                dc.b >vnotetblminusaccess4
                dc.b >vnexttblminusaccess1
                dc.b >vnexttblminusaccess2
                dc.b >vnexttblminusaccess3
                dc.b >vnexttblminusaccess4
                dc.b >vpulsetimeminusaccess1
                dc.b >vpulseaddminusaccess1
                dc.b >vpulsenextminusaccess1
                dc.b >vfilttimeminusaccess1
                dc.b >vfilttimeminusaccess2
                dc.b >vfiltaddminusaccess1
                dc.b >vfiltaddminusaccess2
                dc.b >vfiltnextminusaccess1

reladdtbl:      dc.b REL_UNCHANGED
                dc.b REL_SONGTBL
                dc.b REL_SONGTBL
                dc.b REL_PATTTBL
                dc.b REL_PATTTBL_MINUS
                dc.b REL_UNCHANGED
                dc.b REL_WAVETBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_WAVETBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_WAVETBL_MINUS
                dc.b REL_PULSETBL_MINUS
                dc.b REL_PULSETBL_MINUS
                dc.b REL_PULSETBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_FILTTBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_FILTTBL_MINUS
                dc.b REL_END

sfxtbl:         dc.w snd_footstep
                dc.w snd_jump
                dc.w snd_pickup
                dc.w snd_damage
                dc.w snd_explosion
                dc.w snd_parasite
                dc.w snd_select
                dc.w snd_cockweapon
                dc.w snd_cockfast
                dc.w snd_insertammo
                dc.w snd_insertclip
                dc.w snd_hypo
                dc.w snd_powerup
                dc.w snd_grenade
                dc.w snd_punch
                dc.w snd_throw
                dc.w snd_melee
                dc.w snd_glass
                dc.w snd_takedown
                dc.w snd_9mm
                dc.w snd_9mmsuppr
                dc.w snd_44magnum
                dc.w snd_shotgun
                dc.w snd_556rifle
                dc.w snd_762sniper
                dc.w snd_laser
                dc.w snd_flame
                dc.w snd_flameignite
                dc.w snd_taser
                dc.w snd_gasfist
                dc.w snd_missile
                dc.w snd_dart
                dc.w snd_object
                dc.w snd_train
                dc.w snd_bat
                dc.w snd_transmission
                dc.w snd_shutdown

songadrtbl:     dc.w song_title
                dc.w song_ansgaros2
                dc.w song_cadaver
                dc.w song_aeuk
                dc.w song_ansgaros1
                dc.w song_crow
                dc.w song_barfington
                dc.w song_cadaver2
                dc.w song_neomancia
                dc.w song_malekith
                dc.w song_warlord
                dc.w song_tara
                dc.w song_ending

songremaptbl:   dc.b $00*4+1    ;Title
                dc.b $01*4+1    ;Intro
                dc.b $02*4+1    ;Agency HQ
                dc.b $0b*4+1    ;City
                dc.b $03*4+1    ;Campus
                dc.b $04*4+1    ;Forest
                dc.b $05*4+1    ;Jungle
                dc.b $05*4+3    ;Jungle caves
                dc.b $06*4+1    ;Research
                dc.b $07*4+1    ;Mansion
                dc.b $08*4+1    ;Comm.Interception / Innersphere hub
                dc.b $09*4+1    ;Sentinels
                dc.b $09*4+3    ;Sentinel Abduction
                dc.b $0a*4+1    ;Final facility
                dc.b $0a*4+3    ;Escape tunnels

                dc.b $01*4+3    ;Short metal (unused)
                dc.b $02*4+3    ;Agency fight
                dc.b $03*4+3    ;Campus fight
                dc.b $04*4+3    ;IAC fight
                dc.b $06*4+3    ;Research fight
                dc.b $07*4+3    ;Mansion fight
                dc.b $08*4+3    ;Innersphere hub fight

                dc.b $01*4+2    ;Intro gameover
                dc.b $02*4+2    ;Agent gameover
                dc.b $0b*4+2    ;City gameover
                dc.b $03*4+2    ;Campus gameover
                dc.b $04*4+2    ;Forest gameover
                dc.b $05*4+2    ;Jungle gameover
                dc.b $06*4+2    ;Research gameover
                dc.b $07*4+2    ;Mansion gameover
                dc.b $08*4+2    ;Comm.interception gameover
                dc.b $09*4+2    ;Sentinels gameover
                dc.b $0a*4+2    ;Final facility gameover

                dc.b $0c*4+1    ;Ending
                dc.b $00*4+0    ;Silence

song_title:     incbin ../music/title.bin
song_ansgaros2: incbin ../music/ansgaros2.bin
song_cadaver:   incbin ../music/cadaver.bin
song_aeuk:      incbin ../music/aeuk.bin
song_ansgaros1: incbin ../music/ansgaros1.bin
song_crow:      incbin ../music/crow.bin
song_barfington:incbin ../music/barfington.bin
song_cadaver2:  incbin ../music/cadaver2.bin
song_neomancia: incbin ../music/neomancia.bin
song_malekith:  incbin ../music/malekith.bin
song_warlord:   incbin ../music/warlord.bin
song_tara:      incbin ../music/tara.bin
song_ending:    incbin ../music/ending.bin

snd_footstep:   include ../sfx/footstep.sfx
snd_bat:        include ../sfx/bat.sfx
snd_jump:       include ../sfx/jump.sfx
snd_dart:       include ../sfx/dart.sfx
snd_select:     include ../sfx/select.sfx
snd_object:     include ../sfx/object.sfx
snd_cockweapon: include ../sfx/cock.sfx
snd_cockfast:   include ../sfx/cockfast.sfx
snd_insertammo: include ../sfx/ammo.sfx
snd_insertclip: include ../sfx/clip.sfx
snd_pickup:     include ../sfx/pickup.sfx
snd_hypo:       include ../sfx/hypo.sfx
snd_powerup:    include ../sfx/powerup.sfx
snd_shutdown:   include ../sfx/shutdown.sfx
snd_transmission:include ../sfx/transmis.sfx
snd_grenade:    include ../sfx/grenade.sfx
snd_punch:      include ../sfx/punch.sfx
snd_throw:      include ../sfx/throw.sfx
snd_parasite:   include ../sfx/parasite.sfx
snd_melee:      include ../sfx/melee.sfx
snd_damage:     include ../sfx/damage.sfx
snd_glass:      include ../sfx/glass.sfx
snd_flameignite:include ../sfx/ignite.sfx
snd_flame:      include ../sfx/flame.sfx
snd_9mmsuppr:   include ../sfx/9mmsuppr.sfx
snd_taser:      include ../sfx/taser.sfx
snd_9mm:        include ../sfx/pistol.sfx
snd_44magnum:   include ../sfx/44magnum.sfx
snd_shotgun:    include ../sfx/shotgun.sfx
snd_556rifle:   include ../sfx/556rifle.sfx
snd_laser:      include ../sfx/laser.sfx
snd_gasfist:    include ../sfx/gasfist.sfx
snd_missile:    include ../sfx/missile.sfx
snd_train:      include ../sfx/train.sfx
snd_takedown:   include ../sfx/takedown.sfx
snd_762sniper:  include ../sfx/sniper.sfx
snd_explosion:  include ../sfx/explosio.sfx


