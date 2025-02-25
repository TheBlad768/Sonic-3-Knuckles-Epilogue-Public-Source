; ---------------------------------------------------------------------------
; Маленький босс-шар
; ---------------------------------------------------------------------------

; Dynamic object variables
obBMO_Frame			= $30	; .b

vBMO_Count				= Boss_Events	; .b

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Process:
		move.l	#BossMiniOrbinaut_Process_Load,address(a0)

BossMiniOrbinaut_Process_Load:
		move.l	#BossMiniOrbinaut_Process_Return,address(a0)


		lea	ChildObjDat_BossMiniOrbinaut_Circular_Control(pc),a2
		jsr	(CreateChild6_Simple).w


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
		move.w	(Camera_X_pos).w,d0
		addi.w	#$140,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		move.w	d0,y_pos(a0)






		lea	ChildObjDat_BossMiniOrbinaut_Circular(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.skip
		move.b	subtype(a1),d0
		lsr.b	d0
		move.b	d0,(vBMO_Count).w

.skip:






		move.l	#BossMiniOrbinaut_Circular_Control_Move,address(a0)

BossMiniOrbinaut_Circular_Control_Move:
		jsr	(Find_SonicTails).w
		addi.w	#$10,d2
		cmpi.w	#$60,d2
		blo.s		BossMiniOrbinaut_Circular_Control_MoveSprite
		move.w	#$100,d1
		bset	#0,render_flags(a0)
		tst.w	d0
		bne.s	+
		neg.w	d1
		bclr	#0,render_flags(a0)
+		move.w	d1,x_vel(a0)

BossMiniOrbinaut_Circular_Control_MoveSprite:
		jsr	(MoveSprite2).w

BossMiniOrbinaut_Circular_Control_Return:
		rts
; ---------------------------------------------------------------------------
; Большой шар из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Circular:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossMiniOrbinaut_Circular_Index(pc,d0.w),d0
		jsr	BossMiniOrbinaut_Circular_Index(pc,d0.w)

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

BossMiniOrbinaut_Circular_Index: offsetTable
		offsetTableEntry.w BossMiniOrbinaut_Circular_Init	; 0
		offsetTableEntry.w BossMiniOrbinaut_Circular_Setup	; 2
		offsetTableEntry.w BossMiniOrbinaut_Circular_Setup2	; 4
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Init:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#3,d0
		move.b	d0,$3C(a0)



		lea	ObjDat3_BossMiniOrbinaut_Circular(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#1,collision_property(a0)
		move.b	#80,objoff_3A(a0)
		move.l	#BossMiniOrbinaut_Circular_Wait,$34(a0)

BossMiniOrbinaut_Circular_Setup:
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w

		move.b	objoff_3C(a0),d0
		addq.b	#4,objoff_3C(a0)
		jsr	(MoveSprite_Circular).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Setup2:
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Wait:
		rts




; =============== S U B R O U T I N E =======================================

ObjDat3_BossMiniOrbinaut:
		dc.l Map_MiniOrbinaut
		dc.w $6170
		dc.w $80
		dc.b 16/2
		dc.b 16/2
		dc.b 0
		dc.b $B
ObjDat3_BossMiniOrbinaut_Circular:
		dc.l Map_MiniOrbinaut
		dc.w $6170
		dc.w $80
		dc.b 16/2
		dc.b 16/2
		dc.b 0
		dc.b $B|$80
ChildObjDat_BossMiniOrbinaut_Multitude:
		dc.w 24-1
		dc.l Obj_BossMiniOrbinaut_Multitude
ChildObjDat_BossMiniOrbinaut_Circular_Control:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_Circular_Control
ChildObjDat_BossMiniOrbinaut_Circular:
		dc.w 16-1
		dc.l Obj_BossMiniOrbinaut_Circular