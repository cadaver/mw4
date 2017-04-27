                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level18.map

                org randomacttbl
                incbin bg/level18.lvr

                org bganimcode
                rts

                org blocks
                incbin bg/level18.blk

                org blkcoltbl
                incbin bg/level18.blc

                org charinfo
                incbin bg/level18.chi

