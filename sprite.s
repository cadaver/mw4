MINSPRY         = 34                            ;Minimum visible Y-coord
MAXSPRY         = 211                           ;Maximum visible Y-coord
MAXSPRX         = 168                           ;Maximum visible X-coord

FIRSTDEPACKFRAME = $20
FIRSTSPRITEFRAME = $20+NUMDEPACKSPR
LASTSPRITEFRAME  = $e0
EMPTYFRAME       = $1e


SPRF_COMMON     = 0
SPRF_LEGS       = 1
SPRF_AGENT      = 2
SPRF_LIFT       = 3
SPRF_COP        = 4
SPRF_IAN        = 5
SPRF_THUGS      = 6
SPRF_INSIDE     = 7
SPRF_TECH       = 8
SPRF_BYSTAND    = 9
SPRF_SCIENTIST  = 10
SPRF_GRUNT      = 11
SPRF_COMMANDO   = 12
SPRF_ENEMYAGENT = 13
SPRF_PRIEST     = 14
SPRF_TURRET     = 15
SPRF_HEAVYTURRET = 16
SPRF_ROBOT      = 17
SPRF_SPIDERBOT  = 18
SPRF_MINICOPTER = 19
SPRF_IAC        = 20
SPRF_EXOSKELETON = 21
SPRF_MUTANT1    = 22
SPRF_MUTANT2    = 23
SPRF_HOVERCAR   = 24
SPRF_BLACKHAND  = 25
SPRF_BLOWFISH   = 26
SPRF_GOAT       = 27
SPRF_JOANAGENT  = 28
SPRF_BAND       = 29
SPRF_SENTINEL   = 30

SPRF_PACKED     = $ff

;-------------------------------------------------------------------------------
; SORTSPRITES
;
; Sorts the sprites to the sorted table for multiplexing. If necessary, waits
; for the previous frame update to be completed.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

sortsprites:    lda frameupdflag
                bne sortsprites
                sta music+1                 ;Allow music (loading finished)
                lda targetframes            ;Check for game speed
                beq sortsprites             ;(NTSC/PAL)
                dec targetframes
                lda irqirqstart             ;Assume: no sprites
                eor #NUMSPRIRQ
                sta sortirqstart
                lda irqsprstart
                eor #NUMSPR
                sta sortsprstart
                clc
                adc #$08
                sta sspr_copyycmp+1
                ldx #$00
sspr_sortloop:  ldy sortorder+1,x
                lda spry,y
                ldy sortorder,x
                cmp spry,y
                bcs sspr_sortskip
                stx sspr_sortreload+1
sspr_sortswap:  lda sortorder+1,x
                sta sortorder,x
                sty sortorder+1,x
                cpx #$00
                beq sspr_sortreload
                dex
                ldy sortorder+1,x
                lda spry,y
                ldy sortorder,x
                cmp spry,y
                bcc sspr_sortswap
sspr_sortreload:ldx #$00
sspr_sortskip:  inx
                cpx #NUMSPR-1
                bcc sspr_sortloop
                lda #<sortorder
                sta sspr_copyloop+1
                ldy sortsprstart
sspr_copyloop_resetbits:
                lda #$80                        ;Sprite OR bit
                sta temp1
                eor #$ff                        ;Sprite AND bit
                sta temp2
sspr_copyloop:  ldx sortorder
                inc sspr_copyloop+1
                lda spry,x
                cmp #MAXSPRY
                bcs sspr_copyready
                cmp #MINSPRY
                bcc sspr_copyloop
                sta sortspry,y
sspr_copyycmp:  cpy #$00
                bcc sspr_copyycmpskip
                sbc #21
                cmp sortspry-8,y                ;Check for too many sprites on
                bcc sspr_copyloop               ;same row
sspr_copyycmpskip:
                lda sprc,x                      ;Colors >= 128 are invisible
                bmi sspr_copyloop
                sta sortsprc,y
                lda sprx,x                      ;Check for X out of range
                cmp #MAXSPRX
                bcs sspr_copyloop
                asl
sspr_finescroll:ora #$00
                sta sortsprx,y
                bcc sspr_copymsblow
                lda sortsprd010-1,y             ;Handle $d010 bits (X MSB)
                ora temp1
                sta sortsprd010,y
                bne sspr_copymsbdone
