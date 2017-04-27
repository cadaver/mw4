                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level22.map

                org randomacttbl
                incbin bg/level22.lvr

CHBASE          = 182

                org bganimcode
                inc bganimcounter
                lda bganimcounter
                and #$03
                bne bganimdone
                ldx chars+CHBASE*8+7*8+4
                lda chars+CHBASE*8+6*8+4
                sta chars+CHBASE*8+7*8+4
                lda chars+CHBASE*8+5*8+4
                sta chars+CHBASE*8+6*8+4
                lda chars+CHBASE*8+4*8+4
                sta chars+CHBASE*8+5*8+4
                lda chars+CHBASE*8+3*8+4
                sta chars+CHBASE*8+4*8+4
                lda chars+CHBASE*8+2*8+4
                sta chars+CHBASE*8+3*8+4
                lda chars+CHBASE*8+1*8+4
                sta chars+CHBASE*8+2*8+4
                lda chars+CHBASE*8+4
                sta chars+CHBASE*8+1*8+4
                stx chars+CHBASE*8+4
bganimdone:     lda bganimcounter
                and #$0f
                bne bganimdone2
                lda chars+248*8
                eor #%00001000
                sta chars+248*8
bganimdone2:    rts

bganimcounter:  dc.b 0

                org blocks
                incbin bg/level22.blk

                org blkcoltbl
                incbin bg/level22.blc

                org charinfo
                incbin bg/level22.chi

