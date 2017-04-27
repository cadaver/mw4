                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level20.map

                org randomacttbl
                incbin bg/level20.lvr

                org bganimcode
                rts

                org blocks
                incbin bg/level20.blk

                org blkcoltbl
                incbin bg/level20.blc

                org charinfo
                incbin bg/level20.chi

