; ---------------------------------------------------------------------------
; Маленький босс-шар (Intro)
; ---------------------------------------------------------------------------

; Dynamic object variables
obBGB_Frame			= $30	; .b

; =============== S U B R O U T I N E =======================================

Obj_MiniOrbinaut:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	MiniOrbinaut_Index(pc,d0.w),d0
		jsr	MiniOrbinaut_Index(pc,d0.w)
		moveq	#0,d0
		move.b	obBGB_Frame(a0),d0
		tst.w	x_vel(a0)
		beq.s	+
		bpl.s	++
+		addq.w	#2,d0
+		move.b	d0,mapping_frame(a0)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

MiniOrbinaut_Index: offsetTable
		offsetTableEntry.w MiniOrbinaut_Init	; 0
		offsetTableEntry.w MiniOrbinaut_Setup	; 2
		offsetTableEntry.w MiniOrbinaut_Setup2	; 4
		offsetTableEntry.w MiniOrbinaut_Setup3	; 6
; ---------------------------------------------------------------------------

MiniOrbinaut_Init:
		lea	ObjDat3_MiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$11F,$2E(a0)
		move.l	#MiniOrbinaut_Intro_Start,$34(a0)
		lea	(ArtKosM_MiniOrbinaut).l,a1
		move.w	#tiles_to_bytes($1F0),d2
		jsr	(Queue_Kos_Module).w

MiniOrbinaut_Setup:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

MiniOrbinaut_Setup2:
		bsr.w	MiniOrbinaut_CheckTouch

MiniOrbinaut_Setup3:
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w

; =============== S U B R O U T I N E =======================================

MiniOrbinaut_Intro_Start:
		move.w	#3,$2E(a0)
		moveq	#1,d0
		jsr	(AddRings).w
		moveq	#10,d0
		cmp.w	(Ring_count).w,d0
		bhs.s	MiniOrbinaut_Intro_Start_Return
		move.w	d0,(Ring_count).w
		move.w	#7,$2E(a0)
		move.l	#MiniOrbinaut_Intro_SetSonicPosition,$34(a0)

MiniOrbinaut_Intro_Start_Return:
		rts
; ---------------------------------------------------------------------------

MiniOrbinaut_Intro_SetSonicPosition:
		st	(Ctrl_1_locked).w
		st	(NoPause_flag).w
		move.l	#MiniOrbinaut_Intro_CheckSonicPosition,$34(a0)

MiniOrbinaut_Intro_CheckSonicPosition:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		move.w	#btnL<<8,d1
		addi.w	#$40,d0
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s		+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		rts
; ---------------------------------------------------------------------------
+		btst	#Status_InAir,status(a1)
		bne.s	-
		move.b	#_Setup2,routine(a0)
		move.l	#MiniOrbinaut_Intro_SetPosition,$34(a0)
		music	bgm_MidBoss,0,0,0
		clr.w	(Ctrl_1_logical).w
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)
		move.w	#id_Wait2<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jmp	(Stop_Object).w
; ---------------------------------------------------------------------------

MiniOrbinaut_Intro_SetPosition:
		move.w	#-$100,x_vel(a0)
		move.w	#-$400,y_vel(a0)
		sfx	sfx_Bumper2,0,0,0
		move.w	(Camera_X_pos).w,d0
		addi.w	#$100,d0
		sub.w	x_pos(a0),d0
		blo.s		MiniOrbinaut_Intro_SetPosition_Return
		move.b	#_Setup1,routine(a0)
		move.l	#MiniOrbinaut_Intro_SetPosition_Return,$34(a0)
		clr.l	x_vel(a0)
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	MiniOrbinaut_Intro_SetPosition_Return
		move.b	#_MiniOrbinautStart,routine(a1)
		move.l	#DialogMiniOrbinautStart_Process_Index-4,$34(a1)
		move.b	#(DialogMiniOrbinautStart_Process_Index_End-DialogMiniOrbinautStart_Process_Index)/8,$39(a1)

MiniOrbinaut_Intro_SetPosition_Return:
		rts
; ---------------------------------------------------------------------------

