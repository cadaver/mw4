tm_modejumptbl: dc.w tm_idle
                dc.w tm_turnleft
                dc.w tm_turnright
                dc.w tm_turntotarget
                dc.w tm_free
                dc.w tm_sit
                dc.w tm_anim
                dc.w tm_goto
                dc.w tm_sparsearch
                dc.w tm_patrol
                dc.w tm_alert
                dc.w tm_spar
                dc.w tm_combat
                dc.w tm_combat

coordtbly:      dc.b $00
                dc.b $20
                dc.b $40
                dc.b $60
                dc.b $80
                dc.b $a0
                dc.b $c0
                dc.b $e0

xwavetbl:       dc.b $00
                dc.b $08
                dc.b $18
                dc.b $28
                dc.b $30
                dc.b $28
                dc.b $18
                dc.b $08

coordtblx:      dc.b $00                        ;Tables for rapid conversion
                dc.b $10                        ;from map coords to screen
                dc.b $20                        ;coords
                dc.b $30
                dc.b $40
                dc.b $50
                dc.b $60
                dc.b $70
                dc.b $80
                dc.b $90
                dc.b $a0
                dc.b $b0
                dc.b $c0
                dc.b $d0
                dc.b $e0
                dc.b $f0

itemcolortbl:   dc.b 15,7,1,7