sspr_copymsblow:lda sortsprd010-1,y
                and temp2
                sta sortsprd010,y
                sec
sspr_copymsbdone:
                lda sprf,x
                sta sortsprf,y
                iny
                ror temp2
                lsr temp1
                bne sspr_copyloop
                beq sspr_copyloop_resetbits
sspr_copyready: sty sortsprend
                cpy sortsprstart
                bne sspr_notzerospr
                rts
sspr_notzerospr:

                ldy sortsprstart                ;Sorted sprite-counter
                ldx sortirqstart                ;SpriteIRQ-counter
                txa
                adc #NUMSPRIRQ                  ;Carry is 0 here
                sta sspr_irqlimit+1             ;Last available spriteIRQ
                tya
                sta sprirqstart,x               ;Set start of first spriteIRQ
                adc #$08
                cmp sortsprend                  ;8 or less sprites total?
                bcc sspr_notless
                ldy sortsprend
                jmp sspr_irqdone
sspr_notless:   tay
                jmp sspr_irqdone
sspr_irqloop:   tya
                sta sprirqstart,x
                lda sortspry,y
                sta sprirqline,x
sspr_sprloop:   iny
                cpy sortsprend
                bcs sspr_irqdone
            ;    lda sprirqline,x                ;Can the next sprite
            ;    sbc #33                         ;already be overwritten?
            ;    cmp sortspry-8,y
            ;    bcs sspr_sprloop
                lda sortspry,y                  ;Is there yet need for it
                sbc #8
                cmp sprirqline,x                ;to be overwritten?
                bcc sspr_sprloop
sspr_irqdone:   tya
                sec
                sbc sprirqstart,x
                sta sprirqamount,x
                inx
sspr_endcmp3:   cpy sortsprend
                bcs sspr_irqsdone
sspr_irqlimit:  cpx #$00                        ;Run out of spriteIRQs?
                bcc sspr_irqloop
sspr_irqsdone:  stx sortirqend
loadspr_done:
loadspr_alreadyloaded:
sspr_alldone:   rts

;-------------------------------------------------------------------------------
; LOADSPRITES
;
; Loads a spritefile, using the sprite allocation system.
;
; Parameters: A: Logical spritefile number
; Returns: - (retries until OK)
; Modifies: A,X,Y,temp regs
;-------------------------------------------------------------------------------

loadspr_outofmemory:
                sta lsoom_req+1
                jsr incspritetime
lsoom_purgeagain:
                ldy #$00                        ;Search for oldest spritefile
                lda #$00
                ldx #$01
lsoom_loop:     cmp sprfiletime,x
                bcs lsoom_next
                txa
                tay                             ;Y=oldest found index
                lda sprfiletime,x               ;A=oldest found time
lsoom_next:     inx
                cpx #NUMSPRFILES
                bcc lsoom_loop                  ;Leave sprites0 (common)
                tya                             ;alone, but purge it in
                jsr purgesprites                ;extreme distress :)
lsoom_req:      lda #$00
                cmp freesprites
                beq loadspr_memok
                bcc loadspr_memok
                bcs lsoom_purgeagain            ;Retry until eternity as needed

loadsprites:    sta temp1
                tax
                lda sprfilebaseframe,x
                bne loadspr_alreadyloaded
                lda #FILE_SPRITE                ;Reverse way of using A,X
                                                ;in makefilename but who cares :)
                jsr makefilename
loadspr_retry:  jsr showdisk
                jsr openfile                    ;Open the spritefile
                jsr getbyte                     ;Get amount of sprites
                bcc loadspr_ok
                jsr hidedisk
                jsr retryprompt
                jmp loadspr_retry
loadspr_ok:     cmp freesprites
                beq loadspr_memok
                bcs loadspr_outofmemory
loadspr_memok:  ldx temp1
                sta sprfileframes,x
                sta temp5                      ;Counter for flipping
                sta temp6
                lda #LASTSPRITEFRAME           ;Set sprite baseframe
                sec
                sbc freesprites
                sta sprfilebaseframe,x
                tay
