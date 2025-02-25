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
		bsr.w	BossFinalBall_CheckTouch
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
		move.l	#BossFinalBall_Intro,obBFB_Jump(a0)


		move.b	#1,(Update_HUD_timer).w
		move.b	#1,(HUDBoss_RAM.status).w
		move.w	a0,(HUDBoss_RAM.parent).w


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
		subq.b	#1,$39(a0)

BossFinalBall_Setup:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossFinalBall_Setup3:
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w

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

BossFinalBall_MoveFourSpikeBall:
		move.b	#_Setup2,routine(a0)
		move.b	#3,$39(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_Move,obBFB_Jump(a0)
		jsr	(Find_SonicTails).w
		move.w	#$100,x_vel(a0)
		tst.w	d0
		beq.s	+
		neg.w	x_vel(a0)
+		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFourSpikeBall2:
		move.b	#_Setup2,routine(a0)
		move.b	#3,$39(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_Move,obBFB_Jump(a0)
		move.w	#$100,x_vel(a0)
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
		move.w	#$2F,$2E(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_SetMoveDown,obBFB_Jump(a0)
		clr.w	x_vel(a0)

BossFinalBall_MoveFourSpikeBall_Move_Return:
		rts
; ---------------------------------------------------------------------------

BossFinalBall_MoveFourSpikeBall_SetMoveDown:
		bset	#1,$38(a0)
		move.l	#BossFinalBall_MoveFourSpikeBall_MoveDown_Return,obBFB_Jump(a0)

BossFinalBall_MoveFourSpikeBall_MoveDown_Return:
		rts
; ---------------------------------------------------------------------------
; Босс меняет гравитацию
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinalBall_MoveReverseGravity:
		move.b	#_Setup3,routine(a0)
















; ---------------------------------------------------------------------------
; Проверка урона
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinalBall_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	BossFinalBall_CheckTouch_Return
		move.b	collision_property(a0),d4
		beq.w	BossFinalBall_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.s	BossFinalBall_CheckTouch_Flash
		sfx	sfx_HitBoss,0,0,0
		move.b	#$60,$1C(a0)
		move.b	#$4F,(Negative_flash_timer).w
		bset	#6,status(a0)
		bset	#4,$38(a0)
		lea	ChildObjDat_BossFinalBall_DEZFallingExplosion(pc),a2
		jsr	(CreateChild6_Simple).w

BossFinalBall_CheckTouch_Flash:
		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	+
		addi.w	#7*2,d0
+		bsr.w	BossFinalBall_PalFlash
		subq.b	#1,$1C(a0)
		bne.s	BossFinalBall_CheckTouch_Return
		bclr	#6,status(a0)

BossFinalBall_CheckTouch_Restore:
		move.b	collision_restore_flags(a0),collision_flags(a0)
		bclr	#4,$38(a0)

BossFinalBall_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

BossFinalBall_CheckTouch_WaitExplosive:
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
		addq.b	#4,$3C(a0)
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
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		cmp.w	x_pos(a1),d0
		bge.s	+
		moveq	#-$40,d1
+		cmp.b	$3C(a0),d1
		beq.s	BossFinalBall_RotateSpikeBall_StopRotate

BossFinalBall_RotateSpikeBall_Rotate_Skip:
		lea	(ObjCheckFloorDist).w,a1
		bsr.s	BossFinalBall_RotateSpikeBall_Rotate_CheckSolidness
		lea	(ObjCheckCeilingDist).w,a1

BossFinalBall_RotateSpikeBall_Rotate_CheckSolidness:
		jsr	(a1)
		tst.w	d1
		bpl.s	BossFinalBall_RotateSpikeBall_Return
		moveq	#sfx_Rotate,d0
		moveq	#$17,d2
		jsr	(Wait_Play_Sound).w
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	BossFinalBall_RotateSpikeBall_Return
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_StopRotate:
		move.w	#$1F,$2E(a0)
		move.l	#BossFinalBall_RotateSpikeBall_StopRotate_Radius,$34(a0)
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
+		rts
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_StopRotate_Radius:
		addq.b	#1,objoff_3A(a0)
		cmpi.b	#48,objoff_3A(a0)
		bne.s	BossFinalBall_RotateSpikeBall_StopRotate_Return
		sfx	sfx_SpikeBall2,0,0,0
		move.w	#$100,priority(a0)
		move.l	#BossFinalBall_RotateSpikeBall_Rotate,$34(a0)

BossFinalBall_RotateSpikeBall_StopRotate_Return:
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
		bne.s	+
		eori.b	#$60,art_tile(a0)
+		move.w	x_pos(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	BossFinalBall_RotateSpikeBall_Missile_Remove
		jmp	(Sprite_ChildCheckDeleteTouchY).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Missile_Index: offsetTable
		offsetTableEntry.w BossFinalBall_RotateSpikeBall_Missile_Init		; 0
		offsetTableEntry.w BossFinalBall_RotateSpikeBall_Missile_Setup		; 2
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
+		lea	ChildObjDat_BossGreyBall_SpikeBall_Bounced_Chain_Trail(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Missile_Setup:
		jsr	(MoveSprite_TestGravity).w
		jmp	(ObjHitFloor_DoRoutine).w
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
		move.l	#BossFinalBall_MoveFourSpikeBall2,$34(a1)
		move.l	#BossFinalBall_RotateSpikeBall_Missile_Move,address(a0)
		rts
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
		move.w	#$3F,$2E(a1)
		move.l	#BossFinalBall_MoveFourSpikeBall2,$34(a1)
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
		eori.b	#$60,art_tile(a0)
		jsr	(MoveSprite2).w
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
		move.l	#Go_Delete_Sprite,address(a0)

		move.b	collision_flags(a1),collision_restore_flags(a1)
		clr.b	collision_flags(a1)
		subq.b	#1,collision_property(a1)









		lea	ChildObjDat_DEZRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_BossGreyBall_Splinter(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFinalBall_RotateSpikeBall_Missile_Move_CheckTouch_Return:
		rts






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
		move.w	#$8530,art_tile(a1)
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
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	Robotnik_IntroFullExplosion_Delete
		btst	#4,$38(a1)
		beq.w	Robotnik_IntroFullExplosion_Delete
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_Swing_Setup_Return
		move.w	#$F,$2E(a0)
		bra.s	Obj_BossFinalBall_DEZFallingExplosion_Start

; =============== S U B R O U T I N E =======================================

BossFinalBall_PalFlash:
		lea	BossFinalBall_PalRAM(pc),a1
		lea	BossFinalBall_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_7).w
; ---------------------------------------------------------------------------

BossFinalBall_PalRAM:
		dc.w Normal_palette_line_4+4
		dc.w Normal_palette_line_4+6
		dc.w Normal_palette_line_4+8
		dc.w Normal_palette_line_4+$A
		dc.w Normal_palette_line_4+$C
		dc.w Normal_palette_line_4+$E
		dc.w Normal_palette_line_4+$1E
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
ChildObjDat_BossFinalBall_RotateSpikeBall:
		dc.w 4-1
		dc.l Obj_BossFinalBall_RotateSpikeBall
ChildObjDat_BossGreyBall_SpikeBall_Missile:
		dc.w 1-1
		dc.l Obj_BossFinalBall_RotateSpikeBall_Missile
ChildObjDat_BossFinalBall_DEZFallingExplosion:
		dc.w 1-1
		dc.l Obj_BossFinalBall_DEZFallingExplosion
