;-------------------------------------------------------------------------------
; RETRYPROMPT
;
; Retry prompt for loading.
;
; Parameters: -
; Returns: -
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

retryprompt:    lda #MSG_FILEERROR
                ldy #MSGTIME_ETERNAL
                jsr printmsg
retryprompt_nomessage:
rp_wait:        jsr getcontrols
                jsr getfireclick
                bcc rp_wait
                jmp resetmessage

;-------------------------------------------------------------------------------
; LOADFILERETRY
;
; Loads a file with retry.
;
; Parameters: filename, A,X:startaddress
; Returns: A=0 OK, A=nonzero -> error
; Modifies: A,X,Y
;-------------------------------------------------------------------------------

loadfileretry:  sta lfr_resta+1
                stx lfr_restx+1
lfr_again:      jsr loadfiledisk
                beq lfr_ok
                jsr retryprompt
lfr_resta:      lda #$00
lfr_restx:      ldx #$00
                bne lfr_again
lfr_ok:         jmp initmap

loadfiledisk:   jsr showdisk
                jsr loadfile
hidedisk:       php
hidedisk_ldy:   ldy #$00
                sty textscreen+21*40+70
                plp
                rts

showdisk:       ldy textscreen+21*40+70
                sty hidedisk_ldy+1
                ldy #";"
                sty textscreen+21*40+70
                rts
