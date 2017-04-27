varstart:

vcolbuf         = colors+24*40
sortsprf        = screen1+24*40
dsprf           = screen2+21*40
dsprprevf       = screen2+21*40+NUMDEPACKSPR
emptysprite     = screen2+22*40+16
sortsprc        = screen2+24*40

musicfilenum:   dc.b 0
musicmode:      dc.b 1
soundmode:      dc.b 1

vchnsongpos:    dc.b 0
vchnpattnum:    dc.b 0
vchnpattpos:    dc.b 0
vchntrans:      dc.b 0
vchncounter:    dc.b 0
vchnwavepos:    dc.b 0
vchnwavestored: dc.b 0

                dc.b 0,0,0,0,0,0,0
                dc.b 0,0,0,0,0,0,0

vchnwavepreset: dc.b 0
vchnwavedelay:  dc.b 0
vchnsongnum:    dc.b 0
vchnpulse:      dc.b 0
vchnpulsepos:   dc.b 0
vchnpulsetime:  dc.b 0
vchnnote:       dc.b 0

                dc.b 0,0,0,0,0,0,0
                dc.b 0,0,0,0,0,0,0

vchnduration:   dc.b 0
vchnfreqlo:     dc.b 0
vchnfreqhi:     dc.b 0
vchnfreqmodlo:  dc.b 0
vchnfreqmodhi:  dc.b 0
vchnsfx:        dc.b 0
vchnunused:     dc.b 0

                dc.b 0,0,0,0,0,0,0
                dc.b 0,0,0,0,0,0,0

vchnsfxptrlo    = vchnfreqmodlo
vchnsfxptrhi    = vchnfreqmodhi

panelupdateflag:dc.b 0
menumode:       dc.b 0
menucounter:    dc.b 0
gmselect:       dc.b 0                          ;"New game" by default
sgselect:       dc.b 0
dfselect:       dc.b 0
qtselect:       dc.b 1                          ;Default "No" answer
msgcont:        dc.b 0
choicemin:      dc.b 0
choicemax:      dc.b 0
npcsearch:      dc.b ACTI_FIRSTNPC
itemnamedisplay:dc.b 0
plrprevhp:      dc.b 0
plrprevbatt:    dc.b 0
prevtune:       dc.b $ff
scriptfilenum:  dc.b $ff

mw4end1:


                org ((* + $ff) & $ff00)

fliptable:      include fliptbl.s


lvlobjx:        ds.b NUMLVLOBJ,0
lvlobjy:        ds.b NUMLVLOBJ,0
lvlobjb:        ds.b NUMLVLOBJ,0
lvlobjr:        ds.b NUMLVLOBJ,0
lvlobjd1:       ds.b NUMLVLOBJ,0
lvlobjd2:       ds.b NUMLVLOBJ,0
zonel:          ds.b NUMZONES,0
zoner:          ds.b NUMZONES,0
zoneu:          ds.b NUMZONES,0
zoned:          ds.b NUMZONES,0

        ;Data that needs to be saved
saveareastart:

zonebg1:        ds.b NUMZONES,0                 ;These might be changed
zonebg2:        ds.b NUMZONES,0                 ;by scripts and therefore
zonebg3:        ds.b NUMZONES,0                 ;need to be saved
zonemusic:      ds.b NUMZONES,0

        ;This absolutely needs to be page-aligned
lvlactarea:     include wpndata.s
                org lvlactarea+6*NUMLVLACT

lvlactareaend:

lvlobjstatus:   ds.b 16*NUMLEVELS,0             ;Bit information for active
                                                ;level objects

plotbits:       ds.b NUMPLOTBITS/8,0

alliance:       ds.b NUMGRP,0                   ;Friendly alliances

invtype:        ds.b INVENTORYSIZE+1,0
invcountlo:     ds.b INVENTORYSIZE+1,0
invcounthi:     ds.b INVENTORYSIZE+1,0

waypointxh:     ds.b NUMWAYPOINTS,0
waypointyh:     ds.b NUMWAYPOINTS,0

attype:         ds.b NUMACTTRIGGER+1,0          ;One extra to stop search
atscriptf:      ds.b NUMACTTRIGGER,0
atscriptep:     ds.b NUMACTTRIGGER,0
atmask:         ds.b NUMACTTRIGGER,0            ;Events that are responded to

