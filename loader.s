                processor 6502
                include define.s

                org maincodestart

;-------------------------------------------------------------------------------
; COVERT BITOPS loader
; Heavily modified for the MW4 engine
;
; SuperRAM routines & REU code optimization by Wolfram Sang (Ninja/The Dreams)
; 1581/CMD FD/CMD HD info from Wolfram Sang (Ninja/The Dreams) and
; Christoph Thelen (Doc Bacardi/The Dreams)
; 2Mhz drivecode by Per Olofsson (Magervalp)
;
; Rest by Lasse Öörni
;
; Thanks to K.M/TABOO for inspiration on badline detection and 1-bit transfer,
; Marko Mäkelä for his original irqloader.s (huge inspiration) and Pixman for
; suggesting extra RAM support.
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; MAKEFILENAME
; MAKEFILENAME_DIRECT
;
; Creates the filename.
;
; Parameters: A:File number (X:File type add in MAKEFILENAME only)
; Returns: filename
; Modifies: A
;-------------------------------------------------------------------------------

makefilename:   stx maptemp1
                clc
                adc maptemp1
makefilename_direct:
makefilename2:  pha
                lsr
                lsr
                lsr
                lsr
                jsr mfn_sub
                sta filename
                pla
                jsr mfn_sub
                sta filename+1
                rts

mfn_sub:        and #$0f
                ora #$30
                cmp #$3a
                bcc mfn_number
                adc #$06
mfn_number:     rts


;-------------------------------------------------------------------------------
; OPENFILE
;
; Opens a file either with slow or fast loader.
; If a file is already open, does nothing!
;
; Parameters: filename
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

openfile:       lda fileopen              ;A file already open? If so, do nothing
                beq open_ok               ;(primitive form of IFFL)
                rts
open_ok:        inc fileopen              ;File opened
                sta $d07a                 ;SCPU to slow mode
                lda fastloadstatus        ;If fastloader active, use it
                lsr
                bcs fastopen

;-------------------------------------------------------------------------------
; SLOWOPEN
;
; Opens a file without fastloader.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

slowopen:       jsr kernalon
slowopen_common:jsr setfilename
                lda #$02
                ldy #$00
                jsr setlfsopen
                jmp chkin

;-------------------------------------------------------------------------------
; FASTOPEN
;
; Opens a file with fastloader. Uses an asynchronous protocol inspired by
; Marko Mäkelä's work when sending the filename.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

fastopen:       ldx #$01
fastload_sendouter:
                lda filename,x
                sta loadtempreg
                ldy #$08                  ;Bit counter
fastload_sendinner:
                bit $dd00                 ;Wait for both DATA & CLK to go high
                bpl fastload_sendinner
                bvc fastload_sendinner
                lsr loadtempreg
                lda #$10
                ora $dd00
                bcc fastload_zerobit
                eor #$30
fastload_zerobit:
                sta $dd00
                lda #$c0                  ;Wait for CLK & DATA low (answer from
fastload_sendack:                         ;the diskdrive)
                bit $dd00
                bne fastload_sendack
                lda #$ff-$30              ;Set DATA and CLK high
                and $dd00
                sta $dd00
                dey
                bne fastload_sendinner
                dex
                bpl fastload_sendouter
fastload_predelay:
                dex                       ;Delay to make sure the 1541 has
                bne fastload_predelay     ;set DATA high before we continue
fastload_fillbuffer:
                ldx #$00
fastload_fbwait:
                bit $dd00                 ;Wait for 1541 to signal data ready by
                bmi fastload_fbwait       ;setting DATA low
fastload_fbloop:
fastload_spritewait:  
                lda $d012                 ;Check for sprite Y-coordinate range
fastload_maxspry:     
                cmp #$00                  ;(these max & min values are filled in the
                bcs fastload_nosprites    ;raster interrupt)
fastload_minspry:
                cmp #$00
                bcs fastload_spritewait
fastload_nosprites:
                sei
fastload_waitbadline:
                lda $d011                 ;Check that a badline won't disturb
                clc                       ;the timing
                sbc $d012
                and #$07
                beq fastload_waitbadline
                lda $dd00
                ora #$10
                sta $dd00                 ;Set CLK low
fastload_delay: bit $00                   ;Delay (NTSC version, will be modified for PAL)
                nop
                and #$03
                sta fastload_eor+1
                sta $dd00                 ;Set CLK high
                lda $dd00
                lsr
                lsr
                eor $dd00
                lsr
                lsr
                eor $dd00
                lsr
                lsr
