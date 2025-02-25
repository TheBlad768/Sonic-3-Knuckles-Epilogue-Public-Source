; ---------------------------------------------------------------------------
; MiniGame Screen
; ---------------------------------------------------------------------------

; RAM
vMiniGame_Timer:			= Object_load_addr_front		; word
vMiniGame_Count:			= Object_load_addr_front+2	; byte
vMiniGame_End:				= Object_load_addr_front+3	; byte
vMiniGame_Level:			= Object_load_addr_front+4	; byte
														; byte
vMiniGame_HCount:			= Object_load_addr_front+6	; word
vMiniGame_HFactor:			= Object_load_addr_front+8	; word
vMiniGame_DCount:			= Object_load_addr_front+$A	; word
vMiniGame_Score:			= Object_load_addr_front+$10	; long
vMiniGame_Score_Update:		= Object_load_addr_front+$14	; byte
vMiniGame_SaveScore:		= Plane_Buffer				; long
vMiniGame_Cheat_flag:		= Plane_Buffer+4				; byte
vMiniGame_Cheat2_flag:		= Plane_Buffer+5				; byte
vMiniGame_Cheat3_flag:		= Plane_Buffer+6				; byte
vMiniGame_Cheat4_flag:		= Plane_Buffer+7				; byte

; =============== S U B R O U T I N E =======================================

MiniGame_Screen:
		sfx	bgm_Stop,0,1,1
		bsr.w	Clear_Kos_Module_Queue
		bsr.w	Clear_Nem_Queue
		bsr.w	Pal_FadeToBlack
		disableInts
		disableScreen
		bsr.w	Clear_DisplayData
		lea	(VDP_control_port).l,a6
		move.w	#$8014,(a6)								; Command $8004 - Disable HInt, HV Counter
		move.w	#$8200+(vram_fg>>10),(a6)				; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)				; Command $8407 - Nametable B at $E000
		move.w	#$8700+(2<<4),(a6)						; Command $8700 - BG color is Pal 0 Color 0
		move.w	#$8B03,(a6)								; Command $8B00 - Vscroll full, HScroll full
		move.w	#$8C00,(a6)								; Command $8C81 - 32cell screen size, no interlacing, no s/h
		move.w	#$9000,(a6)								; Command $9001 - 32x32 cell nametable area
		move.w	#$9200,(a6)								; Command $9200 - Window V position at default
		sf	(SegaCD_Mode).w
		clearRAM Sprite_table_input, Sprite_table_input_End
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM Oscillating_variables, Oscillating_variables_End
		ResetDMAQueue
		lea	PLC_MiniGameTitle(pc),a1
		bsr.w	Load_PLC_Nem_Immediate
		lea	(MapEni_MiniGameTitleFG).l,a0
		lea	(RAM_start).l,a1
		move.w	#$4001,d0
		bsr.w	Eni_Decomp
		copyTilemap3		RAM_Start, vram_fg, 256, 224
		music	bgm_TitleSMS,0,0,0
		lea	(Target_palette_line_3).w,a2
		move.l	#$0EA000EE,(a2)+
		move.l	#$0E840000,(a2)+
		move.l	#$0CEE0EEE,(a2)+
		move.w	#$0888,(a2)+
		move.l	#VInt_MiniGame,(V_int_addr).w
		move.l	#HInt_MiniGame,(H_int_addr).w
		move.w	#$8A00,(H_int_counter_command).w
		move.w	#-$80,(vMiniGame_HFactor).w
		move.b	#VintID_Main,(V_int_routine).w
		bsr.w	Wait_VSync
		addq.w	#1,(Level_frame_counter).w
		enableScreen
		bsr.w	Pal_FadeFromBlack

-		move.b	#VintID_Main,(V_int_routine).w
		bsr.w	Wait_VSync
		addq.w	#1,(Level_frame_counter).w
		tst.w	(vMiniGame_HFactor).w
		bne.s	-
		bsr.w	MiniGame_Code_Process
		tst.b	(Ctrl_1_pressed).w
		bpl.s	-

MiniGame_LoadGame:
		sfx	bgm_Stop,0,1,1
		bsr.w	Pal_FadeToBlack
		disableInts
		disableScreen
		bsr.w	Clear_DisplayData
		move.w	#$8004,VDP_control_port-VDP_control_port(a5)
		move.w	#$8A00+255,(H_int_counter_command).w
		move.l	#VInt,(V_int_addr).w
		move.l	#HInt,(H_int_addr).w
		lea	PLC_MiniGame(pc),a1
		bsr.w	Load_PLC_Nem_Immediate
		lea	MapDat_MiniGame(pc),a4
		bsr.w	MiniGame_LoadLevelData
		lea	(Pal_MiniGame).l,a1
		lea	(Target_palette_line_1).w,a2
		moveq	#(64/2)-1,d0
-		move.l	(a1)+,(a2)+
		dbf	d0,-
		moveq	#$20,d0
		move.w	d0,(Camera_X_pos).w
		move.w	d0,(Camera_X_pos_copy).w
		move.w	d0,(Camera_min_X_pos).w
		move.w	d0,(Camera_max_X_pos).w
		move.w	d0,(Saved_Camera_min_X_pos).w
		move.w	d0,(Saved_Camera_max_X_pos).w
		st	(vMiniGame_Score_Update).w
		move.w	#-1,(Screen_X_wrap_value).w
		move.w	#$7FF,(Screen_Y_wrap_value).w
		move.l	#Obj_MiniSonic,(Object_RAM).w
		move.l	#Obj_Collision_Response_List,(Reserved_object_3).w
		move.l	#Obj_MiniHud,(v_Dust).w
		bsr.w	MiniGame_HUDScore
		move.b	#VintID_Main,(V_int_routine).w
		bsr.w	Wait_VSync
		lea	MiniGameScore_Text(pc),a1
		locVRAM	$E068,d1
		move.w	#$80CF,d3
		bsr.w	Load_PlaneText
		addq.w	#1,(Level_frame_counter).w
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		bsr.w	MiniGame_Deform
		bsr.w	Process_Sprites
		bsr.w	Render_Sprites
		enableScreen
		bsr.w	Pal_FadeFromBlack

