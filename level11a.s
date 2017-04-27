                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level11.map

                org randomacttbl
                incbin bg/level11.lvr

                org bganimcode
                inc bganimcounter
                lda bganimcounter
                and #$03
                bne bganimdone
                ldx chars+247*8
                ldy #$00
bganimscroll:   lda chars+247*8+1,y
                sta chars+247*8,y
                iny
                cpy #15
                bcc bganimscroll
                stx chars+247*8+15
                ldy #$02
bganimloop:     ldx chars+220*8,y
                lda chars+221*8,y
                sta chars+220*8,y
                txa
                sta chars+221*8,y
                dey
                bpl bganimloop
bganimdone:     lda bganimcounter
                and #$01
                bne bganimdone2
                lda chars+232*8+2
                eor #%10101010
                sta chars+232*8+2
bganimdone2:    lda bganimcounter
                and #$0f
                bne bganimdone3
                lda chars+207*8
                eor #%00100000
                sta chars+207*8
bganimdone3:    rts

bganimcounter:  dc.b 0

                org blocks
                incbin bg/level11.blk

                org blkcoltbl
                incbin bg/level11.blc

                org charinfo
                incbin bg/level11.chi

