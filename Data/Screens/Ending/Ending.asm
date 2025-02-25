; ---------------------------------------------------------------------------
; Ending Screen
; ---------------------------------------------------------------------------

vEnding_Buffer:			= $FFFF2000		; $800 bytes
vEnding_FactorBuffer:		= $FFFF2800			; $800 bytes

vEnding_Timer:			= Object_load_addr_front		; word
vEnding_TextFactor:		= Object_load_addr_front+2	; byte
vEnding_End:			= Object_load_addr_front+3	; byte
vEnding_Wait:			= Object_load_addr_front+4	; byte

; =============== S U B R O U T I N E =======================================

Ending_Screen:
		sfx	bgm_Stop,0,1,1
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Pal_FadeToBlack).w
		disableInts
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)					; Command $8004 - Disable HInt, HV Counter
		move.w	#$8200+(vram_fg>>10),(a6)	; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)	; Command $8407 - Nametable B at $E000
		move.w	#$8700+(0<<4),(a6)			; Command $8700 - BG color is Pal 0 Color 0
		move.w	#$8B03,(a6)					; Command $8B00 - Vscroll full, HScroll full
		move.w	#$8C81,(a6)					; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM Oscillating_variables, Oscillating_variables_End
		ResetDMAQueue
		lea	PLC_Sega(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(Title_Layout).l,a0
		jsr	(Load_Level2).w
		lea	(DEZ_128x128_Kos).l,a0
		lea	(RAM_start).l,a1
		jsr	(Kos_Decomp).w
		move.l	#DEZ_16x16_Unc,(Block_table_addr_ROM).w
		lea	(Pal_Options).l,a1
		lea	(Target_palette).w,a2
		jsr	(PalLoad_Line64).w
		lea	(Pal_InsertCoin+$A0).l,a1
		lea	(Target_palette_line_3).w,a2
		jsr	(PalLoad_Line16).w
		bsr.w	InsertCoinScreen_LevelSetup
		cmpi.b	#3,(Current_act).w		; Act 4
		beq.s	+
		lea	Ending_MainText(pc),a1
		locVRAM	$C202,d1
		move.w	#$33F,d3
		jsr	(Load_PlaneText).w
		bra.s	Ending_Load
+
		lea	Ending_AltText(pc),a1
		locVRAM	$C102,d1
		move.w	#$33F,d3
		jsr	(Load_PlaneText).w
		lea	Ending_AltCodeText(pc),a1
		locVRAM	$C90C,d1
		move.w	#$433F,d3
		jsr	(Load_PlaneText).w

Ending_Load:
		move.w	#$1000,(HScroll_Shift).w
		move.b	#$14,(vEnding_TextFactor).w
		move.w	#3,(Demo_timer).w

-		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Kos_modules_left).w
		bne.s	-
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		jsr	(Process_Kos_Module_Queue).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

-		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		bsr.w	EndingScreen_Process
		jsr	(Process_Kos_Module_Queue).w
		tst.b	(vEnding_End).w
		beq.s	-

Ending_PressStart:
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
		bsr.w	HardLine_Deform_Screen1
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		jsr	(Process_Kos_Module_Queue).w
		bra.w	Credits_Screen

; =============== S U B R O U T I N E =======================================

EndingScreen_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	EndingScreen_Process_Index(pc,d0.w),d0
		jmp	EndingScreen_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

EndingScreen_Process_Index: offsetTable
		offsetTableEntry.w EndingScreen_Process_Wait			; 0
		offsetTableEntry.w EndingScreen_Process_LoadText		; 2
		offsetTableEntry.w EndingScreen_Process_CheckScroll		; 4
		offsetTableEntry.w EndingScreen_Process_HideText		; 6
		offsetTableEntry.w EndingScreen_Process_Wait			; 8
		offsetTableEntry.w EndingScreen_Process_End			; A
; ---------------------------------------------------------------------------

