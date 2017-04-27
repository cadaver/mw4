                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level03.map

                org randomacttbl
                incbin bg/level03.lvr

                org bganimcode
                inc animcounter
                lda animcounter
                and #$03
                bne animdone
                ldx animindex
                ldy #$00
animloop:       lda randomareastart,x
                and #%11000011
                ora #%10010110
                sta chars+219*8,y
                inx
                iny
                iny
                cpy #$08
                bcc animloop
                stx animindex
animdone:       rts

animindex:      dc.b 0
animcounter:    dc.b 0

                org blocks
                incbin bg/level03.blk

                org blkcoltbl
                incbin bg/level03.blc

                org charinfo
                incbin bg/level03.chi
