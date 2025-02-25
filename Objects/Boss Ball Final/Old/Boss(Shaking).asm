; ---------------------------------------------------------------------------
; Босс-шар 2
; ---------------------------------------------------------------------------

; Hits
BossFinalBall_Hits	= 6

; Attributes
;_Setup4				= 8
;_Setup5				= $A
;_Setup6				= $C
;_Setup7				= $E
;_Setup8				= $10
;_Setup9				= $12

; Dynamic object variables
obBFB_Rotate				= $30	; .b
obBFB_Routine				= $32	; .b
obBFB_Draw					= $33	; .b
obBFB_Jump					= $34	; .l
obBFB_Status				= $38	; .b
obBFB_Count					= $39	; .b

; =============== S U B R O U T I N E =======================================

Obj_BossFinalBall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossFinalBall_Index(pc,d0.w),d0
		jsr	BossFinalBall_Index(pc,d0.w)
;		bsr.w	BossFinalBall_CheckTouch

		moveq	#0,d0
		btst	#0,(V_int_run_count+3).w
		beq.s	+
		addq.b	#1,d0
+		move.b	d0,mapping_frame(a0)
		tst.b	obBFB_Draw(a0)
		bne.w	BossFinalBall_CheckCameraPosition_Return
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

BossFinalBall_Index: offsetTable
		offsetTableEntry.w BossFinalBall_Init	; 0
		offsetTableEntry.w BossFinalBall_Setup	; 2
		offsetTableEntry.w BossFinalBall_Setup2	; 4
; ---------------------------------------------------------------------------

BossFinalBall_Init:
		lea	ObjDat3_BossGreyBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(Boss_flag).w
		move.b	#62/2,y_radius(a0)
		move.b	#BossFinalBall_Hits,collision_property(a0)
		tst.b	(GoodMode_flag).w
		bne.s	BossFinalBall_SkipSecurity
		st	collision_property(a0)

