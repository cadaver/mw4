                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level10.map

                org randomacttbl
                incbin bg/level10.lvr

                org bganimcode
                inc bganimcounter
                lda bganimcounter
                and #$01
                bne bganimdone
                ldx #$01
bganimloop:     ldy snowpos,x
                lda #$ff
                sta chars+$56*8,y
                iny
                tya
                and #$1f
                sta snowpos,x
                inc snowphase,x
                lda snowphase,x
                and #$0f
                tay
                lda snowtbl,y
                ldy snowpos,x
                sta chars+$56*8,y
                dex
                bpl bganimloop
bganimdone:     rts

snowpos:        dc.b 8,20
snowphase:      dc.b 0,10

snowtbl:
                dc.b #%11110011
                dc.b #%11110011
                dc.b #%11111100
                dc.b #%11111100
                dc.b #%11111100
                dc.b #%11111100
                dc.b #%11110011
                dc.b #%11110011
                dc.b #%11001111
                dc.b #%11001111
                dc.b #%00111111
                dc.b #%00111111
                dc.b #%00111111
                dc.b #%00111111
                dc.b #%11001111
                dc.b #%11001111



bganimcounter:  dc.b 0

                org blocks
                incbin bg/level10.blk

                org blkcoltbl
                incbin bg/level10.blc

                org charinfo
                incbin bg/level10.chi

