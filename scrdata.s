colorjmptbllo:  dc.b <sc_upleft
                dc.b <sc_up
                dc.b <sc_upright
                dc.b <sc_left
                dc.b <sc_donothing
                dc.b <sc_right
                dc.b <sc_downleft
                dc.b <sc_down
                dc.b <sc_downright

colorjmptblhi:  dc.b >sc_upleft
                dc.b >sc_up
                dc.b >sc_upright
                dc.b >sc_left
                dc.b >sc_donothing
                dc.b >sc_right
                dc.b >sc_downleft
                dc.b >sc_down
                dc.b >sc_downright

drawjmptbllo:   dc.b <ss_drawupleft
                dc.b <ss_drawup
                dc.b <ss_drawupright
                dc.b <ss_drawleft
                dc.b <ss_drawdonothing
                dc.b <ss_drawright
                dc.b <ss_drawdownleft
                dc.b <ss_drawdown
                dc.b <ss_drawdownright

drawjmptblhi:   dc.b >ss_drawupleft
                dc.b >ss_drawup
                dc.b >ss_drawupright
                dc.b >ss_drawleft
                dc.b >ss_drawdonothing
                dc.b >ss_drawright
                dc.b >ss_drawdownleft
                dc.b >ss_drawdown
                dc.b >ss_drawdownright

shiftsrctbl:    dc.b 0,0,1
                dc.b 40,40,41
                dc.b 80,80,81

shiftdesttbl:   dc.b 1,0,0
                dc.b 1,0,0
                dc.b 1,0,0

shiftworktbl:   dc.b 39,39,38
                dc.b 39,39,38
                dc.b 39,39,38

cpr_tbl:        dc.b $01,$02,$03,$80
                dc.b $05,$06,$07,$84
                dc.b $09,$0a,$0b,$88
                dc.b $0d,$0e,$0f,$8c

cpd_tbl:        dc.b $04,$05,$06,$07
                dc.b $08,$09,$0a,$0b
                dc.b $0c,$0d,$0e,$0f
                dc.b $80,$81,$82,$83

scradrtblhi:    dc.b >screen1, >screen2, >screen1, >screen2

sc_downjumptbllo:dc.b <sc_down0
                dc.b <sc_down1
                dc.b <sc_down2
                dc.b <sc_down3

sc_downjumptblhi:dc.b >sc_down0
                dc.b >sc_down1
                dc.b >sc_down2
                dc.b >sc_down3

sc_upjumptbllo: dc.b <sc_up0
                dc.b <sc_up1
                dc.b <sc_up2
                dc.b <sc_up3

sc_upjumptblhi: dc.b >sc_up0
                dc.b >sc_up1
                dc.b >sc_up2
                dc.b >sc_up3

slopetbl:       dc.b $00,$00,$00,$00,$00,$00,$00,$00    ;Slope 0
                dc.b $00,$00,$00,$00,$00,$00,$00,$00    ;Slope 1
                dc.b $38,$30,$28,$20,$18,$10,$08,$00    ;Slope 2
                dc.b $00,$08,$10,$18,$20,$28,$30,$38    ;Slope 3
                dc.b $38,$38,$30,$30,$28,$28,$20,$20    ;Slope 4
                dc.b $18,$18,$10,$10,$08,$08,$00,$00    ;Slope 5
                dc.b $00,$00,$08,$08,$10,$10,$18,$18    ;Slope 6
                dc.b $20,$20,$28,$28,$30,$30,$38,$38    ;Slope 7

sprontbl:       dc.b %00000000
                dc.b %10000000
                dc.b %11000000
                dc.b %11100000
                dc.b %11110000
                dc.b %11111000
                dc.b %11111100
                dc.b %11111110
                dc.b %11111111

sfxchntbl:      dc.b 0,7,14

d018tbl:        dc.b $0e, $1e, $0e, $0e
frameptrtbl:    dc.b >(screen1+$3f8)
                dc.b >(screen2+$3f8)
                dc.b >(textscreen+$3f8)
                dc.b >(textscreen+$3f8)

rspr_yjumptbl:  dc.b <rspr_loady0
                dc.b <rspr_loady1
                dc.b <rspr_loady2
                dc.b <rspr_loady3
                dc.b <rspr_loady4
                dc.b <rspr_loady5
                dc.b <rspr_loady6
                dc.b <rspr_loady7

rspr_rjumptbl:  dc.b <rspr_loadr0
                dc.b <rspr_loadr1
                dc.b <rspr_loadr2
                dc.b <rspr_loadr3
                dc.b <rspr_loadr4
                dc.b <rspr_loadr5
                dc.b <rspr_loadr6
                dc.b <rspr_loadr7

keyrowbit:      dc.b $fe,$fd,$fb,$f7,$ef,$df,$bf,$7f
