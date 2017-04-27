                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level17.map

                org randomacttbl
                incbin bg/level17.lvr

                org bganimcode
                inc bganimdelay
                lda bganimdelay
                and #$03
                bne bganimdone
                ldx bganimindex
                jsr bganimsub
                sta chars+128*8+2
                jsr bganimsub
                sta chars+129*8+2
                jsr bganimsub2
                sta chars+161*8+3
                jsr bganimsub2
                sta chars+161*8+5
                stx bganimindex
bganimdone:     lda bganimdelay
                and #$0f
                bne bganimdone2
                lda chars+152*8
                eor #%00100000
                sta chars+152*8
                lda chars+217*8+3
                eor #%00100000
                sta chars+217*8+3
bganimdone2:    rts

bganimsub:      lda randomareastart,x
                and #$03
                tay
                lda lighttbl,y
                inx
                rts

bganimsub2:     lda randomareastart,x
                and #%00110000
                ora #%00100110
                inx
                rts

lighttbl:       dc.b %01000100
                dc.b %01000111
                dc.b %01110100
                dc.b %01110111

bganimdelay:    dc.b 0
bganimindex:    dc.b 0

                org blocks
                incbin bg/level17.blk

                org blkcoltbl
                incbin bg/level17.blc

                org charinfo
                incbin bg/level17.chi

