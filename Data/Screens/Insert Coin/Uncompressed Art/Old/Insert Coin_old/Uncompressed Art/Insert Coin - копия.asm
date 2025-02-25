; ---------------------------------------------------------------------------
; Insert Coin Screen
; ---------------------------------------------------------------------------

vInsertCoin_Buffer:			= $FFFF2000		; $800 bytes
vInsertCoin_FactorBuffer:		= $FFFF2800			; $800 bytes
vInsertCoin_Buffer2:			= $FFFF3000			; $800 bytes
vInsertCoin_FactorBuffer2:		= $FFFF3800			; $800 bytes

; RAM
vInsertCoin_Timer:			= Object_load_addr_front		; word
vInsertCoin_TextFactor:		= Object_load_addr_front+2	; byte
vInsertCoin_End:				= Object_load_addr_front+3	; byte
vInsertCoin_TextChg:			= Object_load_addr_front+4	; byte
vInsertCoin_TextIndex:		= Object_load_addr_front+5	; byte

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
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM Oscillating_variables, Oscillating_variables_End
		ResetDMAQueue
		lea	PLC_InsertCoin(pc),a6
		jsr	(LoadPLC_Raw_KosM).w



		lea	(Title_Layout).l,a0
		jsr	(Load_Level2).w
		lea	(Title_128x128_Kos).l,a0
		lea	(RAM_start).l,a1
		jsr	(Kos_Decomp).w
		move.l	#Title_16x16_Unc,(Block_table_addr_ROM).w






		lea	(Pal_InsertCoin).l,a1
		lea	(Target_palette_line_1).w,a2
		moveq	#(64/2)-1,d0
		jsr	(PalLoad_Line.loop).w

		music	bgm_SSZ,0,0,0












		move.l	#Obj_Emerald_InsertCoinScreen,(Object_RAM).w




;		move.w	#1520,(Camera_Y_pos).w
;		move.w	#1520,(Camera_Y_pos_copy).w


		move.w	#$700,(Camera_Y_pos_BG_copy).w



		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#2*60,(vInsertCoin_Timer).w





		bsr.w	InsertCoinScreen_LevelSetup








		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		bsr.w	InsertCoinScreen_Process
		jsr	(Process_Sprites).w
		jsr	(Process_Nem_Queue_Init).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

InsertCoin_Loop:
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		bsr.w	InsertCoinScreen_Process



		jsr	(Process_Sprites).w
		jsr	(Process_Nem_Queue_Init).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		tst.b	(vInsertCoin_End).w
		beq.s	InsertCoin_Loop

InsertCoin_PressStart:
		disableInts
		stopZ80
		dmaFillVRAM 0,$2000,$4000
		dmaFillVRAM 0,$C000,$1000
		startZ80
		enableInts
		clr.l	(Object_load_addr_front).w
		clr.l	(Object_load_addr_front+4).w
		clr.l	(Object_load_addr_front+8).w
		clr.l	(Object_load_addr_front+$C).w
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
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		jsr	(Process_Sprites).w
		jsr	(Process_Nem_Queue_Init).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		bra.w	Options_Loop

; =============== S U B R O U T I N E =======================================