MiniOrbinaut_Intro_FindSonic:
		move.w	(Player_1+x_pos).w,d0
		sub.w	x_pos(a0),d0
		asl.w	#3,d0
		move.w	d0,x_vel(a0)
		move.w	#-$400,y_vel(a0)
		sfx	sfx_Bumper2,0,0,0
		tst.b	(QuickStart_mode).w
		bne.s	MiniOrbinaut_Intro_SetPosition_Return
		subq.b	#1,$39(a0)
		bne.s	MiniOrbinaut_Intro_SetPosition_Return

MiniOrbinaut_Intro_AltWay:
		move.b	#_Setup1,routine(a0)
		move.l	#MiniOrbinaut_Intro_AltWay_CheckSonicPosition,$34(a0)
		st	(Ctrl_1_locked).w
		st	(NoPause_flag).w
		clr.l	x_vel(a0)
		rts
; ---------------------------------------------------------------------------

MiniOrbinaut_Intro_AltWay_CheckSonicPosition:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		move.w	#btnL<<8,d1
		addi.w	#$40,d0
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s		+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		rts
; ---------------------------------------------------------------------------
+		btst	#Status_InAir,status(a1)
		bne.s	-
		sfx	bgm_Fade,0,0,0
		move.b	#_Setup1,routine(a0)
		move.w	#$1F,$2E(a0)
		move.l	#MiniOrbinaut_Intro_AltWay_WaitSetPosition,$34(a0)
		clr.w	(Ctrl_1_logical).w
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)
		move.w	#id_Wait2<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jmp	(Stop_Object).w
; ---------------------------------------------------------------------------

MiniOrbinaut_Intro_AltWay_WaitSetPosition:
		move.b	#_Setup3,routine(a0)
		move.l	#MiniOrbinaut_Intro_AltWay_SetPosition,$34(a0)
		rts
; ---------------------------------------------------------------------------

MiniOrbinaut_Intro_AltWay_SetPosition:
		move.w	#-$400,y_vel(a0)
		move.w	#-$100,x_vel(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$110,d0
		sub.w	x_pos(a0),d0
		ble.s		+
		neg.w	x_vel(a0)
+		move.w	(Camera_X_pos).w,d0
		addi.w	#$110,d0
		sub.w	x_pos(a0),d0
		bpl.s	+
		neg.w	d0
+		cmpi.w	#24,d0
		blo.s		MiniOrbinaut_Intro_AltWay_ClrCheckPosition
		sfx	sfx_Bumper2,0,0,0
		rts
; ---------------------------------------------------------------------------

MiniOrbinaut_Intro_AltWay_ClrCheckPosition:
		move.b	#_Setup1,routine(a0)
		move.l	#MiniOrbinaut_Intro_AltWay_ClrCheckPosition_Return,$34(a0)
		bclr	#0,render_flags(a0)
		clr.l	x_vel(a0)
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	MiniOrbinaut_Intro_AltWay_ClrCheckPosition_Return
		move.b	#_MiniOrbinautAlt,routine(a1)
		move.l	#DialogMiniOrbinautAlt_Process_Index-4,$34(a1)
		move.b	#(DialogMiniOrbinautAlt_Process_Index_End-DialogMiniOrbinautAlt_Process_Index)/8,$39(a1)

MiniOrbinaut_Intro_AltWay_ClrCheckPosition_Return:
		rts
; ---------------------------------------------------------------------------

MiniOrbinaut_Intro_AltWay_SetCheckPosition:
		move.b	#_Setup3,routine(a0)
		move.l	#MiniOrbinaut_Intro_AltWay_SetCheckHidePosition,$34(a0)

MiniOrbinaut_Intro_AltWay_SetCheckHidePosition:
		move.w	#$100,x_vel(a0)
		move.w	#-$400,y_vel(a0)
		sfx	sfx_Bumper2,0,0,0
		move.w	(Camera_X_pos).w,d0
		addi.w	#$160,d0
		sub.w	x_pos(a0),d0
		blo.s		MiniOrbinaut_Intro_AltWay_ClrCheckHidePosition
		rts
