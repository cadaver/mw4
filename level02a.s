                processor 6502

                include define.s

                org map
                incbin bg/level02.map

                org randomacttbl
                incbin bg/level02.lvr

                org bganimcode
                rts

                org blocks
                incbin bg/level02.blk

                org blkcoltbl
                incbin bg/level02.blc

                org charinfo
                incbin bg/level02.chi