actxl:          ds.b NUMACT,0
actxh:          ds.b NUMACT,0
actyl:          ds.b NUMACT,0
actyh:          ds.b NUMACT,0
actt:           ds.b NUMACT,0
actd:           ds.b NUMACT,0
acthitwalld:    ds.b NUMACT,0
actsx:          ds.b NUMACT,0
actsy:          ds.b NUMACT,0
actbits:        ds.b NUMACT,0
actorg:         ds.b NUMACT,0
actgrp:         ds.b NUMACT,0
acttime:        ds.b NUMACT,0
acthp:          ds.b NUMACT,0
actfd:          ds.b NUMACT,0
actf1:          ds.b NUMACT,0
actpurgeable:   ds.b ACTI_LASTLEVELDATA+1,0 ;Note: only $00 or $80 are valid
actf2:          ds.b NUMCOMPLEXACT,0
actlastladderxh:ds.b NUMCOMPLEXACT,0            ;AI / pathfinding
actlastgroundyl:ds.b NUMCOMPLEXACT,0            ;variables
actlastgroundyh:ds.b NUMCOMPLEXACT,0
acttarget:      ds.b NUMCOMPLEXACT,0
actmode:        ds.b NUMCOMPLEXACT,0
acthomemode:    ds.b NUMCOMPLEXACT,0
actctrl:        ds.b NUMCOMPLEXACT,0
actprevctrl:    ds.b NUMCOMPLEXACT,0
actmovectrl:    ds.b NUMCOMPLEXACT,0            ;Move control without
actclimbctrl:   ds.b NUMCOMPLEXACT,0            ;fire button
actattklen:     ds.b NUMCOMPLEXACT,0            ;Attack length (NPCs)
actattkd:       ds.b NUMCOMPLEXACT,0            ;Attack delay
actreload:      ds.b NUMCOMPLEXACT,0            ;Is reloading
actroutecheck:  ds.b NUMCOMPLEXACT,0
actwf:          ds.b NUMCOMPLEXACT,0
actbatt:        ds.b NUMCOMPLEXACT,0            ;Battery meter
actwpn:         ds.b NUMCOMPLEXACT,0            ;Weapon number
actlastdmgact2: ds.b NUMCOMPLEXACT,0
actlastdmgact:  ds.b NUMCOMPLEXACT,0            ;Last damage by actor
actlastdmghp:   ds.b NUMCOMPLEXACT,0
acthpdelta:     ds.b NUMCOMPLEXACT,0            ;Hitpoints deltavalue
acthptime:      ds.b NUMCOMPLEXACT,0            ;and time count
actclip:        ds.b NUMCOMPLEXACT,0            ;Enemy ammo in weapon


gameon:         dc.b 0                          ;Game status
                                                ;$00 = titlesequence
                                                ;$01 = on
                                                ;$80 = game over
scriptf:        dc.b 0                          ;Continuous script file
scriptep:       dc.b 0                          ;Continuous script entrypoint
levelnum:       dc.b 0
zonenum:        dc.b 0
tunenum:        dc.b 0
zoneflash:      dc.b NUMZONES-1
zoneflashcount: dc.b 0
levelalert:     dc.b 0
difficulty:     dc.b 0
invview:        dc.b 0
invselect:      dc.b 0
invsize:        dc.b 0
carrylo:        dc.b 0
carryhi:        dc.b 0
carrymax:       dc.b 0
actcounter:     dc.b 0
plrbattdelta:   dc.b 0
plrbatttime:    dc.b 0
scriptparam:    dc.b 0
lvlobjsearch:   dc.b 0
lvlobjnum:      dc.b $ff                        ;Object player is on
adobjnum:       dc.b $ff                        ;Object auto-deactivation
adobjdelay:     dc.b 0
sourceobjnum:   dc.b 0

bigexplcount:   dc.b 0
bigexplradius:  dc.b 0
bigexplxl:      dc.b 0
bigexplyl:      dc.b 0
bigexplxh:      dc.b 0
bigexplyh:      dc.b 0

firstgamevar:

score:          dc.b 0,0,0
ti_frame:       dc.b 0
ti_seconds:     dc.b 0
ti_minutes:     dc.b 0
ti_hours:       dc.b 0
plrvit:         dc.b 0
plrstr:         dc.b 0
plrarmor:       dc.b 0

        ;Special purpose variables (script routines)

playerscripted: dc.b 0
codesfound:     dc.b 0
multichoices:   dc.b 0
reactormode:    dc.b 0,0
teleportcode:   dc.b 0,0,0
teleportselect: dc.b 0,0,0
comradeagent:   dc.b 0
blowfishwaypoint: dc.b 0
blowfishdelay:  dc.b 0
agenttvscreen:  dc.b 0

