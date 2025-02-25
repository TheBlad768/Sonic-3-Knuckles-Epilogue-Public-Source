; ---------------------------------------------------------------------------
; Insert Coin Screen
; ---------------------------------------------------------------------------

vInsertCoin_Buffer:			= $FFFF2000		; $800 bytes
vInsertCoin_FactorBuffer:		= $FFFF2800			; $800 bytes
vInsertCoin_Buffer2:			= $FFFF3000			; $800 bytes
vInsertCoin_FactorBuffer2:		= $FFFF3800			; $800 bytes

; RAM
vInsertCoin_Timer:			= Camera_RAM		; word
vInsertCoin_TextFactor:		= Camera_RAM+2	; byte
vInsertCoin_End:				= Camera_RAM+3	; byte
vInsertCoin_TextChg:			= Camera_RAM+4	; byte

; =============== S U B R O U T I N E =======================================

InsertCoin_Screen:
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
		lea	(RAM_start+$900).l,a1
		copyTilemap	vram_bg, 512, 256
		lea	(Pal_Options).l,a1
		lea	(Target_palette_line_1).w,a2
		moveq	#(64/2)-1,d0
		jsr	(PalLoad_Line.loop).w
		lea	InsertCoin_MainText(pc),a1
		locVRAM	$C080,d1
		move.w	#$203C,d3
		jsr	(Load_PlaneText).w
		move.w	#$120,(V_scroll_value+2).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#3,(Demo_timer).w
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.w	Title_Deform
		bsr.w	LevelSelect_Deform
		bsr.w	InsertCoinScreen_Process
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

InsertCoin_Loop:
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w

		bsr.w	Title_Deform
		bsr.w	LevelSelect_Deform

		bsr.w	InsertCoinScreen_Process

		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		tst.b	(vInsertCoin_End).w
		beq.s	InsertCoin_Loop

InsertCoin_PressStart:
		disableInts
		stopZ80
		dmaFillVRAM 0,$C000,$1000
		startZ80
		enableInts
		clr.l	(Camera_RAM).w
		clr.l	(Camera_RAM+4).w
		clr.l	(Camera_RAM+8).w
		clr.l	(Camera_RAM+$C).w
		clr.b	(Object_load_routine).w
		lea	(RAM_start+$3000).l,a3
		move.w	#bytesToWcnt(2240),d1

-		clr.w	(a3)+
		dbf	d1,-
		disableInts
		bsr.w	Options_InitDraw
		enableInts
		lea	(Pal_Options).l,a1
		lea	(Normal_palette_line_1).w,a2
		moveq	#(64/2)-1,d0
		jsr	(PalLoad_Line.loop).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		bsr.w	HardLine_Deform_Screen1
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.w	Title_Deform
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		bra.w	Options_Loop

; =============== S U B R O U T I N E =======================================

InsertCoinScreen_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	InsertCoinScreen_Process_Index(pc,d0.w),d0
		jmp	InsertCoinScreen_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_Index: offsetTable
		offsetTableEntry.w InsertCoinScreen_Process_Wait		; 0
		offsetTableEntry.w InsertCoinScreen_Process_StopBG		; 2
		offsetTableEntry.w InsertCoinScreen_Process_LoadText		; 4

		offsetTableEntry.w InsertCoinScreen_Process_DrawPSB
		offsetTableEntry.w InsertCoinScreen_Process_HidePSB



		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp
		offsetTableEntry.w InsertCoinScreen_Process_LoadTiles	; 8

		offsetTableEntry.w InsertCoinScreen_Process_Wait		; 8
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_Wait:
		tst.w	(Demo_timer).w
		bne.s	InsertCoinScreen_Process_Wait_Return

InsertCoinScreen_Process_LoadText_End:
		addq.b	#2,(Object_load_routine).w

