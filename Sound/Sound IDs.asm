; ---------------------------------------------------------------------------
; Sound IDs
; ---------------------------------------------------------------------------
; Background music
offset :=	MusicIndex
ptrsize :=	4
idstart :=	1
; $00 is reserved for silence

bgm__First = idstart
; Levels
bgm_DEZ1 =			SMPS_id(ptr_mus_dez1)

; Bosses
bgm_MidBoss =		SMPS_id(ptr_mus_boss)
bgm_ZoneBoss =		SMPS_id(ptr_mus_boss2)
bgm_DeathBallBoss =	SMPS_id(ptr_mus_boss3)
bgm_BallBoss =		SMPS_id(ptr_mus_boss4)

; Misc
bgm_Invincible =		SMPS_id(ptr_mus_invin)
bgm_GotThrough =	SMPS_id(ptr_mus_through)
bgm_Drowning =		SMPS_id(ptr_mus_drowning)

; Other
bgm_Prologue =		SMPS_id(ptr_mus_prologue)
bgm_TitleStartup =	SMPS_id(ptr_mus_titlestartup)
bgm_TitleScroll =		SMPS_id(ptr_mus_titlescroll)
bgm_Title =			SMPS_id(ptr_mus_title)
bgm_Sparkster =		SMPS_id(ptr_mus_sparkster)
bgm_MiniBallBoss =	SMPS_id(ptr_mus_boss5)
bgm_TitleSMS =		SMPS_id(ptr_mus_titlebug)
bgm_GameOver =		SMPS_id(ptr_mus_gameover)
bgm_DEZSMS =		SMPS_id(ptr_mus_dezsms)
bgm_GHZSMS =		SMPS_id(ptr_mus_ghzsms)

bgm__Last =			SMPS_id(ptr_musend)-1

; Sound effects
offset :=	SoundIndex
ptrsize :=	4
idstart :=	$40