InsertCoinScreen_LevelSetup:
		move.w	#$FFF,(Screen_Y_wrap_value).w
		move.w	#$FF0,(Camera_Y_pos_mask).w
		move.w	#$7C,(Layout_row_index_mask).w
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		lea	(Plane_buffer).w,a0
		movea.l	(Block_table_addr_ROM).w,a2
		movea.l	(Level_layout2_addr_ROM).w,a3
		move.w	#vram_fg,d7
		bsr.s	InsertCoinScreen_ScreenInit
		addq.w	#2,a3
		move.w	#vram_bg,d7
		bsr.s	InsertCoinScreen_BackgroundInit
		move.w	(Camera_Y_pos_copy).w,(V_scroll_value).w
		move.w	(Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_ScreenEvents:
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		lea	(Plane_buffer).w,a0
		movea.l	(Block_table_addr_ROM).w,a2
		movea.l	(Level_layout2_addr_ROM).w,a3
		move.w	#vram_fg,d7
		bsr.s	InsertCoinScreen_ScreenEvent
		addq.w	#2,a3
		move.w	#vram_bg,d7
		bsr.s	InsertCoinScreen_BackgroundEvent
		move.w	(Camera_Y_pos_copy).w,(V_scroll_value).w
		move.w	(Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_ScreenInit:
		jsr	(Reset_TileOffsetPositionActual).w
		jmp	(Refresh_PlaneFull).w
; ---------------------------------------------------------------------------

InsertCoinScreen_ScreenEvent:
		move.w	(Screen_shaking_flag+2).w,d0
		add.w	d0,(Camera_Y_pos_copy).w
		rts

;		jmp	(DrawTilesAsYouMove).w
; ---------------------------------------------------------------------------

InsertCoinScreen_BackgroundInit:
		bsr.w	Title_Deform
		jsr	(Reset_TileOffsetPositionEff).w
		moveq	#0,d1	; Set XCam BG pos
		jsr	(Refresh_PlaneFull).w
		jmp	(ShakeScreen_Setup).w
; ---------------------------------------------------------------------------

InsertCoinScreen_BackgroundEvent:
		bsr.w	Title_Deform
		jsr	(Draw_BG2).w
		jmp	(ShakeScreen_Setup).w

; =============== S U B R O U T I N E =======================================

InsertCoinScreen_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	InsertCoinScreen_Process_Index(pc,d0.w),d0
		jmp	InsertCoinScreen_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_Index: offsetTable
		offsetTableEntry.w InsertCoinScreen_Process_StopBG						; 0
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp_IntroWaitText		; 2
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp_IntroSetLoadText		; 4
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp_IntroDrawText		; 6
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp_IntroHideText		; 8
		offsetTableEntry.w InsertCoinScreen_Process_CheckScroll					; A
		offsetTableEntry.w InsertCoinScreen_Process_Wait_Return					; C







		offsetTableEntry.w InsertCoinScreen_Process_InitFG
		offsetTableEntry.w InsertCoinScreen_Process_LoadFG		; 4
		offsetTableEntry.w InsertCoinScreen_Process_LoadText		; 6
		offsetTableEntry.w InsertCoinScreen_Process_DrawPSB		; 8
		offsetTableEntry.w InsertCoinScreen_Process_HidePSB		; A


		offsetTableEntry.w InsertCoinScreen_Process_HideText		; A

		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp		; C
		offsetTableEntry.w InsertCoinScreen_Process_End			; E

		offsetTableEntry.w InsertCoinScreen_Process_Wait_Return		; 8
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_StopBG:
		subq.w	#8,(HScroll_Shift).w
		bpl.s	InsertCoinScreen_Process_Wait_Return
		clr.w	(HScroll_Shift).w
		addq.b	#2,(Object_load_routine).w

;		music	bgm_DEZ1,0,0,0
;		sfx	sfx_Teleport,0,0,0


InsertCoinScreen_Process_Wait_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_ScrollUp_IntroWaitText:
		bsr.w	InsertCoin_ScrollBG
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_ScrollUp_IntroWaitText_Return
		addq.b	#2,(Object_load_routine).w

InsertCoinScreen_Process_ScrollUp_IntroWaitText_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_ScrollUp_IntroSetLoadText:
		bsr.w	InsertCoin_ScrollBG
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#$3F,(vInsertCoin_Timer).w
		moveq	#0,d0
		lea	InsertCoin_IntroTextIndex(pc),a1
		move.b	(vInsertCoin_TextIndex).w,d0
		addq.b	#2,(vInsertCoin_TextIndex).w
		adda.w	(a1,d0.w),a1
		locVRAM	$C700,d1
		move.w	#$813F,d3
		jmp	(Load_PlaneText).w
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_ScrollUp_IntroDrawText:
		bsr.w	InsertCoin_ScrollBG
		tst.b	(vInsertCoin_TextFactor).w
		beq.s	InsertCoinScreen_Process_ScrollUp_IntroDrawText_Skip
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_ScrollUp_IntroDrawText_Skip_Return
		move.w	#1,(vInsertCoin_Timer).w
		lea	(vInsertCoin_Buffer).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothDrawArtText
		move.l	#vInsertCoin_Buffer,d1
		move.w	#tiles_to_bytes($140),d2	; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_ScrollUp_IntroDrawText_Skip:
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#$3F,(vInsertCoin_Timer).w

InsertCoinScreen_Process_ScrollUp_IntroDrawText_Skip_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_ScrollUp_IntroHideText:
		bsr.w	InsertCoin_ScrollBG
		tst.b	(vInsertCoin_TextFactor).w
		beq.s	InsertCoinScreen_Process_ScrollUp_IntroHideText_Skip
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_ScrollUp_IntroHideText_Return
		move.w	#1,(vInsertCoin_Timer).w
		lea	(vInsertCoin_Buffer).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothHideArtText
		move.l	#vInsertCoin_Buffer,d1
		move.w	#tiles_to_bytes($140),d2	; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_ScrollUp_IntroHideText_Skip:
		move.b	#4,(Object_load_routine).w
		cmpi.b	#(InsertCoin_IntroTextIndex_End-InsertCoin_IntroTextIndex),(vInsertCoin_TextIndex).w
		bne.s	InsertCoinScreen_Process_ScrollUp_IntroHideText_Return
		move.b	#$A,(Object_load_routine).w

InsertCoinScreen_Process_ScrollUp_IntroHideText_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_CheckScroll:
		bsr.w	InsertCoin_ScrollBG
		cmp.w	#$1BC,(Camera_Y_pos_BG_copy).w
		bhs.s	InsertCoinScreen_Process_CheckScroll_Return
		addq.b	#2,(Object_load_routine).w
		music	bgm_Stop,0,0,0
		jsr	(Create_New_Sprite).w
		bne.s	InsertCoinScreen_Process_CheckScroll_Return
		move.l	#Obj_Crane_InsertCoinScreen,address(a1)

InsertCoinScreen_Process_CheckScroll_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_InitFG:
		lea	(MapEni_InsertCoinFG).l,a0
		lea	(RAM_start+$4000).l,a1
		move.w	#$C1C0,d0
		jsr	(Eni_Decomp).w
		disableInts
		dmaFillVRAM 0,$C000,$1000
		lea	(RAM_start+$4000).l,a1
		copyTilemap	(vram_fg+$82), 320, 80
		enableInts
		clearRAM vInsertCoin_Buffer, $FFFF5000
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#7,(vInsertCoin_Timer).w

;		lea	(Pal_InsertCoin+$80).l,a1

		lea	(Pal_Options).l,a1
		jsr	(PalLoad_Line0).w

		lea	(Pal_InsertCoin+$A0).l,a1
		jmp	(PalLoad_Line2).w
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadFG:
		tst.b	(vInsertCoin_TextFactor).w
		beq.s	InsertCoinScreen_Process_LoadObj
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.w	InsertCoinScreen_Process_LoadFG_Return
		move.w	#1,(vInsertCoin_Timer).w
		lea	($FFFF2000).l,a1				; Mod Art
		lea	($FFFF4800).l,a2				; Tile factor
		bsr.w	InsertCoin_SmoothDrawArtText
		move.l	#$FFFF2000,d1
		move.w	#tiles_to_bytes($1C0),d2	; VRAM
		move.w	#(ArtUnc_InsertCoinFG_End-ArtUnc_InsertCoinFG)/2,d3		; Size/2
		jmp	(Add_To_DMA_Queue).w
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadObj:
		sfx	sfx_Flash,0,0,0
		music	bgm_Title,0,0,0
		move.l	#Obj_DeathEggMini_InsertCoinScreen,(Object_RAM).w



		lea	InsertCoin_MainText(pc),a1
		locVRAM	$CD00,d1
		move.w	#$813F,d3
		jsr	(Load_PlaneText).w

InsertCoinScreen_Process_LoadFG_Skip:
		clearRAM vInsertCoin_Buffer, $FFFF5000
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#7,(vInsertCoin_Timer).w

InsertCoinScreen_Process_LoadFG_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadText:
		tst.b	(vInsertCoin_TextFactor).w
		beq.s	InsertCoinScreen_Process_DrawPSB_Skip3
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_LoadFG_Return
		move.w	#1,(vInsertCoin_Timer).w
		lea	(vInsertCoin_Buffer).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothDrawArtText
		move.l	#vInsertCoin_Buffer,d1
		move.w	#tiles_to_bytes($140),d2	; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_DrawPSB_Skip3:
		sfx	sfx_Teleport,0,0,0
		bra.s	InsertCoinScreen_Process_DrawPSB_Skip
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_DrawPSB_Skip2:
		addq.b	#2,(Object_load_routine).w
		bra.s	InsertCoinScreen_Process_DrawPSB_Skip
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
		bmi.s	InsertCoinScreen_Process_DrawPSB_Skip2


		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_DrawPSB_Return
		move.w	#1,(vInsertCoin_Timer).w

		lea	(vInsertCoin_Buffer2).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer2).l,a2		; Tile factor
		bsr.w	SmoothDrawArtText
		move.l	#vInsertCoin_Buffer2,d1
		move.w	#tiles_to_bytes($180),d2	; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_HidePSB:
		tst.b	(Ctrl_1_pressed).w
		bmi.w	InsertCoinScreen_Process_DrawPSB_Skip

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
		locVRAM	$C980,d1
		move.w	#$817F,d3
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
		bsr.w	SmoothHideArtText
		move.l	#vInsertCoin_Buffer2,d1
		move.w	#tiles_to_bytes($180),d2	; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_HideText:
		tst.b	(vInsertCoin_TextFactor).w
		bne.s	InsertCoinScreen_Process_HideText_Wait

		sfx	sfx_Flash,0,0,0
		music	bgm_Fade,0,0,0


;		move.w	(Camera_Y_pos_BG_copy).w,d0
;		addi.w	#80,d0
;		move.w	d0,(Camera_Y_pos).w


		bra.w	InsertCoinScreen_Process_LoadFG_Skip
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_HideText_Wait:
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_HidePSB_Return
		move.w	#1,(vInsertCoin_Timer).w


		move.b	(vInsertCoin_TextFactor).w,-(sp)

		lea	(vInsertCoin_Buffer).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothHideArtText
		move.l	#vInsertCoin_Buffer,d1
		move.w	#tiles_to_bytes($140),d2		; VRAM
		bsr.w	SmoothLoadArtText

		move.b	(sp)+,(vInsertCoin_TextFactor).w

		lea	(vInsertCoin_Buffer2).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer2).l,a2		; Tile factor
		bsr.w	SmoothHideArtText
		move.l	#vInsertCoin_Buffer2,d1
		move.w	#tiles_to_bytes($180),d2		; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_ScrollUp:
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_LoadTiles
		move.w	#1,(vInsertCoin_Timer).w

		subq.w	#1,(Camera_Y_pos).w
		subq.w	#1,(Camera_Y_pos_BG_copy).w
		bne.s	InsertCoinScreen_Process_LoadTiles
		addq.b	#2,(Object_load_routine).w
		clr.w	(Camera_Y_pos).w
		rts

