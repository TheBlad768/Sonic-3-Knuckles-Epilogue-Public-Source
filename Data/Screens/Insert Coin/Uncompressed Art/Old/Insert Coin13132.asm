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
		locVRAM	$6000
		lea	(ArtNem_TitleDeathEggSmall).l,a0
		jsr	(Nem_Decomp).w


;		locVRAM	$6E00
;		lea	(ArtNem_InsertCoinFG).l,a0
;		jsr	(Nem_Decomp).w

		lea	(MapEni_InsertCoinFG).l,a0
		lea	(RAM_start).l,a1
		move.w	#$C370,d0
		jsr	(Eni_Decomp).w
		copyTilemap	(vram_fg+$82), 320, 80






		lea	(MapEni_TitleBG).l,a0
		lea	(RAM_start).l,a1
		move.w	#$E080,d0
		jsr	(Eni_Decomp).w
		lea	(RAM_start+$600).l,a1
		copyTilemap	vram_bg, 512, 256
		lea	(Pal_Options).l,a1
		lea	(Target_palette_line_1).w,a2
		moveq	#(64/2)-1,d0
		jsr	(PalLoad_Line.loop).w
		lea	(Pal_InsertCoin).l,a1
		lea	(Target_palette_line_3).w,a2
		moveq	#(16/2)-1,d0
		jsr	(PalLoad_Line.loop).w




		lea	InsertCoin_MainText2(pc),a1
		locVRAM	$CD00,d1
		move.w	#$A03C,d3
		jsr	(Load_PlaneText).w






		move.w	#$120,(V_scroll_value+2).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#2*60,(Demo_timer).w
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.w	Title_Deform
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
		offsetTableEntry.w InsertCoinScreen_Process_LoadObj		; 4
		offsetTableEntry.w InsertCoinScreen_Process_Wait		; 6




		offsetTableEntry.w InsertCoinScreen_Process_LoadFG		; 4
		offsetTableEntry.w InsertCoinScreen_Process_LoadText		; 6
		offsetTableEntry.w InsertCoinScreen_Process_DrawPSB		; 8
		offsetTableEntry.w InsertCoinScreen_Process_HidePSB		; A
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp		; C
		offsetTableEntry.w InsertCoinScreen_Process_End			; E

		offsetTableEntry.w InsertCoinScreen_Process_Wait_Return		; 8
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

InsertCoinScreen_Process_LoadObj:
		move.l	#Obj_DeathEggMini_InsertCoinScreen,(Object_RAM).w
		move.w	#3*60,(Demo_timer).w
		bra.s	InsertCoinScreen_Process_LoadText_End
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadFG:
		tst.b	(vInsertCoin_TextFactor).w
		beq.s	InsertCoinScreen_Process_LoadFG_Skip
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_Wait_Return
		move.w	#1,(vInsertCoin_Timer).w


		lea	($FFFF2000).l,a1				; Mod Art
		lea	($FFFF4800).l,a2				; Tile factor
		bsr.w	InsertCoin_SmoothDrawArtText
		move.l	#$FFFF2000,d1
		move.w	#tiles_to_bytes($370),d2	; VRAM
		move.w	#(ArtUnc_InsertCoinFG_End-ArtUnc_InsertCoinFG)/2,d3		; Size/2
		jmp	(Add_To_DMA_Queue).w
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadFG_Skip2:
		addq.b	#2,(Object_load_routine).w

InsertCoinScreen_Process_LoadFG_Skip:
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#7,(vInsertCoin_Timer).w


		clearRAM vInsertCoin_Buffer, $FFFF5000
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadText:
		tst.b	(vInsertCoin_TextFactor).w
		beq.s	InsertCoinScreen_Process_DrawPSB_Skip
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_DrawPSB_Return
		move.w	#1,(vInsertCoin_Timer).w
		lea	(vInsertCoin_Buffer).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothDrawArtText
		move.l	#vInsertCoin_Buffer,d1
		move.w	#tiles_to_bytes($3D),d2	; VRAM
		bra.w	SmoothLoadArtText
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
		tst.b	(Ctrl_1_pressed).w
		bmi.s	InsertCoinScreen_Process_LoadFG_Skip2


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
		tst.b	(Ctrl_1_pressed).w
		bmi.w	InsertCoinScreen_Process_LoadFG_Skip

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

		move.w	#$A23F,d3
		locVRAM	$CA80,d1
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

		subq.w	#1,(V_scroll_value).w
		subq.w	#1,(V_scroll_value+2).w
		bne.s	InsertCoinScreen_Process_LoadTiles
		addq.b	#2,(Object_load_routine).w
		clr.w	(V_scroll_value).w
		lea	(Object_RAM).w,a1
		jmp	(Delete_Referenced_Sprite).w
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadTiles:
		move.w	(V_scroll_value).w,d1
		locVRAM	$C000,d0
		bsr.w	InsertCoin_Copy_Map_Line_To_VRAM
		move.w	(V_scroll_value+2).w,d1
		lea	(RAM_start).l,a1
		locVRAM	$E000,d0
		bra.w	Copy_Map_Line_To_VRAM_Full
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_End:
		st	(vInsertCoin_End).w
		rts

