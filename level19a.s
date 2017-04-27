                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level19.map

                org randomacttbl
                incbin bg/level19.lvr

                org bganimcode
                inc bganimdelay
                lda bganimdelay
                and #$0f
                bne bganimdone
                lda chars+241*8
                eor #%00000100
                sta chars+241*8
                lda chars+228*8+4
                eor #%00000001
                sta chars+228*8+4
bganimdone:     rts

bganimdelay:    dc.b 0

                org blocks
                incbin bg/level19.blk

                org blkcoltbl
                incbin bg/level19.blc

                org charinfo
                incbin bg/level19.chi

