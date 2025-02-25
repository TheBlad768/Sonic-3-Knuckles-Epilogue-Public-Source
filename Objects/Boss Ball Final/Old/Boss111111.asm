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
		jsr	(MoveSprite2).w

BossFinalBall_Setup_Wait:
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
; Босс атакует с помощью 4 шаров(движение как в Sonic CD)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinalBall_MoveFourSpikeBall:
		move.b	#_Setup2,routine(a0)
		move.w	#$27F,$2E(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_Move,obBFB_Jump(a0)
		jsr	(Find_SonicTails).w
		move.w	#$100,x_vel(a0)
		tst.w	d0
		beq.s	+
		neg.w	x_vel(a0)
+		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFourSpikeBall_Move:
		move.w	#$2F,$2E(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_SetMoveDown,obBFB_Jump(a0)
		clr.w	x_vel(a0)

		bset	#2,$38(a0)

;		st	obBFB_Rotate(a0)
		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFourSpikeBall_SetMoveDown:
		rts


		move.b	#_Setup1,routine(a0)
		move.w	#$100,y_vel(a0)

BossFinalBall_MoveFourSpikeBall_MoveDown:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$90,d0
		cmp.w	y_pos(a0),d0
		bhs.s	BossFinalBall_MoveFourSpikeBall_MoveDown_Return


		move.l	#BossFinalBall_MoveFourSpikeBall_MoveDown_Return,obBFB_Jump(a0)
		clr.w	y_vel(a0)



BossFinalBall_MoveFourSpikeBall_MoveDown_Return
		rts














; ---------------------------------------------------------------------------
; Шипастый шар
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
		jsr	(MoveSprite_Circular).w
		addq.b	#2,objoff_3A(a0)
		cmpi.b	#48,objoff_3A(a0)
		bne.w	BossFinalBall_RotateSpikeBall_Move
		sfx	sfx_SpikeBall2,0,0,0
		move.w	#$100,priority(a0)
		move.l	#BossFinalBall_RotateSpikeBall_Rotate,address(a0)

BossFinalBall_RotateSpikeBall_Rotate:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsr.b	d0
		movea.w	parent3(a0),a1
		btst	d0,$38(a1)
		bne.s	BossFinalBall_RotateSpikeBall_StopRotate


		tst.b	obBFB_Rotate(a1)
		bne.s	BossFinalBall_RotateSpikeBall_Circular
		addq.b	#3,$3C(a0)
		moveq	#sfx_Rotate,d0
		moveq	#$17,d2
		jsr	(Wait_Play_Sound).w

BossFinalBall_RotateSpikeBall_Circular:
		jsr	(MoveSprite_Circular).w
		bra.w	BossFinalBall_RotateSpikeBall_Draw
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_StopRotate:
		clearRAM3 Pos_objtable_Start, Pos_objtable_End
		lea	ChildObjDat_BossGreyBall_SpikeBall_Bounced_Chain_Trail(pc),a2
		jsr	(CreateChild6_Simple).w




		move.l	#BossFinalBall_RotateSpikeBall_SetDown,address(a0)



		bra.w	BossFinalBall_RotateSpikeBall_Circular
; ---------------------------------------------------------------------------

RotateSpikeBall_SpeedDate:
		dc.w $80, -$100
		dc.w $200, -$200
		dc.w -$200, -$200
		dc.w -$80, -$100
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_SetDown:
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.l	RotateSpikeBall_SpeedDate(pc,d0.w),x_vel(a0)

		move.l	#BossFinalBall_RotateSpikeBall_Down,address(a0)

BossFinalBall_RotateSpikeBall_Down:
		jsr	(MoveSprite).w
		jsr	(ObjCheckFloorDist).l
		tst.w	d1
		bpl.s	BossFinalBall_RotateSpikeBall_SendPos
		add.w	d1,y_pos(a0)
		move.l	#BossFinalBall_RotateSpikeBall_CheckBounced,address(a0)

BossFinalBall_RotateSpikeBall_CheckBounced:
		move.l	#BossFinalBall_RotateSpikeBall_Down,address(a0)
		jsr	(MoveSprite).w
		move.w	y_vel(a0),d0
		bmi.s	BossFinalBall_RotateSpikeBall_SendPos
		cmpi.w	#$180,d0
		bhs.s	BossFinalBall_RotateSpikeBall_Fall

		move.l	#BossFinalBall_RotateSpikeBall_SendPos,address(a0)
		bra.s	BossFinalBall_RotateSpikeBall_SendPos
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Fall:
		asr.w	d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		sfx	sfx_SpikeBall,0,0,0

BossFinalBall_RotateSpikeBall_SendPos:
		bsr.w	Obj_ChasingBall_SendPos
		bra.s	BossFinalBall_RotateSpikeBall_Draw
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Move:
		jsr	(MoveSprite2).w

BossFinalBall_RotateSpikeBall_Draw:
		jmp	(Sprite_ChildCheckDeleteTouchXY).w





























; =============== S U B R O U T I N E =======================================

ChildObjDat_BossFinalBall_RotateSpikeBall:
		dc.w 4-1
		dc.l Obj_BossFinalBall_RotateSpikeBall