fastload_eor:   eor #$00
                eor $dd00
                cli
                sta loadbuffer,x
                inx
                bne fastload_fbloop

                stx bufferstatus          ;X is 0 here
                ldx #$fe
                lda loadbuffer            ;Full 254 bytes?
                bne fastload_fullbuffer
                ldx loadbuffer+1          ;End of load?
                bne fastload_noloadend
                stx fileopen              ;Clear fileopen indicator
                lda loadbuffer+2          ;Read the return/error code
                sta fileclosed+1
fastload_noloadend:
                dex
fastload_fullbuffer:
                stx fastload_endcomp+1
fileclosed:     lda #$00
                sec
                rts

;-------------------------------------------------------------------------------
; GETBYTE
;
; Gets a byte from an opened file.
;
; Parameters: -
; Returns: C=0 OK, A contains byte
;          C=1 File stream ended. A contains the error code:
;              $00 - OK, end of file
;              $01 - Sector read error (only with fastloading)
;              $02 - File not found
; Modifies: A
;-------------------------------------------------------------------------------

getbyte:        lda fileopen
                beq fileclosed
                stx getbyte_restx+1
                sty getbyte_resty+1
getbyte_fileopen:
                lda fastloadstatus
                lsr
                bcc slowload_getbyte
fastload_getbyte:
                ldx bufferstatus
                lda loadbuffer+2,x
                inx
fastload_endcomp:cpx #$00                 ;Reach end of buffer?
                stx bufferstatus
                bcc getbyte_restx
                pha
                jsr fastload_fillbuffer
                pla
getbyte_done:   clc
getbyte_restx:  ldx #$00
getbyte_resty:  ldy #$00
                rts

slowload_getbyte:
                jsr chrin
                ldx status
                beq getbyte_done
                pha
                txa
                and #$03
                sta fileclosed+1          ;EOF - store return code
                dec fileopen
                jsr kernaloff
                pla
                ldx fileclosed+1          ;Check return code, if nonzero,
                cpx #$01                  ;return with carry set and return
                bcc getbyte_restx         ;code in A
                txa
                bcs getbyte_restx

;-------------------------------------------------------------------------------
; CLOSEFILE
;
; "Drains" (closes) a file.
;
; Parameters: -
; Returns: C=1, A:Errorcode or 0 on EOF
; Modifies: A
;-------------------------------------------------------------------------------

closefile:      jsr getbyte
                bcc closefile
                rts

;-------------------------------------------------------------------------------
; LOADFILE
;
; Loads a packed file.
;
; Parameters: A,X:Load address
;             Filename
; Returns: C=0 File loaded OK
;          C=1 A:zero EOF, stream ended successfully
;          C=1 A:nonzero Error of some kind, call GETBYTE again to know more
;
; Modifies: A,X
;-------------------------------------------------------------------------------

loadfile:       sta exo_addl+1
                stx exo_addh+1
                tsx
                stx exo_error+1
                jsr openfile
                jsr exomizer
                clc
                rts

tabl_bi = depackbuffer
tabl_lo = depackbuffer + 52
tabl_hi = depackbuffer + 104

exomizer:
; -------------------------------------------------------------------
; no code below this comment has to be modified in order to generate
; a working decruncher of this source file.
; However, you may want to relocate the tables last in the file to a
; more suitable adress.
; -------------------------------------------------------------------

; -------------------------------------------------------------------
; jsr this label to decrunch, it will in turn init the tables and
; call the decruncher
; no constraints on register content, however the
; decimal flag has to be #0 (it almost always is, otherwise do a cld)
decrunch:
; -------------------------------------------------------------------
; init zeropage, x and y regs. (12 bytes)
;
                ldx #3
                ldy #0
init_zp:        jsr getbyte
                bcs exo_error ;Error
                sta zp_bitbuf-1,x
                dex
                bne init_zp
                lda zp_dest_lo
exo_addl:       adc #$00
                sta zp_dest_lo
                lda zp_dest_hi
exo_addh:       adc #$00
                sta zp_dest_hi

; -------------------------------------------------------------------
; calculate tables (49 bytes)
; x and y must be #0 when entering
;
nextone:        inx
                tya
                and #$0f
                beq shortcut		; starta på ny sekvens

                txa			; this clears reg a
                lsr   		; and sets the carry flag
                ldx zp_bits_lo
rolle:          rol
                rol zp_bits_hi
                dex
                bpl rolle		; c = 0 after this (rol zp_bits_hi)

                adc tabl_lo-1,y
                tax

                lda zp_bits_hi
                adc tabl_hi-1,y
