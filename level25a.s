                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level25.map

                org randomacttbl
                incbin bg/level25.lvr

                org bganimcode
                inc bganimcounter
                lda bganimcounter
                and #$03
                bne bganimdone
                ldy #$02
bganimloop:     ldx chars+220*8,y
                lda chars+221*8,y
                sta chars+220*8,y
                txa
                sta chars+221*8,y
                dey
                bpl bganimloop
                ldx chars+237*8
                ldy #$00
bganimscroll:   lda chars+237*8+1,y
                sta chars+237*8,y
                iny
                cpy #15
                bcc bganimscroll
                stx chars+237*8+15
bganimdone:     lda bganimcounter
                and #$0f
                bne bganimdone2
                lda chars+162*8+2
                eor #%00001000
                sta chars+162*8+2
bganimdone2:    rts

bganimcounter:  dc.b 0

                org blocks
                incbin bg/level25.blk

                org blkcoltbl
                incbin bg/level25.blc

                org charinfo
                incbin bg/level25.chi

