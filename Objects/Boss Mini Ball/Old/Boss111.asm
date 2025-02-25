; ---------------------------------------------------------------------------
; Маленький босс-шар
; ---------------------------------------------------------------------------

; Dynamic object variables
obBMO_Frame			= $30	; .b

vBMO_Count				= Boss_Events	; .b

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Process:
		move.w	#$7F,$2E(a0)
		move.l	#BossMiniOrbinaut_Process_Load,address(a0)

BossMiniOrbinaut_Process_Load:
		subq.w	#1,$2E(a0)
		bpl.s	BossMiniOrbinaut_Process_Return2

		move.l	#BossMiniOrbinaut_Process_Return,address(a0)


		lea	ChildObjDat_BossMiniOrbinaut_Circular_Control(pc),a2
		jsr	(CreateChild6_Simple).w



BossMiniOrbinaut_Process_Return2:
		rts






BossMiniOrbinaut_Process_LoadMultitude:
		lea	ChildObjDat_BossMiniOrbinaut_Multitude(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.skip
		move.b	subtype(a1),d0
		lsr.b	d0
		move.b	d0,(vBMO_Count).w

.skip:
		move.l	#BossMiniOrbinaut_Process_Check,address(a0)

BossMiniOrbinaut_Process_Check:
		tst.b	(vBMO_Count).w
		bpl.s	BossMiniOrbinaut_Process_Return

		move.l	#BossMiniOrbinaut_Process_Load,address(a0)


BossMiniOrbinaut_Process_Return:
		rts
















; ---------------------------------------------------------------------------
; Куча маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Multitude:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossMiniOrbinaut_Multitude_Index(pc,d0.w),d0
		jsr	BossMiniOrbinaut_Multitude_Index(pc,d0.w)
		bsr.w	BossMiniOrbinaut_Multitude_CheckTouch
		moveq	#0,d0
		move.b	obBMO_Frame(a0),d0
		tst.w	x_vel(a0)
		beq.s	+
		bpl.s	++
+		addq.w	#2,d0
+		move.b	d0,mapping_frame(a0)
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Multitude_Index: offsetTable
		offsetTableEntry.w BossMiniOrbinaut_Multitude_Init		; 0
		offsetTableEntry.w BossMiniOrbinaut_Multitude_Setup		; 2
		offsetTableEntry.w BossMiniOrbinaut_Multitude_Setup2	; 4
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Multitude_Init:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.b	d0,d2
		lsl.w	#3,d0
		addi.w	#$4F,d0
		move.w	d0,$2E(a0)

		move.w	#-$20,d1
		btst	#1,d2
		beq.s	+
		move.w	#$160,d1
+		move.w	(Camera_X_pos).w,d0
		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		move.w	d0,y_pos(a0)

		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#1,collision_property(a0)
		move.l	#BossMiniOrbinaut_Multitude_Wait,$34(a0)

BossMiniOrbinaut_Multitude_Setup:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Multitude_Setup2:
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_Multitude_Wait:
		move.b	#_Setup2,routine(a0)
		move.l	#BossMiniOrbinaut_Multitude_Move,$34(a0)
		rts

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_Multitude_Move:

-		jsr	(Random_Number).w
		andi.w	#3,d0
		beq.s	-
		move.w	(Player_1+x_pos).w,d2
		sub.w	x_pos(a0),d2
		asl.w	d0,d2
		move.w	d2,x_vel(a0)
		move.w	#-$100,d2
		asl.w	d0,d2
		move.w	d2,y_vel(a0)
		sfx	sfx_Bumper2,0,0,0
		rts

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_Multitude_CheckTouch:
		tst.b	collision_property(a0)
		bne.s	BossMiniOrbinaut_Multitude_CheckTouch_Return


		subq.b	#1,(vBMO_Count).w

		move.w	#$14,(Screen_shaking_flag).w
		move.l	#Go_Delete_Sprite,address(a0)

		lea	ChildObjDat_DEZRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Multitude_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------
; Большой шар из кучи маленьких босс-шаров (управление)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Circular_Control:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossMiniOrbinaut_Circular_Control_Index(pc,d0.w),d0
		jsr	BossMiniOrbinaut_Circular_Control_Index(pc,d0.w)
		bsr.w	BossMiniOrbinaut_Box_CheckTouch
		jmp	(Child_AddToTouchList).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Control_Index: offsetTable
		offsetTableEntry.w BossMiniOrbinaut_Circular_Control_Init	; 0
		offsetTableEntry.w BossMiniOrbinaut_Circular_Control_Setup	; 2
		offsetTableEntry.w BossMiniOrbinaut_Circular_Control_Setup2	; 4
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Control_Init:
		addq.b	#2,routine(a0)

		move.w	(Camera_X_pos).w,d0
		addi.w	#$100,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		move.w	d0,y_pos(a0)

		move.b	#3,collision_property(a0)
		move.b	#$39,collision_flags(a0)
		move.b	#72/2,y_radius(a0)

		move.l	#BossMiniOrbinaut_Circular_Control_Move,$34(a0)

		lea	ChildObjDat_BossMiniOrbinaut_Circular(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_BossMiniOrbinaut_Circular2(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Control_Setup:
		bsr.w	RepulsionBall_CheckWall
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Control_Setup2:
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Control_Move:
		jsr	(Find_SonicTails).w
		move.w	#$200,d0
		moveq	#$10,d1
		jsr	(Chase_Object).w


		rts



		move.b	#_Setup2,routine(a0)
		move.w	#-$400,y_vel(a0)
		move.l	#BossMiniOrbinaut_Circular_Control_Move2,$34(a0)
		move.w	#-$200,d4
		jmp	(Set_VelocityXTrackSonic).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Control_Move2:
		move.b	#_Setup1,routine(a0)
		move.w	#$7F,$2E(a0)
		move.l	#BossMiniOrbinaut_Circular_Control_Move,$34(a0)
		sfx	sfx_Wham,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		clr.l	x_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Control_Return:
		rts
; ---------------------------------------------------------------------------
; Большой шар из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Circular:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#3,d0
		move.b	d0,$3C(a0)
		lea	ObjDat3_BossMiniOrbinaut_Box(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#40,objoff_3A(a0)	; X
		move.b	#16,objoff_3E(a0)		; Y
		move.l	#BossMiniOrbinaut_Circular_Setup,address(a0)

BossMiniOrbinaut_Circular_Setup:
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w

		tst.b	$38(a0)
		bne.s	++
		cmpi.b	#$3C,objoff_3A(a0)
		ble.s		+
		st	$38(a0)
+		addq.b	#1,objoff_3A(a0)
		addq.b	#1,objoff_3E(a0)
		bra.s	BossMiniOrbinaut_Circular_Setup_SetCircular
+
		cmpi.b	#-$3C,objoff_3A(a0)
		bge.s	+
		clr.b	$38(a0)
+		subq.b	#1,objoff_3A(a0)
		subq.b	#1,objoff_3E(a0)

BossMiniOrbinaut_Circular_Setup_SetCircular:
		move.w	#$80,priority(a0)
		cmpi.b	#$40,objoff_3C(a0)
		blo.s		BossMiniOrbinaut_Circular_Setup_Circular
		cmpi.b	#-$40,objoff_3C(a0)
		bhs.s	BossMiniOrbinaut_Circular_Setup_Circular
		move.w	#$280,priority(a0)

BossMiniOrbinaut_Circular_Setup_Circular:
		addq.b	#4,objoff_3C(a0)
		move.b	objoff_3C(a0),d0
		jsr	(GetSineCosine).w
		move.w	objoff_3A(a0),d2
		muls.w	d0,d2
		swap	d2
		move.w	objoff_3E(a0),d3
		muls.w	d1,d3
		swap	d3
		movea.w	parent3(a0),a1

		move.w	x_pos(a1),d0

		add.w	d2,d0

		move.b	child_dx(a0),d4
		ext.w	d4
		add.w	d4,d0
		move.w	d0,x_pos(a0)


		move.w	y_pos(a1),d1
		add.w	d3,d1
		move.b	child_dy(a0),d4
		ext.w	d4
		add.w	d4,d1
		move.w	d1,y_pos(a0)
		moveq	#0,d0
		move.b	obBMO_Frame(a0),d0
		tst.w	y_vel(a0)
		beq.s	+
		bpl.s	++
+		addq.w	#2,d0
+		move.b	d0,mapping_frame(a0)
		moveq	#0,d0
		jmp	(Child_Draw_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------
; Большой шар из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Circular2:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#3,d0
		move.b	d0,$3C(a0)
		lea	ObjDat3_BossMiniOrbinaut_Box(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#56,objoff_3A(a0)		; X
		move.b	#16,objoff_3E(a0)		; Y
		move.l	#BossMiniOrbinaut_Circular2_Setup,address(a0)

BossMiniOrbinaut_Circular2_Setup:
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w

		tst.b	$38(a0)
		bne.s	++
		cmpi.b	#$3C,objoff_3E(a0)
		ble.s		+
		st	$38(a0)
+		addq.b	#2,objoff_3E(a0)
		addq.b	#2,objoff_3A(a0)
		bra.s	BossMiniOrbinaut_Circular2_Setup_SetCircular
+
		cmpi.b	#-$3C,objoff_3E(a0)
		bge.s	+
		clr.b	$38(a0)
+		subq.b	#2,objoff_3E(a0)
		subq.b	#2,objoff_3A(a0)

BossMiniOrbinaut_Circular2_Setup_SetCircular:
		move.w	#$80,priority(a0)
		cmpi.b	#$40,objoff_3C(a0)
		blo.s		BossMiniOrbinaut_Circular2_Setup_Circular
		cmpi.b	#-$40,objoff_3C(a0)
		bhs.s	BossMiniOrbinaut_Circular2_Setup_Circular
		move.w	#$280,priority(a0)

BossMiniOrbinaut_Circular2_Setup_Circular:
		addq.b	#4,objoff_3C(a0)
		move.b	objoff_3C(a0),d0
		jsr	(GetSineCosine).w
		move.w	objoff_3A(a0),d2
		muls.w	d0,d2
		swap	d2
		move.w	objoff_3E(a0),d3
		muls.w	d1,d3
		swap	d3
		movea.w	parent3(a0),a1

		move.w	x_pos(a1),d0

		add.w	d2,d0

		move.b	child_dx(a0),d4
		ext.w	d4
		add.w	d4,d0
		move.w	d0,x_pos(a0)


		move.w	y_pos(a1),d1
		add.w	d3,d1
		move.b	child_dy(a0),d4
		ext.w	d4
		add.w	d4,d1
		move.w	d1,y_pos(a0)
		moveq	#0,d0
		move.b	obBMO_Frame(a0),d0
		tst.w	y_vel(a0)
		beq.s	+
		bpl.s	++
+		addq.w	#2,d0
+		move.b	d0,mapping_frame(a0)
		moveq	#0,d0
		jmp	(Child_Draw_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------
; Коробка из кучи маленьких босс-шаров (управление)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Box_Control:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossMiniOrbinaut_Box_Control_Index(pc,d0.w),d0
		jsr	BossMiniOrbinaut_Box_Control_Index(pc,d0.w)
		bsr.w	BossMiniOrbinaut_Box_CheckTouch
		jmp	(Child_AddToTouchList).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_Index: offsetTable
		offsetTableEntry.w BossMiniOrbinaut_Box_Control_Init	; 0
		offsetTableEntry.w BossMiniOrbinaut_Box_Control_Setup	; 2
		offsetTableEntry.w BossMiniOrbinaut_Box_Control_Setup2	; 4
		offsetTableEntry.w BossMiniOrbinaut_Box_Control_Setup3	; 6
		offsetTableEntry.w BossMiniOrbinaut_Box_Control_Setup4	; 8
		offsetTableEntry.w BossMiniOrbinaut_Box_Control_Setup5	; A
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_Init:
		addq.b	#2,routine(a0)
		move.w	(Camera_X_pos).w,d0
		move.w	#$100,d1
		move.b	#-$40,$30(a0)
		btst	#0,status(a0)
		beq.s	+
		neg.b	$30(a0)
		move.w	#$30,d1
+		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		subi.w	#$20,d0
		move.w	d0,y_pos(a0)
		move.b	#3,collision_property(a0)
		move.b	#$39,collision_flags(a0)
		move.b	#40/2,y_radius(a0)
		move.w	#$F,$2E(a0)
		move.l	#BossMiniOrbinaut_Box_Control_SetFall,$34(a0)
		lea	ChildObjDat_BossMiniOrbinaut_BoxUp(pc),a2
		jsr	(CreateChild8_TreeListRepeated).w
		lea	ChildObjDat_BossMiniOrbinaut_BoxDown(pc),a2
		jsr	(CreateChild8_TreeListRepeated).w
		lea	ChildObjDat_BossMiniOrbinaut_BoxLeft(pc),a2
		jsr	(CreateChild8_TreeListRepeated).w
		lea	ChildObjDat_BossMiniOrbinaut_BoxRight(pc),a2
		jmp	(CreateChild8_TreeListRepeated).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_Setup4:
		bsr.s	BossMiniOrbinaut_Box_Control_CreateMissileExplosive

BossMiniOrbinaut_Box_Control_Setup2:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_Setup:
		jsr	(MoveSprite).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_Setup5:
		bsr.s	BossMiniOrbinaut_Box_Control_CreateMissileExplosive

BossMiniOrbinaut_Box_Control_Setup3:
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_Box_Control_CreateMissileExplosive:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#$1F,d0
		bne.s	BossMiniOrbinaut_Box_Control_CreateMissileExplosive_Return
		sfx	sfx_SpikeBall2,0,0,0
		lea	ChildObjDat_BossMiniOrbinaut_MissileExplosive(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossMiniOrbinaut_Box_Control_Setup
		addi.w	#16,y_pos(a1)

-		jsr	(Random_Number).w
		andi.w	#$FF,d0
		beq.s	-
		addi.w	#$200,d0
		andi.w	#1,d1
		beq.s	+
		neg.w	d0
+		move.w	d0,x_vel(a1)
		jsr	(Random_Number).w
		andi.w	#$3FF,d0
		beq.s	-
		addi.w	#$400,d0
		neg.w	d0
		move.w	d0,y_vel(a1)

BossMiniOrbinaut_Box_Control_CreateMissileExplosive_Return:
		rts

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_Box_Control_SetFall:
		move.b	#_Setup3,routine(a0)
		move.l	#BossMiniOrbinaut_Box_Control_CheckBounced,$34(a0)

BossMiniOrbinaut_Box_Control_Return:
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_CheckBounced:
		move.w	y_vel(a0),d0
		bmi.s	BossMiniOrbinaut_Box_Control_Return
		cmpi.w	#$180,d0
		blo.s		BossMiniOrbinaut_Box_Control_SetLittleOpen
		asr.w	d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		sfx	sfx_Wham,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_SetLittleOpen:
		move.b	#_Setup2,routine(a0)
		move.w	#$1F,$2E(a0)
		move.l	#BossMiniOrbinaut_Box_Control_LittleOpen,$34(a0)
		sfx	sfx_Wham,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_LittleOpen:
		move.w	#7,$2E(a0)
		move.l	#BossMiniOrbinaut_Box_Control_MoveUp,$34(a0)
		move.b	#-$60,$30(a0)
		btst	#0,status(a0)
		beq.s	+
		neg.b	$30(a0)
+		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_MoveUp:
		move.b	#_Setup3,routine(a0)
		move.w	#-$400,y_vel(a0)
		move.l	#BossMiniOrbinaut_Box_Control_MoveStop,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_MoveStop:
		move.b	#_Setup2,routine(a0)
		move.l	#BossMiniOrbinaut_Box_Control_FullOpen,$34(a0)
		sfx	sfx_Wham,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_FullOpen:
		move.w	#$2F,$2E(a0)
		move.l	#BossMiniOrbinaut_Box_Control_Jump,$34(a0)
		move.b	#$30,$30(a0)
		btst	#0,status(a0)
		beq.s	+
		neg.b	$30(a0)
+		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_Jump:
		move.b	#_Setup3,routine(a0)
		move.w	#-$400,y_vel(a0)
		move.l	#BossMiniOrbinaut_Box_Control_MoveStop2,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_MoveStop2:
		move.b	#_Setup4,routine(a0)
		move.l	#BossMiniOrbinaut_Box_Control_SetWait,$34(a0)
		sfx	sfx_Wham,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_SetWait:
		move.w	#$FF,$2E(a0)
		move.l	#BossMiniOrbinaut_Box_Control_WaitJump,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_WaitJump:
		move.b	#_Setup5,routine(a0)
		move.w	#-$400,y_vel(a0)
		move.l	#BossMiniOrbinaut_Box_Control_CheckBounced2,$34(a0)

BossMiniOrbinaut_Box_Control_WaitJump_Return:
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_CheckBounced2:
		move.w	y_vel(a0),d0
		bmi.s	BossMiniOrbinaut_Box_Control_WaitJump_Return
		cmpi.w	#$180,d0
		blo.s		BossMiniOrbinaut_Box_Control_MoveStop2
		asr.w	d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		sfx	sfx_Wham,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		rts
; ---------------------------------------------------------------------------
; Проверка урона
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_Box_CheckTouch:
		tst.b	collision_flags(a0)
		bne.w	BossMiniOrbinaut_Box_CheckTouch_Return
		tst.b	collision_property(a0)
		beq.w	BossMiniOrbinaut_Box_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.s	BossMiniOrbinaut_Box_CheckTouch_Flash

BossMiniOrbinaut_Box_CheckTouch_HitBoss:
		sfx	sfx_HitBoss,0,0,0
		move.b	#$40,$1C(a0)

BossMiniOrbinaut_Box_CheckTouch_Flash:
		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	+
		addi.w	#7*2,d0
+		bsr.w	BossFinalBall_PalFlash
		subq.b	#1,$1C(a0)
		bne.s	BossMiniOrbinaut_Box_CheckTouch_Return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

BossMiniOrbinaut_Box_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_CheckTouch_WaitExplosive:
		move.l	#Go_Delete_Sprite_3,address(a0)
		rts
; ---------------------------------------------------------------------------
; Столб из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxLeft:
		lea	ObjDat3_BossMiniOrbinaut_Box(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#16,objoff_3A(a0)
		move.l	#BossMiniOrbinaut_BoxLeft_Setup,address(a0)
		tst.b	subtype(a0)
		bne.s	BossMiniOrbinaut_BoxLeft_Setup
		move.b	#-36,child_dx(a0)
		move.b	#-28,child_dy(a0)

BossMiniOrbinaut_BoxLeft_Setup:
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		jsr	(MoveSprite_Circular).w
		moveq	#0,d0
		move.b	obBMO_Frame(a0),d0
		tst.w	y_vel(a0)
		beq.s	+
		bpl.s	++
+		addq.w	#2,d0
+		move.b	d0,mapping_frame(a0)
		moveq	#0,d0
		jmp	(Child_Draw_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------
; Столб из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxRight:
		lea	ObjDat3_BossMiniOrbinaut_Box(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#16,objoff_3A(a0)
		move.l	#BossMiniOrbinaut_BoxLeft_Setup,address(a0)
		tst.b	subtype(a0)
		bne.s	+
		move.b	#28,child_dx(a0)
		move.b	#-28,child_dy(a0)
+		rts
; ---------------------------------------------------------------------------
; Столб из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxUp:
		lea	ObjDat3_BossMiniOrbinaut_Box(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#16,objoff_3A(a0)
		movea.w	$44(a0),a1
		move.b	$30(a1),objoff_3C(a0)
		move.l	#BossMiniOrbinaut_BoxUp_CheckOpen,address(a0)
		btst	#0,status(a1)
		beq.s	+
		move.l	#BossMiniOrbinaut_BoxUp_CheckOpen2,address(a0)
+		tst.b	subtype(a0)
		bne.s	+
		move.b	#-12,child_dy(a0)
		move.b	#28,child_dx(a0)
		movea.w	$44(a0),a1
		btst	#0,status(a1)
		beq.s	+
		move.b	#-36,child_dx(a0)
+		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxUp_CheckOpen:
		movea.w	$44(a0),a1
		move.b	$30(a1),d0
		subq.b	#4,$3C(a0)
		cmp.b	$3C(a0),d0
		blo.s		+
		move.b	d0,$3C(a0)
+		bra.w	BossMiniOrbinaut_BoxLeft_Setup
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxUp_CheckOpen2:
		movea.w	$44(a0),a1
		move.b	$30(a1),d0
		addq.b	#4,$3C(a0)
		cmp.b	$3C(a0),d0
		bhs.s	+
		move.b	d0,$3C(a0)
+		bra.w	BossMiniOrbinaut_BoxLeft_Setup
; ---------------------------------------------------------------------------
; Столб из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxDown:
		lea	ObjDat3_BossMiniOrbinaut_Box(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#16,objoff_3A(a0)
		move.b	#$40,objoff_3C(a0)
		move.l	#BossMiniOrbinaut_BoxLeft_Setup,address(a0)

		tst.b	subtype(a0)
		bne.s	+
		move.b	#-52,child_dx(a0)
		move.b	#20,child_dy(a0)
+		rts
; ---------------------------------------------------------------------------
; Взрывающийся шипастый шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_MissileExplosive:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossMiniOrbinaut_MissileExplosive_Index(pc,d0.w),d0
		jsr	BossMiniOrbinaut_MissileExplosive_Index(pc,d0.w)
		bsr.w	BossMiniOrbinaut_MissileExplosive_CheckTouch
		moveq	#0,d0
		move.b	obBMO_Frame(a0),d0
		tst.w	x_vel(a0)
		beq.s	+
		bpl.s	++
+		addq.w	#2,d0
+		move.b	d0,mapping_frame(a0)
		moveq	#0,d0
		jmp	(Child_DrawTouch_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_MissileExplosive_Index: offsetTable
		offsetTableEntry.w BossMiniOrbinaut_MissileExplosive_Init		; 0
		offsetTableEntry.w BossMiniOrbinaut_MissileExplosive_Setup1	; 2
; ---------------------------------------------------------------------------

BossMiniOrbinaut_MissileExplosive_Init:
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#16/2,y_radius(a0)
		move.b	#3,obBMO_Frame(a0)
		move.b	#1,collision_property(a0)
		move.l	#BossMiniOrbinaut_MissileExplosive_Bounced,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_MissileExplosive_Setup1:
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_MissileExplosive_Bounced:
		move.l	#Go_Delete_Sprite,address(a0)
		sfx	sfx_BreakBridge,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_BossFinalBall_DEZExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Проверка урона
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_MissileExplosive_CheckTouch:
		tst.b	collision_property(a0)
		bne.s	BossMiniOrbinaut_MissileExplosive_CheckTouch_Return
		move.w	#$14,(Screen_shaking_flag).w
		move.l	#Go_Delete_Sprite,address(a0)
		lea	ChildObjDat_DEZRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_MissileExplosive_CheckTouch_Return:
		rts

; =============== S U B R O U T I N E =======================================












; =============== S U B R O U T I N E =======================================

ObjDat3_BossMiniOrbinaut:
		dc.l Map_MiniOrbinaut
		dc.w $E170
		dc.w $180
		dc.b 16/2
		dc.b 16/2
		dc.b 0
		dc.b $B
ObjDat3_BossMiniOrbinaut_Box:
		dc.l Map_MiniOrbinaut
		dc.w $E170
		dc.w $180
		dc.b 16/2
		dc.b 16/2
		dc.b 0
		dc.b 0
ChildObjDat_BossMiniOrbinaut_Multitude:
		dc.w 24-1
		dc.l Obj_BossMiniOrbinaut_Multitude
ChildObjDat_BossMiniOrbinaut_Circular_Control:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_Circular_Control
ChildObjDat_BossMiniOrbinaut_Circular:
		dc.w 16-1
		dc.l Obj_BossMiniOrbinaut_Circular
ChildObjDat_BossMiniOrbinaut_Circular2:
		dc.w 16-1
		dc.l Obj_BossMiniOrbinaut_Circular2
ChildObjDat_BossMiniOrbinaut_Box_Control:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_Box_Control
ChildObjDat_BossMiniOrbinaut_BoxUp:
		dc.w 4-1
		dc.l Obj_BossMiniOrbinaut_BoxUp
ChildObjDat_BossMiniOrbinaut_BoxDown:
		dc.w 5-1
		dc.l Obj_BossMiniOrbinaut_BoxDown
ChildObjDat_BossMiniOrbinaut_BoxLeft:
		dc.w 2-1
		dc.l Obj_BossMiniOrbinaut_BoxLeft
ChildObjDat_BossMiniOrbinaut_BoxRight:
		dc.w 2-1
		dc.l Obj_BossMiniOrbinaut_BoxRight
ChildObjDat_BossMiniOrbinaut_MissileExplosive:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_MissileExplosive