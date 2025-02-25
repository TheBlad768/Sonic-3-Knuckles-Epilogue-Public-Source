; ---------------------------------------------------------------------------
; Босс-шар 2
; ---------------------------------------------------------------------------

; Hits
BossFinalBall_Hits	= 8

; Attributes
;_Setup4				= 8
;_Setup5				= $A
;_Setup6				= $C
;_Setup7				= $E
;_Setup8				= $10
;_Setup9				= $12

; Dynamic object variables
obBFB_Rotate				= $30	; .b
obBFB_Hit					= $31	; .b
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
		bsr.w	BossFinalBall_CheckTouch
		move.b	(V_int_run_count+3).w,d0
		andi.b	#1,d0
		move.b	d0,mapping_frame(a0)
		tst.b	obBFB_Draw(a0)
		bne.w	BossFinalBall_MoveFourSpikeBall_Move_Return
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

BossFinalBall_Index: offsetTable
		offsetTableEntry.w BossFinalBall_Init	; 0
		offsetTableEntry.w BossFinalBall_Setup	; 2
		offsetTableEntry.w BossFinalBall_Setup2	; 4
		offsetTableEntry.w BossFinalBall_Setup3	; 6
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
		move.w	#$4F,$2E(a0)
		move.l	#BossFinalBall_Intro,obBFB_Jump(a0)
		lea	ChildObjDat_BossGreyBall_Face(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_Setup2:
		moveq	#signextendB(sfx_Rotate),d0
		moveq	#$1F,d2
		jsr	(Wait_Play_Sound).w
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
		subq.b	#1,$39(a0)
		sfx	sfx_SpikeBall2,0,0,0

BossFinalBall_Setup:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossFinalBall_Setup3:
		jsr	(MoveSprite_TestGravity).w
		lea	(ObjHitFloor_DoRoutine).w,a1
		tst.b	(Reverse_gravity_flag).w
		beq.s	+
		lea	(ObjHitCeiling_DoRoutine).w,a1
+		jmp	(a1)
; ---------------------------------------------------------------------------
; Интро
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinalBall_Intro:
		tst.b	(Intro_flag).w
		bne.s	BossFinalBall_Intro_MoveSwing
		addq.b	#1,(Intro_flag).w
		st	(NoPause_flag).w
		move.l	#BossFinalBall_MoveFourSpikeBall_Move_Return,obBGB_Jump(a0)
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#_FinalBallStart,routine(a1)
		move.l	#DialogFinalBallStart_Process_Index-4,$34(a1)
		move.b	#(DialogFinalBallStart_Process_Index_End-DialogFinalBallStart_Process_Index)/8,$39(a1)
+		rts
; ---------------------------------------------------------------------------

BossFinalBall_Intro_MoveSwing:
		sfx	sfx_Flash,0,0,0
		move.b	#4,(Hyper_Sonic_flash_timer).w
		move.l	#BossFinalBall_MoveFourSpikeBall_Move_Return,obBGB_Jump(a0)
		lea	ChildObjDat_BossFinalBall_IntroClone(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_Intro_MoveSwing_Load:
		move.w	#$4F,$2E(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall,obBGB_Jump(a0)
		move.b	#1,(Update_HUD_timer).w
		move.b	#1,(HUDBoss_RAM.status).w
		move.w	a0,(HUDBoss_RAM.parent).w
		clr.b	(Ctrl_1_locked).w
		clr.b	(Player_1+object_control).w
		lea	ChildObjDat_BossFinalBall_RotateSpikeBall(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Босс атакует с помощью 4 шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinalBall_MoveFourSpikeBall:
		move.b	#_Setup2,routine(a0)
		move.b	#3,$39(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_Move,obBFB_Jump(a0)
		jsr	(Find_SonicTails).w
		move.w	#$180,x_vel(a0)
		tst.w	d0
		beq.s	+
		neg.w	x_vel(a0)
+		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFourSpikeBall2:
		move.b	#_Setup2,routine(a0)
		move.b	#3,$39(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_Move,obBFB_Jump(a0)
		move.w	#$180,x_vel(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		cmp.w	x_pos(a0),d0
		bge.s	+
		neg.w	x_vel(a0)
+		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFourSpikeBall_Move:
		tst.b	$39(a0)
		bne.s	BossFinalBall_MoveFourSpikeBall_Move_Return
		move.b	#_Setup1,routine(a0)
		move.b	#8,$39(a0)
		move.w	#$2F,$2E(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_SetMoveDown,obBFB_Jump(a0)
		clr.w	x_vel(a0)

BossFinalBall_MoveFourSpikeBall_Move_Return:
		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFourSpikeBall_SetMoveDown:
		bset	#1,$38(a0)
		bset	#2,$38(a0)
		move.w	#$4F,$2E(a0)
		subq.b	#1,$39(a0)
		bne.s	BossFinalBall_MoveFourSpikeBall_MoveDown_Return
		move.l	#BossFinalBall_MoveFourSpikeBall_SetMoveDown2,obBFB_Jump(a0)

BossFinalBall_MoveFourSpikeBall_MoveDown_Return:
		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFourSpikeBall_SetMoveDown2:
		bset	#1,$38(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_SetMoveDown2_Return,obBFB_Jump(a0)

BossFinalBall_MoveFourSpikeBall_SetMoveDown2_Return:
		rts
; ---------------------------------------------------------------------------
; Босс меняет гравитацию (вторая фаза)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinalBall_MoveReverseGravity:
		move.b	#_Setup3,routine(a0)
		move.l	#BossFinalBall_MoveReverseGravity_Floor,obBFB_Jump(a0)
		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveReverseGravity_Floor:
		move.b	#_Setup1,routine(a0)
		move.w	#$4F,$2E(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall2,obBFB_Jump(a0)
		clr.w	y_vel(a0)
		eori.b	#1,(Reverse_gravity_flag).w

BossFinalBall_MoveReverseGravity_Return:
		rts
; ---------------------------------------------------------------------------
; Босс выпускает шары (третья фаза)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinalBall_MoveFallSpikeBall:
		move.b	#_Setup3,routine(a0)
		move.l	#BossFinalBall_MoveFallSpikeBall_Floor,obBFB_Jump(a0)
		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFallSpikeBall_Floor:
		move.b	#_Setup2,routine(a0)
		move.b	#3,$39(a0)
		clr.b	(Reverse_gravity_flag).w
		move.l	#BossFinalBall_MoveFallSpikeBall_Move,obBFB_Jump(a0)
		move.w	#$200,x_vel(a0)
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFallSpikeBall_Move:
		tst.b	$39(a0)
		bne.s	BossFinalBall_MoveFallSpikeBall_Move_Return

BossFinalBall_MoveFallSpikeBall_Move2:
		move.b	#_Setup1,routine(a0)
		move.b	#4,$39(a0)
		move.w	#$4F,$2E(a0)
		move.l	#BossFinalBall_MoveFallSpikeBall_Move_SetMoveDown,obBFB_Jump(a0)
		clr.w	x_vel(a0)

BossFinalBall_MoveFallSpikeBall_Move_Return:
		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFallSpikeBall_Move_SetMoveDown:
		bset	#1,$38(a0)
		bset	#2,$38(a0)
		bset	#3,$38(a0)
		move.w	#$7F,$2E(a0)
		subq.b	#1,$39(a0)
		bne.s	BossFinalBall_MoveFallSpikeBall_Move_MoveDown_Return
		move.l	#BossFinalBall_MoveFallSpikeBall_Move_MoveDown_SetMoveDown2,obBFB_Jump(a0)

BossFinalBall_MoveFallSpikeBall_Move_MoveDown_Return:
		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFallSpikeBall_Move_MoveDown_SetMoveDown2:
		bset	#1,$38(a0)
		bset	#3,$38(a0)
		bset	#5,$38(a0)
		move.l	#BossFinalBall_MoveFallSpikeBall_Move_MoveDown_SetMoveDown2_Return,obBFB_Jump(a0)

BossFinalBall_MoveFallSpikeBall_Move_MoveDown_SetMoveDown2_Return:
		rts
; ---------------------------------------------------------------------------
; Проверка урона
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinalBall_CheckTouch:
		tst.b	collision_flags(a0)
		bne.w	BossFinalBall_CheckTouch_Return
		tst.b	obBFB_Hit(a0)
		beq.w	BossFinalBall_CheckTouch_Bounce
		move.b	collision_property(a0),d4
		beq.w	BossFinalBall_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.s	BossFinalBall_CheckTouch_Flash

BossFinalBall_CheckTouch_HitBoss:
		sfx	sfx_HitBoss,0,0,0
		move.b	#$60,$1C(a0)
		move.w	#$4F,(Screen_shaking_flag).w
		move.b	#$4F,(Negative_flash_timer).w
		bset	#6,status(a0)
		bset	#5,$38(a0)
		lea	ChildObjDat_BossFinalBall_DEZFallingExplosion(pc),a2
		jsr	(CreateChild6_Simple).w

BossFinalBall_CheckTouch_SecondPhase:
		cmpi.b	#BossFinalBall_Hits-2,d4
		bne.s	BossFinalBall_CheckTouch_ThirdPhase
		move.w	#-1,$2E(a0)
		move.l	#BossFinalBall_MoveReverseGravity,obBFB_Jump(a0)

BossFinalBall_CheckTouch_ThirdPhase:
		cmpi.b	#BossFinalBall_Hits/3,d4
		bne.s	BossFinalBall_CheckTouch_Flash
		move.w	#-1,$2E(a0)
		move.l	#BossFinalBall_MoveFallSpikeBall,obBFB_Jump(a0)

BossFinalBall_CheckTouch_Flash:
		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	+
		addi.w	#7*2,d0
+		bsr.w	BossFinalBall_PalFlash
		subq.b	#1,$1C(a0)
		bne.s	BossFinalBall_CheckTouch_Return
		bclr	#6,status(a0)
		bclr	#5,$38(a0)
		clr.b	obBFB_Hit(a0)

BossFinalBall_CheckTouch_Restore:
		move.b	collision_restore_flags(a0),collision_flags(a0)

BossFinalBall_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

BossFinalBall_CheckTouch_Bounce:
		tst.b	collision_property(a0)
		bne.s	+
		bclr	#7,status(a0)
+		addq.b	#1,collision_property(a0)
		sfx	sfx_Bumper2,0,0,0
		lea	(Player_1).w,a1
		move.w	x_pos(a1),d1
		move.w	y_pos(a1),d2
		sub.w	x_pos(a0),d1
		sub.w	y_pos(a0),d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		move.w	#$400,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a1)
		move.w	d1,ground_vel(a1)
		muls.w	d2,d0
		asr.l	#8,d0
		tst.b	(Reverse_gravity_flag).w
		beq.s	+
		neg.w	d0
+		move.w	d0,y_vel(a1)
		bra.s	BossFinalBall_CheckTouch_Restore
; ---------------------------------------------------------------------------

BossFinalBall_CheckTouch_WaitExplosive:
		move.l	#BossFinalBall_CheckTouch_WaitExplosive_Restore,address(a0)
		bset	#7,status(a0)
		clr.l	x_vel(a0)
		move.w	#-1,$2E(a0)
		move.b	#$4F,(Negative_flash_timer).w
		clr.b	(Update_HUD_timer).w	; Stop
		jmp	(BossDefeated_NoTime).w
; ---------------------------------------------------------------------------

BossFinalBall_CheckTouch_WaitExplosive_Restore:
		move.l	#BossFinalBall_CheckTouch_SetPlayerPos,address(a0)
		bclr	#7,status(a0)
		move.w	#$1F,$2E(a0)
		st	(Ctrl_1_locked).w
		lea	ChildObjDat_BossGreyBall_Face(pc),a2
		jsr	(CreateChild6_Simple).w
		st	(NoPause_flag).w
		bset	#5,$38(a0)
		lea	ChildObjDat_BossFinalBall_DEZFallingExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		bra.s	BossFinalBall_CheckTouch_TimeExplosive_Draw
; ---------------------------------------------------------------------------

BossFinalBall_CheckTouch_SetPlayerPos:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		move.w	#btnL<<8,d1
		addi.w	#$60,d0
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s		+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		bra.s	BossFinalBall_CheckTouch_TimeExplosive_Draw
; ---------------------------------------------------------------------------
+		btst	#Status_InAir,status(a1)
		bne.s	-
		clr.w	(Ctrl_1_logical).w
		jsr	(Stop_Object).w
		move.l	#BossFinalBall_CheckTouch_MoveDown,address(a0)

BossFinalBall_CheckTouch_MoveDown:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$60,d0
		sub.w	y_pos(a0),d0
		asl.w	#4,d0
		move.w	d0,y_vel(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		sub.w	x_pos(a0),d0
		beq.s	BossFinalBall_CheckTouch_PlayerExplosive
		asl.w	#5,d0
		move.w	d0,x_vel(a0)

BossFinalBall_CheckTouch_TimeExplosive_Draw:
		moveq	#0,d0
		btst	#0,(Level_frame_counter+1).w
		bne.s	+
		addi.w	#7*2,d0
+		bsr.w	BossFinalBall_PalFlash
		move.b	(V_int_run_count+3).w,d0
		andi.b	#1,d0
		move.b	d0,mapping_frame(a0)
		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

BossFinalBall_CheckTouch_PlayerExplosive:
		clr.w	x_vel(a0)
		move.l	#BossFinalBall_CheckTouch_PlayerExplosive_Swing,address(a0)
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossFinalBall_CheckTouch_PlayerExplosive_Swing
		move.b	#_FinalBallEnd,routine(a1)
		move.l	#DialogFinalBallEnd_Process_Index-4,$34(a1)
		move.b	#(DialogFinalBallEnd_Process_Index_End-DialogFinalBallEnd_Process_Index)/8,$39(a1)

BossFinalBall_CheckTouch_PlayerExplosive_Swing:
		move.b	angle(a0),d0
		addq.b	#2,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#2,d0
		move.w	d0,y_vel(a0)
		bra.s	BossFinalBall_CheckTouch_TimeExplosive_Draw
; ---------------------------------------------------------------------------

BossFinalBall_CheckTouch_SuperExplosive_Fall:
;		subq.w	#1,$2E(a0)
;		bpl.w	BossFinalBall_CheckTouch_PlayerExplosive_Swing
		st	(Screen_shaking_flag).w
		move.b	#$7F,(Negative_flash_timer).w
		move.w	#$7F,$2E(a0)
		bset	#7,status(a0)
		move.l	#BossFinalBall_CheckTouch_SuperExplosive_End,address(a0)
		lea	ChildObjDat_BossGreyBall_FlickerMove(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_CheckTouch_SuperExplosive_End:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#3,d0
		bne.s	+
		lea	ChildObjDat_DEZRadiusSuperExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
+		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge,0,0,0
+		subq.w	#1,$2E(a0)
		bpl.s	BossFinalBall_CheckTouch_SuperExplosive_Return
		clr.b	(Screen_shaking_flag).w
		clr.b	(Boss_flag).w
		addq.b	#2,(Background_event_routine).w
		jmp	(Go_Delete_Sprite_3).w
; ---------------------------------------------------------------------------

BossFinalBall_CheckTouch_SuperExplosive_Return:
		rts
; ---------------------------------------------------------------------------
; Падающий шипастый шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinalBall_RotateSpikeBall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossFinalBall_RotateSpikeBall_Index(pc,d0.w),d0
		jsr	BossFinalBall_RotateSpikeBall_Index(pc,d0.w)
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Index: offsetTable
		offsetTableEntry.w BossFinalBall_RotateSpikeBall_Init		; 0
		offsetTableEntry.w BossFinalBall_RotateSpikeBall_Setup	; 2
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Init:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.b	#5,d0
		move.b	d0,$3C(a0)
		lea	ObjDat3_BossGreyBall_SpikeBall(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.b	#44/2,y_radius(a0)
		move.l	#BossFinalBall_RotateSpikeBall_Radius,$34(a0)

BossFinalBall_RotateSpikeBall_Setup:
		jsr	(MoveSprite_Circular).w
		moveq	#4,d0
		btst	#6,status(a1)
		beq.s	+
		moveq	#8,d0
+		add.b	d0,$3C(a0)
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Radius:
		addq.b	#2,objoff_3A(a0)
		cmpi.b	#48,objoff_3A(a0)
		bne.s	BossFinalBall_RotateSpikeBall_Return
		sfx	sfx_SpikeBall2,0,0,0
		move.w	#$100,priority(a0)
		move.l	#BossFinalBall_RotateSpikeBall_Rotate,$34(a0)

BossFinalBall_RotateSpikeBall_Return:
		rts
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Rotate:
		movea.w	parent3(a0),a1
		btst	#1,$38(a1)
		beq.s	BossFinalBall_RotateSpikeBall_Rotate_Skip
		moveq	#$40,d1
		btst	#3,$38(a1)
		beq.s	+
		moveq	#0,d1
+		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		cmp.w	x_pos(a1),d0
		bge.s	+
		neg.b	d1
+		cmp.b	$3C(a0),d1
		beq.s	BossFinalBall_RotateSpikeBall_StopRotate

BossFinalBall_RotateSpikeBall_Rotate_Skip:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	BossFinalBall_RotateSpikeBall_Return
		lea	(ObjCheckFloorDist).w,a1
		bsr.s	BossFinalBall_RotateSpikeBall_Rotate_CheckSolidness
		lea	(ObjCheckCeilingDist).w,a1

BossFinalBall_RotateSpikeBall_Rotate_CheckSolidness:
		jsr	(a1)
		tst.w	d1
		bpl.s	BossFinalBall_RotateSpikeBall_Return
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_StopRotate:
		move.w	#$1F,$2E(a0)
		move.l	#BossFinalBall_RotateSpikeBall_StopRotate_Radius,$34(a0)
		clr.b	objoff_3A(a0)
		move.w	#$280,priority(a0)
		sfx	sfx_SpikeAttack2,0,0,0
		movea.w	parent3(a0),a1
		bclr	#1,$38(a1)
		btst	#2,$38(a1)
		bne.s	BossFinalBall_RotateSpikeBall_StopRotate2
		lea	ChildObjDat_BossGreyBall_SpikeBall_Missile(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossFinalBall_RotateSpikeBall_StopRotate_Return
		movea.w	parent3(a0),a2
		move.w	#$200,y_vel(a1)
		move.l	#BossFinalBall_MoveFallSpikeBall_Move2,$30(a1)
		btst	#5,$38(a2)
		bne.s	BossFinalBall_RotateSpikeBall_StopRotate_Return
		move.l	#BossFinalBall_MoveFourSpikeBall2,$30(a1)
		move.w	#-$200,y_vel(a1)
		move.w	#$200,x_vel(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		cmp.w	x_pos(a2),d0
		bge.s	BossFinalBall_RotateSpikeBall_StopRotate_Return
		neg.w	x_vel(a1)

BossFinalBall_RotateSpikeBall_StopRotate_Return:
		rts
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_StopRotate2:
		bclr	#2,$38(a1)
		btst	#3,$38(a1)
		bne.s	BossFinalBall_RotateSpikeBall_StopRotate3
		lea	ChildObjDat_BossGreyBall_SpikeBall_MissileExplosive(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossFinalBall_RotateSpikeBall_StopRotate_Return
		move.w	(Player_1+x_pos).w,d0
		sub.w	x_pos(a0),d0
		move.w	d0,d1
		move.w	d0,d2
		asl.w	#2,d0
		add.w	d1,d0
		move.w	d0,x_vel(a1)
		asl.w	#2,d2
		bmi.s	+
		neg.w	d2
+		cmpi.w	#-$100,d2
		blt.s		+
		move.w	#-$200,d2
+		move.w	d2,y_vel(a1)
		rts
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_StopRotate3:
		bclr	#3,$38(a1)
		lea	ChildObjDat_BossFinalBall_RotateSpikeBall_FallingMissile(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_StopRotate_Radius:
		addq.b	#1,objoff_3A(a0)
		cmpi.b	#48,objoff_3A(a0)
		bne.s	BossFinalBall_RotateSpikeBall_StopRotate_Radius_Return
		sfx	sfx_SpikeBall2,0,0,0
		move.w	#$100,priority(a0)
		move.l	#BossFinalBall_RotateSpikeBall_Rotate,$34(a0)

BossFinalBall_RotateSpikeBall_StopRotate_Radius_Return:
		rts
; ---------------------------------------------------------------------------
; Падающий шипастый шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinalBall_RotateSpikeBall_Missile:
		bsr.w	Obj_ChasingBall_SendPos
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossFinalBall_RotateSpikeBall_Missile_Index(pc,d0.w),d0
		jsr	BossFinalBall_RotateSpikeBall_Missile_Index(pc,d0.w)
		bsr.w	BossFinalBall_RotateSpikeBall_Missile_CheckTouch
		btst	#6,status(a0)
		bne.s	++
		moveq	#5,d0
		btst	#0,(Level_frame_counter+1).w
		bne.s	+
		moveq	#$10,d0
+		move.b	d0,mapping_frame(a0)
+		move.w	x_pos(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	BossFinalBall_RotateSpikeBall_Missile_Remove
		jmp	(Sprite_ChildCheckDeleteTouchY).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Missile_Index: offsetTable
		offsetTableEntry.w BossFinalBall_RotateSpikeBall_Missile_Init		; 0
		offsetTableEntry.w BossFinalBall_Setup3							; 2
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Missile_Init:
		clearRAM3 Pos_objtable_Start, Pos_objtable_End
		lea	ObjDat3_BossGreyBall_SpikeBall_Missile(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.b	#44/2,y_radius(a0)
		move.b	#3,collision_property(a0)
		move.b	#8,$39(a0)
		move.l	#BossFinalBall_RotateSpikeBall_Missile_Bounced,$34(a0)
		lea	ChildObjDat_BossGreyBall_Designator(pc),a2
		jsr	(CreateChild1_Normal).w
		bne.s	+
		move.w	#$17F,$2E(a1)
+		lea	ChildObjDat_BossFinalBall_SpikeBall_Bounced_Chain_Trail(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Missile_Bounced:
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jsr	(CreateChild6_Simple).w
		move.w	#-$500,y_vel(a0)
		move.w	#-$400,x_vel(a0)
		tst.b	$39(a0)
		beq.s	BossFinalBall_RotateSpikeBall_Missile_Return
		subq.b	#1,$39(a0)
		move.w	(Player_1+x_pos).w,d0
		sub.w	x_pos(a0),d0
		asl.w	#3,d0
		move.w	d0,x_vel(a0)

BossFinalBall_RotateSpikeBall_Missile_Return:
		rts
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Missile_Remove:
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a1
		move.w	#$1F,$2E(a1)
		move.l	$30(a0),$34(a1)
		jmp	(Go_Delete_Sprite).w
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
		ori.b	#$20,art_tile(a0)

BossFinalBall_RotateSpikeBall_Missile_CheckTouch_Flash:
		btst	#0,$1C(a0)
		bne.s	+
		eori.b	#$20,art_tile(a0)
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
		move.w	#$3F,$2E(a1)
		move.l	$30(a0),$34(a1)
		move.l	#BossFinalBall_RotateSpikeBall_Missile_Move,address(a0)
		move.w	x_pos(a1),d1
		move.w	y_pos(a1),d2
		sub.w	x_pos(a0),d1
		sub.w	y_pos(a0),d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		move.w	#$980,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		rts

; =============== S U B R O U T I N E =======================================

BossFinalBall_RotateSpikeBall_Missile_Move:
		bsr.s	BossFinalBall_RotateSpikeBall_Missile_Move_CheckTouch
		moveq	#5,d0
		btst	#0,(Level_frame_counter+1).w
		bne.s	+
		moveq	#$10,d0
+		move.b	d0,mapping_frame(a0)
		btst	#1,(Level_frame_counter+1).w
		beq.s	+
		lea	ChildObjDat_BossGreyBall_SpikeBall_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
+		jsr	(MoveSprite2).w
		jmp	(Sprite_CheckDeleteXY).w
; ---------------------------------------------------------------------------

obSpikeBall_CheckXY:
		dc.w -32		; X right pos
		dc.w 40		; X left pos
		dc.w -32		; Y down pos
		dc.w 64		; Y up pos
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Missile_Move_CheckTouch:
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a1
		lea	obSpikeBall_CheckXY(pc),a2
		jsr	(Check_InMyRange).l
		beq.s	BossFinalBall_RotateSpikeBall_Missile_Move_CheckTouch_Return
		move.w	#$14,(Screen_shaking_flag).w

		move.b	collision_flags(a1),collision_restore_flags(a1)
		clr.b	collision_flags(a1)
		subq.b	#1,collision_property(a1)
		st	obBFB_Hit(a1)

		bset	#7,status(a0)
		move.l	#Go_Delete_Sprite,address(a0)

		lea	ChildObjDat_DEZRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_BossGreyBall_Splinter(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Missile_Move_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------
; Взрывающийся шипастый шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinalBall_RotateSpikeBall_MissileExplosive:
		bsr.w	Obj_ChasingBall_SendPos
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossFinalBall_RotateSpikeBall_MissileExplosive_Index(pc,d0.w),d0
		jsr	BossFinalBall_RotateSpikeBall_MissileExplosive_Index(pc,d0.w)
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_MissileExplosive_Index: offsetTable
		offsetTableEntry.w BossFinalBall_RotateSpikeBall_MissileExplosive_Init		; 0
		offsetTableEntry.w BossFinalBall_Setup3									; 2
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_MissileExplosive_Init:
		clearRAM3 Pos_objtable_Start, Pos_objtable_End
		lea	ObjDat3_BossGreyBall_SpikeBall_MissileExplosive(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.b	#44/2,y_radius(a0)
		move.l	#BossFinalBall_RotateSpikeBall_MissileExplosive_Bounced,$34(a0)
		lea	ChildObjDat_BossFinalBall_SpikeBall_Bounced_Chain_Trail(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_MissileExplosive_Bounced:
		bset	#7,status(a0)
		move.l	#Go_Delete_Sprite,address(a0)
		sfx	sfx_BreakBridge,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_BossFinalBall_DEZExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_BossGreyBall_Splinter(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Взрывающийся шипастый шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinalBall_RotateSpikeBall_FallingMissile:
		bsr.w	Obj_ChasingBall_SendPos
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossFinalBall_RotateSpikeBall_FallingMissile_Index(pc,d0.w),d0
		jsr	BossFinalBall_RotateSpikeBall_FallingMissile_Index(pc,d0.w)
		jmp	(Sprite_ChildCheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_FallingMissile_Index: offsetTable
		offsetTableEntry.w BossFinalBall_RotateSpikeBall_FallingMissile_Init		; 0
		offsetTableEntry.w BossFinalBall_Setup3								; 2
		offsetTableEntry.w BossFinalBall_Setup								; 4
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_FallingMissile_Init:
		lea	ObjDat3_BossGreyBall_SpikeBall_MissileExplosive(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.b	#44/2,y_radius(a0)
		move.w	#$400,y_vel(a0)
		move.w	(HScroll_Shift).w,d0
		neg.w	d0
		move.w	d0,$30(a0)

-		jsr	(Random_Number).w
		andi.w	#$3FF,d0
		beq.s	-
		addi.w	#$180,d0
		neg.w	d0
		move.w	d0,$32(a0)
		move.l	#BossFinalBall_RotateSpikeBall_FallingMissile_Bounced,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_FallingMissile_Bounced:
		move.w	$30(a0),x_vel(a0)
		move.w	$32(a0),y_vel(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Клон (Интро)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinalBall_IntroClone:
		lea	ObjDat3_BossGreyBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#64,objoff_3C(a0)
		move.b	#128,objoff_3A(a0)
		move.l	#BossFinalBall_IntroClone_Frame2,address(a0)
		tst.b	subtype(a0)
		beq.s	BossFinalBall_IntroClone_Frame2
		neg.b	objoff_3C(a0)
		move.l	#BossFinalBall_IntroClone_Frame1,address(a0)

BossFinalBall_IntroClone_Frame1:
		btst	#0,(Level_frame_counter+1).w
		beq.s	BossFinalBall_IntroClone_Draw

BossFinalBall_IntroClone_NoDraw:
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

BossFinalBall_IntroClone_Frame2:
		btst	#0,(Level_frame_counter+1).w
		beq.s	BossFinalBall_IntroClone_NoDraw

BossFinalBall_IntroClone_Draw:
		subq.b	#2,objoff_3A(a0)
		bmi.s	BossFinalBall_IntroClone_Remove
		jsr	(MoveSprite_Circular).w

BossFinalBall_IntroClone_Draw2:
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

BossFinalBall_IntroClone_Remove:
		bset	#7,status(a0)
		move.l	#Go_Delete_Sprite,address(a0)
		tst.b	subtype(a0)
		bne.s	+
		movea.w	parent3(a0),a1
		move.l	#BossFinalBall_Intro_MoveSwing_Load,obBGB_Jump(a1)
		clr.b	obBGB_Draw(a1)
		sfx	sfx_Activation,0,0,0
		move.w	#$1F,(Screen_shaking_flag).w
		move.b	#$1F,(Negative_flash_timer).w
+		bra.s	BossFinalBall_IntroClone_Draw2
; ---------------------------------------------------------------------------
; Тень отскакивающего шипастого шара
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinalBall_SpikeBall_Bounced_Chain_Trail:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.b	#4,d0
		addi.b	#$24,d0
		move.b	d0,$39(a0)
		lea	ObjDat3_BossGreyBall_SpikeBall_Chain(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#+,address(a0)
+		bsr.w	Obj_ChasingBall_CopyPos
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		add.w	d0,d0
		btst	#1,subtype(a0)
		bne.s	BossFinalBall_SpikeBall_Bounced_Chain_Trail_Check
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossFinalBall_SpikeBall_Bounced_Chain_Trail_CheckParent

BossFinalBall_SpikeBall_Bounced_Chain_Trail_Draw:
		jmp	(Child_Draw_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------

BossFinalBall_SpikeBall_Bounced_Chain_Trail_Check:
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossFinalBall_SpikeBall_Bounced_Chain_Trail_Draw

BossFinalBall_SpikeBall_Bounced_Chain_Trail_CheckParent:
		jmp	(Child_CheckParent_FlickerMove).w
; ---------------------------------------------------------------------------
; Взрывы
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinalBall_DEZExplosion:
		moveq	#1,d2
		moveq	#8-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	BossFinalBall_DEZExplosion_Remove
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
		move.w	(HScroll_Shift).w,d0
		neg.w	d0
		move.w	d0,x_vel(a1)
		move.b	#3,anim_frame_timer(a1)
		addq.w	#1,d2
		dbf	d1,-

BossFinalBall_DEZExplosion_Remove:
		bra.w	DEZExplosion_Delete
; ---------------------------------------------------------------------------
; Падающий взрыв
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinalBall_DEZFallingExplosion:
		move.w	#$F,$2E(a0)
		move.l	#Obj_BossFinalBall_DEZFallingExplosion_Wait,address(a0)

Obj_BossFinalBall_DEZFallingExplosion_Start:
		moveq	#0,d2
		moveq	#16-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	Obj_BossFinalBall_DEZFallingExplosion_Wait
		move.l	#Obj_DEZFallingExplosion_SetVelocity,address(a1)
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
		movea.w	parent3(a0),a2
		move.w	x_pos(a2),x_pos(a1)
		move.w	y_pos(a2),y_pos(a1)
		move.b	d2,subtype(a1)
		move.b	#7,anim_frame_timer(a1)
		addq.w	#4,d2
		dbf	d1,-

Obj_BossFinalBall_DEZFallingExplosion_Wait:
		moveq	#sfx_BreakBridge,d0
		moveq	#7,d2
		jsr	(Wait_Play_Sound).w
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	Robotnik_IntroFullExplosion_Delete
		btst	#5,$38(a1)
		beq.w	Robotnik_IntroFullExplosion_Delete
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_Swing_Setup_Return
		move.w	#$F,$2E(a0)
		bra.w	Obj_BossFinalBall_DEZFallingExplosion_Start

; =============== S U B R O U T I N E =======================================

BossFinalBall_PalFlash:
		lea	BossFinalBall_PalRAM(pc),a1
		lea	BossFinalBall_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_7).w
; ---------------------------------------------------------------------------

BossFinalBall_PalRAM:
		dc.w Normal_palette_line_2+$1C
		dc.w Normal_palette_line_2+$1A
		dc.w Normal_palette_line_2+$18
		dc.w Normal_palette_line_2+$1E
		dc.w Normal_palette_line_2+$16
		dc.w Normal_palette_line_2+$14
		dc.w Normal_palette_line_2+$12
BossFinalBall_PalCycle:
		dc.w $424, $644, $866, $A88, $CAA, $ECC, $222	; Normal
		dc.w $42, $64, $86, $A8, $CA, $EC, $22	; Flash

; =============== S U B R O U T I N E =======================================

ObjDat3_BossGreyBall_SpikeBall_Missile:
		dc.w $280
		dc.b 48/2
		dc.b 48/2
		dc.b 5
		dc.b 1
ObjDat3_BossGreyBall_SpikeBall_MissileExplosive:
		dc.w $280
		dc.b 48/2
		dc.b 48/2
		dc.b 5
		dc.b 1|$80
ChildObjDat_BossFinalBall_IntroClone:
		dc.w 2-1
		dc.l Obj_BossFinalBall_IntroClone
ChildObjDat_BossFinalBall_RotateSpikeBall:
		dc.w 4-1
		dc.l Obj_BossFinalBall_RotateSpikeBall
ChildObjDat_BossFinalBall_SpikeBall_Bounced_Chain_Trail:
		dc.w 6-1
		dc.l Obj_BossFinalBall_SpikeBall_Bounced_Chain_Trail
ChildObjDat_BossGreyBall_SpikeBall_Missile:
		dc.w 1-1
		dc.l Obj_BossFinalBall_RotateSpikeBall_Missile
ChildObjDat_BossGreyBall_SpikeBall_MissileExplosive:
		dc.w 1-1
		dc.l Obj_BossFinalBall_RotateSpikeBall_MissileExplosive
ChildObjDat_BossFinalBall_RotateSpikeBall_FallingMissile:
		dc.w 1-1
		dc.l Obj_BossFinalBall_RotateSpikeBall_FallingMissile
ChildObjDat_BossFinalBall_DEZExplosion:
		dc.w 1-1
		dc.l Obj_BossFinalBall_DEZExplosion
ChildObjDat_BossFinalBall_DEZFallingExplosion:
		dc.w 1-1
		dc.l Obj_BossFinalBall_DEZFallingExplosion