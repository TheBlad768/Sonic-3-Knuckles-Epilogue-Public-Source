; ---------------------------------------------------------------------------
; Insert Coin Screen
; ---------------------------------------------------------------------------

vInsertCoin_Buffer:			= $FFFF2000		; $800 bytes
vInsertCoin_FactorBuffer:		= $FFFF2800			; $800 bytes
vInsertCoin_Buffer2:			= $FFFF3000			; $800 bytes
vInsertCoin_FactorBuffer2:		= $FFFF3800			; $800 bytes
vInsertCoin_Buffer_End:		= $FFFF5000

; RAM
vInsertCoin_Timer:			= Object_load_addr_front		; word
vInsertCoin_TextFactor:		= Object_load_addr_front+2	; byte
vInsertCoin_TextChg:			= Object_load_addr_front+3	; byte
vInsertCoin_End:				= Object_load_addr_front+4	; byte
vInsertCoin_TextIndex:		= Object_load_addr_front+5	; byte
vInsertCoin_NoScrollFG:		= Object_load_addr_front+$E	; byte
vInsertCoin_Cheat:			= Object_load_addr_front+$F	; byte
vInsertCoin_Wait:				= Object_load_addr_front+$10	; byte
vInsertCoin_TextFactor2:		= Object_load_addr_front+$11	; byte

; =============== S U B R O U T I N E =======================================

InsertCoin_Screen:
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
		clr.b	(Timer_flag).w
		clr.b	(Intro_flag).w
		clr.w	(Water_full_screen_flag).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM Oscillating_variables, Oscillating_variables_End
		ResetDMAQueue
		lea	PLC_InsertCoin(pc),a6
		jsr	(LoadPLC_Raw_KosM).w
		lea	PLC_Main2(pc),a6
		jsr	(LoadPLC_Raw_KosM).w
		lea	(Title_Layout).l,a0
		jsr	(Load_Level2).w
		lea	(Title_128x128_Kos).l,a0
		lea	(RAM_start).l,a1
		jsr	(Kos_Decomp).w
		move.l	#Title_16x16_Unc,(Block_table_addr_ROM).w
		lea	(Pal_InsertCoin).l,a1
		lea	(Target_palette).w,a2
		jsr	(PalLoad_Line64).w

		move.w	#$10,(HScroll_Shift).w
		move.w	#$A80,(Camera_Y_pos_BG_copy).w
		bsr.w	InsertCoinScreen_LevelSetup

		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#$9F,(vInsertCoin_Timer).w

		move.l	#Obj_Prologue_Shadow,(Object_RAM).w
		move.w	#$E000,(Object_RAM+art_tile).w
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
		jsr	(Process_Sprites).w
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
		clr.l	(Object_load_addr_front+$10).w
		clr.b	(Object_load_routine).w
		lea	(RAM_start+$3000).l,a3
		move.w	#bytesToWcnt(2240),d1

-		clr.w	(a3)+
		dbf	d1,-
		disableInts
		bsr.w	Options_InitDraw
		enableInts
		lea	PLC_Sega(pc),a6
		jsr	(LoadPLC_Raw_KosM).w
		lea	(Pal_Options).l,a1
		lea	(Normal_palette).w,a2
		jsr	(PalLoad_Line64).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		bsr.w	HardLine_Deform_Screen1
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		st	(InsertCoin_Flag).w
		jsr	(SRAM_Save).l
		move.b	#id_OptionsScreen,(Game_mode).w
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
		tst.b	(vInsertCoin_NoScrollFG).w
		bne.s	InsertCoinScreen_LevelSetup_NoScrollFG
		move.w	(Camera_Y_pos_copy).w,(V_scroll_value).w

InsertCoinScreen_LevelSetup_NoScrollFG:
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
		tst.b	(vInsertCoin_NoScrollFG).w
		bne.s	InsertCoinScreen_ScreenEvents_NoScrollFG
		move.w	(Camera_Y_pos_copy).w,(V_scroll_value).w

InsertCoinScreen_ScreenEvents_NoScrollFG:
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
		offsetTableEntry.w InsertCoinScreen_Process_Startup_WaitLoadText				; 0
		offsetTableEntry.w InsertCoinScreen_Process_Startup_WaitLoadText2			; 2

		offsetTableEntry.w InsertCoinScreen_Process_Startup_DrawText					; 4
		offsetTableEntry.w InsertCoinScreen_Process_Startup_CheckScroll				; 6
		offsetTableEntry.w InsertCoinScreen_Process_Startup_HideText					; 8
		offsetTableEntry.w InsertCoinScreen_Process_Startup_WaitLoadText2			; A
		offsetTableEntry.w InsertCoinScreen_Process_Startup_ScrollUp					; C

		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp_IntroWaitText_Return		; E
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp_IntroWaitText			; 10
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp_IntroSetLoadText			; 12
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp_IntroDrawText			; 14
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp_IntroHideText			; 16
		offsetTableEntry.w InsertCoinScreen_Process_CheckScroll						; 18
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp_IntroWaitText_Return		; 1A
		offsetTableEntry.w InsertCoinScreen_Process_InitFG							; 1C
		offsetTableEntry.w InsertCoinScreen_Process_LoadFG							; 1E
		offsetTableEntry.w InsertCoinScreen_Process_WaitLoadText					; 20
		offsetTableEntry.w InsertCoinScreen_Process_LoadText							; 22
		offsetTableEntry.w InsertCoinScreen_Process_DrawPSB							; 24
		offsetTableEntry.w InsertCoinScreen_Process_HidePSB							; 26
		offsetTableEntry.w InsertCoinScreen_Process_HideText							; 28
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp							; 2A
		offsetTableEntry.w InsertCoinScreen_Process_End								; 2C
		offsetTableEntry.w InsertCoinScreen_Process_ScrollUp_IntroWaitText_Return		; 2E
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_Startup_WaitLoadText:
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_Startup_LoadText_Return
		addq.b	#2,(Object_load_routine).w
		move.w	#$4F,(vInsertCoin_Timer).w
		music	bgm_TitleStartup,0,0,0
		lea	(Pal_InsertCoin+$A0).l,a1
		jmp	(PalLoad_Line2).w
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_Startup_WaitLoadText2:
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_Startup_LoadText_Return
		addq.b	#2,(Object_load_routine).w

InsertCoinScreen_Process_Startup_LoadText_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_Startup_DrawText:
		cmpi.w	#32,(Camera_Y_pos).w
		blo.s		InsertCoinScreen_Process_Startup_CheckScroll
		tst.b	(vInsertCoin_TextFactor).w
		beq.s	InsertCoinScreen_Process_Startup_DrawText_Skip
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_Startup_CheckScroll
		move.w	#1,(vInsertCoin_Timer).w
		lea	(vInsertCoin_Buffer).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothDrawArtText
		move.l	#vInsertCoin_Buffer>>1,d1
		move.w	#tiles_to_bytes($300),d2		; VRAM
		bsr.w	SmoothLoadArtText
		bra.s	InsertCoinScreen_Process_Startup_CheckScroll
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_Startup_DrawText_Skip:
		addq.b	#2,(Object_load_routine).w

InsertCoinScreen_Process_Startup_CheckScroll:
		tst.b	(vInsertCoin_Wait).w
		beq.s	InsertCoinScreen_Process_NoSkipScroll
		tst.b	(Ctrl_1_pressed).w
		bmi.s	InsertCoinScreen_Process_SkipScroll

InsertCoinScreen_Process_NoSkipScroll:
		cmpi.w	#60,(Camera_Y_pos).w
		bne.s	InsertCoinScreen_Process_ToScroll
		st	(vInsertCoin_Wait).w

InsertCoinScreen_Process_ToScroll:
		cmpi.w	#974,(Camera_Y_pos).w
		blo.s		InsertCoinScreen_Process_Startup_Scroll

InsertCoinScreen_Process_SkipScroll:
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_Startup_Scroll:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#3,d0
		bne.s	+
		addq.w	#1,(Camera_Y_pos).w
+		move.w	(Camera_Y_pos).w,d1
		lea	InsertCoin_StartupTextIndex(pc),a1
		locVRAM	$C000,d3
		bra.w	Copy_Map_Line_To_VRAM_Prologue
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_Startup_HideText:
		tst.b	(vInsertCoin_TextFactor).w
		beq.s	InsertCoinScreen_Process_Startup_HideText_Skip
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_Startup_Scroll
		move.w	#1,(vInsertCoin_Timer).w
		lea	(vInsertCoin_Buffer).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothHideArtText
		move.l	#vInsertCoin_Buffer>>1,d1
		move.w	#tiles_to_bytes($300),d2		; VRAM
		bsr.w	SmoothLoadArtText
		bra.s	InsertCoinScreen_Process_Startup_Scroll
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_Startup_HideText_Skip:
		addq.b	#2,(Object_load_routine).w
;		music	bgm_Fade,0,0,0
		move.w	#$100,(Camera_Y_pos).w
		move.w	#$1F,(vInsertCoin_Timer).w
		lea	(Object_RAM).w,a1
		jsr	(Delete_Referenced_Sprite).w
		lea	PLC_InsertCoin2(pc),a6
		jsr	(LoadPLC_Raw_KosM).w
		disableInts
		stopZ80
		dmaFillVRAM 0,$C000,$1000
		startZ80
		enableInts

InsertCoinScreen_Process_Startup_HideText_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_Startup_ScrollUp:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#1,d0
		bne.s	+
		subq.w	#1,(Camera_Y_pos_BG_copy).w
