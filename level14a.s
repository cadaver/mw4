                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level14.map

                org randomacttbl
                incbin bg/level14.lvr

                org bganimcode
                rts

                org blocks
                incbin bg/level14.blk

                org blkcoltbl
                incbin bg/level14.blc

                org charinfo
                incbin bg/level14.chi

