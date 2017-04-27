;
; Script 30: Endscreen
;
                include scriptm.s

                entrypoint es_finalscreen       ;$1e00
                entrypoint es_finalscreenrun    ;$1e01

;-------------------------------------------------------------------------------
; $1e01
;-------------------------------------------------------------------------------

es_finalscreenrun:
                getbit PLOT_MELTDOWN_DONE       ;Sentinels show themselves?
                beq es_fsrfalse
                lda agentcounter
                bne es_noiacinit
                lda #ACTI_LASTNPC
                ldy #ACTI_FIRSTNPC
                jsr getfreeactor
                bcc es_fsrfalse
                lda #ACT_SENTINELIAC
                jsr createactor
                tya
                tax
                lda mapx
                sec
                sbc #$01
                sta actxh,x
                lda mapy
                clc
                adc #$02
                sta actyh,x
                jsr initcomplexactor
                lda #M_FREE
                sta actmode,x
                lda #JOY_RIGHT
                sta actctrl,x
                lda #36
                sta actsx,x
                lda #-24
                sta actsy,x
es_noiacinit:   inc agentcounter
                lda agentcounter
                cmp #23
                bcc es_noctrl
                focus ACT_SENTINELIAC
                bcc es_noctrl
                lda #JOY_RIGHT+JOY_UP
                sta actctrl,x
es_noctrl:      lda agentcounter
                cmp #65
                bcs es_fsrfalse
                rts
es_fsrfalse:    stopscript      ;Fall through

;-------------------------------------------------------------------------------
; $1e00
;-------------------------------------------------------------------------------

es_finalscreen: ldx difficulty
es_bonusloop:   lda #<50000             ;Add 100000 x difficulty level
                ldy #>50000
                jsr addscore
                lda #<50000             ;Add 100000 x difficulty level
                ldy #>50000
                jsr addscore
                dex
                bpl es_bonusloop
                jsr updatepanel

                lda #STATUS_GAMEOVER
                sta gameon
                lda actt+ACTI_PLAYER
                sta es_acttcmp+1
                jsr initactors
                lda #$00
                sta agentcounter
es_wipeloop:    jsr scriptupdateframe
es_wipeloop2:   ldx $d011
                bpl es_wipeloop2
                ldy agentcounter
                lda #$00
                sta temp1
                sta temp3
                lda #>colors
                sta temp4
                ldx screen
                lda scradrtblhi,x
                sta temp2
                ldx #SCROLLROWS
es_wipeloop3:   lda #$40
                sta (temp1),y
                lda #$00
                sta (temp3),y
                lda temp1
                clc
                adc #40
                sta temp1
                sta temp3
                bcc es_wipeok
                inc temp2
                inc temp4
es_wipeok:      dex
                bne es_wipeloop3
                inc agentcounter
                lda agentcounter
                cmp #40
                bcc es_wipeloop

                jsr cleartextscreen
                ldx #FILE_FACES
                lda #$00
                jsr makefilename
                lda #<(chars+$200)
                ldx #>(chars+$200)
                jsr loadfileretry
                lda #$09
                sta rgscr_textbg2+1
                lda #$0a
                sta rgscr_textbg3+1

                ldx #$02
es_copyscore:   lda score,x
                sta temp1,x
                dex
                bpl es_copyscore
                jsr convert24bits
                ldx #15
                lda temp7
                jsr printenddigit
                lda temp6
                jsr printenddigits
                lda temp5
                jsr printenddigits
                lda temp4
                jsr printenddigits
                lda ti_hours
                ldx #37
                jsr printendnumber
                lda ti_minutes
                ldx #40
                jsr printendnumber
                lda ti_seconds
                ldx #43
                jsr printendnumber
                lda #<finaltext2
                ldy #>finaltext2
                jsr printscreentext

                getbit PLOT_JOAN_JOIN   ;Determine ending quote
                jumptrue es_textc
                getbit PLOT_JOAN_DEAD
                jumptrue es_texte
es_texta:
es_acttcmp:     lda #$00
                cmp #ACT_IANCIVILIAN
                beq es_textb
                lda #<finaltexta        ;So Agent, walk on the Chosen Path..
                ldy #>finaltexta        ;(standard)
                bne es_textcommon