shortcut:       sta tabl_hi,y
                txa
                sta tabl_lo,y

                ldx #4
                jsr get_bits		; clears x-reg.
                sta tabl_bi,y
                iny
        	cpy #52
        	bne nextone
        	ldy #0
        	beq begin

; -------------------------------------------------------------------
; get x + 1 bits (1 byte)
;
get_bit1:       inx
; -------------------------------------------------------------------
; get bits (31 bytes)
;
; args:
;   x = number of bits to get
; returns:
;   a = #bits_lo
;   x = #0
;   c = 0
;   zp_bits_lo = #bits_lo
;   zp_bits_hi = #bits_hi
; notes:
;   y is untouched
;   other status bits are set to (a == #0)
; -------------------------------------------------------------------
get_bits:       lda #$00
                sta zp_bits_lo
                sta zp_bits_hi
                cpx #$01
                bcc bits_done
                lda zp_bitbuf
bits_next:      lsr
                bne ok
                 php
                jsr getbyte
                bcs exo_error
                plp
                ror
ok:             rol zp_bits_lo
                rol zp_bits_hi
                dex
                bne bits_next
                sta zp_bitbuf
                lda zp_bits_lo
bits_done:	rts
exo_error:      ldx #$00
                txs
                rts
; -------------------------------------------------------------------
; main copy loop (16 bytes)
;
copy_next_hi:
                dex
                dec zp_dest_hi
                dec zp_src_hi
copy_next:	dey
                lda $01
                sta enableio_01+1
                sei
                lda #$34
                sta $01
                lda (zp_src_lo),y
literal_entry:	sta (zp_dest_lo),y
enableio_01:    lda #$36
                sta $01
                cli
copy_start:	tya
        	bne copy_next
        	txa
        	bne copy_next_hi
; -------------------------------------------------------------------
; decruncher entry point, needs calculated tables (5 bytes)
; x and y must be #0 when entering
;
begin:          jsr get_bit1
                beq sequence
; -------------------------------------------------------------------
; literal handling (13 bytes)
;
literal_start:  lda zp_dest_lo
                bne avoid_hi
                dec zp_dest_hi
avoid_hi:	dec zp_dest_lo
                php
        	jsr getbyte
                bcs exo_error
                plp
                pha
                lda $01
                sta enableio_01+1
                sei
                lda #$34
                sta $01
                pla
                bcc literal_entry
; -------------------------------------------------------------------
; count zero bits + 1 to get length table index (10 bytes)
; y = x = 0 when entering
;
sequence:
next1:  	iny
                jsr get_bit1
                beq next1
                cpy #$11
                bcs bits_done
; -------------------------------------------------------------------
; calulate length of sequence (zp_len) (17 bytes)
;
                ldx tabl_bi - 1,y
                jsr get_bits
                adc tabl_lo - 1,y
                sta zp_len_lo
                lda zp_bits_hi
                adc tabl_hi - 1,y
                pha
; -------------------------------------------------------------------
; here we decide what offset table to use (20 bytes)
; x is 0 here
;
                bne nots123
                ldy zp_len_lo
                cpy #$04
                bcc size123
nots123:	ldy #$03
size123:        ldx tabl_bit - 1,y
        	jsr get_bits
        	adc tabl_off - 1,y
        	tay
; -------------------------------------------------------------------
; prepare zp_dest (11 bytes)
;
                sec
                lda zp_dest_lo
                sbc zp_len_lo
                sta zp_dest_lo
                bcs noborrow
                dec zp_dest_hi
noborrow:
; -------------------------------------------------------------------
; calulate absolute offset (zp_src) (27 bytes)
;
        	ldx tabl_bi,y
        	jsr get_bits
        	adc tabl_lo,y
        	bcc skipcarry
        	inc zp_bits_hi
        	clc
skipcarry:	adc zp_dest_lo
        	sta zp_src_lo
        	lda zp_bits_hi
        	adc tabl_hi,y
        	adc zp_dest_hi
        	sta zp_src_hi
; -------------------------------------------------------------------
; prepare for copy loop (6 bytes)
;
        	ldy zp_len_lo
        	pla
        	tax
        	jmp copy_start
; -------------------------------------------------------------------
; end of decruncher
; -------------------------------------------------------------------

savefilesub:    sta zp_src_lo
                stx zp_src_hi
                jsr kernalon_nocheck
                lda #$05
                ldx #<scratch
                ldy #>scratch
                jsr setnam
                lda #$0f
                tay
                jsr setlfsopen
                lda #$0f
                jsr close
                jsr setfilename
                ldy #$01                  ;Open for write
                ldx fa
                jsr setlfsopen
                jsr chkout
                ldy #$00
sf_loop:        lda (zp_src_lo),y
                jsr chrout
                iny
                bne sf_ok
                inc zp_src_hi
sf_ok:          inc zp_dest_lo
                bne sf_loop
                inc zp_dest_hi
                bne sf_loop

;-------------------------------------------------------------------------------
; KERNALOFF
;
; Ends kernal IO process (closes file and restores $01 value)
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

kernaloff:      lda #$02
                jsr close
                jsr clrchn
kernaloff_01:   lda #$36
                sta $01
                rts

;-------------------------------------------------------------------------------
; KERNALON
;
; Switches Kernal on during loading if required
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

kernalon:       lda fastloadstatus                ;In fake-IRQload mode IRQs
                bmi krnon_ok                      ;continue as usual
kernalon_nocheck:
                lda screen
                cmp #$02
                bcs krnon_ok
krnon_ctsjump:  jsr krnon_donothing               ;Clear textscreen here
                lda #$03                          ;Redraw if in gamescreen
                sta screen                        ;(on next full update)
krnon_ok:       jsr waitraster
                lda $01
                sta kernaloff_01+1
                lda #$36
                sta $01                           ;Wait for one frame (so that
waitraster:     lda $d011                         ;SID voices are switched
                bmi waitraster                    ;off by interrupt)
waitraster2:    lda $d011
                bpl waitraster2
krnon_donothing:rts

;-------------------------------------------------------------------------------
; SETLFSOPEN
; SETFILENAME
;
; Often used subroutines dealing with Kernal file access
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

setlfsopen:     ldx fa
                jsr setlfs
                jsr open
                ldx #$02
ifl_ok:         rts

setfilename:    lda fastloadstatus
                and #$fe
                sta fastloadstatus        ;Fastloader removed from drive, if it
                lda #$02                  ;was there
                ldx #<filename
                ldy #>filename
                jmp setnam

;-------------------------------------------------------------------------------
; SAVEFILE
;
; Saves a file. Restarts fastloader afterwards.
;
; Parameters: filename, A,X:startaddress, zp_dest:length as negative num.
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

savefile:       inc fileopen
                jsr savefilesub
                dec fileopen

;-------------------------------------------------------------------------------
; INITFASTLOAD
;
; Starts/restarts fastloader drivecode. The init routine is loaded from disk
; to conserve memory
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

initfastload:   lda fastloadstatus              ;Deinitted?
                bne ifl_ok
                lda usefastload                 ;Need fastload?
                beq ifl_ok
                lda #$01                        ;Filename 01
                jsr makefilename_direct
                lda #<screen2                   ;Load to screen2
                ldx #>screen2
                jsr loadfile
                bcs ifl_ok                      ;If fail, do not start!
                jmp screen2                     ;(let them slowload!)

nmi:            rti

tabl_bit:       dc.b 2,4,4
tabl_off:       dc.b 48,32,16

usefastload:    dc.b 0
useloadpic:     dc.b 0
scratch:        dc.b "S0:"
filename:       dc.b "00"

loadercodeend:                            ;Resident code ends here!

;-------------------------------------------------------------------------------
; INITLOADER
;
; Inits the loadersystem. Needs to be called only once in the beginning.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

initloader:     sta $d07f                 ;Disable SCPU hardware regs
                sta $d07a                 ;SCPU to slow mode
                lda #<nmi                 ;Set NMI vector
                sta $0318
                sta $fffa
                lda #>nmi
                sta $0319
                sta $fffb
                ldy #$00
                lda #$81                  ;Run Timer A once to disable NMI from Restore keypress
                sta $dd0d                 ;Timer A interrupt source
                lda #$01                  ;Timer A count ($0001)
                sta $dd04
                sty $dd05
                lda #%00011001            ;Run Timer A in one-shot mode
                sta $dd0e
                sty messages              ;Disable KERNAL messages
                sty fastloadstatus        ;Clear fastload & fileopen
                sty fileopen              ;indicators
                lda #$01
                sta ntscflag              ;Assume NTSC
                sta ntscdelay
                sei                       ;Detect PAL/NTSC by measuring
il_detectntsc1: ldx $d011                 ;greatest rasterline number
                bmi il_detectntsc1
il_detectntsc2: ldx $d011
                bpl il_detectntsc2
il_detectntsc3: cpy $d012
                bcs il_detectntsc4
                ldy $d012
il_detectntsc4: ldx $d011
                bmi il_detectntsc3
                cli
                cpy #$20
                bcc il_isntsc             ;PAL
                lda #$2c                  ;Adjust 2-bit fastload transfer
                sta fastload_delay        ;delay
                dec ntscflag
il_isntsc:      rts


