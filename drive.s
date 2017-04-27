;-------------------------------------------------------------------------------
; MW4 fastloader drivepart
;
; 1581/CMD FD/CMD HD info from Wolfram Sang (Ninja/The Dreams) and
; Christoph Thelen (Doc Bacardi/The Dreams)
; 2MHz 2-bit transfer code by Per Olofsson (MagerValp)
;-------------------------------------------------------------------------------

                processor 6502

                include define.s
                include loadsym.s

                org screen2

MAXFILES        = 128           ;Max. files to buffer

RETRIES         = 5             ;Retries when reading a sector

IRQ_SPEED       = $28           ;$1c07 (head movement speed)
                                ;Safe range $20-$28+ (Graham)

MW_DATA_LENGTH  = 32            ;Bytes in one M-W command

iddrv0          = $12           ;Disk drive ID (1541 only)
id              = $16           ;Disk ID (1541 only)

buf             = $0400         ;Sector data buffer
serial          = $1800         ;Serial bus register (1541)

drv_filetrk     = $0300         ;Drive memory map
drv_filesct     = $0380
drvstart        = $0452
drv_fileletter1 = $0700
drv_fileletter2 = $0780

initialize      = $d005         ;1541 only

ifl:            lda #$aa
                sta $a5
                jsr kernalon
                ldy #$00
                lda #(drivecodeend-drivecodestart+MW_DATA_LENGTH-1)/MW_DATA_LENGTH
                sta loadtempreg           ;Number of "packets" to send
                bne ifl_nextpacket
ifl_sendmw:     lda ifl_mwstring,x        ;Send M-W command (backwards)
                jsr ciout
                dex
                bpl ifl_sendmw
                ldx #MW_DATA_LENGTH
ifl_senddata:   lda drivecodestart,y      ;Send one byte of drivecode
                jsr ciout
                iny
                bne ifl_notover
                inc ifl_senddata+2
ifl_notover:    inc ifl_mwstring+2        ;Also, move the M-W pointer forward
                bne ifl_notover2
                inc ifl_mwstring+1
ifl_notover2:   dex
                bne ifl_senddata
                jsr unlsn                 ;Unlisten to perform the command
ifl_nextpacket: lda fa                    ;Set drive to listen
                jsr listen
                lda status                ;Quit if serial error (probably IDE64)
                cmp #$c0
                beq ifl_noserial
                lda #$6f
                jsr second
                ldx #$05
                dec loadtempreg           ;All "packets" sent?
                bpl ifl_sendmw
                dex
ifl_sendme:     lda ifl_mestring,x        ;Send M-E command (backwards)
                jsr ciout
                dex
                bpl ifl_sendme
                jsr unlsn
                jsr kernaloff_01
                lda $a5                   ;Serial delay counter untouched?
                cmp #$aa
                beq ifl_noserial          ;Probably fast drive emulation then
                lda #$01                  ;Fastloader (ordinary mode) active
                sta fastloadstatus
                rts
                
ifl_noserial:   lda #$80                  ;Fake-IRQload mode
                sta fastloadstatus
                rts

;-------------------------------------------------------------------------------
; DRIVECODE - Code executed in the disk drive.
;-------------------------------------------------------------------------------

drivecodestart:                           ;Address in C64's memory
                rorg drvstart             ;Address in diskdrive's memory

                lda $fea0                 ;Recognize drive family
                ldx #3                    ;(from Dreamload)
drv_floop:      cmp drv_family-1,x
                beq drv_ffound
                dex                       ;If unrecognized, assume 1541
                bne drv_floop
                beq drv_idfound
drv_ffound:     lda drv_idloclo-1,x
                sta drv_idlda+1
                lda drv_idlochi-1,x
                sta drv_idlda+2
drv_idlda:      lda $fea4                 ;Recognize drive type
                ldx #3                    ;3 = CMD HD
drv_idloop:     cmp drv_id-1,x            ;2 = CMD FD
                beq drv_idfound           ;1 = 1581
                dex                       ;0 = 1541
                bne drv_idloop
drv_idfound:    stx drv_drivetype+1       ;Store drive type
                lda drv_1800lo,x
                sta drv_patch1800lo+1
                lda drv_1800hi,x
                sta drv_patch1800hi+1
                ldy #10
drv_patchloop:  ldx drv_1800ofs,y
drv_patch1800lo:lda #$00                  ;Patch all $1800 accesses
                sta drvmain+1,x
drv_patch1800hi:lda #$00
                sta drvmain+2,x
                dey
                bpl drv_patchloop
                ldx drv_drivetype+1       ;On 1541, speedup controller IRQs
                bne drv_skip1c07          ;and copy the 1MHz send code
                lda #IRQ_SPEED
                sta $1c07
                ldy #drv_1mhzsenddone-drv_1mhzsend-1
drv_copysendcode:
                lda drvend,y
                sta drv_2mhzsend,y
                dey
                bpl drv_copysendcode

