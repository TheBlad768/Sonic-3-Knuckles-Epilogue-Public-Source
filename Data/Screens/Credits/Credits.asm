; ---------------------------------------------------------------------------
; Credits Screen
; ---------------------------------------------------------------------------

; RAM
vCredits_Buffer:				= $FFFF2000		; $800 bytes
vCredits_FactorBuffer:			= $FFFF2800			; $800 bytes

vCredits_Timer:				= Object_load_addr_front		; word
vCredits_TextFactor:			= Object_load_addr_front+2	; byte
vCredits_End:				= Object_load_addr_front+3	; byte
vCredits_Wait:				= Object_load_addr_front+4	; byte

; =============== S U B R O U T I N E =======================================

Credits_Screen:
		music	bgm_Prologue,0,0,0
		lea	(Pal_Options).l,a1
		lea	(Normal_palette).w,a2
		jsr	(PalLoad_Line64).w
		clr.w	(Normal_palette_line_2+2).w
		lea	(Normal_palette_line_2+$18).w,a0
		move.l	#$00AA0088,(a0)+
		move.l	#$00660044,(a0)+
		move.w	#2*60,(Demo_timer).w
		move.b	#$14,(vCredits_TextFactor).w
		move.l	#Obj_Prologue_Shadow,(Object_RAM).w
		move.w	#$8225,(Object_RAM+art_tile).w

-		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		bsr.w	CreditsScreen_Process
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		tst.b	(vCredits_End).w
		beq.s	-

CreditsScreen_PressStart:
		disableInts
		stopZ80
		dmaFillVRAM 0,$C000,$1000
		startZ80
		enableInts
		clr.l	(Object_load_addr_front).w
		clr.l	(Object_load_addr_front+4).w
		clr.l	(Object_load_addr_front+8).w
		clr.l	(Object_load_addr_front+$C).w
		clr.b	(Object_load_routine).w
		clr.w	(Camera_Y_pos).w
		lea	(Object_RAM).w,a1
		jsr	(Delete_Referenced_Sprite).w
		lea	(RAM_start+$3000).l,a3
		move.w	#bytesToWcnt(2240),d1

-		clr.w	(a3)+
		dbf	d1,-
		disableInts
		bsr.w	Options_InitDraw
		enableInts
		sfx	bgm_Stop,0,0,0
		lea	(Pal_Options).l,a1
		lea	(Normal_palette).w,a2
		jsr	(PalLoad_Line64).w
		move.w	#2*60,(Demo_timer).w
		clr.w	(HScroll_Shift).w
		clr.b	(Intro_flag).w
		clr.b	(PauseSkip_Flag).w
		clr.l	(Timer).w						; clear time
		clr.b	(Time_over_flag).w
		move.b	#$14,(vCredits_TextFactor).w
		bsr.w	HardLine_Deform_Screen1
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		move.b	#id_OptionsScreen,(Game_mode).w
		bra.w	Options_Loop

; =============== S U B R O U T I N E =======================================

CreditsScreen_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	CreditsScreen_Process_Index(pc,d0.w),d0
		jmp	CreditsScreen_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

CreditsScreen_Process_Index: offsetTable
		offsetTableEntry.w CreditsScreen_Process_Wait			; 0
		offsetTableEntry.w CreditsScreen_Process_LoadText		; 2
		offsetTableEntry.w CreditsScreen_Process_CheckScroll		; 4
		offsetTableEntry.w CreditsScreen_Process_WaitStart		; 6
		offsetTableEntry.w CreditsScreen_Process_HideText		; 8
		offsetTableEntry.w CreditsScreen_Process_Wait			; A
		offsetTableEntry.w CreditsScreen_Process_End			; C
; ---------------------------------------------------------------------------

CreditsScreen_Process_Wait:
		tst.w	(Demo_timer).w
		bne.s	CreditsScreen_Process_Wait_Return
		addq.b	#2,(Object_load_routine).w

CreditsScreen_Process_Wait_Return:
		rts
; ---------------------------------------------------------------------------

