; ---------------------------------------------------------------------------
; Маленький босс-шар
; ---------------------------------------------------------------------------

; Dynamic object variables
obBMO_Frame			= $30	; .b

vBMO_Parent			= Boss_Events	; .w
vBMO_Count				= Boss_Events+2	; .b
vBMO_Count2			= Boss_Events+3	; .b
vBMO_Hurt				= Boss_Events+4	; .b

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Process:
		move.w	#$7F,$2E(a0)
		move.l	#BossMiniOrbinaut_Process_Wait,address(a0)
		move.w	a0,(vBMO_Parent).w
		clr.w	(vBMO_Count).w

BossMiniOrbinaut_Process_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	BossMiniOrbinaut_Process_Return
		move.l	#BossMiniOrbinaut_Process_Load,address(a0)

BossMiniOrbinaut_Process_Load:
		moveq	#0,d0
		move.b	routine(a0),d0
		addq.b	#2,routine(a0)
		move.w	BossMiniOrbinaut_Index(pc,d0.w),d0
		lea	BossMiniOrbinaut_Index(pc,d0.w),a4
		move.w	(a4)+,d5									; Total
		bmi.s	BossMiniOrbinaut_Process_Error_Minus

-		move.w	(a4),d1									; Obj
		lea	(a4,d1.w),a2
		addq.w	#2,a4
		jsr	(CreateChild6_Simple).w
		bne.s	BossMiniOrbinaut_Process_Error_RAM
		move.b	subtype(a1),d0
		lsr.b	d0
		addq.b	#1,d0
		move.b	d0,(vBMO_Count2).w
		move.w	(a4)+,d0
		bmi.s	+
		move.w	d0,$2E(a1)
+		addq.b	#1,(vBMO_Count).w
		dbf	d5,-
		move.l	#BossMiniOrbinaut_Process_Return,address(a0)

BossMiniOrbinaut_Process_Return:
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Process_Error_RAM:
		illegal

BossMiniOrbinaut_Process_Error_Minus:
		illegal
; ---------------------------------------------------------------------------
;		offsetTableEntry.w ChildObjDat_BossMiniOrbinaut_Multitude				; 0
;		offsetTableEntry.w ChildObjDat_BossMiniOrbinaut_SmallCircular_Control	; 1
;		offsetTableEntry.w ChildObjDat_BossMiniOrbinaut_Circular_Control			; 2
;		offsetTableEntry.w ChildObjDat_BossMiniOrbinaut_CircularRotation_Control	; 3
;		offsetTableEntry.w ChildObjDat_BossMiniOrbinaut_Box_Control				; 4
;		offsetTableEntry.w ChildObjDat_BossMiniOrbinaut_BoxJump_Control		; 5
;		offsetTableEntry.w ChildObjDat_BossMiniOrbinaut_Snake					; 6
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Index: offsetTable
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 0
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level2						; 2
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 4
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level3						; 6
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 8
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level4						; A
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; C
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level5						; E
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 10
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level6						; 12
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 14
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level7						; 16
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 18
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level8						; 1A
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 1C
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level9						; 1A
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 1C
		offsetTableEntry.w ObjData_BossMiniOrbinaut_LevelA						; 1E
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 20
		offsetTableEntry.w ObjData_BossMiniOrbinaut_LevelB						; 22
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 24
		offsetTableEntry.w ObjData_BossMiniOrbinaut_LevelC						; 26
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 28
		offsetTableEntry.w ObjData_BossMiniOrbinaut_LevelD						; 2A
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 2C
		offsetTableEntry.w ObjData_BossMiniOrbinaut_LevelE						; 2E
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 30
		offsetTableEntry.w ObjData_BossMiniOrbinaut_LevelF						; 32
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level10					; 34
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 36
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level11						; 38
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level12						; 3A
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 3C
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level13						; 3E
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level14						; 40
		offsetTableEntry.w ObjData_BossMiniOrbinaut_Level1						; 42


BossMiniOrbinaut_Index_End
; ---------------------------------------------------------------------------

ObjData_BossMiniOrbinaut_Level1:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_SmallCircular_Control			; Obj
		dc.w -1																; Timer

ObjData_BossMiniOrbinaut_Level2:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_Box_Control					; Obj
		dc.w -1																; Timer

ObjData_BossMiniOrbinaut_Level3:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_CircularRotation_Control		; Obj
		dc.w -1																; Timer

ObjData_BossMiniOrbinaut_Level4:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_BoxJump_Control			; Obj
		dc.w -1																; Timer

ObjData_BossMiniOrbinaut_Level5:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_SmallCircular_Control			; Obj
		dc.w -1																; Timer

ObjData_BossMiniOrbinaut_Level6:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_Box_Control					; Obj
		dc.w 1																; Timer

ObjData_BossMiniOrbinaut_Level7:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_Circular_Control				; Obj
		dc.w -1																; Timer

ObjData_BossMiniOrbinaut_Level8:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_BoxJump_Control			; Obj
		dc.w 1																; Timer

ObjData_BossMiniOrbinaut_Level9:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_Circular_Control				; Obj
		dc.w 1																; Timer

ObjData_BossMiniOrbinaut_LevelA:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_Snake						; Obj
		dc.w -1																; Timer

ObjData_BossMiniOrbinaut_LevelB:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_SmallCircular_Control			; Obj
		dc.w 1																; Timer

ObjData_BossMiniOrbinaut_LevelC:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_Box_Control2				; Obj
		dc.w 1																; Timer

ObjData_BossMiniOrbinaut_LevelD:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_CircularRotation_Control2		; Obj
		dc.w 1																; Timer

ObjData_BossMiniOrbinaut_LevelE:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_Snake						; Obj
		dc.w 1																; Timer

ObjData_BossMiniOrbinaut_LevelF:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_Box_Control					; Obj
		dc.w -1																; Timer

