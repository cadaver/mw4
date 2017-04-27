                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level24.map

                org randomacttbl
                incbin bg/level24.lvr

                org bganimcode
                inc bganimcounter
                lda bganimcounter
                and #$07
                bne bganimdone
                ldy #$00
                ldx chars+176*8+1
bganimloop:     lda chars+176*8+2,y
                sta chars+176*8+1,y
                iny
                cpy #$05
                bcc bganimloop
                stx chars+176*8+6
bganimdone:     lda bganimcounter
                and #$03
                bne bganimdone2
                ldx bganimindex
                ldy #$06
bganimloop3:    jsr bganimsub
                sta chars+192*8,y
                dey
                dey
                bpl bganimloop3
                stx bganimindex
bganimdone2:    ldy #$07
bganimloop2:    lda chars+196*8,y
                eor #%00000111
                sta chars+196*8,y
                lda chars+197*8,y
                eor #%11010000
                sta chars+197*8,y
                dey
                bpl bganimloop2
                rts

bganimsub:      lda randomareastart,x
                and #%11001100
                ora #%10001000
                inx
                rts

bganimcounter:  dc.b 0
bganimindex:    dc.b 0

                org blocks
                incbin bg/level24.blk

                org blkcoltbl
                incbin bg/level24.blc

                org charinfo
                incbin bg/level24.chi