;		lea	(Object_RAM).w,a1
;		jmp	(Delete_Referenced_Sprite).w
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadTiles:
		move.w	(Camera_Y_pos).w,d1
		locVRAM	$C000,d0
		bra.w	InsertCoin_Clear_Map_Line_To_VRAM
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_End:
		st	(vInsertCoin_End).w
		rts




; =============== S U B R O U T I N E =======================================

InsertCoin_ScrollBG:
		tst.w	(Camera_Y_pos_BG_copy).w
		beq.s	InsertCoin_ScrollBG_Return
		btst	#0,(Level_frame_counter+1).w
		beq.s	InsertCoin_ScrollBG_Return
		subq.w	#1,(Camera_Y_pos_BG_copy).w

InsertCoin_ScrollBG_Return:
		rts

; =============== S U B R O U T I N E =======================================

InsertCoin_Clear_Map_Line_To_VRAM:
		subi.w	#16,d1
		bcs.s	InsertCoin_Copy_Map_Line_To_VRAM_Return
		move.w	d1,d3
		andi.w	#7,d3
		bne.s	InsertCoin_Copy_Map_Line_To_VRAM_Return
		andi.w	#$F8,d1
		move.w	d1,d2
		lsl.w	#4,d2
		swap	d0
		add.w	d2,d0
		swap	d0
		moveq	#512/8-1,d3
		disableInts
		lea	(VDP_data_port).l,a6
		move.l	d0,VDP_control_port-VDP_data_port(a6)

