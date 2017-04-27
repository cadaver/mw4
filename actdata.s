        ;Base player damage multipliers

baseplrdmgmodtbl:
                dc.b EASY_DMGMOD
                dc.b MEDIUM_DMGMOD
                dc.b HARD_DMGMOD

        ;Actor display data

actdtbl:        dc.w actd_agent
                dc.w actd_item
                dc.w actd_smokecloud
                dc.w actd_smokecloud
                dc.w actd_explosion
                dc.w actd_bullet
                dc.w actd_riflebullet
                dc.w actd_stealthbullet
                dc.w actd_shuriken
                dc.w actd_dart
                dc.w actd_grenade
                dc.w actd_meleehit
                dc.w actd_laser
                dc.w actd_flame
                dc.w actd_electricity
                dc.w actd_plasma
                dc.w actd_missile
                dc.w actd_parasite
                dc.w actd_psionic
                dc.w actd_zsign
                dc.w actd_lift1
                dc.w actd_doorhint
                dc.w actd_balloon
                dc.w actd_lift2
                dc.w actd_streetcop
                dc.w actd_nonagent
                dc.w actd_thug1a
                dc.w actd_thug1b
                dc.w actd_thug1c
                dc.w actd_thug2a
                dc.w actd_thug2b
                dc.w actd_thug2c
                dc.w actd_weaponshop
                dc.w actd_tech
                dc.w actd_techboss
                dc.w actd_techiac
                dc.w actd_bystand1
                dc.w actd_bystand2
                dc.w actd_bystand3
                dc.w actd_bystand4
                dc.w actd_scientistm
                dc.w actd_scientistf
                dc.w actd_techlight
                dc.w actd_grunt1
                dc.w actd_grunt2
                dc.w actd_grunt3
                dc.w actd_gruntcmdr
                dc.w actd_snowgrunt
                dc.w actd_snowtech
                dc.w actd_commando1
                dc.w actd_commando2
                dc.w actd_enemyagentm1
                dc.w actd_enemyagentm2
                dc.w actd_enemyagentf1
                dc.w actd_enemyagentf2
                dc.w actd_priest1
                dc.w actd_priest2
                dc.w actd_ahriman
                dc.w actd_suhrim
                dc.w actd_lilith
                dc.w actd_lilith
                dc.w actd_iac
                dc.w actd_ceilturret
                dc.w actd_floorturret
                dc.w actd_heavyturret
                dc.w actd_securitybot
                dc.w actd_spiderbot
                dc.w actd_minicopter
                dc.w actd_ahriman
                dc.w actd_suhrim
                dc.w actd_iac
                dc.w actd_exoskeleton
                dc.w actd_seeker
                dc.w actd_mutant1
                dc.w actd_mutant2
                dc.w actd_hovercar
                dc.w actd_blackhand
                dc.w actd_sarge
                dc.w actd_sarge
                dc.w actd_blowfish
                dc.w actd_goat
                dc.w actd_sentinel
                dc.w actd_exagent
                dc.w actd_bartender
                dc.w actd_band
                dc.w actd_joanagent
                dc.w actd_ironfist
                dc.w actd_ultrashred
                dc.w actd_lordobskurius
                dc.w actd_satanakhia
                dc.w actd_joancivilian
                dc.w actd_obskuriushead
                dc.w actd_councilheadm
                dc.w actd_councilheadf
                dc.w actd_sentinel
                dc.w actd_joanlevitate
                dc.w actd_bat
                dc.w actd_observer
                dc.w actd_tvscreen
                dc.w actd_axesmith
                dc.w actd_sentineliac
                dc.w actd_sadok
                dc.w actd_widemeleehit

actd_lift1:     dc.b ADF_NORMAL                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_LIFT                          ;Spritefile number
                dc.w fr_lift1                           ;Frame ptr
                dc.b 1                                  ;Frame amount
                dc.b 2                                  ;Sprite amount
fr_lift1:       dc.b 1,0                                ;Frames

actd_lift2:     dc.b ADF_NORMAL                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 2                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_LIFT                          ;Spritefile number
                dc.w fr_lift1                           ;Frame ptr
                dc.b 1                                  ;Frame amount
                dc.b 2                                  ;Sprite amount

actd_zsign:     dc.b ADF_SIMPLE|ADF_FLICKER             ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 103                                ;Frames

actd_psionic:   dc.b ADF_SIMPLE|ADF_FLICKER             ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 92,93,94                           ;Frames

actd_parasite:  dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 95,96                              ;Frames

actd_missile:   dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 3                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 89,90,91,89+$80,90+$80,91+$80      ;Frames

actd_electricity:dc.b ADF_SIMPLE|ADF_FLICKER            ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 87                                 ;Frames

actd_plasma:    dc.b ADF_SIMPLE|ADF_FLICKER            ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 88                                 ;Frames

actd_flame:     dc.b ADF_SIMPLE|ADF_FLICKER             ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 83,84,85,86                        ;Frames

actd_laser:     dc.b ADF_SIMPLE|ADF_FLICKER             ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 3                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 80,81,82,80,82,81                  ;Frames

actd_stealthbullet:
actd_observer:
actd_widemeleehit:
actd_meleehit:  dc.b ADF_INVISIBLE                      ;Display flags

actd_grenade:   dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 79                                 ;Frames

actd_dart:      dc.b ADF_SIMPLE|ADF_FLICKER             ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 3                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 76,77,78,76,78,77                  ;Frames

actd_shuriken:  dc.b ADF_SIMPLE|ADF_FLICKER             ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 75                                 ;Frames

actd_riflebullet:
                dc.b ADF_SIMPLE|ADF_FLICKER             ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 3                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 100,101,102                        ;Frames
                dc.b 100+$80,101+$80,102+$80

actd_bullet:    dc.b ADF_SIMPLE|ADF_FLICKER             ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 3                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 97,98,99                           ;Frames
                dc.b 97+$80,98+$80,99+$80

actd_explosion: dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_COMMON                        ;Spritefile number
                dc.b 0,1,2,3,4                          ;Frames

actd_smokecloud:dc.b ADF_SIMPLE|ADF_FLICKER             ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 73,74                              ;Frames

actd_balloon:   dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 105,113                            ;Frames

actd_doorhint:  dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 106                                ;Frames


actd_item:      dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_PACKED                        ;Spritefile number
                dc.b 0                                  ;None (empty)
                dc.b 55                                 ;Fists
                dc.b 44                                 ;Baton
                dc.b 45                                 ;Knife
                dc.b 46                                 ;Katana
                dc.b 47                                 ;Shuriken
                dc.b 52                                 ;Grenade
                dc.b 66                                 ;Parasite
                dc.b 50                                 ;Dartgun
                dc.b 50                                 ;Taser
                dc.b 48                                 ;Pistol
                dc.b 58                                 ;Stealth pistol
                dc.b 49                                 ;SMG
                dc.b 48                                 ;Magnum pistol
                dc.b 51                                 ;Shotgun
                dc.b 60                                 ;Auto shotgun
                dc.b 60                                 ;Assault rifle
                dc.b 61                                 ;Machine gun
                dc.b 59                                 ;Sniper rifle
                dc.b 61                                 ;Laser rifle
                dc.b 62                                 ;Flamethrower
                dc.b 64                                 ;Missile launcher
                dc.b 63                                 ;Gas fist
                dc.b 65                                 ;Psionic rifle
                dc.b 54                                 ;Darts
                dc.b 54                                 ;9mm ammo
                dc.b 54                                 ;.44 ammo
                dc.b 54                                 ;12gauge buckshot
                dc.b 54                                 ;5.56 ammo
                dc.b 54                                 ;7.62 ammo
                dc.b 69                                 ;Napalm canister
                dc.b 71                                 ;Missiles
                dc.b 57                                 ;Cell ammo
                dc.b 67                                 ;Plutonium ammo
                dc.b 53                                 ;First aid
                dc.b 56                                 ;Recharger
                dc.b 107                                ;Beer
                dc.b 104                                ;Credits
                dc.b 68                                 ;Vitality aug.
                dc.b 68                                 ;Strength aug.
                dc.b 70                                 ;Beta armor
                dc.b 70                                 ;Gamma armor
                dc.b 70                                 ;Delta armor
                dc.b 70                                 ;Epsilon armor
                dc.b 108                                ;Agent trenchcoat
                dc.b 72                                 ;Maintenance accesscard
                dc.b 72                                 ;Basement accesscard
                dc.b 72                                 ;Armory
                dc.b 72                                 ;Train
                dc.b 72                                 ;Cells
                dc.b 72                                 ;Security
                dc.b 72                                 ;Lift
                dc.b 72                                 ;Reactor
                dc.b 72                                 ;Teleport
                dc.b 109                                ;Code sheets
                dc.b 109
                dc.b 109
                dc.b 109
                dc.b 72                                 ;Generator
                dc.b 111                                ;Lever
                dc.b 112                                ;Triangular crystal
                dc.b 110                                ;Letter
                dc.b 108                                ;Fake agent trenchcoat

actd_agent:     dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_AGENT                         ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_streetcop: dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 18                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_COP                           ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_COP                           ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_nonagent:  dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 11                                 ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                          ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 1
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_IAN                           ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2


actd_thug1a:    dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 12                                 ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                          ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 8                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_THUGS                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_thug1b:    dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 12                                 ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                           ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_THUGS                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_thug1c:    dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                           ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 6                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_THUGS                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2


actd_thug2a:    dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 12                                  ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                           ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 4                                  ;Color override 2
                dc.b 18                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_THUGS                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_thug2b:    dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                           ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 11                                 ;Color override 2
                dc.b 18                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_THUGS                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_thug2c:    dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 12                                 ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                           ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 9                                  ;Color override 2
                dc.b 18                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_THUGS                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_weaponshop:dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_INSIDE                        ;Spritefile number
                dc.b 0                                  ;Frames

