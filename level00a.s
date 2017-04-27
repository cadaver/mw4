                processor 6502

                include define.s

                org map
                incbin bg/level00.map

                org randomacttbl
                incbin bg/level00.lvr

                org bganimcode
                rts

                org blocks
                incbin bg/level00.blk

                org blkcoltbl
                incbin bg/level00.blc

                org charinfo
                incbin bg/level00.chi