-		move.w	#0,VDP_data_port-VDP_data_port(a6)
		dbf	d3,-
		enableInts

InsertCoin_Copy_Map_Line_To_VRAM_Return:
		rts

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

Obj_Emerald_InsertCoinScreen:
		move.l	#Map_SSZDeathEggSmall,mappings(a0)
		move.w	#$C0DC,art_tile(a0)
		move.w	#$200,priority(a0)
		move.w	#$120,x_pos(a0)
		move.w	#$C4,y_pos(a0)
		addq.b	#1,mapping_frame(a0)
		move.w	#1*60,$2E(a0)
		move.l	#Emerald_InsertCoinScreen_Wait,address(a0)

Emerald_InsertCoinScreen_Wait:
		cmpi.w	#$200,(Camera_Y_pos_BG_copy).w
		bhs.s	Emerald_InsertCoinScreen_Draw
		sfx	sfx_Squeak,0,0,0
		move.l	#Emerald_InsertCoinScreen_Move,address(a0)

Emerald_InsertCoinScreen_Move:
		move.w	(Camera_Y_pos_BG_copy).w,d0
		neg.w	d0
		addi.w	#$C4,d0
		move.w	d0,y_pos(a0)

Emerald_InsertCoinScreen_Draw:
		lea	off_7DD5A(pc),a1
		lea	(Normal_palette_line_3+$1C).w,a2
		jsr	(Run_PalRotationScript2).w
		bra.w	DeathEggMini_InsertCoinScreen_Draw