actd_tech:      dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_TECH                           ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_TECH                           ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_techboss:  dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 5                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_TECH                          ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 5                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_TECH                           ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_techiac:   dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 11                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_TECH                          ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 11                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_TECH                           ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_bystand1:  dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 12                                 ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                          ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_BYSTAND                       ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_bystand2:  dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 11                                 ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                          ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 6                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_BYSTAND                       ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_bystand3:  dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 14                                 ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                          ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 12                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_BYSTAND                       ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_bystand4:  dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 12                                 ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                          ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 4                                  ;Color override 2
                dc.b 12                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_BYSTAND                       ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_scientistm:dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 18                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_SCIENTIST                     ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_SCIENTIST                      ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_scientistf:dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 18                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_SCIENTIST                     ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 39                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_SCIENTIST                      ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_techlight: dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 2                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_TECH                           ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 2                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_TECH                           ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_grunt1:    dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_GRUNT                          ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_GRUNT                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_grunt2:    dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 8                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_GRUNT                          ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 8                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_GRUNT                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_grunt3:    dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 5                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_GRUNT                          ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 5                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_GRUNT                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_gruntcmdr: dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 14                                 ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_GRUNT                          ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 14                                 ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_GRUNT                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_snowgrunt: dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 15                                 ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_GRUNT                          ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 15                                 ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_GRUNT                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_snowtech:  dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 15                                 ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_TECH                          ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 15                                 ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_TECH                           ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_commando1: dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_COMMANDO                      ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_COMMANDO                       ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_commando2: dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 6                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_COMMANDO                      ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 6                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_COMMANDO                       ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_enemyagentm1:dc.b ADF_HUMANOID|ADF_WEAPON          ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_ENEMYAGENT                     ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_enemyagentm2:dc.b ADF_HUMANOID|ADF_WEAPON          ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 8                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_ENEMYAGENT                     ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_enemyagentf1:dc.b ADF_HUMANOID|ADF_WEAPON          ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 22                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_ENEMYAGENT                     ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_enemyagentf2:dc.b ADF_HUMANOID|ADF_WEAPON          ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 9                                  ;Color override 2
                dc.b 22                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_ENEMYAGENT                     ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_priest1:   dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 18                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_PRIEST                        ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_PRIEST                         ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_priest2:   dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 8                                  ;Color override 1
                dc.b 18                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_PRIEST                        ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 8                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_PRIEST                         ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_ahriman:   dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 2                                  ;Color override 1
                dc.b 18                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_PRIEST                        ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 36                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_PRIEST                         ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_suhrim:    dc.b ADF_HUMANOID|ADF_WEAPON          ;Display flags
                dc.b 6                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 6                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_ENEMYAGENT                     ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_lilith:    dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 6                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 6                                  ;Color override 2
                dc.b 22                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_ENEMYAGENT                     ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_ceilturret:dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 3                                  ;Left frame add
                dc.b SPRF_TURRET                        ;Spritefile number
                dc.b 0,2,4,1,3,5                        ;Frames

actd_floorturret:dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 3                                  ;Left frame add
                dc.b SPRF_TURRET                        ;Spritefile number
                dc.b 6,8,10,7,9,11                      ;Frames

actd_heavyturret:dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 3                                  ;Left frame add
                dc.b SPRF_HEAVYTURRET                   ;Spritefile number
                dc.b 0,2,4,1,3,5                        ;Frames

actd_securitybot:dc.b ADF_NORMAL                        ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 4                                  ;Left frame add
                dc.b SPRF_ROBOT                         ;Spritefile number
                dc.w fr_robot                           ;Frame ptr
                dc.b 8                                  ;Frame amount
                dc.b 4                                  ;Sprite amount
fr_robot:       dc.b 7,8,7,8,16,17,16,17
                dc.b 4,5,4,6,13,14,13,15
                dc.b 0,1,0,2,9,10,9,11
                dc.b 3,3,3,3,12,12,12,12

actd_spiderbot: dc.b ADF_NORMAL                        ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 8                                 ;Left frame add
                dc.b SPRF_SPIDERBOT                     ;Spritefile number
                dc.w fr_spiderbot                       ;Frame ptr
                dc.b 16                                 ;Frame amount
                dc.b 2                                  ;Sprite amount
fr_spiderbot:   dc.b 0,0,4,2,0,4,2,2
                dc.b 6,6,10,8,6,10,8,8
                dc.b 1,3,5,1,3,5,1,3
                dc.b 7,9,11,7,9,11,7,9

actd_minicopter:dc.b ADF_NORMAL                        ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 2                                 ;Left frame add
                dc.b SPRF_MINICOPTER                    ;Spritefile number
                dc.w fr_minicopter                      ;Frame ptr
                dc.b 4                                  ;Frame amount
                dc.b 4                                  ;Sprite amount
fr_minicopter:  dc.b 5,5,11,11
                dc.b 4,4,10,10
                dc.b 0,2,6,8
                dc.b 1,3,7,9

actd_iac:       dc.b ADF_NORMAL                        ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                 ;Left frame add
                dc.b SPRF_IAC                           ;Spritefile number
                dc.w fr_iac                             ;Frame ptr
                dc.b 2                                  ;Frame amount
                dc.b 8                                  ;Sprite amount
fr_iac:         dc.b 6,9
                dc.b 7,7
                dc.b 3,3
                dc.b 2,2
                dc.b 1,1
                dc.b 0,0
                dc.b 4,4
                dc.b 5,8

actd_exoskeleton:dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 16                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_EXOSKELETON                   ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_EXOSKELETON                   ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_seeker:    dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_SPIDERBOT                     ;Spritefile number
                dc.b 12,13,14,13                        ;Frames

actd_mutant1:   dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 7                                  ;Left frame add
                dc.b SPRF_MUTANT1                       ;Spritefile number
                dc.b 0,1,0,1,2,3,4                          ;Frames
                dc.b 5,6,5,6,7,8,9

actd_mutant2:   dc.b ADF_NORMAL                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 7                                  ;Left frame add
                dc.b SPRF_MUTANT2                       ;Spritefile number
                dc.w fr_mutant2                         ;Frame ptr
                dc.b 14                                 ;Frame amount
                dc.b 4                                  ;Sprite amount
fr_mutant2:     dc.b 7,6,7,8,9,9,13,21,20,21,22,23,23,27
                dc.b 1,1,1,1,1,1,11,15,15,15,15,15,15,25
                dc.b 0,0,0,0,0,0,10,14,14,14,14,14,14,24
                dc.b 3,2,3,4,5,5,12,17,16,17,18,19,19,26

actd_hovercar:  dc.b ADF_NORMAL                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_HOVERCAR                      ;Spritefile number
                dc.w fr_hovercar                        ;Frame ptr
                dc.b 6                                  ;Frame amount
                dc.b 6                                                  ;Sprite amount
fr_hovercar:    dc.b 9,17,12,20,14,22
                dc.b 10,18,4,4,15,23
                dc.b 2,2,3,3,7,7
                dc.b 1,1,11,19,6,6
                dc.b 0,0,255,255,5,5
                dc.b 8,16,255,255,13,21

actd_sentineliac:
                dc.b ADF_SIMPLE|ADF_FLICKER             ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_HOVERCAR                      ;Spritefile number
                dc.b 24,24,24,24,24,24                  ;Frames

actd_blackhand: dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                  ;Left frame add 2
                dc.b SPRF_BLACKHAND                     ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_sarge:     dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 12                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                  ;Left frame add 2
                dc.b SPRF_BLACKHAND                     ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_blowfish:  dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 19                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_BLOWFISH                      ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                  ;Left frame add 2
                dc.b SPRF_BLOWFISH                      ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_sadok:     dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 12                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_BAND                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_goat:      dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 12                                 ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                          ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 1
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_GOAT                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_bartender: dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 1                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_INSIDE                        ;Spritefile number
                dc.b 0                                  ;Frames

actd_exagent:   dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_INSIDE                        ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_band:      dc.b ADF_NORMAL                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_INSIDE                        ;Spritefile number
                dc.w fr_band                            ;Frame ptr
                dc.b 4                                  ;Frame amount
                dc.b 5                                  ;Sprite amount
fr_band:        dc.b 4,5,4,5
                dc.b 6,7,8,9
                dc.b 10,10,10,10
                dc.b 15,15,15,15
                dc.b 11,12,13,14

actd_joanagent: dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_AGENT                         ;Spritefile number 1
                dc.w fr_legs                            ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_JOANAGENT                     ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_ironfist:  dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 12                                 ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                          ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 19                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_INSIDE                        ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_ultrashred:dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 1                                  ;Color override 1
                dc.b 18                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_SCIENTIST                     ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 15                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_INSIDE                         ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_lordobskurius:dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 11                                ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                          ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 6                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_BAND                           ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_satanakhia:dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 9                                  ;Color override 1
                dc.b 22                                 ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_GRUNT                         ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_BAND                          ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_joancivilian:dc.b ADF_HUMANOID|ADF_WEAPON            ;Display flags
                dc.b 12                                 ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_LEGS                          ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 0                                  ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_JOANAGENT                      ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_obskuriushead:
                dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 1                                  ;Left frame add
                dc.b SPRF_PRIEST                        ;Spritefile number
                dc.b 54,55                              ;Frames

actd_councilheadm:
                dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 1                                  ;Left frame add
                dc.b SPRF_PRIEST                        ;Spritefile number
                dc.b 56,57                              ;Frames

actd_councilheadf:
                dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 0                                  ;Baseframe add
                dc.b 1                                  ;Left frame add
                dc.b SPRF_PRIEST                        ;Spritefile number
                dc.b 58,59                              ;Frames

actd_sentinel:  dc.b ADF_HUMANOID|ADF_FLICKER           ;Display flags
                dc.b 0                                  ;Color override 1
                dc.b 0                                  ;Baseframe add 1
                dc.b 20                                 ;Left frame add 1
                dc.b SPRF_SENTINEL                      ;Spritefile number 1
                dc.w fr_legs2                           ;Frame pointer 1
                dc.b 0                                  ;Color override 2
                dc.b 10                                 ;Baseframe add 2
                dc.b 36                                 ;Left frame add 2
                dc.b SPRF_SENTINEL                      ;Spritefile number 2
                dc.w fr_torso                           ;Frame pointer 2

