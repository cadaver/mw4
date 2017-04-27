                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level07.map

                org randomacttbl
                incbin bg/level07.lvr

                org bganimcode
                rts

                org blocks
                incbin bg/level07.blk

                org blkcoltbl
                incbin bg/level07.blc

                org charinfo
                incbin bg/level07.chi
