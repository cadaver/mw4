                processor 6502

                include define.s
                include loadsym.s

                org loadercodeend

                include raster.s
                include sprite.s
                include screen.s
                include sound.s
                include control.s
                include math.s
                include file.s
                include level.s
                include actor.s
                include item.s
                include gamemenu.s
                include ai.s
                include weapon.s
                include player.s
                include others.s
                include script.s
                include plot.s
                include main.s
                include sprdata.s
                include scrdata.s
                include snddata.s
                include ctrldata.s
                include actdata.s
                include lvldata.s
                include itemdata.s
                include gmdata.s
                include aidata.s
                include var.s
                include init.s                  ;This belongs to init data and
                                                ;will be overwritten