actd_joanlevitate:
                dc.b ADF_NORMAL                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 16                                 ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_SENTINEL                      ;Spritefile number
                dc.w fr_joanlevitate                    ;Frame ptr
                dc.b 2                                  ;Frame amount
                dc.b 2                                  ;Sprite amount
fr_joanlevitate:dc.b 2,3
                dc.b 0,1

actd_bat:       dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 10                                 ;Baseframe add
                dc.b 6                                  ;Left frame add
                dc.b SPRF_MUTANT1                       ;Spritefile number
                dc.b 1,0,1,2,0,1                        ;Frames
                dc.b 4,3,4,5,3,4

actd_tvscreen:  dc.b ADF_SIMPLE|ADF_FLICKER             ;Display flags
                dc.b 0                                  ;Color override
                dc.b 19                                 ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_BLACKHAND                     ;Spritefile number
actd_tvscreenframe:
                dc.b 0                                  ;Frames

actd_axesmith:  dc.b ADF_SIMPLE                         ;Display flags
                dc.b 0                                  ;Color override
                dc.b 16                                 ;Baseframe add
                dc.b 0                                  ;Left frame add
                dc.b SPRF_INSIDE                        ;Spritefile number
                dc.b 0                                  ;Frames

fr_legs:        dc.b 0                                ;Stand
                dc.b 2                                ;Run
                dc.b 4
                dc.b 6
                dc.b 2
                dc.b 4
                dc.b 6
                dc.b 8                                ;Jump
                dc.b 10                               ;Duck
                dc.b 12
                dc.b 10
                dc.b 12
                dc.b 18                               ;Climb
                dc.b 19
                dc.b 18
                dc.b 20
                dc.b 14                               ;Dead
                dc.b 16
                dc.b 18                               ;Door
                dc.b 21                               ;Sit
                dc.b 1                                ;Stand
                dc.b 3                                ;Run
                dc.b 5
                dc.b 7
                dc.b 3
                dc.b 5
                dc.b 7
                dc.b 9                                ;Jump
                dc.b 11                               ;Duck
                dc.b 13
                dc.b 11
                dc.b 13
                dc.b 18                               ;Climb
                dc.b 19
                dc.b 18
                dc.b 20
                dc.b 15                               ;Dead
                dc.b 17
                dc.b 18                               ;Door
                dc.b 22                               ;Sit

fr_legs2:       dc.b 0                                ;Stand
                dc.b 2                                ;Run
                dc.b 4
                dc.b 6
                dc.b 2
                dc.b 4
                dc.b 6
                dc.b 8                                ;Jump
                dc.b 10                               ;Duck
                dc.b 12
                dc.b 10
                dc.b 12
                dc.b 18                               ;Climb
                dc.b 18
                dc.b 18
                dc.b 18
                dc.b 14                               ;Dead
                dc.b 16
                dc.b 18                               ;Door
                dc.b 19                               ;Sit
                dc.b 1                                ;Stand
                dc.b 3                                ;Run
                dc.b 5
                dc.b 7
                dc.b 3
                dc.b 5
                dc.b 7
                dc.b 9                                ;Jump
                dc.b 11                               ;Duck
                dc.b 13
                dc.b 11
                dc.b 13
                dc.b 18                               ;Climb
                dc.b 18
                dc.b 18
                dc.b 18
                dc.b 15                               ;Dead
                dc.b 17
                dc.b 18                               ;Door
                dc.b 20                               ;Sit



fr_torso:       dc.b 0                                ;Stand
                dc.b 0                                ;Run
                dc.b 2
                dc.b 4
                dc.b 4
                dc.b 2
                dc.b 0
                dc.b 0                                ;Jump
                dc.b 0                                ;Duck
                dc.b 2
                dc.b 4
                dc.b 2
                dc.b 20                               ;Climb
                dc.b 19
                dc.b 20
                dc.b 21
                dc.b 8                                ;Dead
                dc.b 16
                dc.b 18                               ;Door
                dc.b 2                                ;Sit
                dc.b 8                                ;Melee
                dc.b 6
                dc.b 10                               ;Aim
                dc.b 12
                dc.b 14
                dc.b 2                                ;Shoot from hip
                dc.b 4
                dc.b 0
                dc.b 9                                ;Melee backwards
                dc.b 7
                dc.b 11                               ;Aim backwards
                dc.b 13
                dc.b 15
                dc.b 3                                ;Shoot from hip backwards
                dc.b 5
                dc.b 1
                dc.b 1                                ;Stand
                dc.b 1                                ;Run
                dc.b 3
                dc.b 5
                dc.b 5
                dc.b 3
                dc.b 1
                dc.b 1                                ;Jump
                dc.b 1                                ;Duck
                dc.b 3
                dc.b 5
                dc.b 3
                dc.b 20                               ;Climb
                dc.b 19
                dc.b 20
                dc.b 21
                dc.b 9                                ;Dead
                dc.b 17
                dc.b 18                               ;Door
                dc.b 3                                ;Sit
                dc.b 9                                ;Melee
                dc.b 7
                dc.b 11                               ;Aim
                dc.b 13
                dc.b 15
                dc.b 3                                ;Shoot from hip
                dc.b 5
                dc.b 1
                dc.b 8                                ;Melee backwards
                dc.b 6
                dc.b 10                               ;Aim backwards
                dc.b 12
                dc.b 14
                dc.b 2                                ;Shoot from hip backwards
                dc.b 4
                dc.b 0

        ;Actor logic data

actltbl:        dc.w actl_agent
                dc.w actl_item
                dc.w actl_smokecloud
                dc.w actl_shrapnel
                dc.w actl_explosion
                dc.w actl_bulletflash
                dc.w actl_bulletflash
                dc.w actl_bullet
                dc.w actl_shuriken
                dc.w actl_bullet
                dc.w actl_grenade
                dc.w actl_meleehit
                dc.w actl_laser
                dc.w actl_flame
                dc.w actl_electricity
                dc.w actl_bullet
                dc.w actl_missile
                dc.w actl_parasite
                dc.w actl_psionic
                dc.w actl_zsign
                dc.w actl_lift
                dc.w actl_doorhint
                dc.w actl_balloon
                dc.w actl_lift
                dc.w actl_streetcop
                dc.w actl_nonagent
                dc.w actl_thug
                dc.w actl_thug2
                dc.w actl_thug
                dc.w actl_thug2
                dc.w actl_thug
                dc.w actl_thug2
                dc.w actl_idle
                dc.w actl_tech
                dc.w actl_techboss
                dc.w actl_grunt
                dc.w actl_bystand2
                dc.w actl_bystand1
                dc.w actl_bystand2
                dc.w actl_bystand1
                dc.w actl_scientist
                dc.w actl_scientist
                dc.w actl_tech
                dc.w actl_grunt
                dc.w actl_grunt
                dc.w actl_grunt
                dc.w actl_commando ;Grunt cmdr
                dc.w actl_grunt
                dc.w actl_tech
                dc.w actl_commando
                dc.w actl_commando
                dc.w actl_enemyagent
                dc.w actl_enemyagent
                dc.w actl_enemyagent
                dc.w actl_enemyagent
                dc.w actl_priest
                dc.w actl_priest
                dc.w actl_ahriman
                dc.w actl_suhrim
                dc.w actl_lilith                        ;Lilith
                dc.w actl_bystand2                      ;Lilith's 1st appearance
                dc.w actl_iac
                dc.w actl_ceilturret
                dc.w actl_floorturret
                dc.w actl_heavyturret
                dc.w actl_securitybot
                dc.w actl_spiderbot
                dc.w actl_minicopter
                dc.w actl_bystand2                      ;Ahriman bystander
                dc.w actl_bystand2                      ;Suhrim bystander
                dc.w actl_iac
                dc.w actl_exoskeleton
                dc.w actl_seeker
                dc.w actl_mutant1
                dc.w actl_mutant2
                dc.w actl_hovercar
                dc.w actl_blackhand              ;Blackhand
                dc.w actl_blackhand              ;Sarge
                dc.w actl_techboss                      ;Sarge as traitor
                dc.w actl_blowfish                      ;Blowfish
                dc.w actl_goat
                dc.w actl_sentinel
                dc.w actl_bystand1
                dc.w actl_idle
                dc.w actl_band
                dc.w actl_joanagent
                dc.w actl_ironfist
                dc.w actl_bystand2                      ;Dr.Ultrashred
                dc.w actl_bystand2                      ;Lord Obskurius
                dc.w actl_bystand2                      ;Satanakhia
                dc.w actl_joanagent                     ;Joan as civilian
                dc.w actl_head
                dc.w actl_head
                dc.w actl_head
                dc.w actl_sentinel                      ;The Sentinel
                dc.w actl_joanlevitate
                dc.w actl_bat
                dc.w actl_observer                      ;Player as
                                                        ;invisible observer
                dc.w actl_idle                          ;TV screen
                dc.w actl_idle                          ;Axesmith
                dc.w actl_hovercar                      ;Sentinel IAC
                dc.w actl_bystand2                      ;Sadok
                dc.w actl_widemeleehit

actl_parasite:  dc.w 0                                  ;AI
                dc.w move_parasite                      ;Moveroutine
                dc.b 4                                  ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 8                                  ;Size up
                dc.b 8                                  ;Size up (ducking)

actl_psionic:   dc.w 0                                  ;AI
                dc.w move_psionic                       ;Moveroutine
                dc.b 4                                  ;Size left/right
                dc.b 4                                  ;Size down
                dc.b 4                                  ;Size up
                dc.b 4                                  ;Size up (ducking)

actl_missile:   dc.w 0                                  ;AI
                dc.w move_missile                       ;Moveroutine
                dc.b 4                                  ;Size left/right
                dc.b 2                                  ;Size down
                dc.b 2                                  ;Size up
                dc.b 2                                  ;Size up (ducking)