loadspr_loop:   jsr getbyte                     ;Load sprite header information
                sta sprcol-FIRSTSPRITEFRAME,y
                jsr getbyte
                sta sprhotspotx-FIRSTSPRITEFRAME,y
                jsr getbyte
                sta sprhotspoty-FIRSTSPRITEFRAME,y
                jsr getbyte
                sta sprconnectspotx-FIRSTSPRITEFRAME,y
                jsr getbyte
                sta sprconnectspoty-FIRSTSPRITEFRAME,y
                iny
                dec freesprites
                dec temp6
                bne loadspr_loop
                ldx temp1
                lda sprfilebaseframe,x
                sta temp3
                sta temp4
                jsr getspriteaddress
                jsr loadfile
loadspr_fliploop:
                lda temp3
                jsr getspriteaddress
                sta tempadrlo
                stx tempadrhi
                ldy #$3e
loadspr_sliceloop1:
                sei
                dec $01
                lda (tempadrlo),y        ;Push sprite onto stack
                pha
                dey
                lda (tempadrlo),y
                pha
                dey
                lda (tempadrlo),y
                inc $01
                cli
                pha
                dey
                bpl loadspr_sliceloop1
                iny
                clc
loadspr_sliceloop2:
                pla
                sei
                dec $01
                sta (tempadrlo),y
                inc $01
                cli
                tya
                adc #$03
                tay
                cmp #63
                bcc loadspr_sliceloop2
                sbc #62                 ;Go to beginning of next vertical slice
                tay
                cmp #$03                ;Until all 3 done
                bcc loadspr_sliceloop2

                ldy #$3f                ;Check last byte of sprite for
                sei                     ;the flip indicator
                dec $01
                lda (tempadrlo),y
                inc $01
                cli
                cmp #$00
                beq loadspr_flipnext
                sbc #$01                ;Carry 1 if nonzero
                clc
                adc temp4
                jsr getspriteaddress
                lda #21                 ;Row counter
                sta temp2
                clc
loadspr_rowloop:
                ldy #2                  ;Flip each row of sprite
                sei
                dec $01
                lda (alo),y
                ldy #0
                tax
                lda fliptable,x
                sta (tempadrlo),y
                iny
                lda (alo),y
                tax
                lda fliptable,x
                sta (tempadrlo),y
                dey
                lda (alo),y
                ldy #2
                tax
                lda fliptable,x
                sta (tempadrlo),y
                inc $01
                cli
                lda tempadrlo   ;Sprites never cross page boundaries :)
                adc #$03
                sta tempadrlo
                lda alo
                adc #$03
                sta alo
                dec temp2
                bne loadspr_rowloop
loadspr_flipnext:
                inc temp3
                dec temp5
                beq loadspr_flipdone
                jmp loadspr_fliploop
loadspr_flipdone:

                jsr hidedisk
                jsr initmap
                clc
                rts


;-------------------------------------------------------------------------------
; PURGESPRITES
;
; Purges a spritefile from the memory.
;
; Parameters: A: Logical spritefile number
; Returns: -
; Modifies: A,Y,temp2-temp6
;-------------------------------------------------------------------------------

purgesprites:   tax
                stx temp2

                lda $01
                sta pspr_rest01+1

                lda #$00
                sta temp6                       ;Assume: no shifting required
                lda sprfilebaseframe,x          ;Sprites loaded?
                beq pspr_noshift3
                sta temp5
                ldy #NUMSPRFILES-1
pspr_check:     lda temp5                       ;If there are spritefiles after
                cmp sprfilebaseframe,y          ;this in memory, have to shift
                bcs pspr_noshift2               ;them upwards
                lda sprfilebaseframe,y          ;Change the baseframe
                sec
                sbc sprfileframes,x
                sta sprfilebaseframe,y
                lda #LASTSPRITEFRAME
                sec
                sbc freesprites
                sbc temp5
                sbc sprfileframes,x
                sta temp6                       ;Amount of sprites to shift
pspr_noshift2:  dey
                bpl pspr_check
                lda temp6
                bne pspr_shift
pspr_noshift3:  jmp pspr_noshift
pspr_shift:     lda temp5
                jsr getspriteaddress
                sta tempadrlo                   ;Shift dest.address
                stx tempadrhi
                ldx temp2
                lda temp5                       ;Shift source address
                clc
                adc sprfileframes,x
                sta temp4                       ;Source spritenumber
                jsr getspriteaddress

                ldy #62