InsertCoinScreen_Process_Wait_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_StopBG:
		subq.w	#8,(HScroll_Shift).w
		bpl.s	InsertCoinScreen_Process_Wait_Return
		clr.w	(HScroll_Shift).w
		bra.s	InsertCoinScreen_Process_LoadText_End
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadText:
		tst.b	(vInsertCoin_TextFactor).w
		beq.s	InsertCoinScreen_Process_LoadText_End
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_Wait_Return
		move.w	#1,(vInsertCoin_Timer).w
		lea	(vInsertCoin_Buffer).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer).l,a2		; Tile factor
		lea	(ArtUnc_TerminalText2).l,a0
		move.w	#((ArtUnc_TerminalText2_End-ArtUnc_TerminalText2)/$20)-1,d7		; Art size
		bsr.w	SmoothDrawArtText.loc_CDC6
		move.l	#vInsertCoin_Buffer,d1
		move.w	#tiles_to_bytes($3D),d2	; VRAM
		bra.w	SmoothLoadArtText2
; ---------------------------------------------------------------------------




InsertCoinScreen_Process_DrawPSB:
		tst.b	(vInsertCoin_TextFactor).w
		bne.s	InsertCoinScreen_Process_DrawPSB_Wait

InsertCoinScreen_Process_DrawPSB_Skip:
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#7,(vInsertCoin_Timer).w

InsertCoinScreen_Process_DrawPSB_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_DrawPSB_Wait:
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_DrawPSB_Return
		move.w	#1,(vInsertCoin_Timer).w

		lea	(vInsertCoin_Buffer2).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer2).l,a2		; Tile factor


		lea	(ArtUnc_TerminalText2).l,a0
		move.w	#((ArtUnc_TerminalText2_End-ArtUnc_TerminalText2)/$20)-1,d7		; Art size
		bsr.w	SmoothDrawArtText.loc_CDC6


		move.l	#vInsertCoin_Buffer2,d1
		move.w	#tiles_to_bytes($240),d2	; VRAM
		bra.w	SmoothLoadArtText2
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_HidePSB:
		tst.b	(vInsertCoin_TextFactor).w
		bne.s	InsertCoinScreen_Process_HidePSB_Wait
		subq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#7,(vInsertCoin_Timer).w

		lea	InsertCoin_PSBText(pc),a1
		bchg	#0,(vInsertCoin_TextChg).w
		bne.s	+
		lea	InsertCoin_ICText(pc),a1
+

		move.w	#$223F,d3
		locVRAM	$C780,d1
		jsr	(Load_PlaneText).w

InsertCoinScreen_Process_HidePSB_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_HidePSB_Wait:
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_HidePSB_Return
		move.w	#1,(vInsertCoin_Timer).w

		lea	(vInsertCoin_Buffer2).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer2).l,a2		; Tile factor



		lea	(ArtUnc_TerminalText2).l,a0
		move.w	#((ArtUnc_TerminalText2_End-ArtUnc_TerminalText2)/$20)-1,d7		; Art size
		bsr.w	SmoothHideArtText.loc_CDC6

		move.l	#vInsertCoin_Buffer2,d1
		move.w	#tiles_to_bytes($240),d2	; VRAM
		bra.w	SmoothLoadArtText2
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_ScrollUp:
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_LoadTiles
		move.w	#1,(vInsertCoin_Timer).w

		subq.w	#1,(V_scroll_value+2).w
		bne.s	InsertCoinScreen_Process_LoadTiles
		addq.b	#2,(Object_load_routine).w

InsertCoinScreen_Process_LoadTiles:
		move.w	(V_scroll_value+2).w,d1
		lea	(RAM_start).l,a1
		locVRAM	$E000,d0
		bra.w	Copy_Map_Line_To_VRAM_Full
; ---------------------------------------------------------------------------





























InsertCoinScreen_Process_Control:
















		rts

; =============== S U B R O U T I N E =======================================

	; set the character
		CHARSET ' ', $37
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

InsertCoin_ICText:	dc.b "              INSERT COIN               ",-1
InsertCoin_PSBText:	dc.b "           PRESS START BUTTON           ",-1
InsertCoin_Blank:		dc.b "                                        ",-1

InsertCoin_MainText:
		dc.b "SONIC EPILOGUE: ARCADE DEMO 2021                                ",$98
		dc.b " SEGA @1994              HARDLINE @2021 ",-1
	even

		CHARSET ; reset character set
