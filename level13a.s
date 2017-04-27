                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level13.map

                org randomacttbl
                incbin bg/level13.lvr

                org bganimcode
                inc bganimcounter
                lda bganimcounter
                and #$03
                bne bganimdone
                ldy #$02
bganimloop:     ldx chars+173*8,y
                lda chars+174*8,y
                sta chars+173*8,y
                txa
                sta chars+174*8,y
                dey
                bpl bganimloop
bganimdone:     lda bganimcounter
                and #$0f
                bne bganimdone2
                lda chars+230*8
                eor #%00100000
                sta chars+230*8
bganimdone2:    rts

bganimcounter:  dc.b 0

                org blocks
                incbin bg/level13.blk

                org blkcoltbl
                incbin bg/level13.blc

                org charinfo
                incbin bg/level13.chi

