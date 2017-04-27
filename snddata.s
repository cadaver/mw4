vsongtbllo:
vsongtblhi:
vpatttbllo:
vpatttblhi:
vwavetbl:
vnotetbl:
vnexttbl:
vpulsetimetbl:
vpulseaddtbl:
vpulsenexttbl:
vfilttimetbl:
vfiltaddtbl:
vfiltnexttbl:

vfreqtbl:       dc.w $022a,$024a,$026d,$0292,$02b9,$02e3,$030f,$033e,$036f,$03a3,$03db,$0415
                dc.w $0454,$0495,$04db,$0525,$0573,$05c7,$061e,$067c,$06de,$0747,$07b6,$082b
                dc.w $08a8,$092b,$09b7,$0a4b,$0ae7,$0b8e,$0c3d,$0cf8,$0dbd,$0e8e,$0f6c,$1057
                dc.w $1150,$1257,$136e,$1496,$15cf,$171c,$187b,$19f0,$1b7b,$1d1d,$1ed8,$20ae
                dc.w $22a0,$24af,$26dd,$292d,$2b9f,$2e38,$30f7,$33e0,$36f6,$3a3b,$3db1,$415d
                dc.w $4540,$495e,$4dbb,$525a,$573f,$5c70,$61ef,$67c1,$6ded,$7476,$7b63,$82ba
                dc.w $8a80,$92bc,$9b76,$a4b4,$ae7f,$b8e0,$c3de,$cf83,$dbda,$e8ed,$f6c7,$ffff

reladrtbllo:    dc.b <vsongtblloaccess
                dc.b <vsongtblhiaccess
                dc.b <vpatttblloaccess
                dc.b <vpatttblhiaccess
                dc.b <vwavetblminusaccess1
                dc.b <vwavetblaccess1
                dc.b <vnotetblminusaccess1
                dc.b <vnotetblminusaccess2
                dc.b <vnotetblminusaccess3
                dc.b <vnotetblminusaccess4
                dc.b <vnexttblminusaccess1
                dc.b <vnexttblminusaccess2
                dc.b <vnexttblminusaccess3
                dc.b <vnexttblminusaccess4
                dc.b <vpulsetimeminusaccess1
                dc.b <vpulseaddminusaccess1
                dc.b <vpulsenextminusaccess1
                dc.b <vfilttimeminusaccess1
                dc.b <vfilttimeminusaccess2
                dc.b <vfiltaddminusaccess1
                dc.b <vfiltaddminusaccess2
                dc.b <vfiltnextminusaccess1

reladrtblhi:    dc.b >vsongtblloaccess
                dc.b >vsongtblhiaccess
                dc.b >vpatttblloaccess
                dc.b >vpatttblhiaccess
                dc.b >vwavetblminusaccess1
                dc.b >vwavetblaccess1
                dc.b >vnotetblminusaccess1
                dc.b >vnotetblminusaccess2
                dc.b >vnotetblminusaccess3
                dc.b >vnotetblminusaccess4
                dc.b >vnexttblminusaccess1
                dc.b >vnexttblminusaccess2
                dc.b >vnexttblminusaccess3
                dc.b >vnexttblminusaccess4
                dc.b >vpulsetimeminusaccess1
                dc.b >vpulseaddminusaccess1
                dc.b >vpulsenextminusaccess1
                dc.b >vfilttimeminusaccess1
                dc.b >vfilttimeminusaccess2
                dc.b >vfiltaddminusaccess1
                dc.b >vfiltaddminusaccess2
                dc.b >vfiltnextminusaccess1

reladdtbl:      dc.b REL_UNCHANGED
                dc.b REL_SONGTBL
                dc.b REL_SONGTBL
                dc.b REL_PATTTBL
                dc.b REL_PATTTBL_MINUS
                dc.b REL_UNCHANGED
                dc.b REL_WAVETBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_WAVETBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_WAVETBL_MINUS
                dc.b REL_PULSETBL_MINUS
                dc.b REL_PULSETBL_MINUS
                dc.b REL_PULSETBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_FILTTBL_MINUS
                dc.b REL_UNCHANGED_MINUS
                dc.b REL_FILTTBL_MINUS
                dc.b REL_END

sfxtbl:         dc.w snd_footstep
                dc.w snd_jump
                dc.w snd_pickup
                dc.w snd_damage
                dc.w snd_explosion
                dc.w snd_parasite
                dc.w snd_select
                dc.w snd_cockweapon
                dc.w snd_cockfast
                dc.w snd_insertammo
                dc.w snd_insertclip
                dc.w snd_hypo
                dc.w snd_powerup
                dc.w snd_grenade
                dc.w snd_punch
                dc.w snd_throw
                dc.w snd_melee
                dc.w snd_glass
                dc.w snd_takedown
                dc.w snd_9mm
                dc.w snd_9mmsuppr
                dc.w snd_44magnum
                dc.w snd_shotgun
                dc.w snd_556rifle
                dc.w snd_762sniper
                dc.w snd_laser
                dc.w snd_flame
                dc.w snd_flameignite
                dc.w snd_taser
                dc.w snd_gasfist
                dc.w snd_missile
                dc.w snd_dart
                dc.w snd_object
                dc.w snd_train
                dc.w snd_bat
                dc.w snd_transmission
                dc.w snd_shutdown


snd_footstep:   include sfx/footstep.sfx
snd_bat:        include sfx/bat.sfx
snd_jump:       include sfx/jump.sfx
snd_dart:       include sfx/dart.sfx
snd_select:     include sfx/select.sfx
snd_object:     include sfx/object.sfx
snd_cockweapon: include sfx/cock.sfx
snd_cockfast:   include sfx/cockfast.sfx
snd_insertammo: include sfx/ammo.sfx
snd_insertclip: include sfx/clip.sfx
snd_pickup:     include sfx/pickup.sfx
snd_hypo:       include sfx/hypo.sfx
snd_powerup:    include sfx/powerup.sfx
snd_shutdown:   include sfx/shutdown.sfx
snd_transmission:include sfx/transmis.sfx
snd_grenade:    include sfx/grenade.sfx
snd_punch:      include sfx/punch.sfx
snd_throw:      include sfx/throw.sfx
snd_parasite:   include sfx/parasite.sfx
snd_melee:      include sfx/melee.sfx
snd_damage:     include sfx/damage.sfx
snd_glass:      include sfx/glass.sfx
snd_flameignite:include sfx/ignite.sfx
snd_flame:      include sfx/flame.sfx
snd_9mmsuppr:   include sfx/9mmsuppr.sfx
snd_taser:      include sfx/taser.sfx
snd_9mm:        include sfx/pistol.sfx
snd_44magnum:   include sfx/44magnum.sfx
snd_shotgun:    include sfx/shotgun.sfx
snd_556rifle:   include sfx/556rifle.sfx
snd_laser:      include sfx/laser.sfx
snd_gasfist:    include sfx/gasfist.sfx
snd_missile:    include sfx/missile.sfx
snd_train:      include sfx/train.sfx
snd_takedown:   include sfx/takedown.sfx
snd_762sniper:  include sfx/sniper.sfx
snd_explosion:  include sfx/explosio.sfx



