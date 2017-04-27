;
; Weapon Bullet Item & Special Damage definitions
;

; Weapons

wpndefs:        dc.b ITEM_FISTS
                dc.b 0                  ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_FISTHIT        ; First bullet number
                dc.b 0                  ; Reload time (insert new clip)
                dc.b 0                  ; Reload time (after readying)
                dc.b 0                  ; Reload amount
                dc.b 0                  ; Reload sound (insert clip/bullet)
                dc.b 0                  ; Reload sound (ready weapon)
                dc.b WF_NONE            ; Idle frame
                dc.b WF_NONE            ; Attack prepare frame
                dc.b WF_NONE            ; Attack frame (straight)
                dc.b WF_NONE            ; Attack frame (up)
                dc.b WF_NONE            ; Attack frame (down)
                dc.b 0                  ; Directional?
                dc.b 2                  ; Is a melee weapon?
                dc.b SFX_PUNCH          ; Sound effect number
                dc.b 1                  ; NPC maximum distance
                dc.b 0                  ; NPC minimum distance
                dc.b 6*1                ; NPC attack time (time firebutton is held down)
                dc.b 6                  ; Attack delay
                dc.b DMG_FISTS          ; Damage

                dc.b ITEM_BATON
                dc.b 0                  ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_BATONHIT       ; First bullet number
                dc.b 0                  ; Reload time (insert new clip)
                dc.b 0                  ; Reload time (after readying)
                dc.b 0                  ; Reload amount
                dc.b 0                  ; Reload sound (insert clip/bullet)
                dc.b 0                  ; Reload sound (ready weapon)
                dc.b WF_BATON+1         ; Idle frame
                dc.b WF_BATON           ; Attack prepare frame
                dc.b WF_BATON+2         ; Attack frame (straight)
                dc.b WF_BATON+1         ; Attack frame (up)
                dc.b WF_BATON+3         ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 2                  ; Is a melee weapon?
                dc.b SFX_MELEE          ; Sound effect number
                dc.b 1                  ; NPC maximum distance
                dc.b 0                  ; NPC minimum distance
                dc.b 8*1                ; NPC attack time (time firebutton is held down)
                dc.b 8                  ; Attack delay
                dc.b DMG_BATON          ; Damage

                dc.b ITEM_KNIFE
                dc.b 0                  ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_KNIFEHIT       ; First bullet number
                dc.b 0                  ; Reload time (insert new clip)
                dc.b 0                  ; Reload time (after readying)
                dc.b 0                  ; Reload amount
                dc.b 0                  ; Reload sound (insert clip/bullet)
                dc.b 0                  ; Reload sound (ready weapon)
                dc.b WF_KNIFE           ; Idle frame
                dc.b WF_KNIFE+1         ; Attack prepare frame
                dc.b WF_KNIFE+1         ; Attack frame (straight)
                dc.b WF_NONE            ; Attack frame (up)
                dc.b WF_NONE            ; Attack frame (down)
                dc.b 0                  ; Directional?
                dc.b 2                  ; Is a melee weapon?
                dc.b SFX_MELEE          ; Sound effect number
                dc.b 1                  ; NPC maximum distance
                dc.b 0                  ; NPC minimum distance
                dc.b 7*1                ; NPC attack time (time firebutton is held down)
                dc.b 7                  ; Attack delay
                dc.b DMG_KNIFE          ; Damage



                dc.b ITEM_KATANA
                dc.b 0                  ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_KATANAHIT      ; First bullet number
                dc.b 0                  ; Reload time (insert new clip)
                dc.b 0                  ; Reload time (after readying)
                dc.b 0                  ; Reload amount
                dc.b 0                  ; Reload sound (insert clip/bullet)
                dc.b 0                  ; Reload sound (ready weapon)
                dc.b WF_KATANA          ; Idle frame
                dc.b WF_KATANA+1        ; Attack prepare frame
                dc.b WF_KATANA+3        ; Attack frame (straight)
                dc.b WF_KATANA+2        ; Attack frame (up)
                dc.b WF_KATANA+4        ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 2                  ; Is a melee weapon?
                dc.b SFX_MELEE          ; Sound effect number
                dc.b 1                  ; NPC maximum distance
                dc.b 0                  ; NPC minimum distance
                dc.b 10*1                ; NPC attack time (time firebutton is held down)
                dc.b 10                 ; Attack delay
                dc.b DMG_KATANA         ; Damage



                dc.b ITEM_SHURIKEN
                dc.b 0                  ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_SHURIKEN       ; First bullet number
                dc.b 0                  ; Reload time (insert new clip)
                dc.b 0                  ; Reload time (after readying)
                dc.b 0                  ; Reload amount
                dc.b 0                  ; Reload sound (insert clip/bullet)
                dc.b 0                  ; Reload sound (ready weapon)
                dc.b WF_NONE            ; Idle frame
                dc.b WF_NONE            ; Attack prepare frame
                dc.b WF_NONE            ; Attack frame (straight)
                dc.b WF_NONE            ; Attack frame (up)
                dc.b WF_NONE            ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 1                  ; Is a melee weapon?
                dc.b SFX_THROW          ; Sound effect number
                dc.b 4                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 6*1                ; NPC attack time (time firebutton is held down)
                dc.b 8                  ; Attack delay
                dc.b DMG_SHURIKEN       ; Damage



                dc.b ITEM_FRAG_GRENADE
                dc.b NOISE_SILENT       ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_GRENADE        ; First bullet number
                dc.b 0                  ; Reload time (insert new clip)
                dc.b 0                  ; Reload time (after readying)
                dc.b 0                  ; Reload amount
                dc.b 0                  ; Reload sound (insert clip/bullet)
                dc.b 0                  ; Reload sound (ready weapon)
                dc.b WF_NONE            ; Idle frame
                dc.b WF_NONE            ; Attack prepare frame
                dc.b WF_NONE            ; Attack frame (straight)
                dc.b WF_NONE            ; Attack frame (up)
                dc.b WF_NONE            ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 1                  ; Is a melee weapon?
                dc.b SFX_GRENADE        ; Sound effect number
                dc.b 6                  ; NPC maximum distance
                dc.b 2                  ; NPC minimum distance
                dc.b 6*1                ; NPC attack time (time firebutton is held down)
                dc.b 14                 ; Attack delay
                dc.b DMG_GRENADE        ; Damage



                dc.b ITEM_PARASITE
                dc.b NOISE_SILENT       ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_PARASITE       ; First bullet number
                dc.b 0                  ; Reload time (insert new clip)
                dc.b 0                  ; Reload time (after readying)
                dc.b 0                  ; Reload amount
                dc.b 0                  ; Reload sound (insert clip/bullet)
                dc.b 0                  ; Reload sound (ready weapon)
                dc.b WF_NONE            ; Idle frame
                dc.b WF_NONE            ; Attack prepare frame
                dc.b WF_NONE            ; Attack frame (straight)
                dc.b WF_NONE            ; Attack frame (up)
                dc.b WF_NONE            ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 1                  ; Is a melee weapon?
                dc.b SFX_MELEE          ; Sound effect number
                dc.b 5                  ; NPC maximum distance
                dc.b 2                  ; NPC minimum distance
                dc.b 6*1                ; NPC attack time (time firebutton is held down)
                dc.b 16                 ; Attack delay
                dc.b DMG_PARASITE       ; Damage




                dc.b ITEM_DARTGUN
                dc.b NOISE_SILENT       ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_DART           ; First bullet number
                dc.b 24                 ; Reload time (insert new clip)
                dc.b 6                  ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_COCKFAST       ; Reload sound (ready weapon)
                dc.b WF_DARTGUN         ; Idle frame
                dc.b WF_DARTGUN+2       ; Attack prepare frame
                dc.b WF_DARTGUN         ; Attack frame (straight)
                dc.b WF_DARTGUN+1       ; Attack frame (up)
                dc.b WF_DARTGUN+2       ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_DART           ; Sound effect number
                dc.b 4                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 10*1               ; NPC attack time (time firebutton is held down)
                dc.b 14                 ; Attack delay
                dc.b DMG_DART           ; Damage
                     


                dc.b ITEM_9MM_PISTOL
                dc.b NOISE_LOUD         ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_PISTOL         ; First bullet number
                dc.b 18                 ; Reload time (insert new clip)
                dc.b 8                  ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_COCKFAST       ; Reload sound (ready weapon)
                dc.b WF_PISTOL          ; Idle frame
                dc.b WF_PISTOL+2        ; Attack prepare frame
                dc.b WF_PISTOL          ; Attack frame (straight)
                dc.b WF_PISTOL+1        ; Attack frame (up)
                dc.b WF_PISTOL+2        ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_9MM            ; Sound effect number
                dc.b 5                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 6*1                ; NPC attack time (time firebutton is held down)
                dc.b 8                  ; Attack delay
                dc.b DMG_9MM            ; Damage



                dc.b ITEM_9MM_SILENCED_PISTOL
                dc.b NOISE_MODERATE     ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_STEALTHPISTOL  ; First bullet number
                dc.b 18                 ; Reload time (insert new clip)
                dc.b 8                  ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_COCKFAST       ; Reload sound (ready weapon)
                dc.b WF_PISTOL          ; Idle frame
                dc.b WF_PISTOL+2        ; Attack prepare frame
                dc.b WF_PISTOL          ; Attack frame (straight)
                dc.b WF_PISTOL+1        ; Attack frame (up)
                dc.b WF_PISTOL+2        ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_9MMSUPPR       ; Sound effect number
                dc.b 5                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 6*1                ; NPC attack time (time firebutton is held down)
                dc.b 7                  ; Attack delay
                dc.b DMG_9MMSUPPR       ; Damage



                dc.b ITEM_44_MAGNUM_PISTOL
                dc.b NOISE_LOUD         ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_PISTOL         ; First bullet number
                dc.b 18                 ; Reload time (insert new clip)
                dc.b 10                 ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_COCKFAST       ; Reload sound (ready weapon)
                dc.b WF_PISTOL          ; Idle frame
                dc.b WF_PISTOL+2        ; Attack prepare frame
                dc.b WF_PISTOL          ; Attack frame (straight)
                dc.b WF_PISTOL+1        ; Attack frame (up)
                dc.b WF_PISTOL+2        ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_44MAGNUM       ; Sound effect number
                dc.b 5                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 7*1                ; NPC attack time (time firebutton is held down)
                dc.b 9                  ; Attack delay
                dc.b DMG_44MAGNUM       ; Damage



                dc.b ITEM_9MM_SUBMACHINEGUN
                dc.b NOISE_LOUD         ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_SMG            ; First bullet number
                dc.b 18                 ; Reload time (insert new clip)
                dc.b 8                  ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_COCKFAST       ; Reload sound (ready weapon)
                dc.b WF_SMG             ; Idle frame
                dc.b WF_SMG+2           ; Attack prepare frame
                dc.b WF_SMG             ; Attack frame (straight)
                dc.b WF_SMG+1           ; Attack frame (up)
                dc.b WF_SMG+2           ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_9MM            ; Sound effect number
                dc.b 4                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 10*1               ; NPC attack time (time firebutton is held down)
                dc.b 3                  ; Attack delay
                dc.b DMG_9MMAUTO        ; Damage



                dc.b ITEM_SHOTGUN
                dc.b NOISE_LOUD         ; Noise
                dc.b 2                  ; Ammo consumption
                dc.b BLT_SHOTGUN1       ; First bullet number
                dc.b 6                  ; Reload time (insert new clip)
                dc.b 8                  ; Reload time (after readying)
                dc.b 1                  ; Reload amount
                dc.b SFX_INSERTAMMO     ; Reload sound (insert clip/bullet)
                dc.b SFX_COCKWEAPON     ; Reload sound (ready weapon)
                dc.b WF_SHOTGUN         ; Idle frame
                dc.b WF_SHOTGUN+2       ; Attack prepare frame
                dc.b WF_SHOTGUN         ; Attack frame (straight)
                dc.b WF_SHOTGUN+1       ; Attack frame (up)
                dc.b WF_SHOTGUN+2       ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_SHOTGUN        ; Sound effect number
                dc.b 4                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 9*1                ; NPC attack time (time firebutton is held down)
                dc.b 10                 ; Attack delay
                dc.b DMG_SHOTGUN        ; Damage



                dc.b ITEM_AUTO_SHOTGUN
                dc.b NOISE_LOUD         ; Noise
                dc.b 2                  ; Ammo consumption
                dc.b BLT_ASHOTGUN1      ; First bullet number
                dc.b 24                 ; Reload time (insert new clip)
                dc.b 10                 ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_COCKFAST       ; Reload sound (ready weapon)
                dc.b WF_ASHOTGUN        ; Idle frame
                dc.b WF_ASHOTGUN+2      ; Attack prepare frame
                dc.b WF_ASHOTGUN        ; Attack frame (straight)
                dc.b WF_ASHOTGUN+1      ; Attack frame (up)
                dc.b WF_ASHOTGUN+2      ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_SHOTGUN        ; Sound effect number
                dc.b 4                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 10                 ; NPC attack time (time firebutton is held down)
                dc.b 6                  ; Attack delay
                dc.b DMG_AUTOSHOTGUN    ; Damage



                dc.b ITEM_556_ASSAULT_RIFLE
                dc.b NOISE_LOUD         ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_AR             ; First bullet number
                dc.b 20                 ; Reload time (insert new clip)
                dc.b 10                 ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_COCKFAST       ; Reload sound (ready weapon)
                dc.b WF_AR              ; Idle frame
                dc.b WF_AR+2            ; Attack prepare frame
                dc.b WF_AR              ; Attack frame (straight)
                dc.b WF_AR+1            ; Attack frame (up)
                dc.b WF_AR+2            ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_556RIFLE       ; Sound effect number
                dc.b 5                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 5                  ; NPC attack time (time firebutton is held down)
                dc.b 4                  ; Attack delay
                dc.b DMG_556RIFLE       ; Damage



                dc.b ITEM_762_SNIPER_RIFLE
                dc.b NOISE_LOUD         ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_SNIPER         ; First bullet number
                dc.b 24                 ; Reload time (insert new clip)
                dc.b 12                 ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_COCKWEAPON     ; Reload sound (ready weapon)
                dc.b WF_SNIPER          ; Idle frame
                dc.b WF_SNIPER+2        ; Attack prepare frame
                dc.b WF_SNIPER          ; Attack frame (straight)
                dc.b WF_SNIPER+1        ; Attack frame (up)
                dc.b WF_SNIPER+2        ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_762SNIPER      ; Sound effect number
                dc.b 7                  ; NPC maximum distance
                dc.b 2                  ; NPC minimum distance
                dc.b 10*1               ; NPC attack time (time firebutton is held down)
                dc.b 12                 ; Attack delay
                dc.b DMG_762SNIPER      ; Damage



                dc.b ITEM_556_MACHINE_GUN
                dc.b NOISE_LOUD         ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_MG             ; First bullet number
                dc.b 40                 ; Reload time (insert new clip)
                dc.b 12                 ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_COCKFAST       ; Reload sound (ready weapon)
                dc.b WF_MG              ; Idle frame
                dc.b WF_MG+2            ; Attack prepare frame
                dc.b WF_MG              ; Attack frame (straight)
                dc.b WF_MG+1            ; Attack frame (up)
                dc.b WF_MG+2            ; Attack frame (down)
                dc.b WD_FROMHIP+1       ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_556RIFLE       ; Sound effect number
                dc.b 5                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 8*1                ; NPC attack time (time firebutton is held down)
                dc.b 3                  ; Attack delay
                dc.b DMG_556MACHINEGUN  ; Damage



                dc.b ITEM_FLAME_THROWER
                dc.b NOISE_MEDIUM       ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_FLAME          ; First bullet number
                dc.b 36                 ; Reload time (insert new clip)
                dc.b 12                 ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_FLAMEIGNITE    ; Reload sound (ready weapon)
                dc.b WF_FLAMETHR        ; Idle frame
                dc.b WF_FLAMETHR+2      ; Attack prepare frame
                dc.b WF_FLAMETHR        ; Attack frame (straight)
                dc.b WF_FLAMETHR+1      ; Attack frame (up)
                dc.b WF_FLAMETHR+2      ; Attack frame (down)
                dc.b WD_FROMHIP+WD_LOCKANIM+1  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_FLAME          ; Sound effect number
                dc.b 4                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 11*1               ; NPC attack time (time firebutton is held down)
                dc.b 3                  ; Attack delay
                dc.b DMG_FLAME          ; Damage



                dc.b ITEM_LASER_RIFLE
                dc.b NOISE_LOUD         ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_LASER          ; First bullet number
                dc.b 14                 ; Reload time (insert new clip)
                dc.b 12                 ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_POWERUP        ; Reload sound (ready weapon)
                dc.b WF_MG              ; Idle frame
                dc.b WF_MG+2            ; Attack prepare frame
                dc.b WF_MG              ; Attack frame (straight)
                dc.b WF_MG+1            ; Attack frame (up)
                dc.b WF_MG+2            ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_LASER          ; Sound effect number
                dc.b 6                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 10*1               ; NPC attack time (time firebutton is held down)
                dc.b 5                  ; Attack delay
                dc.b DMG_LASER          ; Damage



                dc.b ITEM_ELECTRONIC_STUN_GUN
                dc.b NOISE_SILENT       ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_ELECTRICITY    ; First bullet number
                dc.b 14                 ; Reload time (insert new clip)
                dc.b 12                 ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_POWERUP        ; Reload sound (ready weapon)
                dc.b WF_DARTGUN         ; Idle frame
                dc.b WF_DARTGUN+2       ; Attack prepare frame
                dc.b WF_DARTGUN         ; Attack frame (straight)
                dc.b WF_DARTGUN+1       ; Attack frame (up)
                dc.b WF_DARTGUN+2       ; Attack frame (down)
                dc.b 0                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_TASER          ; Sound effect number
                dc.b 2                  ; NPC maximum distance
                dc.b 0                  ; NPC minimum distance
                dc.b 8*1                ; NPC attack time (time firebutton is held down)
                dc.b 5                  ; Attack delay
                dc.b DMG_TASER          ; Damage



                dc.b ITEM_GASFIST_MK2
                dc.b NOISE_LOUD         ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_PLASMA         ; First bullet number
                dc.b 24                 ; Reload time (insert new clip)
                dc.b 12                 ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_POWERUP        ; Reload sound (ready weapon)
                dc.b WF_GASFIST         ; Idle frame
                dc.b WF_GASFIST+2       ; Attack prepare frame
                dc.b WF_GASFIST         ; Attack frame (straight)
                dc.b WF_GASFIST+1       ; Attack frame (up)
                dc.b WF_GASFIST+2       ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_GASFIST        ; Sound effect number
                dc.b 6                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 6*1                ; NPC attack time (time firebutton is held down)
                dc.b 7                  ; Attack delay
                dc.b DMG_GASFIST        ; Damage



                dc.b ITEM_MISSILE_LAUNCHER
                dc.b NOISE_LOUD         ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_MISSILE        ; First bullet number
                dc.b 8                  ; Reload time (insert new clip)
                dc.b 12                 ; Reload time (after readying)
                dc.b 1                  ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_COCKFAST       ; Reload sound (ready weapon)
                dc.b WF_MISSILE         ; Idle frame
                dc.b WF_MISSILE+2       ; Attack prepare frame
                dc.b WF_MISSILE         ; Attack frame (straight)
                dc.b WF_MISSILE+1       ; Attack frame (up)
                dc.b WF_MISSILE+2       ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_MISSILE        ; Sound effect number
                dc.b 7                  ; NPC maximum distance
                dc.b 2                  ; NPC minimum distance
                dc.b 12                 ; NPC attack time (time firebutton is held down)
                dc.b 16                 ; Attack delay
                dc.b DMG_MISSILE        ; Damage



                dc.b ITEM_PSIONIC_RIFLE
                dc.b NOISE_LOUD         ; Noise
                dc.b 1                  ; Ammo consumption
                dc.b BLT_PSIONIC        ; First bullet number
                dc.b 24                 ; Reload time (insert new clip)
                dc.b 12                 ; Reload time (after readying)
                dc.b 255                ; Reload amount
                dc.b SFX_INSERTCLIP     ; Reload sound (insert clip/bullet)
                dc.b SFX_POWERUP        ; Reload sound (ready weapon)
                dc.b WF_PSIONIC          ; Idle frame
                dc.b WF_PSIONIC+2        ; Attack prepare frame
                dc.b WF_PSIONIC          ; Attack frame (straight)
                dc.b WF_PSIONIC+1        ; Attack frame (up)
                dc.b WF_PSIONIC+2        ; Attack frame (down)
                dc.b 1                  ; Directional?
                dc.b 0                  ; Is a melee weapon?
                dc.b SFX_LASER          ; Sound effect number
                dc.b 6                  ; NPC maximum distance
                dc.b 1                  ; NPC minimum distance
                dc.b 10*1               ; NPC attack time (time firebutton is held down)
                dc.b 6                  ; Attack delay
                dc.b DMG_PSIONIC        ; Damage


                dc.b $ff ;End weapon defs.



                ; Bullets
                ; Note - negative timecounter ($ff) indicates special
                ; handling for the shotgun: bullet damage is reduced
                ; by one at each 2nd frame. $8d indicates the shotgun
                ; shot flies for 13 frames


                dc.b  BLT_FISTHIT
                dc.b  <2*8                 ; X modification lowbyte
                dc.b  >2*8                 ; X modification highbyte
                dc.b  <1*8                 ; Y modification lowbyte
                ;dc.b  >1*8                 ; Y modification highbyte
                dc.b  4*8                  ; X speed
                dc.b  0                    ; Y speed
                dc.b  0                    ; Y aiming speed modification
                dc.b  0                    ; Y aiming pos. modification
                dc.b  0                    ; Y aiming affects bullet frame?
                dc.b  ACT_MELEEHIT         ; Bullet actor number
                dc.b  1                    ; Bullet duration
                dc.b  0                    ; Remain on hit
                dc.b  0                    ; Next bullet (multi-bullet weapons)



                dc.b  BLT_KNIFEHIT
                dc.b  <10*8                ; X modification lowbyte
                dc.b  >10*8                ; X modification highbyte
                dc.b  <1*8                  ; Y modification lowbyte
                ;dc.b  >1*8                 ; Y modification highbyte
                dc.b  8*8                 ; X speed
                dc.b  0                   ; Y speed
                dc.b  0                   ; Y aiming speed modification
                dc.b  12*8                ; Y aiming pos. modification
                dc.b  0                   ; Y aiming affects bullet frame?
                dc.b  ACT_MELEEHIT        ; Bullet actor number
                dc.b  1                   ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_KATANAHIT
                dc.b  <16*8               ; X modification lowbyte
                dc.b  >16*8               ; X modification highbyte
                dc.b  <0                  ; Y modification lowbyte
                ;dc.b  >0                  ; Y modification highbyte
                dc.b  10*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  0                   ; Y aiming speed modification
                dc.b  11*8                ; Y aiming pos. modification
                dc.b  0                   ; Y aiming affects bullet frame?
                dc.b  ACT_WIDEMELEEHIT    ; Bullet actor number
                dc.b  1                   ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_BATONHIT
                dc.b  <10*8               ; X modification lowbyte
                dc.b  >10*8               ; X modification highbyte
                dc.b  <0                  ; Y modification lowbyte
                ;dc.b  >0                  ; Y modification highbyte
                dc.b  10*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  0                   ; Y aiming speed modification
                dc.b  9*8                 ; Y aiming pos. modification
                dc.b  0                   ; Y aiming affects bullet frame?
                dc.b  ACT_WIDEMELEEHIT    ; Bullet actor number
                dc.b  1                   ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_SHURIKEN
                dc.b  <0*8                ; X modification lowbyte
                dc.b  >0*8                ; X modification highbyte
                dc.b  <0                  ; Y modification lowbyte
                ;dc.b  >0                  ; Y modification highbyte
                dc.b  12*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  12*8/2              ; Y aiming speed modification
                dc.b  6*8                 ; Y aiming pos. modification
                dc.b  0                   ; Y aiming affects bullet frame?
                dc.b  ACT_SHURIKEN        ; Bullet actor number
                dc.b  20                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_DART
                dc.b  <6*8               ; X modification lowbyte
                dc.b  >6*8               ; X modification highbyte
                dc.b  <(-2*8)             ; Y modification lowbyte
                ;dc.b  >(-2*8)             ; Y modification highbyte
                dc.b  12*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  12*8/2              ; Y aiming speed modification
                dc.b  7*8                 ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_DART            ; Bullet actor number
                dc.b  20                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_PISTOL
                dc.b  <10*8               ; X modification lowbyte
                dc.b  >10*8               ; X modification highbyte
                dc.b  <(-2*8)             ; Y modification lowbyte
                ;dc.b  >(-2*8)             ; Y modification highbyte
                dc.b  14*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  14*8/2              ; Y aiming speed modification
                dc.b  9*8                 ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_BULLET          ; Bullet actor number
                dc.b  16                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_STEALTHPISTOL
                dc.b  <10*8               ; X modification lowbyte
                dc.b  >10*8               ; X modification highbyte
                dc.b  <(-2*8)             ; Y modification lowbyte
                ;dc.b  >(-2*8)             ; Y modification highbyte
                dc.b  14*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  14*8/2              ; Y aiming speed modification
                dc.b  9*8                 ; Y aiming pos. modification
                dc.b  0                   ; Y aiming affects bullet frame?
                dc.b  ACT_STEALTHBULLET   ; Bullet actor number
                dc.b  16                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)




                dc.b  BLT_SMG
                dc.b  <12*8               ; X modification lowbyte
                dc.b  >12*8               ; X modification highbyte
                dc.b  <(-2*8)             ; Y modification lowbyte
                ;dc.b  >(-2*8)             ; Y modification highbyte
                dc.b  14*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  14*8/2              ; Y aiming speed modification
                dc.b  9*8                 ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_BULLET          ; Bullet actor number
                dc.b  14                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_SHOTGUN1
                dc.b  <16*8               ; X modification lowbyte
                dc.b  >16*8               ; X modification highbyte
                dc.b  <(-2*8)             ; Y modification lowbyte
                ;dc.b  >(-2*8)             ; Y modification highbyte
                dc.b  14*8                ; X speed
                dc.b  4                   ; Y speed
                dc.b  14*8/2              ; Y aiming speed modification
                dc.b  11*8                ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_BULLET          ; Bullet actor number
                dc.b  13+$80              ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  BLT_SHOTGUN2        ; Next bullet (multi-bullet weapons)



                dc.b  BLT_SHOTGUN2
                dc.b  <16*8               ; X modification lowbyte
                dc.b  >16*8               ; X modification highbyte
                dc.b  <(-2*8)             ; Y modification lowbyte
                ;dc.b  >(-2*8)             ; Y modification highbyte
                dc.b  14*8                ; X speed
                dc.b  -4                  ; Y speed
                dc.b  14*8/2              ; Y aiming speed modification
                dc.b  11*8                ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_BULLET          ; Bullet actor number
                dc.b  13+$80              ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_ASHOTGUN1
                dc.b  <16*8               ; X modification lowbyte
                dc.b  >16*8               ; X modification highbyte
                dc.b  <(-2*8)             ; Y modification lowbyte
                ;dc.b  >(-2*8)             ; Y modification highbyte
                dc.b  14*8                ; X speed
                dc.b  4                   ; Y speed
                dc.b  14*8/2              ; Y aiming speed modification
                dc.b  11*8                ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_BULLET          ; Bullet actor number
                dc.b  13+$80              ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  BLT_SHOTGUN2        ; Next bullet (multi-bullet weapons)



                dc.b  BLT_ASHOTGUN2
                dc.b  <16*8               ; X modification lowbyte
                dc.b  >16*8               ; X modification highbyte
                dc.b  <(-2*8)             ; Y modification lowbyte
                ;dc.b  >(-2*8)             ; Y modification highbyte
                dc.b  14*8                ; X speed
                dc.b  -4                  ; Y speed
                dc.b  14*8/2              ; Y aiming speed modification
                dc.b  11*8                ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_BULLET          ; Bullet actor number
                dc.b  13+$80              ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_AR
                dc.b  <12*8               ; X modification lowbyte
                dc.b  >12*8               ; X modification highbyte
                dc.b  <(-2*8)             ; Y modification lowbyte
                ;dc.b  >(-2*8)             ; Y modification highbyte
                dc.b  15*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  15*8/2              ; Y aiming speed modification
                dc.b  9*8                 ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_RIFLEBULLET     ; Bullet actor number
                dc.b  16                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_SNIPER
                dc.b  <20*8               ; X modification lowbyte
                dc.b  >20*8               ; X modification highbyte
                dc.b  <(-2*8)             ; Y modification lowbyte
                ;dc.b  >(-2*8)             ; Y modification highbyte
                dc.b  15*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  15*8/2              ; Y aiming speed modification
                dc.b  13*8                ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_RIFLEBULLET     ; Bullet actor number
                dc.b  20                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)




                dc.b  BLT_MG
                dc.b  <8*8                ; X modification lowbyte
                dc.b  >8*8                ; X modification highbyte
                dc.b  <(6*8)              ; Y modification lowbyte
                ;dc.b  >(6*8)              ; Y modification highbyte
                dc.b  15*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  15*8/2              ; Y aiming speed modification
                dc.b  8*8                 ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_RIFLEBULLET     ; Bullet actor number
                dc.b  16                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)




                dc.b  BLT_LASER
                dc.b  <24*8               ; X modification lowbyte
                dc.b  >24*8               ; X modification highbyte
                dc.b  <(-1*8)             ; Y modification lowbyte
                ;dc.b  >(-1*8)             ; Y modification highbyte
                dc.b  $7f                 ; X speed
                dc.b  0                   ; Y speed
                dc.b  $7f/2               ; Y aiming speed modification
                dc.b  15*8                ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_LASER           ; Bullet actor number
                dc.b  18                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_PLASMA
                dc.b  <24*8               ; X modification lowbyte
                dc.b  >24*8               ; X modification highbyte
                dc.b  <(-4*8)             ; Y modification lowbyte
                ;dc.b  >(-4*8)             ; Y modification highbyte
                dc.b  13*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  13*8/2              ; Y aiming speed modification
                dc.b  15*8                ; Y aiming pos. modification
                dc.b  0                   ; Y aiming affects bullet frame?
                dc.b  ACT_PLASMA          ; Bullet actor number
                dc.b  18                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_GRENADE
                dc.b  <2*8                ; X modification lowbyte
                dc.b  >2*8                ; X modification highbyte
                dc.b  <0                  ; Y modification lowbyte
                ;dc.b  >0                  ; Y modification highbyte
                dc.b  6*8                 ; X speed
                dc.b  -5*8                ; Y speed
                dc.b  2*8                 ; Y aiming speed modification
                dc.b  7*8                 ; Y aiming pos. modification
                dc.b  0                   ; Y aiming affects bullet frame?
                dc.b  ACT_GRENADE         ; Bullet actor number
                dc.b  30                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_PARASITE
                dc.b  <2*8                ; X modification lowbyte
                dc.b  >2*8                ; X modification highbyte
                dc.b  <0                  ; Y modification lowbyte
                ;dc.b  >0                  ; Y modification highbyte
                dc.b  6*8                 ; X speed
                dc.b  -4*8                ; Y speed
                dc.b  2*8                 ; Y aiming speed modification
                dc.b  6*8                 ; Y aiming pos. modification
                dc.b  0                   ; Y aiming affects bullet frame?
                dc.b  ACT_PARASITE        ; Bullet actor number
                dc.b  50                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_FLAME
                dc.b  <4*8                ; X modification lowbyte
                dc.b  >4*8                ; X modification highbyte
                dc.b  <(6*8)              ; Y modification lowbyte
                ;dc.b  >(6*8)              ; Y modification highbyte
                dc.b  8*8                 ; X speed
                dc.b  0                   ; Y speed
                dc.b  8*8/2               ; Y aiming speed modification
                dc.b  5*8                 ; Y aiming pos. modification
                dc.b  0                   ; Y aiming affects bullet frame?
                dc.b  ACT_FLAME           ; Bullet actor number
                dc.b  12                  ; Bullet duration
                dc.b  1                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_ELECTRICITY
                dc.b  <16*8               ; X modification lowbyte
                dc.b  >16*8               ; X modification highbyte
                dc.b  <(-1*8)             ; Y modification lowbyte
                ;dc.b  >(-1*8)             ; Y modification highbyte
                dc.b  $7f                 ; X speed
                dc.b  0                   ; Y speed
                dc.b  $7f/2               ; Y aiming speed modification
                dc.b  13*8                ; Y aiming pos. modification
                dc.b  0                   ; Y aiming affects bullet frame?
                dc.b  ACT_ELECTRICITY     ; Bullet actor number
                dc.b  3                   ; Bullet duration
                dc.b  1                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_MISSILE
                dc.b  <12*8               ; X modification lowbyte
                dc.b  >12*8               ; X modification highbyte
                dc.b  <(-2*8)             ; Y modification lowbyte
                ;dc.b  >(-2*8)             ; Y modification highbyte
                dc.b  $10                 ; X speed
                dc.b  0                   ; Y speed
                dc.b  $10/2               ; Y aiming speed modification
                dc.b  9*8                 ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_MISSILE         ; Bullet actor number
                dc.b  12                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)



                dc.b  BLT_PSIONIC
                dc.b  <24*8               ; X modification lowbyte
                dc.b  >24*8               ; X modification highbyte
                dc.b  <(-3*8)             ; Y modification lowbyte
                ;dc.b  >(-3*8)             ; Y modification highbyte
                dc.b  15*8                ; X speed
                dc.b  0                   ; Y speed
                dc.b  15*8/2              ; Y aiming speed modification
                dc.b  15*8                ; Y aiming pos. modification
                dc.b  1                   ; Y aiming affects bullet frame?
                dc.b  ACT_PSIONIC          ; Bullet actor number
                dc.b  16                  ; Bullet duration
                dc.b  0                   ; Remain on hit
                dc.b  0                   ; Next bullet (multi-bullet weapons)

                dc.b  $ff  ; End bullet defs.

                ; Items

                dc.b  ITEM_FISTS
                dc.b  0                    ; Default pickup amount
                dc.b  1                    ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_INFINITE        ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_BATON
                dc.b  1                    ; Default pickup amount
                dc.b  1                    ; Maximum carried / clip size
                dc.b  4                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_INFINITE        ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_KNIFE
                dc.b  1                    ; Default pickup amount
                dc.b  1                    ; Maximum carried / clip size
                dc.b  2                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_INFINITE        ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_KATANA
                dc.b  1                    ; Default pickup amount
                dc.b  1                    ; Maximum carried / clip size
                dc.b  6                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_INFINITE        ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_SHURIKEN
                dc.b  5                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  5                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_FRAG_GRENADE
                dc.b  2                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  7                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_PARASITE
                dc.b  2                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  7                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_DARTGUN
                dc.b  3                    ; Default pickup amount
                dc.b  5                    ; Maximum carried / clip size
                dc.b  2                    ; Item weight
                dc.b  5                    ; Ammo weight multiplier
                dc.b  ITEM_DARTS           ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_9MM_PISTOL
                dc.b  7                    ; Default pickup amount
                dc.b  15                   ; Maximum carried / clip size
                dc.b  2                    ; Item weight
                dc.b  3                    ; Ammo weight multiplier
                dc.b  ITEM_9MM_AMMO        ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_9MM_SILENCED_PISTOL
                dc.b  7                    ; Default pickup amount
                dc.b  15                   ; Maximum carried / clip size
                dc.b  3                    ; Item weight
                dc.b  3                    ; Ammo weight multiplier
                dc.b  ITEM_9MM_AMMO        ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_44_MAGNUM_PISTOL
                dc.b  4                    ; Default pickup amount
                dc.b  8                    ; Maximum carried / clip size
                dc.b  4                    ; Item weight
                dc.b  4                    ; Ammo weight multiplier
                dc.b  ITEM_44MAGNUM_AMMO   ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_9MM_SUBMACHINEGUN
                dc.b  10                   ; Default pickup amount
                dc.b  30                   ; Maximum carried / clip size
                dc.b  5                    ; Item weight
                dc.b  3                    ; Ammo weight multiplier
                dc.b  ITEM_9MM_AMMO        ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_SHOTGUN
                dc.b  4                    ; Default pickup amount
                dc.b  8                    ; Maximum carried / clip size
                dc.b  7                    ; Item weight
                dc.b  4                    ; Ammo weight multiplier
                dc.b  ITEM_12GAUGE_AMMO    ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_AUTO_SHOTGUN
                dc.b  5                    ; Default pickup amount
                dc.b  10                   ; Maximum carried / clip size
                dc.b  9                    ; Item weight
                dc.b  4                    ; Ammo weight multiplier
                dc.b  ITEM_12GAUGE_AMMO    ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_556_ASSAULT_RIFLE
                dc.b  10                   ; Default pickup amount
                dc.b  30                   ; Maximum carried / clip size
                dc.b  7                    ; Item weight
                dc.b  3                    ; Ammo weight multiplier
                dc.b  ITEM_556_AMMO        ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_762_SNIPER_RIFLE
                dc.b  3                    ; Default pickup amount
                dc.b  5                    ; Maximum carried / clip size
                dc.b  10                   ; Item weight
                dc.b  5                    ; Ammo weight multiplier
                dc.b  ITEM_762_AMMO        ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_556_MACHINE_GUN
                dc.b  20                   ; Default pickup amount
                dc.b  99                   ; Maximum carried / clip size
                dc.b  11                   ; Item weight
                dc.b  3                    ; Ammo weight multiplier
                dc.b  ITEM_556_AMMO        ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_FLAME_THROWER
                dc.b  20                   ; Default pickup amount
                dc.b  60                   ; Maximum carried / clip size
                dc.b  8                    ; Item weight
                dc.b  4                    ; Ammo weight multiplier
                dc.b  ITEM_FUEL            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_LASER_RIFLE
                dc.b  7                    ; Default pickup amount
                dc.b  20                   ; Maximum carried / clip size
                dc.b  10                   ; Item weight
                dc.b  4                    ; Ammo weight multiplier
                dc.b  ITEM_CHARGE_CELLS    ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_GASFIST_MK2
                dc.b  5                    ; Default pickup amount
                dc.b  15                   ; Maximum carried / clip size
                dc.b  12                   ; Item weight
                dc.b  5                    ; Ammo weight multiplier
                dc.b  ITEM_PLUTONIUM       ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_PSIONIC_RIFLE
                dc.b  5                    ; Default pickup amount
                dc.b  15                   ; Maximum carried / clip size
                dc.b  11                   ; Item weight
                dc.b  5                    ; Ammo weight multiplier
                dc.b  ITEM_PLUTONIUM       ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_MISSILE_LAUNCHER
                dc.b  2                    ; Default pickup amount
                dc.b  4                    ; Maximum carried / clip size
                dc.b  10                   ; Item weight
                dc.b  7                    ; Ammo weight multiplier
                dc.b  ITEM_MISSILES        ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_ELECTRONIC_STUN_GUN
                dc.b  7                    ; Default pickup amount
                dc.b  10                   ; Maximum carried / clip size
                dc.b  2                    ; Item weight
                dc.b  4                    ; Ammo weight multiplier
                dc.b  ITEM_CHARGE_CELLS    ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_9MM_AMMO
                dc.b  15                   ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  3                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_44MAGNUM_AMMO
                dc.b  10                   ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  4                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_12GAUGE_AMMO
                dc.b  10                   ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  4                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_556_AMMO
                dc.b  30                   ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  3                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_762_AMMO
                dc.b  10                   ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  5                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_FUEL
                dc.b  60                   ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  4                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_CHARGE_CELLS
                dc.b  20                   ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  4                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_PLUTONIUM
                dc.b  15                   ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  5                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_MISSILES
                dc.b  2                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  7                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_DARTS
                dc.b  10                   ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  5                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_MEDIKIT
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  8+$80                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  1                    ; Usable

                dc.b  ITEM_BATTERY
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  8+$80                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  1                    ; Usable

                dc.b  ITEM_BEER
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  7+$80                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  1                    ; Usable

                dc.b  ITEM_CREDITS
                dc.b  5                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_VITALITY_ENHANCEMENT
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  8                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_STRENGTH_ENHANCEMENT
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  8                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_BETA_ARMORSYSTEM
                dc.b  1                    ; Default pickup amount
                dc.b  1                    ; Maximum carried / clip size
                dc.b  4                    ; Item weight
                dc.b  0+$80                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  1                    ; Usable

                dc.b  ITEM_GAMMA_ARMORSYSTEM
                dc.b  1                    ; Default pickup amount
                dc.b  1                    ; Maximum carried / clip size
                dc.b  4                    ; Item weight
                dc.b  0+$80                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  1                    ; Usable

                dc.b  ITEM_DELTA_ARMORSYSTEM
                dc.b  1                    ; Default pickup amount
                dc.b  1                    ; Maximum carried / clip size
                dc.b  4                    ; Item weight
                dc.b  0+$80                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  1                    ; Usable

                dc.b  ITEM_EPSILON_ARMORSYSTEM
                dc.b  1                    ; Default pickup amount
                dc.b  1                    ; Maximum carried / clip size
                dc.b  4                    ; Item weight
                dc.b  0+$80                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  1                    ; Usable

                dc.b  ITEM_AGENT_GEAR
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  4                    ; Item weight
                dc.b  0+$80                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  1                    ; Usable

                dc.b  ITEM_MAINTENANCE_ACCESS
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_BASEMENT_ACCESS
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_TRAIN_ACCESS
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_ARMORY_ACCESS
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_CELL_ACCESS
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_SECURITY_ACCESS
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_LIFT_ACCESS
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_REACTOR_ACCESS
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_TELEPORT_ACCESS
                dc.b  1                    ; Default pickup amount
                dc.b  1                    ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_CODESHEET1
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_CODESHEET2
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_CODESHEET3
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_CODESHEET4
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_LETTER
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  0                    ; Item weight
                dc.b  0+$80                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  1                    ; Usable

                dc.b  ITEM_LEVER
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  2                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_CRYSTAL
                dc.b  1                    ; Default pickup amount
                dc.b  255                  ; Maximum carried / clip size
                dc.b  1                    ; Item weight
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  ITEM_FAKEAGENTGEAR
                dc.b  1                    ; Default pickup amount
                dc.b  1                    ; Maximum carried / clip size
                dc.b  120                  ; Item weight (impossible to pick up)
                dc.b  0                    ; Ammo weight multiplier
                dc.b  AMMO_NONE            ; Ammo item type
                ;dc.b  0                    ; Usable

                dc.b  $ff   ; End item defs.

                ; Special damage


                dc.b  SPDMG_DARTS
                dc.b  AFB_ORGANIC          ; Fightbits that must be on for damage to work
                dc.b  -12                  ; Damage time
                dc.b  1                    ; Damage hitpoints delta
                dc.b  4                    ; Initial damage
                dc.b  1                    ; Bypass armor



                dc.b  SPDMG_FLAME
                dc.b  $ff                  ; Fightbits that must be on for damage to work
                dc.b  -10                  ; Damage time
                dc.b  1+DMG_LETHAL         ; Damage hitpoints delta
                dc.b  4+DMG_LETHAL         ; Initial damage
                dc.b  0                    ; Bypass armor



                dc.b  SPDMG_TASER
                dc.b  AFB_ORGANIC          ; Fightbits that must be on for damage to work
                dc.b  0                    ; Damage time
                dc.b  0                    ; Damage hitpoints delta
                dc.b  5                    ; Initial damage
                dc.b  1                    ; Bypass armor



                dc.b  SPDMG_PSIONIC
                dc.b  AFB_ORGANIC          ; Fightbits that must be on for damage to work
                dc.b  0                    ; Damage time
                dc.b  0                    ; Damage hitpoints delta
                dc.b  10+DMG_LETHAL        ; Initial damage
                dc.b  1                    ; Bypass armor



                dc.b  SPDMG_PARASITE
                dc.b  AFB_ORGANIC          ; Fightbits that must be on for damage to work
                dc.b  -10                  ; Damage time
                dc.b  2+DMG_LETHAL         ; Damage hitpoints delta
                dc.b  4+DMG_LETHAL         ; Initial damage
                dc.b  0                    ; Bypass armor

                dc.b  $ff   ; End special damage defs.




