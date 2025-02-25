; ---------------------------------------------------------------------------
; Music metadata (pointers, speed shoes tempos, flags)
; ---------------------------------------------------------------------------
MusicIndex:
; Levels
ptr_mus_dez1:		SMPS_MUSIC_METADATA	Music_DEZ1, s3TempotoS1($FF), 0			; DEZ 1

; Boss
ptr_mus_boss:		SMPS_MUSIC_METADATA	Music_Boss, s3TempotoS1($FF), 0			; Boss
ptr_mus_boss2:		SMPS_MUSIC_METADATA	Music_Boss2, s3TempotoS1($FF), 0			; Boss 2
ptr_mus_boss3:		SMPS_MUSIC_METADATA	Music_Boss3, s3TempotoS1($FF), 0			; Boss 3
ptr_mus_boss4:		SMPS_MUSIC_METADATA	Music_Boss4, s3TempotoS1($FF), 0			; Boss 4

; Misc
ptr_mus_invin:		SMPS_MUSIC_METADATA	Music_Invin, s3TempotoS1($FF), 0			; Invincible
ptr_mus_through:	SMPS_MUSIC_METADATA	Music_Through, s3TempotoS1($FF), 0		; End of Act
ptr_mus_drowning:	SMPS_MUSIC_METADATA	Music_Drowning, s3TempotoS1($02), SMPS_MUSIC_METADATA_FORCE_PAL_SPEED	; Drowning

; Other
ptr_mus_prologue:	SMPS_MUSIC_METADATA	Music_Prologue, s3TempotoS1($FF), 0		; Prologue
ptr_mus_titlestartup:	SMPS_MUSIC_METADATA	Music_TitleStartup, s3TempotoS1($FF), 0	; Title Startup
ptr_mus_titlescroll:	SMPS_MUSIC_METADATA	Music_TitleScroll, s3TempotoS1($FF), 0		; Title Scroll
ptr_mus_title:		SMPS_MUSIC_METADATA	Music_Title, s3TempotoS1($FF), 0			; Title
ptr_mus_sparkster:	SMPS_MUSIC_METADATA	Music_Sparkster, s3TempotoS1($FF), 0		; Sparkster
ptr_mus_boss5:		SMPS_MUSIC_METADATA	Music_Boss5, s3TempotoS1($FF), 0			; Boss 5
ptr_mus_gameover:	SMPS_MUSIC_METADATA	Music_GameOver, s3TempotoS1($FF), 0		; Game Over
ptr_mus_titlebug:		SMPS_MUSIC_METADATA	Music_TitleSMS, s3TempotoS1($FF), 0		; Title Glitch
ptr_mus_dezsms:		SMPS_MUSIC_METADATA	Music_DEZSMS, s3TempotoS1($FF), 0		; DEZ Glitch
ptr_mus_ghzsms:		SMPS_MUSIC_METADATA	Music_GHZSMS, s3TempotoS1($FF), 0		; GHZ Glitch

ptr_musend

; ---------------------------------------------------------------------------
; Music data ($01-$3F)
; ---------------------------------------------------------------------------

Music_DEZ1:			include "Sound/Music/Mus - DEZ1.asm"
	even
Music_Boss:			include "Sound/Music/Mus - Miniboss.asm"
	even
Music_Boss2:			include "Sound/Music/Mus - Zone Boss.asm"
	even
Music_Boss3:			include "Sound/Music/Mus - Boss(Death Ball).asm"
	even
Music_Boss4:			include "Sound/Music/Mus - Boss(Ball).asm"
	even
Music_Boss5:			include "Sound/Music/Mus - Boss(Mini Ball).asm"
	even
Music_Invin:			include "Sound/Music/Mus - Invincibility.asm"
	even
Music_Through: 		include "Sound/Music/Mus - Sonic Got Through.asm"
	even
Music_Drowning:		include "Sound/Music/Mus - Drowning.asm"
	even
Music_Prologue:		include "Sound/Music/Mus - Prologue.asm"
	even
Music_TitleStartup:	include "Sound/Music/Mus - Title Startup.asm"
	even
Music_TitleScroll:		include "Sound/Music/Mus - Title Scroll.asm"
	even
Music_Title:			include "Sound/Music/Mus - Title.asm"
	even
Music_Sparkster:		include "Sound/Music/Mus - Sparkster.asm"
	even
Music_GameOver:	include "Sound/Music/Mus - Game Over.asm"
	even
Music_TitleSMS:		include "Sound/Music/Mus - Title Bug.asm"
	even
Music_DEZSMS:		include "Sound/Music/Mus - DEZ SMS.asm"
	even
Music_GHZSMS:		include "Sound/Music/Mus - GHZ SMS.asm"
	even