actl_flame:     dc.w 0                                  ;AI
                dc.w move_flame                         ;Moveroutine
                dc.b 6                                  ;Size left/right
                dc.b 4                                  ;Size down
                dc.b 6                                  ;Size up
                dc.b 6                                  ;Size up (ducking)


actl_laser:     dc.w 0                                  ;AI
                dc.w move_laser                         ;Moveroutine
                dc.b 8                                  ;Size left/right
                dc.b 2                                  ;Size down
                dc.b 2                                  ;Size up
                dc.b 2                                  ;Size up (ducking)


actl_meleehit:  dc.w 0                                  ;AI
                dc.w move_meleehit                      ;Moveroutine
                dc.b 4                                  ;Size left/right
                dc.b 3                                  ;Size down
                dc.b 3                                  ;Size up
                dc.b 3                                  ;Size up (ducking)

actl_widemeleehit:
                dc.w 0                                  ;AI
                dc.w move_meleehit                      ;Moveroutine
                dc.b 6                                  ;Size left/right
                dc.b 3                                  ;Size down
                dc.b 3                                  ;Size up
                dc.b 3                                  ;Size up (ducking)


actl_grenade:   dc.w 0                                  ;AI
                dc.w move_grenade                       ;Moveroutine
                dc.b 4                                  ;Size left/right
                dc.b 4                                  ;Size down
                dc.b 4                                  ;Size up
                dc.b 4                                  ;Size up (ducking)

actl_shuriken:  dc.w 0                                  ;AI
                dc.w move_shuriken                      ;Moveroutine
                dc.b 4                                  ;Size left/right
                dc.b 2                                  ;Size down
                dc.b 2                                  ;Size up
                dc.b 2                                  ;Size up (ducking)

actl_bulletflash:
                dc.w 0                                  ;AI
                dc.w move_bulletflash                   ;Moveroutine
                dc.b 3                                  ;Size left/right
                dc.b 1                                  ;Size down
                dc.b 1                                  ;Size up
                dc.b 1                                  ;Size up (ducking)

actl_bullet:    dc.w 0                                  ;AI
                dc.w move_bullet                        ;Moveroutine
                dc.b 3                                  ;Size left/right
                dc.b 1                                  ;Size down
                dc.b 1                                  ;Size up
                dc.b 1                                  ;Size up (ducking)

actl_electricity:dc.w 0                                  ;AI
                dc.w move_bullet                        ;Moveroutine
                dc.b 8                                  ;Size left/right
                dc.b 2                                  ;Size down
                dc.b 2                                  ;Size up
                dc.b 2                                  ;Size up (ducking)


actl_explosion: dc.w 0                                  ;AI
                dc.w move_explosion                     ;Moveroutine
                dc.b 12                                 ;Size left/right
                dc.b 10                                 ;Size down
                dc.b 10                                 ;Size up
                dc.b 10                                 ;Size up (ducking)

actl_shrapnel:  dc.w 0                                  ;AI
                dc.w move_shrapnel                      ;Moveroutine

actl_smokecloud:dc.w 0                                  ;AI
                dc.w move_smokecloud                    ;Moveroutine

actl_zsign:     dc.w 0                                  ;AI
                dc.w move_zsign                         ;Moveroutine

actl_balloon:   dc.w 0                                  ;AI
                dc.w move_balloon                       ;Moveroutine

actl_doorhint:  dc.w 0                                  ;AI
                dc.w move_doorhint                      ;Moveroutine


actl_agent:     dc.w thinker_player                     ;AI
                dc.w move_human                         ;Moveroutine
                dc.b 8                                  ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_AGENT                           ;Default batt.
                dc.b HP_AGENT                           ;Default armor
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_HEAVY           ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP|ACB_CLIMB|ACB_WALLFLIP ;Caps
                dc.b GRP_AGENTS                         ;Group alliance
                dc.b 32                                 ;Speed pos
                dc.b -32                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -36                                ;Jumpspeed
                dc.b 96                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 0                                  ;Takedown score

actl_nonagent:  dc.w thinker_player                     ;AI
                dc.w move_human                         ;Moveroutine
                dc.b 8                                  ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_NONAGENT                     ;Default batt.
                dc.b HP_NONAGENT                        ;Default armor
                dc.b AFB_ORGANIC|AFB_HUMANOID           ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP    ;Caps
                dc.b GRP_AGENTS                         ;Group alliance
                dc.b 32                                 ;Speed pos
                dc.b -32                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -36                                ;Jumpspeed
                dc.b 96                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 0                                  ;Takedown score

actl_item:      dc.w 0                                  ;Ai routine (none)
                dc.w move_item                          ;Moveroutine
                dc.b 8                                  ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 8                                  ;Size up
                dc.b 8                                  ;Size up (ducking)

actl_lift:      dc.w thinker_lift                       ;AI
                dc.w move_lift                          ;Moveroutine
                dc.b 32                                 ;Size left/right
                dc.b 8                                  ;Size down
                dc.b 0                                  ;Size up
                dc.b 0                                  ;Size up (ducking)
                dc.b 0                                  ;Default batt.
                dc.b 1                                  ;Default hp
                dc.b 0                                  ;Fighting bits
                dc.b 0                                  ;Caps
                dc.b GRP_LIFT                           ;Group alliance


        ;Enemies/NPCs

actl_streetcop: dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_STREETCOP                    ;Default batt.
                dc.b HP_STREETCOP                       ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES      ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP ;Caps
                dc.b GRP_COPS                           ;Group alliance
                dc.b 30                                 ;Speed pos
                dc.b -30                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -36                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 0                                  ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 4                                  ;Patrol radius
                dc.b 5                                  ;Alert radius
                dc.b 20                                 ;Patrol idle time
                dc.b 80                                 ;Get bored-time (routecheck)
                dc.b $30                                ;Attack probability (positive)
                dc.b $70                                ;Melee attack probability (positive)
                dc.b $fc                                ;Ducking probability (negative)
                dc.b $d0                                ;Ducking probability when shot at (negative)
                dc.b $f8                                ;Ducking exit prob. (negative)
                dc.b $24                                ;Duck-attack probability (positive)
                dc.b $04                                ;Jump instead of duck (positive)
                dc.b $04                                ;Patrol idle prob.

actl_thug:      dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_THUG                         ;Default batt.
                dc.b HP_THUG                            ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR|AFB_REACTVISUAL|AFB_REACTNOISE      ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP ;Caps
                dc.b GRP_CRIMINAL1                      ;Group alliance
                dc.b 26                                 ;Speed pos
                dc.b -26                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -30                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 350                                ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 4                                  ;Patrol radius
                dc.b 4                                  ;Alert radius
                dc.b 5                                  ;Patrol idle time
                dc.b 40                                 ;Get bored-time (routecheck)
                dc.b $28                                ;Attack probability (positive)
                dc.b $68                                ;Melee attack probability (positive)
                dc.b $fe                                ;Ducking probability (negative)
                dc.b $e8                                ;Ducking probability when shot at (negative)
                dc.b $f8                                ;Ducking exit prob. (negative)
                dc.b $1c                                ;Duck-attack probability (positive)
                dc.b $02                                ;Jump instead of duck (positive)
                dc.b $02                                ;Patrol idle prob.


actl_thug2:     dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_THUG                         ;Default batt.
                dc.b HP_THUG                            ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR|AFB_REACTVISUAL|AFB_REACTNOISE     ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP ;Caps
                dc.b GRP_CRIMINAL2                      ;Group alliance
                dc.b 30                                 ;Speed pos
                dc.b -30                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -30                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 500                                ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 4                                  ;Patrol radius
                dc.b 5                                  ;Alert radius
                dc.b 5                                  ;Patrol idle time
                dc.b 60                                 ;Get bored-time (routecheck)
                dc.b $34                                ;Attack probability (positive)
                dc.b $70                                ;Melee attack probability (positive)
                dc.b $f8                                ;Ducking probability (negative)
                dc.b $e4                                ;Ducking probability when shot at (negative)
                dc.b $f4                                ;Ducking exit prob. (negative)
                dc.b $1e                                ;Duck-attack probability (positive)
                dc.b $02                                ;Jump instead of duck (positive)
                dc.b $04                                ;Patrol idle prob.

actl_idle:      dc.w 0                                  ;AI
                dc.w move_stationary                    ;Moveroutine
                dc.b 8                                  ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 16                                 ;Size up
                dc.b 16                                 ;Size up (ducking)
                dc.b 0                                  ;Default batt.
                dc.b 1                                  ;Default hp
                dc.b 0                                  ;Fighting bits
                dc.b 0                                  ;Caps
                dc.b GRP_BYSTANDER                      ;Group alliance

actl_tech:      dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_TECH                         ;Default batt.
                dc.b HP_TECH                            ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES      ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP|ACB_CLIMB ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 31                                 ;Speed pos
                dc.b -31                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -34                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 750                                ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 5                                  ;Patrol radius
                dc.b 5                                  ;Alert radius
                dc.b 10                                 ;Patrol idle time
                dc.b 60                                 ;Get bored-time (routecheck)
                dc.b $2c                                ;Attack probability (positive)
                dc.b $80                                ;Melee attack probability (positive)
                dc.b $f4                                ;Ducking probability (negative)
                dc.b $e0                                ;Ducking probability when shot at (negative)
                dc.b $f8                                ;Ducking exit prob. (negative)
                dc.b $24                                ;Duck-attack probability (positive)
                dc.b $20                                ;Jump instead of duck (positive)
                dc.b $18                                ;Patrol idle prob.

