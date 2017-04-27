                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level12.map

                org randomacttbl
                incbin bg/level12.lvr

                org bganimcode
                lda chars+$66*8+15
                sta bganimstore1+1
                ldy #14
bganimloop:     lda chars+$66*8,y
                sta chars+$66*8+1,y
                dey
                bpl bganimloop
bganimstore1:   lda #$00
                sta chars+$66*8
                inc bganimcounter
                lda bganimcounter
                and #$03
                bne bganimskip
                lda chars+$68*8+2
                ldx chars+$68*8+3
                sta chars+$68*8+3
                stx chars+$68*8+2
bganimskip:     lda bganimcounter
                and #$01
                bne bganimskip2
                lda chars+$68*8+7
                sta bganimstore2+1
                ldy #2
bganimloop2:    lda chars+$68*8+4,y
                sta chars+$68*8+5,y
                dey
                bpl bganimloop2
bganimstore2:   lda #$00
                sta chars+$68*8+4
bganimskip2:    rts

bganimcounter:  dc.b 0

                org blocks
                incbin bg/level12.blk

                org blkcoltbl
                incbin bg/level12.blc

                org charinfo
                incbin bg/level12.chi

