; ---------------------------------------------------------------------------
; MiniGame Screen
; ---------------------------------------------------------------------------

; RAM
vMiniGame_Timer:			= Camera_RAM		; word
vMiniGame_CamMin:			= Camera_RAM+2	; word
vMiniGame_CamMax:			= Camera_RAM+4	; word
vMiniGame_CamVel:			= Camera_RAM+6	; long
vMiniGame_Count:			= Camera_RAM+$A	; byte
vMiniGame_End:				= Camera_RAM+$B	; byte
vMiniGame_Level:			= Camera_RAM+$C	; byte

; =============== S U B R O U T I N E =======================================

MiniGame_Screen:
		sfx	bgm_Stop,0,1,1
		bsr.w	Clear_Kos_Module_Queue
		bsr.w	Clear_Nem_Queue
		bsr.w	Pal_FadeToBlack
		disableInts
		move.w	(VDP_reg_1_command).w,d0
		andi.b	#$BF,d0
		move.w	d0,(VDP_control_port).l
		bsr.w	Clear_DisplayData
		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)					; Command $8004 - Disable HInt, HV Counter
		move.w	#$8200+(vram_fg>>10),(a6)	; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)	; Command $8407 - Nametable B at $E000
		move.w	#$8700+(2<<4),(a6)			; Command $8700 - BG color is Pal 0 Color 0
		move.w	#$8B00,(a6)					; Command $8B03 - Vscroll full, HScroll line-based
		move.w	#$8C00,(a6)					; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		sf	(SegaCD_Mode).w
		clearRAM Sprite_table_input, Sprite_table_input_End
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM Oscillating_variables, Oscillating_variables_End
		ResetDMAQueue































MiniGame_LoadGame:
		lea	PLC_MiniGame(pc),a1
		bsr.w	Load_PLC_Nem_Immediate

		lea	(MapEni_MiniGameFG).l,a0
		lea	(RAM_start).l,a1
		move.w	#$4001,d0
		bsr.w	EniDec
		copyTilemap	RAM_Start, (vram_fg|$100), 256, 224
		copyTilemap	RAM_Start, (vram_fg|$140), 256, 224
		lea	(MapEni_MiniGameBG).l,a0
		lea	(RAM_start).l,a1
		move.w	#$6031,d0
		bsr.w	EniDec
		copyTilemap	RAM_Start, (vram_bg), 256, 224
		copyTilemap	RAM_Start, (vram_bg|$40), 256, 224




		lea	(Pal_MiniGame).l,a1
		lea	(Target_palette_line_1).w,a2
		moveq	#(64/2)-1,d0
-		move.l	(a1)+,(a2)+
		dbf	d0,-

		music	bgm_GHZ,0,0,0
		move.l	#Obj_MiniSonic,(Object_RAM).w
		move.l	#Obj_Collision_Response_List,(Reserved_object_3).w
		move.l	#Obj_MiniHud,(v_Dust).w


		move.w	#-$10,(vMiniGame_CamMin).w
		move.w	#$180,(vMiniGame_CamMax).w

		move.b	#VintID_Main,(V_int_routine).w
		jsr	(DelayProgram).l
		bsr.w	Process_Sprites
		bsr.w	Render_Sprites
		move.w	(VDP_reg_1_command).w,d0
		ori.b	#$40,d0
		move.w	d0,(VDP_control_port).l
		jsr	(Pal_FadeTo).l

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(DelayProgram).l
		bsr.w	MiniGame_Deform
		disableInts
		bsr.w	MiniGame_SynchroAnimate
		enableInts
		bsr.s	Load_MiniEnemy
		bsr.w	Process_Sprites
		bsr.w	Render_Sprites
		tst.b	(vMiniGame_End).w
		beq.s	-
		sfx	bgm_Stop,0,1,1
		move.w	#2*60,(vMiniGame_Timer).w
		lea	MiniGameOver_Text(pc),a1
		locVRAM	$E082,d1
		move.w	#$8063,d3
		bsr.w	Load_PlaneText

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(DelayProgram).l
		subq.w	#1,(vMiniGame_Timer).w
		bpl.s	-