actl_techboss:  dc.w thinker_mammal                     ;AI
                dc.w move_human                         ;Moveroutine (NO REMOVE!)
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_TECHBOSS                    ;Default batt.
                dc.b HP_TECHBOSS                       ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES   ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP|ACB_CLIMB ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 34                                 ;Speed pos
                dc.b -34                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -36                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 5000                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 6                                  ;Patrol radius
                dc.b 6                                  ;Alert radius
                dc.b 5                                  ;Patrol idle time
                dc.b 80                                 ;Get bored-time (routecheck)
                dc.b $38                                ;Attack probability (positive)
                dc.b $a0                                ;Melee attack probability (positive)
                dc.b $f4                                ;Ducking probability (negative)
                dc.b $f0                                ;Ducking probability when shot at (negative)
                dc.b $f4                                ;Ducking exit prob. (negative)
                dc.b $1c                                ;Duck-attack probability (positive)
                dc.b $60                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_bystand1:  dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b 0                                  ;Default batt.
                dc.b 1                                  ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR ;Fighting bits
                dc.b ACB_JUMP                           ;Caps
                dc.b GRP_BYSTANDER                      ;Group alliance
                dc.b 24                                 ;Speed pos
                dc.b -24                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -30                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 0                                  ;Takedown score
                dc.b RM_SELFDEFENSE                     ;Reaction to opposite groups
                dc.b 2                                  ;Patrol radius
                dc.b 2                                  ;Alert radius
                dc.b 2                                  ;Patrol idle time
                dc.b 80                                 ;Get bored-time (routecheck)
                dc.b $20                                ;Attack probability (positive)
                dc.b $80                                ;Melee attack probability (positive)
                dc.b $f0                                ;Ducking probability (negative)
                dc.b $c8                                ;Ducking probability when shot at (negative)
                dc.b $fa                                ;Ducking exit prob. (negative)
                dc.b $20                                ;Duck-attack probability (positive)
                dc.b $10                                ;Jump instead of duck (positive)
                dc.b $01                                ;Patrol idle prob.



actl_bystand2:  dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b 0                                  ;Default batt.
                dc.b 1                                  ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR ;Fighting bits
                dc.b ACB_JUMP                           ;Caps
                dc.b GRP_BYSTANDER                      ;Group alliance
                dc.b 28                                 ;Speed pos
                dc.b -28                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -30                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 0                                  ;Takedown score
                dc.b RM_SELFDEFENSE                     ;Reaction to opposite groups
                dc.b 2                                  ;Patrol radius
                dc.b 2                                  ;Alert radius
                dc.b 2                                  ;Patrol idle time
                dc.b 80                                 ;Get bored-time (routecheck)
                dc.b $20                                ;Attack probability (positive)
                dc.b $80                                ;Melee attack probability (positive)
                dc.b $f0                                ;Ducking probability (negative)
                dc.b $c8                                ;Ducking probability when shot at (negative)
                dc.b $fa                                ;Ducking exit prob. (negative)
                dc.b $20                                ;Duck-attack probability (positive)
                dc.b $10                                ;Jump instead of duck (positive)
                dc.b $01                                ;Patrol idle prob.

actl_grunt:     dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_GRUNT                           ;Default batt.
                dc.b HP_GRUNT                           ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES      ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP|ACB_CLIMB ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 28                                 ;Speed pos
                dc.b -28                                ;Speed neg
                dc.b 3                                  ;Accel pos
                dc.b -3                                 ;Accel neg
                dc.b -34                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 1250                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 5                                  ;Patrol radius
                dc.b 6                                  ;Alert radius
                dc.b 20                                 ;Patrol idle time
                dc.b 80                                 ;Get bored-time (routecheck)
                dc.b $34                                ;Attack probability (positive)
                dc.b $90                                ;Melee attack probability (positive)
                dc.b $fa                                ;Ducking probability (negative)
                dc.b $c8                                ;Ducking probability when shot at (negative)
                dc.b $f0                                ;Ducking exit prob. (negative)
                dc.b $28                                ;Duck-attack probability (positive)
                dc.b $04                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_scientist: dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_SCIENTIST                    ;Default batt.
                dc.b HP_SCIENTIST                       ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES      ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP     ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 29                                 ;Speed pos
                dc.b -29                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -30                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 1000                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 4                                  ;Patrol radius
                dc.b 5                                  ;Alert radius
                dc.b 2                                  ;Patrol idle time
                dc.b 100                                ;Get bored-time (routecheck)
                dc.b $24                                ;Attack probability (positive)
                dc.b $90                                ;Melee attack probability (positive)
                dc.b $f4                                ;Ducking probability (negative)
                dc.b $dc                                ;Ducking probability when shot at (negative)
                dc.b $f6                                ;Ducking exit prob. (negative)
                dc.b $28                                ;Duck-attack probability (positive)
                dc.b $20                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.


actl_commando:  dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_COMMANDO                        ;Default batt.
                dc.b HP_COMMANDO                        ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES      ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP|ACB_CLIMB ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 34                                 ;Speed pos
                dc.b -34                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -38                                ;Jumpspeed
                dc.b 96                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 1500                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 5                                  ;Patrol radius
                dc.b 6                                  ;Alert radius
                dc.b 15                                 ;Patrol idle time
                dc.b 100                                ;Get bored-time (routecheck)
                dc.b $3c                                ;Attack probability (positive)
                dc.b $90                                ;Melee attack probability (positive)
                dc.b $f8                                ;Ducking probability (negative)
                dc.b $c0                                ;Ducking probability when shot at (negative)
                dc.b $f6                                ;Ducking exit prob. (negative)
                dc.b $2a                                ;Duck-attack probability (positive)
                dc.b $38                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_enemyagent:dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_ENEMYAGENT                      ;Default batt.
                dc.b HP_ENEMYAGENT                      ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES      ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP|ACB_CLIMB ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 31                                 ;Speed pos
                dc.b -31                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -36                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 1750                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 5                                  ;Patrol radius
                dc.b 6                                  ;Alert radius
                dc.b 5                                  ;Patrol idle time
                dc.b 120                                ;Get bored-time (routecheck)
                dc.b $40                                ;Attack probability (positive)
                dc.b $94                                ;Melee attack probability (positive)
                dc.b $f6                                ;Ducking probability (negative)
                dc.b $b0                                ;Ducking probability when shot at (negative)
                dc.b $f4                                ;Ducking exit prob. (negative)
                dc.b $2a                                ;Duck-attack probability (positive)
                dc.b $18                                ;Jump instead of duck (positive)
                dc.b $04                                ;Patrol idle prob.

actl_priest:    dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_PRIEST                       ;Default batt.
                dc.b HP_PRIEST                          ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES      ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LEVITATE     ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 24                                ;Speed pos
                dc.b -24                                ;Speed neg
                dc.b 3                                  ;Accel pos
                dc.b -3                                 ;Accel neg
                dc.b -18                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 2000                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 5                                  ;Patrol radius
                dc.b 5                                  ;Alert radius
                dc.b 2                                  ;Patrol idle time
                dc.b 100                                ;Get bored-time (routecheck)
                dc.b $40                                ;Attack probability (positive)
                dc.b $a0                                ;Melee attack probability (positive)
                dc.b $e4                                ;Ducking probability (negative)
                dc.b $d0                                ;Ducking probability when shot at (negative)
                dc.b $f4                                ;Ducking exit prob. (negative)
                dc.b $30                                ;Duck-attack probability (positive)
                dc.b $e0                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_ahriman:   dc.w thinker_mammal                     ;AI
                dc.w move_human                         ;Moveroutine (NO REMOVE!)
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 35                                 ;Size up
                dc.b 26                                 ;Size up (ducking)
                dc.b AR_AHRIMAN                         ;Default batt.
                dc.b HP_AHRIMAN                         ;Default hp
                dc.b AFB_BOSS|AFB_ORGANIC|AFB_HUMANOID|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES|AFB_HEAVY   ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LEVITATE     ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 33                                 ;Speed pos
                dc.b -33                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -28                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                 ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 15000                              ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 5                                  ;Patrol radius
                dc.b 6                                  ;Alert radius
                dc.b 2                                  ;Patrol idle time
                dc.b 100                                ;Get bored-time (routecheck)
                dc.b $60                                ;Attack probability (positive)
                dc.b $80                                ;Melee attack probability (positive)
                dc.b $d0                                ;Ducking probability (negative)
                dc.b $d0                                ;Ducking probability when shot at (negative)
                dc.b $f8                                ;Ducking exit prob. (negative)
                dc.b $10                                ;Duck-attack probability (positive)
                dc.b $ff                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_suhrim:    dc.w thinker_mammal                     ;AI
                dc.w move_human                         ;Moveroutine (NO REMOVE!)
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_SUHRIM                          ;Default batt.
                dc.b HP_SUHRIM                          ;Default hp
                dc.b AFB_BOSS|AFB_ORGANIC|AFB_HUMANOID|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES|AFB_HEAVY  ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP|ACB_CLIMB ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 34                                 ;Speed pos
                dc.b -34                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -36                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                 ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 10000                              ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 6                                  ;Patrol radius
                dc.b 6                                  ;Alert radius
                dc.b 5                                  ;Patrol idle time
                dc.b 120                                ;Get bored-time (routecheck)
                dc.b $00                                ;Attack probability (positive)
                dc.b $00                                ;Melee attack probability (positive)
                dc.b $d0                                ;Ducking probability (negative)
                dc.b $d0                                ;Ducking probability when shot at (negative)
                dc.b $fa                                ;Ducking exit prob. (negative)
                dc.b $24                                ;Duck-attack probability (positive)
                dc.b $40                                ;Jump instead of duck (positive)
                dc.b $0c                                ;Patrol idle prob.

actl_lilith:    dc.w thinker_mammal                     ;AI
                dc.w move_human                         ;Moveroutine (NO REMOVE!)
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_LILITH                          ;Default batt.
                dc.b HP_LILITH                          ;Default hp
                dc.b AFB_BOSS|AFB_ORGANIC|AFB_HUMANOID|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES|AFB_HEAVY  ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP|ACB_CLIMB ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 36                                 ;Speed pos
                dc.b -36                                ;Speed neg
                dc.b 5                                  ;Accel pos
                dc.b -5                                 ;Accel neg
                dc.b -40                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                 ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 15000                              ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 7-1                                ;Patrol radius
                dc.b 7-1                                ;Alert radius
                dc.b 5                                  ;Patrol idle time
                dc.b 120                                ;Get bored-time (routecheck)
                dc.b $58                                ;Attack probability (positive)
                dc.b $80                                ;Melee attack probability (positive)
                dc.b $e0                                ;Ducking probability (negative)
                dc.b $d0                                ;Ducking probability when shot at (negative)
                dc.b $e8                                ;Ducking exit prob. (negative)
                dc.b $2c                                ;Duck-attack probability (positive)
                dc.b $c0                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.



