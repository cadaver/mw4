                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level23.map

                org randomacttbl
                incbin bg/level23.lvr

                org bganimcode
                inc bganimdelay
                lda bganimdelay
                and #$0f
                bne bganimdone
                lda chars+178*8
                eor #%00001000
                sta chars+178*8
bganimdone:     lda bganimdelay
                and #$07
                bne bganimdone2
                ldx bganimindex
                lda randomareastart,x
                ora #%10101010
                sta chars+153*8
                inx
                lda randomareastart,x
                ora #%11011101
                sta chars+153*8+1
                inx
                lda randomareastart,x
                ora #%10101010
                sta chars+154*8
                inx
                lda randomareastart,x
                ora #%11011101
                sta chars+154*8+1
                inx
                stx bganimindex
bganimdone2:    rts

bganimdelay:    dc.b 0
bganimindex:    dc.b 0

                org blocks
                incbin bg/level23.blk

                org blkcoltbl
                incbin bg/level23.blc

                org charinfo
                incbin bg/level23.chi

