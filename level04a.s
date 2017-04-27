                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level04.map

                org randomacttbl
                incbin bg/level04.lvr

                org bganimcode
                lda chars+$8f*8+15
                sta bganimstore1+1
                ldy #14
bganimloop:     lda chars+$8f*8,y
                sta chars+$8f*8+1,y
                dey
                bpl bganimloop
bganimstore1:   lda #$00
                sta chars+$8f*8
                inc bganimcounter+1
bganimcounter:  lda #$00
                and #$01
                bne bganimskip
bganimindex:    ldx #$00
                lda randomareastart,x
                and #%01010101
                sta chars+$91*8+4
                inx
                lda randomareastart,x
                ora #%10101010
                sta chars+$91*8+5
                eor #%01010101
                sta chars+$91*8+7
                inx
                lda randomareastart,x
                and #$0e
                tay
                lda chars+$8f*8,y
                eor #%00010001
                sta chars+$8f*8,y
                stx bganimindex+1
bganimskip:     rts

                org blocks
                incbin bg/level04.blk

                org blkcoltbl
                incbin bg/level04.blc

                org charinfo
                incbin bg/level04.chi