actl_ceilturret:
                dc.w thinker_mammal
                dc.w move_turret
                dc.b 10                               ;Size left/right
                dc.b 14                               ;Size down
                dc.b 0                                ;Size up
                dc.b 0                                ;Size up (ducking)
                dc.b AR_TURRET                          ;Default batt.
                dc.b HP_TURRET                          ;Default hp
                dc.b AFB_REACTVISUAL        ;Fighting bits
                dc.b 0                                         ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 0                                  ;Speed pos
                dc.b 0                                  ;Speed neg
                dc.b 0                                  ;Accel pos
                dc.b 0                                  ;Accel neg
                dc.b 0                                  ;Jumpspeed
                dc.b 0                                  ;Climbspeed
                dc.b 0                                  ;Braking accel.
                dc.b 0                                  ;Attack X-mod
                dc.b -8                                 ;Normal attack Y-mod
                dc.b -8                                 ;Ducking attack Y-mod
                dc.b SFX_EXPLOSION                      ;Takedown SFX
                dc.b 7*8                                ;Takedown Y-mod
                dc.w 2000                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 4                                  ;Patrol radius
                dc.b 4                                  ;Alert radius
                dc.b 25                                 ;Patrol idle time
                dc.b 60                                 ;Get bored-time (routecheck)
                dc.b $f0                                ;Attack probability (positive)
                dc.b $f0                                ;Melee attack probability (positive)
                dc.b $00                                ;Ducking probability (negative)
                dc.b $00                                ;Ducking probability when shot at (negative)
                dc.b $fc                                ;Ducking exit prob. (negative)
                dc.b $c0                                ;Duck-attack probability (positive)
                dc.b $00                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_floorturret:
                dc.w thinker_mammal
                dc.w move_turret
                dc.b 10                               ;Size left/right
                dc.b 0                                ;Size down
                dc.b 14                               ;Size up
                dc.b 14                               ;Size up (ducking)
                dc.b AR_TURRET                          ;Default batt.
                dc.b HP_TURRET                          ;Default hp
                dc.b AFB_REACTVISUAL                    ;Fighting bits
                dc.b 0                                  ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 0                                  ;Speed pos
                dc.b 0                                  ;Speed neg
                dc.b 0                                  ;Accel pos
                dc.b 0                                  ;Accel neg
                dc.b 0                                  ;Jumpspeed
                dc.b 0                                  ;Climbspeed
                dc.b 0                                  ;Braking accel.
                dc.b 0                                  ;Attack X-mod
                dc.b 7                                  ;Normal attack Y-mod
                dc.b 7                                  ;Ducking attack Y-mod
                dc.b SFX_EXPLOSION                      ;Takedown SFX
                dc.b -7*8                               ;Takedown Y-mod
                dc.w 2000                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 4                                  ;Patrol radius
                dc.b 4                                  ;Alert radius
                dc.b 25                                 ;Patrol idle time
                dc.b 60                                 ;Get bored-time (routecheck)
                dc.b $f0                                ;Attack probability (positive)
                dc.b $f0                                ;Melee attack probability (positive)
                dc.b $ff                                ;Ducking probability (negative)
                dc.b $ff                                ;Ducking probability when shot at (negative)
                dc.b $c0                                ;Ducking exit prob. (negative)
                dc.b $c0                                ;Duck-attack probability (positive)
                dc.b $00                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_heavyturret:
                dc.w thinker_mammal
                dc.w move_turret
                dc.b 10                               ;Size left/right
                dc.b 0                                ;Size down
                dc.b 18                               ;Size up
                dc.b 18                               ;Size up (ducking)
                dc.b AR_HEAVYTURRET                          ;Default batt.
                dc.b HP_HEAVYTURRET                          ;Default hp
                dc.b AFB_REACTVISUAL|AFB_REACTNOISE     ;Fighting bits
                dc.b 0                                  ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 0                                  ;Speed pos
                dc.b 0                                  ;Speed neg
                dc.b 0                                  ;Accel pos
                dc.b 0                                  ;Accel neg
                dc.b 0                                  ;Jumpspeed
                dc.b 0                                  ;Climbspeed
                dc.b 0                                  ;Braking accel.
                dc.b 0                                  ;Attack X-mod
                dc.b 12                                 ;Normal attack Y-mod
                dc.b 12                                 ;Ducking attack Y-mod
                dc.b SFX_EXPLOSION                      ;Takedown SFX
                dc.b -9*8                               ;Takedown Y-mod
                dc.w 3500                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 4                                  ;Patrol radius
                dc.b 4                                  ;Alert radius
                dc.b 25                                 ;Patrol idle time
                dc.b 60                                 ;Get bored-time (routecheck)
                dc.b $f0                                ;Attack probability (positive)
                dc.b $f0                                ;Melee attack probability (positive)
                dc.b $ff                                ;Ducking probability (negative)
                dc.b $ff                                ;Ducking probability when shot at (negative)
                dc.b $c0                                ;Ducking exit prob. (negative)
                dc.b $a0                                ;Duck-attack probability (positive)
                dc.b $00                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_securitybot:
                dc.w thinker_mammal
                dc.w move_securitybot
                dc.b 20                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 42                                 ;Size up
                dc.b 42                                 ;Size up (ducking)
                dc.b AR_SECURITYBOT                     ;Default batt.
                dc.b HP_SECURITYBOT                     ;Default hp
                dc.b AFB_REACTVISUAL|AFB_HEAVY          ;Fighting bits
                dc.b 0                                  ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 16                                 ;Speed pos
                dc.b -16                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b 0                                  ;Jumpspeed
                dc.b 0                                  ;Climbspeed
                dc.b 6                                  ;Braking accel.
                dc.b 0                                  ;Attack X-mod
                dc.b 10                                 ;Normal attack Y-mod
                dc.b 10                                 ;Ducking attack Y-mod
                dc.b SFX_EXPLOSION                      ;Takedown SFX
                dc.b -15*8                              ;Takedown Y-mod
                dc.w 7500                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 5                                  ;Patrol radius
                dc.b 5                                  ;Alert radius
                dc.b 15                                 ;Patrol idle time
                dc.b 60                                 ;Get bored-time (routecheck)
                dc.b $a0                                ;Attack probability (positive)
                dc.b $a0                                ;Melee attack probability (positive)
                dc.b $ff                                ;Ducking probability (negative)
                dc.b $ff                                ;Ducking probability when shot at (negative)
                dc.b $f0                                ;Ducking exit prob. (negative)
                dc.b $a0                                ;Duck-attack probability (positive)
                dc.b $00                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.


actl_spiderbot: dc.w thinker_mammal                     ;AI
                dc.w move_spiderbot                     ;Moveroutine
                dc.b 18                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 18                                 ;Size up
                dc.b 18                                 ;Size up (ducking)
                dc.b AR_SPIDERBOT                       ;Default batt.
                dc.b HP_SPIDERBOT                       ;Default hp
                dc.b AFB_REACTVISUAL|AFB_REACTNOISE     ;Fighting bits
                dc.b ACB_JUMP|ACB_LONGJUMP              ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 24                                 ;Speed pos
                dc.b -24                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -34                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 8                                  ;Attack X-mod
                dc.b 7                                  ;Normal attack Y-mod
                dc.b 7                                  ;Ducking attack Y-mod
                dc.b SFX_EXPLOSION                      ;Takedown SFX
                dc.b -9*8                               ;Takedown Y-mod
                dc.w 2500                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 4                                  ;Patrol radius
                dc.b 4                                  ;Alert radius
                dc.b 15                                 ;Patrol idle time
                dc.b 60                                 ;Get bored-time (routecheck)
                dc.b $30                                ;Attack probability (positive)
                dc.b $80                                ;Melee attack probability (positive)
                dc.b $e0                                ;Ducking probability (negative)
                dc.b $e0                                ;Ducking probability when shot at (negative)
                dc.b $f0                                ;Ducking exit prob. (negative)
                dc.b $30                                ;Duck-attack probability (positive)
                dc.b $40                                ;Jump instead of duck (positive)
                dc.b $10                                ;Patrol idle prob.

actl_minicopter:
                dc.w thinker_mammal
                dc.w move_minicopter
                dc.b 20                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 29                                 ;Size up
                dc.b 29                                 ;Size up (ducking)
                dc.b AR_MINICOPTER                      ;Default batt.
                dc.b HP_MINICOPTER                      ;Default hp
                dc.b AFB_REACTVISUAL                    ;Fighting bits
                dc.b ACB_FLY                            ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 40                                 ;Speed pos
                dc.b -40                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b 4                                  ;Jumpspeed (altitude)
                dc.b 6                                  ;Climbspeed (freefall accel.)
                dc.b 2                                  ;Braking accel.
                dc.b 16                                  ;Attack X-mod
                dc.b 5                                  ;Normal attack Y-mod
                dc.b 5                                  ;Ducking attack Y-mod
                dc.b SFX_EXPLOSION                      ;Takedown SFX
                dc.b -15*8                              ;Takedown Y-mod
                dc.w 5000                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 7                                  ;Patrol radius
                dc.b 8                                  ;Alert radius
                dc.b 10                                 ;Patrol idle time
                dc.b 60                                 ;Get bored-time (routecheck)
                dc.b $a0                                ;Attack probability (positive)
                dc.b $a0                                ;Melee attack probability (positive)
                dc.b $ff                                ;Ducking probability (negative)
                dc.b $ff                                ;Ducking probability when shot at (negative)
                dc.b $f0                                ;Ducking exit prob. (negative)
                dc.b $a0                                ;Duck-attack probability (positive)
                dc.b $00                                ;Jump instead of duck (positive)
                dc.b $01                                ;Patrol idle prob.