es_textb:       lda #<finaltextb        ;I have seen things better left untold..
                ldy #>finaltextb        ;(traitorous)
                bne es_textcommon
es_textc:       getbit PLOT_MELTDOWN_DONE
                jumptrue es_textd
                lda #<finaltextc        ;We have learned that things aren't..
                ldy #>finaltextc        ;(together)
                bne es_textcommon
es_textd:       lda #<finaltextd        ;The Truth is hidden..
                ldy #>finaltextd        ;(sentinels appear)
                bne es_textcommon
es_texte:       lda #<finaltexte        ;When all the enemies have been..
                ldy #>finaltexte        ;(mourning)
es_textcommon:  jsr printscreentext
                ;Determine lineup
                getbit PLOT_SADOK_JOIN
                pha
                getbit PLOT_GOAT_JOIN
                lsr
                pla
                rol
                pha
                getbit PLOT_JOAN_JOIN
                lsr
                pla
                rol


es_lineup:      tax
                lda lineupdataptrlo,x
                sta tempadrlo
                lda lineupdataptrhi,x
                sta tempadrhi
                ldy #$00
es_drawlineup:  lda (tempadrlo),y       ;X position
                beq es_drawfacedone
                tax
                lda #5                  ;Row counter
                sta temp1
                sta temp2               ;Column counter
                iny
                lda (tempadrlo),y       ;Whose face?
                iny
                clc
es_drawrow:     sta textscreen+7*40,x
                adc #$01
                inx
                dec temp2
                bne es_drawrow
                pha
                lda #5                  ;Reload column counter
                sta temp2
                txa
                adc #35
                tax
                pla
                dec temp1
                bne es_drawrow
                lda (tempadrlo),y       ;What instrument?
                pha
                iny
                sty temp1
                and #$03
                sta temp2
                asl
                asl
                adc temp2
                tay
                lda #5
                sta temp3
es_drawinstr:   lda instrtxt,y
                and #$3f
                sta textscreen+7*40,x
                inx
                iny
                dec temp3
                bne es_drawinstr
                pla
                and #VOCALS             ;Vocals?
                beq es_novocals
                lda #","
                sta textscreen+7*40-1,x
                ldy #15
                lda #5
                sta temp3
es_drawinstr2:  lda instrtxt,y
                and #$3f
                sta textscreen+7*40+35,x
                inx
                iny
                dec temp3
                bne es_drawinstr2
es_novocals:    ldy temp1
                jmp es_drawlineup
es_drawfacedone:lda es_acttcmp+1        ;False or ture agentmetal?
                cmp #ACT_IANCIVILIAN
                beq es_falseagentmetal
es_trueagentmetal:
                lda #<lineuptitle1
                ldy #>lineuptitle1
                bne es_agentcommon
es_falseagentmetal:
                lda #<lineuptitle2
                ldy #>lineuptitle2
es_agentcommon: jsr printscreentext

                lda #$00
                sta agentcounter
es_revealloop:  jsr scriptupdateframe
                ldy agentcounter
                lda #$01
                sta colors+0*40,y
                sta colors+1*40,y
                sta colors+2*40,y
                sta colors+5*40,y
                sta colors+12*40,y
                sta colors+13*40,y
                sta colors+16*40,y
                sta colors+18*40,y
                lda #$09
                sta colors+7*40,y
                sta colors+8*40,y
                sta colors+9*40,y
                sta colors+10*40,y
                sta colors+11*40,y
                inc agentcounter
                lda agentcounter
                cmp #40
                bcc es_revealloop
                lda #MSGTIME_ETERNAL
                jsr waitforfire
                jsr cleartextscreen
                jumpto SCRIPT_TITLE

printendnumber: sta temp3
                stx pen_x+1
                jsr convert8bits
                lda temp4
pen_x:          ldx #$00
printenddigits: pha
                lsr
                lsr
                lsr
                lsr
                ora #$30
                sta finaltext2,x
                inx
                pla
printenddigit:  and #$0f
                ora #$30
                sta finaltext2,x
                inx
                rts

                                ;0123456789012345678901234567890123456789
