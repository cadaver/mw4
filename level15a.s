                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level15.map

                org randomacttbl
                incbin bg/level15.lvr

                org bganimcode
                inc bganimcounter
                lda bganimcounter
                and #$03
                bne bganimdone
                ldy #05
                ldx bganimindex
bganimloop:     lda randomareastart,x
                inx
                and #%00001100
                ora #%00001000
                sta bganimlda+1
                lda chars+209*8,y
                and #%11110000
bganimlda:      ora #$00
                sta chars+209*8,y
                lda randomareastart,x
                inx
                and #%11001100
                ora #%10001000
                sta chars+210*8,y
                dey
                bpl bganimloop
                stx bganimindex
bganimdone:     lda bganimcounter
                and #$0f
                bne bganimdone2
                lda chars+248*8
                eor #%00001000
                sta chars+248*8
bganimdone2:    rts

bganimcounter:  dc.b 0
bganimindex:    dc.b 0

                org blocks
                incbin bg/level15.blk

                org blkcoltbl
                incbin bg/level15.blc

                org charinfo
                incbin bg/level15.chi