EndingScreen_Process_Wait:
		tst.w	(Demo_timer).w
		bne.s	EndingScreen_Process_Wait_Return
		addq.b	#2,(Object_load_routine).w

EndingScreen_Process_Wait_Return:
		rts
; ---------------------------------------------------------------------------

EndingScreen_Process_LoadText:
		tst.b	(vEnding_TextFactor).w
		beq.s	EndingScreen_Process_LoadText_End
		subq.w	#1,(vEnding_Timer).w
		bpl.s	EndingScreen_Process_Wait_Return
		move.w	#1,(vEnding_Timer).w
		lea	(vEnding_Buffer).l,a1			; Mod Art
		lea	(vEnding_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothDrawArtText
		move.l	#vEnding_Buffer>>1,d1
		move.w	#tiles_to_bytes($340),d2	; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

EndingScreen_Process_LoadText_End:
		addq.b	#2,(Object_load_routine).w

EndingScreen_Process_CheckScroll:
		tst.b	(Ctrl_1_pressed).w
		bpl.s	EndingScreen_Process_Wait_Return
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vEnding_TextFactor).w
		rts
; ---------------------------------------------------------------------------

EndingScreen_Process_HideText:
		tst.b	(vEnding_TextFactor).w
		beq.s	EndingScreen_Process_HideText_End
		subq.w	#1,(vEnding_Timer).w
		bpl.s	Ending_Process_Return
		move.w	#1,(vEnding_Timer).w
		lea	(vEnding_Buffer).l,a1			; Mod Art
		lea	(vEnding_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothHideArtText
		move.l	#vEnding_Buffer>>1,d1
		move.w	#tiles_to_bytes($340),d2	; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

EndingScreen_Process_HideText_End:
		addq.b	#2,(Object_load_routine).w
		move.w	#1*60,(Demo_timer).w

Ending_Process_Return:
		rts
; ---------------------------------------------------------------------------

EndingScreen_Process_End:
		st	(vEnding_End).w
		rts

; =============== S U B R O U T I N E =======================================

	; set the character
		CHARSET ' ', 0
		CHARSET '0','9', 1
		CHARSET '!', $B
		CHARSET '?', $C
		CHARSET '&', $D
		CHARSET '@', $E
		CHARSET '^', $F
		CHARSET '*', $10
		CHARSET '$', $11
		CHARSET ';', $12
		CHARSET ':', $13
		CHARSET '.', $14
		CHARSET ',', $15
		CHARSET '(', $16
		CHARSET ')', $17
		CHARSET '-', $18
		CHARSET '=', $19
		CHARSET '<', $1A
		CHARSET '>', $1B
		CHARSET '/', $1C
		CHARSET 'A','Z', $1D
		CHARSET 'a','z', $1D

Ending_MainText:
		dc.b "Will Sonic be able to save himself and",$81
		dc.b " foil the foul plans of Dr. Robotnik",$81
		dc.b " yet again, or will his adventure end",$81
		dc.b " here, lost in the vastness of space?",$82
		dc.b "      Tune into the next episode",$81
		dc.b "             to find out!",$8A
		dc.b "     PRESS *START* BUTTON TO EXIT",-1
Ending_AltText:
		dc.b "  Alternate route? Is this the true",$81
		dc.b " ending? No. This one was added just",$81
		dc.b " for fun. I hope that you liked this",$81
		dc.b "  little adventure and you had fun",$81
		dc.b "playing. Maybe you*ll even be able to",$81
		dc.b "       spot a few more secrets!",$82
		dc.b "        Take this cheat code:",$85
		dc.b "  Use it while the game is paused to",$81
		dc.b "       skip to the next level.",$82
		dc.b "     PRESS *START* BUTTON TO EXIT",-1
Ending_AltCodeText:
		dc.b "B A Down B A Down Left Up C",-1
	even

		CHARSET ; reset character set
