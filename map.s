                include extern.s

                org map
                incbin bg/map.chr

                org map+$5a0
                incbin bg/map.clr

                org map+$800

                dc.b $40,$41,$42,$43,$44,$45," SUB-CITY     "
                dc.b $46,$47,$48,$49,$4a,$4b,"              "
                dc.b $4c,$4d,$4e,$4f,$50,$51,"              "

                dc.b $52,$53,$54,$55,$56,$57," THE 'FARM'   "
                dc.b $58,$59,$5a,$5b,$5c,$5d,"              "
                dc.b $5e,$5f,$60,$61,$62,$63,"              "

                dc.b $64,$65,$66,$67,$68,$69," AGENT HQ     "
                dc.b $6a,$6b,$6c,$6d,$6e,$6f,"              "
                dc.b $70,$71,$72,$73,$74,$75,"              "

                dc.b $76,$77,$78,$79,$7a,$7b," GOAT'S NEW   "
                dc.b $7c,$7d,$7e,$7f,$80,$81," LOCATION     "
                dc.b $82,$83,$84,$85,$86,$87,"              "

                dc.b $88,$89,$8a,$8b,$8c,$8d," THE CAMPUS   "
                dc.b $8e,$8f,$90,$91,$92,$93,"              "
                dc.b $94,$95,$96,$97,$98,$99,"              "

                dc.b $9a,$9b,$9c,$9d,$9e,$9f," RESEARCH     "
                dc.b $a0,$a1,$a2,$a3,$a4,$a5," FACILITY     "
                dc.b $a6,$a7,$a8,$a9,$aa,$ab,"              "

                dc.b $ac,$ad,$ae,$af,$b0,$b1," BLACK OPS    "
                dc.b $b2,$b3,$b4,$b5,$b6,$b7," TRAINING     "
                dc.b $b8,$b9,$ba,$bb,$bc,$bd,"              "

                dc.b $be,$bf,$c0,$c1,$c2,$c3," SCEPTRE      "
                dc.b $c4,$c5,$c6,$c7,$c8,$c9," MANSION      "
                dc.b $ca,$cb,$cc,$cd,$ce,$cf,"              "

                dc.b $d0,$d1,$d2,$d3,$d4,$d5," IAC PROJECT  "
                dc.b $d6,$d7,$d8,$d9,$da,$db,"              "
                dc.b $dc,$dd,$de,$df,$e0,$e1,"              "

                dc.b $e2,$e3,$e4,$e5,$e6,$e7," BLACK OPS    "
                dc.b $e8,$e9,$ea,$eb,$ec,$ed," COMMAND      "
                dc.b $ee,$ef,$f0,$f1,$f2,$f3,"              "