ObjData_BossMiniOrbinaut_Level10:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_Box_Control					; Obj
		dc.w 1																; Timer

ObjData_BossMiniOrbinaut_Level11:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_Circular_Control				; Obj
		dc.w -1																; Timer

ObjData_BossMiniOrbinaut_Level12:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_Circular_Control				; Obj
		dc.w 1																; Timer

ObjData_BossMiniOrbinaut_Level13:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_SmallCircular_Control			; Obj
		dc.w -1																; Timer

ObjData_BossMiniOrbinaut_Level14:
		dc.w 1-1																; Total
		offsetEntry.w ChildObjDat_BossMiniOrbinaut_SmallCircular_Control			; Obj
		dc.w 1																; Timer









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
		asl.w	#2,d2
		move.w	d2,x_vel(a0)
		move.w	#-$100,d2
		asl.w	d0,d2
		move.w	d2,y_vel(a0)
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#1,d0
		bne.s	BossMiniOrbinaut_Multitude_Move_Return
		sfx	sfx_Jump3,0,0,0

BossMiniOrbinaut_Multitude_Move_Return:
		rts

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_Multitude_CheckTouch:
		tst.b	collision_property(a0)
		bne.s	BossMiniOrbinaut_Multitude_Move_Return
		subq.b	#1,(vBMO_Count2).w
		bne.s	+
		clr.b	(vBMO_Count).w
		clr.b	(vBMO_Hurt).w
		movea.w	(vBMO_Parent).w,a1
		move.w	#$9F,$2E(a1)
		move.l	#BossMiniOrbinaut_Process_Wait,address(a1)
+		sfx	sfx_BreakBridge,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		move.l	#Go_Delete_Sprite,address(a0)
		lea	ChildObjDat_DEZRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Маленький шар из кучи маленьких босс-шаров (управление)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_SmallCircular_Control:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossMiniOrbinaut_SmallCircular_Control_Index(pc,d0.w),d0
		jsr	BossMiniOrbinaut_SmallCircular_Control_Index(pc,d0.w)
		bsr.w	BossMiniOrbinaut_SmallCircular_Control_CheckWall
		bsr.w	BossMiniOrbinaut_Box_CheckTouch
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_SmallCircular_Control_Index: offsetTable
		offsetTableEntry.w BossMiniOrbinaut_SmallCircular_Control_Init	; 0
		offsetTableEntry.w BossMiniOrbinaut_SmallCircular_Control_Setup	; 2
		offsetTableEntry.w BossMiniOrbinaut_SmallCircular_Control_Setup2	; 4
		offsetTableEntry.w BossMiniOrbinaut_SmallCircular_Control_Setup3	; 6
		offsetTableEntry.w BossMiniOrbinaut_SmallCircular_Control_Setup4	; 8
		offsetTableEntry.w BossMiniOrbinaut_SmallCircular_Control_Setup5	; A
; ---------------------------------------------------------------------------

BossMiniOrbinaut_SmallCircular_Control_Init:
		addq.b	#2,routine(a0)

		tst.w	$2E(a0)
		beq.s	+
		bset	#0,status(a0)
+

		move.w	(Camera_X_pos).w,d0
		move.w	#$1A0,d1
		btst	#0,status(a0)
		beq.s	+
		move.w	#-$B0,d1