finaltexta:     dc.b 2,1,0,    34,"SO, AGENT, WALK ON THE CHOSEN PATH,",0
                dc.b 2,2,0,       "THE SIGN OF THE GUN LIGHTS YOUR WAY",34,0,$ff

                                ;0123456789012345678901234567890123456789
finaltextb:     dc.b 0,1,0,   34,"ON MY JOURNEYS OF AND OUT OF THIS WORLD",0
                dc.b 0,2,0,     "I'VE SEEN THE THINGS BETTER LEFT UNTOLD",34,0,$ff

                                ;0123456789012345678901234567890123456789
finaltextc:     dc.b 0,0,0,   34,"YET STILL THEY CONSPIRE, SETTING THEIR",0
                dc.b 0,1,0,     "WICKED SCHEMES, BUT WE HAVE LEARNED THAT",0
                dc.b 2,2,0,       "THINGS AREN'T ALWAYS WHAT THEY SEEM",34,0,$ff

                                ;0123456789012345678901234567890123456789
finaltextd:     dc.b 0,0,0,    34,"EVERYTHING I'VE ALWAYS WONDERED, I'VE",0
                dc.b 3,1,0,         "ALWAYS HOPED, AND NOW I KNOW. BUT",0
                dc.b 8,2,0,             "THE TRUTH.. IS HIDDEN..",34,0,$ff

                                ;0123456789012345678901234567890123456789
finaltexte:     dc.b 0,0,0,   34,"BUT WHAT WILL IT ALL LEAVE ME? WHEN ALL",0
                dc.b 2,1,0,       "THE ENEMIES HAVE BEEN ELIMINATED, ALL",0
                dc.b 1,2,0,      "CONSPIRACIES UNVEILED, I WILL BE ALONE",34,0,$ff


finaltext2:     dc.b 10,16,0, "FINAL SCORE        ",0
                dc.b 10,18,0, "FINAL TIME   :  :  ",0,$ff

lineuptitle1:   dc.b 11,5,0,"AGENT METAL LINEUP",0,$ff
lineuptitle2:   dc.b 11,5,0,"FALSE AGENT LINEUP",0,$ff

lineupdataptrlo:dc.b <lineupdata0  ;I
                dc.b <lineupdata1  ;IJ
                dc.b <lineupdata2  ;IG
                dc.b <lineupdata3  ;IJG
                dc.b <lineupdata4  ;IS
                dc.b <lineupdata5  ;IJS
                dc.b <lineupdata6  ;IGS
                dc.b <lineupdata7  ;IJGS
lineupdataptrhi:dc.b >lineupdata0  ;I
                dc.b >lineupdata1  ;IJ
                dc.b >lineupdata2  ;IG
                dc.b >lineupdata3  ;IJG
                dc.b >lineupdata4  ;IS
                dc.b >lineupdata5  ;IJS
                dc.b >lineupdata6  ;IGS
                dc.b >lineupdata7  ;IJGS

FI              = 64+50
FJ              = 64+25
FG              = 64+0
FS              = 64+75

GTR             = 0
BASS            = 1
DRUMS           = 2
VOCALS          = 4

lineupdata0:    dc.b 17,FI,GTR+VOCALS,0
lineupdata1:    dc.b 13,FI,BASS+VOCALS,21,FJ,GTR,0
lineupdata2:    dc.b 13,FI,GTR+VOCALS,21,FG,DRUMS,0
lineupdata3:    dc.b 9,FI,BASS+VOCALS,17,FG,DRUMS,25,FJ,GTR,0
lineupdata4:    dc.b 13,FI,GTR,21,FS,BASS+VOCALS,0
lineupdata5:    dc.b 9,FI,GTR,17,FS,BASS+VOCALS,25,FJ,GTR,0
lineupdata6:    dc.b 9,FI,GTR,17,FG,DRUMS,25,FS,BASS+VOCALS,0
lineupdata7:    dc.b 5,FI,GTR,13,FS,BASS+VOCALS,21,FG,DRUMS,29,FJ,GTR,0

instrtxt:       dc.b "GTRS.BASS DRUMSVOICE"

                endscript