-		move.b	#VintID_Main,(V_int_routine).w
		bsr.w	Wait_VSync
		addq.w	#1,(Level_frame_counter).w
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		move.w	(Camera_X_pos_copy).w,(Camera_min_X_pos).w
		bsr.w	MiniGame_Deform
		disableInts
		bsr.w	MiniGame_HUDScore
		bsr.w	MiniGame_SynchroAnimate
		enableInts
		bsr.w	MiniGame_Resize
		bsr.w	Process_Sprites
		bsr.w	Render_Sprites
		tst.b	(vMiniGame_End).w
		beq.s	-
		sfx	bgm_Stop,0,1,1
		move.w	#2*60,(vMiniGame_Timer).w
		lea	MiniGameOver_Text(pc),a1
		locVRAM	$E042,d1
		move.w	#$80CF,d3
		bsr.w	Load_PlaneText

-		move.b	#VintID_Main,(V_int_routine).w
		bsr.w	Wait_VSync
		addq.w	#1,(Level_frame_counter).w
		subq.w	#1,(vMiniGame_Timer).w
		bpl.s	-
		bra.w	MiniGame_Screen
; ---------------------------------------------------------------------------
; Vertical interrupt handler
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

VInt_MiniGame:
		movem.l	d0-a6,-(sp)							; save all the registers to the stack
		tst.b	(V_int_routine).w
		beq.w	VInt_MiniGame_Music

-		move.w	(VDP_control_port).l,d0
		andi.w	#8,d0
		beq.s	-				; wait until vertical blanking is taking place
		sf	(V_int_routine).w
		clr.w	(vMiniGame_HCount).w
		tst.w	(vMiniGame_HFactor).w
		beq.s	+
		addq.w	#1,(vMiniGame_HFactor).w
+		bsr.w	Poll_Controllers
		dma68kToVDP Normal_palette,$0000,$80,CRAM
		dma68kToVDP Sprite_table_buffer,vram_sprites,$280,VRAM
		dma68kToVDP H_scroll_buffer,vram_hscroll,$380,VRAM
		move.w	(H_int_counter_command).w,(a5)

VInt_MiniGame_Music:
		SMPS_UpdateSoundDriver

VInt_MiniGame_Done:
		bsr.w	Random_Number
		addq.l	#1,(V_int_run_count).w
		movem.l	(sp)+,d0-a6
		rte
; ---------------------------------------------------------------------------
; Horizontal interrupt
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HInt_MiniGame:
		movem.l	d0-a6,-(sp)
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5

-		move.w	(VDP_control_port).l,d0
		andi.w	#4,d0					; is horizontal blanking occuring?
		beq.s	-						; if not, wait until it is
		move.w	(vMiniGame_HCount).w,d0
		addq.w	#1,(vMiniGame_HCount).w
		move.w	(vMiniGame_HFactor).w,d1
		muls.w	d1,d0
		asr.w	#6,d0
		sub.w	d1,d0
		move.l	#vdpComm($0000,VSRAM,WRITE),VDP_control_port-VDP_control_port(a5)
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		nop
		nop
		moveq	#$1F,d0
		dbf	d0,*
		movem.l	(sp)+,d0-a6
		tst.b	(Do_Updates_in_H_int).w
		beq.s	HInt_MiniGame_Done
		sf	(Do_Updates_in_H_int).w
		movem.l	d0-a6,-(sp)
		SMPS_UpdateSoundDriver
		movem.l	(sp)+,d0-a6

HInt_MiniGame_Done:
		rte
; ---------------------------------------------------------------------------
; Load Level
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MiniGame_LoadLevelData:
		moveq	#0,d1					; DEZ(Destroyed)
		tst.b	(vMiniGame_Cheat3_flag).w
		beq.s	.NoCheat3
		moveq	#1*$E,d1					; DEZ(Normal)

.NoCheat3:
		moveq	#bgm_DEZSMS,d0
		tst.b	(vMiniGame_Cheat_flag).w
		beq.s	.CheckCheat
		moveq	#2*$E,d1				; GHZ(Normal)
		move.w	#$8700+(3<<4),VDP_control_port-VDP_control_port(a5)
		moveq	#bgm_GHZSMS,d0

.CheckCheat:
		tst.b	(vMiniGame_Cheat2_flag).w
		beq.s	.NoCheat
		moveq	#0,d0

.NoCheat:
		bsr.w	PlaySound
		adda.w	d1,a4

; Load Art
		move.w	(a4),d0
		lea	(a4,d0.w),a1
		bsr.w	Load_PLC_Nem_Immediate
		addq.w	#2,a4

; Load BG
		movea.l	(a4)+,a0
		move.w	(a4)+,d0
		lea	(RAM_start).l,a1
		bsr.w	Eni_Decomp
		copyTilemap3		RAM_Start, vram_bg, 256, 224

; Load FG
		movea.l	(a4)+,a0
		move.w	(a4)+,d0
		lea	(RAM_start).l,a1
		bsr.w	Eni_Decomp
		copyTilemap3		RAM_Start, vram_fg, 256, 224

MiniGame_Deform_Return:
		rts
; ---------------------------------------------------------------------------
; Deform
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MiniGame_Deform:
		bsr.s	MiniGame_Deform2
		move.w	(HScroll_Shift).w,d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,(HScroll_Shift+2).w
		lea	MiniGameDEZ_BGDrawArray(pc),a4
		tst.b	(vMiniGame_Cheat_flag).w
		beq.s	+
		lea	MiniGameDEZ_BGDrawArray+4(pc),a4