; ---------------------------------------------------------------------------

MiniOrbinaut_Intro_AltWay_ClrCheckHidePosition:
		move.l	#DEZ1_Resize_loadminiboss,(Level_data_addr_RAM.Resize).w
		jsr	(Go_Delete_Sprite).w
		clr.b	(Ctrl_1_locked).w
		clr.b	(NoPause_flag).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------
; Проверка касания
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MiniOrbinaut_CheckTouch:
		lea	(Player_1).w,a1
		lea	ObjDat_CheckPos(pc),a2
		jsr	(Check_InTheirRange).w
		beq.w	MiniOrbinaut_Intro_SetPosition_Return
		move.l	#DEZ1_Resize_breakdist,(Level_data_addr_RAM.Resize).w
		move.b	#$8F,(Negative_flash_timer).w
		lea	(Player_1).w,a1
		move.b	#id_SonicHurt,routine(a1)	; Hit animation
		bset	#Status_Facing,status(a1)
		bclr	#Status_OnObj,status(a1)
		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
		bset	#Status_InAir,status(a1)
		move.w	#$300,x_vel(a1)			; Set speed of player
		move.w	#-$700,y_vel(a1)
		clr.w	ground_vel(a1)			; Zero out inertia
		move.b	#id_Hurt,anim(a1)		; Set falling animation
		sfx	sfx_Death,0,0,0
		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	+
		move.b	#$C,subtype(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$C0,d0
		move.w	d0,y_pos(a1)
+		move.l	a0,-(sp)
		lea	(DEZ1_Layout_FloorExplosion).l,a0
		jsr	(Load_Level2).w
		movea.l	(sp)+,a0
		sfx	sfx_BreakBridge,0,0,0
		st	(Screen_shaking_flag).w
		jsr	(Go_Delete_Sprite).w
		lea	ChildObjDat_DEZBlock(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_DEZRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Падающие чанки
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_DEZBlock:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	d0,d1
		lsl.w	#5,d0
		add.w	(Camera_X_pos).w,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#224,d0
		move.w	d0,y_pos(a0)
		move.w	DEZBlock_SetTime(pc,d1.w),$30(a0)
		lea	ObjDat3_DEZBlock(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$2F,$2E(a0)
		move.l	#DEZBlock_Wait,address(a0)

DEZBlock_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	DEZBlock_Return
		move.l	#DEZBlock_Wait2,address(a0)

DEZBlock_Wait2:
		subq.w	#1,$30(a0)
		bpl.s	DEZBlock_Draw
		move.l	#DEZBlock_Move,address(a0)

DEZBlock_Move:
		addi.w	#$38,y_vel(a0)
		jsr	(MoveSprite).w

DEZBlock_Draw:
		jmp	(Sprite_CheckDeleteXY).w
; ---------------------------------------------------------------------------

DEZBlock_Return:
		rts
; ---------------------------------------------------------------------------

DEZBlock_SetTime:
		dc.w 10	; 1
		dc.w 12	; 2
		dc.w 10	; 3
		dc.w 12	; 4
		dc.w 14	; 5
		dc.w 12	; 6
		dc.w 14	; 7
		dc.w 12	; 8
		dc.w 16	; 9
		dc.w 12	; 10

; =============== S U B R O U T I N E =======================================

ObjDat3_MiniOrbinaut:
		dc.l Map_MiniOrbinaut
		dc.w $21F0
		dc.w $200
		dc.b 16/2
		dc.b 16/2
		dc.b 0
		dc.b 0
ObjDat3_DEZBlock:
		dc.l Map_MiniOrbinaut
		dc.w $C000
		dc.w 0
		dc.b 64/2
		dc.b 32/2
		dc.b 6
		dc.b 0
ObjDat_CheckPos:
		dc.w -16, 32
		dc.w -16, 40
ChildObjDat_DEZBlock:
		dc.w 5-1
		dc.l Obj_DEZBlock
; ---------------------------------------------------------------------------

		include "Objects/Mini Ball/Object Data/Map - Mini Orbinaut.asm"