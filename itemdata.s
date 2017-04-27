textrowtbl:     dc.b <(textscreen+21*40-1)
                dc.b <(textscreen+22*40-1)

msgtbl:         dc.w msg_pickedup
                dc.w msg_required
                dc.w msg_fileerror
                dc.w msg_itemnone
                dc.w msg_itemname1
                dc.w msg_itemname2
                dc.w msg_itemname3
                dc.w msg_itemname4
                dc.w msg_itemname5
                dc.w msg_itemname6
                dc.w msg_itemname7
                dc.w msg_itemname8
                dc.w msg_itemname9
                dc.w msg_itemname10
                dc.w msg_itemname11
                dc.w msg_itemname12
                dc.w msg_itemname13
                dc.w msg_itemname14
                dc.w msg_itemname15
                dc.w msg_itemname16
                dc.w msg_itemname17
                dc.w msg_itemname18
                dc.w msg_itemname19
                dc.w msg_itemname20
                dc.w msg_itemname21
                dc.w msg_itemname22
                dc.w msg_itemname23
                dc.w msg_itemname24
                dc.w msg_itemname25
                dc.w msg_itemname26
                dc.w msg_itemname27
                dc.w msg_itemname28
                dc.w msg_itemname29
                dc.w msg_itemname30
                dc.w msg_itemname31
                dc.w msg_itemname32
                dc.w msg_itemname33
                dc.w msg_itemname34
                dc.w msg_itemname35
                dc.w msg_itemname36
                dc.w msg_itemname37
                dc.w msg_itemname38
                dc.w msg_itemname39
                dc.w msg_itemname40
                dc.w msg_itemname41
                dc.w msg_itemname42
                dc.w msg_itemname43
                dc.w msg_itemname44
                dc.w msg_itemname45
                dc.w msg_itemname46
                dc.w msg_itemname47
                dc.w msg_itemname48
                dc.w msg_itemname49
                dc.w msg_itemname50
                dc.w msg_itemname51
                dc.w msg_itemname52
                dc.w msg_itemname53
                dc.w msg_itemname54
                dc.w msg_itemname55
                dc.w msg_itemname56
                dc.w msg_itemname57
                dc.w msg_itemname58
                dc.w msg_itemname59
                dc.w msg_itemname60
                dc.w msg_itemname61
                dc.w msg_itemname44

msg_pickedup:   dc.b "PICKED UP ",0
msg_required:   dc.b " REQUIRED",0
msg_fileerror:  dc.b "DISK ERROR - FIRE TO RETRY",0
msg_itemnone:   dc.b 0
msg_itemname1:  dc.b "FISTS",0
msg_itemname2:  dc.b "BATON",0
msg_itemname3:  dc.b "KNIFE",0
msg_itemname4:  dc.b "KATANA",0
msg_itemname5:  dc.b "SHURIKEN",0
msg_itemname6:  dc.b "GRENADES",0
msg_itemname7:  dc.b "SPIDER PARASITE",0

msg_itemname8:  dc.b "DART"
msg_gun:        dc.b " GUN",0

msg_itemname9:  dc.b "ELECTRONIC STUN",TEXTJUMP
                dc.w msg_gun

msg_itemname10: dc.b "9MM"
msg_pistol:     dc.b " PISTOL",0

msg_itemname11: dc.b "SILENCED",TEXTJUMP
                dc.w msg_pistol

msg_itemname12: dc.b "SUB",TEXTJUMP
                dc.w msg_machinegun

msg_itemname13: dc.b "MAGNUM",TEXTJUMP
                dc.w msg_pistol

msg_itemname14: dc.b "PUMP-ACTION"
msg_shotgun:    dc.b " SHOTGUN",0

msg_itemname15: dc.b "AUTO",TEXTJUMP
                dc.w msg_shotgun

msg_itemname16: dc.b "ASSAULT"
msg_rifle:      dc.b " RIFLE",0