actl_iac:       dc.w thinker_mammal
                dc.w move_iac
                dc.b 44                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 40                                 ;Size up
                dc.b 40                                 ;Size up (ducking)
                dc.b AR_IAC                             ;Default batt.
                dc.b HP_IAC                             ;Default hp
                dc.b AFB_REACTVISUAL|AFB_REACTNOISE|AFB_HEAVY        ;Fighting bits
                dc.b ACB_FLY                            ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 40                                 ;Speed pos
                dc.b -40                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b 9                                 ;Jumpspeed (altitude)
                dc.b 3                                  ;Climbspeed (freefall accel.)
                dc.b 2                                  ;Braking accel.
                dc.b 0                                  ;Attack X-mod
                dc.b 16                                 ;Normal attack Y-mod
                dc.b 16                                 ;Ducking attack Y-mod
                dc.b SFX_EXPLOSION                      ;Takedown SFX
                dc.b -15*8                              ;Takedown Y-mod
                dc.w 15000                              ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 9                                  ;Patrol radius
                dc.b 9                                  ;Alert radius
                dc.b 10                                 ;Patrol idle time
                dc.b 80                                 ;Get bored-time (routecheck)
                dc.b $78                                ;Attack probability (positive)
                dc.b $80                                ;Melee attack probability (positive)
                dc.b $ff                                ;Ducking probability (negative)
                dc.b $ff                                ;Ducking probability when shot at (negative)
                dc.b $f0                                ;Ducking exit prob. (negative)
                dc.b $78                                ;Duck-attack probability (positive)
                dc.b $00                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_exoskeleton:dc.w thinker_mammal                     ;AI
                dc.w move_exoskeleton                   ;Moveroutine (NO REMOVE!)
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 39                                 ;Size up
                dc.b 30                                 ;Size up (ducking)
                dc.b AR_EXOSKELETON                     ;Default batt.
                dc.b HP_EXOSKELETON                     ;Default hp
                dc.b AFB_BOSS|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES|AFB_HEAVY      ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP     ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 36                                ;Speed pos
                dc.b -36                                ;Speed neg
                dc.b 7                                  ;Accel pos
                dc.b -7                                 ;Accel neg
                dc.b -35                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 5                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 10000                              ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 10                                  ;Patrol radius
                dc.b 10                                 ;Alert radius
                dc.b 5                                  ;Patrol idle time
                dc.b 120                                ;Get bored-time (routecheck)
                dc.b $60                                ;Attack probability (positive)
                dc.b $60                                ;Melee attack probability (positive)
                dc.b $d8                                ;Ducking probability (negative)
                dc.b $d8                                ;Ducking probability when shot at (negative)
                dc.b $d0                                ;Ducking exit prob. (negative)
                dc.b $10                                ;Duck-attack probability (positive)
                dc.b $f0                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_seeker:    dc.w thinker_mammal
                dc.w move_seeker
                dc.b 8                                  ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 8                                  ;Size up
                dc.b 8                                  ;Size up (ducking)
                dc.b AR_SEEKER                          ;Default batt.
                dc.b HP_SEEKER                          ;Default hp
                dc.b AFB_REACTVISUAL|AFB_REACTNOISE     ;Fighting bits
                dc.b ACB_FLY                            ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 20                                 ;Speed pos
                dc.b -20                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b 3                                  ;Jumpspeed (altitude)
                dc.b 6                                  ;Climbspeed (freefall accel.)
                dc.b 3                                  ;Braking accel.
                dc.b 0                                  ;Attack X-mod
                dc.b 0                                  ;Normal attack Y-mod
                dc.b 0                                  ;Ducking attack Y-mod
                dc.b SFX_EXPLOSION                      ;Takedown SFX
                dc.b 0                                  ;Takedown Y-mod
                dc.w 1500                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 6                                  ;Patrol radius
                dc.b 6                                  ;Alert radius
                dc.b 2                                  ;Patrol idle time
                dc.b 60                                 ;Get bored-time (routecheck)
                dc.b $c0                                ;Attack probability (positive)
                dc.b $c0                                ;Melee attack probability (positive)
                dc.b $ff                                ;Ducking probability (negative)
                dc.b $ff                                ;Ducking probability when shot at (negative)
                dc.b $f0                                ;Ducking exit prob. (negative)
                dc.b $a0                                ;Duck-attack probability (positive)
                dc.b $00                                ;Jump instead of duck (positive)
                dc.b $01                                ;Patrol idle prob.

actl_mutant1:   dc.w thinker_mammal                     ;AI
                dc.w move_mutant                        ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 20                                 ;Size up
                dc.b 20                                 ;Size up (ducking)
                dc.b AR_MUTANT1                         ;Default batt.
                dc.b HP_MUTANT1                         ;Default hp
                dc.b AFB_ORGANIC|AFB_DISAPPEAR|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES      ;Fighting bits
                dc.b 0                                  ;Caps
                dc.b GRP_BEASTS                         ;Group alliance
                dc.b 30                                 ;Speed pos
                dc.b -30                                ;Speed neg
                dc.b 3                                  ;Accel pos
                dc.b -3                                 ;Accel neg
                dc.b -48                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 3                                  ;Braking accel.
                dc.b 2                                  ;Attack X-mod
                dc.b 9                                  ;Normal attack Y-mod
                dc.b 9                                  ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -2*8                               ;Takedown Y-mod
                dc.w 750                                ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 6                                  ;Patrol radius
                dc.b 7                                  ;Alert radius
                dc.b 5                                  ;Patrol idle time
                dc.b 80                                 ;Get bored-time (routecheck)
                dc.b $30                                ;Attack probability (positive)
                dc.b $90                                ;Melee attack probability (positive)
                dc.b $ff                                ;Ducking probability (negative)
                dc.b $ff                                ;Ducking probability when shot at (negative)
                dc.b $f8                                ;Ducking exit prob. (negative)
                dc.b $30                                ;Duck-attack probability (positive)
                dc.b $00                                ;Jump instead of duck (positive)
                dc.b $06                                ;Patrol idle prob.

actl_mutant2:   dc.w thinker_mammal                     ;AI
                dc.w move_mutant_noremove               ;Moveroutine (NO REMOVE!)
                dc.b 20                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 36                                 ;Size up
                dc.b 36                                 ;Size up (ducking)
                dc.b AR_MUTANT2                         ;Default batt.
                dc.b HP_MUTANT2                         ;Default hp
                dc.b AFB_BOSS|AFB_HEAVY|AFB_ORGANIC|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES ;Fighting bits
                dc.b ACB_JUMP|ACB_LONGJUMP              ;Caps
                dc.b GRP_BEASTS                         ;Group alliance
                dc.b 36                                 ;Speed pos
                dc.b -36                                ;Speed neg
                dc.b 5                                  ;Accel pos
                dc.b -5                                 ;Accel neg
                dc.b -50                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 5                                  ;Braking accel.
                dc.b 22                                 ;Attack X-mod
                dc.b 13                                 ;Normal attack Y-mod
                dc.b 13                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -2*8                               ;Takedown Y-mod
                dc.w 7500                               ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 4                                  ;Patrol radius
                dc.b 4                                  ;Alert radius
                dc.b 5                                  ;Patrol idle time
                dc.b 80                                 ;Get bored-time (routecheck)
                dc.b $38                                ;Attack probability (positive)
                dc.b $90                                ;Melee attack probability (positive)
                dc.b $d0                                ;Ducking probability (negative)
                dc.b $c8                                ;Ducking probability when shot at (negative)
                dc.b $f8                                ;Ducking exit prob. (negative)
                dc.b $40                                ;Duck-attack probability (positive)
                dc.b $c0                                ;Jump instead of duck (positive)
                dc.b $06                                ;Patrol idle prob.

actl_hovercar:  dc.w thinker_mammal
                dc.w move_hovercar
                dc.b 32                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 34                                 ;Size up (ducking)
                dc.b 0                                  ;Default batt.
                dc.b 1                                  ;Default hp
                dc.b AFB_REACTVISUAL|AFB_REACTNOISE     ;Fighting bits
                dc.b ACB_FLY                            ;Caps
                dc.b GRP_AGENTS                         ;Group alliance
                dc.b 36                                 ;Speed pos
                dc.b -36                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b 1                                  ;Jumpspeed (altitude)
                dc.b 3                                  ;Climbspeed (freefall accel.)
                dc.b 2                                  ;Braking accel.
                dc.b 28                                 ;Attack X-mod
                dc.b 12                                 ;Normal attack Y-mod
                dc.b 12                                 ;Ducking attack Y-mod
                dc.b SFX_EXPLOSION                      ;Takedown SFX
                dc.b -15*8                              ;Takedown Y-mod
                dc.w 0                                  ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 7                                  ;Patrol radius
                dc.b 8                                  ;Alert radius
                dc.b 10                                 ;Patrol idle time
                dc.b 60                                 ;Get bored-time (routecheck)
                dc.b $e0                                ;Attack probability (positive)
                dc.b $e0                                ;Melee attack probability (positive)
                dc.b $ff                                ;Ducking probability (negative)
                dc.b $ff                                ;Ducking probability when shot at (negative)
                dc.b $f0                                ;Ducking exit prob. (negative)
                dc.b $e0                                ;Duck-attack probability (positive)
                dc.b $00                                ;Jump instead of duck (positive)
                dc.b $02                                ;Patrol idle prob.