; =============== S U B R O U T I N E =======================================

InsertCoin_Copy_Map_Line_To_VRAM:
		subi.w	#16,d1
		bcs.s	+
		move.w	d1,d3
		andi.w	#7,d3
		bne.s	+
		andi.w	#$F8,d1
		move.w	d1,d2


		lsl.w	#4,d2
		swap	d0
		add.w	d2,d0
		swap	d0

		moveq	#320/8-1,d3
		disableInts
		lea	(VDP_data_port).l,a6
		move.l	d0,VDP_control_port-VDP_data_port(a6)

-		move.w	#0,VDP_data_port-VDP_data_port(a6)
		dbf	d3,-
		enableInts
+		rts

; =============== S U B R O U T I N E =======================================

InsertCoin_SmoothDrawArtText:
		lea	(ArtUnc_InsertCoinFG).l,a0
		move.w	#((ArtUnc_InsertCoinFG_End-ArtUnc_InsertCoinFG)/$20)-1,d7		; Art size

.loc_CDC6:
		moveq	#7,d6			; Tile size
		move.w	(a2),d5
		move.w	d5,d0
		addq.w	#1,d0
		cmpi.w	#6,d0
		blo.s		.skip
		moveq	#5,d0

.skip:
		move.w	d0,(a2)+
		bra.s	.loc_CDDE
; ---------------------------------------------------------------------------

.loc_CDDA:
		move.w	(a2),d5
		move.w	d4,(a2)+

.loc_CDDE:
		move.w	d5,d4
		add.w	d5,d5
		add.w	d5,d5
		move.l	(a0)+,d0
		move.l	dword_CDFA1(pc,d5.w),d2
		and.l	d2,d0
		move.l	d0,(a1)+
		dbf	d6,.loc_CDDA
		dbf	d7,.loc_CDC6
		subq.b	#1,(vInsertCoin_TextFactor).w
		rts
; ---------------------------------------------------------------------------

dword_CDFA1:
		dc.l 0				; 0
		dc.l $000F0000		; 1
		dc.l $000FF000		; 2
		dc.l $00FFFF00		; 3
		dc.l $0FFFFFF0		; 4
		dc.l $FFFFFFFF		; 5





		dc.l 0				; 0
		dc.l $FF000			; 1
		dc.l $FFFF00			; 2
		dc.l $FFFFFF0		; 3
		dc.l $FFFFFFFF		; 4




		dc.l 0			; 0
		dc.l $F0000000	; 1
		dc.l $FF000000	; 2
		dc.l $FFF00000	; 3
		dc.l $FFFF0000	; 4
		dc.l $FFFFF000	; 5
		dc.l $FFFFFF00	; 6
		dc.l $FFFFFFF0	; 7
		dc.l $FFFFFFFF	; 8


; =============== S U B R O U T I N E =======================================

Obj_DeathEggMini_InsertCoinScreen:
		move.l	#Map_SSZDeathEggSmall,mappings(a0)
		move.w	#$300,art_tile(a0)
		move.w	#$280,priority(a0)
		move.w	#$168,x_pos(a0)
		move.w	#$F8,y_pos(a0)
		move.w	y_pos(a0),$32(a0)
		move.w	#1*60,$2E(a0)
		move.l	#DeathEggMini_InsertCoinScreen_Wait,address(a0)

DeathEggMini_InsertCoinScreen_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	DeathEggMini_InsertCoinScreen_Move
		move.w	#7,$2E(a0)
		moveq	#0,d0
		move.b	$30(a0),d0
		addq.b	#6,$30(a0)
		lea	(Normal_palette_line_1+2).w,a2
		lea	Pal_DeathEggMini_InsertCoinScreen(pc,d0.w),a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		cmpi.b	#3*6,$30(a0)
		bne.s	DeathEggMini_InsertCoinScreen_Move
		move.l	#DeathEggMini_InsertCoinScreen_Move,address(a0)

DeathEggMini_InsertCoinScreen_Move:
		move.b	angle(a0),d0
		addq.b	#1,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#6,d0
		move.w	(V_scroll_value).w,d1
		neg.w	d1
		add.w	d1,d0
		add.w	$32(a0),d0
		move.w	d0,y_pos(a0)

DeathEggMini_InsertCoinScreen_Draw:
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Pal_DeathEggMini_InsertCoinScreen:
		dc.w $200, 0, 0
		dc.w $422, $200, 0
		dc.w $644, $422, $200

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
		dc.b "SONIC EPILOGUE: ARCADE DEMO 2021                                ",-1
InsertCoin_MainText2:
		dc.b " SEGA @1994              HARDLINE @2021 ",-1
	even

		CHARSET ; reset character set