sfx__First = idstart
sfx_Ring =			SMPS_id(ptr_snd40)
sfx_RingLeft =		SMPS_id(ptr_snd41)
sfx_RingLoss =		SMPS_id(ptr_snd42)
sfx_Jump =			SMPS_id(ptr_snd43)
sfx_Roll =			SMPS_id(ptr_snd44)
sfx_Skid =			SMPS_id(ptr_snd45)
sfx_Death =			SMPS_id(ptr_snd46)
sfx_SpinDash =		SMPS_id(ptr_snd47)
sfx_Splash =			SMPS_id(ptr_snd48)
sfx_InstaAttack =		SMPS_id(ptr_snd49)
sfx_FireShield =		SMPS_id(ptr_snd4A)
sfx_BubleShield =		SMPS_id(ptr_snd4B)
sfx_LightShield =		SMPS_id(ptr_snd4C)
sfx_FireAttack =		SMPS_id(ptr_snd4D)
sfx_BubleAttack =		SMPS_id(ptr_snd4E)
sfx_LightAttack =		SMPS_id(ptr_snd4F)
sfx_HitSpikes =		SMPS_id(ptr_snd50)
sfx_SpikesMove =		SMPS_id(ptr_snd51)
sfx_Drown =			SMPS_id(ptr_snd52)
sfx_Lamppost =		SMPS_id(ptr_snd53)
sfx_Spring =			SMPS_id(ptr_snd54)
sfx_Teleport =		SMPS_id(ptr_snd55)
sfx_BreakItem =		SMPS_id(ptr_snd56)
sfx_HitBoss =			SMPS_id(ptr_snd57)
sfx_Warning =		SMPS_id(ptr_snd58)
sfx_Air =			SMPS_id(ptr_snd59)
sfx_Bomb =			SMPS_id(ptr_snd5A)
sfx_Signpost =		SMPS_id(ptr_snd5B)
sfx_Switch =			SMPS_id(ptr_snd5C)
sfx_Cash =			SMPS_id(ptr_snd5D)
sfx_ScarySignal =		SMPS_id(ptr_snd5E)
sfx_ScarySignal2 =	SMPS_id(ptr_snd5F)
sfx_Boom2 =			SMPS_id(ptr_snd60)
sfx_Boom =			SMPS_id(ptr_snd61)
sfx_WallSmash =		SMPS_id(ptr_snd62)
sfx_Magnet =			SMPS_id(ptr_snd63)
sfx_BreakBridge =		SMPS_id(ptr_snd64)
sfx_Flash =			SMPS_id(ptr_snd65)
sfx_Laser =			SMPS_id(ptr_snd66)
sfx_Laser2 =			SMPS_id(ptr_snd67)
sfx_Laser3 =			SMPS_id(ptr_snd68)
sfx_Laser4 =			SMPS_id(ptr_snd69)
sfx_Laser5 =			SMPS_id(ptr_snd6A)
sfx_Squeak =			SMPS_id(ptr_snd6B)
sfx_Emerald =		SMPS_id(ptr_snd6C)
sfx_Bumper =		SMPS_id(ptr_snd6D)
sfx_Fire =			SMPS_id(ptr_snd6E)
sfx_Ghost =			SMPS_id(ptr_snd6F)
sfx_Falling =			SMPS_id(ptr_snd70)
sfx_Attachment =		SMPS_id(ptr_snd71)
sfx_Attachment2 =	SMPS_id(ptr_snd72)
sfx_Signal =			SMPS_id(ptr_snd73)
sfx_Lifting =			SMPS_id(ptr_snd74)
sfx_Descend =		SMPS_id(ptr_snd75)
sfx_Activation =		SMPS_id(ptr_snd76)
sfx_Shaking =		SMPS_id(ptr_snd77)
sfx_Wave =			SMPS_id(ptr_snd78)
sfx_Circular =		SMPS_id(ptr_snd79)
sfx_SpikeBall =		SMPS_id(ptr_snd7A)
sfx_LaserStart =		SMPS_id(ptr_snd7B)
sfx_SpikeAttack =		SMPS_id(ptr_snd7C)
sfx_Wham =			SMPS_id(ptr_snd7D)
sfx_Bumper2 =		SMPS_id(ptr_snd7E)
sfx_Fire2 =			SMPS_id(ptr_snd7F)
sfx_SpikeBall2 =		SMPS_id(ptr_snd80)
sfx_Jump2 =			SMPS_id(ptr_snd81)
sfx_Teleport2 =		SMPS_id(ptr_snd82)
sfx_Siren =			SMPS_id(ptr_snd83)
sfx_Rotate =			SMPS_id(ptr_snd84)
sfx_SpikeAttack2 =	SMPS_id(ptr_snd85)
sfx_SegaKick =		SMPS_id(ptr_snd86)
sfx_SegaPresent =		SMPS_id(ptr_snd87)
sfx_Electro =			SMPS_id(ptr_snd88)
sfx_Jump3 =			SMPS_id(ptr_snd89)
sfx_Arm =			SMPS_id(ptr_snd8A)
sfx_JumpSMS =		SMPS_id(ptr_snd8B)
sfx_AttackSMS =		SMPS_id(ptr_snd8C)
sfx_DeathSMS =		SMPS_id(ptr_snd8D)
sfx_Open =			SMPS_id(ptr_snd8E)
sfx_Grab =			SMPS_id(ptr_snd8F)
sfx_Trans =			SMPS_id(ptr_snd90)
sfx_Shot =			SMPS_id(ptr_snd91)
sfx_DialogSonic =		SMPS_id(ptr_snd92)
sfx_DialogRobotnik =	SMPS_id(ptr_snd93)
sfx_DialogMiniBall =	SMPS_id(ptr_snd94)
sfx_DialogBall =		SMPS_id(ptr_snd95)
sfx_DialogTails =		SMPS_id(ptr_snd96)
sfx_DialogFireBall =	SMPS_id(ptr_snd97)
sfx_DialogFireBall2 =	SMPS_id(ptr_snd98)

; Continuous
sfx_WindQuiet =		SMPS_id(ptr_sndC01)
sfx_WindLoud =		SMPS_id(ptr_sndC02)
sfx_LargeShip =		SMPS_id(ptr_sndC03)
sfx_Rising =			SMPS_id(ptr_sndC04)
sfx_Siren2 =			SMPS_id(ptr_sndC05)
sfx_RiseLoud =		SMPS_id(ptr_sndC06)

sfx__Last =			SMPS_id(ptr_sndend)-1

; Sound commands
offset :=	Sound_ExIndex
ptrsize :=	2
idstart :=	$FA

flg__First = idstart
sfx_Fade =			SMPS_id(ptr_flgFA)
bgm_Fade =			SMPS_id(ptr_flgFB)
sfx_Sega =			SMPS_id(ptr_flgFC)
bgm_Speedup =		SMPS_id(ptr_flgFD)
bgm_Slowdown =		SMPS_id(ptr_flgFE)
bgm_Stop =			SMPS_id(ptr_flgFF)
flg__Last =			SMPS_id(ptr_flgend)-1
