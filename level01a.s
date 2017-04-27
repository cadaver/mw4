                processor 6502

                include define.s

                org map
                incbin bg/level01.map

                org randomacttbl
                incbin bg/level01.lvr

                org bganimcode
                rts

                org blocks
                incbin bg/level01.blk

                org blkcoltbl
                incbin bg/level01.blc

                org charinfo
                incbin bg/level01.chi