msg_itemname17: dc.b "LIGHT "
msg_machinegun: dc.b "MACHINE",TEXTJUMP
                dc.w msg_gun

msg_itemname18: dc.b "SNIPER",TEXTJUMP
                dc.w msg_rifle

msg_itemname19: dc.b "LASER",TEXTJUMP
                dc.w msg_rifle

msg_itemname20: dc.b "FLAMETHROWER",0
msg_itemname21: dc.b "ROCKET LAUNCHER",0
msg_itemname22: dc.b "GASFIST MK2",0
msg_itemname23: dc.b "PSIONIC",TEXTJUMP
                dc.w msg_rifle
msg_itemname24: dc.b "TRANQUILIZER DARTS",0
msg_itemname25: dc.b "9MM"
msg_ammo:       dc.b " AMMO",0

msg_itemname26: dc.b "44 MAGNUM",TEXTJUMP
                dc.w msg_ammo

msg_itemname27: dc.b "12 GAUGE",TEXTJUMP
                dc.w msg_ammo

msg_itemname28: dc.b "5.56",TEXTJUMP
                dc.w msg_ammo

msg_itemname29: dc.b "7.62",TEXTJUMP
                dc.w msg_ammo

msg_itemname30: dc.b "FLAMETHR. FUEL",0
msg_itemname31: dc.b "ROCKETS",0
msg_itemname32: dc.b "BATTERIES",0
msg_itemname33: dc.b "PLUTONIUM",TEXTJUMP
                dc.w msg_ammo

msg_itemname34: dc.b "FIRST AID KIT",0
msg_itemname35: dc.b "ARMOR RECHARGER",0
msg_itemname36: dc.b "BEER",0
msg_itemname37: dc.b "CREDITS",0
msg_itemname38: dc.b "VITALITY"
msg_enh:        dc.b " UPGRADE",0

msg_itemname39: dc.b "STRENGTH",TEXTJUMP
                dc.w msg_enh

msg_itemname40: dc.b "BETA"
msg_armor:      dc.b " ARMOR",0

msg_itemname41: dc.b "GAMMA",TEXTJUMP
                dc.w msg_armor

msg_itemname42: dc.b "DELTA",TEXTJUMP
                dc.w msg_armor

msg_itemname43: dc.b "EPSILON",TEXTJUMP
                dc.w msg_armor

msg_itemname44: dc.b "AGENT GEAR",0

msg_itemname45: dc.b "MAINTENANCE"
msg_accesscard: dc.b " KEYCARD",0

msg_itemname46: dc.b "SUBLEVEL",TEXTJUMP
                dc.w msg_accesscard

msg_itemname47: dc.b "ARMORY",TEXTJUMP
                dc.w msg_accesscard

msg_itemname48: dc.b "RAIL SYSTEM",TEXTJUMP
                dc.w msg_accesscard

msg_itemname49: dc.b "CELL",TEXTJUMP
                dc.w msg_accesscard

msg_itemname50: dc.b "SECURITY",TEXTJUMP
                dc.w msg_accesscard

msg_itemname51: dc.b "LIFT",TEXTJUMP
                dc.w msg_accesscard

msg_itemname52: dc.b "POWER PLANT",TEXTJUMP
                dc.w msg_accesscard

msg_itemname53: dc.b "TELEPORT",TEXTJUMP
                dc.w msg_accesscard

msg_itemname54: dc.b "CODE SHEET A",0

msg_itemname55: dc.b "CODE SHEET B",0

msg_itemname56: dc.b "CODE SHEET C",0

msg_itemname57: dc.b "CODE SHEET D",0

msg_itemname58: dc.b "GENERATOR",TEXTJUMP
                dc.w msg_accesscard

msg_itemname59: dc.b "LEVER",0

msg_itemname60: dc.b "TRIANGULAR CRYSTAL",0

msg_itemname61: dc.b "LETTER",0

infammotext:    dc.b "INF",0

