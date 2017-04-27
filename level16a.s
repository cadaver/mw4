                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level16.map

                org randomacttbl
                incbin bg/level16.lvr

                org bganimcode
                rts

                org blocks
                incbin bg/level16.blk

                org blkcoltbl
                incbin bg/level16.blc

                org charinfo
                incbin bg/level16.chi

