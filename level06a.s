                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level06.map

                org randomacttbl
                incbin bg/level06.lvr

                org bganimcode
                inc bganimcounter
                lda bganimcounter
                and #$03
                bne bganimdone
                ldy #$02
bganimloop:     ldx chars+229*8,y
                lda chars+230*8,y
                sta chars+229*8,y
                txa
                sta chars+230*8,y
                dey
                bpl bganimloop
                ldx bganimindex
                lda randomareastart,x
                sta bganimtemp
                ldy #6
bganimloop2:    lda #%00000010
                lsr bganimtemp
                adc #$00
                asl
                asl
                ora #%00010001
                sta chars+200*8,y
                dey
                dey
                bpl bganimloop2
                inx
                stx bganimindex
bganimdone:     lda bganimcounter
                and #$0f
                bne bganimdone2
                lda chars+212*8
                eor #%00001000
                sta chars+212*8
bganimdone2:    rts


bganimcounter:  dc.b 0
bganimindex:    dc.b 0
bganimtemp:     dc.b 0

                org blocks
                incbin bg/level06.blk

                org blkcoltbl
                incbin bg/level06.blc

                org charinfo
                incbin bg/level06.chi