; ---------------------------------------------------------------------------

off_7DD5A:
		dc.l off_7DD7A
		dc.w 1
		dc.b 0
		dc.b $F
		dc.w $109
		dc.w $209
		dc.w $307
		dc.w $407
		dc.w $505
		dc.w $605
		dc.w $505
		dc.w $407
		dc.w $307
		dc.w $209
		dc.w $109
		dc.w $FFFC
off_7DD7A: offsetTable
		offsetTableEntry.w word_7DD88
		offsetTableEntry.w word_7DD8C
		offsetTableEntry.w word_7DD90
		offsetTableEntry.w word_7DD94
		offsetTableEntry.w word_7DD98
		offsetTableEntry.w word_7DD9C
		offsetTableEntry.w word_7DDA0
word_7DD88:
		dc.w $480
		dc.w $6A0
word_7DD8C:
		dc.w $680
		dc.w $8A0
word_7DD90:
		dc.w $680
		dc.w $8C0
word_7DD94:
		dc.w $6A0
		dc.w $AC0
word_7DD98:
		dc.w $8A0
		dc.w $AE0
word_7DD9C:
		dc.w $8C0
		dc.w $CE0
word_7DDA0:
		dc.w $AC0
		dc.w $EE0

; =============== S U B R O U T I N E =======================================

Obj_Crane_InsertCoinScreen:
		move.l	#Map_SSZRobotnikShipCrane,mappings(a0)
		move.w	#$A113,art_tile(a0)
		move.w	#$180,priority(a0)
		move.w	#$120,x_pos(a0)
		move.w	#$40,y_pos(a0)
		move.b	#32/2,width_pixels(a0)
		move.b	#32/2,height_pixels(a0)
		move.w	#$F,$2E(a0)
		move.l	#Crane_InsertCoinScreen_Wait,address(a0)

Crane_InsertCoinScreen_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	Crane_InsertCoinScreen_Draw
		sfx	sfx_Arm,0,0,0
		move.l	#Crane_InsertCoinScreen_Down,address(a0)
		lea	Crane_InsertCoinScreen_ObjData(pc),a2
		moveq	#2-1,d6