pspr_shiftinner:sei
                lda #$34
                sta $01
                lda (alo),y                     ;Move one row at a time
                sta (tempadrlo),y
                dey
                lda (alo),y
                sta (tempadrlo),y
                dey
                lda (alo),y
                sta (tempadrlo),y
pspr_rest01:    lda #$35
                sta $01
                cli
                dey
                bpl pspr_shiftinner
                ldx temp4
                ldy temp5
                lda sprcol-FIRSTSPRITEFRAME,x             ;Copy sprite parameters
                sta sprcol-FIRSTSPRITEFRAME,y
                lda sprhotspotx-FIRSTSPRITEFRAME,x
                sta sprhotspotx-FIRSTSPRITEFRAME,y
                lda sprhotspoty-FIRSTSPRITEFRAME,x
                sta sprhotspoty-FIRSTSPRITEFRAME,y
                lda sprconnectspotx-FIRSTSPRITEFRAME,x
                sta sprconnectspotx-FIRSTSPRITEFRAME,y
                lda sprconnectspoty-FIRSTSPRITEFRAME,x
                sta sprconnectspoty-FIRSTSPRITEFRAME,y
                ldx #NUMSPR*2-1                         ;Move also spritepointer
pspr_checkloop: lda sortsprf,x                          ;if necessary
                cmp temp4
                bne pspr_checknext
                tya
                sta sortsprf,x
pspr_checknext: dex
                bpl pspr_checkloop

                inc temp4
                inc temp5
                dec temp6
                bne pspr_shift
                ldx temp2
pspr_noshift:   lda freesprites
                clc
                adc sprfileframes,x
                sta freesprites
                lda #$00
                sta sprfilebaseframe,x
                sta sprfileframes,x
                sta sprfiletime,x
                rts

;-------------------------------------------------------------------------------
; GETSPRITEADDRESS
;
; Gets address corresponding to frame number.
;
; Parameters: A:Frame number (32-255)
; Returns: Address in A,X (and alo,ahi)
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

getspriteaddress:
                tay
                lsr
                lsr
                clc
                adc #$c0
                tax
                tya
                ror
                ror
                ror
                and #$c0
                sta alo
                stx ahi
dspr_donothing: rts

;------------------------------------------------------------------------------
; DEPACKSPRITES
;
; Copies (depacks) packed sprites as needed.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;------------------------------------------------------------------------------

depacksprites:  ldy #NUMDEPACKSPR-1
dspr_loop:      lda dsprf,y
                cmp dsprprevf,y
                bne dspr_notsame
dspr_next:      dey
                bpl dspr_loop
                rts

dspr_notsame:   sty temp1
                sta dsprprevf,y
                tax
                bmi dspr_left
                jmp dspr_right

dspr_left:      lda dspr_adrlo-$80,x
                sta temp3
                lda dspr_adrhi-$80,x
                sta temp4
                tya
                lsr
                lsr
                clc
                adc #$c0+(FIRSTDEPACKFRAME/4)
                cmp dsprl_emptysta1+2
                beq dsprl_skipselfmod
                sta dsprl_emptysta1+2
                sta dsprl_emptysta2+2
                sta dsprl_emptysta3+2
                sta dsprl_emptysta4+2
                sta dsprl_emptysta5+2
                sta dsprl_emptysta6+2
                sta dsprl_emptysta7+2
                sta dsprl_fullsta1+2
                sta dsprl_fullsta2+2
                sta dsprl_fullsta3+2
                sta dsprl_fullsta4+2
                sta dsprl_fullsta5+2
                sta dsprl_fullsta6+2
                sta dsprl_fullsta7+2
dsprl_skipselfmod:
                lda dspr_mask-$80,x
                sta temp2
                tya
                ror
                ror
                ror
                and #$c0
                ora #$02
                tax
                ldy #$00
                jsr dsprl_slice
                dex
                jsr dsprl_slice
                dex
                jsr dsprl_slice
                txa
                clc
                adc #23
                tax
                jsr dsprl_slice
                dex
                jsr dsprl_slice
                dex
                jsr dsprl_slice
                ldy temp1
                jmp dspr_next