actl_blackhand:
actl_blowfish:
                dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_BLACKHAND                       ;Default batt.
                dc.b HP_BLACKHAND                       ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES     ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP     ;Caps
                dc.b GRP_AGENTS                         ;Group alliance
                dc.b 30                                 ;Speed pos
                dc.b -30                                ;Speed neg
                dc.b 3                                  ;Accel pos
                dc.b -3                                 ;Accel neg
                dc.b -34                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 0                                  ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 5                                  ;Patrol radius
                dc.b 6                                  ;Alert radius
                dc.b 20                                 ;Patrol idle time
                dc.b 80                                 ;Get bored-time (routecheck)
                dc.b $38                                ;Attack probability (positive)
                dc.b $a0                                ;Melee attack probability (positive)
                dc.b $fa                                ;Ducking probability (negative)
                dc.b $d0                                ;Ducking probability when shot at (negative)
                dc.b $fc                                ;Ducking exit prob. (negative)
                dc.b $34                                ;Duck-attack probability (positive)
                dc.b $40                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_band:      dc.w 0                                  ;AI
                dc.w move_band                          ;Moveroutine
                dc.b 32                                 ;Size left/right
                dc.b 16                                 ;Size down
                dc.b 16                                 ;Size up
                dc.b 16                                 ;Size up (ducking)
                dc.b 0                                  ;Default batt.
                dc.b 1                                  ;Default hp
                dc.b 0                                  ;Fighting bits
                dc.b 0                                  ;Caps
                dc.b GRP_BYSTANDER                      ;Group alliance

actl_goat:      dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_GOAT                            ;Default batt.
                dc.b HP_GOAT                            ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES      ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP|ACB_CLIMB     ;Caps
                dc.b GRP_AGENTS                         ;Group alliance
                dc.b 32                                 ;Speed pos
                dc.b -32                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -37                                ;Jumpspeed
                dc.b 96                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                 ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 0                                  ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 5                                  ;Patrol radius
                dc.b 6                                  ;Alert radius
                dc.b 20                                 ;Patrol idle time
                dc.b 120                                ;Get bored-time (routecheck)
                dc.b $40                                ;Attack probability (positive)
                dc.b $90                                ;Melee attack probability (positive)
                dc.b $f0                                ;Ducking probability (negative)
                dc.b $c0                                ;Ducking probability when shot at (negative)
                dc.b $f0                                ;Ducking exit prob. (negative)
                dc.b $40                                ;Duck-attack probability (positive)
                dc.b $18                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_joanagent: dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_JOANAGENT                       ;Default batt.
                dc.b HP_JOANAGENT                       ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_REACTVISUAL|AFB_REACTNOISE|AFB_REACTBODIES      ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP|ACB_CLIMB     ;Caps
                dc.b GRP_AGENTS                         ;Group alliance
                dc.b 32                                 ;Speed pos
                dc.b -32                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -37                                ;Jumpspeed
                dc.b 96                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                 ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 0                                  ;Takedown score
                dc.b RM_ONSIGHT                         ;Reaction to opposite groups
                dc.b 5                                  ;Patrol radius
                dc.b 6                                  ;Alert radius
                dc.b 20                                 ;Patrol idle time
                dc.b 120                                ;Get bored-time (routecheck)
                dc.b $40                                ;Attack probability (positive)
                dc.b $90                                ;Melee attack probability (positive)
                dc.b $f0                                ;Ducking probability (negative)
                dc.b $b0                                ;Ducking probability when shot at (negative)
                dc.b $fc                                ;Ducking exit prob. (negative)
                dc.b $40                                ;Duck-attack probability (positive)
                dc.b $28                                ;Jump instead of duck (positive)
                dc.b $08                                ;Patrol idle prob.

actl_ironfist:  dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 34                                 ;Size up
                dc.b 25                                 ;Size up (ducking)
                dc.b AR_IRONFIST                     ;Default batt.
                dc.b HP_IRONFIST                        ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_REACTVISUAL  ;Fighting bits
                dc.b ACB_JUMP|ACB_DUCK|ACB_LONGJUMP ;Caps
                dc.b GRP_SCEPTRE                        ;Group alliance
                dc.b 26                                 ;Speed pos
                dc.b -26                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -30                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                  ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 0                                  ;Takedown score
                dc.b RM_SELFDEFENSE                     ;Reaction to opposite groups
                dc.b 4                                  ;Patrol radius
                dc.b 4                                  ;Alert radius
                dc.b 5                                  ;Patrol idle time
                dc.b 40                                 ;Get bored-time (routecheck)
                dc.b $28                                ;Attack probability (positive)
                dc.b $68                                ;Melee attack probability (positive)
                dc.b $fe                                ;Ducking probability (negative)
                dc.b $e8                                ;Ducking probability when shot at (negative)
                dc.b $f0                                ;Ducking exit prob. (negative)
                dc.b $2c                                ;Duck-attack probability (positive)
                dc.b $02                                ;Jump instead of duck (positive)
                dc.b $02                                ;Patrol idle prob.

actl_head:      dc.w thinker_mammal                     ;AI
                dc.w move_head                          ;Moveroutine
                dc.b 8                                  ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 8                                  ;Size up
                dc.b 8                                  ;Size up (ducking)
                dc.b 0                                  ;Default batt.
                dc.b 1                                  ;Default hp
                dc.b 0                                  ;Fighting bits
                dc.b 0                                  ;Caps
                dc.b GRP_BYSTANDER                      ;Group alliance

actl_joanlevitate:
                dc.w 0                                  ;AI
                dc.w move_levitate                      ;Moveroutine
                dc.b 20                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 20                                 ;Size up
                dc.b 20                                 ;Size up (ducking)
                dc.b AR_JOANAGENT                       ;Default batt.
                dc.b HP_JOANAGENT                       ;Default hp
                dc.b 0                                  ;Fighting bits
                dc.b 0                                  ;Caps
                dc.b GRP_AGENTS                         ;Group alliance

actl_sentinel:  dc.w thinker_mammal                     ;AI
                dc.w move_human_rmcheck                 ;Moveroutine
                dc.b 10                                 ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 31                                 ;Size up
                dc.b 22                                 ;Size up (ducking)
                dc.b 0                                  ;Default batt.
                dc.b 1                                  ;Default hp
                dc.b AFB_ORGANIC|AFB_HUMANOID|AFB_DISAPPEAR ;Fighting bits
                dc.b 0                                  ;Caps
                dc.b GRP_BYSTANDER                      ;Group alliance
                dc.b 32                                 ;Speed pos
                dc.b -32                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b -30                                ;Jumpspeed
                dc.b 80                                 ;Climbspeed
                dc.b 4                                  ;Braking accel.
                dc.b 12                                 ;Attack X-mod
                dc.b 29                                 ;Normal attack Y-mod
                dc.b 20                                 ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b -8*8                               ;Takedown Y-mod
                dc.w 0                                  ;Takedown score
                dc.b RM_NOATTACK                        ;Reaction to opposite groups
                dc.b 2                                  ;Patrol radius
                dc.b 2                                  ;Alert radius
                dc.b 10                                 ;Patrol idle time
                dc.b 80                                 ;Get bored-time (routecheck)
                dc.b $20                                ;Attack probability (positive)
                dc.b $80                                ;Melee attack probability (positive)
                dc.b $f0                                ;Ducking probability (negative)
                dc.b $c8                                ;Ducking probability when shot at (negative)
                dc.b $fa                                ;Ducking exit prob. (negative)
                dc.b $38                                ;Duck-attack probability (positive)
                dc.b $10                                ;Jump instead of duck (positive)
                dc.b $06                                ;Patrol idle prob.


actl_bat:       dc.w thinker_mammal
                dc.w move_bat
                dc.b 6                                  ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 3                                  ;Size up
                dc.b 3                                  ;Size up (ducking)
                dc.b AR_BAT                             ;Default batt.
                dc.b HP_BAT                             ;Default hp
                dc.b AFB_REACTVISUAL|AFB_REACTNOISE|AFB_DISAPPEAR|AFB_ORGANIC     ;Fighting bits
                dc.b ACB_FLY                            ;Caps
                dc.b GRP_BEASTS                         ;Group alliance
                dc.b 26                                 ;Speed pos
                dc.b -26                                ;Speed neg
                dc.b 4                                  ;Accel pos
                dc.b -4                                 ;Accel neg
                dc.b 7                                  ;Jumpspeed (altitude)
                dc.b 6                                  ;Climbspeed (freefall accel.)
                dc.b 3                                  ;Braking accel.
                dc.b 0                                  ;Attack X-mod
                dc.b 0                                  ;Normal attack Y-mod
                dc.b 0                                  ;Ducking attack Y-mod
                dc.b SFX_TAKEDOWN                       ;Takedown SFX
                dc.b 0                                  ;Takedown Y-mod
                dc.w 0                                  ;Takedown score
                dc.b RM_SELFDEFENSE                     ;Reaction to opposite groups
                dc.b 6                                  ;Patrol radius
                dc.b 6                                  ;Alert radius
                dc.b 2                                  ;Patrol idle time
                dc.b 60                                 ;Get bored-time (routecheck)
                dc.b $c0                                ;Attack probability (positive)
                dc.b $c0                                ;Melee attack probability (positive)
                dc.b $ff                                ;Ducking probability (negative)
                dc.b $ff                                ;Ducking probability when shot at (negative)
                dc.b $f0                                ;Ducking exit prob. (negative)
                dc.b $a0                                ;Duck-attack probability (positive)
                dc.b $00                                ;Jump instead of duck (positive)
                dc.b $01                                ;Patrol idle prob.

actl_observer:  dc.w 0                                  ;AI
                dc.w move_stationary_noremove           ;Moveroutine
                dc.b 8                                  ;Size left/right
                dc.b 0                                  ;Size down
                dc.b 16                                 ;Size up
                dc.b 16                                 ;Size up (ducking)
                dc.b AR_NONAGENT                        ;Default batt.
                dc.b HP_NONAGENT                        ;Default hp
                dc.b 0                                  ;Fighting bits
                dc.b 0                                  ;Caps
                dc.b GRP_BYSTANDER                      ;Group alliance