MiniGame_Return:
		rts
; ---------------------------------------------------------------------------
; MiniGame Deform
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MiniGame_Deform:
		move.w	(vMiniGame_CamVel).w,d0
		neg.w	d0
		move.w	d0,(H_scroll_buffer).w
		move.w	d0,(H_scroll_buffer+2).w
		asr.w	(H_scroll_buffer+2).w
		rts
; ---------------------------------------------------------------------------
; Load Mini Enemy
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Load_MiniEnemy:
		tst.b	(vMiniGame_Count).w
		bne.s	Load_MiniEnemy_Return
		subq.w	#1,(vMiniGame_Timer).w
		bpl.s	Load_MiniEnemy_Return

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
		move.w	(a2)+,x_pos(a1)
		move.b	(a2)+,anim(a1)
		addq.w	#1,a2
		move.b	d2,subtype(a1)
		addq.w	#2,d2
		dbf	d6,-
		move.w	#1*60,(vMiniGame_Timer).w
		cmpi.b	#((Load_MiniEnemy_DataIndex_End-Load_MiniEnemy_DataIndex)/2)-1,(vMiniGame_Level).w
		bne.s	Load_MiniEnemy_Return
		clr.b	(vMiniGame_Level).w

Load_MiniEnemy_Return:
		rts
; ---------------------------------------------------------------------------

Load_MiniEnemy_DataIndex: offsetTable
		offsetTableEntry.w Load_MiniEnemy_Data_Level1
		offsetTableEntry.w Load_MiniEnemy_Data_Level2
		offsetTableEntry.w Load_MiniEnemy_Data_Level1
		offsetTableEntry.w Load_MiniEnemy_Data_Level2
		offsetTableEntry.w Load_MiniEnemy_Data_Level3
		offsetTableEntry.w Load_MiniEnemy_Data_Level4
		offsetTableEntry.w Load_MiniEnemy_Data_Level1
		offsetTableEntry.w Load_MiniEnemy_Data_Level2
		offsetTableEntry.w Load_MiniEnemy_Data_Level5
		offsetTableEntry.w Load_MiniEnemy_Data_Level6
		offsetTableEntry.w Load_MiniEnemy_Data_Level5
		offsetTableEntry.w Load_MiniEnemy_Data_Level6
Load_MiniEnemy_DataIndex_End
; ---------------------------------------------------------------------------

Load_MiniEnemy_Data_Level1:
		dc.w 1-1		; Count
		dc.w $188	; Xpos
		dc.b 0, 0		; Badnik ID, Unused
Load_MiniEnemy_Data_Level2:
		dc.w 1-1
		dc.w $88
		dc.b 0, 0
Load_MiniEnemy_Data_Level3:
		dc.w 1-1
		dc.w $188
		dc.b 1, 0
Load_MiniEnemy_Data_Level4:
		dc.w 1-1
		dc.w $88
		dc.b 1, 0
Load_MiniEnemy_Data_Level5:
		dc.w 1-1
		dc.w $188
		dc.b 2, 0
Load_MiniEnemy_Data_Level6:
		dc.w 1-1
		dc.w $88
		dc.b 2, 0
; ---------------------------------------------------------------------------
; Mini Sonic
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_MiniSonic:
		move.l	#Map_MiniSonic,mappings(a0)
		move.w	#$100,art_tile(a0)
		move.w	#$100,priority(a0)
		move.w	#$100,x_pos(a0)
		move.w	#$130,y_pos(a0)
		move.b	#16/2,y_radius(a0)
		move.b	#16/2,x_radius(a0)
		move.b	#3,$30(a0)
		move.l	#MiniSonic_Main,address(a0)

MiniSonic_Main:
		bsr.w	MiniSonic_Camera
		tst.b	$31(a0)
		bne.s	MiniSonic_Main_Death
		tst.b	$3C(a0)
		bne.s	MiniSonic_Main_Hurt
		tst.b	$3A(a0)
		bne.s	MiniSonic_Main_SkipAttack
		bsr.w	MiniSonic_Attack