BossFinalBall_SkipSecurity:
		move.l	#BossFinalBall_Intro,obBFB_Jump(a0)


		move.b	#1,(Update_HUD_timer).w
		move.b	#1,(HUDBoss_RAM.status).w
		move.w	a0,(HUDBoss_RAM.parent).w



		move.w	#2,d0
		move.w	d0,$3E(a0)
		move.w	d0,y_vel(a0)
		move.w	#1,$40(a0)
		bclr	#0,$38(a0)





		lea	ChildObjDat_BossFinalBall_RotateSpikeBall(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_BossGreyBall_Face(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_Setup2:
		move.w	(Camera_X_pos).w,d0
		tst.w	x_vel(a0)
		bmi.s	+
		addi.w	#$120,d0
		cmp.w	x_pos(a0),d0
		bge.s	BossFinalBall_Setup
		bra.s	++
+		addi.w	#$20,d0
		cmp.w	x_pos(a0),d0
		ble.s		BossFinalBall_Setup
+		neg.w	x_vel(a0)

BossFinalBall_Setup:
		jsr	(Swing_UpAndDown).w
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w

; =============== S U B R O U T I N E =======================================

BossFinalBall_CheckCameraPosition_Return:
		rts
; ---------------------------------------------------------------------------
; Интро
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinalBall_Intro:
		move.w	#$4F,$2E(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall,obBFB_Jump(a0)
		rts
; ---------------------------------------------------------------------------
; Босс атакует с помощью 4 шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinalBall_MoveFourSpikeBall_ResetMove:
		move.w	#$30F,$2E(a0)
		bra.s	BossFinalBall_MoveFourSpikeBall2
; ---------------------------------------------------------------------------

BossFinalBall_MoveFourSpikeBall:
		move.w	#$28F,$2E(a0)

BossFinalBall_MoveFourSpikeBall2:
		move.b	#_Setup2,routine(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_Move,obBFB_Jump(a0)
		jsr	(Find_SonicTails).w
		move.w	#$100,x_vel(a0)
		tst.w	d0
		beq.s	+
		neg.w	x_vel(a0)
+		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFourSpikeBall_Move:
		move.b	#_Setup1,routine(a0)
		move.w	#$2F,$2E(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_SetMoveDown,obBFB_Jump(a0)
		clr.w	x_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFourSpikeBall_SetMoveDown:


		move.l	#BossFinalBall_MoveFourSpikeBall_MoveDown_Return,obBFB_Jump(a0)

		bset	#1,$38(a0)






BossFinalBall_MoveFourSpikeBall_MoveDown_Return:
		rts














; ---------------------------------------------------------------------------
; Падающий шипастый шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinalBall_RotateSpikeBall:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.b	#5,d0
		move.b	d0,$3C(a0)



		lea	ObjDat3_BossGreyBall_SpikeBall(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.b	#44/2,y_radius(a0)
		move.l	#BossFinalBall_RotateSpikeBall_Radius,address(a0)

BossFinalBall_RotateSpikeBall_Radius:
		addq.b	#2,objoff_3A(a0)
		cmpi.b	#48,objoff_3A(a0)
		bne.w	BossFinalBall_RotateSpikeBall_Circular
		sfx	sfx_SpikeBall2,0,0,0
		move.w	#$100,priority(a0)
		move.l	#BossFinalBall_RotateSpikeBall_Rotate,address(a0)

BossFinalBall_RotateSpikeBall_Rotate:
		movea.w	parent3(a0),a1
		btst	#1,$38(a1)
		beq.s	BossFinalBall_RotateSpikeBall_Rotate_Skip
		moveq	#$40,d1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		cmp.w	x_pos(a1),d0
		bge.s	+
		moveq	#-$40,d1
+		cmp.b	$3C(a0),d1
		beq.s	BossFinalBall_RotateSpikeBall_StopRotate

BossFinalBall_RotateSpikeBall_Rotate_Skip:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$20,d0
		cmp.w	y_pos(a0),d0
		blo.s		BossFinalBall_RotateSpikeBall_Circular
		moveq	#sfx_Rotate,d0
		moveq	#$17,d2
		jsr	(Wait_Play_Sound).w
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#$F,d0
		bne.s	BossFinalBall_RotateSpikeBall_Circular
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jsr	(CreateChild6_Simple).w

BossFinalBall_RotateSpikeBall_Circular:
		addq.b	#4,$3C(a0)
		jsr	(MoveSprite_Circular).w
		bra.w	BossFinalBall_RotateSpikeBall_Draw
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_StopRotate:
		movea.w	parent3(a0),a1
		bclr	#1,$38(a1)


		clr.b	objoff_3A(a0)
		move.w	#$280,priority(a0)
		sfx	sfx_SpikeAttack2,0,0,0
		lea	ChildObjDat_BossGreyBall_SpikeBall_Missile(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.w	#-$200,y_vel(a1)
		move.w	#$200,x_vel(a1)
		movea.w	parent3(a0),a2
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		cmp.w	x_pos(a2),d0
		bge.s	+
		neg.w	x_vel(a1)
+



		move.l	#BossFinalBall_RotateSpikeBall_StopRotate_Radius,address(a0)

BossFinalBall_RotateSpikeBall_StopRotate_Radius:
		addq.b	#1,objoff_3A(a0)
		cmpi.b	#48,objoff_3A(a0)
		bne.w	BossFinalBall_RotateSpikeBall_Circular
		sfx	sfx_SpikeBall2,0,0,0
		move.w	#$100,priority(a0)
		move.l	#BossFinalBall_RotateSpikeBall_Rotate,address(a0)

		bra.s	BossFinalBall_RotateSpikeBall_Circular
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Draw:
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------
; Падающий шипастый шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinalBall_RotateSpikeBall_Missile:
		lea	ObjDat3_BossGreyBall_SpikeBall_Missile(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.b	#44/2,y_radius(a0)
		move.b	#3,collision_property(a0)

		move.b	#9,$39(a0)

		lea	ChildObjDat_BossGreyBall_Designator(pc),a2
		jsr	(CreateChild1_Normal).w
		bne.s	+
		move.w	#$17F,$2E(a1)
+



		clearRAM3 Pos_objtable_Start, Pos_objtable_End
		lea	ChildObjDat_BossGreyBall_SpikeBall_Bounced_Chain_Trail(pc),a2
		jsr	(CreateChild6_Simple).w






		move.l	#BossFinalBall_RotateSpikeBall_Missile_Down,address(a0)
		bra.w	BossFinalBall_RotateSpikeBall_Missile_SendPos
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Missile_Down:
		tst.w	y_vel(a0)
		bmi.s	BossFinalBall_RotateSpikeBall_Missile_MoveSprite
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	BossFinalBall_RotateSpikeBall_Missile_MoveSprite
		add.w	d1,y_pos(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jsr	(CreateChild6_Simple).w
		move.w	#-$500,y_vel(a0)
		move.w	#-$400,x_vel(a0)
		tst.b	$39(a0)
		beq.s	BossFinalBall_RotateSpikeBall_Missile_MoveSprite
		subq.b	#1,$39(a0)
		move.w	(Player_1+x_pos).w,d0
		sub.w	x_pos(a0),d0
		asl.w	#3,d0
		move.w	d0,x_vel(a0)

BossFinalBall_RotateSpikeBall_Missile_MoveSprite:
		jsr	(MoveSprite).w

BossFinalBall_RotateSpikeBall_Missile_SendPos:
		bsr.w	Obj_ChasingBall_SendPos

BossFinalBall_RotateSpikeBall_Missile_Draw:
		bsr.s	BossFinalBall_RotateSpikeBall_Missile_CheckTouch
		btst	#6,status(a0)
		bne.s	+
		eori.b	#$60,art_tile(a0)
+
		move.w	x_pos(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	BossFinalBall_RotateSpikeBall_Missile_WaitExplosive
		jmp	(Sprite_ChildCheckDeleteTouchY).w
; ---------------------------------------------------------------------------
; Проверка урона
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinalBall_RotateSpikeBall_Missile_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	BossFinalBall_RotateSpikeBall_Missile_CheckTouch_Return
		tst.b	collision_property(a0)
		beq.s	BossFinalBall_RotateSpikeBall_Missile_WaitExplosive
		tst.b	$1C(a0)
		bne.s	BossFinalBall_RotateSpikeBall_Missile_CheckTouch_Flash
		sfx	sfx_HitBoss,0,0,0
		move.b	#$40,$1C(a0)
		bset	#6,status(a0)
		andi.b	#$0F,art_tile(a0)
		ori.b	#$60,art_tile(a0)

BossFinalBall_RotateSpikeBall_Missile_CheckTouch_Flash:
		btst	#0,$1C(a0)
		bne.s	+
		eori.b	#$40,art_tile(a0)
+		subq.b	#1,$1C(a0)
		bne.s	BossFinalBall_RotateSpikeBall_Missile_CheckTouch_Return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

BossFinalBall_RotateSpikeBall_Missile_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Missile_WaitExplosive:
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a1
		move.l	#BossFinalBall_MoveFourSpikeBall_ResetMove,$34(a1)

		move.l	#Go_Delete_Sprite,address(a0)
		rts










; =============== S U B R O U T I N E =======================================

ObjDat3_BossGreyBall_SpikeBall_Missile:
		dc.w $280
		dc.b 48/2
		dc.b 48/2
		dc.b 5
		dc.b 1
ChildObjDat_BossFinalBall_RotateSpikeBall:
		dc.w 4-1
		dc.l Obj_BossFinalBall_RotateSpikeBall
ChildObjDat_BossGreyBall_SpikeBall_Missile:
		dc.w 1-1
		dc.l Obj_BossFinalBall_RotateSpikeBall_Missile


