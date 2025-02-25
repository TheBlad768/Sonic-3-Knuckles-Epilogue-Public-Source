; ---------------------------------------------------------------------------
; Босс-смертельный шар
; ---------------------------------------------------------------------------

; Hits
BossRobot_Hits	= 8

; Attributes
_Setup1			= 2
_Setup2			= 4
_Setup3			= 6

; Animates
setOpen			= 1
setClose			= 2

; =============== S U B R O U T I N E =======================================

Obj_BossRobot:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossRobot_Index(pc,d0.w),d0
		jsr	BossRobot_Index(pc,d0.w)
		bsr.w	BossRobot_CheckTouch
		lea	Ani_BossRobot(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

BossRobot_Index: offsetTable
		offsetTableEntry.w BossRobot_Init		; 0
		offsetTableEntry.w BossRobot_Setup		; 2
		offsetTableEntry.w BossRobot_Setup2	; 4
; ---------------------------------------------------------------------------

BossRobot_Init:
		lea	ObjDat3_BossRobot(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	collision_property(a0)
		st	(Boss_flag).w
		move.b	#36,y_radius(a0)
		move.l	#BossRobot_Robotnik_Intro,$34(a0)
		jmp	(Swing_Setup1).w
; ---------------------------------------------------------------------------

BossRobot_Setup2:
		move.w	$3A(a0),d0
		sub.w	x_pos(a0),d0
		asl.w	#4,d0
		move.w	d0,x_vel(a0)

BossRobot_Setup:
		jsr	(Swing_UpAndDown).w
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w

; =============== S U B R O U T I N E =======================================

BossRobot_Robotnik_Intro:
		bset	#3,$38(a0)
		move.l	#BossRobot_Robotnik_Intro_Return,$34(a0)
		lea	ChildObjDat_Robotnik_Intro(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossRobot_Robotnik_Intro_FindRobotnik_Start:
		sfx	sfx_Boom,0,0,0
		movea.w	$44(a0),a1
		move.b	#_Setup1,routine(a1)
		move.w	#$F,$2E(a0)
		move.l	#BossRobot_Robotnik_Intro_FindRobotnik,$34(a0)
		clr.b	(Screen_shaking_flag).w
		rts
; ---------------------------------------------------------------------------

BossRobot_Robotnik_Intro_FindRobotnik:
		movea.w	$44(a0),a1
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		subq.w	#8,d0
		bne.s	+
		move.l	#BossRobot_Robotnik_Intro_Return,$34(a0)
+		asl.w	#4,d0
		move.w	d0,x_vel(a0)

BossRobot_Robotnik_Intro_Return:
		rts

; =============== S U B R O U T I N E =======================================

BossRobot_Startup:
		andi.b	#-$D,$38(a0)
		tst.b	(GoodMode_flag).w
		beq.s	BossRobot_Startup_SkipSecurity
		move.b	#BossRobot_Hits,collision_property(a0)

BossRobot_Startup_SkipSecurity:
		move.w	#$4F,$2E(a0)
		clr.b	(Ctrl_1_locked).w
		jsr	(Restore_PlayerControl).w
		lea	ChildObjDat_BossRobot_CreateShield_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		move.l	#BossRobot_MoveFallingBall_Start,d0
		bra.s	BossRobot_SetSubroutine
; ---------------------------------------------------------------------------

BossRobot_CheckSubroutine:
		lea	BossRobot_Movement(pc),a1
		cmpi.b	#(BossRobot_Hits/2)+1,collision_property(a0)
		bhs.s	BossRobot_LoadSubroutine
		lea	BossRobot_Movement2(pc),a1

BossRobot_LoadSubroutine:
		jsr	(Random_Number).w
		andi.w	#6,d0
		movea.l	a1,a2
		adda.w	(a2,d0.w),a2
		move.l	a2,d0
		cmp.l	$30(a0),d0
		beq.s	BossRobot_LoadSubroutine

BossRobot_SetSubroutine:
		move.l	d0,$30(a0)
		move.l	d0,$34(a0)
		move.b	#_Setup1,routine(a0)
		clr.w	x_vel(a0)
		clearRAM3 Pos_objtable_Start, Pos_objtable_End
		rts
; ---------------------------------------------------------------------------

BossRobot_Movement: offsetTable
		offsetTableEntry.w BossRobot_MoveFallingBall_Start		; 0
		offsetTableEntry.w BossRobot_MoveCircularChaseBall_Start	; 2
		offsetTableEntry.w BossRobot_MoveRepulsionBall_Start	; 4
		offsetTableEntry.w BossRobot_MoveShootingBall_Start		; 6
BossRobot_Movement2: offsetTable
		offsetTableEntry.w BossRobot_MoveFallingWaitBall_Start	; 0
		offsetTableEntry.w BossRobot_MoveRepulsionBall_Start	; 2
		offsetTableEntry.w BossRobot_MoveMultiplyingBall_Start	; 4
		offsetTableEntry.w BossRobot_MoveSwingBall_Start		; 6
; ---------------------------------------------------------------------------
; Босс атакует с помощью падающего шара
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossRobot_MoveFallingBall_Start:
		move.b	#4,$39(a0)

BossRobot_MoveFallingBall_FindSonic:
		move.b	#_Setup2,routine(a0)
		move.w	#$2F,$2E(a0)
		move.w	(Player_1+x_pos).w,$3A(a0)
		move.l	#BossRobot_MoveFallingBall_WaitAttack,$34(a0)
		sfx	sfx_Boom,1,0,0
; ---------------------------------------------------------------------------

BossRobot_MoveFallingBall_WaitAttack:
		move.b	#_Setup1,routine(a0)
		move.w	#$F,$2E(a0)
		move.l	#BossRobot_MoveFallingBall_Attack,$34(a0)
		clr.w	x_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossRobot_MoveFallingBall_Attack:
		move.w	#$1F,$2E(a0)
		move.l	#BossRobot_MoveFallingBall_FindSonic,d0
		subq.b	#1,$39(a0)
		bne.s	+
		move.l	#BossRobot_CheckSubroutine,d0
+		move.l	d0,$34(a0)
		lea	ChildObjDat_FallingBall(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Босс атакует с помощью циркулирующих шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossRobot_MoveCircularChaseBall_Start:
		sfx	sfx_Boom,0,0,0
		move.l	#BossRobot_MoveCircularChaseBall_CheckPosition,$34(a0)

BossRobot_MoveCircularChaseBall_CheckPosition:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.l	#BossRobot_MoveCircularChaseBall_Create,$34(a0)
+		asl.w	#4,d0
		move.w	d0,x_vel(a0)

BossRobot_MoveCircularChaseBall_Wait:
		rts
; ---------------------------------------------------------------------------

BossRobot_MoveCircularChaseBall_Create:
		move.l	#BossRobot_MoveCircularChaseBall_Wait,$34(a0)
		lea	ChildObjDat_CircularBall(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossRobot_MoveCircularChaseBall_SetMove:
		move.l	#BossRobot_MoveCircularChaseBall_Move,$34(a0)
		jsr	(Find_SonicTails).w
		move.w	#$80,x_vel(a0)
		tst.w	d0
		beq.s	BossRobot_MoveCircularChaseBall_Move
		neg.w	x_vel(a0)

BossRobot_MoveCircularChaseBall_Move:
		move.w	(Camera_X_pos).w,d0
		tst.w	x_vel(a0)
		bpl.s	+
		addi.w	#$40,d0			; Проверить левую сторону
		cmp.w	x_pos(a0),d0
		bhs.s	++
		bra.s	+++
+		addi.w	#$100,d0		; Проверить правую сторону
		cmp.w	x_pos(a0),d0
		bhs.s	++
+		neg.w	x_vel(a0)
+		rts
; ---------------------------------------------------------------------------
; Босс атакует с помощью отталкивающихся шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossRobot_MoveRepulsionBall_Start:
		move.l	#BossRobot_MoveRepulsionBall_CheckPosition,$34(a0)
		sfx	sfx_Boom,0,0,0
		jsr	(Random_Number).w
		andi.w	#6,d0
		move.w	d0,$3C(a0)
		move.w	BossRobot_SetPos(pc,d0.w),$3A(a0)

BossRobot_MoveRepulsionBall_CheckPosition:
		move.w	(Camera_X_pos).w,d0
		add.w	$3A(a0),d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.l	#BossRobot_MoveRepulsionBall_Create,$34(a0)
+		asl.w	#4,d0
		move.w	d0,x_vel(a0)

BossRobot_MoveRepulsionBall_Wait:
		rts
; ---------------------------------------------------------------------------

BossRobot_SetPos:
		dc.w $40		; Левая сторона
		dc.w $A0	; Середина
		dc.w $100	; Правая сторона
		dc.w $A0	; Середина
BossRobot_SetPos2:
		dc.w -$40	; Левая сторона
		dc.w -$40	; Середина
		dc.w $180	; Правая сторона
		dc.w $180	; Середина
BossRobot_SetPos3:
		dc.w $40		; Левая сторона
		dc.w $40		; Середина
		dc.w $100	; Правая сторона
		dc.w $100	; Середина
; ---------------------------------------------------------------------------

BossRobot_MoveRepulsionBall_Create:
		move.w	#$3F,$2E(a0)
		move.l	#BossRobot_MoveRepulsionBall_SetHidePosition,$34(a0)
		lea	ChildObjDat_RepulsionBall(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossRobot_MoveRepulsionBall_SetHidePosition:
		andi.b	#-$D,$38(a0)
		move.b	#setClose,anim(a0)
		sfx	sfx_Boom,0,0,0
		move.l	#BossRobot_MoveRepulsionBall_HidePosition,$34(a0)
		move.w	$3C(a0),d0
		move.w	BossRobot_SetPos2(pc,d0.w),$3A(a0)

BossRobot_MoveRepulsionBall_HidePosition:
		move.w	(Camera_X_pos).w,d0
		add.w	$3A(a0),d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.l	#BossRobot_MoveRepulsionBall_Wait,$34(a0)
+		asl.w	#4,d0
		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossRobot_MoveRepulsionBall_SetReturnPosition:
		sfx	sfx_Boom,0,0,0
		move.l	#BossRobot_MoveRepulsionBall_ReturnPosition,$34(a0)
		move.w	$3C(a0),d0
		move.w	BossRobot_SetPos3(pc,d0.w),$3A(a0)

BossRobot_MoveRepulsionBall_ReturnPosition:
		move.w	(Camera_X_pos).w,d0
		add.w	$3A(a0),d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.l	#BossRobot_CheckSubroutine,$34(a0)
+		asl.w	#4,d0
		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------
; Босс атакует с помощью циркулирующих шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossRobot_MoveShootingBall_Start:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	#$40,$3A(a0)
		sub.w	x_pos(a0),d0
		bgt.s	+
		move.w	#$100,$3A(a0)
+		sfx	sfx_Boom,0,0,0
		move.l	#BossRobot_MoveShootingBall_CheckPosition,$34(a0)

BossRobot_MoveShootingBall_CheckPosition:
		move.w	(Camera_X_pos).w,d0
		add.w	$3A(a0),d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.l	#BossRobot_MoveShootingBall_Create,$34(a0)
+		asl.w	#4,d0
		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossRobot_MoveShootingBall_Create:
		move.w	$3A(a0),d0
		move.w	#-$40,d1
		cmpi.w	#$100,d0
		bne.s	+
		move.w	#$180,d1
+		move.w	d1,$3A(a0)
		move.w	#$6F,$2E(a0)
		move.l	#BossRobot_MoveShootingBall_HidePosition,$34(a0)
		lea	ChildObjDat_ShootingBall(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossRobot_MoveShootingBall_HidePosition:
		move.w	(Camera_X_pos).w,d0
		add.w	$3A(a0),d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.l	#BossRobot_MoveShootingBall_Wait,$34(a0)
+		asl.w	#4,d0
		move.w	d0,x_vel(a0)

BossRobot_MoveShootingBall_Wait:
		rts
; ---------------------------------------------------------------------------

BossRobot_MoveShootingBall_SetReturnPosition:
		sfx	sfx_Boom,0,0,0
		move.l	#BossRobot_MoveRepulsionBall_ReturnPosition,$34(a0)
		move.w	$3A(a0),d0
		move.w	#$40,d1
		cmpi.w	#$180,d0
		bne.s	+
		move.w	#$100,d1
+		move.w	d1,$3A(a0)
		rts
; ---------------------------------------------------------------------------
; Выстрел кучей падающих шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossRobot_MoveFallingWaitBall_Start:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	#$40,$3A(a0)
		sub.w	x_pos(a0),d0
		bgt.s	+
		move.w	#$100,$3A(a0)
+		sfx	sfx_Boom,0,0,0
		move.l	#BossRobot_MoveFallingWaitBall_CheckPosition,$34(a0)

BossRobot_MoveFallingWaitBall_CheckPosition:
		move.w	(Camera_X_pos).w,d0
		add.w	$3A(a0),d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.w	#$DF,$2E(a0)
		bset	#3,$38(a0)
		move.b	#setOpen,anim(a0)
		lea	ChildObjDat_FallingWaitBall_Intro(pc),a2
		jsr	(CreateChild6_Simple).w
		move.l	#BossRobot_MoveFallingWaitBall_SetHidePosition,$34(a0)
+		asl.w	#4,d0
		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossRobot_MoveFallingWaitBall_SetHidePosition:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	#-$40,$3A(a0)
		sub.w	x_pos(a0),d0
		bgt.s	+
		move.w	#$180,$3A(a0)
+		andi.b	#-$D,$38(a0)
		move.b	#setClose,anim(a0)
		sfx	sfx_Boom,0,0,0
		move.l	#BossRobot_MoveFallingWaitBall_CheckHidePosition,$34(a0)

BossRobot_MoveFallingWaitBall_CheckHidePosition:
		move.w	(Camera_X_pos).w,d0
		add.w	$3A(a0),d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.b	#3,$39(a0)
		move.w	#$F,$2E(a0)
		move.l	#BossRobot_MoveFallingWaitBall_Create,$34(a0)
+		asl.w	#4,d0
		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossRobot_MoveFallingWaitBall_Create:
		move.w	#$14F,$2E(a0)
		bsr.s	BossRobot_MoveFallingWaitBall_CreateBallAim
		subq.b	#1,$39(a0)
		bne.s	BossRobot_MoveFallingWaitBall_Return
		move.l	#BossRobot_MoveFallingWaitBall_ReturnBack,$34(a0)

BossRobot_MoveFallingWaitBall_Return:
		rts
; ---------------------------------------------------------------------------

BossRobot_MoveFallingWaitBall_CreateBallAim:
		jsr	(Random_Number).w
		andi.w	#$E,d0
		move.w	ObjDat_FallingWaitBall_Xpos_Random(pc,d0.w),d0
		cmp.w	$3A(a0),d0
		beq.s	BossRobot_MoveFallingWaitBall_CreateBallAim
		move.w	d0,$3A(a0)
		move.w	d0,$3C(a0)
		lea	ObjDat_FallingWaitBall_Xpos(pc),a2
		cmpi.w	#$90,$3C(a0)
		blo.s		+
		lea	ObjDat_FallingWaitBall_Xpos_Negative(pc),a2
+		moveq	#0,d2
		move.w	#9-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	+
		move.l	#Obj_FallingWaitBall,address(a1)
		move.w	a0,parent3(a1)
-		move.w	(a2)+,d0
		cmp.w	$3C(a0),d0
		beq.s	-
		add.w	(Camera_X_pos).w,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		subi.w	#$20,d0
		move.w	d0,y_pos(a1)
		move.b	d2,subtype(a1)
		addq.w	#2,d2
		dbf	d1,--
		move.w	$3C(a0),$3E(a1)
+		rts
; ---------------------------------------------------------------------------

ObjDat_FallingWaitBall_Xpos_Random:
		dc.w $50
		dc.w $F0
		dc.w $90
		dc.w $B0
		dc.w $70
		dc.w $110
		dc.w $30
		dc.w $D0
ObjDat_FallingWaitBall_Xpos:
		dc.w $10
		dc.w $30
		dc.w $50
		dc.w $70
		dc.w $90
		dc.w $B0
		dc.w $D0
		dc.w $F0
		dc.w $110
		dc.w $130
ObjDat_FallingWaitBall_Xpos_Negative:
		dc.w $130
		dc.w $110
		dc.w $F0
		dc.w $D0
		dc.w $B0
		dc.w $90
		dc.w $70
		dc.w $50
		dc.w $30
		dc.w $10
; ---------------------------------------------------------------------------

BossRobot_MoveFallingWaitBall_ReturnBack:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	#$40,$3A(a0)
		sub.w	x_pos(a0),d0
		bgt.s	+
		move.w	#$100,$3A(a0)
+		andi.b	#-$D,$38(a0)
		move.b	#setClose,anim(a0)
		sfx	sfx_Boom,0,0,0
		move.l	#BossRobot_MoveFallingWaitBall_CheckReturnPosition,$34(a0)

BossRobot_MoveFallingWaitBall_CheckReturnPosition:
		move.w	(Camera_X_pos).w,d0
		add.w	$3A(a0),d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.w	#$F,$2E(a0)
		move.l	#BossRobot_CheckSubroutine,$34(a0)
+		asl.w	#4,d0
		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------
; Выстрел кучей падающих шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossRobot_MoveSwingBall_Start:
		move.b	#4,$39(a0)

BossRobot_MoveSwingBall_FindSonic:
		move.b	#_Setup2,routine(a0)
		move.w	#$2F,$2E(a0)
		move.w	(Player_1+x_pos).w,$3A(a0)
		move.l	#BossRobot_MoveSwingBall_Attack,$34(a0)
		clearRAM3 Pos_objtable_Start, Pos_objtable_End
		sfx	sfx_Boom,1,0,0
; ---------------------------------------------------------------------------

BossRobot_MoveSwingBall_Attack:
		move.b	#_Setup1,routine(a0)
		clr.w	x_vel(a0)
		move.w	#$7F,$2E(a0)
		move.l	#BossRobot_MoveSwingBall_FindSonic,$34(a0)
		subq.b	#1,$39(a0)
		bne.s	+
		move.l	#BossRobot_CheckSubroutine,$34(a0)
+		lea	ChildObjDat_SwingBall(pc),a2
		jmp	(CreateChild1_Normal).w
; ---------------------------------------------------------------------------
; Выстрел умножающимся шаром
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossRobot_MoveMultiplyingBall_Start:
		sfx	sfx_Boom,0,0,0
		move.l	#BossRobot_MoveMultiplyingBall_CheckPosition,$34(a0)

BossRobot_MoveMultiplyingBall_CheckPosition:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.l	#BossRobot_MoveMultiplyingBall_Create,$34(a0)
+		asl.w	#4,d0
		move.w	d0,x_vel(a0)

BossRobot_MoveMultiplyingBall_Wait:
		rts
; ---------------------------------------------------------------------------

BossRobot_MoveMultiplyingBall_Create:
		move.l	#BossRobot_MoveMultiplyingBall_Wait,$34(a0)
		lea	ChildObjDat_MultiplyingBall(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Проверка урона
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossRobot_CheckTouch:
		btst	#4,$38(a0)
		bne.s	BossRobot_CheckTouch_Return
		tst.b	collision_flags(a0)
		bne.s	BossRobot_CheckTouch_Return
		tst.b	collision_property(a0)
		beq.s	BossRobot_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.s	+
		move.b	#$80,$1C(a0)
		sfx	sfx_HitBoss,0,0,0
		bset	#6,status(a0)
+		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	+
		addi.w	#6*2,d0
+		bsr.w	BossRobot_PalFlash
		subq.b	#1,$1C(a0)
		bne.s	BossRobot_CheckTouch_Return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

BossRobot_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

BossRobot_CheckTouch_WaitExplosive:
		move.l	#BossRobot_CheckTouch_WaitPlayerExplosive,address(a0)
		move.w	#$2020,$3A(a0)
		bset	#7,status(a0)
		clr.l	x_vel(a0)
		clr.w	$2E(a0)
		clr.b	(Update_HUD_timer).w	; Stop
		jmp	(BossDefeated_NoTime).w
; ---------------------------------------------------------------------------

BossRobot_CheckTouch_WaitPlayerExplosive:
		lea	(Player_1).w,a1
		btst	#Status_InAir,status(a1)
		bne.s	BossRobot_CheckTouch_TimeExplosive
		move.l	#BossRobot_CheckTouch_TimeExplosive,address(a0)
		clr.w	(Ctrl_1_logical).w
		st	(NoPause_flag).w
		jsr	(Find_SonicTails).w
		move.b	#$81,object_control(a1)
		move.w	#id_LookUp<<8,anim(a1)
		jsr	(Stop_Object).w
		bclr	#Status_Facing,status(a1)
		tst.w	d0
		beq.s	+
		bset	#Status_Facing,status(a1)
+		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossRobot_CheckTouch_TimeExplosive
		move.b	#_Defeated,routine(a1)
		move.l	#DialogDefeated_Process_Index-4,$34(a1)
		move.b	#(DialogDefeated_Process_Index_End-DialogDefeated_Process_Index)/8,$39(a1)

BossRobot_CheckTouch_TimeExplosive:
		subq.w	#1,$2E(a0)
		bpl.s	+
		bsr.w	loc_83E7E
+		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

BossRobot_CheckTouch_Explosive:
		move.l	#Wait_NewDelay,address(a0)
		move.l	#BossRobot_CheckTouch_Explosive_SetFalling,$34(a0)
		lea	Child6_CreateBossExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

BossRobot_CheckTouch_Explosive_SetFalling:
		move.l	#DEZ1_Resize_timer,(Level_data_addr_RAM.Resize).w
		lea	PLC_Robotnik(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		move.l	#BossRobot_CheckTouch_Explosive_Falling,address(a0)

BossRobot_CheckTouch_Explosive_Falling:
		jsr	(MoveSprite_LightGravity).w
		pea	(Draw_Sprite).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	BossRobot_CheckTouch_Return
		add.w	d1,y_pos(a0)
		bclr	#7,render_flags(a0)
		clr.b	(Boss_flag).w
		move.b	#$4F,(Negative_flash_timer).w
		bset	#7,status(a0)
		bset	#4,$38(a0)
		move.l	#Go_Delete_Sprite_3,address(a0)
		sfx	sfx_WallSmash,0,0,0
		lea	ChildObjDat_BossRobot_FlickerMove(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_RobotnikJetpack_Intro(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Создание щита
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossRobot_CreateShield_Process:
		move.w	#$4F,$2E(a0)
		move.l	#BossRobot_CreateShield_Process_Wait,address(a0)

BossRobot_CreateShield_Process_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	BossRobot_CreateShield_Return
		move.l	#BossRobot_CreateShield_Process_Main,address(a0)

BossRobot_CreateShield_Process_Main:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	DEZExplosion_Delete
		btst	#4,$38(a1)
		bne.s	BossRobot_CreateShield_Return
		tst.b	$1C(a1)
		bne.s	BossRobot_CreateShield_HurtBoss
		subq.w	#1,$2E(a0)
		bpl.s	BossRobot_CreateShield_Return
		bra.s	BossRobot_CreateShield_LoadShield
; ---------------------------------------------------------------------------

BossRobot_CreateShield_HurtBoss:
		move.l	#BossRobot_CreateShield_HurtBossWait,address(a0)

BossRobot_CreateShield_HurtBossWait:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	DEZExplosion_Delete
		tst.b	$1C(a1)
		bne.s	BossRobot_CreateShield_Return

BossRobot_CreateShield_LoadShield:
		move.w	a0,-(sp)
		movea.w	parent3(a0),a0
		bset	#4,$38(a0)
		clr.b	collision_flags(a0)
		lea	ChildObjDat_BossRobot_Shield(pc),a2
		jsr	(CreateChild6_Simple).w
		movea.w	(sp)+,a0
		sfx	sfx_Magnet,0,0,0
		move.w	#$4F,$2E(a0)
		move.l	#BossRobot_CreateShield_Process_Main,address(a0)

BossRobot_CreateShield_Return:
		rts
; ---------------------------------------------------------------------------
; Тень
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ChasingBall_Trail:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.b	#4,d0
		addi.b	#$24,d0
		move.b	d0,$39(a0)
		lea	ObjDat3_ChasingBall_Trail(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#+,address(a0)
+		jsr	(Child_GetVRAMPriorityOnce).w
		bsr.w	Obj_ChasingBall_CopyPos
		bra.s	ChasingBall_Trail_2_Main
; ---------------------------------------------------------------------------

ChasingBall_Trail_NoDraw:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		beq.s	+
		move.l	#loc_849E2,address(a0)
+		rts
; ---------------------------------------------------------------------------
; Тень 2
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ChasingBall_Trail_2:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.b	#4,d0
		addi.b	#$24,d0
		move.b	d0,$39(a0)
		lea	ObjDat3_ChasingBall_Trail(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#+,address(a0)
+		jsr	(Child_GetVRAMPriorityOnce).w
		bsr.w	Obj_ChasingBall_CopyPos2

ChasingBall_Trail_2_Main:
		btst	#1,subtype(a0)
		bne.s	ChasingBall_Trail_2_Check
		btst	#0,(Level_frame_counter+1).w
		beq.s	ChasingBall_Trail_NoDraw

ChasingBall_Trail_2_Draw:
		jmp	(Child_Draw_Sprite_Explosion).w
; ---------------------------------------------------------------------------

ChasingBall_Trail_2_Check:
		btst	#0,(Level_frame_counter+1).w
		beq.s	ChasingBall_Trail_2_Draw

ChasingBall_Trail_2_NoDraw:
		bra.s	ChasingBall_Trail_NoDraw
; ---------------------------------------------------------------------------
; Тень отталкивающегося шара
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_RepulsionBall_Trail:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.b	#3,d0
		addi.b	#$14,d0
		move.b	d0,$39(a0)
		lea	ObjDat3_ChasingBall_Trail(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#+,address(a0)
+		bsr.w	Obj_ChasingBall_CopyPos
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.s	RepulsionBall_Trail_SetRemove
		jsr	(Add_SpriteToCollisionResponseList).w

RepulsionBall_Trail_Draw:
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

RepulsionBall_Trail_SetRemove:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsr.w	#1,d0
		move.w	d0,$2E(a0)
		move.l	#RepulsionBall_Trail_WaitRemove,address(a0)

RepulsionBall_Trail_WaitRemove:
		subq.w	#1,$2E(a0)
		bpl.s	RepulsionBall_Trail_Draw
		bset	#7,status(a0)
		move.l	#loc_1E746,address(a0)
		move.w	#4,(Screen_shaking_flag).w
		btst	#2,subtype(a0)
		beq.s	+
		sfx	sfx_BreakBridge,0,0,0
+		rts
; ---------------------------------------------------------------------------
; Падающий шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_FallingBall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	FallingBall_Index(pc,d0.w),d0
		jsr	FallingBall_Index(pc,d0.w)
		jmp	(Child_DrawTouch_Sprite_CircularExplosion).w
; ---------------------------------------------------------------------------

FallingBall_Index: offsetTable
		offsetTableEntry.w FallingBall_Init		; 0
		offsetTableEntry.w FallingBall_Setup		; 2
; ---------------------------------------------------------------------------

FallingBall_Init:
		lea	ObjDat3_ChasingBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		movea.w	parent3(a0),a1
		bset	#3,$38(a1)
		move.b	#setOpen,anim(a1)
		move.l	#FallingBall_Explosion,$34(a0)
		move.l	#AniRaw_ChasingBall,$30(a0)

FallingBall_Setup:
		jsr	(Animate_Raw).w
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

FallingBall_Explosion:
		movea.w	parent3(a0),a1
		andi.b	#-$D,$38(a1)
		move.b	#setClose,anim(a1)

FallingWaitBall_Explosion:
		sfx	sfx_BreakBridge,0,0,0
		move.l	#Go_Delete_Sprite,$34(a0)
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_DEZExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Вращающийся и преследующий шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_CircularChaseBall:
		bsr.w	CircularChaseBall_SetTrail
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	CircularChaseBall_Index(pc,d0.w),d0
		jsr	CircularChaseBall_Index(pc,d0.w)
		jmp	(Child_DrawTouch_Sprite_CircularExplosion).w
; ---------------------------------------------------------------------------

CircularChaseBall_Index: offsetTable
		offsetTableEntry.w CircularChaseBall_Init		; 0
		offsetTableEntry.w CircularChaseBall_Setup	; 2
		offsetTableEntry.w CircularChaseBall_Setup2	; 4
		offsetTableEntry.w CircularChaseBall_Setup3	; 6
; ---------------------------------------------------------------------------

CircularChaseBall_Init:
		lea	ObjDat3_ChasingBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#2,$3A(a0)
		move.b	#2,$40(a0)
		move.w	#$1F,$2E(a0)
		ori.w	#$6000,art_tile(a0)
		tst.b	subtype(a0)
		beq.s	+
		subi.w	#$2000,art_tile(a0)
		move.w	#$5F,$2E(a0)
+		move.l	#CircularChaseBall_MoveDown,$34(a0)
		move.l	#AniRaw_ChasingBall,$30(a0)
		lea	ChildObjDat_ChasingBall_Trail2(pc),a2
		tst.b	subtype(a0)
		bne.s	+
		movea.w	parent3(a0),a1
		bset	#3,$38(a1)
		move.b	#setOpen,anim(a1)
		sfx	sfx_Laser2,0,0,0
		lea	ChildObjDat_ChasingBall_Trail(pc),a2
+		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

CircularChaseBall_Setup3:
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.w	#$400,d0
		moveq	#$20,d1
		jsr	(Chase_Object).w
		bra.s	CircularChaseBall_Setup
; ---------------------------------------------------------------------------

CircularChaseBall_Setup2:
		move.b	$40(a0),d0
		add.b	d0,$3C(a0)
		move.b	$3A(a0),d2
		jsr	(MoveSprite_CircularSimple).w

CircularChaseBall_Setup:
		jsr	(Animate_Raw).w
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

CircularChaseBall_MoveDown:
		move.w	#$100,y_vel(a0)
		move.l	#CircularChaseBall_MoveClosed,$34(a0)
		moveq	#$3F,d0
		tst.b	subtype(a0)
		beq.s	+
		moveq	#$3E,d0
+		move.w	d0,$2E(a0)
		rts
; ---------------------------------------------------------------------------

CircularChaseBall_MoveClosed:
		move.b	#_Setup2,routine(a0)
		clr.w	y_vel(a0)
		move.w	#$100,priority(a0)
		ori.w	#$E000,art_tile(a0)
		move.w	#$F,$2E(a0)
		move.l	#CircularChaseBall_SetClosed,$34(a0)
		tst.b	subtype(a0)
		beq.s	+
		subi.w	#$2000,art_tile(a0)
+		rts
; ---------------------------------------------------------------------------

CircularChaseBall_SetClosed:
		move.w	#$9F,$2E(a0)
		move.l	#CircularChaseBall_SetChase,$34(a0)
		tst.b	subtype(a0)
		beq.s	+
		movea.w	parent3(a0),a1
		andi.b	#-$D,$38(a1)
		move.b	#setClose,anim(a1)
		move.w	#$17F,$2E(a0)
		move.w	#$4F,$2E(a1)
		move.l	#BossRobot_MoveCircularChaseBall_SetMove,$34(a1)
+		rts
; ---------------------------------------------------------------------------

CircularChaseBall_SetChase:
		move.b	#_Setup3,routine(a0)
		move.w	#4*60,$2E(a0)
		move.l	#CircularChaseBall_Remove,$34(a0)
		sfx	sfx_Flash,1,0,0
; ---------------------------------------------------------------------------

CircularChaseBall_Remove:
		tst.b	subtype(a0)
		beq.s	+
		movea.w	parent3(a0),a1
		move.w	#$4F,$2E(a1)
		move.l	#BossRobot_CheckSubroutine,$34(a1)
+		bset	#7,status(a0)
		move.l	#Go_Delete_Sprite,address(a0)
		lea	ChildObjDat_DEZCircularExplosion(pc),a2
		jmp	(CreateChild6_Simple).w

; =============== S U B R O U T I N E =======================================

CircularChaseBall_SetTrail:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lea	CircularChaseBall_TrailIndex(pc),a1
		adda.w	(a1,d0.w),a1
		jmp	(a1)
; ---------------------------------------------------------------------------

CircularChaseBall_TrailIndex: offsetTable
		offsetTableEntry.w Obj_ChasingBall_SendPos		; 0
		offsetTableEntry.w Obj_ChasingBall_SendPos2	; 2
; ---------------------------------------------------------------------------
; Отталкивающийся шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_RepulsionBall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	RepulsionBall_Index(pc,d0.w),d0
		jsr	RepulsionBall_Index(pc,d0.w)
		bsr.w	Obj_ChasingBall_SendPos
		jmp	(Child_DrawTouch_Sprite_Explosion).w
; ---------------------------------------------------------------------------

RepulsionBall_Index: offsetTable
		offsetTableEntry.w RepulsionBall_Init		; 0
		offsetTableEntry.w RepulsionBall_Setup		; 2
		offsetTableEntry.w RepulsionBall_Setup2		; 4
; ---------------------------------------------------------------------------

RepulsionBall_Init:
		lea	ObjDat3_ShootingBall_Missile(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$400,y_vel(a0)
		move.l	#RepulsionBall_CheckTouch,$34(a0)
		movea.w	parent3(a0),a1
		bset	#3,$38(a1)
		move.b	#setOpen,anim(a1)
		sfx	sfx_Laser,0,0,0
		lea	ChildObjDat_RepulsionBall_Trail(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

RepulsionBall_Setup:
		jsr	(MoveSprite2).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

RepulsionBall_Setup2:
		bsr.s	RepulsionBall_CheckWall
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

RepulsionBall_CheckWall:
		move.w	(Camera_Y_pos).w,d0
		tst.w	y_vel(a0)
		bmi.s	+
		addi.w	#$C8,d0			; Проверить пол
		cmp.w	y_pos(a0),d0
		blo.s		++
		bra.s	+++
+		addi.w	#$18,d0			; Проверить потолок
		cmp.w	y_pos(a0),d0
		blo.s		++
+		neg.w	y_vel(a0)
		sfx	sfx_Laser5,0,0,0
+		move.w	(Camera_X_pos).w,d0
		tst.w	x_vel(a0)
		bpl.s	+
		addq.w	#8,d0			; Проверить левую сторону стены
		cmp.w	x_pos(a0),d0
		bhs.s	++
		rts
+		addi.w	#$138,d0		; Проверить правую сторону стены
		cmp.w	x_pos(a0),d0
		bhs.s	++
+		neg.w	x_vel(a0)
		sfx	sfx_Laser5,0,0,0
+		rts
; ---------------------------------------------------------------------------

RepulsionBall_CheckTouch:
		move.b	#_Setup2,routine(a0)
		move.l	#RepulsionBall_Remove,$34(a0)
		jsr	(Random_Number).w
		andi.w	#$C,d0
		move.l	ObDat_RepulsionBallSpeed(pc,d0.w),x_vel(a0)
		lsr.w	d0
		move.w	ObDat_RepulsionBallTimer(pc,d0.w),$2E(a0)
		jsr	(Find_SonicTails).w
		neg.w	x_vel(a0)
		tst.w	d0
		bne.s	+
		neg.w	x_vel(a0)
+		rts
; ---------------------------------------------------------------------------

ObDat_RepulsionBallTimer:
		dc.w 5*60
		dc.w 7*60
		dc.w 6*60
		dc.w 5*60
ObDat_RepulsionBallSpeed:
		dc.w $300, $300	; Xpos, Ypos
		dc.w $100, $500	; Xpos, Ypos
		dc.w $400, $100	; Xpos, Ypos
		dc.w $300, $300	; Xpos, Ypos
; ---------------------------------------------------------------------------

RepulsionBall_Remove:
		movea.w	parent3(a0),a1
		move.w	#$27,$2E(a1)
		bset	#7,status(a0)
		move.l	#Go_Delete_Sprite,address(a0)
		move.l	#BossRobot_MoveRepulsionBall_SetReturnPosition,$34(a1)
		rts
; ---------------------------------------------------------------------------
; Стреляющий по радиусу шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShootingBall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	ShootingBall_Index(pc,d0.w),d0
		jsr	ShootingBall_Index(pc,d0.w)
		jmp	(Child_DrawTouch_Sprite_CircularExplosion).w
; ---------------------------------------------------------------------------

ShootingBall_Index: offsetTable
		offsetTableEntry.w ShootingBall_Init		; 0
		offsetTableEntry.w ShootingBall_Setup	; 2
		offsetTableEntry.w ShootingBall_Setup2	; 4
		offsetTableEntry.w ShootingBall_Setup3	; 6
; ---------------------------------------------------------------------------

ShootingBall_Init:
		lea	ObjDat3_ChasingBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		movea.w	parent3(a0),a1
		bset	#3,$38(a1)
		move.b	#setOpen,anim(a1)
		move.b	#24/2,y_radius(a0)
		move.l	#ShootingBall_SetBounced,$34(a0)
		move.l	#AniRaw_ChasingBall,$30(a0)
		sfx	sfx_Laser,0,0,0
		jsr	(Find_SonicTails).w
		moveq	#1,d1
		tst.w	d0
		beq.s	+
		neg.b	d1
+		move.b	d1,$40(a0)

ShootingBall_Return:
		rts
; ---------------------------------------------------------------------------

ShootingBall_Setup:
		jsr	(Animate_Raw).w
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

ShootingBall_Setup3:
		bsr.w	ShootingBall_Shoot

ShootingBall_Setup2:
		jsr	(Animate_Raw).w
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

ShootingBall_SetBounced:
		movea.w	parent3(a0),a1
		andi.b	#-$D,$38(a1)
		move.b	#setClose,anim(a1)
		move.l	#ShootingBall_CheckBounced,$34(a0)
		move.w	#$100,x_vel(a0)
		cmpi.w	#$180,$3A(a1)
		bne.s	ShootingBall_CheckBounced
		neg.w	x_vel(a0)

ShootingBall_CheckBounced:
		move.w	y_vel(a0),d0
		bmi.s	ShootingBall_Return
		cmpi.w	#$180,d0
		bhs.s	ShootingBall_Fall
		move.b	#_Setup2,routine(a0)
		move.l	#ShootingBall_CheckPosition,$34(a0)
		sfx	sfx_Squeak,0,0,0
		lea	ChildObjDat_DEZGravitySwitch(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

ShootingBall_Fall:
		asr.w	d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		sfx	sfx_Emerald,1,0,0
; ---------------------------------------------------------------------------

ShootingBall_CheckPosition:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		sub.w	x_pos(a0),d0
		asl.w	#4,d0
		move.w	d0,x_vel(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$70,d0
		sub.w	y_pos(a0),d0
		bne.s	+
		lea	ChildObjDat_ShootingBall_Wave(pc),a2
		jsr	(CreateChild6_Simple).w
		move.w	#$1F,$2E(a0)
		move.l	#ShootingBall_CheckPositionWait,$34(a0)
+		asl.w	#4,d0
		move.w	d0,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

ShootingBall_CheckPositionWait:
		move.b	#_Setup3,routine(a0)
		sfx	sfx_Flash,0,0,0
		move.b	#4,(Hyper_Sonic_flash_timer).w
		move.w	#5*60,$2E(a0)
		move.l	#ShootingBall_Remove,$34(a0)
		rts
; ---------------------------------------------------------------------------

ShootingBall_Remove:
		movea.w	parent3(a0),a1
		move.w	#$2F,$2E(a1)
		sfx	sfx_BreakBridge,0,0,0
		move.l	#BossRobot_MoveShootingBall_SetReturnPosition,$34(a1)
		move.l	#Obj_DEZCircularExplosion,address(a0)

ShootingBall_Remove_Return:
		rts
; ---------------------------------------------------------------------------

ShootingBall_Shoot:
		move.b	$40(a0),d0
		add.b	d0,$3C(a0)
		moveq	#signextendB(sfx_Fire),d0
		moveq	#7,d2
		jsr	(Wait_Play_Sound).w
		btst	#0,(Level_frame_counter+1).w
		beq.s	ShootingBall_Remove_Return
		lea	ChildObjDat_ShootingBall_Missile(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Волна перед началом стрельбы шаров по радиусу
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShootingBall_Wave:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	ShootingBall_Wave_Index(pc,d0.w),d0
		jsr	ShootingBall_Wave_Index(pc,d0.w)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

ShootingBall_Wave_Index: offsetTable
		offsetTableEntry.w ShootingBall_Wave_Init		; 0
		offsetTableEntry.w ShootingBall_Wave_Setup		; 2
		offsetTableEntry.w ShootingBall_Wave_Setup2	; 4
		offsetTableEntry.w ShootingBall_Wave_Setup3	; 6
; ---------------------------------------------------------------------------

ShootingBall_Wave_Init:
		lea	ObjDat3_ShootingBall_Wave(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$400,y_vel(a0)
		tst.b	subtype(a0)
		beq.s	+
		bset	#1,render_flags(a0)
		move.b	#_Setup2,routine(a0)
+		move.l	#ShootingBall_Wave_Falling,$34(a0)

ShootingBall_Wave_Setup:
		jsr	(MoveSprite2).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

ShootingBall_Wave_Setup2:
		jsr	(MoveSprite2_ReverseGravity).w
		jmp	(ObjHitCeiling_DoRoutine).w
; ---------------------------------------------------------------------------

ShootingBall_Wave_Setup3:
		jmp	(Animate_Raw).w
; ---------------------------------------------------------------------------

ShootingBall_Wave_Falling:
		move.b	#_Setup3,routine(a0)
		move.w	#$80,priority(a0)
		move.l	#Go_Delete_Sprite,$34(a0)
		move.l	#AniRaw_ShootingBall_Wave,$30(a0)
		rts
; ---------------------------------------------------------------------------
; Снаряд для выстрела по радиусу
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShootingBall_Missile:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.b	#6,d0
		move.b	d0,$3F(a0)
		lea	ObjDat3_ShootingBall_Missile(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#+,address(a0)
		movea.w	parent3(a0),a1
		move.b	$3C(a1),d0
		add.b	$3F(a0),d0
		jsr	(GetSineCosine).w
		move.w	#$C00,d2
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,x_vel(a0)
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,y_vel(a0)
+		jsr	(MoveSprite2).w
		bsr.s	ShootingBall_Missile_CheckFloor
		jmp	(Sprite_ChildCheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

ShootingBall_Missile_CheckFloor:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#16,d0
		cmp.w	y_pos(a0),d0
		bhs.s	+
		addi.w	#192,d0
		cmp.w	y_pos(a0),d0
		bhs.s	ShootingBall_Missile_Return
+		move.w	#4,(Screen_shaking_flag).w
		btst	#1,(Level_frame_counter+1).w
		beq.s	ShootingBall_Missile_Return
		move.l	#loc_1E746,address(a0)

ShootingBall_Missile_Return:
		rts
; ---------------------------------------------------------------------------
; Падающий ждущий шар (кат-сцена)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_FallingWaitBall_Intro:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w		#2,d0
		addq.w	#8,d0
		move.w	d0,$2E(a0)
		lea	ObjDat3_ChasingBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		ori.w	#$C000,art_tile(a0)
		move.w	#$800,y_vel(a0)
		move.l	#FallingWaitBall_Intro_Animate,address(a0)
		move.l	#FallingWaitBall_Intro_Sound,$34(a0)
		move.l	#AniRaw_ChasingBall,$30(a0)

FallingWaitBall_Intro_Animate:
		jsr	(Animate_Raw).w
		jsr	(Obj_Wait).w
		jmp	(Sprite_ChildCheckDeleteXY_NoDraw).w
; ---------------------------------------------------------------------------

FallingWaitBall_Intro_Sound:
		sfx	sfx_Ghost,0,0,0
		move.l	#FallingWaitBall_Intro_Draw,address(a0)

FallingWaitBall_Intro_Draw:
		jsr	(Animate_Raw).w
		jsr	(MoveSprite2).w
		jmp	(Sprite_ChildCheckDeleteTouchXY).w
; ---------------------------------------------------------------------------
; Падающий ждущий шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_FallingWaitBall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	FallingWaitBall_Index(pc,d0.w),d0
		jsr	FallingWaitBall_Index(pc,d0.w)
		jmp	(Child_DrawTouch_Sprite_CircularExplosion).w
; ---------------------------------------------------------------------------

FallingWaitBall_Index: offsetTable
		offsetTableEntry.w FallingWaitBall_Init		; 0
		offsetTableEntry.w FallingWaitBall_Setup		; 2
		offsetTableEntry.w FallingWaitBall_Setup2	; 4
		offsetTableEntry.w FallingWaitBall_Setup3	; 6
; ---------------------------------------------------------------------------

FallingWaitBall_Init:
		lea	ObjDat3_ChasingBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		ori.w	#$C000,art_tile(a0)
		move.l	#FallingWaitBall_Waiting,$34(a0)
		move.l	#AniRaw_ChasingBall,$30(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w		#2,d0
		addi.w	#$80,d0
		move.w	d0,$2E(a0)
		cmpi.b	#(9-1)*2,subtype(a0)
		bne.s	+
		lea	ChildObjDat_FallingWaitBall_Aim(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.w	#$80,$2E(a1)
		move.w	$3E(a0),$3E(a1)
+		rts
; ---------------------------------------------------------------------------

FallingWaitBall_Setup:
		jsr	(Animate_Raw).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

FallingWaitBall_Setup2:
		jsr	(Animate_Raw).w
		jsr	(MoveSprite).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

FallingWaitBall_Setup3:
		jsr	(Animate_Raw).w
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

FallingWaitBall_Waiting:
		move.b	#_Setup2,routine(a0)
		move.w	#$1F,$2E(a0)
		move.l	#FallingWaitBall_Waiting2,$34(a0)
		tst.b		subtype(a0)
		bne.s	+
		sfx	sfx_Falling,0,0,0
+		rts
; ---------------------------------------------------------------------------

FallingWaitBall_Waiting2:
		move.b	#_Setup3,routine(a0)
		eori.w	#$4000,art_tile(a0)
		move.l	#FallingWaitBall_Explosion,$34(a0)
		rts
; ---------------------------------------------------------------------------
; Прицел для вращающегося и преследующего шара
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_FallingWaitBall_Aim:
		move.w	(Camera_X_pos).w,d0
		add.w	$3E(a0),d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		add.w	#$C8,d0
		move.w	d0,y_pos(a0)
		sfx	sfx_Squeak,0,0,0
		lea	ObjDat3_FallingWaitBall_Aim(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#+,address(a0)
		move.l	#Go_Delete_Sprite,$34(a0)
		move.l	#AniRaw_FallingWaitBall_Aim,$30(a0)
+		jsr	(Animate_Raw).w
		jsr	(Obj_Wait).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------
; Раскачивающийся шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SwingBall:
		bsr.w	CircularChaseBall_SetTrail
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	SwingBall_Index(pc,d0.w),d0
		jmp	SwingBall_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SwingBall_Index: offsetTable
		offsetTableEntry.w SwingBall_Init		; 0
		offsetTableEntry.w SwingBall_Setup		; 2
		offsetTableEntry.w SwingBall_Setup2	; 4
; ---------------------------------------------------------------------------

SwingBall_Init:
		lea	ObjDat3_ChasingBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		ori.w	#$E000,art_tile(a0)
		move.w	#$F,$2E(a0)
		move.l	#SwingBall_MoveDown,$34(a0)
		move.l	#AniRaw_ChasingBall,$30(a0)
		move.b	#6,$40(a0)
		lea	ChildObjDat_ChasingBall_Trail2(pc),a2
		tst.b	subtype(a0)
		bne.s	+
		neg.b	$40(a0)
		subi.w	#$6000,art_tile(a0)
		movea.w	parent3(a0),a1
		bset	#3,$38(a1)
		move.b	#setOpen,anim(a1)
		sfx	sfx_Laser2,0,0,0
		lea	ChildObjDat_ChasingBall_Trail(pc),a2
+		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

SwingBall_Setup2:
		pea	(Sprite_ChildCheckDeleteTouchXY).w
		move.b	$40(a0),d0
		add.b	d0,$3C(a0)
		move.b	$3C(a0),d0
		jsr	(GetSineCosine).w
		asl.w	#2,d0
		move.w	d0,x_vel(a0)
		bra.s	SwingBall_Setup_2
; ---------------------------------------------------------------------------

SwingBall_Setup:
		pea	(Sprite_ChildCheckDeleteXY_NoDraw).w

SwingBall_Setup_2:
		jsr	(Animate_Raw).w
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

SwingBall_MoveDown:
		move.b	#_Setup2,routine(a0)
		move.w	#$300,y_vel(a0)
		move.w	#$F,$2E(a0)
		move.l	#SwingBall_SetClose,$34(a0)
		rts
; ---------------------------------------------------------------------------

SwingBall_SetClose:
		tst.b	subtype(a0)
		bne.s	SwingBall_Return
		tst.b	render_flags(a0)
		bmi.s	SwingBall_Return
		movea.w	parent3(a0),a1
		andi.b	#-$D,$38(a1)
		move.b	#setClose,anim(a1)
		move.l	#SwingBall_Return,$34(a0)

SwingBall_Return:
		rts
; ---------------------------------------------------------------------------
; Умножающийся шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_MultiplyingBall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	MultiplyingBall_Index(pc,d0.w),d0
		jsr	MultiplyingBall_Index(pc,d0.w)
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

MultiplyingBall_Index: offsetTable
		offsetTableEntry.w MultiplyingBall_Init		; 0
		offsetTableEntry.w MultiplyingBall_Setup		; 2
		offsetTableEntry.w MultiplyingBall_Setup2	; 4
; ---------------------------------------------------------------------------

MultiplyingBall_Init:
		lea	ObjDat3_ChasingBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		sfx	sfx_Laser,0,0,0
		movea.w	parent3(a0),a1
		bset	#3,$38(a1)
		move.b	#setOpen,anim(a1)
		move.b	#24/2,y_radius(a0)
		move.l	#MultiplyingBall_MoveDown,$34(a0)
		move.l	#AniRaw_ChasingBall,$30(a0)

MultiplyingBall_Setup:
		jsr	(Animate_Raw).w
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

MultiplyingBall_Setup2:
		jsr	(Animate_Raw).w

MultiplyingBall_Setup3:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

MultiplyingBall_MoveDown:
		movea.w	parent3(a0),a1
		andi.b	#-$D,$38(a1)
		move.b	#setClose,anim(a1)
		move.b	#_Setup2,routine(a0)
		move.w	#-$200,y_vel(a0)
		move.l	#MultiplyingBall_Setup3,address(a0)
		move.l	#MultiplyingBall_Create,$34(a0)
		rts
; ---------------------------------------------------------------------------

MultiplyingBall_Create:
		clr.w	y_vel(a0)
		movea.w	parent3(a0),a1
		move.w	#$27,$2E(a0)
		move.w	#$3F,$2E(a1)
		move.l	#Obj_Wait,address(a0)
		move.l	#Go_Delete_Sprite_2,$34(a0)
		move.l	#BossRobot_CheckSubroutine,$34(a1)
		lea	ChildObjDat_MultiplyingBall_Extra_Left(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_MultiplyingBall_Extra_Right(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Дополнительный умножающийся шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_MultiplyingBall_Extra_Left:
		st	$40(a0)

Obj_MultiplyingBall_Extra_Right:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#2,d0
		addq.w	#4,d0
		move.w	d0,$2E(a0)
		move.w	#$400,x_vel(a0)
		tst.b	$40(a0)
		beq.s	+
		neg.w	x_vel(a0)
+		lea	ObjDat3_MultiplyingBall(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#+,address(a0)
		move.l	#MultiplyingBall_Extra_Stop,$34(a0)
		move.l	#AniRaw_ChasingBall,$30(a0)
+		jsr	(Animate_Raw).w
		jsr	(MoveSprite2).w
		jsr	(Obj_Wait).w
		tst.b	$41(a0)
		bne.s	+
		btst	#0,(Level_frame_counter+1).w
		beq.s	MultiplyingBall_Extra_AddToTouchList
+		jmp	(Child_DrawTouch_Sprite_Explosion).w
; ---------------------------------------------------------------------------

MultiplyingBall_Extra_AddToTouchList:
		jmp	(Child_AddToTouchList).w
; ---------------------------------------------------------------------------

MultiplyingBall_Extra_Stop:
		clr.w	x_vel(a0)
		st	$41(a0)
		move.b	#$82,collision_flags(a0)
		move.l	#MultiplyingBall_Extra_Check,$34(a0)
		tst.b	$40(a0)
		beq.s	MultiplyingBall_Extra_Check
		sfx	sfx_Laser5,0,0,0

MultiplyingBall_Extra_Check:
		movea.w	parent3(a0),a1
		btst	#4,$38(a1)
		beq.s	MultiplyingBall_Extra_Return
		tst.b	$40(a0)
		beq.s	MultiplyingBall_Extra_Remove
		cmpi.b	#(5-1)*2,subtype(a0)
		bne.s	MultiplyingBall_Extra_Remove
		sfx	sfx_Flash,0,0,0
		move.b	#4,(Hyper_Sonic_flash_timer).w

MultiplyingBall_Extra_Remove:
		move.l	#Go_Delete_Sprite,$34(a0)

MultiplyingBall_Extra_Return:
		rts
; ---------------------------------------------------------------------------
; Щит
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossRobot_Shield:
		lea	ObjDat3_BossRobot_Shield(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		ori.w	#$8000,art_tile(a0)
		move.b	#2,collision_property(a0)
		move.l	#BossRobot_Shield_Shot,address(a0)
		lea	(Player_1).w,a2
		movea.w	parent3(a0),a1
		jsr	(CalcObjAngle).w
		move.b	d0,$3C(a0)
		st	$40(a0)
		tst.b	render_flags(a1)
		spl	$41(a0)
		bsr.w	BossRobot_Shield_ChgFrame
		jsr	(MoveSprite_CircularSimpleRadius).w

BossRobot_Shield_Shot:
		movea.w	parent3(a0),a1
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		asl.w	#5,d0
		move.w	d0,x_vel(a0)
		move.w	y_pos(a1),d0
		sub.w	y_pos(a0),d0
		asl.w	#5,d0
		move.w	d0,y_vel(a0)
		jsr	(Find_OtherObject).w
		cmpi.w	#64,d2
		bhs.s	+
		cmpi.w	#64,d3
		bhs.s	+
		sfx	sfx_Attachment2,0,0,0
		move.l	#BossRobot_Shield_Angle,address(a0)
+		jsr	(MoveSprite2).w
		tst.b	$41(a0)
		bne.w	BossRobot_Shield_Return
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

BossRobot_Shield_Angle:
		lea	(Player_1).w,a2
		movea.w	parent3(a0),a1
		jsr	(CalcObjAngle).w
		movea.w	parent3(a0),a1
		btst	#3,$38(a1)
		beq.s	+
		move.b	d0,d1
		smi	d2
		addi.b	#$30,d1
		cmpi.b	#$60,d1
		bhs.s	+
		moveq	#$30,d0
		tst.b	d2
		beq.s	+
		moveq	#-$30,d0
+		move.b	d0,$3C(a0)
		lea	AngleLookup_BossRobot(pc),a2
		jsr	(MoveSprite_AtAngleLookup).w
		bsr.s	BossRobot_Shield_CheckBreak
		bsr.s	BossRobot_Shield_ChgFrame
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

BossRobot_Shield_ChgFrame:
		moveq	#0,d0
		move.b	$3C(a0),d0
		bclr	#7,d0
		sne	d2
		moveq	#4,d3			; current frame
		lea	byte_7FB0A(pc),a1
		btst	#6,d0
		beq.s	+
		moveq	#10,d3			; current frame
		addq.w	#8,a1
+
-		cmp.b	(a1)+,d0			; d0 - current angle
		blo.s		+
		addq.w	#1,d3
		bra.s	-
; ---------------------------------------------------------------------------
+		move.b	d3,mapping_frame(a0)
		move.b	render_flags(a0),d0
		andi.b	#-4,d0
		tst.b	d2
		beq.s	+
		ori.b	#3,d0
+		move.b	d0,render_flags(a0)
		rts
; ---------------------------------------------------------------------------

byte_7FB0A:		; frame angle
		dc.b 5, $10, $1B, $26, $31, $3C, $40, 0
		dc.b $45, $50, $5B, $66, $71, $7C, $80, 0		; +$40
; ---------------------------------------------------------------------------

BossRobot_Shield_CheckBreak:
		tst.b	collision_flags(a0)
		bne.s	BossRobot_Shield_Return
		tst.b	collision_property(a0)
		beq.s	BossRobot_Shield_CheckBreak_Remove
		tst.b	$1C(a0)
		bne.s	+
		move.b	#$20,$1C(a0)
		sfx	sfx_Bumper,0,0,0
		bset	#6,status(a0)
+		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	+
		addq.w	#3*2,d0
+		bsr.w	BossRobot_Shield_PalFlash
		subq.b	#1,$1C(a0)
		bne.s	BossRobot_Shield_Return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

BossRobot_Shield_Return:
		rts
; ---------------------------------------------------------------------------

BossRobot_Shield_CheckBreak_Remove:
		move.l	#BossRobot_Shield_CheckBreak_CheckRemove,address(a0)
		moveq	#0,d0
		bsr.w	BossRobot_Shield_PalFlash
		lea	Child6_CreateBossExplosion(pc),a2
		jsr	(CreateChild1_Normal).w
		bne.s	+
		move.b	#6,subtype(a1)
+		jsr	(Create_New_Sprite3).w
		bne.s	BossRobot_Shield_CheckBreak_CheckRemove
		move.w	parent3(a0),parent3(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.l	#Obj_BossRobot_Shield_FlickerMove,address(a1)
		move.b	subtype(a0),subtype(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	mapping_frame(a0),mapping_frame(a1)

BossRobot_Shield_CheckBreak_CheckRemove:
		lea	(Player_1).w,a1
		btst	#Status_InAir,status(a1)
		bne.s	BossRobot_Shield_CheckBreak_Return
		bset	#7,status(a0)
		move.l	#Go_Delete_Sprite,address(a0)
		movea.w	parent3(a0),a1
		bclr	#4,$38(a1)
		move.b	#$F,collision_flags(a1)

BossRobot_Shield_CheckBreak_Return:
		rts
; ---------------------------------------------------------------------------
; Частицы щита
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossRobot_Shield_FlickerMove:
		moveq	#1<<2,d0
		jmp	(loc_849D8).w
; ---------------------------------------------------------------------------
; Взрывы
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_DEZExplosion:
		moveq	#1,d2
		moveq	#8-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	++
		move.l	#Obj_DEZExplosion_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$8530,d3
		tst.b	(HUD_RAM.draw).w
		beq.s	+
		move.w	#$530,d3
+		move.w	d3,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	#$100,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	d2,d3
		asl.w	#8,d3
		neg.w	d3
		move.w	d3,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)
		addq.w	#1,d2
		dbf	d1,-
+		bra.s	DEZExplosion_Delete
; ---------------------------------------------------------------------------

Obj_DEZExplosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#7,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.s	DEZExplosion_Delete
+		jsr	(MoveSprite_TestGravity).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

DEZExplosion_Delete:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------
; Взрывы
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_DEZCircularExplosion:
		moveq	#0,d2
		moveq	#8-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	++
		move.l	#Obj_DEZCircularExplosion_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$8530,d3
		tst.b	(HUD_RAM.draw).w
		beq.s	+
		move.w	#$530,d3
+		move.w	d3,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	#$100,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	#3,anim_frame_timer(a1)
		move.b	#8,$3A(a1)
		move.b	d2,angle(a1)
		move.b	#8,$40(a1)
		addi.w	#256/8,d2
		dbf	d1,-
+		bra.s	DEZExplosion_Delete
; ---------------------------------------------------------------------------

Obj_DEZCircularExplosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#7,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		subq.b	#1,$3A(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.w	DEZExplosion_Delete
+		move.b	$40(a0),d0
		sub.b	d0,angle(a0)
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		moveq	#0,d2
		move.b	$3A(a0),d2
		asr.w	d2,d0
		add.w	d0,x_pos(a0)
		asr.w	d2,d1
		add.w	d1,y_pos(a0)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------
; Частицы босса
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossRobot_FlickerMove:
		lea	ObjDat3_BossRobot_Flicker(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#Obj_FlickerMove,address(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsr.b	#1,d0
		addi.b	#$11,d0
		move.b	d0,mapping_frame(a0)
		moveq	#2<<2,d0
		jsr	(Set_IndexedVelocity).w
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_ChasingBall_SendPos:
		move.w	(Pos_objtable_index).w,d0
		lea	(Pos_objTable).w,a1
		lea	(a1,d0.w),a1
		move.w	x_pos(a0),(a1)+
		move.w	y_pos(a0),(a1)+
		addq.b	#4,(Pos_objtable_byte).w
		rts
; ---------------------------------------------------------------------------

Obj_ChasingBall_SendPos2:
		move.w	(Pos_obj2table_index).w,d0
		lea	(Pos_obj2Table).w,a1
		lea	(a1,d0.w),a1
		move.w	x_pos(a0),(a1)+
		move.w	y_pos(a0),(a1)+
		addq.b	#4,(Pos_obj2table_byte).w
		rts
; ---------------------------------------------------------------------------

Obj_ChasingBall_CopyPos:
		move.w	(Pos_objtable_index).w,d0
		lea	(Pos_objtable).w,a1
		bra.s	Obj_ChasingBall_CopyPosSet
; ---------------------------------------------------------------------------

Obj_ChasingBall_CopyPos2:
		move.w	(Pos_obj2table_index).w,d0
		lea	(Pos_obj2table).w,a1

Obj_ChasingBall_CopyPosSet:
		sub.b	$39(a0),d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,x_pos(a0)
		move.w	(a1)+,y_pos(a0)
		rts

; =============== S U B R O U T I N E =======================================

BossRobot_PalFlash:
		lea	LoadBossRobot_PalRAM(pc),a1
		lea	LoadBossRobot_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_6).w
; ---------------------------------------------------------------------------

LoadBossRobot_PalRAM:
		dc.w Normal_palette_line_4+6
		dc.w Normal_palette_line_4+8
		dc.w Normal_palette_line_4+$18
		dc.w Normal_palette_line_4+$1A
		dc.w Normal_palette_line_4+$1C
		dc.w Normal_palette_line_4+$1E
LoadBossRobot_PalCycle:
		dc.w $E, 8, $866, $644, $422, 0
		dc.w $888, $AAA, $888, $AAA, $CCC, $EEE

; =============== S U B R O U T I N E =======================================

BossRobot_Shield_PalFlash:
		lea	LoadBossRobot_Shield_PalRAM(pc),a1
		lea	LoadBossRobot_Shield_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_3).w
; ---------------------------------------------------------------------------

LoadBossRobot_Shield_PalRAM:
		dc.w Normal_palette_line_4+$10
		dc.w Normal_palette_line_4+$12
		dc.w Normal_palette_line_4+$14
LoadBossRobot_Shield_PalCycle:
		dc.w $EC0, $A80, $860
		dc.w $E0E, $A0A, $808

; =============== S U B R O U T I N E =======================================

ObjDat3_BossRobot:
		dc.l Map_BossRobot
		dc.w $61F0
		dc.w $200
		dc.b 80/2
		dc.b 80/2
		dc.b 0
		dc.b $F
ObjDat3_BossRobot_Shield:
		dc.w $180
		dc.b 48/2
		dc.b 48/2
		dc.b 4
		dc.b $17
ObjDat3_BossRobot_Flicker:
		dc.w 0
		dc.b 80/2
		dc.b 80/2
		dc.b $11
		dc.b 0
ObjDat3_ShootingBall_Wave:
		dc.l Map_BossBallWave
		dc.w $82E1
		dc.w $280
		dc.b 64/2
		dc.b 64/2
		dc.b 0
		dc.b 0
ObjDat3_ChasingBall:
		dc.l Map_BossBall
		dc.w $290
		dc.w $280
		dc.b 32/2
		dc.b 24/2
		dc.b 1
		dc.b $86
ObjDat3_ShootingBall_Missile:
		dc.l Map_BossBall
		dc.w $8290
		dc.w $280
		dc.b 16/2
		dc.b 16/2
		dc.b 0
		dc.b $8B
ObjDat3_ChasingBall_Trail:
		dc.w $280
		dc.b 16/2
		dc.b 16/2
		dc.b 0
		dc.b $8B
ObjDat3_FallingWaitBall_Aim:
		dc.l Map_BossAim
		dc.w $A2D4
		dc.w 0
		dc.b 44/2
		dc.b 44/2
		dc.b 0
		dc.b 0
ObjDat3_MultiplyingBall:
		dc.w $280
		dc.b 32/2
		dc.b 24/2
		dc.b 1
		dc.b 0
AniRaw_ChasingBall:
		dc.b 1, 1, 2, 1, 5, $FC
AniRaw_FallingWaitBall_Aim:
		dc.b 0, 0, 1, $FC
AniRaw_ShootingBall_Wave:
		dc.b	1, 0, 1, 2, 3, 4, $F4,0
ChildObjDat_ChasingBall_Trail:
		dc.w 4-1
		dc.l Obj_ChasingBall_Trail
ChildObjDat_ChasingBall_Trail2:
		dc.w 4-1
		dc.l Obj_ChasingBall_Trail_2
ChildObjDat_RepulsionBall_Trail:
		dc.w 12-1
		dc.l Obj_RepulsionBall_Trail
ChildObjDat_FallingBall:
		dc.w 1-1
		dc.l Obj_FallingBall
ChildObjDat_CircularBall:
		dc.w 2-1
		dc.l Obj_CircularChaseBall
ChildObjDat_ShootingBall:
		dc.w 1-1
		dc.l Obj_ShootingBall
ChildObjDat_ShootingBall_Wave:
		dc.w 2-1
		dc.l Obj_ShootingBall_Wave
ChildObjDat_ShootingBall_Missile:
		dc.w 2-1
		dc.l Obj_ShootingBall_Missile
ChildObjDat_RepulsionBall:
		dc.w 1-1
		dc.l Obj_RepulsionBall
ChildObjDat_BossRobot_CreateShield_Process:
		dc.w 1-1
		dc.l Obj_BossRobot_CreateShield_Process
ChildObjDat_BossRobot_Shield:
		dc.w 1-1
		dc.l Obj_BossRobot_Shield
ChildObjDat_FallingWaitBall_Aim:
		dc.w 1-1
		dc.l Obj_FallingWaitBall_Aim
ChildObjDat_FallingWaitBall_Intro:
		dc.w 27-1
		dc.l Obj_FallingWaitBall_Intro
ChildObjDat_MultiplyingBall:
		dc.w 1-1
		dc.l Obj_MultiplyingBall
ChildObjDat_MultiplyingBall_Extra_Left:
		dc.w 5-1
		dc.l Obj_MultiplyingBall_Extra_Left
ChildObjDat_MultiplyingBall_Extra_Right:
		dc.w 5-1
		dc.l Obj_MultiplyingBall_Extra_Right
ChildObjDat_SwingBall:
		dc.w 2-1
		dc.l Obj_SwingBall
		dc.b 22
		dc.b 0
		dc.l Obj_SwingBall
		dc.b -22
		dc.b 0
ChildObjDat_DEZExplosion:
		dc.w 1-1
		dc.l Obj_DEZExplosion
ChildObjDat_DEZCircularExplosion:
		dc.w 1-1
		dc.l Obj_DEZCircularExplosion
ChildObjDat_DEZGravitySwitch:
		dc.w 2-1
		dc.l Obj_DEZGravitySwitch
ChildObjDat_BossRobot_FlickerMove:
		dc.w 6-1
		dc.l Obj_BossRobot_FlickerMove
AngleLookup_BossRobot:
		dc.b 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, $C, $D, $D, $E, $F, $10, $11, $12
		dc.b $13, $14, $15, $15, $16, $17, $18, $19, $19, $1A, $1B, $1C, $1C, $1D, $1E, $1E, $1F, $20, $20, $21
		dc.b $21, $22, $22, $23, $23, $24, $24, $25, $25, $25, $26, $26, $26, $27, $27, $27, $27, $27, $28, $28
		dc.b $28, $28, $28, $28
PLC_BossRobot: plrlistheader
		plreq $2E1, ArtKosM_BossBallWave
PLC_BossRobot_End
; ---------------------------------------------------------------------------

		include "Objects/Boss/Object Data/Anim - Boss.asm"
		include "Objects/Boss/Object Data/Map - Boss.asm"
		include "Objects/Boss/Object Data/Map - Ball.asm"
		include "Objects/Boss/Object Data/Map - Ball Wave.asm"
		include "Objects/Boss/Object Data/Map - Aim.asm"
		include "Objects/Boss/Object Data/Map - Explosion.asm"