MiniSonic_Main_SkipAttack:
		tst.b	$39(a0)
		bne.s	MiniSonic_Main_Display
		bsr.w	MiniSonic_Speed
		bsr.w	MiniSonic_Walk
		bsr.w	MiniSonic_Jump
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
		move.b	$3B(a0),d0
		beq.s	MiniSonic_Main_Touch
		subq.b	#1,$3B(a0)
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
		tst.b	$39(a0)
		beq.s	MiniSonic_Animate_CheckJump
		moveq	#2,d0

MiniSonic_Animate_CheckJump:
		tst.b	$3A(a0)
		beq.s	MiniSonic_Animate_CheckHurt
		moveq	#3,d0

MiniSonic_Animate_CheckHurt:
		tst.b	$3C(a0)
		beq.s	MiniSonic_Animate_Set
		moveq	#4,d0

MiniSonic_Animate_Set:
		move.b	d0,anim(a0)

MiniSonic_Animate_Return:
		rts
; ---------------------------------------------------------------------------

MiniSonic_Camera:
		move.w	#$88,d0
		cmp.w	x_pos(a0),d0
		bgt.s	MiniSonic_Camera_StopMiniSonic
		move.w	#$178,d0
		cmp.w	x_pos(a0),d0
		bgt.s	MiniSonic_Camera_Vel

MiniSonic_Camera_StopMiniSonic:
		move.w	d0,x_pos(a0)
		clr.w	x_pos+2(a0)
		clr.w	x_vel(a0)

MiniSonic_Camera_Vel:
		move.w	(vMiniGame_CamMin).w,d0
		cmp.w	x_pos(a0),d0
		bgt.s	MiniSonic_Camera_StopMiniSonic_Vel
		move.w	(vMiniGame_CamMax).w,d0
		cmp.w	x_pos(a0),d0
		bgt.s	MiniSonic_Camera_Return

MiniSonic_Camera_StopMiniSonic_Vel:
		move.w	d0,$32(a0)
		clr.w	$34(a0)
		clr.w	x_vel(a0)

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

MiniSonic_Walk:
		move.w	x_vel(a0),d0
		beq.s	MiniSonic_Speed_Return
		bmi.s	MiniSonic_Walk_Neg
		subi.w	#$10,x_vel(a0)
		bra.s	MiniSonic_Walk_SetVel
; ---------------------------------------------------------------------------

MiniSonic_Walk_Neg:
		addi.w	#$10,x_vel(a0)

MiniSonic_Walk_SetVel:
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,$32(a0)
		move.w	$32(a0),d1
		sub.w	(vMiniGame_CamVel).w,d1

		move.w	d1,($FFFF6000).l
		move.w	$32(a0),($FFFF6010).l
		move.w	(vMiniGame_CamVel).w,($FFFF6020).l


		tst.w	d1
		blt.s		SH_SetScreen
		bge.s	MiniSonic_Walk_SetVel2
		rts
; ---------------------------------------------------------------------------

SH_SetScreen:
		add.w	(vMiniGame_CamVel).w,d1
		cmp.w	(vMiniGame_CamMin).w,d1
		bgt.s	loc_1C1121
		move.w	(vMiniGame_CamMin).w,d1
		cmpi.w	#$100,x_pos(a0)
		bgt.s	loc_1C1120

MiniSonic_Walk_SetVel3:
		add.l	d0,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

loc_1C1120:
		move.w	#$100,x_pos(a0)

loc_1C1121:
		move.w	d1,(vMiniGame_CamVel).w
		rts
; ---------------------------------------------------------------------------

MiniSonic_Walk_SetVel2:
		add.w	(vMiniGame_CamVel).w,d1
		cmp.w	(vMiniGame_CamMax).w,d1
		blt.s		loc_1C1121
		move.w	(vMiniGame_CamMax).w,d1
		cmpi.w	#$100,x_pos(a0)
		blt.s		loc_1C1120
		bra.s	MiniSonic_Walk_SetVel3