+		move.w	#$950,d0
		cmp.w	(Camera_Y_pos_BG_copy).w,d0
		blo.s		InsertCoinScreen_Process_Startup_HideText_Return
		move.w	d0,(Camera_Y_pos_BG_copy).w
		addq.b	#2,(Object_load_routine).w
		move.l	#Obj_TailsPlane_InsertCoinScreen,(Object_RAM).w
		move.w	#$100,(HScroll_Shift).w
		st	(vInsertCoin_NoScrollFG).w
		lea	(Pal_InsertCoin+$40).l,a1
		jmp	(PalLoad_Line2).w
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
		move.w	#$5F,(vInsertCoin_Timer).w
		moveq	#0,d0
		lea	InsertCoin_IntroTextIndex(pc),a1
		move.b	(vInsertCoin_TextIndex).w,d0
		addq.b	#2,(vInsertCoin_TextIndex).w
		adda.w	(a1,d0.w),a1
		locVRAM	$C700,d1
		move.w	#$C2FF,d3
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
		move.l	#vInsertCoin_Buffer>>1,d1
		move.w	#tiles_to_bytes($300),d2		; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_ScrollUp_IntroDrawText_Skip:
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#$5F,(vInsertCoin_Timer).w

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
		move.l	#vInsertCoin_Buffer>>1,d1
		move.w	#tiles_to_bytes($300),d2		; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_ScrollUp_IntroHideText_Skip:
		move.b	#$12,(Object_load_routine).w
		cmpi.b	#(InsertCoin_IntroTextIndex_End-InsertCoin_IntroTextIndex),(vInsertCoin_TextIndex).w
		bne.s	InsertCoinScreen_Process_ScrollUp_IntroHideText_Return
		addq.b	#6,(Object_load_routine).w

InsertCoinScreen_Process_ScrollUp_IntroHideText_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_CheckScroll:
		bsr.w	InsertCoin_ScrollBG
		cmp.w	#$1BC,(Camera_Y_pos_BG_copy).w
		bhs.s	InsertCoinScreen_Process_CheckScroll_Return
		addq.b	#2,(Object_load_routine).w
		music	bgm_Fade,0,0,0
		jsr	(Create_New_Sprite).w
		bne.s	InsertCoinScreen_Process_CheckScroll_Return
		move.l	#Obj_Crane_InsertCoinScreen,address(a1)

InsertCoinScreen_Process_CheckScroll_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_InitFG:
		lea	(MapEni_InsertCoinFG).l,a0
		lea	(RAM_start+$4000).l,a1
		move.w	#$C380,d0
		jsr	(Eni_Decomp).w
		disableInts
		dmaFillVRAM 0,$8000,$1000
		dmaFillVRAM 0,$C000,$1000
		lea	(RAM_start+$4000).l,a1
		copyTilemap	(vram_fg+$280), 320, 96
		enableInts
		clearRAM vInsertCoin_Buffer, vInsertCoin_Buffer_End
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor2).w
		move.w	#7,(vInsertCoin_Timer).w
		lea	(Pal_Options).l,a1
		jsr	(PalLoad_Line0).w
		lea	(Pal_InsertCoin+$80).l,a1
		jmp	(PalLoad_Line2).w
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadFG:
		tst.b	(vInsertCoin_TextFactor2).w
		beq.s	InsertCoinScreen_Process_LoadObj
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.w	InsertCoinScreen_Process_LoadFG_Return
		move.w	#1,(vInsertCoin_Timer).w
		lea	(ArtUnc_InsertCoinFG).l,a1		; Original Art
		lea	(RAM_Start+$2000).l,a2		; Mod Art
		bsr.w	InsertCoin_SmoothDrawArtText
		move.l	#(RAM_Start+$2000)>>1,d1
		move.w	#tiles_to_bytes($380),d2	; VRAM
		move.w	#(ArtUnc_InsertCoinFG_End-ArtUnc_InsertCoinFG)/2,d3		; Size/2
		jmp	(Add_To_DMA_Queue).w
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadObj:
		sfx	sfx_Flash,0,0,0
		music	bgm_Title,0,0,0
		move.l	#Obj_DeathEggMini_InsertCoinScreen,(Object_RAM).w
		move.b	#$14,(vInsertCoin_TextFactor2).w
		lea	InsertCoin_MainText(pc),a1
		locVRAM	$CD00,d1
		move.w	#$82FF,d3
		jsr	(Load_PlaneText).w

InsertCoinScreen_Process_LoadFG_Skip:
		clearRAM vInsertCoin_Buffer, vInsertCoin_Buffer_End
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#7,(vInsertCoin_Timer).w

InsertCoinScreen_Process_LoadFG_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_WaitLoadText:
		tst.b	(vInsertCoin_TextFactor2).w
		bne.s	InsertCoinScreen_Process_WaitLoadText_Return
		addq.b	#2,(Object_load_routine).w
		clearRAM vInsertCoin_Buffer, vInsertCoin_Buffer_End

InsertCoinScreen_Process_WaitLoadText_Return:
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
		move.l	#vInsertCoin_Buffer>>1,d1
		move.w	#tiles_to_bytes($300),d2	; VRAM
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
		bsr.w	InsertCoinScreen_Code
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_DrawPSB_Return
		move.w	#1,(vInsertCoin_Timer).w
		lea	(vInsertCoin_Buffer2).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer2).l,a2		; Tile factor
		bsr.w	SmoothDrawArtText
		move.l	#vInsertCoin_Buffer2>>1,d1
		move.w	#tiles_to_bytes($340),d2	; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_HidePSB:
		tst.b	(Ctrl_1_pressed).w
		bmi.w	InsertCoinScreen_Process_DrawPSB_Skip
		bsr.w	InsertCoinScreen_Code
		tst.b	(vInsertCoin_TextFactor).w
		bne.s	InsertCoinScreen_Process_HidePSB_Wait
		subq.b	#2,(Object_load_routine).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		move.w	#7,(vInsertCoin_Timer).w
		lea	InsertCoin_PSBText(pc),a1
		bchg	#0,(vInsertCoin_TextChg).w
		bne.s	+
		lea	InsertCoin_ICText(pc),a1
+		locVRAM	$C980,d1
		move.w	#$833F,d3
		jmp	(Load_PlaneText).w
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_HidePSB_Wait:
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_DrawPSB_Return
		move.w	#1,(vInsertCoin_Timer).w
		lea	(vInsertCoin_Buffer2).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer2).l,a2		; Tile factor
		bsr.w	SmoothHideArtText
		move.l	#vInsertCoin_Buffer2>>1,d1
		move.w	#tiles_to_bytes($340),d2	; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_HideText:
		tst.b	(vInsertCoin_TextFactor).w
		bne.s	InsertCoinScreen_Process_HideText_Wait
;		sfx	sfx_Flash,0,0,0
		music	bgm_Fade,0,0,0
		clr.b	(vInsertCoin_NoScrollFG).w
		bra.w	InsertCoinScreen_Process_LoadFG_Skip
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_HideText_Wait:
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_ScrollUp_Return
		move.w	#1,(vInsertCoin_Timer).w
		move.b	(vInsertCoin_TextFactor).w,-(sp)
		lea	(vInsertCoin_Buffer).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothHideArtText
		move.l	#vInsertCoin_Buffer>>1,d1
		move.w	#tiles_to_bytes($300),d2		; VRAM
		bsr.w	SmoothLoadArtText
		move.b	(sp)+,(vInsertCoin_TextFactor).w
		lea	(vInsertCoin_Buffer2).l,a1			; Mod Art
		lea	(vInsertCoin_FactorBuffer2).l,a2		; Tile factor
		bsr.w	SmoothHideArtText
		move.l	#vInsertCoin_Buffer2>>1,d1
		move.w	#tiles_to_bytes($340),d2		; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_ScrollUp:
		subq.w	#1,(vInsertCoin_Timer).w
		bpl.s	InsertCoinScreen_Process_LoadTiles
		move.w	#1,(vInsertCoin_Timer).w
		subq.w	#1,(Camera_Y_pos).w
		subq.w	#1,(Camera_Y_pos_BG_copy).w
		bpl.s	InsertCoinScreen_Process_LoadTiles
		clr.w	(Camera_Y_pos_BG_copy).w
		clr.w	(Camera_Y_pos).w
		addq.b	#2,(Object_load_routine).w

InsertCoinScreen_Process_ScrollUp_Return:
		rts
; ---------------------------------------------------------------------------

InsertCoinScreen_Process_LoadTiles:
		move.w	(Camera_Y_pos).w,d1
		locVRAM	$C000,d0
		bra.s	InsertCoin_Clear_Map_Line_To_VRAM
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
		move.w	#((ArtUnc_InsertCoinFG_End-ArtUnc_InsertCoinFG)/$20)-1,d5		; Art size

InsertCoin_SmoothDrawArtText2:
		move.b	(vInsertCoin_TextFactor2).w,d2
		add.b	d2,d2
		andi.w	#$3E,d2

InsertCoin_SmoothDrawArtText3:
		lea	.factor(pc,d2.w),a3

-		movea.l	a3,a4
		moveq	#8-1,d6

-		move.l	(a1)+,d0
		and.l	(a4)+,d0
		or.l	d0,(a2)+
		dbf	d6,-
		dbf	d5,--
		subq.b	#1,(vInsertCoin_TextFactor2).w
		rts
; ---------------------------------------------------------------------------

.factor:
		dc.l $00F00000		; 0		; 0
		dc.l $0000000F		; 4		; 1
		dc.l $0000F000		; 8		; 2
		dc.l $0F000000		; $C		; 3
		dc.l $00000F00		; $10	; 4
		dc.l $000F0000		; $14	; 5
		dc.l $F0000000		; $18	; 6
		dc.l $000000F0		; $1C	; 7
		dc.l $00F00000		; $20	; 8
		dc.l $0000000F		; $24	; 9
		dc.l $0000F000		; $28	; $A
		dc.l $0F000000		; $2C	; $B
		dc.l $00000F00		; $30	; $C
		dc.l $000F0000		; $34	; $D
		dc.l $F0000000		; $38	; $E
		dc.l $000000F0		; $3C	; $F
		dc.l $00F00000		; $40	; $10
		dc.l $0000000F		; $44	; $11
