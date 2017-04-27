                processor 6502
                org $0801

bootcodestart   = $c780

zp_len_lo       = $02
zp_src_lo       = $03
zp_src_hi       = $04
zp_bits_lo      = $fb
zp_bits_hi      = $fc
zp_bitbuf       = $fd
zp_dest_lo      = $fe	; dest addr lo
zp_dest_hi      = $ff	; dest addr hi

tabl_bi = decrunch_table
tabl_lo = decrunch_table + 52
tabl_hi = decrunch_table + 104

sys:            dc.b $0b,$08
                dc.b $0a,$00
                dc.b $9e
                dc.b $32,$30,$36,$31
                dc.b $00
                dc.b $00,$00

start:          cld
                lda $d011
                and #$0f
                sta $d011
                sei
                lda #$34
                sta $01
                ldx #3
                ldy #0
                lda #>(bootcodestart-1)         ;Push startaddress &
                pha                             ;depack
                lda #<(bootcodestart-1)
                pha

; -------------------------------------------------------------------
; no code below this comment has to be modified in order to generate
; a working decruncher of this source file.
; However, you may want to relocate the tables last in the file to a
; more suitable adress.
; -------------------------------------------------------------------
; init zeropage, x and y regs. (12 bytes)
;
init_zp:
	jsr get_byte
	sta zp_bitbuf - 1,x
	dex
	bne init_zp
; -------------------------------------------------------------------
; calculate tables (49 bytes)
; x and y must be #0 when entering
;
nextone:
	inx
	tya
	and #$0f
	beq shortcut		; starta på ny sekvens

	txa			; this clears reg a
	lsr   		; and sets the carry flag
	ldx zp_bits_lo
rolle:
	rol
	rol zp_bits_hi
	dex
	bpl rolle		; c = 0 after this (rol zp_bits_hi)

	adc tabl_lo-1,y
	tax

	lda zp_bits_hi
	adc tabl_hi-1,y
shortcut:
	sta tabl_hi,y
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
get_bit1:
	inx
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
get_bits:
	lda #$00
	sta zp_bits_lo
	sta zp_bits_hi
	cpx #$01
	bcc bits_done
	lda zp_bitbuf
bits_next:
	lsr
	bne ok
	jsr get_byte
	ror
ok:
	rol zp_bits_lo
	rol zp_bits_hi
	dex
	bne bits_next
	sta zp_bitbuf
	lda zp_bits_lo
bits_done:
	rts
; -------------------------------------------------------------------
; main copy loop (16 bytes)
;
copy_next_hi:
	dex
	dec zp_dest_hi
	dec zp_src_hi
copy_next:
	dey
	lda (zp_src_lo),y
literal_entry:
	sta (zp_dest_lo),y
copy_start:
	tya
	bne copy_next
	txa
	bne copy_next_hi
; -------------------------------------------------------------------
; decruncher entry point, needs calculated tables (5 bytes)
; x and y must be #0 when entering
;
begin:
	jsr get_bit1
	beq sequence
; -------------------------------------------------------------------
; literal handling (13 bytes)
;
literal_start:
	lda zp_dest_lo
	bne avoid_hi
	dec zp_dest_hi
avoid_hi:
	dec zp_dest_lo
	jsr get_byte
	bcc literal_entry
; -------------------------------------------------------------------
; count zero bits + 1 to get length table index (10 bytes)
; y = x = 0 when entering
;
sequence:
next1:
	iny
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
nots123:
	ldy #$03
size123:
	ldx tabl_bit - 1,y
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
	jsr get_bits;
	adc tabl_lo,y
	bcc skipcarry
	inc zp_bits_hi
	clc
skipcarry:
	adc zp_dest_lo
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
	bcc copy_start
; -------------------------------------------------------------------
; two small static tables (6 bytes)
;
tabl_bit:
	.byte 2,4,4
tabl_off:
	.byte 48,32,16
; -------------------------------------------------------------------
; end of decruncher
; -------------------------------------------------------------------
; -------------------------------------------------------------------
; this is an example implementation of the get_byte routine.
; You may implement this yourselves to read bytes from any datasource.
; The get_byte routine must not modify the x or y registers nor change
; the carry or decimal flags
; -------------------------------------------------------------------
get_byte:
	lda packeddata
  inc get_byte+1
  bne gbok
  inc get_byte+2
gbok:
  rts

packeddata:     incbin menu.pak
decrunch_table:
