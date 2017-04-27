                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level21.map

                org randomacttbl
                incbin bg/level21.lvr

                org bganimcode
                rts

                org blocks
                incbin bg/level21.blk

                org blkcoltbl
                incbin bg/level21.blc

                org charinfo
                incbin bg/level21.chi