+		add.w	d1,d0
		move.w	d0,x_pos(a0)


		move.w	(Camera_Y_pos).w,d0
		addi.w	#$A2,d0
		move.w	d0,y_pos(a0)

		move.b	#$B,collision_flags(a0)
		move.b	#6,collision_property(a0)
		move.b	#92/2,y_radius(a0)



		move.b	#30,objoff_3A(a0)		; X
		move.b	#30,objoff_3E(a0)		; Y


		move.l	#BossMiniOrbinaut_SmallCircular_Control_SetChase,$34(a0)

		lea	ChildObjDat_BossMiniOrbinaut_SmallCircular(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_SmallCircular_Control_Setup:
		moveq	#sfx_SpikeBall,d0
		moveq	#$F,d2
		jsr	(Wait_Play_Sound).w
		jsr	(Find_SonicTails).w
		move.w	#$200,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectXOnly).w

BossMiniOrbinaut_SmallCircular_Control_Setup3:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_SmallCircular_Control_Setup4:
		jsr	(Find_SonicTails).w
		move.w	#$200,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectXOnly).w
		jsr	(MoveSprite).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_SmallCircular_Control_Setup5:
		jsr	(Find_SonicTails).w
		move.w	#$200,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectXOnly).w

BossMiniOrbinaut_SmallCircular_Control_Setup2:
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_SmallCircular_Control_CheckWall:
		move.w	(Camera_X_pos).w,d0
		tst.w	x_vel(a0)
		bpl.s	+
		addi.w	#$28,d0			; Проверить левую сторону стены
		cmp.w	x_pos(a0),d0
		bhs.s	++
		rts
+		addi.w	#$118,d0			; Проверить правую сторону стены
		cmp.w	x_pos(a0),d0
		bhs.s	++
+		neg.w	x_vel(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
+		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_SmallCircular_Control_SetChase:
		move.w	#$9F,$2E(a0)
		move.l	#BossMiniOrbinaut_SmallCircular_Control_SetJump,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_SmallCircular_Control_SetJump:
		move.b	#_Setup2,routine(a0)
		move.w	#-$600,y_vel(a0)
		sfx	sfx_Jump3,0,0,0
		move.l	#BossMiniOrbinaut_SmallCircular_Control_JumpSetDeceleration,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_SmallCircular_Control_JumpSetDeceleration:
		move.b	#_Setup3,routine(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		move.l	#BossMiniOrbinaut_SmallCircular_Control_JumpDeceleration,$34(a0)
		clr.w	y_vel(a0)

BossMiniOrbinaut_SmallCircular_Control_JumpDeceleration:
		addq.w	#2,y_pos(a0)
		addq.b	#1,objoff_3A(a0)		; X
		subq.b	#2,objoff_3E(a0)		; Y
		moveq	#8,d0
		cmp.b	objoff_3E(a0),d0		; Y
		blo.s		BossMiniOrbinaut_SmallCircular_Control_JumpDeceleration_Return
		move.b	d0,objoff_3E(a0)		; Y
		move.w	#$F,$2E(a0)
		move.l	#BossMiniOrbinaut_SmallCircular_Control_JumpSetAcceleration,$34(a0)

BossMiniOrbinaut_SmallCircular_Control_JumpDeceleration_Return:
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_SmallCircular_Control_JumpSetAcceleration:
		move.b	#_Setup4,routine(a0)
		move.w	#-$700,y_vel(a0)
		sfx	sfx_Jump3,0,0,0
		move.l	#BossMiniOrbinaut_SmallCircular_Control_JumpAcceleration,$34(a0)

BossMiniOrbinaut_SmallCircular_Control_JumpAcceleration:
		subq.b	#1,objoff_3A(a0)		; X
		addq.b	#2,objoff_3E(a0)		; Y
		moveq	#30,d0
		cmp.b	objoff_3E(a0),d0		; Y
		bhs.s	BossMiniOrbinaut_SmallCircular_Control_JumpAcceleration_Return
		move.b	d0,objoff_3E(a0)		; Y
		move.b	d0,objoff_3A(a0)		; X
		move.b	#_Setup5,routine(a0)
		move.l	#BossMiniOrbinaut_SmallCircular_Control_JumpSetDeceleration,$34(a0)

BossMiniOrbinaut_SmallCircular_Control_JumpAcceleration_Return:
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_SmallCircular_Control_Jump:
		move.b	#_Setup1,routine(a0)
		move.w	#$F,$2E(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		move.l	#BossMiniOrbinaut_SmallCircular_Control_SetJump,$34(a0)
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------
; Маленький шар из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_SmallCircular:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#4,d0
		move.b	d0,$3C(a0)
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
		move.b	#16,child_dy(a0)

;		move.b	#30,objoff_3A(a0)		; X
;		move.b	#30,objoff_3E(a0)		; Y

		move.l	#BossMiniOrbinaut_SmallCircular_Setup,address(a0)

BossMiniOrbinaut_SmallCircular_Setup:
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		movea.w	parent3(a0),a1
		move.b	collision_flags(a1),collision_flags(a0)

		bsr.w	BossMiniOrbinaut_SmallCircular_CheckTouch

		movea.w	parent3(a0),a1
		move.b	objoff_3A(a1),objoff_3A(a0)	; X
		move.b	objoff_3E(a1),objoff_3E(a0)		; Y
		bra.w	BossMiniOrbinaut_CircularRotation2_Setup_Circular
; ---------------------------------------------------------------------------
; Проверка урона
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_SmallCircular_CheckTouch:
		movea.w	parent3(a0),a1
		btst	#6,status(a1)
		bne.s	BossMiniOrbinaut_SmallCircular_CheckTouch_Return




		tst.b	collision_flags(a0)
		bne.s	BossMiniOrbinaut_SmallCircular_CheckTouch_Return





		addq.b	#1,collision_property(a0)




		movea.w	parent3(a0),a1
		move.b	collision_flags(a1),collision_restore_flags(a1)
		clr.b	collision_flags(a1)
		clr.b	collision_flags(a0)
		subq.b	#1,collision_property(a1)

BossMiniOrbinaut_SmallCircular_CheckTouch_Return:
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
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Control_Index: offsetTable
		offsetTableEntry.w BossMiniOrbinaut_Circular_Control_Init	; 0
		offsetTableEntry.w BossMiniOrbinaut_Circular_Control_Setup	; 2
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Control_Init:
		addq.b	#2,routine(a0)

		tst.w	$2E(a0)
		beq.s	+
		bset	#0,status(a0)
+

		move.w	(Camera_X_pos).w,d0
		move.w	#$1A0,d1
		btst	#0,status(a0)
		beq.s	+
		move.w	#-$B0,d1
+		add.w	d1,d0
		move.w	d0,x_pos(a0)


		move.w	(Camera_Y_pos).w,d0
		addi.w	#$84,d0
		move.w	d0,y_pos(a0)

		move.b	#3,collision_property(a0)

		lea	ChildObjDat_BossMiniOrbinaut_Circular(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Circular_Control_Setup:
		moveq	#sfx_SpikeBall,d0
		moveq	#$F,d2
		jsr	(Wait_Play_Sound).w
		jsr	(Find_SonicTails).w
		move.w	#$400,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectXOnly).w
		jmp	(MoveSprite2).w
; ---------------------------------------------------------------------------
; Большой шар из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Circular:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#3,d0
		move.b	d0,$3C(a0)
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
		move.b	#60,objoff_3A(a0)
		move.b	#16,child_dy(a0)
		move.l	#BossMiniOrbinaut_Circular_Setup,address(a0)

BossMiniOrbinaut_Circular_Setup:
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		addq.b	#4,objoff_3C(a0)
		jsr	(MoveSprite_Circular).w
		bra.w	BossMiniOrbinaut_CircularRotation2_Setup_Draw
; ---------------------------------------------------------------------------
; Большой шар из кучи маленьких босс-шаров (управление)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_CircularRotation_Control2:
		st	$40(a0)
		move.l	#Obj_BossMiniOrbinaut_CircularRotation_Control,address(a0)

Obj_BossMiniOrbinaut_CircularRotation_Control:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossMiniOrbinaut_CircularRotation_Control_Index(pc,d0.w),d0
		jsr	BossMiniOrbinaut_CircularRotation_Control_Index(pc,d0.w)
		bsr.w	BossMiniOrbinaut_Box_CheckTouch
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_CircularRotation_Control_Index: offsetTable
		offsetTableEntry.w BossMiniOrbinaut_CircularRotation_Control_Init		; 0
		offsetTableEntry.w BossMiniOrbinaut_CircularRotation_Control_Setup	; 2
; ---------------------------------------------------------------------------

BossMiniOrbinaut_CircularRotation_Control_Init:
		addq.b	#2,routine(a0)

		tst.w	$2E(a0)
		beq.s	+
		bset	#0,status(a0)
+

		move.w	(Camera_X_pos).w,d0
		move.w	#$1A0,d1
		btst	#0,status(a0)
		beq.s	+
		move.w	#-$B0,d1
+		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		move.w	d0,y_pos(a0)

		move.b	#6,collision_property(a0)
		move.b	#72/2,y_radius(a0)


		lea	ChildObjDat_BossMiniOrbinaut_CircularRotation(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_BossMiniOrbinaut_CircularRotation2(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_CircularRotation_Control_Setup:
		bsr.s	BossMiniOrbinaut_CircularRotation_Control_CheckWall
		moveq	#sfx_Circular,d0
		moveq	#$1F,d2
		jsr	(Wait_Play_Sound).w
		jsr	(Find_SonicTails).w
		move.w	#$600,d0
		moveq	#8,d1
		jsr	(Chase_Object).w
		jmp	(MoveSprite2).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_CircularRotation_Control_CheckWall:
		move.w	(Camera_Y_pos).w,d0
		tst.w	y_vel(a0)
		bmi.s	+
		addi.w	#$A8,d0			; Проверить пол
		cmp.w	y_pos(a0),d0
		blo.s		++
		bra.s	+++
+		addi.w	#$48,d0			; Проверить потолок
		cmp.w	y_pos(a0),d0
		blo.s		++
+		neg.w	y_vel(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
+		move.w	(Camera_X_pos).w,d0
		tst.w	x_vel(a0)
		bpl.s	+
		addi.w	#$28,d0			; Проверить левую сторону стены
		cmp.w	x_pos(a0),d0
		bhs.s	++
		rts
+		addi.w	#$118,d0			; Проверить правую сторону стены
		cmp.w	x_pos(a0),d0
		bhs.s	++
+		neg.w	x_vel(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
+		rts
; ---------------------------------------------------------------------------
; Большой шар из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_CircularRotation:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#3,d0
		move.b	d0,$3C(a0)
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
		move.b	#40,objoff_3A(a0)
		move.l	#BossMiniOrbinaut_Circular_Setup,address(a0)
		bra.w	BossMiniOrbinaut_Circular_Setup
; ---------------------------------------------------------------------------
; Большой шар из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_CircularRotation2:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#3,d0
		move.b	d0,$3C(a0)
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
		move.b	#56,objoff_3A(a0)		; X
		move.b	#16,objoff_3E(a0)		; Y
		move.l	#BossMiniOrbinaut_CircularRotation2_Setup,address(a0)

BossMiniOrbinaut_CircularRotation2_Setup:
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		bsr.w	BossMiniOrbinaut_CircularRotation2_Angle
		move.w	#$80,priority(a0)
		cmpi.b	#$40,objoff_3C(a0)
		blo.s		BossMiniOrbinaut_CircularRotation2_Setup_Circular
		cmpi.b	#-$40,objoff_3C(a0)
		bhs.s	BossMiniOrbinaut_CircularRotation2_Setup_Circular
		move.w	#$280,priority(a0)

BossMiniOrbinaut_CircularRotation2_Setup_Circular:
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

BossMiniOrbinaut_CircularRotation2_Setup_Draw:
		moveq	#0,d0
		move.b	obBMO_Frame(a0),d0
		tst.w	x_vel(a0)
		beq.s	+
		bpl.s	++
+		addq.w	#2,d0
+		move.b	d0,mapping_frame(a0)
		moveq	#0,d0
		movea.w	parent3(a0),a1
		btst	#6,status(a1)
		bne.s	BossMiniOrbinaut_CircularRotation2_Setup_Circular_NoTouch
		jmp	(Child_DrawTouch_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_CircularRotation2_Setup_Circular_NoTouch:
		jmp	(Child_Draw_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_CircularRotation2_Angle:
		movea.w	parent3(a0),a1
		tst.b	$40(a1)
		bne.s	BossMiniOrbinaut_CircularRotation2_Angle2
		addq.b	#2,objoff_3E(a0)
		cmpi.b	#$40,objoff_3C(a0)
		blo.s		BossMiniOrbinaut_CircularRotation2_Angle_Return
		cmpi.b	#-$40,objoff_3C(a0)
		bhs.s	BossMiniOrbinaut_CircularRotation2_Angle_Return
		subq.b	#4,objoff_3E(a0)

BossMiniOrbinaut_CircularRotation2_Angle_Return:
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_CircularRotation2_Angle2:
		btst	#0,$38(a0)
		bne.s	++
		cmpi.b	#$3C,objoff_3E(a0)
		ble.s		+
		bset	#0,$38(a0)
+		addq.b	#2,objoff_3E(a0)
		bra.s	BossMiniOrbinaut_CircularRotation2_Angle2_Return
+		cmpi.b	#-$3C,objoff_3E(a0)
		bge.s	+
		bclr	#0,$38(a0)
+		subq.b	#2,objoff_3E(a0)

BossMiniOrbinaut_CircularRotation2_Angle2_Return:
		rts
; ---------------------------------------------------------------------------
; Коробка из кучи маленьких босс-шаров (управление)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Box_Control2:
		st	$40(a0)
		move.l	#Obj_BossMiniOrbinaut_Box_Control,address(a0)

Obj_BossMiniOrbinaut_Box_Control:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossMiniOrbinaut_Box_Control_Index(pc,d0.w),d0
		jsr	BossMiniOrbinaut_Box_Control_Index(pc,d0.w)
		bsr.w	BossMiniOrbinaut_Box_CheckTouch
		jmp	(Child_CheckParent).w
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
		tst.w	$2E(a0)
		beq.s	+
		bset	#0,status(a0)
+
		move.w	(Camera_X_pos).w,d0
		move.w	#$110,d1
		move.b	#-$40,$30(a0)
		btst	#0,status(a0)
		beq.s	+
		neg.b	$30(a0)
		move.w	#$40,d1
+		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		subi.w	#$20,d0
		move.w	d0,y_pos(a0)
		move.b	#-1,collision_property(a0)
		move.b	#40/2,y_radius(a0)
		move.l	#BossMiniOrbinaut_Box_Control_Wait,$34(a0)
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

BossMiniOrbinaut_Box_Control_Setup:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_Setup2:
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
		jsr	(Find_SonicTails).w
		tst.w	d0
		sne	d5
		sfx	sfx_Jump3,0,0,0
		lea	ChildObjDat_BossMiniOrbinaut_MissileExplosive(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossMiniOrbinaut_Box_Control_CreateMissileExplosive_Return
		addi.w	#16,y_pos(a1)

-		jsr	(Random_Number).w
		andi.w	#$FF,d0
		beq.s	-
		addi.w	#$280,d0
		tst.b	d5
		beq.s	+
		neg.w	d0
+		andi.w	#1,d1
		beq.s	+
		neg.w	d0
+		move.w	d0,x_vel(a1)
		jsr	(Random_Number).w
		andi.w	#$3FF,d0
		beq.s	-
		addi.w	#$480,d0
		neg.w	d0
		move.w	d0,y_vel(a1)

BossMiniOrbinaut_Box_Control_CreateMissileExplosive_Return:
		rts

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_Box_Control_Wait:
		move.b	#_Setup2,routine(a0)
		move.w	#$F,$2E(a0)
		move.l	#BossMiniOrbinaut_Box_Control_SetFall,$34(a0)
		rts
; ---------------------------------------------------------------------------

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
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_SetLittleOpen:
		move.b	#_Setup1,routine(a0)
		move.w	#$1F,$2E(a0)
		move.l	#BossMiniOrbinaut_Box_Control_LittleOpen,$34(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_LittleOpen:
		move.w	#7,$2E(a0)
		move.l	#BossMiniOrbinaut_Box_Control_MoveUp,$34(a0)
		sfx	sfx_Attachment2,0,0,0
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
		move.b	#_Setup1,routine(a0)
		move.l	#BossMiniOrbinaut_Box_Control_FullOpen,$34(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_FullOpen:
		moveq	#3,d0
		tst.b	$40(a0)
		beq.s	+
		moveq	#6,d0
+		move.b	d0,collision_property(a0)
		move.w	#$2F,$2E(a0)
		move.l	#BossMiniOrbinaut_Box_Control_Jump,$34(a0)
		sfx	sfx_Attachment2,0,0,0
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
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_SetWait:

-		jsr	(Random_Number).w
		andi.w	#$7F,d0
		beq.s	-
		addi.w	#$FF,d0
		move.w	d0,$2E(a0)
		move.l	#BossMiniOrbinaut_Box_Control_WaitJump,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_WaitJump:
		move.b	#_Setup5,routine(a0)
		move.w	#-$400,y_vel(a0)
		move.l	#BossMiniOrbinaut_Box_Control_CheckBounced2,$34(a0)
		tst.b	$40(a0)
		beq.s	BossMiniOrbinaut_Box_Control_WaitJump_Return
		move.w	(Player_1+x_pos).w,d0
		sub.w	x_pos(a0),d0
		asl.w	#1,d0
		move.w	d0,x_vel(a0)

BossMiniOrbinaut_Box_Control_WaitJump_Return:
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_CheckBounced2:
		move.w	y_vel(a0),d0
		bmi.s	BossMiniOrbinaut_Box_Control_WaitJump_Return
		cmpi.w	#$180,d0
		blo.s		BossMiniOrbinaut_Box_Control_StopVelocity
		asr.w	d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_StopVelocity:
		move.w	x_vel(a0),d0
		cmpi.w	#$80,d0
		blo.s		BossMiniOrbinaut_Box_Control_WaitJump2
		cmpi.w	#-$80,d0
		bhs.s	BossMiniOrbinaut_Box_Control_WaitJump2
		asr.w	d0
		move.w	d0,x_vel(a0)
		move.w	#$F,$2E(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Box_Control_WaitJump2:
		move.w	#$1F,$2E(a0)
		move.l	#BossMiniOrbinaut_Box_Control_MoveStop2,$34(a0)
		clr.w	x_vel(a0)

BossMiniOrbinaut_Box_Control_WaitJump2_Return:
		rts
; ---------------------------------------------------------------------------
; Проверка урона
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_Box_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	BossMiniOrbinaut_Box_Control_WaitJump2_Return
		tst.b	collision_property(a0)
		beq.w	BossMiniOrbinaut_Box_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.w	BossMiniOrbinaut_Box_CheckTouch_Flash

BossMiniOrbinaut_Box_CheckTouch_HitBoss:
		sfx	sfx_HitBoss,0,0,0
		move.b	#$60,$1C(a0)
		bset	#6,status(a0)
		cmpi.l	#Obj_BossMiniOrbinaut_CircularRotation_Control,address(a0)
		bne.s	BossMiniOrbinaut_Box_CheckTouch_CheckObj2
		lea	(Player_1).w,a1
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		move.w	#$400,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)

BossMiniOrbinaut_Box_CheckTouch_CheckObj2:
		cmpi.l	#Obj_BossMiniOrbinaut_Circular_Control,address(a0)
		bne.s	BossMiniOrbinaut_Box_CheckTouch_CheckObj3
		lea	(Player_1).w,a1
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		move.w	#$400,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)

BossMiniOrbinaut_Box_CheckTouch_CheckObj3:
		cmpi.l	#Obj_BossMiniOrbinaut_Snake,address(a0)
		bne.s	BossMiniOrbinaut_Box_CheckTouch_CheckObj4
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_DEZRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w

BossMiniOrbinaut_Box_CheckTouch_CheckObj4:
		cmpi.l	#Obj_BossMiniOrbinaut_SmallCircular_Control,address(a0)
		bne.s	BossMiniOrbinaut_Box_CheckTouch_Flash
		lea	(Player_1).w,a1
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		move.w	#$400,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)

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
		subq.b	#1,(vBMO_Count).w
		bne.s	+
		clr.b	(vBMO_Hurt).w
		movea.w	(vBMO_Parent).w,a1
		move.w	#$9F,$2E(a1)
		move.l	#BossMiniOrbinaut_Process_Wait,address(a1)
+
		sfx	sfx_BreakBridge,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		move.l	#Go_Delete_Sprite_3,address(a0)
		lea	ChildObjDat_DEZRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Столб из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxLeft:
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
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
		bsr.w	BossMiniOrbinaut_BoxLeft_CheckTouch
		moveq	#0,d0
		move.b	obBMO_Frame(a0),d0
		tst.w	y_vel(a0)
		beq.s	+
		bpl.s	++
+		addq.w	#2,d0
+		move.b	d0,mapping_frame(a0)
		moveq	#0,d0
		tst.b	(vBMO_Hurt).w
		bne.s	BossMiniOrbinaut_BoxLeft_Setup_NoTouch
		jmp	(Child_DrawTouch_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxLeft_Setup_NoTouch:
		jmp	(Child_Draw_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------
; Проверка урона
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_BoxLeft_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	BossMiniOrbinaut_BoxLeft_CheckTouch_Return
		tst.b	(vBMO_Hurt).w
		beq.s	BossMiniOrbinaut_BoxLeft_CheckTouch_Check
		tst.b	$1D(a0)
		beq.s	BossMiniOrbinaut_BoxLeft_CheckTouch_RestoreCollision2

BossMiniOrbinaut_BoxLeft_CheckTouch_Check:
		movea.w	$44(a0),a1
		tst.b	$1D(a1)
		bmi.s	BossMiniOrbinaut_BoxLeft_CheckTouch_RestoreCollision
		bne.s	BossMiniOrbinaut_BoxLeft_CheckTouch_Return
		subq.b	#1,collision_property(a1)
		move.b	#1,$1D(a1)
		st	$1D(a0)
		st	(vBMO_Hurt).w

BossMiniOrbinaut_BoxLeft_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxLeft_CheckTouch_RestoreCollision:
		clr.b	(vBMO_Hurt).w
		clr.b	$1D(a1)
		clr.b	$1D(a0)

BossMiniOrbinaut_BoxLeft_CheckTouch_RestoreCollision2:
		move.b	collision_restore_flags(a0),collision_flags(a0)
		addq.b	#1,collision_property(a0)
		rts
; ---------------------------------------------------------------------------
; Столб из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxRight:
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
		move.b	#16,objoff_3A(a0)
		move.l	#BossMiniOrbinaut_BoxLeft_Setup,address(a0)
		tst.b	subtype(a0)
		bne.s	+
		move.b	#28,child_dx(a0)
		move.b	#-28,child_dy(a0)
+		bra.w	BossMiniOrbinaut_BoxLeft_Setup
; ---------------------------------------------------------------------------
; Столб из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxUp:
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
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
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
		move.b	#16,objoff_3A(a0)
		move.b	#$40,objoff_3C(a0)
		move.l	#BossMiniOrbinaut_BoxLeft_Setup,address(a0)
		tst.b	subtype(a0)
		bne.s	+
		move.b	#-52,child_dx(a0)
		move.b	#20,child_dy(a0)
+		bra.w	BossMiniOrbinaut_BoxLeft_Setup
; ---------------------------------------------------------------------------
; Коробка из кучи маленьких босс-шаров (управление)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxJump_Control:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossMiniOrbinaut_BoxJump_Control_Index(pc,d0.w),d0
		jsr	BossMiniOrbinaut_BoxJump_Control_Index(pc,d0.w)
		bsr.w	BossMiniOrbinaut_Box_CheckTouch
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxJump_Control_Index: offsetTable
		offsetTableEntry.w BossMiniOrbinaut_BoxJump_Control_Init		; 0
		offsetTableEntry.w BossMiniOrbinaut_BoxJump_Control_Setup		; 2
		offsetTableEntry.w BossMiniOrbinaut_BoxJump_Control_Setup2	; 4
		offsetTableEntry.w BossMiniOrbinaut_BoxJump_Control_Setup3	; 6
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxJump_Control_Init:
		addq.b	#2,routine(a0)

		tst.w	$2E(a0)
		beq.s	+
		bset	#0,status(a0)
+



		move.w	(Camera_X_pos).w,d0
		move.w	#$1A0,d1
		move.b	#-$40,$30(a0)
		btst	#0,status(a0)
		beq.s	+
		neg.b	$30(a0)
		move.w	#-$B0,d1
+		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$40,d0
		move.w	d0,y_pos(a0)
		move.b	#6,collision_property(a0)
		move.b	#108/2,y_radius(a0)
		move.w	#$F,$2E(a0)
		move.l	#BossMiniOrbinaut_BoxJump_Control_SetFall,$34(a0)

		lea	ChildObjDat_BossMiniOrbinaut_BoxJumpUp(pc),a2
		jsr	(CreateChild8_TreeListRepeated).w
		lea	ChildObjDat_BossMiniOrbinaut_BoxJumpDown(pc),a2
		jsr	(CreateChild8_TreeListRepeated).w
		lea	ChildObjDat_BossMiniOrbinaut_BoxJumpLeft(pc),a2
		jsr	(CreateChild8_TreeListRepeated).w
		lea	ChildObjDat_BossMiniOrbinaut_BoxJumpRight(pc),a2
		jmp	(CreateChild8_TreeListRepeated).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxJump_Control_Setup:
		jsr	(MoveSprite).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxJump_Control_Setup2:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxJump_Control_Setup3:
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w

; =============== S U B R O U T I N E =======================================

BossMiniOrbinaut_BoxJump_Control_SetFall:
		move.b	#_Setup3,routine(a0)
		move.l	#BossMiniOrbinaut_BoxJump_Control_CheckBounced,$34(a0)

BossMiniOrbinaut_BoxJump_Control_Return:
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxJump_Control_CheckBounced:
		move.w	y_vel(a0),d0
		bmi.s	BossMiniOrbinaut_BoxJump_Control_Return
		cmpi.w	#$180,d0
		blo.s		BossMiniOrbinaut_BoxJump_Control_SetLittleOpen
		asr.w	d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxJump_Control_SetLittleOpen:
		move.b	#_Setup2,routine(a0)
		move.l	#BossMiniOrbinaut_BoxJump_Control_StopVelocity,$34(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxJump_Control_StopVelocity:
		move.w	x_vel(a0),d0
		cmpi.w	#$80,d0
		blo.s		BossMiniOrbinaut_BoxJump_Control_WaitJump
		cmpi.w	#-$80,d0
		bhs.s	BossMiniOrbinaut_BoxJump_Control_WaitJump
		asr.w	d0
		move.w	d0,x_vel(a0)
		move.w	#$F,$2E(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxJump_Control_WaitJump:
		move.w	#$7F,$2E(a0)
		move.l	#BossMiniOrbinaut_BoxJump_Control_LittleOpen,$34(a0)
		clr.w	x_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_BoxJump_Control_LittleOpen:
		move.l	#BossMiniOrbinaut_BoxJump_Control_SetFall,$34(a0)
		move.w	(Player_1+x_pos).w,d0
		sub.w	x_pos(a0),d0
		asl.w	#1,d0
		move.w	d0,x_vel(a0)
		move.w	#-$580,y_vel(a0)
		rts
; ---------------------------------------------------------------------------
; Столб из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxJumpLeft:
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
		move.b	#16,objoff_3A(a0)
		move.l	#BossMiniOrbinaut_BoxLeft_Setup,address(a0)
		tst.b	subtype(a0)
		bne.s	+
		move.b	#-74,child_dx(a0)
		move.b	#-58,child_dy(a0)
+		bra.w	BossMiniOrbinaut_BoxLeft_Setup
; ---------------------------------------------------------------------------
; Столб из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxJumpRight:
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
		move.b	#16,objoff_3A(a0)
		move.l	#BossMiniOrbinaut_BoxLeft_Setup,address(a0)
		tst.b	subtype(a0)
		bne.s	+
		move.b	#70,child_dx(a0)
		move.b	#-58,child_dy(a0)
+		bra.w	BossMiniOrbinaut_BoxLeft_Setup
; ---------------------------------------------------------------------------
; Столб из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxJumpUp:
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
		move.b	#16,objoff_3A(a0)
		move.b	#$40,objoff_3C(a0)
		move.l	#BossMiniOrbinaut_BoxLeft_Setup,address(a0)
		tst.b	subtype(a0)
		bne.s	+
		move.b	#-74,child_dx(a0)
		move.b	#-42,child_dy(a0)
+		bra.w	BossMiniOrbinaut_BoxLeft_Setup
; ---------------------------------------------------------------------------
; Столб из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_BoxJumpDown:
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#3,obBMO_Frame(a0)
		move.b	#3,collision_property(a0)
		move.b	#16,objoff_3A(a0)
		move.b	#$40,objoff_3C(a0)
		move.l	#BossMiniOrbinaut_BoxLeft_Setup,address(a0)
		tst.b	subtype(a0)
		bne.s	+
		move.b	#-90,child_dx(a0)
		move.b	#54,child_dy(a0)
+		bra.w	BossMiniOrbinaut_BoxLeft_Setup
; ---------------------------------------------------------------------------
; Змея из кучи маленьких босс-шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Snake:
		bsr.w	Obj_ChasingBall_SendPos
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossMiniOrbinaut_Snake_Index(pc,d0.w),d0
		jsr	BossMiniOrbinaut_Snake_Index(pc,d0.w)
		bsr.w	BossMiniOrbinaut_Box_CheckTouch
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

BossMiniOrbinaut_Snake_Index: offsetTable
		offsetTableEntry.w BossMiniOrbinaut_Snake_Init		; 0
		offsetTableEntry.w BossMiniOrbinaut_Snake_Setup1	; 2
		offsetTableEntry.w BossMiniOrbinaut_Snake_Setup2	; 4
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Snake_Init:
		clearRAM3 Pos_objtable_Start, Pos_objtable_End
		lea	ObjDat3_BossMiniOrbinaut(pc),a1
		jsr	(SetUp_ObjAttributes).w

		tst.w	$2E(a0)
		beq.s	+
		bset	#0,status(a0)
+
		move.w	(Camera_X_pos).w,d0
		move.w	#$1A0,d1
		btst	#0,status(a0)
		beq.s	+
		move.w	#-$B0,d1
+		add.w	d1,d0
		move.w	d0,x_pos(a0)

		move.w	(Camera_Y_pos).w,d0
		addi.w	#$CF,d0
		move.w	d0,y_pos(a0)
		move.b	#17,collision_property(a0)
		move.b	#3,obBMO_Frame(a0)
		move.w	#$9F,$2E(a0)
		move.l	#BossMiniOrbinaut_Snake_SetJump,$34(a0)
		lea	ChildObjDat_BossMiniOrbinaut_Snake_Trail(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Snake_Setup1:
		moveq	#sfx_SpikeBall,d0
		moveq	#$F,d2
		jsr	(Wait_Play_Sound).w
		jsr	(Find_SonicTails).w
		move.w	#$300,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectXOnly).w
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Snake_Setup2:
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Snake_SetJump:
		move.b	#_Setup2,routine(a0)
		move.w	#-$600,y_vel(a0)
		sfx	sfx_Jump3,0,0,0
		move.l	#BossMiniOrbinaut_Snake_Jump,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Snake_Jump:
		move.b	#_Setup1,routine(a0)
		move.w	#$9F,$2E(a0)
		move.l	#BossMiniOrbinaut_Snake_SetJump,$34(a0)
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------
; Змея из кучи маленьких босс-шаров (тень)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossMiniOrbinaut_Snake_Trail:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.b	d0,d1
		lsr.b	#1,d1
		addq.b	#1,d1
		move.b	d1,$30(a0)
		lsl.b	#3,d0
		addi.b	#$10,d0
		move.b	d0,$39(a0)
		lea	ObjDat3_BossMiniOrbinaut_Snake_Trail(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#+,address(a0)
+		bsr.w	Obj_ChasingBall_CopyPos
		movea.w	parent3(a0),a1
		jsr	(Find_OtherObject).w
		jsr	(Change_FlipX2).w
		moveq	#0,d1
		move.b	$30(a0),d1
		cmp.b	collision_property(a1),d1
		beq.s	BossMiniOrbinaut_Snake_Trail_Remove
		moveq	#0,d0
		btst	#6,status(a1)
		bne.s	BossMiniOrbinaut_Snake_Trail_NoDraw
		jmp	(Child_DrawTouch_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Snake_Trail_NoDraw:
		jmp	(Child_Draw_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_Snake_Trail_Remove:
		move.l	#Go_Delete_Sprite,address(a0)
		rts
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
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_MissileExplosive_Index: offsetTable
		offsetTableEntry.w BossMiniOrbinaut_MissileExplosive_Init		; 0
		offsetTableEntry.w BossMiniOrbinaut_MissileExplosive_Setup	; 2
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

BossMiniOrbinaut_MissileExplosive_Setup:
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_MissileExplosive_Bounced:
		sfx	sfx_BreakBridge,0,0,0
		move.l	#Go_Delete_Sprite,address(a0)
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
		sfx	sfx_BreakBridge,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		move.l	#Go_Delete_Sprite,address(a0)
		lea	ChildObjDat_DEZRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossMiniOrbinaut_MissileExplosive_CheckTouch_Return:
		rts

; =============== S U B R O U T I N E =======================================

ObjDat3_BossMiniOrbinaut:
		dc.l Map_MiniOrbinaut
		dc.w $E170
		dc.w $180
		dc.b 16/2
		dc.b 16/2
		dc.b 0
		dc.b $B
ObjDat3_BossMiniOrbinaut_Snake_Trail:
		dc.w $180
		dc.b 16/2
		dc.b 16/2
		dc.b 0
		dc.b $B|$80
ChildObjDat_BossMiniOrbinaut_Multitude:
		dc.w 24-1
		dc.l Obj_BossMiniOrbinaut_Multitude
ChildObjDat_BossMiniOrbinaut_SmallCircular_Control:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_SmallCircular_Control
ChildObjDat_BossMiniOrbinaut_SmallCircular:
		dc.w 8-1
		dc.l Obj_BossMiniOrbinaut_SmallCircular
ChildObjDat_BossMiniOrbinaut_Circular_Control:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_Circular_Control
ChildObjDat_BossMiniOrbinaut_Circular:
		dc.w 16-1
		dc.l Obj_BossMiniOrbinaut_Circular
ChildObjDat_BossMiniOrbinaut_CircularRotation_Control:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_CircularRotation_Control
ChildObjDat_BossMiniOrbinaut_CircularRotation_Control2:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_CircularRotation_Control2
ChildObjDat_BossMiniOrbinaut_CircularRotation:
		dc.w 16-1
		dc.l Obj_BossMiniOrbinaut_CircularRotation
ChildObjDat_BossMiniOrbinaut_CircularRotation2:
		dc.w 16-1
		dc.l Obj_BossMiniOrbinaut_CircularRotation2
ChildObjDat_BossMiniOrbinaut_Box_Control:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_Box_Control
ChildObjDat_BossMiniOrbinaut_Box_Control2:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_Box_Control2
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
ChildObjDat_BossMiniOrbinaut_BoxJump_Control:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_BoxJump_Control
ChildObjDat_BossMiniOrbinaut_BoxJumpUp:
		dc.w 9-1
		dc.l Obj_BossMiniOrbinaut_BoxJumpUp
ChildObjDat_BossMiniOrbinaut_BoxJumpDown:
		dc.w 10-1
		dc.l Obj_BossMiniOrbinaut_BoxJumpDown
ChildObjDat_BossMiniOrbinaut_BoxJumpLeft:
		dc.w 7-1
		dc.l Obj_BossMiniOrbinaut_BoxJumpLeft
ChildObjDat_BossMiniOrbinaut_BoxJumpRight:
		dc.w 7-1
		dc.l Obj_BossMiniOrbinaut_BoxJumpRight
ChildObjDat_BossMiniOrbinaut_Snake:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_Snake
ChildObjDat_BossMiniOrbinaut_Snake_Trail:
		dc.w 8-1
		dc.l Obj_BossMiniOrbinaut_Snake_Trail
ChildObjDat_BossMiniOrbinaut_MissileExplosive:
		dc.w 1-1
		dc.l Obj_BossMiniOrbinaut_MissileExplosive