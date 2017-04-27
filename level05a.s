                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level05.map

                org randomacttbl
                incbin bg/level05.lvr

                org bganimcode
                inc bganimdelay
                lda bganimdelay
                and #$03
                bne bganimdone
                ldx bganimindex
                jsr bganimsub
                sta chars+$dc*8+2
                jsr bganimsub
                sta chars+$dd*8+2
                stx bganimindex
bganimdone:     lda bganimdelay
                and #$0f
                bne bganimdone2
                lda chars+$e5*8+1
                eor #%00001000
                sta chars+$e5*8+1
bganimdone2:    rts

bganimsub:      lda randomareastart,x
                and #$03
                tay
                lda lighttbl,y
                inx
                rts

bganimdelay:    dc.b 0
bganimindex:    dc.b 0

lighttbl:       dc.b %01000100
                dc.b %01000111
                dc.b %01110100
                dc.b %01110111

                org blocks
                incbin bg/level05.blk

                org blkcoltbl
                incbin bg/level05.blc

                org charinfo
                incbin bg/level05.chi
