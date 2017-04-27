                processor 6502

                include define.s
                include extern.s

                org map
                incbin bg/level26.map

                org randomacttbl
                incbin bg/level26.lvr

                org bganimcode
                rts

                org blocks
                incbin bg/level26.blk

                org blkcoltbl
                incbin bg/level26.blc

                org charinfo
                incbin bg/level26.chi

