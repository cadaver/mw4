SFX_FOOTSTEP    = 0
SFX_JUMP        = 1
SFX_PICKUP      = 2
SFX_DAMAGE      = 3
SFX_EXPLOSION   = 4
SFX_PARASITE    = 5
SFX_SELECT      = 6
SFX_COCKWEAPON  = 7
SFX_COCKFAST    = 8
SFX_INSERTAMMO  = 9
SFX_INSERTCLIP  = 10
SFX_HYPO        = 11
SFX_POWERUP     = 12
SFX_GRENADE     = 13
SFX_PUNCH       = 14
SFX_THROW       = 15
SFX_MELEE       = 16
SFX_GLASS       = 17
SFX_TAKEDOWN    = 18
SFX_9MM         = 19
SFX_9MMSUPPR    = 20
SFX_44MAGNUM    = 21
SFX_SHOTGUN     = 22
SFX_556RIFLE    = 23
SFX_762SNIPER   = 24
SFX_LASER       = 25
SFX_FLAME       = 26
SFX_FLAMEIGNITE = 27
SFX_TASER       = 28
SFX_GASFIST     = 29
SFX_MISSILE     = 30
SFX_DART        = 31
SFX_OBJECT      = 32
SFX_TRAIN       = 33
SFX_BAT         = 34
SFX_TRANSMISSION = 35
SFX_SHUTDOWN = 36

SOUND_CHN       = 2                     ;Use channel 3 for sounds when music on

SONG_STOP       = 0

;-------------------------------------------------------------------------------
; PLAYSFX
;
; Plays a sound effect.
;
; Parameters: A:Sound effect number
; Returns: -
; Modifies: A
;-------------------------------------------------------------------------------

playsfx:        stx psfx_restx+1
                sty psfx_resty+1
                ldy soundmode                   ;No sounds at all?
                beq psfx_restx
                ldx #SOUND_CHN*7
                ldy prevtune                    ;Use one or all channels?
                bne psfx_chnok2
nextsndchn:     ldy #$00
                iny
                cpy #$03
                bcc psfx_chnok
                ldy #$00
psfx_chnok:     sty nextsndchn+1
                ldx sfxchntbl,y                 ;X=channel index
psfx_chnok2:    asl
                tay
                lda vchnsfx,x                   ;Channel already playing an
                beq psfx_ok                     ;effect?
                lda sfxtbl+1,y
                cmp vchnsfxptrhi,x              ;Higher in memory = higher
                bcc psfx_restx                  ;priority
                bne psfx_ok
                lda sfxtbl,y
                cmp vchnsfxptrlo,x
                bcc psfx_restx
psfx_ok:        lda #$01
                sta vchnsfx,x
                lda sfxtbl,y
                sta vchnsfxptrlo,x
                lda sfxtbl+1,y
                sta vchnsfxptrhi,x
psfx_restx:     ldx #$00
psfx_resty:     ldy #$00
pzt_none:       rts

;-------------------------------------------------------------------------------
; PLAYGAMETUNE
;
; Plays an "ingame" tune. This means it won't be played if music has been
; turned off.
;
; Parameters: A:Song number
; Returns: -
; Modifies: A
;-------------------------------------------------------------------------------

playzonetune:   ldx zonenum
                lda zonemusic,x
                beq pzt_none              ;0 = do not change music
playgametune:   sta tunenum
                lda musicmode
                beq pgt_musicoff
                lda tunenum
pgt_musicoff:   jmp playtune_check

;-------------------------------------------------------------------------------
; TOGGLEMUSIC
;
; Toggles music. Takes care of restarting the last played song if necessary.
;
; Parameters: -
; Returns: -
; Modifies: A
;-------------------------------------------------------------------------------

togglemusic:    lda musicmode
                lsr
                lda tunenum
                bcs tm_on
                lda #SONG_STOP
tm_on:          jmp playtune_ok

;-------------------------------------------------------------------------------
; PLAYTUNE
;
; Plays a tune regardless of whether music is active.
;
; Parameters: A:Song number
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

playtune:       sta tunenum
playtune_check: cmp prevtune
                beq playtune_skip
playtune_ok:    pha
                cmp #SONG_STOP                  ;If it's the silence tune,
                beq playtune_noload             ;music file doesn't matter
                lsr                             ;Get music file number
                lsr
                cmp musicfilenum                ;Same as previous?
                beq playtune_noload
                sta musicfilenum
                ldx #FILE_MUSIC
                stx music+1                     ;Stop music playback
                jsr makefilename                ;when new music is loaded
                lda #<musicarea
                ldx #>musicarea
                jsr loadfileretry
                jsr relocatemusic
playtune_noload:pla
                sta prevtune
                and #$03
                sta maptemp1
                asl
                adc maptemp1
                sta vinitsongnum+1
playtune_skip:  rts

;-------------------------------------------------------------------------------
; Ninjatracker playroutine
;-------------------------------------------------------------------------------

music_silence:  lda #$00                          ;Silence music channels so
                tax                               ;that they can be restarted
                jsr music_silence2                ;later
                inx                               ;(in case of music loading
music_silence2: sta $d400,x                       ;or KERNAL on)
                sta $d400+7,x
                sta $d400+14,x
                rts

music:          ldx #$ff                        ;Nonzero = disallow music
                bne music_silence
vinitsongnum:   ldy #$00
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
                adc #<musicarea
                sta musiczpbase
vpatttblhiaccess:
                lda vpatttblhi,y
                adc #>musicarea
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
                adc #<musicarea
                sta musiczpbase
vsongtblhiaccess:
                lda vsongtblhi,y
                adc #>musicarea
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
                bpl vfiltdone
vsetfilt:       and #$70
vmastervolume:  ora #$0f
                sta $d418
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

;-------------------------------------------------------------------------------
; RELOCATEMUSIC
;
; Modifies playroutine addresses to reflect the current song(s) loaded. This
; uses the same zeropage addresses as MUSIC (the playroutine itself), so don't
; call it while this is running!
;-------------------------------------------------------------------------------

;musicdata+0 = songtable len (1/2)
;musicdata+1 = patttable len (1/2)
;musicdata+2 = wavetable len
;musicdata+3 = pulsetable len
;musicdata+4 = filttable len

;Relocation codes:
;0 = unchanged
;1 = don't subtract one
;2,4,6,8,10 = add length
;Negative = quit

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

