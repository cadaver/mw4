;
; MW4 Scriptfile 09: Blowfish, letter, Suhrim
;

                include scriptm.s

                entrypoint blowfishconv  ;$0900
                entrypoint letter        ;$0901
                entrypoint suhrim1                      ;$902
                entrypoint suhrim2                      ;$903
                entrypoint suhrim3                      ;$904

;-------------------------------------------------------------------------------
; $0900
;-------------------------------------------------------------------------------

blowfishconv:   say l_bfish1
                plrsay l_bfish2
                say l_bfish3
                setdomulti %00000011,l_bfish4m
                selectline l_bfish5m
                saynoptr
                plrsay l_bfish6
                say l_bfish7
                plrsay l_bfish8
                say l_bfish9
                ldx #ACTI_LASTITEM
                jsr removelevelactor
                ldy #ACTI_LASTITEM
                lda #ACT_ITEM
                jsr createactor
                lda #ITEM_MAINTENANCE_ACCESS         ;Create keycard on table
                sta actf1,y
                lda #1
                sta acthp,y
                lda #$23
                sta actxh,y
                lda #$12
                sta actyh,y
                lda #$c0
                sta actxl,y
                lda #$80
                sta actyl,y
                plrsay l_bfish10
                settrigger ACT_BLOWFISH,SCRIPT_BLOWFISHCONV2,T_CONV
                stop

l_bfish1:       dc.b 34,"THE NOISE WILL MASK OUR CONVERSATION, IN CASE SCEPTRE IS LISTENING.",34,0
l_bfish2:       dc.b 34,"THEY OPERATE IN THIS PLACE?",34,0
l_bfish3:       dc.b 34,"THE COMMUNICATIONS GATEWAY HERE IS AN IDEAL PLACE TO INTERCEPT LOTS OF TRAFFIC.",34,0
l_bfish4m:      dc.w l_bfish4m0
                dc.w l_bfish4m1
l_bfish4m0:     dc.b 34,"EMAILS, PHONECALLS AND SUCH?",34,0
l_bfish4m1:     dc.b 34,"AN UNBELIEVABLE AMOUNT OF DATA?",34,0
l_bfish5m:      dc.w l_bfish5m0
                dc.w l_bfish5m1
l_bfish5m0:     dc.b 34,"YES. FROM SMALL BITS OF INFORMATION THEY MIGHT BE ABLE TO PIECE TOGETHER YOUR WHOLE LIFE.",34,0
l_bfish5m1:     dc.b 34,"THEY HAVE THE CAPACITY TO SORT IT OUT AND STORE EVERYTHING THEY DEEM INTERESTING.",34,0
l_bfish6:       dc.b 34,"DOESN'T SOUND TOO TERRIFYING. I'VE ALWAYS SUSPECTED SOMETHING LIKE THAT.",34,0
l_bfish7:       dc.b 34,"IT'S JUST A SMALL PART OF HOW THEY OPERATE. I'VE BEEN DOWN IN THE FACILITY ONCE - PERHAPS YOU CAN FIND OUT MORE.",34,0
l_bfish8:       dc.b 34,"HOW DO I GET THERE?",34,0
l_bfish9:       dc.b 34,"FROM THE NEXT BUILDING WHICH HOUSES MOST OF THE GATEWAY EQUIPMENT. YOU'LL NEED THIS KEYCARD.",34,0
l_bfish10:      dc.b 34,"THANKS.",34,0

;-------------------------------------------------------------------------------
; $0901
;-------------------------------------------------------------------------------

letter:         jsr beginfullscreen
                lda #<lettertext
                ldy #>lettertext
                jsr printscreentext
                lda #$01
                sta rgscr_textbg1+1
                lda #MSGTIME_ETERNAL
                jsr waitforfire
                lda #$00
                sta rgscr_textbg1+1
                setbit PLOT_MADLOCUST_LETTER
                jmp endfullscreen

lettertext:     dc.b 6,4,0,"YOU CAN  BREAK MY  BODY AND",0
                dc.b 6,5,0,"MIND BUT YOU CAN'T KILL THE",0
                dc.b 6,6,0,"SPIRIT OF THE  THREE WORDS.",0
                dc.b 6,7,0,"FREEDOM,  METAL AND  MIGHT!",0
                dc.b 6,9,0,"THE DAY WILL COME WHEN YOUR",0
                dc.b 6,10,0,"ACTIONS ARE EXPOSED AND YOU",0
                dc.b 6,11,0,"ALL ARE MURDERED WITH HATE.",0
                dc.b 6,13,0,"                 MAD LOCUST",0,$ff

;-------------------------------------------------------------------------------
; $0902,$0904
;-------------------------------------------------------------------------------

suhrim1:        setscript SCRIPT_SUHRIM3
                removetrigger ACT_SUHRIMBYSTD
                stop

suhrim3:        stopscript
                lda #$00                ;Player faces right
                sta actd+ACTI_PLAYER
                say l_suhrim0
                setmulti %00000001
                getbit PLOT_SUHRIM_SEEN
                jumpfalse suhrim1_skip
                addmulti %00000010
                plrsay l_suhrim1
suhrim1_skip:   say l_suhrim2
                domulti l_suhrim3m
               ; choice 0,suhrim1_0
                choice 1,suhrim1_1
suhrim1_0:      say l_suhrim4
                plrsay l_suhrim5
                say l_suhrim6
suhrim1_common: focus ACT_SUHRIMBYSTD
                lda #ACT_SUHRIM
                sta actt,x
                jsr initcomplexactor_noweap
                settrigger ACT_SUHRIM,SCRIPT_SUHRIM2,T_APPEAR|T_TAKEDOWN
                jmp suhrim2_appear

suhrim1_1:      say l_suhrim7
                jmp suhrim1_common

l_suhrim0:      dc.b 34,"I SEE THE BLACK OPS DIDN'T DO THEIR JOB PROPERLY.",34,0
l_suhrim1:      dc.b 34,"YOU.. THE GUY ON THE TV SCREEN?",34,0
l_suhrim2:      dc.b 34,"SO I, SUHRIM - HEAD OF SECURITY, WILL DO IT MYSELF.",34,0
l_suhrim3m:     dc.w l_suhrim3m0
                dc.w l_suhrim3m1
l_suhrim3m0:    dc.b 34,"FUNNY NAME.",34,0
l_suhrim3m1:    dc.b 34,"HOW DID YOU FIND THE AGENT HQ?",34,0

l_suhrim4:      dc.b 34,"IT SERVES TO INSPIRE RESPECT AND FEAR IN SUBORDINATES.",34,0
l_suhrim5:      dc.b 34,"HMM, SORT OF LIKE HOW WE METALHEADS CHOOSE NAMES.",34,0
l_suhrim6:      dc.b 34,"ENOUGH!",34,0

l_suhrim7:      dc.b 34,"INTESTINAL TRANSMITTER. VERY HARD TO DETECT. BUT NOW, ENOUGH OF TALKING!",34,0

;-------------------------------------------------------------------------------
; $0903
;-------------------------------------------------------------------------------

suhrim2:        choice T_APPEAR,suhrim2_appear
suhrim2_takedown:
                lda #ITEM_556_MACHINE_GUN       ;Make sure the MG is dropped,
                sta actwpn,x                    ;never any other item
                lda #ACT_SUHRIM
                jsr removeactortrigger
                jmp playzonetune

suhrim2_appear: lda tunenum
                and #$fc
                ora #$03
                jmp playgametune


                endscript