; ---------------------------------------------------------------------------
; Атакующие снаряды (Процесс)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShotBall_InsertCoinScreen_Process:
		movea.w	parent3(a0),a1
		move.w	a0,$44(a1)
		move.l	#ShotBall_InsertCoinScreen_Process_Return,address(a0)

ShotBall_InsertCoinScreen_Process_Return:
		rts
; ---------------------------------------------------------------------------

ShotBall_InsertCoinScreen_Process_LoadDialog:
		subq.w	#1,$2E(a0)
		bpl.s	ShotBall_InsertCoinScreen_Process_WaitDialog
		sfx	sfx_Fade,0,0,0
		move.l	#ShotBall_InsertCoinScreen_Process_WaitDialog,address(a0)
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	ShotBall_InsertCoinScreen_Process_WaitDialog
		move.b	#_TitleStartup,routine(a1)
		move.l	#DialogTitleStartup_Process_Index-4,$34(a1)
		move.b	#(DialogTitleStartup_Process_Index_End-DialogTitleStartup_Process_Index)/8,$39(a1)

ShotBall_InsertCoinScreen_Process_WaitDialog:
		rts
; ---------------------------------------------------------------------------

ShotBall_InsertCoinScreen_Process_WaitBinoculars:
		subq.w	#1,$2E(a0)
		bpl.s	ShotBall_InsertCoinScreen_Process_WaitDialog
		move.l	#ShotBall_InsertCoinScreen_Process_LoadBinoculars,address(a0)

ShotBall_InsertCoinScreen_Process_LoadBinoculars:
		move.l	a0,-(sp)
		lea	(MapEni_InsertBinoculars).l,a0
		lea	(RAM_start+$4000).l,a1
		move.w	#$A2D0,d0
		jsr	(Eni_Decomp).w
		movea.l	(sp)+,a0
		move.w	#$1F,$2E(a0)
;		sfx	sfx_Signal,0,0,0
		move.l	#ShotBall_InsertCoinScreen_Process_DrawBinoculars,address(a0)

ShotBall_InsertCoinScreen_Process_LoadBinoculars_Return:
		rts
; ---------------------------------------------------------------------------

ShotBall_InsertCoinScreen_Process_DrawBinoculars:
		move.w	(vInsertCoin_TextFactor).w,d1
		addi.w	#$28,(vInsertCoin_TextFactor).w
		locVRAM	$C000,d0
		lea	(RAM_start+$4000).l,a1
		jsr	(Copy_Map_Line_To_VRAM).w
		cmpi.w	#$600,(vInsertCoin_TextFactor).w
		blo.s		ShotBall_InsertCoinScreen_Process_DrawBinoculars_Return
		clr.w	(vInsertCoin_TextFactor).w
		move.l	#ShotBall_InsertCoinScreen_Process_LoadDialog2,address(a0)

ShotBall_InsertCoinScreen_Process_DrawBinoculars_Return:
		rts
; ---------------------------------------------------------------------------

ShotBall_InsertCoinScreen_Process_LoadDialog2:
		subq.w	#1,$2E(a0)
		bpl.s	ShotBall_InsertCoinScreen_Process_LoadDialog2_Return
		move.l	#ShotBall_InsertCoinScreen_Process_WaitDialog,address(a0)
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	ShotBall_InsertCoinScreen_Process_LoadDialog2_Return
		move.b	#_TitleStartup2,routine(a1)
		move.l	#DialogTitleStartup2_Process_Index-4,$34(a1)
		move.b	#(DialogTitleStartup2_Process_Index_End-DialogTitleStartup2_Process_Index)/8,$39(a1)

ShotBall_InsertCoinScreen_Process_LoadDialog2_Return:
		rts
; ---------------------------------------------------------------------------

ShotBall_InsertCoinScreen_Process_ScrollUp_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	ShotBall_InsertCoinScreen_Process_LoadDialog2_Return
		move.l	#ShotBall_InsertCoinScreen_Process_ScrollUp,address(a0)

ShotBall_InsertCoinScreen_Process_ScrollUp:
;		move.b	(V_int_run_count+3).w,d0
;		andi.b	#7,d0
;		bne.s	+
;		sfx	sfx_Rising,0,0,0
;+
		subq.w	#1,(Camera_Y_pos_BG_copy).w
		subq.w	#1,(Camera_Y_pos).w
		cmpi.w	#-$20,(Camera_Y_pos).w
		bge.s	ShotBall_InsertCoinScreen_Process_WaitDialog2
		move.w	#$F,$2E(a0)
		move.l	#ShotBall_InsertCoinScreen_Process_ScrollRight_Wait,address(a0)

ShotBall_InsertCoinScreen_Process_ScrollRight_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	ShotBall_InsertCoinScreen_Process_WaitDialog2
		move.l	#ShotBall_InsertCoinScreen_Process_ScrollRight,address(a0)

ShotBall_InsertCoinScreen_Process_ScrollRight:
;		move.b	(V_int_run_count+3).w,d0
;		andi.b	#7,d0
;		bne.s	+
;		sfx	sfx_Rising,0,0,0
;+
		addq.w	#1,(Camera_X_pos).w
		cmpi.w	#$100,(Camera_X_pos).w
		blo.s		ShotBall_InsertCoinScreen_Process_WaitDialog2
		move.l	#ShotBall_InsertCoinScreen_Process_WaitDialog2,address(a0)
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	ShotBall_InsertCoinScreen_Process_WaitDialog2
		move.b	#_TitleStartup3,routine(a1)
		move.l	#DialogTitleStartup3_Process_Index-4,$34(a1)
		move.b	#(DialogTitleStartup3_Process_Index_End-DialogTitleStartup3_Process_Index)/8,$39(a1)

ShotBall_InsertCoinScreen_Process_WaitDialog2:
		rts
; ---------------------------------------------------------------------------

ShotBall_InsertCoinScreen_Process_ScrollDown_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	ShotBall_InsertCoinScreen_Process_WaitDialog2
		move.l	#ShotBall_InsertCoinScreen_Process_ScrollDown,address(a0)

ShotBall_InsertCoinScreen_Process_ScrollDown:
;		move.b	(V_int_run_count+3).w,d0
;		andi.b	#7,d0
;		bne.s	+
;		sfx	sfx_Rising,0,0,0
;+
		addq.w	#1,(Camera_Y_pos_BG_copy).w
		addq.w	#1,(Camera_Y_pos).w
		cmpi.w	#$10,(Camera_Y_pos).w
		bne.s	ShotBall_InsertCoinScreen_Process_WaitDialog3
		move.l	#ShotBall_InsertCoinScreen_Process_WaitDialog3,address(a0)
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	ShotBall_InsertCoinScreen_Process_WaitDialog3
		move.b	#_TitleStartup4,routine(a1)
		move.l	#DialogTitleStartup4_Process_Index-4,$34(a1)
		move.b	#(DialogTitleStartup4_Process_Index_End-DialogTitleStartup4_Process_Index)/8,$39(a1)

ShotBall_InsertCoinScreen_Process_WaitDialog3:
		rts
; ---------------------------------------------------------------------------

ShotBall_InsertCoinScreen_Process_Attack:
		lea	(Pal_InsertCoin+$A0).l,a1
		jsr	(PalLoad_Line2).w
		move.l	#ShotBall_InsertCoinScreen_Process_WaitDialog4,address(a0)