drv_skip1c07:   lda drv_dirtrklo,x        ;Patch directory
                sta drv_dirtrk+1
                lda drv_dirtrkhi,x
                sta drv_dirtrk+2
                lda drv_dirsctlo,x
                sta drv_dirsct+1
                lda drv_dirscthi,x
                sta drv_dirsct+2
                lda drv_execlo,x          ;Patch job exec address
                sta drv_execjsr+1
                lda drv_exechi,x
                sta drv_execjsr+2
                lda drv_jobtrklo,x        ;Patch job track/sector
                sta drv_readtrk+1
                clc
                adc #$01
                sta drv_readsct+1
                lda drv_jobtrkhi,x
                sta drv_readtrk+2
                adc #$00
                sta drv_readsct+2
                lda drv_ledenabled,x             ;Patch LED flashing
                sta drv_led
                lda drv_ledbit,x
                sta drv_led+1
                lda drv_ledadrhi,x
                sta drv_ledacc1+2
                sta drv_ledacc2+2

drvmain:        jsr drv_cachedir          ;Always cache on startup
drv_loop:       cli
                ldx #$01
drv_nameloop:   ldy #$08                  ;Bit counter
drv_namebitloop:
drv_1800ac0:    lda $1800
                bpl drv_noquit            ;Quit if ATN is low
drv_drivetype:  lda #$00                  ;1541 = exit through Initialize
                bne drv_not1541           ;Others = exit through RTS
                lda #$3a                  ;Restore default speed
                sta $1c07
                jmp initialize
drv_not1541:    rts

drv_noquit:     and #$05                  ;Wait for CLK or DATA going low
                beq drv_namebitloop
                lsr                       ;Read the data bit
                lda #$02	              ;Pull the other line low to acknowledge
                bcc drv_namezero
                lda #$08
drv_namezero:   ror drv_filename,x        ;Store the data bit
drv_1800ac1:    sta $1800
drv_namewait:
drv_1800ac2:    lda $1800                 ;Wait for either line going high
                and #$05
                cmp #$05
                beq drv_namewait
                lda #$00
drv_1800ac3:    sta $1800	              ;Set both lines high
                dey
                bne drv_namebitloop       ;Loop until all bits have been received
                sei                       ;Disable interrupts after first byte
                dex
                bpl drv_nameloop

                lda drv_dircached         ;Cache directory if necessary
                bne drv_dircacheok
                jsr drv_cachedir
drv_dircacheok:
drv_searchname: lda drv_fileletter1,y
                cmp drv_filename
                bne drv_searchnext
                lda drv_fileletter2,y
                cmp drv_filename+1
                beq drv_found
drv_searchnext: iny
                cpy drv_dircached
                bcc drv_searchname
drv_filenotfound:
                lda #$00                  ;If file not found, reset caching
                sta drv_dircached
                ldx #$02                  ;Return code $02 = File not found
drv_loadend:    stx buf+2
                lda #$00
                sta buf
                sta buf+1
                beq drv_sendblk

drv_found:      ldx drv_filetrk,y
                lda drv_filesct,y
                jmp drv_firstsect

drv_nextsect:   ldx buf,y                 ;File found, get starting T&S
                beq drv_loadend           ;At file's end? (return code $00 = OK)
                lda buf+1,y
drv_firstsect:  tay
                jsr drv_readsector        ;Read the data sector
                bcs drv_loadend
drv_sendblk:    ldy #$00
                ldx #$02
drv_sendloop:   lda buf,y
                lsr
                lsr
                lsr
                lsr
drv_1800ac4:    stx $1800               ;Set DATA=low for first byte, high for
                tax                     ;subsequent bytes
                lda drv_sendtbl,x
                pha
                lda buf,y
                and #$0f
                tax
                lda #$04
drv_1800ac5:    bit $1800               ;Wait for CLK=low
                beq drv_1800ac5
                lda drv_sendtbl,x
drv_1800ac6:    sta $1800

        ; 2MHz send timing code from ULoad3 by MagerValp

drv_2mhzsend:   jsr drv_delay18
                nop
                asl
                and #$0f
drv_1800ac7:    sta $1800
                cmp ($00,x)
                nop
                pla
drv_1800ac8:    sta $1800
                cmp ($00,x)
                nop
                asl
                and #$0f
drv_1800ac9:    sta $1800
                ldx #$00
                iny
                bne drv_sendloop
                jsr drv_delay12
drv_1800ac10:   stx $1800                 ;Finish send: DATA & CLK both high

drv_senddone:   lda buf                   ;First 2 bytes zero marks end of loading
                ora buf+1                 ;(3rd byte is the return code)
                bne drv_nextsect
                jmp drv_loop

drv_readsector: jsr drv_led
drv_readtrk:    stx $1000
drv_readsct:    sty $1000
                ldy #RETRIES            ;Retry counter
drv_retry:      lda #$80
                ldx #1
drv_execjsr:    jsr drv_1541exec        ;Exec buffer 1 job
                cmp #$02                ;Error?
                bcc drv_success
drv_skipid:     dey                     ;Decrease retry counter
                bne drv_retry
drv_failure:    ldx #$01                ;Return code $01 - Read error
drv_success:    sei                     ;Make sure interrupts now disabled
drv_led:        lda #$08                ;Flash the drive LED
drv_ledacc1:    eor $1c00
drv_ledacc2:    sta $1c00
                rts