CreditsScreen_Process_LoadText:
		cmpi.w	#32,(Camera_Y_pos).w
		blo.s		CreditsScreen_Process_CheckScroll
		tst.b	(vCredits_TextFactor).w
		beq.s	CreditsScreen_Process_LoadText_End
		subq.w	#1,(vCredits_Timer).w
		bpl.s	CreditsScreen_Process_CheckScroll
		move.w	#1,(vCredits_Timer).w
		lea	(vCredits_Buffer).l,a1			; Mod Art
		lea	(vCredits_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothDrawArtText
		move.l	#vCredits_Buffer>>1,d1
		move.w	#tiles_to_bytes($340),d2	; VRAM
		bsr.w	SmoothLoadArtText
		bra.s	CreditsScreen_Process_CheckScroll
; ---------------------------------------------------------------------------

CreditsScreen_Process_LoadText_End:
		addq.b	#2,(Object_load_routine).w

CreditsScreen_Process_CheckScroll:
		tst.b	(vCredits_Wait).w
		beq.s	CreditsScreen_Process_NoSkipScroll
		tst.b	(Ctrl_1_pressed).w
		bmi.s	CreditsScreen_Process_SkipScroll

CreditsScreen_Process_NoSkipScroll:
		cmpi.w	#60,(Camera_Y_pos).w
		bne.s	CreditsScreen_Process_ToScroll
		st	(vCredits_Wait).w

CreditsScreen_Process_ToScroll:
		cmpi.w	#2340,(Camera_Y_pos).w
		blo.s		CreditsScreen_Process_Scroll
		addq.b	#2,(Object_load_routine).w

CreditsScreen_Process_ToScroll2:
		move.b	#$14,(vCredits_TextFactor).w
		rts
; ---------------------------------------------------------------------------

CreditsScreen_Process_SkipScroll:
		addq.b	#4,(Object_load_routine).w
		bra.s	CreditsScreen_Process_ToScroll2
; ---------------------------------------------------------------------------

CreditsScreen_Process_Scroll:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#1,d0
		bne.s	+
		addq.w	#1,(Camera_Y_pos).w
+		move.w	(Camera_Y_pos).w,d1
		lea	Credits_MainTextIndex(pc),a1
		locVRAM	$C000,d3
		bra.w	Copy_Map_Line_To_VRAM_Prologue
; ---------------------------------------------------------------------------

CreditsScreen_Process_WaitStart:
		tst.b	(Ctrl_1_pressed).w
		bpl.s	CreditsScreen_Process_WaitStart_Return
		addq.b	#2,(Object_load_routine).w

CreditsScreen_Process_WaitStart_Return:
		rts
; ---------------------------------------------------------------------------

CreditsScreen_Process_HideText:
		tst.b	(vCredits_TextFactor).w
		beq.s	CreditsScreen_Process_HideText_End
		subq.w	#1,(vCredits_Timer).w
		bpl.s	CreditsScreen_Process_Scroll
		move.w	#1,(vCredits_Timer).w
		lea	(vCredits_Buffer).l,a1			; Mod Art
		lea	(vCredits_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothHideArtText
		move.l	#vCredits_Buffer>>1,d1
		move.w	#tiles_to_bytes($340),d2	; VRAM
		bsr.w	SmoothLoadArtText
		bra.s	CreditsScreen_Process_Scroll
; ---------------------------------------------------------------------------

CreditsScreen_Process_HideText_End:
		addq.b	#2,(Object_load_routine).w
		move.w	#1*60,(Demo_timer).w
		rts
; ---------------------------------------------------------------------------

CreditsScreen_Process_End:
		st	(vCredits_End).w
		rts

; =============== S U B R O U T I N E =======================================

Credits_MainTextIndex: offsetTable
		offsetTableEntry.w Credits_MainText1
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText2
		offsetTableEntry.w Credits_MainText3
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText4
		offsetTableEntry.w Credits_MainText5
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText6
		offsetTableEntry.w Credits_MainText7
		offsetTableEntry.w Credits_MainText8
		offsetTableEntry.w Credits_MainText9
		offsetTableEntry.w Credits_MainText10
		offsetTableEntry.w Credits_MainText11
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText12
		offsetTableEntry.w Credits_MainText13
		offsetTableEntry.w Credits_MainText14
		offsetTableEntry.w Credits_MainText15
		offsetTableEntry.w Credits_MainText16
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText17
		offsetTableEntry.w Credits_MainText18
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText19
		offsetTableEntry.w Credits_MainText20
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText21
		offsetTableEntry.w Credits_MainText22
		offsetTableEntry.w Credits_MainText23
		offsetTableEntry.w Credits_MainText24
		offsetTableEntry.w Credits_MainText25
		offsetTableEntry.w Credits_MainText26
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText27
		offsetTableEntry.w Credits_MainText28
		offsetTableEntry.w Credits_MainText29
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText30
		offsetTableEntry.w Credits_MainText31
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText32
		offsetTableEntry.w Credits_MainText33
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText34
		offsetTableEntry.w Credits_MainText35
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText36
		offsetTableEntry.w Credits_MainText37
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText38
		offsetTableEntry.w Credits_MainText39
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText40
		offsetTableEntry.w Credits_MainText41
		offsetTableEntry.w Credits_MainText42
		offsetTableEntry.w Credits_MainText43
		offsetTableEntry.w Credits_MainText44
		offsetTableEntry.w Credits_MainText45
		offsetTableEntry.w Credits_MainText46
		offsetTableEntry.w Credits_MainText47
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText48
		offsetTableEntry.w Credits_MainText49
		offsetTableEntry.w Credits_MainText50
		offsetTableEntry.w Credits_MainText51
		offsetTableEntry.w Credits_MainText52
		offsetTableEntry.w Credits_MainText53
		offsetTableEntry.w Credits_MainText54
		offsetTableEntry.w Credits_MainText55
		offsetTableEntry.w Credits_MainText56
		offsetTableEntry.w Credits_MainText57
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText58
		offsetTableEntry.w Credits_MainText59
		offsetTableEntry.w Credits_MainText60
		offsetTableEntry.w Credits_MainText61
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText62
		offsetTableEntry.w Credits_MainText63
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText64
		offsetTableEntry.w Credits_MainText65
		offsetTableEntry.w Credits_MainText66
		offsetTableEntry.w Credits_MainText67
		offsetTableEntry.w Credits_MainText68
		offsetTableEntry.w Credits_MainText69
		offsetTableEntry.w Credits_MainText70
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText71
		offsetTableEntry.w Credits_MainText72
		offsetTableEntry.w Credits_MainText73
		offsetTableEntry.w Credits_MainText74
		offsetTableEntry.w Credits_MainText75
		offsetTableEntry.w Credits_MainText76
		offsetTableEntry.w Credits_MainText77
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText78
		offsetTableEntry.w Credits_MainText79
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText80
		offsetTableEntry.w Credits_MainText81
		offsetTableEntry.w Credits_MainText82
		offsetTableEntry.w Credits_MainText83
		offsetTableEntry.w Credits_MainText84
		offsetTableEntry.w Credits_MainText85
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainText86

; Null
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull
		offsetTableEntry.w Credits_MainTextNull

Credits_MainText1:		prologuestr $00, "SONIC 3 & KNUCKLES: EPILOGUE (2021)"

Credits_MainText2:		prologuestr $01, "- CREATED BY -"
Credits_MainText3:		prologuestr $00, "HARDLINE"

Credits_MainText4:		prologuestr $01, "- PROGRAMMING BY -"
Credits_MainText5:		prologuestr $00, "THEBLAD768"

Credits_MainText6:		prologuestr $01, "- GRAPHICS BY -"
Credits_MainText7:		prologuestr $00, "PIXELCAT"
Credits_MainText8:		prologuestr $00, "THEBLAD768"
Credits_MainText9:		prologuestr $00, "FOXCONED"
Credits_MainText10:		prologuestr $00, "TISAKOTU"
Credits_MainText11:		prologuestr $00, "DOLPHMAN"

Credits_MainText12:		prologuestr $01, "- MAIN MUSIC BY -"
Credits_MainText13:		prologuestr $00, "FOXCONED"
Credits_MainText14:		prologuestr $00, "        "
Credits_MainText15:		prologuestr $00, "N-BAH"
Credits_MainText16:		prologuestr $00, "PIXELCAT"

Credits_MainText17:		prologuestr $01, "- OTHER SOUND BY -"
Credits_MainText18:		prologuestr $00, "THEBLAD768"

Credits_MainText19:		prologuestr $01, "- TRANSLATION TO ENGLISH BY -"
Credits_MainText20:		prologuestr $00, "PIXELCAT"

Credits_MainText21:		prologuestr $01, "- BETA TESTERS -"
Credits_MainText22:		prologuestr $00, "NARCOLOGER"
Credits_MainText23:		prologuestr $00, "FOXCONED"
Credits_MainText24:		prologuestr $00, "PIXELCAT"
Credits_MainText25:		prologuestr $00, "TISAKOTU"
Credits_MainText26:		prologuestr $00, "VLADIKCOMPER"

Credits_MainText27:		prologuestr $01, "- ADVANCED ERROR HANDLER FROM -"
Credits_MainText28:		prologuestr $00, "VLADIKCOMPER"
Credits_MainText29:		prologuestr $00, "AURORA FIELDS"

Credits_MainText30:		prologuestr $01, "- ULTRA DMA QUEUE FROM -"
Credits_MainText31:		prologuestr $00, "FLAMEWING"

Credits_MainText32:		prologuestr $01, "- SONIC 2 CLONE DRIVER V2 FROM -"
Credits_MainText33:		prologuestr $00, "CLOWNACY"

Credits_MainText34:		prologuestr $01, "- MSU CD DRIVER FROM -"
Credits_MainText35:		prologuestr $00, "KRIKZZ"

Credits_MainText36:		prologuestr $01, "- GENESIS EMULATOR DETECTOR -"
Credits_MainText37:		prologuestr $00, "RALAKIMUS"

Credits_MainText38:		prologuestr $01, "- SPECIAL THANKS -"
Credits_MainText39:		prologuestr $00, "VLADIKCOMPER"

Credits_MainText40:		prologuestr $01, "- MUSIC FROM FOXCONED -"
Credits_MainText41:		prologuestr $00, "MEGA MAN ZERO 4 - FALLING DOWN"
Credits_MainText42:		prologuestr $00, "MEGA MAN 9 - BOSS THEME"
Credits_MainText43:		prologuestr $00, "THUNDER FORCE IV - EASY ENDING (HQ)"
Credits_MainText44:		prologuestr $00, "THUNDER FORCE IV - LIGHT OF SI... (HQ)"
Credits_MainText45:		prologuestr $00, "ELEMENTAL MASTER - SORROWFUL R... (HQ)"
Credits_MainText46:		prologuestr $00, "THE LAWNMOWER MAN - CYBER RUN (HQ)"
Credits_MainText47:		prologuestr $00, "SVA - TITLE SCREEN"

Credits_MainText48:		prologuestr $01, "- MUSIC FROM              -"
Credits_MainText49:		prologuestr $00, "THUNDER FORCE IV - EASY ENDING (SMPS)"
Credits_MainText50:		prologuestr $00, "THUNDER FORCE IV - ACE RANKING (SMPS)"
Credits_MainText51:		prologuestr $00, "THUNDER FORCE IV - LIGHT OF... (SMPS)"
Credits_MainText52:		prologuestr $00, "ELEMENTAL MASTER - SORROWFUL REQUIEM"
Credits_MainText53:		prologuestr $00, "BATMAN AND ROBIN - BOSS THEME"
Credits_MainText54:		prologuestr $00, "THE LAWNMOWER MAN - CYBER RUN"
Credits_MainText55:		prologuestr $00, "MINI GAME - TITLE"
Credits_MainText56:		prologuestr $00, "MINI GAME - DEZ  "
Credits_MainText57:		prologuestr $00, "MINI GAME - GHZ  "

Credits_MainText58:		prologuestr $01, "- MUSIC FROM N-BAH -"
Credits_MainText59:		prologuestr $00, "SVA - SONIC GOT THROUGH"
Credits_MainText60:		prologuestr $00, "SVA - INVINCIBILITY"
Credits_MainText61:		prologuestr $00, "SVA - TITLE SCREEN"

Credits_MainText62:		prologuestr $01, "- MUSIC FROM PIXELCAT -"
Credits_MainText63:		prologuestr $00, "THUNDER FORCE IV - LIGHT OF SI... (HQ)"

Credits_MainText64:		prologuestr $01, "- OTHER CD MUSIC -"
Credits_MainText65:		prologuestr $00, "QUARTZ QUADRANT *B* MIX (US)"
Credits_MainText66:		prologuestr $00, "SONIC UNLEASHED - EGGMANLAND (CUT)"
Credits_MainText67:		prologuestr $00, "SONIC CD - ROBOTNIK (US)"
Credits_MainText68:		prologuestr $00, "SONIC GENERATIONS - INVINCIBLE"
Credits_MainText69:		prologuestr $00, "SONIC GENERATIONS - ACT CLEAR"
Credits_MainText70:		prologuestr $00, "SONIC GENERATIONS - COUNTDOWN"

Credits_MainText71:		prologuestr $01, "- OTHER GRAPHICS FROM -"
Credits_MainText72:		prologuestr $00, "SONIC TEAM"
Credits_MainText73:		prologuestr $00, "GUNSTAR HEROES"
Credits_MainText74:		prologuestr $00, "CONTRA - HARD CORPS"
Credits_MainText75:		prologuestr $00, "THE ADVENTURES OF BATMAN AND ROBIN"
Credits_MainText76:		prologuestr $00, "ROCKET KNIGHT ADVENTURES"
Credits_MainText77:		prologuestr $00, "SPARKSTER"

Credits_MainText78:		prologuestr $01, "- ORIGINAL BACKGROUND FOR MINI GAME -"
Credits_MainText79:		prologuestr $00, "SONICLOVER789"

Credits_MainText80:		prologuestr $01, "- STAY TUNED HERE -"
Credits_MainText81:		prologuestr $00, "HTTPS:// YOUTUBE.COM / THEBLAD768"
Credits_MainText82:		prologuestr $00, "HTTPS:// REDMISO.STUDIO"
Credits_MainText83:		prologuestr $00, "HTTPS:// VK.COM  / RED_MISO_STUDIOS"
Credits_MainText84:		prologuestr $00, "HTTPS:// DISCORD.ME  / HARDLINETEAM"
Credits_MainText85:		prologuestr $00, "HTTPS:// PIXELCAT.SPACE"

Credits_MainText86:		prologuestr $00, "THANK YOU FOR PLAYING!"
















Credits_MainTextNull:		dc.b 0, 0, -1
	even