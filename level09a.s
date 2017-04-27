                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level09.map

                org randomacttbl
                incbin bg/level09.lvr

                org bganimcode
                inc bganimcounter
                lda bganimcounter
                and #$07
                bne bganimdone
                lda chars+$41*8+2
                clc
                adc #%00000001
                and #%00000011
                ora #%11111100
                sta chars+$41*8+2
                lda chars+$42*8+5
                clc
                adc #%00000100
                and #%00001100
                ora #%11110011
                sta chars+$42*8+5
                lda chars+$43*8+7
                clc
                adc #%00000001
                and #%00000011
                ora #%11111100
                sta chars+$43*8+7
bganimdone:     rts

bganimcounter:  dc.b 0

                org blocks
                incbin bg/level09.blk

                org blkcoltbl
                incbin bg/level09.blc

                org charinfo
                incbin bg/level09.chi