dsprl_slice:    lsr temp2                       ;Check slice type (empty/data)
                bcc dsprl_emptyslice
dsprl_fullslice:lda (temp3),y
                sta dsprl_fulllda1+1
dsprl_fulllda1: lda fliptable
dsprl_fullsta1: sta $c000,x
                iny
                lda (temp3),y
                sta dsprl_fulllda2+1
dsprl_fulllda2: lda fliptable
dsprl_fullsta2: sta $c000+3,x
                iny
                lda (temp3),y
                sta dsprl_fulllda3+1
dsprl_fulllda3: lda fliptable
dsprl_fullsta3: sta $c000+6,x
                iny
                lda (temp3),y
                sta dsprl_fulllda4+1
dsprl_fulllda4: lda fliptable
dsprl_fullsta4: sta $c000+9,x
                iny
                lda (temp3),y
                sta dsprl_fulllda5+1
dsprl_fulllda5: lda fliptable
dsprl_fullsta5: sta $c000+12,x
                iny
                lda (temp3),y
                sta dsprl_fulllda6+1
dsprl_fulllda6: lda fliptable
dsprl_fullsta6: sta $c000+15,x
                iny
                lda (temp3),y
                sta dsprl_fulllda7+1
dsprl_fulllda7: lda fliptable
dsprl_fullsta7: sta $c000+18,x
                iny
                rts

dsprl_emptyslice:lda #$00
dsprl_emptysta1: sta $c000,x
dsprl_emptysta2: sta $c000+3,x
dsprl_emptysta3: sta $c000+6,x
dsprl_emptysta4: sta $c000+9,x
dsprl_emptysta5: sta $c000+12,x
dsprl_emptysta6: sta $c000+15,x
dsprl_emptysta7: sta $c000+18,x
                rts

dspr_right:     lda dspr_adrlo,x
                sta temp3
                lda dspr_adrhi,x
                sta temp4
                tya
                lsr
                lsr
                clc
                adc #$c0+(FIRSTDEPACKFRAME/4)
                cmp dspr_emptysta1+2
                beq dspr_skipselfmod
                sta dspr_emptysta1+2
                sta dspr_emptysta2+2
                sta dspr_emptysta3+2
                sta dspr_emptysta4+2
                sta dspr_emptysta5+2
                sta dspr_emptysta6+2
                sta dspr_emptysta7+2
                sta dspr_fullsta1+2
                sta dspr_fullsta2+2
                sta dspr_fullsta3+2
                sta dspr_fullsta4+2
                sta dspr_fullsta5+2
                sta dspr_fullsta6+2
                sta dspr_fullsta7+2
dspr_skipselfmod:
                lda dspr_mask,x
                sta temp2
                tya
                ror
                ror
                ror
                and #$c0
                tax
                ldy #$00
                jsr dspr_slice
                inx
                jsr dspr_slice
                inx
                jsr dspr_slice
                txa
                clc
                adc #19
                tax
                jsr dspr_slice
                inx
                jsr dspr_slice
                inx
                jsr dspr_slice
                ldy temp1
                jmp dspr_next

dspr_slice:     lsr temp2                       ;Check slice type (empty/data)
                bcc dspr_emptyslice
dspr_fullslice: lda (temp3),y
dspr_fullsta1:  sta $c000,x
                iny
                lda (temp3),y
dspr_fullsta2:  sta $c000+3,x
                iny
                lda (temp3),y
dspr_fullsta3:  sta $c000+6,x
                iny
                lda (temp3),y
dspr_fullsta4:  sta $c000+9,x
                iny
                lda (temp3),y
dspr_fullsta5:  sta $c000+12,x
                iny
                lda (temp3),y
dspr_fullsta6:  sta $c000+15,x
                iny
                lda (temp3),y
dspr_fullsta7:  sta $c000+18,x
                iny
                rts

dspr_emptyslice:lda #$00
dspr_emptysta1: sta $c000,x
dspr_emptysta2: sta $c000+3,x
dspr_emptysta3: sta $c000+6,x
dspr_emptysta4: sta $c000+9,x
dspr_emptysta5: sta $c000+12,x
dspr_emptysta6: sta $c000+15,x
dspr_emptysta7: sta $c000+18,x
                rts



