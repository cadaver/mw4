;-------------------------------------------------------------------------------
; RANDOM
;
; Returns a 8bit pseudorandom number.
;
; Parameters: -
; Returns: A:number ($00-$ff)
; Modifies: A
;-------------------------------------------------------------------------------

random:         inc randomadd+1
                bne randomseed
                lda randomadd+2
                cmp #>randomareaend-1
                bcc randomok
                lda #>randomareastart-2
randomok:       adc #$01
                sta randomadd+2
randomseed:     lda #$00
randomadd:      eor randomareastart
                adc #$3b
                sta randomseed+1
                rts

;-------------------------------------------------------------------------------
; MULU
;
; Unsigned multiplication
;
; Parameters: A:first value to be multiplied
;             Y:second value to be multiplied
;             X:zeropage base
; Returns:    zeropage:Result
;             A:highbyte of result
; Modifies:   A,X,Y
;-------------------------------------------------------------------------------

mulu:           sta $00,x
                tya
                beq mulu_zero
                dey
                sty $01,x
                ldy #$07
                lda #$00
                lsr $00,x
                bcc mulu_shift1
                adc $01,x
mulu_shift1:    ror
                ror $00,x
                bcc mulu_shift2
                adc $01,x
mulu_shift2:    dey
                bne mulu_shift1
mulu_shift8:    ror
                sta $01,x
                ror $00,x
                rts
mulu_zero:      sta $00,x
                sta $01,x
                rts

;-------------------------------------------------------------------------------
; DIVU
;
; Unsigned divide
;
; Parameters: A:value to be divided
;             Y:divider
;             X:zeropage base
; Returns:    zeropage:Result
;             A:remainder
; Modifies:   A,X,Y
;-------------------------------------------------------------------------------

divu:           sta $00,x
                tya
                sta $01,x
                lda #$00
                asl $00,x
                ldy #$07
divu_loop:      rol
                cmp $01,x
                bcc divu_skip
                sbc $01,x
divu_skip:      rol $00,x
                dey
                bpl divu_loop
                rts

;-------------------------------------------------------------------------------
; ASR
;
; Arithmetic shift right.
;
; Parameters: A:number. Flags must reflect its value!
;             Y:bits to shift
; Returns: A:number
; Modifies: A,Y
;-------------------------------------------------------------------------------

asr:            bmi asr_neg
asr_pos:        lsr
                dey
                bne asr_pos
                rts
asr_neg:        lsr
                ora #$80
                dey
                bne asr_neg
                rts

;-------------------------------------------------------------------------------
; NEGATE
;
; 2's complement negation.
;
; Parameters: A:number.
; Returns: A:number negated
; Modifies: A
;-------------------------------------------------------------------------------

negate:         clc
                eor #$ff
                adc #$01
                rts