meltdowndelay:
agentcounter:
iaccounter:
traincounter:   dc.b 0
meltdownmin:
traindir:       dc.b 0
agentdelay:
meltdownsec:
trainanimdelay: dc.b 0
trainspeed:     dc.b 0

lastgamevar:

saveareaend:

        ;Data that doesn't need to be saved

actsizex:       ds.b NUMACT,0
actsizeup:      ds.b NUMACT,0
actsizedown:    ds.b NUMACT,0
actprevxl:      ds.b NUMACT,0
actprevxh:      ds.b NUMACT,0
actprevyl:      ds.b NUMACT,0
actprevyh:      ds.b NUMACT,0
actfls:         ds.b NUMACT,0
actdb:          ds.b NUMACT,0
actlvlptrlo:    ds.b ACTI_LASTLEVELDATA+1,<lvlactarea
actlvlptrhi:    ds.b ACTI_LASTLEVELDATA+1,>lvlactarea

itemaddtbl:     ds.b NUMITEMS,0
itemmaxtbl:     ds.b NUMITEMS,0
itemweighttbl:  ds.b NUMITEMS,0
itemammoweighttbl:ds.b NUMITEMS,0
itemammotbl:    ds.b NUMITEMS,0

wpn_noisetbl:   ds.b NUMWEAPONS,0
wpn_amounttbl:  ds.b NUMWEAPONS,0
wpn_firstblttbl:ds.b NUMWEAPONS,0
wpn_reloadtime1:ds.b NUMWEAPONS,0
wpn_reloadtime2:ds.b NUMWEAPONS,0
wpn_reloadamount:ds.b NUMWEAPONS,0
wpn_reloadsnd1: ds.b NUMWEAPONS,0
wpn_reloadsnd2: ds.b NUMWEAPONS,0
wpn_idlefrtbl:  ds.b NUMWEAPONS,0
wpn_prepfrtbl:  ds.b NUMWEAPONS,0
wpn_attkfrtbl:  ds.b NUMWEAPONS,0
wpn_upfrtbl:    ds.b NUMWEAPONS,0
wpn_downfrtbl:  ds.b NUMWEAPONS,0
wpn_dirtbl:     ds.b NUMWEAPONS,0
wpn_meleetbl:   ds.b NUMWEAPONS,0
wpn_sfxtbl:     ds.b NUMWEAPONS,0
wpn_npcmaxdist: ds.b NUMWEAPONS,0
wpn_npcmindist: ds.b NUMWEAPONS,0
wpn_npcattacktime:ds.b NUMWEAPONS,0
wpn_delaytbl:   ds.b NUMWEAPONS,0
wpn_dmgtbl:     ds.b NUMWEAPONS,0

blt_xmodtbllo:  ds.b NUMBULLETS,0
blt_xmodtblhi:  ds.b NUMBULLETS,0
blt_ymodtbllo:  ds.b NUMBULLETS,0
blt_xspdtbl:    ds.b NUMBULLETS,0
blt_yspdtbl:    ds.b NUMBULLETS,0
blt_yaimspdtbl: ds.b NUMBULLETS,0
blt_yaimmodtbl: ds.b NUMBULLETS,0
blt_yaimfrtbl:  ds.b NUMBULLETS,0
blt_actortbl:   ds.b NUMBULLETS,0
blt_timetbl:    ds.b NUMBULLETS,0
blt_removetbl:  ds.b NUMBULLETS,0
blt_nexttbl:    ds.b NUMBULLETS,0

specdmgcondition:ds.b NUMSPECDMG,0
specdmgtime:    ds.b NUMSPECDMG,0
specdmgdelta:   ds.b NUMSPECDMG,0
specdmginitial: ds.b NUMSPECDMG,0
specdmgarmor:   ds.b NUMSPECDMG,0

sprcol:         ds.b LASTSPRITEFRAME-FIRSTSPRITEFRAME,0
sprhotspotx:    ds.b LASTSPRITEFRAME-FIRSTSPRITEFRAME,0
sprhotspoty:    ds.b LASTSPRITEFRAME-FIRSTSPRITEFRAME,0
sprconnectspotx:ds.b LASTSPRITEFRAME-FIRSTSPRITEFRAME,0
sprconnectspoty:ds.b LASTSPRITEFRAME-FIRSTSPRITEFRAME,0

sprirqstart:    ds.b 32,0
sprirqamount:   ds.b 32,0
sprirqline:     ds.b 32,0

mw4end2:
