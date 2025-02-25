; ---------------------------------------------------------------------------
; Options Screen
; ---------------------------------------------------------------------------

vOptions_Buffer:				= $FFFF2000		; $800 bytes
vOptions_FactorBuffer:		= $FFFF2800			; $800 bytes

; RAM
vOptions_Timer:				= Camera_RAM		; word
vOptions_TextFactor:			= Camera_RAM+2	; byte
vOptions_End:				= Camera_RAM+3	; byte
vOptions_Music_test_count:	= Camera_RAM+4	; word
vOptions_Sound_test_count:	= Camera_RAM+6	; word
vOptions_PlayFlag:			= Camera_RAM+8	; byte
vOptions_Count:				= Camera_RAM+$A	; word
vOptions_Frame_Counter:		= Camera_RAM+$C	; word

; =============== S U B R O U T I N E =======================================

Options_Screen:
		sfx	bgm_Stop,0,1,1
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Clear_Nem_Queue).w
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
		clr.b	(Timer_flag).w
		clr.w	(Intro_flag).w
		clr.w	(Water_full_screen_flag).w
		lea	(RAM_start+$3000).l,a3
		move.w	#bytesToWcnt(2240),d1

-		clr.w	(a3)+
		dbf	d1,-
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM Oscillating_variables, Oscillating_variables_End
		ResetDMAQueue
		lea	PLC_Sega(pc),a1
		jsr	(Load_PLC_Nem_Immediate).w
		lea	(MapEni_TitleBG).l,a0
		lea	(RAM_start).l,a1
		move.w	#$E080,d0
		jsr	(Eni_Decomp).w
		copyTilemap	vram_bg, 512, 256
		lea	(Pal_Options).l,a1
		lea	(Target_palette_line_1).w,a2
		moveq	#(64/2)-1,d0
		jsr	(PalLoad_Line.loop).w
		bsr.w	Load_Options_Text
		move.w	#palette_line_1,d3
		bsr.w	Options_LoadMainText
		move.w	#palette_line_1,d3
		bsr.w	Options_LoadExitText
		move.w	#palette_line_1,d3
		bsr.w	Options_MarkFields
		move.w	#palette_line_0,d3
		bsr.w	Options_DrawSoundNumber
		move.w	#palette_line_0,d3
		bsr.w	Options_DrawMusicNumber
		move.w	#palette_line_0,d3
		bsr.w	Options_LoadQuickStart
		move.w	#palette_line_0,d3
		bsr.w	Options_LoadFlashing
		move.b	#$14,(vOptions_TextFactor).w
		move.w	#3,(Demo_timer).w
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.w	Title_Deform
		bsr.w	LevelSelect_Deform
		bsr.w	OptionsScreen_Process
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

Options_Loop:
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		addq.w	#1,(vOptions_Frame_Counter).w
		bsr.w	Title_Deform
		bsr.w	LevelSelect_Deform
		bsr.w	OptionsScreen_Process
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		tst.b	(vOptions_End).w
		beq.s	Options_Loop

Options_PressStart:
		cmpi.w	#4,(vOptions_Count).w
		beq.s	Options_PressStart_LoadMiniGame
		disableInts
		dmaFillVRAM 0,$C000,$1000
		enableInts
		clr.l	(Camera_RAM).w
		clr.l	(Camera_RAM+4).w
		clr.w	(Camera_RAM+8).w
		clr.l	(Camera_RAM+$C).w
		clr.b	(Object_load_routine).w
		bsr.w	HardLine_Deform_Screen1
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.w	Title_Deform
		lea	Sega_Screen(pc),a1
		cmpi.w	#5,(vOptions_Count).w
		bne.s	+
		lea	TimeScreen_Screen(pc),a1
+		cmpi.w	#6,(vOptions_Count).w
		bne.s	Options_PressStart_Load
		lea	Credits_Screen(pc),a1

Options_PressStart_Load:
		clr.w	(Camera_RAM+$A).w
		jmp	(a1)
; ---------------------------------------------------------------------------

Options_PressStart_LoadMiniGame:
		clr.l	(Score).l
		bra.w	MiniGame_Screen

; =============== S U B R O U T I N E =======================================

OptionsScreen_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	OptionsScreen_Process_Index(pc,d0.w),d0
		jmp	OptionsScreen_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

OptionsScreen_Process_Index: offsetTable
		offsetTableEntry.w OptionsScreen_Process_Wait			; 0
		offsetTableEntry.w OptionsScreen_Process_StopBG		; 2
		offsetTableEntry.w OptionsScreen_Process_LoadText		; 4
		offsetTableEntry.w OptionsScreen_Process_Control			; 6
		offsetTableEntry.w OptionsScreen_Process_Wait			; 8
		offsetTableEntry.w OptionsScreen_Process_HideText		; A
		offsetTableEntry.w OptionsScreen_Process_CheckFade		; C
		offsetTableEntry.w OptionsScreen_Process_Wait			; E
		offsetTableEntry.w OptionsScreen_Process_End			; 10
; ---------------------------------------------------------------------------

OptionsScreen_Process_Wait:
		tst.w	(Demo_timer).w
		bne.s	OptionsScreen_Process_Wait_Return

OptionsScreen_Process_LoadText_End:
		addq.b	#2,(Object_load_routine).w

OptionsScreen_Process_Wait_Return:
		rts
; ---------------------------------------------------------------------------

OptionsScreen_Process_StopBG:
		subq.w	#8,(HScroll_Shift).w
		bpl.s	OptionsScreen_Process_Wait_Return
		clr.w	(HScroll_Shift).w
		bra.s	OptionsScreen_Process_LoadText_End
; ---------------------------------------------------------------------------

OptionsScreen_Process_LoadText:
		tst.b	(vOptions_TextFactor).w
		beq.s	OptionsScreen_Process_LoadText_End
		subq.w	#1,(vOptions_Timer).w
		bpl.s	OptionsScreen_Process_Wait_Return
		move.w	#1,(vOptions_Timer).w
		lea	(vOptions_Buffer).l,a1			; Mod Art
		lea	(vOptions_FactorBuffer).l,a2	; Tile factor
		lea	(ArtUnc_TerminalText2).l,a0
		move.w	#((ArtUnc_TerminalText2_End-ArtUnc_TerminalText2)/$20)-1,d7		; Art size
		bsr.w	SmoothDrawArtText.loc_CDC6
		move.l	#vOptions_Buffer,d1
		move.w	#tiles_to_bytes($3D),d2	; VRAM

SmoothLoadArtText2:
		move.w	#(ArtUnc_TerminalText2_End-ArtUnc_TerminalText2)/2,d3		; Size/2
		jmp	(Add_To_DMA_Queue).w
; ---------------------------------------------------------------------------

OptionsScreen_Process_Control:
		disableInts
		moveq	#palette_line_0,d3
		bsr.w	Options_MarkFields
		bsr.w	Options_Controls
		move.w	#palette_line_1,d3
		bsr.w	Options_MarkFields
		enableInts
		tst.b	(Ctrl_1_pressed).w
		bpl.s	OptionsScreen_Process_Control_Return
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vOptions_TextFactor).w
		move.w	#3,(Demo_timer).w

OptionsScreen_Process_Control_Return:
		rts
; ---------------------------------------------------------------------------

OptionsScreen_Process_HideText:
		tst.b	(vOptions_TextFactor).w
		beq.s	OptionsScreen_Process_HideText_End
		subq.w	#1,(vOptions_Timer).w
		bpl.s	OptionsScreen_Process_Control_Return
		move.w	#1,(vOptions_Timer).w
		lea	(vOptions_Buffer).l,a1			; Mod Art
		lea	(vOptions_FactorBuffer).l,a2	; Tile factor
		lea	(ArtUnc_TerminalText2).l,a0
		move.w	#((ArtUnc_TerminalText2_End-ArtUnc_TerminalText2)/$20)-1,d7		; Art size
		bsr.w	SmoothHideArtText.loc_CDC6
		move.l	#vOptions_Buffer,d1
		move.w	#tiles_to_bytes($3D),d2	; VRAM
		bra.s	SmoothLoadArtText2
; ---------------------------------------------------------------------------

OptionsScreen_Process_HideText_End:
		addq.b	#2,(Object_load_routine).w
		move.w	#$F,(Demo_timer).w
		tst.b	(vOptions_PlayFlag).w
		beq.s	+
		sfx	bgm_Fade,1,0,0
+		rts
; ---------------------------------------------------------------------------

OptionsScreen_Process_CheckFade:
		tst.b	(Clone_Driver_RAM+SMPS_RAM.variables.v_fadeout_counter).w
		bne.s	+
		addq.b	#2,(Object_load_routine).w
+		rts
; ---------------------------------------------------------------------------

OptionsScreen_Process_End:
		cmpi.w	#5,(vOptions_Count).w
		beq.s	OptionsScreen_Process_SetEnd
		cmpi.w	#4,(vOptions_Count).w
		beq.s	OptionsScreen_Process_SetEnd
		addq.w	#8,(HScroll_Shift).w
		cmpi.w	#$100,(HScroll_Shift).w
		blo.s		OptionsScreen_Process_End_Return
		move.w	#$100,(HScroll_Shift).w

OptionsScreen_Process_SetEnd:
		st	(vOptions_End).w

OptionsScreen_Process_End_Return:
		rts

; =============== S U B R O U T I N E =======================================

Options_Controls:
		moveq	#8-1,d2
		move.w	(vOptions_Count).w,d0
		bsr.w	LevelSelect_FindUpDownControls
		move.w	d0,(vOptions_Count).w
		tst.w	(vOptions_Count).w
		beq.w	LevelSelect_LoadFlashingNumber
		cmpi.w	#1,(vOptions_Count).w
		beq.w	LevelSelect_LoadQuickStartNumber
		cmpi.w	#2,(vOptions_Count).w
		beq.w	LevelSelect_LoadMusicNumber
		cmpi.w	#3,(vOptions_Count).w
		beq.w	LevelSelect_LoadSoundNumber

Options_Controls_Return:
		rts

; =============== S U B R O U T I N E =======================================

Options_MarkFields:
		lea	(RAM_start+$3000).l,a4
		lea	Options_MarkTable(pc),a5
		lea	(VDP_data_port).l,a6
		moveq	#0,d0
		move.w	(vOptions_Count).w,d0
		lsl.w	#2,d0
		lea	(a5,d0.w),a3
		moveq	#0,d0
		move.b	(a3),d0
		mulu.w	#$50,d0
		moveq	#0,d1
		move.b	1(a3),d1
		add.w	d1,d0
		lea	(a4,d0.w),a1
		moveq	#0,d1
		move.b	(a3),d1
		lsl.w	#7,d1
		add.b	1(a3),d1
		addi.w	#VRAM_Plane_A_Name_Table,d1
		lsl.l	#2,d1
		lsr.w	#2,d1
		ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d1
		swap	d1
		move.l	d1,VDP_control_port-VDP_data_port(a6)
		moveq	#$40,d2
-		move.w	(a1)+,d0
		add.w	d3,d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d2,-
		addq.w	#2,a3
		moveq	#0,d0
		move.b	(a3),d0
		beq.s	+
		mulu.w	#$50,d0
		moveq	#0,d1
		move.b	1(a3),d1
		add.w	d1,d0
		lea	(a4,d0.w),a1
		moveq	#0,d1
		move.b	(a3),d1
		lsl.w	#7,d1
		add.b	1(a3),d1
		addi.w	#VRAM_Plane_A_Name_Table,d1
		lsl.l	#2,d1
		lsr.w	#2,d1
		ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d1
		swap	d1
		move.l	d1,VDP_control_port-VDP_data_port(a6)
		move.w	(a1)+,d0
		add.w	d3,d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)
+		tst.w	(vOptions_Count).w
		bne.s	+
		bra.s	Options_LoadFlashing
+		cmpi.w	#1,(vOptions_Count).w
		bne.s	+
		bra.s	Options_LoadQuickStart
+		cmpi.w	#2,(vOptions_Count).w
		bne.s	+
		bra.w	Options_DrawMusicNumber
+		cmpi.w	#3,(vOptions_Count).w
		bne.s	Options_LoadFlashing_Return
		bra.w	Options_DrawSoundNumber

; =============== S U B R O U T I N E =======================================

Options_LoadFlashing:
		moveq	#0,d0
		move.b	(Seizure_flag).w,d0
		add.w	d0,d0
		lea	Options_LoadFlashingText(pc),a1
		locVRAM	$C332
		btst	#3,(vOptions_Frame_Counter+1).w
		bne.s	Options_LoadFlashing_Return
		bra.s	Options_LoadText
; ---------------------------------------------------------------------------

Options_LoadMainText:
		lea	Options_MainText(pc),a1
		locVRAM	$C080
		bra.s	Options_LoadText2
; ---------------------------------------------------------------------------

Options_LoadExitText:
		lea	Options_ExitText(pc),a1
		locVRAM	$CD00
		bra.s	Options_LoadText2
; ---------------------------------------------------------------------------

Options_LoadQuickStart:
		moveq	#0,d0
		move.b	(QuickStart_mode).w,d0
		add.w	d0,d0
		lea	Options_LoadQuickStartText(pc),a1
		locVRAM	$C432
		btst	#3,(vOptions_Frame_Counter+1).w
		bne.s	Options_LoadFlashing_Return

Options_LoadText:
		adda.w	(a1,d0.w),a1

Options_LoadText2:
		moveq	#0,d6
		move.b	(a1)+,d6

-		moveq	#0,d0
		move.b	(a1)+,d0
		addi.w	#$3C,d0
		add.w	d3,d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d6,-

Options_LoadFlashing_Return:
		rts

; =============== S U B R O U T I N E =======================================

Options_DrawMusicNumber:
		locVRAM	$C532
		move.w	(vOptions_Music_test_count).w,d0
		btst	#3,(vOptions_Frame_Counter+1).w
		bne.s	Options_LoadFlashing_Return
		bra.s	Options_DrawNumbers
; ---------------------------------------------------------------------------

Options_DrawSoundNumber:
		locVRAM	$C632
		move.w	(vOptions_Sound_test_count).w,d0
		btst	#3,(vOptions_Frame_Counter+1).w
		bne.s	Options_LoadFlashing_Return

Options_DrawNumbers:
		move.b	d0,d2
		lsr.b #8,d0
		bsr.s	+
		move.b	d2,d0
		lsr.b	#4,d0
		bsr.s	+
		move.b	d2,d0
+		andi.w	#$F,d0
		cmpi.b	#$A,d0
		blo.s		+
		addq.b	#7,d0
+		addi.w	#$3D,d0
		add.w	d3,d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		rts

; =============== S U B R O U T I N E =======================================

Load_Options_Text:
		lea	Options_Text(pc),a1
		lea	Options_MapText(pc),a5
		moveq	#8-1,d1

Load_Options_Text2:
		moveq	#0,d0
		lea	(RAM_start+$3000).l,a3

-		move.w	(a5)+,d3
		lea	(a3,d3.w),a2
		moveq	#0,d2
		move.b	(a1)+,d2
		move.w	d2,d3

-		moveq	#0,d0
		move.b	(a1)+,d0
		addi.w	#$3C,d0
		move.w	d0,(a2)+
		dbf	d2,-
		dbf	d1,--
		lea	(RAM_start+$3000).l,a1
		locVRAM	$C000,d0
		moveq	#(320/8-1),d1
		moveq	#(224/8-1),d2
		jmp	(Plane_Map_To_VRAM).w

; =============== S U B R O U T I N E =======================================

Options_MarkTable:
		dc.b 6, 0, 6, $24
		dc.b 8, 0, 8, $24
		dc.b 10, 0, 10, $24
		dc.b 12, 0, 12, $24
		dc.b 14, 0, 14, $24
		dc.b 16, 0, 16, $24
		dc.b 18, 0, 18, $24
		dc.b 20, 0, 20, $24
Options_MapText:
		dc.w planeLocH28(0,6)
		dc.w planeLocH28(0,8)
		dc.w planeLocH28(0,10)
		dc.w planeLocH28(0,12)
		dc.w planeLocH28(0,14)
		dc.w planeLocH28(0,16)
		dc.w planeLocH28(0,18)
		dc.w planeLocH28(0,20)
Options_Text:
		optionstr "   FLASHING:           -                "
		optionstr "   FREE MODE:          -                "
		optionstr "   MUSIC TEST:         -                "
		optionstr "   SOUND TEST:         -                "
		optionstr "   PLAY SONIUM                          "
		optionstr "   TIME ATTACK                          "
		optionstr "   CREDITS                              "
		optionstr "   EXIT                                 "
	even

Options_LoadFlashingText: offsetTable
		offsetTableEntry.w Options_LoadQuickStart2
		offsetTableEntry.w Options_LoadQuickStart1
Options_LoadQuickStartText: offsetTable
		offsetTableEntry.w Options_LoadQuickStart1
		offsetTableEntry.w Options_LoadQuickStart2
; --------------------------------------------------------------------------

Options_LoadQuickStart1:
		optionstr "OFF"
Options_LoadQuickStart2:
		optionstr "ON"
Options_MainText:
		optionstr "SONIC EPILOGUE - STARTUP SETTINGS                               "
Options_ExitText:
		optionstr "      PRESS *START* BUTTON TO EXIT      "
	even

		CHARSET ; reset character set