; ---------------------------------------------------------------------------

MiniSonic_Attack:
		tst.b	$39(a0)
		bne.s	MiniSonic_Attack_Clear
		move.b	(Ctrl_1_pressed).w,d1
		andi.b	#JoyB,d1
		beq.s	MiniSonic_Attack_Return
		sfx	sfx_AttackSMS,0,0,0
		move.w	#1*10,$2E(a0)
		st	$39(a0)
		clr.w	x_vel(a0)

MiniSonic_Walk_Return:
		rts
; ---------------------------------------------------------------------------

MiniSonic_Attack_Clear:
		subq.w	#1,$2E(a0)
		bpl.s	MiniSonic_Attack_Return
		sf	$39(a0)

MiniSonic_Attack_Return:
		rts
; ---------------------------------------------------------------------------

MiniSonic_Jump:
		tst.b	$3A(a0)
		bne.s	MiniSonic_Jump_Fall
		move.b	(Ctrl_1_pressed).w,d1
		andi.b	#JoyC,d1
		beq.s	MiniSonic_Jump_Return
		sfx	sfx_JumpSMS,0,0,0
		move.w	#-$380,y_vel(a0)
		st	$3A(a0)
		rts
; ---------------------------------------------------------------------------

MiniSonic_Jump_Fall:
		move.w	y_vel(a0),d0
		addi.w	#$20,y_vel(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,y_pos(a0)
		cmpi.w	#$12C,y_pos(a0)
		ble.s		MiniSonic_Jump_Return
		move.w	#$130,y_pos(a0)
		clr.w	y_vel(a0)
		sf	$3A(a0)

MiniSonic_Jump_Return:
		rts
; ---------------------------------------------------------------------------

MiniSonic_Hurt:
		move.w	x_vel(a0),d0
		bsr.w	MiniSonic_Walk_SetVel
		move.w	y_vel(a0),d0
		addi.w	#$20,y_vel(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,y_pos(a0)
		cmpi.w	#$12C,y_pos(a0)
		ble.s		MiniSonic_Hurt_Return
		move.w	#$130,y_pos(a0)
		clr.l	x_vel(a0)
		sf	$3C(a0)

MiniSonic_Hurt_Return:
		rts
; ---------------------------------------------------------------------------

MiniSonic_Death:
		move.w	x_vel(a0),d0
		bsr.w	MiniSonic_Walk_SetVel
		move.w	y_vel(a0),d0
		addi.w	#$20,y_vel(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,y_pos(a0)
		cmpi.w	#$1EC,y_pos(a0)
		ble.s		MiniSonic_Hurt_Return
		move.l	#Delete_Current_Sprite,address(a0)
		st	(vMiniGame_End).w

MiniSonic_Death_Return:
		rts
; ---------------------------------------------------------------------------
; Enemy
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_MiniEnemy:
		move.l	#Map_MiniEnemy,mappings(a0)
		move.w	#$140,art_tile(a0)
		move.w	#$180,priority(a0)
		move.w	#$130,y_pos(a0)
		move.b	#$B,collision_flags(a0)
		move.b	#3-1,collision_property(a0)
		move.l	#MiniEnemy_Main,address(a0)
		addq.b	#1,(vMiniGame_Count).w
		move.l	x_pos(a0),$30(a0)

MiniEnemy_Main:
		bsr.w	Find_SonicTails
		addi.w	#16,d2
		cmpi.w	#64,d2
		blo.s		MiniEnemy_Touch
		move.w	#$80,d1
		bclr	#0,status(a0)
		tst.w	d0
		bne.s	+
		neg.w	d1
		bset	#0,status(a0)
+		move.w	d1,x_vel(a0)

MiniEnemy_Touch:
		bsr.s	MiniEnemy_CheckTouch