+		lea	(H_scroll_table).w,a5
		bsr.w	ApplyDeformation
		move.w	(Camera_Y_pos_copy).w,(V_scroll_value).w
		move.w	(Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
		bra.w	ShakeScreen_Setup
; ---------------------------------------------------------------------------

MiniGame_Deform2:
		move.w	(Screen_shaking_flag+2).w,d0
		add.w	d0,(Camera_Y_pos_copy).w
		lea	MiniGameDEZ_ParallaxScript(pc),a1
		tst.b	(vMiniGame_Cheat_flag).w
		beq.s	+
		lea	MiniGameGHZ_ParallaxScript(pc),a1
+		bra.w	ExecuteParallaxScript
; ---------------------------------------------------------------------------

MiniGameDEZ_BGDrawArray:	dc.w 80, 70, $7FFF
; ---------------------------------------------------------------------------

MiniGameDEZ_ParallaxScript:
			; Mode	Speed coef.	Number of lines(Linear only)
		dc.w _normal,		 $0000		; BG
		dc.w	_moving|$03,	 $0050		; BG

MiniGameGHZ_ParallaxScript:
		dc.w _normal,		 $0000		; BG
		dc.w	-1
; ---------------------------------------------------------------------------
; HUD Score
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MiniGame_HUDScore:
		tst.b	(vMiniGame_Score_Update).w
		beq.s	MiniGame_HUDScore_Return
		clr.b	(vMiniGame_Score_Update).w
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		locVRAM	$E0EE,VDP_control_port-VDP_control_port(a5)
		move.l	(vMiniGame_Score).w,d0
		bsr.s	MiniGame_HUDScore_DrawNumbers
		move.l	(vMiniGame_Score).w,d0
		cmp.l	(vMiniGame_SaveScore).w,d0
		blt.s		MiniGame_HUDScore_DrawSaveScore
		move.l	d0,(vMiniGame_SaveScore).w

MiniGame_HUDScore_DrawSaveScore:
		move.l	(vMiniGame_SaveScore).w,d0
		locVRAM	$E06E,VDP_control_port-VDP_control_port(a5)

MiniGame_HUDScore_DrawNumbers:
		moveq	#8-1,d6
		move.w	#$80D0,d2

-		rol.l	#4,d0
		move.w	d0,d1
		andi.w	#$F,d1
		cmpi.w	#$A,d1
		blo.s		+
		addq.w	#6,d1
+		add.w	d2,d1
		move.w	d1,VDP_data_port-VDP_data_port(a6)
		dbf	d6,-

MiniGame_HUDScore_Return:
		rts
; ---------------------------------------------------------------------------
; Add Score
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MiniGame_HUD_AddToScore:
		st	(vMiniGame_Score_Update).w
		lea	(vMiniGame_Score).w,a3
		add.l	d0,(a3)
		move.l	#$FFFFFF0,d1
		cmp.l	(a3),d1
		bhi.s	.locret
		move.l	d1,(a3)

.locret:
		rts
; ---------------------------------------------------------------------------
; Cheat Code
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MiniGame_Code_Process:


		lea	MiniGame_CodeDat(pc),a1
		lea	(vMiniGame_DCount).w,a2
		lea	MiniGame_SetFirstCheatCode(pc),a3
		bsr.s	MiniGame_Code

		lea	MiniGame_Code2Dat(pc),a1
		lea	(vMiniGame_DCount+1).w,a2
		lea	MiniGame_SetSecondCheatCode(pc),a3
		bsr.s	MiniGame_Code

		lea	MiniGame_Code3Dat(pc),a1
		lea	(vMiniGame_DCount+2).w,a2
		lea	MiniGame_SetThirdCheatCode(pc),a3
		bsr.s	MiniGame_Code

		lea	MiniGame_Code4Dat(pc),a1
		lea	(vMiniGame_DCount+3).w,a2
		lea	MiniGame_SetFourthCheatCode(pc),a3
		bsr.s	MiniGame_Code




MiniGame_Code_Process_Return:
		rts
; ---------------------------------------------------------------------------

MiniGame_SetFirstCheatCode:
		eori.b	#-1,(vMiniGame_Cheat_flag).w
		rts
; ---------------------------------------------------------------------------

MiniGame_SetSecondCheatCode:
		moveq	#bgm_Fade,d0
		eori.b	#-1,(vMiniGame_Cheat2_flag).w
		bne.s	+
		moveq	#bgm_TitleSMS,d0
+		bra.w	PlaySound
; ---------------------------------------------------------------------------

MiniGame_SetThirdCheatCode:
		eori.b	#-1,(vMiniGame_Cheat3_flag).w
		rts
; ---------------------------------------------------------------------------

MiniGame_SetFourthCheatCode:
		eori.b	#-1,(vMiniGame_Cheat4_flag).w
		rts

; =============== S U B R O U T I N E =======================================

MiniGame_Code:
		moveq	#0,d0
		move.b	(a2),d0
		adda.w	d0,a1
		move.b	(Ctrl_1_pressed).w,d0
		andi.b	#$7F,d0
		beq.s	MiniGame_Code_Fall2
		move.b	(Ctrl_1).w,d0
		cmp.b	(a1),d0
		bne.s	MiniGame_Code_Fall
		addq.b	#1,(a2)
		tst.b	1(a1)
		bne.s	MiniGame_Code_Fall2
		sfx	sfx_Ring,0,0,0
		clr.b	(a2)
		jsr	(a3)
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

MiniGame_Code_Fall:
		clr.b	(a2)

MiniGame_Code_Fall2:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------
; Resize
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MiniGame_Resize:
		tst.b	(vMiniGame_Count).w
		bne.s	MiniGame_Resize_AddCamera
		bsr.w	Load_MiniEnemy
		cmpi.w	#$7FC0,(Saved_Camera_max_X_pos).w
		bhs.s	MiniGame_Resize_Return
		addi.w	#$40,(Saved_Camera_max_X_pos).w

MiniGame_Resize_AddCamera:
		move.w	(Player_1+x_pos).w,d0
		sub.w	(Camera_X_pos).w,d0
		cmpi.w	#$C0,d0
		blo.s		MiniGame_Resize_Return
		move.w	(Saved_Camera_max_X_pos).w,d0
		addq.w	#1,(Camera_max_X_pos).w
		cmp.w	(Camera_max_X_pos).w,d0
		bhs.s	MiniGame_Resize_Return
		move.w	(Saved_Camera_max_X_pos).w,(Camera_max_X_pos).w

MiniGame_Resize_Return:
		rts
; ---------------------------------------------------------------------------
; Load Mini Enemy
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Load_MiniEnemy:
;		tst.b	(vMiniGame_Count).w
;		bne.s	Load_MiniEnemy_Return
;		subq.w	#1,(vMiniGame_Timer).w
;		bpl.s	Load_MiniEnemy_Return

; Load Data
		moveq	#0,d0
		move.b	(vMiniGame_Level).w,d0
		addq.b	#1,(vMiniGame_Level).w
		add.w	d0,d0
		lea	Load_MiniEnemy_DataIndex(pc),a2
		move.w	(a2,d0.w),d0
		lea	(a2,d0.w),a2

; Load Badnik
		moveq	#0,d2
		move.w	(a2)+,d6
		bmi.s	Load_MiniEnemy_Return

-		bsr.w	Create_New_Sprite
		bne.s	Load_MiniEnemy_Return
		move.l	#Obj_MiniEnemy,address(a1)
		move.w	(Camera_X_pos).w,d1
		add.w	(a2)+,d1
		move.w	d1,x_pos(a1)
		move.b	(a2)+,anim(a1)
		addq.w	#1,a2
		move.b	d2,subtype(a1)
		addq.w	#2,d2
		dbf	d6,-

;		move.w	#1*60,(vMiniGame_Timer).w

		cmpi.b	#((Load_MiniEnemy_DataIndex_End-Load_MiniEnemy_DataIndex)/2),(vMiniGame_Level).w
		bne.s	Load_MiniEnemy_Return
		move.b	#((Load_MiniEnemy_DataIndex2-Load_MiniEnemy_DataIndex)/2),(vMiniGame_Level).w

Load_MiniEnemy_Return:
		rts
; ---------------------------------------------------------------------------

Load_MiniEnemy_DataIndex: offsetTable
		offsetTableEntry.w Load_MiniEnemy_Data_Level1
		offsetTableEntry.w Load_MiniEnemy_Data_Level2
		offsetTableEntry.w Load_MiniEnemy_Data_Level1
		offsetTableEntry.w Load_MiniEnemy_Data_Level4
		offsetTableEntry.w Load_MiniEnemy_Data_Level3
		offsetTableEntry.w Load_MiniEnemy_Data_Level2
		offsetTableEntry.w Load_MiniEnemy_Data_Level1
		offsetTableEntry.w Load_MiniEnemy_Data_Level6
		offsetTableEntry.w Load_MiniEnemy_Data_Level5
		offsetTableEntry.w Load_MiniEnemy_Data_Level6
		offsetTableEntry.w Load_MiniEnemy_Data_Level5
		offsetTableEntry.w Load_MiniEnemy_Data_Level7
		offsetTableEntry.w Load_MiniEnemy_Data_Level8

		offsetTableEntry.w Load_MiniEnemy_Data_Level9
		offsetTableEntry.w Load_MiniEnemy_Data_LevelA
		offsetTableEntry.w Load_MiniEnemy_Data_LevelB
		offsetTableEntry.w Load_MiniEnemy_Data_LevelC
		offsetTableEntry.w Load_MiniEnemy_Data_LevelD
		offsetTableEntry.w Load_MiniEnemy_Data_LevelE

; Hard
Load_MiniEnemy_DataIndex2
		offsetTableEntry.w Load_MiniEnemy_Data_LevelF
		offsetTableEntry.w Load_MiniEnemy_Data_Level10
		offsetTableEntry.w Load_MiniEnemy_Data_Level11
		offsetTableEntry.w Load_MiniEnemy_Data_Level12
Load_MiniEnemy_DataIndex_End
; ---------------------------------------------------------------------------

Load_MiniEnemy_Data_Level1:
		dc.w 1-1			; Count
		dc.w $198-$80	; Xpos
		dc.b 0, 0			; Badnik ID, Unused
Load_MiniEnemy_Data_Level2:
		dc.w 1-1
		dc.w $78-$80
		dc.b 0, 0
Load_MiniEnemy_Data_Level3:
		dc.w 1-1
		dc.w $198-$80
		dc.b 1, 0
Load_MiniEnemy_Data_Level4:
		dc.w 1-1
		dc.w $78-$80
		dc.b 1, 0
Load_MiniEnemy_Data_Level5:
		dc.w 1-1
		dc.w $198-$80
		dc.b 2, 0
Load_MiniEnemy_Data_Level6:
		dc.w 1-1
		dc.w $78-$80
		dc.b 2, 0
Load_MiniEnemy_Data_Level7:
		dc.w 1-1
		dc.w $198-$80
		dc.b 3, 0
Load_MiniEnemy_Data_Level8:
		dc.w 1-1
		dc.w $78-$80
		dc.b 3, 0

Load_MiniEnemy_Data_Level9:		; 2 enemy
		dc.w 2-1
		dc.w $78-$80
		dc.b 0, 0
		dc.w $198-$80
		dc.b 1, 0
Load_MiniEnemy_Data_LevelA:
		dc.w 2-1
		dc.w $78-$80
		dc.b 1, 0
		dc.w $198-$80
		dc.b 0, 0
Load_MiniEnemy_Data_LevelB:
		dc.w 2-1
		dc.w $78-$80
		dc.b 0, 0
		dc.w $198-$80
		dc.b 2, 0
Load_MiniEnemy_Data_LevelC:
		dc.w 2-1
		dc.w $78-$80
		dc.b 2, 0
		dc.w $198-$80
		dc.b 0, 0
Load_MiniEnemy_Data_LevelD:
		dc.w 2-1
		dc.w $78-$80
		dc.b 2, 0
		dc.w $198-$80
		dc.b 3, 0
Load_MiniEnemy_Data_LevelE:
		dc.w 2-1
		dc.w $78-$80
		dc.b 3, 0
		dc.w $198-$80
		dc.b 2, 0

Load_MiniEnemy_Data_LevelF:		; 3 enemy
		dc.w 3-1
		dc.w $78-$80
		dc.b 0, 0
		dc.w $198-$80
		dc.b 1, 0
		dc.w $198-$80
		dc.b 2, 0
Load_MiniEnemy_Data_Level10:
		dc.w 3-1
		dc.w $78-$80
		dc.b 2, 0
		dc.w $78-$80
		dc.b 1, 0
		dc.w $198-$80
		dc.b 0, 0
Load_MiniEnemy_Data_Level11:
		dc.w 3-1
		dc.w $78-$80
		dc.b 3, 0
		dc.w $198-$80
		dc.b 1, 0
		dc.w $198-$80
		dc.b 2, 0
Load_MiniEnemy_Data_Level12:
		dc.w 3-1
		dc.w $78-$80
		dc.b 2, 0
		dc.w $78-$80
		dc.b 1, 0
		dc.w $198-$80
		dc.b 3, 0
; ---------------------------------------------------------------------------
; Mini Sonic
; ---------------------------------------------------------------------------

obMS_Timer				= $2E	; .w
obMS_Hitcount			= $30	; .b
obMS_Invultimer			= $31	; .b

; status_secondary
Status_MS_Attack		= $00	; bit
Status_MS_Jump			= $01	; bit
Status_MS_Hurt			= $02	; bit
Status_MS_Death			= $03	; bit

; =============== S U B R O U T I N E =======================================

Obj_MiniSonic:
		lea	ObjDat3_MiniSonic(pc),a1
		bsr.w	SetUp_ObjAttributes
		move.w	(Camera_X_pos).w,d0
		addi.w	#$80,d0
		move.w	d0,x_pos(a0)
		move.w	#$B0,y_pos(a0)
		moveq	#16/2,d0
		move.b	d0,y_radius(a0)
		move.b	d0,x_radius(a0)
		move.b	#3,obMS_Hitcount(a0)
		move.l	#MiniSonic_Main,address(a0)

MiniSonic_Main:
		bsr.w	MiniSonic_Camera
		btst	#Status_MS_Death,status_secondary(a0)
		bne.s	MiniSonic_Main_Death
		bsr.w	MiniGame_MoveCameraX
		btst	#Status_MS_Hurt,status_secondary(a0)
		bne.s	MiniSonic_Main_Hurt
		btst	#Status_MS_Jump,status_secondary(a0)
		bne.s	MiniSonic_Main_SkipAttack
		bsr.w	MiniSonic_Attack

MiniSonic_Main_SkipAttack:
		btst	#Status_MS_Attack,status_secondary(a0)
		bne.s	MiniSonic_Main_Display
		bsr.w	MiniSonic_Jump
		bsr.w	MiniSonic_Speed
		bsr.w	MiniSonic_Deceleration
		bsr.w	MiniSonic_MoveObject
		bra.s	MiniSonic_Main_Display
; ---------------------------------------------------------------------------

MiniSonic_Main_Death:
		bsr.w	MiniSonic_Death
		bra.s	MiniSonic_Main_Display
; ---------------------------------------------------------------------------

MiniSonic_Main_Hurt:
		bsr.w	MiniSonic_Hurt

MiniSonic_Main_Display:
		lea	Ani_MiniSonic(pc),a1
		bsr.w	AnimateSprite
		bsr.s	MiniSonic_Animate
		move.b	obMS_Invultimer(a0),d0
		beq.s	MiniSonic_Main_Touch
		subq.b	#1,obMS_Invultimer(a0)
		lsr.b	#3,d0
		bcc.w	MiniGame_TouchResponse

MiniSonic_Main_Touch:
		bsr.w	MiniGame_TouchResponse

MiniSonic_Main_Draw:
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

MiniSonic_Animate:
		moveq	#0,d0
		tst.w	x_vel(a0)
		beq.s	MiniSonic_Animate_CheckAttack
		moveq	#1,d0

MiniSonic_Animate_CheckAttack:
		btst	#Status_MS_Attack,status_secondary(a0)
		beq.s	MiniSonic_Animate_CheckJump
		moveq	#2,d0

MiniSonic_Animate_CheckJump:
		btst	#Status_MS_Jump,status_secondary(a0)
		beq.s	MiniSonic_Animate_CheckHurt
		moveq	#3,d0

MiniSonic_Animate_CheckHurt:
		btst	#Status_MS_Hurt,status_secondary(a0)
		beq.s	MiniSonic_Animate_Set
		moveq	#4,d0

MiniSonic_Animate_Set:
		move.b	d0,anim(a0)

MiniSonic_Animate_Return:
		rts
; ---------------------------------------------------------------------------

MiniSonic_Camera:
		move.l	x_pos(a0),d1
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(Camera_min_X_pos).w,d0
		addq.w	#8,d0
		cmp.w	d1,d0
		bhi.s	MiniSonic_Camera_StopMiniSonic
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#256-8,d0
		cmp.w	d1,d0
		bhs.s	MiniSonic_Camera_Return

MiniSonic_Camera_StopMiniSonic:
		move.w	d0,x_pos(a0)
		clr.w	2+x_pos(a0)
		clr.w	x_vel(a0)
		clr.w	ground_vel(a0)

MiniSonic_Camera_Return:
		rts
; ---------------------------------------------------------------------------

MiniSonic_Speed:
		move.b	(Ctrl_1_held).w,d1
		btst	#button_left,d1
		beq.s	+
		bset	#0,status(a0)
		cmpi.w	#-$180,x_vel(a0)
		ble.s		+
		subi.w	#$20,x_vel(a0)
+		btst	#button_right,d1
		beq.s	MiniSonic_Speed_Return
		bclr	#0,status(a0)
		cmpi.w	#$180,x_vel(a0)
		bge.s	MiniSonic_Speed_Return
		addi.w	#$20,x_vel(a0)

MiniSonic_Speed_Return:
		rts
; ---------------------------------------------------------------------------

MiniSonic_MoveObject:
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

MiniSonic_Deceleration:
		move.b	(Ctrl_1_held).w,d0
		andi.b	#$C,d0
		bne.s	.loc_11332
		move.w	#$80,d5
		move.w	x_vel(a0),d0
		beq.s	.loc_11332
		bmi.s	.loc_11326
		sub.w	d5,d0
		bcc.s	.loc_11320
		move.w	#0,d0

.loc_11320:
		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

.loc_11326:
		add.w	d5,d0
		bcc.s	.loc_1132E
		move.w	#0,d0

.loc_1132E:
		move.w	d0,x_vel(a0)

.loc_11332:
		rts
; ---------------------------------------------------------------------------

MiniSonic_Attack:
		btst	#Status_MS_Attack,status_secondary(a0)
		bne.s	MiniSonic_Attack_Clear
		move.b	(Ctrl_1_pressed).w,d1
		andi.b	#JoyB,d1
		beq.s	MiniSonic_Attack_Return
		bset	#Status_MS_Attack,status_secondary(a0)
		sfx	sfx_AttackSMS,0,0,0
		move.w	#1*10,obMS_Timer(a0)
		clr.w	x_vel(a0)
		rts
; ---------------------------------------------------------------------------

MiniSonic_Attack_Clear:
		subq.w	#1,obMS_Timer(a0)
		bpl.s	MiniSonic_Attack_Return
		bclr	#Status_MS_Attack,status_secondary(a0)

MiniSonic_Attack_Return:
		rts
; ---------------------------------------------------------------------------

MiniSonic_Jump:
		btst	#Status_MS_Jump,status_secondary(a0)
		bne.s	MiniSonic_Jump_Fall
		move.b	(Ctrl_1_pressed).w,d1
		andi.b	#JoyC,d1
		beq.s	MiniSonic_Jump_Return
		bset	#Status_MS_Jump,status_secondary(a0)
		sfx	sfx_JumpSMS,0,0,0
		move.w	#-$380,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

MiniSonic_Jump_Fall:
		move.w	y_vel(a0),d0
		addi.w	#$20,y_vel(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,y_pos(a0)
		move.w	#$B0,d0
		cmp.w	y_pos(a0),d0
		bge.s	MiniSonic_Jump_Return
		move.w	d0,y_pos(a0)
		bclr	#Status_MS_Jump,status_secondary(a0)
		clr.w	y_vel(a0)

MiniSonic_Jump_Return:
		rts
; ---------------------------------------------------------------------------

MiniSonic_Hurt:
		bsr.w	MoveSprite_LightGravity
		move.w	#$B0,d0
		cmp.w	y_pos(a0),d0
		bge.s	MiniSonic_Hurt_Return
		move.w	d0,y_pos(a0)
		bclr	#Status_MS_Hurt,status_secondary(a0)
		clr.l	x_vel(a0)

MiniSonic_Hurt_Return:
		rts
; ---------------------------------------------------------------------------

MiniSonic_Death:
		bsr.w	MoveSprite_LightGravity
		tst.b render_flags(a0)					; Object visible on the screen?
		bmi.s	MiniSonic_Death_Return		; If yes, branch
		move.l	#Delete_Current_Sprite,address(a0)
		st	(vMiniGame_End).w

MiniSonic_Death_Return:
		rts

; =============== S U B R O U T I N E =======================================

MiniGame_MoveCameraX:
		lea	(Camera_X_pos).w,a1
		lea	(Camera_min_X_pos).w,a2
		move.w	x_pos(a0),d0
		sub.w	(a1),d0
		subi.w	#256/2,d0
		blt.s		.loc_1C0E8
		bge.s	.loc_1C0FC
		rts
; ---------------------------------------------------------------------------

.loc_1C0E8:
		cmpi.w	#-16,d0
		bgt.s	.skip
		move.w	#-16,d0

.skip:
		add.w	(a1),d0
		cmp.w	(a2),d0
		bgt.s	.loc_1C112
		move.w	(a2),d0
		bra.s	.loc_1C112
; ---------------------------------------------------------------------------

.loc_1C0FC:
		cmpi.w	#16,d0
		blo.s		.skip2
		move.w	#16,d0

.skip2:
		add.w	(a1),d0
		cmp.w	Camera_max_X_pos-Camera_min_X_pos(a2),d0
		blt.s		.loc_1C112
		move.w	Camera_max_X_pos-Camera_min_X_pos(a2),d0

.loc_1C112:
		move.w	d0,(a1)
		rts
; ---------------------------------------------------------------------------
; Enemy
; ---------------------------------------------------------------------------

MiniEnemy_Data:		dc.w -$80, -$100, -$180, -$80

; =============== S U B R O U T I N E =======================================

Obj_MiniEnemy:
		moveq	#0,d0
		move.b	anim(a0),d0
		add.w	d0,d0
		move.w	MiniEnemy_Data(pc,d0.w),$30(a0)
		lea	ObjDat3_MiniEnemy(pc),a1
		bsr.w	SetUp_ObjAttributes
		move.w	#$B0,y_pos(a0)
-		bsr.w	Random_Number
		andi.w	#3,d0
		beq.s	-
		move.w	d0,d1
		add.w	d0,d0
		move.b	d0,collision_property(a0)
		move.b	d1,$32(a0)
		move.l	#MiniEnemy_Main,address(a0)
		addq.b	#1,(vMiniGame_Count).w

MiniEnemy_Main:
		lea	(Player_1).w,a1
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		bsr.w	GetArcTan
		bsr.w	GetSineCosine
		muls.w	$30(a0),d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		bsr.w	Find_SonicTails
		bclr	#0,status(a0)
		tst.w	d0
		bne.s	MiniEnemy_Touch
		bset	#0,status(a0)

MiniEnemy_Touch:
		bsr.w	MiniEnemy_CheckTouch

MiniEnemy_Animate:
		lea	Ani_MiniEnemy(pc),a1
		bsr.w	AnimateSprite
		bsr.w	MoveSprite2
		bsr.w	MiniEnemy_CheckDelete
		bra.w	Draw_And_Touch_Sprite
; ---------------------------------------------------------------------------

MiniEnemy_Bounce:
		move.w	#$B0,d0
		cmp.w	y_pos(a0),d0
		bge.s	MiniEnemy_Bounce_Touch
		move.w	d0,y_pos(a0)
		sfx	sfx_AttackSMS,0,0,0
		move.w	#4,(Screen_shaking_flag).w
		move.l	#MiniEnemy_BounceFall,address(a0)

MiniEnemy_Bounce_Touch:
		bsr.s	MiniEnemy_CheckTouch
		lea	Ani_MiniEnemy(pc),a1
		bsr.w	AnimateSprite
		bsr.w	MoveSprite
		bra.w	Draw_And_Touch_Sprite
; ---------------------------------------------------------------------------

MiniEnemy_BounceFall:
		move.l	#MiniEnemy_Bounce,address(a0)
		move.w	y_vel(a0),d0
		bmi.w	MiniEnemy_Bounce_Touch
		cmpi.w	#$180,d0
		bhs.s	MiniEnemy_BounceFall2
		clr.l	x_vel(a0)
		move.w	#$B0,y_pos(a0)
		move.l	#MiniEnemy_Main,address(a0)
		bra.w	MiniEnemy_Touch
; ---------------------------------------------------------------------------

MiniEnemy_BounceFall2:
		asr.w	d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		bra.s	MiniEnemy_Bounce_Touch
; ---------------------------------------------------------------------------

MiniEnemy_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	MiniEnemy_CheckTouch_Return
		tst.b	$1C(a0)
		bne.s	+
		move.b	#$10,$1C(a0)
		move.w	x_vel(a0),d0
		asr.w	#4,d0
		sub.w	d0,x_pos(a0)
		moveq	#$10,d0
		bsr.w	MiniGame_HUD_AddToScore
		move.b	collision_property(a0),d0
		cmp.b	$32(a0),d0
		bne.s	+
		move.b	#$60,$1C(a0)
		moveq	#$50,d0
		bsr.w	MiniGame_HUD_AddToScore
		move.l	#MiniEnemy_Bounce,address(a0)
		move.w	#-$300,y_vel(a0)
		move.w	#$100,x_vel(a0)
		btst	#0,status(a0)
		bne.s	+
		neg.w	x_vel(a0)
+		btst	#0,$1C(a0)
		bne.s	+
		eori.b	#$20,art_tile(a0)
+		subq.b	#1,$1C(a0)
		bne.s	MiniEnemy_CheckTouch_Return
		move.b	collision_restore_flags(a0),collision_flags(a0)

MiniEnemy_CheckTouch_Return:
		rts

; =============== S U B R O U T I N E =======================================

MiniEnemy_CheckDelete:
		btst	#7,status(a0)
		beq.s	MiniEnemy_Delete_Return
		tst.b render_flags(a0)					; Object visible on the screen?
		bmi.s	MiniEnemy_Delete_Return		; If yes, branch

MiniEnemy_Delete:
		subq.b	#1,(vMiniGame_Count).w
		move.l	#Delete_Current_Sprite,address(a0)
		addq.w	#4,sp

MiniEnemy_Delete_Return:
		rts
; ---------------------------------------------------------------------------
; Mini Hud
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_MiniHud:
		move.l	#Map_MiniRing,mappings(a0)
		move.w	#$F8,art_tile(a0)
		move.w	#$90,x_pos(a0)
		move.w	#$98,y_pos(a0)
		move.l	#MiniHud_Main,address(a0)

MiniHud_Main:
		move.b	(Player_1+obMS_Hitcount).w,d0
		andi.b	#3,d0
		move.b	d0,mapping_frame(a0)
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------
; Touch Response
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MiniGame_TouchResponse:
		btst	#Status_MS_Attack,status_secondary(a0)
		beq.s	.Touch_NoAttack
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		subi.w	#24,d2
		subi.w	#24,d3
		move.w	#40,d4
		move.w	#40,d5
		bra.s	.Touch_Process
; ---------------------------------------------------------------------------

.Touch_NoAttack:
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		subq.w	#8,d2
		moveq	#0,d5
		move.b	y_radius(a0),d5
		subq.b	#3,d5
		sub.w	d5,d3
		move.w	#16,d4
		add.w	d5,d5

.Touch_Process:
		lea	(Collision_response_list).w,a4
		move.w	(a4)+,d6
		beq.s	MiniGame_Touch_Return

MiniGame_Touch_Loop:
		movea.w	(a4)+,a1
		move.b	collision_flags(a1),d0
		bne.s	MiniGame_Touch_Width

MiniGame_Touch_NextObj:
		subq.w	#2,d6
		bne.s	MiniGame_Touch_Loop
		moveq	#0,d0

MiniGame_Touch_Return:
		rts
; ---------------------------------------------------------------------------

MiniGame_Touch_Width:
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	Touch_Sizes(pc),a2
		lea	(a2,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	x_pos(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	.checkrightside
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	MiniGame_Touch_Height
		bra.s	MiniGame_Touch_NextObj
; ---------------------------------------------------------------------------

.checkrightside:
		cmp.w	d4,d0
		bhi.s	MiniGame_Touch_NextObj

MiniGame_Touch_Height:
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	y_pos(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	.checktop
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	MiniGame_Touch_ChkValue
		bra.s	MiniGame_Touch_NextObj
; ---------------------------------------------------------------------------

.checktop:
		cmp.w	d5,d0
		bhi.s	MiniGame_Touch_NextObj

MiniGame_Touch_ChkValue:
		move.b	collision_flags(a1),d1
		andi.b	#$C0,d1
		beq.s	MiniGame_TouchResponse_Check
		tst.b	d1
		bmi.s	MiniGame_Touch_ChkHurt
		rts
; ---------------------------------------------------------------------------

MiniGame_TouchResponse_Check:
		btst	#Status_MS_Attack,status_secondary(a0)
		bne.s	MiniGame_TouchResponse_MiniSonicAttack

MiniGame_Touch_ChkHurt:
		btst	#Status_MS_Death,status_secondary(a0)
		bne.s	MiniGame_Touch_ChkHurt_Return
		tst.b	obMS_Invultimer(a0)
		bne.s	MiniGame_Touch_ChkHurt_Return
		sfx	sfx_DeathSMS,0,0,0
		move.w	#-$380,y_vel(a0)
		move.w	#-$100,x_vel(a0)
		move.w	x_pos(a0),d0
		cmp.w	x_pos(a1),d0
		blo.s		+
		neg.w	x_vel(a0)
+		move.b	#3*60,obMS_Invultimer(a0)
		bset	#Status_MS_Hurt,status_secondary(a0)
		subq.b	#1,obMS_Hitcount(a0)
		bne.s	MiniGame_Touch_ChkHurt_Return
		bset	#Status_MS_Death,status_secondary(a0)
		clr.b	obMS_Invultimer(a0)

MiniGame_Touch_ChkHurt_Return:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

MiniGame_TouchResponse_MiniSonicAttack:
		move.b	status(a0),d0
		andi.b	#1,d0
		move.b	status(a1),d1
		andi.b	#1,d1
		sub.b	d0,d1
		beq.s	MiniGame_TouchResponse_MiniSonicAttack_Return
		move.w	#$14,(Screen_shaking_flag).w
		tst.b	collision_property(a1)
		beq.s	MiniGame_Touch_EnemyNormal
		move.b	collision_flags(a1),collision_restore_flags(a1)	; Save collision_flags
		clr.b	collision_flags(a1)
		subq.b	#1,collision_property(a1)
		bne.s	MiniGame_TouchResponse_MiniSonicAttack_Return
		bset	#7,status(a1)

MiniGame_TouchResponse_MiniSonicAttack_Return:
		rts
; ---------------------------------------------------------------------------

MiniGame_Touch_EnemyNormal:
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		bsr.w	GetArcTan
		bsr.w	GetSineCosine
		move.w	#-$800,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a1)
		move.w	d2,y_vel(a1)
		clr.b	collision_flags(a1)
		bset	#7,status(a1)
		move.w	#$100,d0
		bsr.w	MiniGame_HUD_AddToScore
		move.l	#MiniEnemy_Animate,address(a1)
		bra.s	MiniGame_Touch_ChkHurt_Return

; =============== S U B R O U T I N E =======================================

MiniGame_SynchroAnimate:
		subq.b	#1,(Rings_frame_timer).w
		bpl.s	MiniGame_SynchroAnimate_Return
		move.b	#7,(Rings_frame_timer).w
		addq.b	#1,(Rings_frame).w
		cmpi.b	#(ArtUnc_MiniGameMiniRing_End-ArtUnc_MiniGameMiniRing)>>7,(Rings_frame).w
		bne.s	.Sync
		clr.b	(Rings_frame).w

; Dynamic graphics
.Sync:
		lea	(VDP_data_port).l,a6
		locVRAM	tiles_to_bytes($F8),VDP_control_port-VDP_data_port(a6)
		moveq	#0,d0
		lea	(ArtUnc_MiniGameMiniRing).l,a1
		move.b	(Rings_frame).w,d0
		lsl.w	#7,d0
		adda.l	d0,a1

	rept (8*4)
		move.l	(a1)+,VDP_data_port-VDP_data_port(a6)
	endm

MiniGame_SynchroAnimate_Return:
		rts
; ---------------------------------------------------------------------------

MapDat_MiniGame:

; Level 1	; $00
		dc.w PLC_MiniGameDEZ-*
		dc.l MapEni_MiniGameDEZBG
		dc.w $406C
		dc.l MapEni_MiniGameDEZFG
		dc.w $4001

; Level 2	; $0E
		dc.w PLC_MiniGameDEZ2-*
		dc.l MapEni_MiniGameDEZBG
		dc.w $4058
		dc.l MapEni_MiniGameDEZFG2
		dc.w $4001

; Level 3	; $1C
		dc.w PLC_MiniGameGHZ-*
		dc.l MapEni_MiniGameGHZBG
		dc.w $6031
		dc.l MapEni_MiniGameGHZFG
		dc.w $6001
; ---------------------------------------------------------------------------

ObjDat3_MiniSonic:
		dc.l Map_MiniSonic
		dc.w $100
		dc.w $80
		dc.b 32/2
		dc.b 32/2
		dc.b 0
		dc.b 0
ObjDat3_MiniEnemy:
		dc.l Map_MiniEnemy
		dc.w $140
		dc.w $100
		dc.b 32/2
		dc.b 32/2
		dc.b 0
		dc.b $B
; ---------------------------------------------------------------------------

PLC_MiniGameTitle:
		dc.w ((PLC_MiniGameTitle_End-PLC_MiniGameTitle)/6)-1
		plreq 1, ArtNem_MiniGameTitleFG
PLC_MiniGameTitle_End

PLC_MiniGameDEZ:
		dc.w ((PLC_MiniGameDEZ_End-PLC_MiniGameDEZ)/6)-1
		plreq 1, ArtNem_MiniGameDEZFG
		plreq $6C, ArtNem_MiniGameDEZBG
PLC_MiniGameDEZ_End

PLC_MiniGameDEZ2:
		dc.w ((PLC_MiniGameDEZ2_End-PLC_MiniGameDEZ2)/6)-1
		plreq 1, ArtNem_MiniGameDEZFG2
		plreq $58, ArtNem_MiniGameDEZBG
PLC_MiniGameDEZ2_End

PLC_MiniGameGHZ:
		dc.w ((PLC_MiniGameGHZ_End-PLC_MiniGameGHZ)/6)-1
		plreq 1, ArtNem_MiniGameGHZFG
		plreq $31, ArtNem_MiniGameGHZBG
PLC_MiniGameGHZ_End

PLC_MiniGame:
		dc.w ((PLC_MiniGame_End-PLC_MiniGame)/6)-1
		plreq $D0, ArtNem_MiniGameText
		plreq $100, ArtNem_MiniGameMiniSonic
		plreq $140, ArtNem_MiniGameMiniEnemy
PLC_MiniGame_End
MiniGame_CodeDat:
		dc.b btnUp, btnDn, btnL, btnR
		dc.b 0		; Stop
MiniGame_Code2Dat:
		dc.b btnDn, btnDn, btnDn, btnDn
		dc.b 0		; Stop
MiniGame_Code3Dat:
		dc.b btnUp, btnUp, btnDn, btnDn, btnL, btnR, btnL, btnR, btnB, btnA
		dc.b 0		; Stop
MiniGame_Code4Dat:
		dc.b btnA, btnC, btnUp, btnB, btnUp, btnB, btnA, btnDn
		dc.b 0		; Stop
	even
; ---------------------------------------------------------------------------

	; set the character
		CHARSET ' ', 0
		CHARSET '0','9', 1
		CHARSET '*', $B
		CHARSET '@', $C
		CHARSET ':', $D
		CHARSET '.', $E
		CHARSET '!', $F
		CHARSET '$', $10
		CHARSET 'A','Z', $11
		CHARSET 'a','z', $11

MiniGameScore_Text:
		dc.b "HI",$80
		dc.b "1P",-1
MiniGameWin_Text:	dc.b "YOU$RE WINNER!",-1
MiniGameOver_Text:	dc.b "GAME OVER",-1
	even

		CHARSET ; reset character set

; ---------------------------------------------------------------------------

		include "Data/Screens/MiniGame/Object Data/Anim - Mini Sonic.asm"
		include "Data/Screens/MiniGame/Object Data/Anim - Enemy.asm"
		include "Data/Screens/MiniGame/Object Data/Map - Mini Sonic.asm"
		include "Data/Screens/MiniGame/Object Data/Map - Mini Enemy.asm"
		include "Data/Screens/MiniGame/Object Data/Map - Mini Ring.asm"