-		jsr	(Create_New_Sprite3).w
		bne.s	Crane_InsertCoinScreen_Wait
		move.l	(a2)+,address(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.w	a0,parent3(a1)
		dbf	d6,-

Crane_InsertCoinScreen_Down:
		addq.w	#4,y_pos(a0)
		addq.b	#4,child_dy(a0)
		cmpi.b	#176,child_dy(a0)
		blo.s		Crane_InsertCoinScreen_Draw
		addq.b	#2,mapping_frame(a0)
		sfx	sfx_Bumper2,0,0,0
		move.l	#Crane_InsertCoinScreen_Up,address(a0)

Crane_InsertCoinScreen_Up:
		lea	(Object_RAM).w,a1
		move.w	y_pos(a0),d0
		addi.w	#17,d0
		move.w	d0,y_pos(a1)
		subq.w	#4,y_pos(a0)
		subq.b	#4,child_dy(a0)
		bhs.s	Crane_InsertCoinScreen_Draw
		clr.b	child_dy(a0)
		addq.b	#2,(Object_load_routine).w
		move.l	#Go_Delete_Sprite,address(a0)
		lea	(Object_RAM).w,a1
		jmp	(Delete_Referenced_Sprite).w
; ---------------------------------------------------------------------------

Crane_InsertCoinScreen_Draw:
		bra.w	DeathEggMini_InsertCoinScreen_Draw
; ---------------------------------------------------------------------------

Crane_InsertCoinScreen_ObjData:
		dc.l Obj_Crane2_InsertCoinScreen
		dc.l Obj_Chain_InsertCoinScreen

; =============== S U B R O U T I N E =======================================

Obj_Crane2_InsertCoinScreen:
		move.w	#$280,priority(a0)
		move.b	#32/2,width_pixels(a0)
		move.b	#32/2,height_pixels(a0)
		move.l	#Crane2_InsertCoinScreen_Main,address(a0)

Crane2_InsertCoinScreen_Main:
		jsr	(Refresh_ChildPosition).w
		move.b	mapping_frame(a1),d0
		addq.b	#1,d0
		move.b	d0,mapping_frame(a0)
		jmp	(Child_Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_Chain_InsertCoinScreen:
		move.w	#$300,priority(a0)
		move.b	#8/2,width_pixels(a0)
		move.b	#80/2,height_pixels(a0)
		move.b	#4,mapping_frame(a0)
		move.b	#-48,child_dy(a0)
		move.l	#Chain_InsertCoinScreen_Down,address(a0)

Chain_InsertCoinScreen_Down:
		movea.w	parent3(a0),a1
		move.b	child_dy(a1),d0
		andi.w	#$F,d0
		bne.s	Chain_InsertCoinScreen_Draw
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#$C,mapping_frame(a0)
		bne.s	Chain_InsertCoinScreen_Draw
		move.l	#Chain_InsertCoinScreen_Up,address(a0)
		bra.s	Chain_InsertCoinScreen_Draw
; ---------------------------------------------------------------------------

Chain_InsertCoinScreen_Up:
		movea.w	parent3(a0),a1
		move.b	child_dy(a1),d0
		andi.w	#$F,d0
		bne.s	Chain_InsertCoinScreen_Draw
		subq.b	#1,mapping_frame(a0)
		cmpi.b	#4,mapping_frame(a0)
		bne.s	Chain_InsertCoinScreen_Draw
		move.l	#Chain_InsertCoinScreen_Draw,address(a0)

Chain_InsertCoinScreen_Draw:
		jsr	(Refresh_ChildPosition).w
		jmp	(Child_Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_DeathEggMini_InsertCoinScreen:
		move.l	#Map_SSZDeathEggSmall,mappings(a0)
		move.w	#$6E,art_tile(a0)
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

;		sfx	sfx_Flash,0,0,0

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
		cmpi.w	#$1A0,d0
		bhs.s	DeathEggMini_InsertCoinScreen_Remove

DeathEggMini_InsertCoinScreen_Draw:
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

DeathEggMini_InsertCoinScreen_Remove:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

Pal_DeathEggMini_InsertCoinScreen:
		dc.w $200, 0, 0
		dc.w $422, $200, 0
		dc.w $644, $422, $200
; ---------------------------------------------------------------------------

PLC_InsertCoin:
		dc.w ((PLC_InsertCoin_End-PLC_InsertCoin)/6)-1
		plreq 0, Title_8x8_KosM
		plreq $6E, ArtKosM_TitleDeathEggSmall
PLC_InsertCoin_End

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

InsertCoin_IntroTextIndex: offsetTable
		offsetTableEntry.w InsertCoin_IntroText1		; 0
		offsetTableEntry.w InsertCoin_IntroText2		; 2
		offsetTableEntry.w InsertCoin_IntroText3		; 4
		offsetTableEntry.w InsertCoin_IntroText4		; 6
		offsetTableEntry.w InsertCoin_IntroText5		; 8
		offsetTableEntry.w InsertCoin_IntroText6		; A
		offsetTableEntry.w InsertCoin_IntroText7		; C
		offsetTableEntry.w InsertCoin_IntroText8		; E
InsertCoin_IntroTextIndex_End



InsertCoin_IntroText1:		dc.b "  SONIC 3 & KNUCKLES: EPILOGUE (2021)   ",-1

InsertCoin_IntroText2:		dc.b "         PRESENT FROM HARDLINE          ",-1

InsertCoin_IntroText3:		dc.b "           HACK BY THEBLAD768           ",-1

InsertCoin_IntroText4:		dc.b "        MAIN ART BY MRCAT-PIXEL         ",-1

InsertCoin_IntroText5:		dc.b "         MAIN MUSIC BY FOXCONED         ",-1

InsertCoin_IntroText6:		dc.b "    ADDITIONAL MUSIC BY MR. JOKER 27    ",-1

InsertCoin_IntroText7:		dc.b "            SPECIAL FOR THE             ",$81
						dc.b "       SONIC HACKING CONTEST 2021       ",-1

InsertCoin_IntroText8:		dc.b "    THANK YOU FOR STARTING THE GAME!    ",$81
						dc.b "                                        ",-1

















InsertCoin_ICText:		dc.b "              INSERT COIN               ",-1
InsertCoin_PSBText:		dc.b "           PRESS START BUTTON           ",-1
InsertCoin_MainText:		dc.b " SEGA @1994              HARDLINE @2021 ",-1
	even

		CHARSET ; reset character set