MiniEnemy_Animate:
		lea	Ani_MiniEnemy(pc),a1
		bsr.w	AnimateSprite
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,$30(a0)
		move.l	$30(a0),d0
		move.w	(vMiniGame_CamVel).w,d1
		ext.l	d1
		swap	d1
		sub.l	d1,d0
		move.l	d0,x_pos(a0)
		move.w	y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,y_pos(a0)
		btst	#7,status(a0)
		beq.s	MiniEnemy_Draw
		bsr.s	MiniEnemy_CheckDelete

MiniEnemy_Draw:
		bra.w	Draw_And_Touch_Sprite
; ---------------------------------------------------------------------------

MiniEnemy_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	MiniEnemy_CheckTouch_Return
		tst.b	$1C(a0)
		bne.s	++
		move.b	#$10,$1C(a0)
		bsr.w	Find_SonicTails
		moveq	#8,d1
		tst.w	d0
		beq.s	+
		neg.w	d1
+		add.w	d1,$30(a0)
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
		cmpi.w	#$80,y_pos(a0)
		blo.s		MiniEnemy_Delete
		cmpi.w	#$68,x_pos(a0)
		blo.s		MiniEnemy_Delete
		cmpi.w	#$198,x_pos(a0)
		blo.s		MiniEnemy_Delete_Return

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
		move.w	#$170,art_tile(a0)
		move.w	#$90,x_pos(a0)
		move.w	#$98,y_pos(a0)
		move.l	#MiniHud_Main,address(a0)

MiniHud_Main:
		move.b	(Player_1+$30).w,d0
		andi.b	#3,d0
		move.b	d0,mapping_frame(a0)
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------
; Touch Response
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MiniGame_TouchResponse:
		tst.b	$39(a0)
		beq.s	.Touch_NoAttack
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		subi.w	#24,d2
		subi.w	#24,d3
		move.w	#48,d4
		move.w	#48,d5
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
		tst.b	$39(a0)
		bne.s	MiniGame_TouchResponse_MiniSonicAttack

MiniGame_Touch_ChkHurt:
		tst.b	$31(a0)
		bne.s	MiniGame_Touch_ChkHurt_Return
		tst.b	$3B(a0)
		bne.s	MiniGame_Touch_ChkHurt_Return
		sfx	sfx_DeathSMS,0,0,0
		move.w	#-$380,y_vel(a0)
		move.w	#-$100,x_vel(a0)
		move.w	x_pos(a0),d0
		cmp.w	x_pos(a1),d0
		blo.s		+
		neg.w	x_vel(a0)
+		move.b	#3*60,$3B(a0)
		st	$3C(a0)
		subq.b	#1,$30(a0)
		bne.s	MiniGame_Touch_ChkHurt_Return
		st	$31(a0)
		clr.b	$3B(a0)

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
		locVRAM	tiles_to_bytes($170),VDP_control_port-VDP_data_port(a6)
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

PLC_MiniGame:
		dc.w ((PLC_MiniGame_End-PLC_MiniGame)/6)-1
		plreq 1, ArtNem_MiniGameFG
		plreq $31, ArtNem_MiniGameBG
		plreq $64, ArtNem_MiniGameText
		plreq $100, ArtNem_MiniGameMiniSonic
		plreq $140, ArtNem_MiniGameMiniEnemy
PLC_MiniGame_End
; ---------------------------------------------------------------------------

	; set the character
		CHARSET ' ', 0
		CHARSET '0','9', 1
		CHARSET '*', $B
		CHARSET '@', $C
		CHARSET ':', $D
		CHARSET '.', $E
		CHARSET 'A','Z', $F
		CHARSET 'a','z', $F

MiniGameOver_Text:	dc.b "GAME OVER",-1
	even

		CHARSET ; reset character set

; ---------------------------------------------------------------------------

		include "Data/Screens/MiniGame/Object Data/Anim - Mini Sonic.asm"
		include "Data/Screens/MiniGame/Object Data/Anim - Enemy.asm"
		include "Data/Screens/MiniGame/Object Data/Map - Mini Sonic.asm"
		include "Data/Screens/MiniGame/Object Data/Map - Mini Enemy.asm"
		include "Data/Screens/MiniGame/Object Data/Map - Mini Ring.asm"