drv_cachedir:
drv_dirtrk:     ldx $1000
drv_dirsct:     ldy $1000                 ;Read disk directory
drv_dirloop:    jsr drv_readsector        ;Read sector
                bcs drv_dircachedone      ;If failed, abort caching
                ldy #$02
drv_nextfile:   lda buf,y                 ;File type must be PRG
                and #$83
                cmp #$82
                bne drv_skipfile
                lda buf+5,y               ;Must be two-letter filename
                cmp #$a0                  ;(MW4 datafiles)
                bne drv_skipfile
                ldx drv_dircached
                cpx #MAXFILES
                bcs drv_dircachedone
                lda buf+1,y
                sta drv_filetrk,x
                lda buf+2,y
                sta drv_filesct,x
                lda buf+3,y
                sta drv_fileletter1,x
                lda buf+4,y
                sta drv_fileletter2,x
                inc drv_dircached
drv_skipfile:   tya
                clc
                adc #$20
                tay
                bcc drv_nextfile
                ldy buf+1                 ;Go to next directory block, until no
                ldx buf	                  ;more directory blocks
                bne drv_dirloop
drv_dircachedone:
                rts

drv_1541exec:   tax
                cli                       ;Allow interrupts & execute command
                stx $01
drv_1541execwait:
                lda $01
                bmi drv_1541execwait
                pha
                ldx #$02
drv_checkid:    lda id-1,x                ;Check for disk ID change
                cmp iddrv0-1,x            ;(1541 only)
                beq drv_idok
                sta iddrv0-1,x
                lda #$00                  ;If changed, force recache of dir
                sta drv_dircached
drv_idok:       dex
                bne drv_checkid
                pla
                rts

drv_fdexec:     jsr $ff54                 ;FD2000 fix By Ninja
                lda $03
                rts

drv_delay18:     cmp ($00,x)
drv_delay12:     rts

drv_1541dirtrk: dc.b 18
drv_1541dirsct: dc.b 1
drv_1581dirsct: dc.b 3

drv_dircached:  dc.b 0

drv_sendtbl:    dc.b $0f,$07,$0d,$05
                dc.b $0b,$03,$09,$01
                dc.b $0e,$06,$0c,$04
                dc.b $0a,$02,$08,$00

drv_filename:

drv_family:     dc.b $43,$0d,$ff
drv_idloclo:    dc.b $a4,$c6,$e9
drv_idlochi:    dc.b $fe,$e5,$a6
drv_id:         dc.b "8","F","H"

drv_1800ofs:    dc.b drv_1800ac0-drvmain
                dc.b drv_1800ac1-drvmain
                dc.b drv_1800ac2-drvmain
                dc.b drv_1800ac3-drvmain
                dc.b drv_1800ac4-drvmain
                dc.b drv_1800ac5-drvmain
                dc.b drv_1800ac6-drvmain
                dc.b drv_1800ac7-drvmain
                dc.b drv_1800ac8-drvmain
                dc.b drv_1800ac9-drvmain
                dc.b drv_1800ac10-drvmain

drv_1800lo:     dc.b <$1800,<$4001,<$4001,<$8000
drv_1800hi:     dc.b >$1800,>$4001,>$4001,>$8000

drv_dirtrklo:   dc.b <drv_1541dirtrk,<$022b,<$54,<$2ba7
drv_dirtrkhi:   dc.b >drv_1541dirtrk,>$022b,>$54,>$2ba7
drv_dirsctlo:   dc.b <drv_1541dirsct,<drv_1581dirsct,<$56,<$2ba9
drv_dirscthi:   dc.b >drv_1541dirsct,>drv_1581dirsct,>$56,>$2ba9

drv_execlo:     dc.b <drv_1541exec,<$ff54,<drv_fdexec,<$ff4e
drv_exechi:     dc.b >drv_1541exec,>$ff54,>drv_fdexec,>$ff4e

drv_jobtrklo:   dc.b <$0008,<$000d,<$000d,<$2802
drv_jobtrkhi:   dc.b >$0008,>$000d,>$000d,>$2802

drv_ledenabled:  dc.b $a9,$a9,$a9,$60
drv_ledbit:      dc.b $08,$40,$40,$00
drv_ledadrhi:    dc.b $1c,$40,$40,$40

drvend:
                rorg drv_2mhzsend

drv_1mhzsend:   asl
                and #$0f
drv_1800ac7b:   sta $1800
                pla
drv_1800ac8b:   sta $1800
                asl
                and #$0f
drv_1800ac9b:   sta $1800
                ldx #$00
                iny
                bne drv_sendloop
                nop
drv_1800ac10b:  stx $1800                 ;Finish send: DATA & CLK both high
                jmp drv_senddone
drv_1mhzsenddone:

                rend

drivecodeend:

ifl_mwstring:   dc.b MW_DATA_LENGTH,>drvstart, <drvstart,"W-M"
ifl_mestring:   dc.b >drvstart, <drvstart, "E-M"