;		sfx	sfx_Laser,0,0,0
		lea	ChildObjDat_ShotBall_InsertCoinScreen(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

ShotBall_InsertCoinScreen_Process_AfterAttack:
		move.l	#ShotBall_InsertCoinScreen_Process_WaitDialog4,address(a0)
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	ShotBall_InsertCoinScreen_Process_WaitDialog4
		move.b	#_TitleStartup5,routine(a1)
		move.l	#DialogTitleStartup5_Process_Index-4,$34(a1)
		move.b	#(DialogTitleStartup5_Process_Index_End-DialogTitleStartup5_Process_Index)/8,$39(a1)

ShotBall_InsertCoinScreen_Process_WaitDialog4:
		rts
; ---------------------------------------------------------------------------

ShotBall_InsertCoinScreen_Process_Remove:
		subq.w	#1,$2E(a0)
		bpl.s	ShotBall_InsertCoinScreen_Process_WaitDialog4
		move.l	#Delete_Current_Sprite,address(a0)
		lea	(Object_RAM).w,a1
		move.w	#$2F,$2E(a1)
		move.l	#TailsPlane_InsertCoinScreen_Flash_Wait,address(a1)

ShotBall_InsertCoinScreen_Process_Remove_Return:
		rts
; ---------------------------------------------------------------------------
; Атакующие снаряды
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShotBall_InsertCoinScreen:
		move.l	#Map_SSZShotBall,mappings(a0)
		move.w	#$423D,art_tile(a0)
		move.w	#$180,priority(a0)
		move.b	#4,render_flags(a0)
		move.w	(Camera_X_pos).w,d0
		move.w	#$30,d1
		tst.b	subtype(a0)
		beq.s	+
		move.w	#$120,d1
+		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$120,d0
		move.w	d0,y_pos(a0)
		move.b	#$17,anim_frame_timer(a0)
		move.l	#ShotBall_InsertCoinScreen_Animate,address(a0)
		lea	(Object_RAM).w,a1
		moveq	#0,d0
		move.w	x_pos(a1),d0
		tst.b	subtype(a0)
		beq.s	+
		addi.w	#$20,d0
+		moveq	#0,d1
		move.w	y_pos(a1),d1
		moveq	#2,d5
		jsr	(Shot_Object_3).w

ShotBall_InsertCoinScreen_Animate:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	ShotBall_InsertCoinScreen_Move
		move.b	#5,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#4,mapping_frame(a0)
		beq.s	ShotBall_InsertCoinScreen_Remove

ShotBall_InsertCoinScreen_Move:
		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

ShotBall_InsertCoinScreen_Remove:
		move.l	#Obj_BossExplosion1,address(a0)
		tst.b	subtype(a0)
		bne.w	ShotBall_InsertCoinScreen_Process_Remove_Return
		movea.w	parent3(a0),a1
		move.l	#ShotBall_InsertCoinScreen_Process_AfterAttack,address(a1)
		lea	(Object_RAM).w,a1
		move.l	#TailsPlane_InsertCoinScreen_SetAttack,address(a1)
		bset	#0,$41(a1)
;		sfx	sfx_Boom2,0,0,0
		move.w	#$14,(Screen_shaking_flag).w











		lea	(Pal_InsertCoin+$40).l,a1
		jmp	(PalLoad_Line2).w
; ---------------------------------------------------------------------------

ChildObjDat_ShotBall_InsertCoinScreen_Process:
		dc.w 1-1
		dc.l Obj_ShotBall_InsertCoinScreen_Process
ChildObjDat_ShotBall_InsertCoinScreen:
		dc.w 2-1
		dc.l Obj_ShotBall_InsertCoinScreen
; ---------------------------------------------------------------------------
; Падающий взрыв
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_DEZFallingExplosion_TailsPlane_InsertCoinScreen:
		move.w	#$F,$2E(a0)
		move.l	#Obj_DEZFallingExplosion_TailsPlane_InsertCoinScreen_Wait,address(a0)

Obj_DEZFallingExplosion_TailsPlane_InsertCoinScreen_Start:
		moveq	#0,d2
		moveq	#8-1,d1

-		jsr	(Create_New_Sprite).w
		bne.s	Obj_DEZFallingExplosion_TailsPlane_InsertCoinScreen_Wait
		move.l	#Obj_DEZFallingExplosion_SetVelocity,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$530,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		movea.w	parent3(a0),a2
		move.w	x_pos(a2),x_pos(a1)
		move.w	y_pos(a2),y_pos(a1)
		move.b	d2,subtype(a1)
		move.b	#7,anim_frame_timer(a1)
		addq.w	#4,d2
		dbf	d1,-

Obj_DEZFallingExplosion_TailsPlane_InsertCoinScreen_Wait:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	Robotnik_IntroFullExplosion_Delete
		tst.b	render_flags(a1)
		bpl.w	Robotnik_IntroFullExplosion_Delete
		subq.w	#1,$2E(a0)
		bpl.w	TailsPlane_InsertCoinScreen_DeleteSprite_Return
		move.w	#$F,$2E(a0)
		bra.s	Obj_DEZFallingExplosion_TailsPlane_InsertCoinScreen_Start
; ---------------------------------------------------------------------------
; Самолет тейлза
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_TailsPlane_InsertCoinScreen:
		move.l	#Map_SSZTailsPlane,mappings(a0)
		move.w	#$24E,art_tile(a0)
		move.w	#$200,priority(a0)
		move.b	#4,render_flags(a0)
		move.w	#$180,x_pos(a0)
		move.w	#$80,y_pos(a0)
		move.b	#128/2,width_pixels(a0)
		move.b	#64/2,height_pixels(a0)
		move.w	x_pos(a0),$30(a0)
		move.w	y_pos(a0),$34(a0)
		addq.b	#1,mapping_frame(a0)
		move.w	#$9F,$2E(a0)
		move.l	#TailsPlane_InsertCoinScreen_Wait,address(a0)
		move.l	#Obj_SonicPlane_InsertCoinScreen,(Object_RAM+(next_object*1)).w
		move.l	#Obj_Emerald_InsertCoinScreen,(Object_RAM+(next_object*2)).w
		lea	TailsPlane_Misc_InsertCoinScreen_ObjData(pc),a2
		moveq	#5-1,d6

-		jsr	(Create_New_Sprite).w
		bne.s	TailsPlane_InsertCoinScreen_Wait
		move.l	(a2)+,address(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	a0,parent3(a1)
		dbf	d6,-

TailsPlane_InsertCoinScreen_Wait:
;		move.b	(V_int_run_count+3).w,d0
;		andi.b	#7,d0
;		bne.s	+
;		sfx	sfx_LargeShip,0,0,0
;+
		subq.w	#1,$2E(a0)
		bpl.w	TailsPlane_InsertCoinScreen_Swing
;		music	bgm_ZoneBoss,0,0,0
		move.l	#TailsPlane_InsertCoinScreen_Swing,address(a0)
		movea.w	$44(a0),a1
		move.l	#ShotBall_InsertCoinScreen_Process_LoadDialog,address(a1)
		bra.w	TailsPlane_InsertCoinScreen_Swing
; ---------------------------------------------------------------------------

TailsPlane_InsertCoinScreen_SetAttack:
		lea	(Object_RAM+(next_object*1)).w,a1
		move.l	#SonicPlane_InsertCoinScreen_CheckAttack,address(a1)
		move.l	#TailsPlane_InsertCoinScreen_Flash2,address(a0)
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_DEZFallingExplosion_TailsPlane_InsertCoinScreen,address(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	a0,parent3(a1)
+		bra.w	TailsPlane_InsertCoinScreen_Flash2
; ---------------------------------------------------------------------------

TailsPlane_InsertCoinScreen_Flash_Wait:
		subq.w	#1,$2E(a0)
		bpl.w	TailsPlane_InsertCoinScreen_Flash
		move.l	#TailsPlane_InsertCoinScreen_HideBinoculars,address(a0)

TailsPlane_InsertCoinScreen_HideBinoculars:
		move.w	(vInsertCoin_TextFactor).w,d1
		addi.w	#$28,(vInsertCoin_TextFactor).w
		locVRAM	$C000,d0
		bsr.w	InsertCoin_Clear_Map_Line_To_VRAM
		cmpi.w	#$600,(vInsertCoin_TextFactor).w
		blo.w	TailsPlane_InsertCoinScreen_Flash
		clr.w	(vInsertCoin_TextFactor).w
		bset	#4,$38(a0)
		lea	(Object_RAM+(next_object*2)).w,a1
		move.l	#Emerald_InsertCoinScreen_MoveLeft,address(a1)
		move.l	#TailsPlane_InsertCoinScreen_Flash,address(a0)
		jsr	(Create_New_Sprite).w
		bne.s	TailsPlane_InsertCoinScreen_Flash
		move.l	#Obj_Dialog_Process,address(a1)
		move.w	a0,parent3(a1)
		move.b	#_TitleTails,routine(a1)
		move.l	#DialogTitleTails_Process_Index-4,$34(a1)
		move.b	#(DialogTitleTails_Process_Index_End-DialogTitleTails_Process_Index)/8,$39(a1)
		bra.s	TailsPlane_InsertCoinScreen_Flash
; ---------------------------------------------------------------------------

TailsPlane_InsertCoinScreen_Flash_SonicJump_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	TailsPlane_InsertCoinScreen_Flash
		move.l	#TailsPlane_InsertCoinScreen_Flash_SonicJump,address(a0)

TailsPlane_InsertCoinScreen_Flash_SonicJump:
		lea	(Object_RAM+(next_object*1)).w,a1
		move.l	#SonicPlane_InsertCoinScreen_SetJump,address(a1)
		move.l	#TailsPlane_InsertCoinScreen_CheckRemove,address(a0)
		move.w	#$100,x_vel(a0)
		move.w	#$200,y_vel(a0)
		clr.w	(HScroll_Shift).w
		bra.s	TailsPlane_InsertCoinScreen_Flash
; ---------------------------------------------------------------------------

TailsPlane_InsertCoinScreen_CheckRemove:
		tst.b	render_flags(a0)
		bpl.s	TailsPlane_InsertCoinScreen_DeleteSprite

TailsPlane_InsertCoinScreen_Flash:
		addq.w	#1,(Camera_Y_pos_BG_copy).w

TailsPlane_InsertCoinScreen_Flash2:
;		move.b	(V_int_run_count+3).w,d0
;		andi.b	#7,d0
;		bne.s	+
;		sfx	sfx_Siren2,0,0,0
;+
		btst	#0,(V_int_run_count+3).w
		beq.s	TailsPlane_InsertCoinScreen_Swing
		eori.w	#$2000,art_tile(a0)

TailsPlane_InsertCoinScreen_Swing:
		jsr	(MoveSprite2_Reserve).w
		move.b	angle(a0),d0
		addq.b	#4,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#6,d0
		add.w	$34(a0),d0
		move.w	d0,y_pos(a0)
		move.w	$30(a0),x_pos(a0)
		tst.b $41(a0)
		beq.s	+
		subq.w	#8,x_pos(a0)
+		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

TailsPlane_InsertCoinScreen_DeleteSprite:
		bset	#7,status(a0)
		move.l	#TailsPlane_InsertCoinScreen_DeleteSprite_HScroll,address(a0)

TailsPlane_InsertCoinScreen_DeleteSprite_HScroll:
		subq.w	#8,(HScroll_Shift).w
		bpl.s	TailsPlane_InsertCoinScreen_DeleteSprite_Return
		clr.w	(HScroll_Shift).w
		move.l	#TailsPlane_InsertCoinScreen_DeleteSprite_WaitFade,address(a0)
		music	bgm_Fade,0,0,0
		addq.b	#2,(Object_load_routine).w
		move.w	#7*60,(vInsertCoin_Timer).w
		lea	(Pal_InsertCoin+$A0).l,a1
		jsr	(PalLoad_Line2).w
		disableInts
		stopZ80
		dmaFillVRAM 0,$6000,$1000
		startZ80
		enableInts
		rts
; ---------------------------------------------------------------------------

TailsPlane_InsertCoinScreen_DeleteSprite_WaitFade:
		tst.b	(Clone_Driver_RAM+SMPS_RAM.variables.v_fadeout_counter).w
		bne.s	TailsPlane_InsertCoinScreen_DeleteSprite_Return
		music	bgm_TitleScroll,0,0,0
		move.l	#Delete_Current_Sprite,address(a0)

TailsPlane_InsertCoinScreen_DeleteSprite_Return:
		rts
; ---------------------------------------------------------------------------

TailsPlane_Misc_InsertCoinScreen_ObjData:
		dc.l Obj_TailsPlane_Head_InsertCoinScreen
		dc.l Obj_TailsPlane_Propeller_InsertCoinScreen
		dc.l Obj_TailsPlane_Fire_InsertCoinScreen
		dc.l Obj_TailsPlane_GrabEmerald_InsertCoinScreen
		dc.l Obj_ShotBall_InsertCoinScreen_Process
; ---------------------------------------------------------------------------
; Самолет тейлза (Голова)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_TailsPlane_Head_InsertCoinScreen:
		move.b	#4,render_flags(a0)
		move.w	#$280,priority(a0)
		move.b	#16/2,width_pixels(a0)
		move.b	#16/2,height_pixels(a0)
		move.b	#9,mapping_frame(a0)
		move.l	#TailsPlane_Head_InsertCoinScreen_Main,address(a0)

TailsPlane_Head_InsertCoinScreen_Main:
		jsr	(Refresh_ChildPosition).w
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------
; Самолет тейлза (Пропеллер)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_TailsPlane_Propeller_InsertCoinScreen:
		move.b	#4,render_flags(a0)
		move.w	#$280,priority(a0)
		move.b	#128/2,width_pixels(a0)
		move.b	#64/2,height_pixels(a0)
		addq.b	#2,mapping_frame(a0)
		move.l	#TailsPlane_Propeller_InsertCoinScreen_Main,address(a0)

TailsPlane_Propeller_InsertCoinScreen_Main:
		jsr	(Refresh_ChildPosition).w
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#6,mapping_frame(a0)
		bne.s	TailsPlane_Propeller_InsertCoinScreen_Draw
		move.b	#2,mapping_frame(a0)

TailsPlane_Propeller_InsertCoinScreen_Draw:
		movea.w	parent3(a0),a1
		move.w	art_tile(a1),art_tile(a0)
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------
; Самолет тейлза (Огонь)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_TailsPlane_Fire_InsertCoinScreen:
		move.b	#4,render_flags(a0)
		move.w	#$280,priority(a0)
		move.b	#128/2,width_pixels(a0)
		move.b	#64/2,height_pixels(a0)
		addq.b	#6,mapping_frame(a0)
		move.l	#TailsPlane_Fire_InsertCoinScreen_Main,address(a0)

TailsPlane_Fire_InsertCoinScreen_Main:
		jsr	(Refresh_ChildPosition).w
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#8,mapping_frame(a0)
		bne.s	TailsPlane_Fire_InsertCoinScreen_Draw
		move.b	#6,mapping_frame(a0)

TailsPlane_Fire_InsertCoinScreen_Draw:
		movea.w	parent3(a0),a1
		move.w	art_tile(a1),art_tile(a0)
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------
; Соник
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SonicPlane_InsertCoinScreen:
		move.l	#Map_Sonic,mappings(a0)
		move.w	#make_art_tile(ArtTile_Sonic,0,0),art_tile(a0)
		move.w	#$100,priority(a0)
		move.b	#48/2,width_pixels(a0)
		move.b	#48/2,height_pixels(a0)
		move.b	#4,render_flags(a0)
		move.b	#id_Wait2,anim(a0)
		move.b	#32,child_dx(a0)
		move.b	#-42,child_dy(a0)
		move.l	#SonicPlane_InsertCoinScreen_ChildPosition,address(a0)
		bra.w	SonicPlane_InsertCoinScreen_ChildPosition
; ---------------------------------------------------------------------------

SonicPlane_InsertCoinScreen_CheckAttack:
		bclr	#0,(Object_RAM+$41).w
		beq.w	SonicPlane_InsertCoinScreen_ChildPosition
		move.w	#7,$2E(a0)
		move.l	#SonicPlane_InsertCoinScreen_CheckAttack_Wait,address(a0)

SonicPlane_InsertCoinScreen_CheckAttack_Wait:
		subq.w	#1,$2E(a0)
		bpl.w	SonicPlane_InsertCoinScreen_ChildPosition
		move.b	#id_Assault,anim(a0)
		move.l	#SonicPlane_InsertCoinScreen_ChildPosition,address(a0)
		bra.w	SonicPlane_InsertCoinScreen_ChildPosition
; ---------------------------------------------------------------------------

SonicPlane_InsertCoinScreen_SetJump:
		bset	#0,status(a0)
		move.b	#id_Roll,anim(a0)
		move.w	#-$400,x_vel(a0)
		move.w	#-$680,y_vel(a0)
		move.l	#SonicPlane_InsertCoinScreen_Jump,address(a0)

SonicPlane_InsertCoinScreen_Jump:
		move.w	x_pos(a0),d0
		subi.w	#$A0,d0
		move.w	d0,(Camera_X_pos).w
		move.w	y_pos(a0),d0
		subi.w	#$60,d0
		move.w	d0,(Camera_Y_pos).w
		addq.w	#1,(Camera_Y_pos_BG_copy).w
		subq.w	#1,(Camera_X_pos).w
		bpl.s	SonicPlane_InsertCoinScreen_MoveSprite
		clr.w	(Camera_X_pos).w
		clr.l	x_vel(a0)
		bclr	#0,status(a0)
		sfx2	sfx_Grab,0,0,0
		move.b	#id_Grab,anim(a0)
		move.l	#SonicPlane_InsertCoinScreen_Draw,address(a0)
		lea	(Object_RAM+(next_object*2)).w,a1
		move.l	#Emerald_InsertCoinScreen_MoveUp,address(a1)
		bra.s	SonicPlane_InsertCoinScreen_Draw
; ---------------------------------------------------------------------------

SonicPlane_InsertCoinScreen_MoveSprite:
		jsr	(MoveSprite).w
		bra.s	SonicPlane_InsertCoinScreen_Draw
; ---------------------------------------------------------------------------

SonicPlane_InsertCoinScreen_ChildPosition:
		lea	(Object_RAM).w,a1
		jsr	(Refresh_ChildPosition2).w

SonicPlane_InsertCoinScreen_Draw:
		jsr	(Animate_Sonic).l
		jsr	(Sonic_Load_PLC).l
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_TailsPlane_GrabEmerald_InsertCoinScreen:
		move.b	#4,render_flags(a0)
		move.w	#$180,priority(a0)
		move.b	#128/2,width_pixels(a0)
		move.b	#64/2,height_pixels(a0)
		move.b	#8,mapping_frame(a0)
		move.b	#-116,child_dx(a0)
		move.b	#-4,child_dy(a0)
		move.l	#TailsPlane_GrabEmerald_InsertCoinScreen_Main,address(a0)

TailsPlane_GrabEmerald_InsertCoinScreen_Main:
		jsr	(Refresh_ChildPosition).w
		moveq	#0,d0
		jmp	(Child_Draw_Sprite2_FlickerMove).w

; =============== S U B R O U T I N E =======================================

Obj_Emerald_InsertCoinScreen:
		move.l	#Map_SSZDeathEggSmall,mappings(a0)
		move.w	#$21DE,art_tile(a0)
		move.w	#$200,priority(a0)
		move.b	#4,render_flags(a0)
		addq.b	#1,mapping_frame(a0)
		move.b	#64/2,width_pixels(a0)
		move.b	#64/2,height_pixels(a0)
		move.b	#-74,child_dx(a0)
		st	child_dy(a0)
		move.l	#Emerald_InsertCoinScreen_Wait,address(a0)

Emerald_InsertCoinScreen_Wait:
		lea	(Object_RAM).w,a1
		move.w	x_pos(a1),d0
		move.b	child_dx(a0),d1
		ext.w	d1
		add.w	d1,d1
		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	y_pos(a1),d0
		move.b	child_dy(a0),d1
		ext.w	d1
		add.w	d1,d1
		add.w	d1,d0
		move.w	d0,y_pos(a0)
		bra.w	Emerald_InsertCoinScreen_Draw
; ---------------------------------------------------------------------------

Emerald_InsertCoinScreen_MoveLeft:
		subq.w	#1,x_pos(a0)
		cmpi.w	#$A0,x_pos(a0)
		bhs.w	Emerald_InsertCoinScreen_Draw
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$40,d0
		move.w	d0,y_pos(a0)
		move.l	#Emerald_InsertCoinScreen_Draw,address(a0)
		bra.s	Emerald_InsertCoinScreen_Draw
; ---------------------------------------------------------------------------

Emerald_InsertCoinScreen_MoveUp:
		cmpi.w	#$208,(Camera_Y_pos_BG_copy).w
		bhs.s	Emerald_InsertCoinScreen_MoveSonic
		sfx	sfx_Squeak,0,0,0
		move.l	#Emerald_InsertCoinScreen_MoveUpFix,address(a0)
		bra.s	Emerald_InsertCoinScreen_MoveSonic
; ---------------------------------------------------------------------------

Emerald_InsertCoinScreen_MoveUpFix:
		btst	#0,(Level_frame_counter+1).w
		bne.s	Emerald_InsertCoinScreen_MoveSonic
		subq.w	#1,(Camera_Y_pos).w
		bpl.s	Emerald_InsertCoinScreen_MoveSonic
		clr.w	(Camera_Y_pos).w
		move.l	#Emerald_InsertCoinScreen_MoveUpFix2,address(a0)
		bra.s	Emerald_InsertCoinScreen_MoveSonic
; ---------------------------------------------------------------------------

Emerald_InsertCoinScreen_MoveUpFix2:
		btst	#0,(Level_frame_counter+1).w
		bne.s	Emerald_InsertCoinScreen_MoveSonic
		addq.w	#1,y_pos(a0)
		cmpi.w	#$8A,y_pos(a0)
		blo.s		Emerald_InsertCoinScreen_MoveSonic
		move.l	#Emerald_InsertCoinScreen_MoveSonic,address(a0)

Emerald_InsertCoinScreen_MoveSonic:
		lea	(Object_RAM+(next_object*1)).w,a1
		move.w	x_pos(a0),d0
		addi.w	#8,d0
		move.w	d0,x_pos(a1)
		move.w	y_pos(a0),d0
		addi.w	#5,d0
		move.w	d0,y_pos(a1)

Emerald_InsertCoinScreen_Draw:
		lea	off_7DD5A(pc),a1
		lea	(Normal_palette_line_2+$E).w,a2
		jsr	(Run_PalRotationScript2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

off_7DD5A:
		dc.l off_7DD7A		; Address of Palette animation data
		dc.w 2-1				; Number of colors to replace
		dc.b 0, $F			; Index, Timer
		dc.b 1, 9
		dc.b 2, 9
		dc.b 3, 7
		dc.b 4, 7
		dc.b 5, 5
		dc.b 6, 5
		dc.b 5, 5
		dc.b 4, 7
		dc.b 3, 7
		dc.b 2, 9
		dc.b 1, 9
		palscriptrept			; Repeat

off_7DD7A: offsetTable
		offsetTableEntry.w word_7DD88		; 0
		offsetTableEntry.w word_7DD8C	; 1
		offsetTableEntry.w word_7DD90	; 2
		offsetTableEntry.w word_7DD94		; 3
		offsetTableEntry.w word_7DD98		; 4
		offsetTableEntry.w word_7DD9C	; 5
		offsetTableEntry.w word_7DDA0	; 6
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
		move.w	#$215,art_tile(a0)
		move.w	#$80,priority(a0)
		move.b	#4,render_flags(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		subi.w	#$40,d0
		move.w	d0,y_pos(a0)
		move.b	#32/2,width_pixels(a0)
		move.b	#32/2,height_pixels(a0)
		move.w	#$F,$2E(a0)
		move.l	#Crane_InsertCoinScreen_Wait,address(a0)

Crane_InsertCoinScreen_Wait:
		subq.w	#1,$2E(a0)
		bpl.w	Crane_InsertCoinScreen_Draw
		sfx	sfx_Arm,0,0,0
		move.l	#Crane_InsertCoinScreen_Down,address(a0)
		lea	Crane_InsertCoinScreen_ObjData(pc),a2
		moveq	#2-1,d6

-		jsr	(Create_New_Sprite).w
		bne.s	Crane_InsertCoinScreen_Down
		move.l	(a2)+,address(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
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
		lea	(Object_RAM+(next_object*2)).w,a1
		move.w	y_pos(a0),d0
		addi.w	#17,d0
		move.w	d0,y_pos(a1)
		subq.w	#4,y_pos(a0)
		subq.b	#4,child_dy(a0)
		bhs.s	Crane_InsertCoinScreen_Draw
		clr.b	child_dy(a0)
		addq.b	#2,(Object_load_routine).w
		move.l	#Go_Delete_Sprite,address(a0)
		lea	(Delete_Referenced_Sprite).w,a4
		lea	(Object_RAM+(next_object*1)).w,a1
		jsr	(a4)
		lea	(Object_RAM+(next_object*2)).w,a1
		jmp	(a4)
; ---------------------------------------------------------------------------

Crane_InsertCoinScreen_Draw:
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Crane_InsertCoinScreen_ObjData:
		dc.l Obj_Crane2_InsertCoinScreen
		dc.l Obj_Chain_InsertCoinScreen

; =============== S U B R O U T I N E =======================================

Obj_Crane2_InsertCoinScreen:
		move.b	#4,render_flags(a0)
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
		move.b	#4,render_flags(a0)
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
		move.w	#$170,art_tile(a0)
		move.w	#$280,priority(a0)
		move.b	#4,render_flags(a0)
		move.b	#64/2,width_pixels(a0)
		move.b	#64/2,height_pixels(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$100,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$40,d0
		move.w	d0,y_pos(a0)
		move.w	y_pos(a0),$32(a0)
		moveq	#1*60,d0
		move.w	d0,$2E(a0)
		move.b	d0,$30(a0)
		move.l	#DeathEggMini_InsertCoinScreen_Wait,address(a0)
		bra.w	DeathEggMini_InsertCoinScreen_Draw
; ---------------------------------------------------------------------------

Pal_DeathEggMini_InsertCoinScreen:
		dc.w $200, 0, 0
		dc.w $422, $200, 0
		dc.w $644, $422, $200
; ---------------------------------------------------------------------------

DeathEggMini_InsertCoinScreen_Wait:
		tst.b	(vInsertCoin_TextFactor2).w
		beq.w	DeathEggMini_InsertCoinScreen_End
		subq.b	#1,$30(a0)
		bpl.s	.redraw
		move.b	#7,$30(a0)
		moveq	#0,d0
		move.b	$31(a0),d0
		cmpi.b	#3*6,d0
		beq.s	.redraw
		addq.b	#6,$31(a0)
		lea	(Normal_palette_line_1+2).w,a2
		lea	Pal_DeathEggMini_InsertCoinScreen(pc,d0.w),a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+

.redraw:
		subq.w	#1,$2E(a0)
		bpl.w	DeathEggMini_InsertCoinScreen_Move
		move.w	#1,$2E(a0)
		lea	(ArtUnc_TitleDeathEggSmall).l,a1		; Original Art
		lea	(RAM_Start+$2000).l,a2				; Mod Art
		move.w	#((ArtUnc_TitleDeathEggSmall_End-ArtUnc_TitleDeathEggSmall)/$20)-1,d5	; Art size
		move.b	(vInsertCoin_TextFactor2).w,d2
		add.b	d2,d2
		andi.w	#$3C,d2
		bsr.w	InsertCoin_SmoothDrawArtText3
		QueueStaticDMA (RAM_Start+$2000),tiles_to_bytes((ArtUnc_TitleDeathEggSmall_End-ArtUnc_TitleDeathEggSmall)/$20),tiles_to_bytes($170)
		bra.w	DeathEggMini_InsertCoinScreen_Move
; ---------------------------------------------------------------------------

DeathEggMini_InsertCoinScreen_End:
;		sfx	sfx_Flash,0,0,0

		move.l	#DeathEggMini_InsertCoinScreen_Move,address(a0)

DeathEggMini_InsertCoinScreen_Move:
		move.b	angle(a0),d0
		addq.b	#1,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#6,d0
		add.w	$32(a0),d0
		move.w	d0,y_pos(a0)
		cmpi.w	#$100,(Camera_Y_pos_BG_copy).w
		blo.s		DeathEggMini_InsertCoinScreen_Remove

DeathEggMini_InsertCoinScreen_Draw:
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

DeathEggMini_InsertCoinScreen_Remove:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

InsertCoinScreen_CodeDat:
		dc.b btnUp, btnC, btnDn, btnB, btnL, btnA, btnR, btnB, btnA, btnC
		dc.b 0		; Stop
	even

; =============== S U B R O U T I N E =======================================

InsertCoinScreen_Code:
		lea	InsertCoinScreen_CodeDat(pc),a1
		lea	(vInsertCoin_Cheat).w,a2
		moveq	#0,d0
		move.b	(a2),d0
		adda.w	d0,a1
		move.b	(Ctrl_1_pressed).w,d0
		andi.b	#$7F,d0
		beq.s	InsertCoinScreen_Code_Return
		move.b	(Ctrl_1).w,d0
		cmp.b	(a1)+,d0
		bne.s	InsertCoinScreen_Code_Fail
		addq.b	#1,(a2)
		tst.b	(a1)
		bne.s	InsertCoinScreen_Code_Return
		sfx	sfx_Ring,0,0,0
		move.b	#id_LevelSelectScreen,(Game_mode).w		; set Game Mode
		addq.w	#8,sp

InsertCoinScreen_Code_Fail:
		clr.b	(a2)

InsertCoinScreen_Code_Return:
		rts

; =============== S U B R O U T I N E =======================================

SmoothDrawArtText:
		lea	(ArtUnc_TerminalText).l,a0
		move.w	#((ArtUnc_TerminalText_End-ArtUnc_TerminalText)/$20)-1,d7		; Art size

SmoothDrawArtText2:
		moveq	#8-1,d6			; Tile size
		move.w	(a2),d5
		move.w	d5,d0
		addq.w	#1,d0
		cmpi.w	#9,d0
		blo.s		.skip
		moveq	#8,d0

.skip:
		move.w	d0,(a2)+
		bra.s	.loadfactor
; ---------------------------------------------------------------------------

.setfactor:
		move.w	(a2),d5
		move.w	d4,(a2)+

.loadfactor:
		move.w	d5,d4
		add.w	d5,d5
		add.w	d5,d5
		move.l	(a0)+,d0
		move.l	SmoothText_Factor(pc,d5.w),d2
		and.l	d2,d0
		move.l	d0,(a1)+
		dbf	d6,.setfactor
		dbf	d7,SmoothDrawArtText2
		subq.b	#1,(vInsertCoin_TextFactor).w
		rts
; ---------------------------------------------------------------------------

SmoothText_Factor:
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

SmoothHideArtText:
		lea	(ArtUnc_TerminalText).l,a0
		move.w	#((ArtUnc_TerminalText_End-ArtUnc_TerminalText)/$20)-1,d7		; Art size

SmoothHideArtText2:
		moveq	#8-1,d6			; Tile size
		move.w	(a2),d5
		move.w	d5,d0
		subq.w	#1,d0
		bpl.s	.skip
		moveq	#0,d0

.skip:
		move.w	d0,(a2)+
		bra.s	.loadfactor
; ---------------------------------------------------------------------------

.setfactor:
		move.w	(a2),d5
		move.w	d4,(a2)+

.loadfactor:
		move.w	d5,d4
		add.w	d5,d5
		add.w	d5,d5
		move.l	(a0)+,d0
		move.l	SmoothText_Factor(pc,d5.w),d2
		and.l	d2,d0
		move.l	d0,(a1)+
		dbf	d6,.setfactor
		dbf	d7,SmoothHideArtText2
		subq.b	#1,(vInsertCoin_TextFactor).w
		rts

; =============== S U B R O U T I N E =======================================

SmoothLoadArtText:
		move.w	#(ArtUnc_TerminalText_End-ArtUnc_TerminalText)/2,d3		; Size/2
		jmp	(Add_To_DMA_Queue).w

; =============== S U B R O U T I N E =======================================

Title_Deform:
		bsr.s	Title_Deform2
		move.w	(HScroll_Shift).w,d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,(HScroll_Shift+2).w
		lea	Title_BGDrawArray(pc),a4
		lea	(H_scroll_table).w,a5
		bra.w	ApplyTitleDeformation
; ---------------------------------------------------------------------------

Title_Deform2:
		lea	Title_ParallaxScript(pc),a1
		jmp	(ExecuteParallaxScript).w
; ---------------------------------------------------------------------------

Title_BGDrawArray:

	rept	3
		dc.w 16									; Space
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
	endr

		dc.w 16									; Space 2	; 606
		dc.w 14

		dc.w 8									; Earth

		dc.w 6									; Earth 2
		dc.w 8
		dc.w 8
		dc.w 8									; 644

		dc.w 508									; Null ; 1152

		dc.w 20									; Clouds	; 1172
		dc.w 6									; 1178
		dc.w 36									; 1214
		dc.w 22									; 1236
		dc.w 44									; 1280

		dc.w 260									; Null ; 1540

		dc.w 48									; Clouds	; 1588
		dc.w 16									; 1604
		dc.w 16									; 1620
		dc.w 12									; 1632
		dc.w 32									; 1664
		dc.w 20									; 1684
		dc.w 6									; 1690
		dc.w 36									; 1726
		dc.w 22									; 1748
		dc.w 44									; 1792

		dc.w 260									; Null ; 2052

		dc.w 48									; Clouds	; 2100
		dc.w 16									; 2116
		dc.w 16									; 2132
		dc.w 12									; 2144
		dc.w 32									; 2176
		dc.w 20									; 2196
		dc.w 6									; 2202
		dc.w 36									; 2238
		dc.w 22									; 2260
		dc.w 44									; 2304

		dc.w 388									; Null ; 2692

		dc.w 48									; Clouds	; 2740
		dc.w 16									; 2756
		dc.w 16									; 2772
		dc.w 12									; 2784
		dc.w 32									; 2816
		dc.w 20									; 2836
		dc.w 6									; 2842
		dc.w 36									; 2878
		dc.w 22									; 2900
		dc.w 44									; 2944

		dc.w 48									; Clouds	; 2992
		dc.w 16									; 3008
		dc.w 16									; 3024
		dc.w 12									; 3036
		dc.w 32									; 3068
		dc.w 20									; 3088
		dc.w 6									; 3094
		dc.w 36									; 3130
		dc.w 22									; 3152
		dc.w 44									; 3196

		dc.w 48									; Clouds	; 3244
		dc.w 16									; 3260
		dc.w 16									; 3276
		dc.w 12									; 3288
		dc.w 32									; 3320
		dc.w 20									; 3340
		dc.w 6									; 3346
		dc.w 36									; 3382
		dc.w 22									; 3404
		dc.w 44									; 3448












		dc.w $7FFF

Title_ParallaxScript:
		; Mode	Speed coef.	Number of lines(Linear only)

; Space
	rept	3
		dc.w	_moving|$03,	$0600		; BG
		dc.w	_moving|$02,	$0400		; BG
		dc.w	_moving|$03,	$0600		; BG
		dc.w	_moving|$02,	$0400		; BG
		dc.w	_moving|$03,	$0600		; BG
		dc.w	_moving|$02,	$0400		; BG
		dc.w	_moving|$03,	$0600		; BG
		dc.w	_moving|$02,	$0400		; BG
		dc.w	_moving|$03,	$0600		; BG
		dc.w	_moving|$02,	$0400		; BG
		dc.w	_moving|$03,	$0600		; BG
		dc.w	_moving|$02,	$0400		; BG
	endm

; Space 2
		dc.w	_moving|$03,	$0600		; BG
		dc.w	_moving|$02,	$0400		; BG

; Earth
		dc.w	_moving|$02,	$0200		; BG

; Earth 2
		dc.w	_moving|$04,	$0002		; BG
		dc.w	_moving|$05,	$0006		; BG
		dc.w	_moving|$06,	$0008		; BG
		dc.w	_moving|$07,	$0010		; BG

; Null
		dc.w	_moving|$07,	$0000		; BG

; Clouds
		dc.w	_moving|$04,	$0600		; BG
		dc.w	_moving|$05,	$0400		; BG
		dc.w	_moving|$06,	$0600		; BG
		dc.w	_moving|$07,	$0400		; BG
		dc.w	_moving|$08,	$0600		; BG

; Null
		dc.w	_moving|$07,	$0000		; BG

; Clouds
		dc.w	_moving|$04,	$0600		; BG
		dc.w	_moving|$05,	$0400		; BG
		dc.w	_moving|$06,	$0600		; BG
		dc.w	_moving|$07,	$0400		; BG
		dc.w	_moving|$08,	$0600		; BG
		dc.w	_moving|$04,	$0600		; BG
		dc.w	_moving|$05,	$0400		; BG
		dc.w	_moving|$06,	$0600		; BG
		dc.w	_moving|$07,	$0400		; BG
		dc.w	_moving|$08,	$0600		; BG

; Null
		dc.w	_moving|$07,	$0000		; BG

; Clouds
		dc.w	_moving|$04,	$0600		; BG
		dc.w	_moving|$05,	$0400		; BG
		dc.w	_moving|$06,	$0600		; BG
		dc.w	_moving|$07,	$0400		; BG
		dc.w	_moving|$08,	$0600		; BG
		dc.w	_moving|$04,	$0600		; BG
		dc.w	_moving|$05,	$0400		; BG
		dc.w	_moving|$06,	$0600		; BG
		dc.w	_moving|$07,	$0400		; BG
		dc.w	_moving|$08,	$0600		; BG

; Null
		dc.w	_moving|$07,	$0000		; BG

; Clouds
		dc.w	_moving|$04,	$0010		; BG
		dc.w	_moving|$05,	$0010		; BG
		dc.w	_moving|$06,	$0010		; BG
		dc.w	_moving|$07,	$0010		; BG
		dc.w	_moving|$08,	$0010		; BG
		dc.w	_moving|$04,	$0010		; BG
		dc.w	_moving|$05,	$0010		; BG
		dc.w	_moving|$06,	$0010		; BG
		dc.w	_moving|$07,	$0010		; BG
		dc.w	_moving|$08,	$0010		; BG

; Clouds
		dc.w	_moving|$04,	$0010		; BG
		dc.w	_moving|$05,	$0010		; BG
		dc.w	_moving|$06,	$0010		; BG
		dc.w	_moving|$07,	$0010		; BG
		dc.w	_moving|$08,	$0010		; BG
		dc.w	_moving|$04,	$0010		; BG
		dc.w	_moving|$05,	$0010		; BG
		dc.w	_moving|$06,	$0010		; BG
		dc.w	_moving|$07,	$0010		; BG
		dc.w	_moving|$08,	$0010		; BG

; Clouds
		dc.w	_moving|$04,	$0010		; BG
		dc.w	_moving|$05,	$0010		; BG
		dc.w	_moving|$06,	$0010		; BG
		dc.w	_moving|$07,	$0010		; BG
		dc.w	_moving|$08,	$0010		; BG
		dc.w	_moving|$04,	$0010		; BG
		dc.w	_moving|$05,	$0010		; BG
		dc.w	_moving|$06,	$0010		; BG
		dc.w	_moving|$07,	$0010		; BG
		dc.w	_moving|$08,	$0010		; BG












		dc.w -1

; =============== S U B R O U T I N E =======================================

ApplyTitleDeformation:
		move.w	#224-1,d1

ApplyTitleDeformation3:
		lea	(H_scroll_buffer).w,a1
		move.w	(Camera_Y_pos_BG_copy).w,d0
		move.w	(Camera_X_pos_copy).w,d3

ApplyTitleDeformation2:
		move.w	(a4)+,d2
		smi	d4
		bpl.s	.loc_4F0E8
		andi.w	#$7FFF,d2

.loc_4F0E8:
		sub.w	d2,d0
		bmi.s	.loc_4F0FA
		addq.w	#2,a5
		tst.b	d4
		beq.s	ApplyTitleDeformation2
		subq.w	#2,a5
		add.w	d2,d2
		adda.w	d2,a5
		bra.s	ApplyTitleDeformation2
; ---------------------------------------------------------------------------

.loc_4F0FA:
		tst.b	d4
		beq.s	.loc_4F104
		add.w	d0,d2
		add.w	d2,d2
		adda.w	d2,a5

.loc_4F104:
		neg.w	d0
		move.w	d1,d2
		sub.w	d0,d2
		bcc.s	.loc_4F110
		move.w	d1,d0
		addq.w	#1,d0

.loc_4F110:
		neg.w	d3
		swap	d3

.loc_4F114:
		subq.w	#1,d0

.loc_4F116:
		tst.b	d4
		beq.s	.loc_4F130
		lsr.w	#1,d0
		bcc.s	.loc_4F124

.loc_4F11E:
		move.w	(a5)+,d3
		neg.w	d3
		addq.w	#2,a1
		move.w	d3,(a1)+

.loc_4F124:
		move.w	(a5)+,d3
		neg.w	d3
		addq.w	#2,a1
		move.w	d3,(a1)+
		dbf	d0,.loc_4F11E
		bra.s	.loc_4F140
; ---------------------------------------------------------------------------

.loc_4F130:
		move.w	(a5)+,d3
		neg.w	d3
		lsr.w	#1,d0
		bcc.s	.loc_4F13A

.loc_4F138:
		addq.w	#2,a1
		move.w	d3,(a1)+

.loc_4F13A:
		addq.w	#2,a1
		move.w	d3,(a1)+
		dbf	d0,.loc_4F138

.loc_4F140:
		tst.w	d2
		bmi.s	.locret_4F158
		move.w	(a4)+,d0
		smi	d4
		bpl.s	.loc_4F14E
		andi.w	#$7FFF,d0

.loc_4F14E:
		move.w	d2,d3
		sub.w	d0,d2
		bpl.s	.loc_4F114
		move.w	d3,d0
		bra.s	.loc_4F116
; ---------------------------------------------------------------------------

.locret_4F158:
		rts
; End of function ApplyTitleDeformation
; ---------------------------------------------------------------------------

PLC_InsertCoin:
		dc.w ((PLC_InsertCoin_End-PLC_InsertCoin)/6)-1
		plreq 0, Title_8x8_KosM
		plreq $175, ArtKosM_TitlePixel
PLC_InsertCoin_End

PLC_InsertCoin2:
		dc.w ((PLC_InsertCoin2_End-PLC_InsertCoin2)/6)-1
		plreq $1DE, ArtKosM_TitleMasterEmerald
		plreq $24E, ArtKosM_TitleTailsPlane
		plreq $2D0, ArtKosM_TitleBinoculars
PLC_InsertCoin2_End

; =============== S U B R O U T I N E =======================================

InsertCoin_StartupTextIndex: offsetTable
		offsetTableEntry.w InsertCoin_StartupText1
		offsetTableEntry.w InsertCoin_StartupText2
		offsetTableEntry.w InsertCoin_StartupText3
		offsetTableEntry.w InsertCoin_StartupText4
		offsetTableEntry.w InsertCoin_StartupText5
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupText6
		offsetTableEntry.w InsertCoin_StartupText7
		offsetTableEntry.w InsertCoin_StartupText8
		offsetTableEntry.w InsertCoin_StartupText9
		offsetTableEntry.w InsertCoin_StartupText10
		offsetTableEntry.w InsertCoin_StartupText11
		offsetTableEntry.w InsertCoin_StartupText12
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupText13
		offsetTableEntry.w InsertCoin_StartupText14
		offsetTableEntry.w InsertCoin_StartupText15
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupText16
		offsetTableEntry.w InsertCoin_StartupText17
		offsetTableEntry.w InsertCoin_StartupText18
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupText19
		offsetTableEntry.w InsertCoin_StartupText20
		offsetTableEntry.w InsertCoin_StartupText21
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupText22
		offsetTableEntry.w InsertCoin_StartupText23
		offsetTableEntry.w InsertCoin_StartupText24
		offsetTableEntry.w InsertCoin_StartupText25
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupText26
		offsetTableEntry.w InsertCoin_StartupText27
		offsetTableEntry.w InsertCoin_StartupText28
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupText29
		offsetTableEntry.w InsertCoin_StartupText30
		offsetTableEntry.w InsertCoin_StartupText31
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupText32
		offsetTableEntry.w InsertCoin_StartupText33
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupText34
		offsetTableEntry.w InsertCoin_StartupText35
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupText36

; Null
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull
		offsetTableEntry.w InsertCoin_StartupNull

InsertCoin_StartupText1:		prologuestr $02, "Sonic and Tails were once again able"
InsertCoin_StartupText2:		prologuestr $02, "to defeat the villain Dr. Robotnik."
InsertCoin_StartupText3:		prologuestr $02, "They were able to knock Master Emerald"
InsertCoin_StartupText4:		prologuestr $02, "out of the hands of Dr. Robotnik and"
InsertCoin_StartupText5:		prologuestr $02, "spoil his insidious plans."

InsertCoin_StartupText6:		prologuestr $02, "Our heroes understood that they had to"
InsertCoin_StartupText7:		prologuestr $02, "protect Master Emerald from"
InsertCoin_StartupText8:		prologuestr $02, "Dr. Robotnik, otherwise in the hands"
InsertCoin_StartupText9:		prologuestr $02, "of the villain this magical relic"
InsertCoin_StartupText10:		prologuestr $02, "could destroy the whole world."
InsertCoin_StartupText11:		prologuestr $02, "However, the adventures of our heroes"
InsertCoin_StartupText12:		prologuestr $02, "do not end there..."

InsertCoin_StartupText13:		prologuestr $02, "Celebrating another victory, they had"
InsertCoin_StartupText14:		prologuestr $02, "no idea that Dr. Robotnik had an ace"
InsertCoin_StartupText15:		prologuestr $02, "hidden up his sleeve."

InsertCoin_StartupText16:		prologuestr $02, "He tracked down our heroes who were"
InsertCoin_StartupText17:		prologuestr $02, "already celebrating the victory in"
InsertCoin_StartupText18:		prologuestr $02, "order to regain their rightful place..."

InsertCoin_StartupText19:		prologuestr $02, "Dr. Robotnik already had a plan to get"
InsertCoin_StartupText20:		prologuestr $02, "Master Emerald before Sonic and Tails"
InsertCoin_StartupText21:		prologuestr $02, "returned to Angel Island."

InsertCoin_StartupText22:		prologuestr $02, "This time, Dr. Robotnik decided to use"
InsertCoin_StartupText23:		prologuestr $02, "his new, more advanced plan to attack"
InsertCoin_StartupText24:		prologuestr $02, "our heroes in order to get"
InsertCoin_StartupText25:		prologuestr $02, "Master Emerald back."

InsertCoin_StartupText26:		prologuestr $02, "Dr. Robotnik will use his new secret"
InsertCoin_StartupText27:		prologuestr $02, "weapon. Therefore, he will not lose"
InsertCoin_StartupText28:		prologuestr $02, "so easily..."

InsertCoin_StartupText29:		prologuestr $02, "Dr. Robotnik is ready to burn this"
InsertCoin_StartupText30:		prologuestr $02, "world to the ground, just not to spend"
InsertCoin_StartupText31:		prologuestr $02, "another minute with these animals."

InsertCoin_StartupText32:		prologuestr $02, "Whether Sonic and Tails can protect"
InsertCoin_StartupText33:		prologuestr $02, "Master Emerald all depends on you..."

InsertCoin_StartupText34:		prologuestr $02, "You must defeat Dr. Robotnik or the"
InsertCoin_StartupText35:		prologuestr $02, "whole world will be destroyed!"

InsertCoin_StartupText36:		prologuestr $02, "You have to save us!"
InsertCoin_StartupNull:		dc.b 0, 0, -1
	even

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
		offsetTableEntry.w InsertCoin_IntroText9		; 10
		offsetTableEntry.w InsertCoin_IntroTextA		; 12
InsertCoin_IntroTextIndex_End



InsertCoin_IntroText1:		dc.b "  SONIC 3 & KNUCKLES: EPILOGUE (2021)   ",-1

InsertCoin_IntroText2:		dc.b "         PRESENT FROM HARDLINE          ",-1

InsertCoin_IntroText3:		dc.b "           HACK BY THEBLAD768           ",-1

InsertCoin_IntroText4:		dc.b "        MAIN ARTIST MRCAT-PIXEL         ",-1

InsertCoin_IntroText5:		dc.b "       MUSIC COMPOSITOR FOXCONED        ",-1

InsertCoin_IntroText6:		dc.b "     MUSIC COMPOSITOR MR. JOKER 27      ",-1

InsertCoin_IntroText7:		dc.b "            SPECIAL FOR THE             ",$81
						dc.b "       SONIC HACKING CONTEST 2021       ",-1

InsertCoin_IntroText8:		dc.b "    THANK YOU FOR STARTING THE GAME!    ",$81
						dc.b "                                        ",-1

InsertCoin_IntroText9:		dc.b "    YOU COULD NOT LIVE WITH YOUR OWN    ",$81
						dc.b "   FAILURE. WHERE DID THAT BRING YOU?   ",$81
						dc.b "             BACK TO ME...              ",-1

InsertCoin_IntroTextA:	dc.b "          I*LL DESTROY YOU...           ",-1













InsertCoin_ICText:		dc.b "              INSERT COIN               ",-1
InsertCoin_PSBText:		dc.b "           PRESS START BUTTON           ",-1
InsertCoin_MainText:		dc.b " SEGA @1994               HARDLINE 2021 ",-1
	even

		CHARSET ; reset character set
; ---------------------------------------------------------------------------

		include "Data/Screens/Insert Coin/Object Data/Map - Death Egg Small.asm"
		include "Data/Screens/Insert Coin/Object Data/Map - Robotnik Ship Crane.asm"
		include "Data/Screens/Insert Coin/Object Data/Map - Shot Ball.asm"
		include "Data/Screens/Insert Coin/Object Data/Map - Shot Ball Aim.asm"
		include "Data/Screens/Insert Coin/Object Data/Map - Tails Plane.asm"