; ---------------------------------------------------------------------------
; Босс-шар
; ---------------------------------------------------------------------------

; Hits
BossGreyBall_Hits				= 8

; Attributes
_Setup4						= 8
_Setup5						= $A
_Setup6						= $C
_Setup7						= $E
_Setup8						= $10
_Setup9						= $12
_SetupA						= $14
_SetupB						= $16
_SetupC						= $18

; Dynamic object variables
obBGB_Looking				= $20	; .b
obBGB_DeadZone				= $21	; .b
obBGB_XPos					= $30	; .w
obBGB_Routine				= $32	; .b
obBGB_Draw					= $33	; .b
obBGB_Jump				= $34	; .l
obBGB_Status				= $38	; .b
obBGB_Count				= $39	; .b
obBGB_SwingLRSpeed			= $3A	; .w
obBGB_SwingLRAcceleration	= $3C	; .w
obBGB_SwingUDSpeed		= $3E	; .w
obBGB_SwingUDAcceleration	= $40	; .w

vBGB_FlickerTimer			= Boss_Events	; .b
vBGB_RingCount				= Boss_Events+1	; .b



; $20-$21, $23-$24, $26-$27, $2C-$2D, $42-$49	; free

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BossGreyBall_Index(pc,d0.w),d0
		jsr	BossGreyBall_Index(pc,d0.w)
		bsr.w	BossGreyBall_CheckTouch
		bsr.w	BossGreyBall_DeadZone
		move.b	(V_int_run_count+3).w,d0
		andi.b	#1,d0
		move.b	d0,mapping_frame(a0)
		tst.b	obBGB_Draw(a0)
		bne.w	BossGreyBall_CheckCameraPosition_Return
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

BossGreyBall_Index: offsetTable
		offsetTableEntry.w BossGreyBall_Init		; 0
		offsetTableEntry.w BossGreyBall_Setup	; 2
		offsetTableEntry.w BossGreyBall_Setup2	; 4
		offsetTableEntry.w BossGreyBall_Setup3	; 6
		offsetTableEntry.w BossGreyBall_Setup4	; 8
		offsetTableEntry.w BossGreyBall_Setup5	; A
		offsetTableEntry.w BossGreyBall_Setup6	; C
		offsetTableEntry.w BossGreyBall_Setup7	; E
		offsetTableEntry.w BossGreyBall_Setup8	; 10
		offsetTableEntry.w BossGreyBall_Setup9	; 12
		offsetTableEntry.w BossGreyBall_SetupA	; 14
		offsetTableEntry.w BossGreyBall_SetupB	; 16
		offsetTableEntry.w BossGreyBall_SetupC	; 18
; ---------------------------------------------------------------------------

BossGreyBall_Init:
		lea	ObjDat3_BossGreyBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(Boss_flag).w
		clr.w	(Boss_Events).w
		move.b	#62/2,y_radius(a0)
		move.b	#BossGreyBall_Hits,collision_property(a0)
		tst.b	(GoodMode_flag).w
		bne.s	BossGreyBall_SkipSecurity
		st	collision_property(a0)

BossGreyBall_SkipSecurity:
		move.l	#BossGreyBall_Intro,obBGB_Jump(a0)
		lea	ChildObjDat_BossGreyBall_Face(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossGreyBall_Setup2:
		bsr.w	BossGreyBall_CheckCameraPosition
		jsr	(Find_SonicTails).w
		addi.w	#$20,d2
		cmpi.w	#$80,d2
		blo.s		BossGreyBall_Setup3
		move.w	#$100,d1
		tst.w	d0
		bne.s	+
		neg.w	d1
+		move.w	d1,x_vel(a0)

BossGreyBall_Setup3:
		jsr	(Swing_UpAndDown).w

BossGreyBall_Setup:
		jsr	(MoveSprite2).w

BossGreyBall_Setup_Wait:
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossGreyBall_SetupC:
		jsr	(Find_SonicTails).w
		subi.w	#3,x_pos(a0)
		tst.w	d0
		bne.s	+
		addi.w	#6,x_pos(a0)
+		move.w	(Camera_X_pos).w,d0
		addi.w	#$40,d0
		cmp.w	x_pos(a0),d0
		blt.s		+
		move.w	d0,x_pos(a0)
		clr.w	2+x_pos(a0)
+		addi.w	#$C0,d0
		cmp.w	x_pos(a0),d0
		bgt.s	+
		move.w	d0,x_pos(a0)
		clr.w	2+x_pos(a0)
+		lea	(Player_1).w,a1
		move.w	#$100,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectYOnly).w

BossGreyBall_SetupA:
		bsr.w	BossGreyBall_CreateFire
		bsr.w	BossGreyBall_CheckFireShield
		bra.s	BossGreyBall_Setup
; ---------------------------------------------------------------------------

BossGreyBall_SetupB:
		bsr.w	BossGreyBall_CreateFire
		bsr.w	BossGreyBall_CheckFireShield
		jsr	(MoveSprite).w
		bra.s	BossGreyBall_Setup_Wait
; ---------------------------------------------------------------------------

BossGreyBall_Setup5:
		jsr	(Swing_LeftAndRight).w
		bra.s	BossGreyBall_Setup
; ---------------------------------------------------------------------------

BossGreyBall_Setup4:
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

BossGreyBall_Setup6:
		bsr.s	BossGreyBall_CheckCameraPosition
		bsr.w	BossGreyBall_CreateFire
		bsr.s	BossGreyBall_CheckFireShield
		jsr	(MoveSprite).w
		bra.w	BossGreyBall_Setup_Wait
; ---------------------------------------------------------------------------

BossGreyBall_Setup7:
		bsr.s	BossGreyBall_CheckCameraPosition
		bsr.w	BossGreyBall_CreateFire
		bsr.s	BossGreyBall_CheckFireShield
		bra.w	BossGreyBall_Setup
; ---------------------------------------------------------------------------

BossGreyBall_Setup8:
		move.w	(Oscillating_Data+2).w,d0
		asr.w	#1,d0
		move.w	d0,x_vel(a0)
		bra.w	BossGreyBall_Setup3
; ---------------------------------------------------------------------------

BossGreyBall_Setup9:
		bsr.s	BossGreyBall_CreateFire
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge,0,0,0
+		bra.w	BossGreyBall_Setup

; =============== S U B R O U T I N E =======================================

BossGreyBall_CheckCameraPosition:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$20,d0
		cmp.w	x_pos(a0),d0
		blt.s		+
		neg.w	x_vel(a0)
+		addi.w	#$100,d0
		cmp.w	x_pos(a0),d0
		bgt.s	BossGreyBall_CheckCameraPosition_Return
		neg.w	x_vel(a0)

BossGreyBall_CheckCameraPosition_Return:
		rts

; =============== S U B R O U T I N E =======================================

BossGreyBall_CheckFireShield:
		lea	(Player_1).w,a1
		cmpi.b	#id_SonicDeath,routine(a1)
		bhs.s	BossGreyBall_CheckFireShield_Return
		btst	#Status_FireShield,status_secondary(a1)
		bne.s	BossGreyBall_CheckFireShield_Return
		bsr.w	BossGreyBall_SecondPhase_Intro_CreateFireShield

BossGreyBall_CheckFireShield_Return:
		rts
; ---------------------------------------------------------------------------
; Попытка исправить коллизию
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGreyBall_DeadZone:
		tst.b	obBGB_DeadZone(a0)
		beq.s	BossGreyBall_CheckFireShield_Return
		tst.b	obBGB_Looking(a0)
		beq.s	BossGreyBall_CheckFireShield_Return
		jsr	(Find_SonicTails).w
		moveq	#16,d0
		cmp.w	d0,d2
		bhs.s	BossGreyBall_CheckFireShield_Return
		cmp.w	d0,d3
		bhs.s	BossGreyBall_CheckFireShield_Return
		lea	(Player_1).w,a1		; Довольно застревать!
		bra.w	sub_24280		; Получай!

; =============== S U B R O U T I N E =======================================

BossGreyBall_CreateFire:
		moveq	#3,d1
		btst	#7,(v_Breathing_bubbles+$38).w
		beq.s	+
		moveq	#1,d1
+		move.b	(Level_frame_counter+1).w,d0
		and.w	d1,d0
		bne.s	+
		lea	ChildObjDat_BossGreyBall_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#48/2,$3A(a1)
		move.b	#48/2,$3B(a1)
		move.w	#$100,$3C(a1)
+		rts

; =============== S U B R O U T I N E =======================================

BossGreyBall_CreateFire_SpikeBall:
		moveq	#3,d1
		btst	#7,(v_Breathing_bubbles+$38).w
		beq.s	+
		moveq	#1,d1
+		move.b	(Level_frame_counter+1).w,d0
		and.w	d1,d0
		bne.s	+
		lea	ChildObjDat_BossGreyBall_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#24/2,$3A(a1)
		move.b	#24/2,$3B(a1)
		move.w	#$80,$3C(a1)
+		rts
; ---------------------------------------------------------------------------
; Интро
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGreyBall_Intro:
		sfx	sfx_Flash,0,0,0
		move.b	#4,(Hyper_Sonic_flash_timer).w
		move.l	#BossGreyBall_CheckFireShield_Return,obBGB_Jump(a0)
		lea	ChildObjDat_BossGreyBall_IntroClone(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossGreyBall_Intro_MoveSwing:
		move.b	#_Setup8,routine(a0)
		tst.b	(Intro_flag).w
		bne.s	BossGreyBall_Intro_SkipIntro
		addq.b	#1,(Intro_flag).w
		st	(NoPause_flag).w
		move.l	#BossGreyBall_CheckFireShield_Return,obBGB_Jump(a0)
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#_GreyBallStart,routine(a1)
		move.l	#DialogGreyBallStart_Process_Index-4,$34(a1)
		move.b	#(DialogGreyBallStart_Process_Index_End-DialogGreyBallStart_Process_Index)/8,$39(a1)
+		bra.w	BossGreyBall_Swing_Setup
; ---------------------------------------------------------------------------

BossGreyBall_Intro_SkipIntro:
		move.w	#$F,$2E(a0)
		move.w	#-$100,y_vel(a0)
		move.b	#_Setup1,routine(a0)
		move.l	#BossGreyBall_Intro_CheckPosition,obBGB_Jump(a0)
		move.b	#1,(Update_HUD_timer).w
		move.b	#1,(HUDBoss_RAM.status).w
		move.w	a0,(HUDBoss_RAM.parent).w
		clr.b	(Ctrl_1_locked).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------

BossGreyBall_Intro_CheckPosition:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$50,d0
		cmp.w	y_pos(a0),d0
		blo.s		BossGreyBall_Intro_CheckPosition_Return
		move.l	#BossGreyBall_SetSubroutine,obBGB_Jump(a0)
		clr.l	x_vel(a0)

BossGreyBall_Intro_CheckPosition_Return:
		rts

; =============== S U B R O U T I N E =======================================

BossGreyBall_SetSubroutine:
		moveq	#0,d0
		move.b	obBGB_Routine(a0),d0
		addq.b	#1,obBGB_Routine(a0)
		move.b	BossGreyBall_SetMovement(pc,d0.w),d0
		bmi.s	+
		lea	BossGreyBall_Movement(pc),a1
		adda.w	(a1,d0.w),a1
		move.l	a1,obBGB_Jump(a0)
		rts
+		clr.b	obBGB_Routine(a0)
		rts
; ---------------------------------------------------------------------------

BossGreyBall_SetMovement:
		dc.b 0
		dc.b 1<<1
		dc.b 2<<1
		dc.b 1<<1
		dc.b -1	; Конец
	even
BossGreyBall_Movement: offsetTable
		offsetTableEntry.w BossGreyBall_MoveSpikeBall_Explosion	; 0
		offsetTableEntry.w BossGreyBall_MoveSpikeBall_Hand		; 2
		offsetTableEntry.w BossGreyBall_MoveSpikeBall_Bounced	; 4
; ---------------------------------------------------------------------------
; Босс атакует с помощью взрывающихся шипастых шаров
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGreyBall_MoveSpikeBall_Explosion:
		move.b	#_Setup2,routine(a0)
		bsr.w	BossGreyBall_Swing_Setup
		move.b	#6,obBGB_Count(a0)
		jsr	(Find_SonicTails).w
		move.w	#$100,x_vel(a0)
		tst.w	d0
		bne.s	+
		neg.w	x_vel(a0)
+		move.l	#BossGreyBall_MoveSpikeBall_Explosion_Attack,obBGB_Jump(a0)

BossGreyBall_MoveSpikeBall_Explosion_Attack:
		move.w	#$6F,$2E(a0)
		lea	ChildObjDat_BossGreyBall_SpikeBall_Explosion(pc),a2
		jsr	(CreateChild6_Simple).w
		subq.b	#1,obBGB_Count(a0)
		bne.s	+
		move.l	#BossGreyBall_SetSubroutine,obBGB_Jump(a0)
+		rts
; ---------------------------------------------------------------------------
; Босс атакует с помощью шипастой руки
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGreyBall_MoveSpikeBall_Hand:
		move.b	#_Setup3,routine(a0)
		bsr.w	BossGreyBall_Swing_Setup
		move.l	#BossGreyBall_MoveSpikeBall_Hand_CheckPosition,obBGB_Jump(a0)
		jsr	(Find_SonicTails).w
		move.w	#$10,d1
		tst.w	d0
		bne.s	+
		move.w	#$130,d1
+		move.w	d1,obBGB_XPos(a0)

BossGreyBall_MoveSpikeBall_Hand_CheckPosition:
		move.w	(Camera_X_pos).w,d0
		add.w	obBGB_XPos(a0),d0
		sub.w	x_pos(a0),d0
		bmi.s	+
		cmpi.w	#20,d0
		bhs.s	+++
		bra.s	++
+		cmpi.w	#-20,d0
		blo.s		++
+		move.l	#BossGreyBall_MoveSpikeBall_Hand_Bounced,obBGB_Jump(a0)
+		asl.w	#3,d0
		move.w	d0,x_vel(a0)

BossGreyBall_MoveSpikeBall_Hand_Wait:
		rts
; ---------------------------------------------------------------------------

BossGreyBall_MoveSpikeBall_Hand_Bounced:
		move.b	#_Setup4,routine(a0)
		move.l	#BossGreyBall_MoveSpikeBall_Hand_CheckBounced,obBGB_Jump(a0)
		clr.w	x_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossGreyBall_MoveSpikeBall_Hand_CheckBounced:
		move.w	y_vel(a0),d0
		bmi.s	BossGreyBall_MoveSpikeBall_Hand_Wait
		cmpi.w	#$180,d0
		blo.s		BossGreyBall_MoveSpikeBall_Hand_SetCreate
		asr.w	d0
		neg.w	d0
		move.w	d0,y_vel(a0)

BossGreyBall_MoveSpikeBall_Hand_Shaking:
		sfx	sfx_Wham,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossGreyBall_MoveSpikeBall_Hand_SetCreate:
		move.b	#_Setup1,routine(a0)
		move.w	#$1F,$2E(a0)
		move.l	#BossGreyBall_MoveSpikeBall_Hand_Create,obBGB_Jump(a0)
		clr.w	y_vel(a0)
		st	obBGB_DeadZone(a0)
		rts
; ---------------------------------------------------------------------------

BossGreyBall_MoveSpikeBall_Hand_Create:
		move.l	#BossGreyBall_MoveSpikeBall_Hand_Wait,obBGB_Jump(a0)
		lea	ChildObjDat_BossGreyBall_SpikeBall(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossGreyBall_MoveSpikeBall_Hand_ReturnPosition:
		move.b	#_Setup5,routine(a0)
		move.w	#$2F,$2E(a0)
		move.l	#BossGreyBall_MoveSpikeBall_Hand_Return,obBGB_Jump(a0)
		move.w	#-$200,y_vel(a0)
		bra.w	BossGreyBall_Swing_Setup2
; ---------------------------------------------------------------------------

BossGreyBall_MoveSpikeBall_Hand_Return:
		move.b	#_Setup3,routine(a0)
		move.l	#BossGreyBall_SetSubroutine,obBGB_Jump(a0)
		clr.w	x_vel(a0)
		clr.b	obBGB_DeadZone(a0)
		rts
; ---------------------------------------------------------------------------
; Босс атакует с помощью шипастых шаров на цепи
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGreyBall_MoveSpikeBall_Bounced:
		move.b	#_Setup2,routine(a0)
		bsr.w	BossGreyBall_Swing_Setup
		move.b	#4,obBGB_Count(a0)
		jsr	(Find_SonicTails).w
		move.w	#$100,x_vel(a0)
		tst.w	d0
		bne.s	+
		neg.w	x_vel(a0)
+		move.l	#BossGreyBall_MoveSpikeBall_Bounced_Attack,obBGB_Jump(a0)

BossGreyBall_MoveSpikeBall_Bounced_Attack:
		move.w	#$EF,$2E(a0)
		lea	ChildObjDat_BossGreyBall_SpikeBall_Bounced(pc),a2
		jsr	(CreateChild6_Simple).w
		subq.b	#1,obBGB_Count(a0)
		bne.s	+
		move.l	#BossGreyBall_SetSubroutine,obBGB_Jump(a0)
+		rts
; ---------------------------------------------------------------------------
; Интро (вторая фаза)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGreyBall_SecondPhase_Intro:
		move.b	#_Setup5,routine(a0)
		move.l	#BossGreyBall_SecondPhase_Intro_CheckPosition,obBGB_Jump(a0)
		bclr	#4,$38(a0)
		bclr	#6,$38(a0)
		clr.b	(vBGB_FlickerTimer).w
		move.w	#-$200,y_vel(a0)
		move.w	#$4F,(Screen_shaking_flag).w
		move.b	#$67,(Negative_flash_timer).w
		bra.w	BossGreyBall_Swing_Setup2
; ---------------------------------------------------------------------------

BossGreyBall_SecondPhase_Intro_CheckPosition:
		bsr.w	BossGreyBall_CreateFire
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge,0,0,0
+		move.w	(Camera_Y_pos).w,d0
		addi.w	#$40,d0
		cmp.w	y_pos(a0),d0
		blo.s		BossGreyBall_SecondPhase_Intro_Return
		move.b	#_Setup9,routine(a0)
		move.w	#$1F,$2E(a0)
		move.l	#BossGreyBall_SecondPhase_Intro_Fall,obBGB_Jump(a0)
		clr.l	x_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossGreyBall_SecondPhase_Intro_Fall:
		move.b	#_Setup1,routine(a0)
		move.l	#BossGreyBall_MoveJump_Attack,obBGB_Jump(a0)
		clr.l	x_vel(a0)
		lea	(Player_1).w,a1
		sfx	sfx_FireShield,0,0,0

BossGreyBall_SecondPhase_Intro_CreateFireShield:
		andi.b	#$8E,status_secondary(a1)
		bset	#Status_FireShield,status_secondary(a1)
		move.l	#Obj_Fire_Shield,(v_Shield).w
		move.w	a1,(v_Shield+parent).w

BossGreyBall_SecondPhase_Intro_Return:
		rts
; ---------------------------------------------------------------------------
; Босс атакует с помощью прыжка (вторая фаза)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGreyBall_MoveJump_Attack:
		move.b	#_Setup6,routine(a0)
		move.l	#BossGreyBall_MoveJump_Floor,obBGB_Jump(a0)
		bclr	#4,$38(a0)

BossGreyBall_MoveJump_Wait:
		rts
; ---------------------------------------------------------------------------

BossGreyBall_MoveJump_Floor:
		tst.w	y_vel(a0)
		bmi.s	BossGreyBall_MoveJump_Wait
		jsr	(ObjCheckFloorDist).l
		tst.w	d1
		bpl.s	BossGreyBall_MoveJump_Wait
		add.w	d1,y_pos(a0)
		move.l	#BossGreyBall_MoveJump_CheckBounced,obBGB_Jump(a0)

BossGreyBall_MoveJump_CheckBounced:
		move.w	y_vel(a0),d0
		bmi.w	BossGreyBall_MoveJump_Wait
		cmpi.w	#$180,d0
		blo.s		BossGreyBall_MoveJump_JumpWait
		asr.w	d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		move.l	#BossGreyBall_MoveJump_Floor,obBGB_Jump(a0)
		bra.w	BossGreyBall_MoveSpikeBall_Hand_Shaking
; ---------------------------------------------------------------------------

BossGreyBall_MoveJump_JumpWait:
		move.b	#_Setup7,routine(a0)
		move.l	#BossGreyBall_MoveJump_StopVelocity,obBGB_Jump(a0)
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossGreyBall_MoveJump_StopVelocity:
		move.w	x_vel(a0),d0
		beq.s	BossGreyBall_MoveJump_Return
		cmpi.w	#-1,d0
		beq.s	BossGreyBall_MoveJump_Return
		asr.w	d0
		move.w	d0,x_vel(a0)
		move.w	#$F,$2E(a0)
		rts
; ---------------------------------------------------------------------------

BossGreyBall_MoveJump_Return:
		moveq	#$5F,d0
		btst	#6,status(a0)
		beq.s	+
		moveq	#$2F,d0
+		move.w	d0,$2E(a0)
		move.l	#BossGreyBall_MoveJump_Start,obBGB_Jump(a0)
		clr.w	x_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossGreyBall_MoveJump_Start:
		move.l	#BossGreyBall_MoveJump_Attack,obBGB_Jump(a0)
		jsr	(Find_SonicTails).w
		move.w	#$200,x_vel(a0)
		tst.w	d0
		bne.s	+
		neg.w	x_vel(a0)
+		move.w	#-$700,y_vel(a0)
		bset	#4,$38(a0)
		sfx	sfx_Jump2,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_BossGreyBall_SpikeBall_Shot(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Интро (третья фаза)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGreyBall_ThirdPhase_Intro:
		move.b	#_SetupA,routine(a0)
		move.l	#DEZ2_Resize_FloorExplosion,(Level_data_addr_RAM.Resize).w
		move.w	#1*60,(Demo_timer).w
		move.b	#$4F,(Negative_flash_timer).w
		move.w	#$4F,(Screen_shaking_flag).w
		move.w	#$2F,$2E(a0)
		move.l	#BossGreyBall_ThirdPhase_Intro_SetFall,obBGB_Jump(a0)
		clr.l	x_vel(a0)
		bclr	#4,$38(a0)
		bclr	#6,$38(a0)
		st	(NoPause_flag).w
		clr.b	(vBGB_FlickerTimer).w
		lea	(Player_1).w,a1
		move.b	#id_SonicHurt,routine(a1)	; Hit animation
		bset	#Status_Facing,status(a1)
		bclr	#Status_OnObj,status(a1)
		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
		bset	#Status_InAir,status(a1)
		move.w	#-$300,x_vel(a1)			; Set speed of player
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
		addi.w	#$100,d0
		move.w	d0,y_pos(a1)
+		move.l	a0,-(sp)
		lea	(DEZ2_Layout_FloorExplosion).l,a0
		jsr	(Load_Level2).w
		movea.l	(sp)+,a0
		lea	ChildObjDat_DEZFallingExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_DEZBlock(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossGreyBall_ThirdPhase_Intro_SetFall:
		move.b	#_SetupB,routine(a0)
		move.l	#BossGreyBall_ThirdPhase_Intro_CheckFall,obBGB_Jump(a0)

BossGreyBall_ThirdPhase_Intro_CheckFall:
		tst.b	render_flags(a0)
		bmi.s	BossGreyBall_ThirdPhase_Intro_CheckFall_Return
		move.b	#_SetupA,routine(a0)
		move.w	#$9F,$2E(a0)
		move.l	#BossGreyBall_ThirdPhase_Intro_CheckCamera,obBGB_Jump(a0)
		clr.l	x_vel(a0)
		bset	#5,(v_Breathing_bubbles+$38).w
		move.w	(Camera_X_pos).w,d0
		addi.w	#$100,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#$180,d0
		move.w	d0,y_pos(a0)

BossGreyBall_ThirdPhase_Intro_CheckFall_Return:
		rts
; ---------------------------------------------------------------------------

BossGreyBall_ThirdPhase_Intro_CheckCamera:
		cmpi.w	#$840,(Camera_Y_pos).w
		bne.s	BossGreyBall_ThirdPhase_Intro_CheckPosition_Return
		move.l	#BossGreyBall_ThirdPhase_Intro_CheckRings,obBGB_Jump(a0)
		lea	ChildObjDat_RestorePlayerRings(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossGreyBall_ThirdPhase_Intro_CheckRings:
		tst.b	(vBGB_RingCount).w
		bne.s	BossGreyBall_ThirdPhase_Intro_CheckPosition_Return
		clr.b	(Update_HUD_timer).w	; Stop
		move.b	#_SetupC,routine(a0)
		move.l	#BossGreyBall_ThirdPhase_Intro_CheckPosition,obBGB_Jump(a0)

BossGreyBall_ThirdPhase_Intro_CheckPosition:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$A0,d0
		cmp.w	y_pos(a0),d0
		blo.s		BossGreyBall_ThirdPhase_Intro_CheckPosition_Return
		cmpi.b	#1,(Intro_flag).w
		bne.s	BossGreyBall_ThirdPhase_Intro_SkipIntro
		addq.b	#1,(Intro_flag).w
		move.l	#BossGreyBall_ThirdPhase_Intro_CheckPosition_Return,obBGB_Jump(a0)
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossGreyBall_ThirdPhase_Intro_CheckPosition_Return
		move.b	#_GreyBallThirdPhase,routine(a1)
		move.l	#DialogGreyBallThirdPhase_Process_Index-4,$34(a1)
		move.b	#(DialogGreyBallThirdPhase_Process_Index_End-DialogGreyBallThirdPhase_Process_Index)/8,$39(a1)

BossGreyBall_ThirdPhase_Intro_CheckPosition_Return:
		rts
; ---------------------------------------------------------------------------

BossGreyBall_ThirdPhase_Intro_SkipIntro:
		move.l	#BossGreyBall_ThirdPhase_FallAttack,obBGB_Jump(a0)
		bset	#6,(v_Breathing_bubbles+$38).w
		clr.b	(NoPause_flag).w
		move.b	#1,(Update_HUD_timer).w
		rts
; ---------------------------------------------------------------------------
; Босс атакует в воздухе (третья фаза)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGreyBall_ThirdPhase_FallAttack:
		move.w	#$17,$2E(a0)
		move.l	#BossGreyBall_ThirdPhase_UnlockCamera,obBGB_Jump(a0)

BossGreyBall_ThirdPhase_FallAttack_Return:
		rts
; ---------------------------------------------------------------------------

BossGreyBall_ThirdPhase_UnlockCamera:
		bclr	#5,(v_Breathing_bubbles+$38).w
		move.l	#BossGreyBall_ThirdPhase_FallAttack_Start,obBGB_Jump(a0)
		rts
; ---------------------------------------------------------------------------

BossGreyBall_ThirdPhase_FallAttack_Start:
		move.l	#BossGreyBall_ThirdPhase_FallAttack_Return,obBGB_Jump(a0)
		lea	ChildObjDat_BossGreyBall_SpikeBall(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Проверка урона
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGreyBall_CheckTouch:
		tst.b	collision_flags(a0)
		bne.w	BossGreyBall_CheckTouch_Return
		move.b	collision_property(a0),d4
		beq.w	BossGreyBall_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.w	BossGreyBall_CheckTouch_Flash
		btst	#5,$38(a0)
		bne.s	BossGreyBall_CheckTouch_HitBoss
		tst.b	obBGB_Looking(a0)
		bne.w	BossGreyBall_CheckTouch_Bounce

BossGreyBall_CheckTouch_HitBoss:
		sfx	sfx_HitBoss,0,0,0
		move.b	#$60,$1C(a0)
		bset	#6,status(a0)
		btst	#7,(v_Breathing_bubbles+$38).w
		beq.s	BossGreyBall_CheckTouch_SecondPhase
		move.b	#$60,(vBGB_FlickerTimer).w

BossGreyBall_CheckTouch_SecondPhase:
		cmpi.b	#BossGreyBall_Hits/2,d4
		bne.s	BossGreyBall_CheckTouch_ThirdPhase
		bset	#4,$38(a0)
		bset	#5,$38(a0)
		bset	#6,$38(a0)
		bset	#5,status(a0)
		st	$1C(a0)
		clr.b	obBGB_DeadZone(a0)
		move.w	#-1,$2E(a0)
		move.l	#BossGreyBall_SecondPhase_Intro,obBGB_Jump(a0)

BossGreyBall_CheckTouch_ThirdPhase:
		cmpi.b	#BossGreyBall_Hits/4,d4
		bne.s	BossGreyBall_CheckTouch_Flash
		bset	#4,$38(a0)
		bset	#6,$38(a0)
		st	$1C(a0)
		move.w	#-1,$2E(a0)
		move.l	#BossGreyBall_ThirdPhase_Intro,obBGB_Jump(a0)

BossGreyBall_CheckTouch_Flash:
		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	+
		addi.w	#7*2,d0
+		bsr.w	BossGreyBall_PalFlash
		subq.b	#1,$1C(a0)
		bne.s	BossGreyBall_CheckTouch_Return
		bclr	#6,status(a0)

BossGreyBall_CheckTouch_Restore:
		move.b	collision_restore_flags(a0),collision_flags(a0)

BossGreyBall_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

BossGreyBall_CheckTouch_Bounce:
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
		move.w	d0,y_vel(a1)
		bra.s	BossGreyBall_CheckTouch_Restore
; ---------------------------------------------------------------------------

BossGreyBall_CheckTouch_WaitExplosive:
		move.l	#BossGreyBall_CheckTouch_WaitExplosive_Restore,address(a0)
		bset	#7,status(a0)
		clr.l	x_vel(a0)
		move.w	#-1,$2E(a0)
		move.b	#$4F,(Negative_flash_timer).w
		clr.b	(Update_HUD_timer).w	; Stop
		jmp	(BossDefeated_NoTime).w
; ---------------------------------------------------------------------------

BossGreyBall_CheckTouch_WaitExplosive_Restore:
		move.l	#BossGreyBall_CheckTouch_WaitPlayerExplosive,address(a0)
		bclr	#7,status(a0)
		move.w	#$1F,$2E(a0)
		lea	ChildObjDat_BossGreyBall_Face(pc),a2
		jsr	(CreateChild6_Simple).w
		st	(NoPause_flag).w
		bra.w	BossGreyBall_CheckTouch_TimeExplosive
; ---------------------------------------------------------------------------

BossGreyBall_CheckTouch_WaitPlayerExplosive:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge,0,0,0
+		jsr	(MoveSprite2).w
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_CheckTouch_TimeExplosive
		lea	(Player_1).w,a1
		move.b	#id_Hurt,anim(a1)
		lea	(v_Breathing_bubbles).w,a2
		bclr	#6,$38(a2)
		move.l	#SonicFlying_FallingControl,address(a2)
		moveq	#4,d1
		move.w	x_pos(a0),d0
		sub.w	(Camera_X_pos).w,d0
		subi.w	#$A0,d0
		blo.s		+
		moveq	#5,d1
+		bset	d1,$38(a2)
		move.l	#BossGreyBall_CheckTouch_CheckPlayerExplosive,address(a0)
		bra.s	BossGreyBall_CheckTouch_TimeExplosive
; ---------------------------------------------------------------------------

BossGreyBall_CheckTouch_CheckPlayerExplosive:
		moveq	#1,d1
		move.w	(Player_1+y_pos).w,d0
		sub.w	(Camera_Y_pos).w,d0
		subi.w	#$88,d0
		beq.s	BossGreyBall_CheckTouch_PlayerExplosive
		ble.s		+
		moveq	#-1,d1
+		add.w	d1,(v_Breathing_bubbles+$34).w
		bra.s	BossGreyBall_CheckTouch_TimeExplosive
; ---------------------------------------------------------------------------

BossGreyBall_CheckTouch_PlayerExplosive:
		move.l	#BossGreyBall_CheckTouch_TimeExplosive,address(a0)
		jsr	(Find_SonicTails).w
		bclr	#Status_Facing,status(a1)
		tst.w	d0
		beq.s	+
		bset	#Status_Facing,status(a1)
+		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossGreyBall_CheckTouch_TimeExplosive
		move.b	#_GreyBallEnd,routine(a1)
		move.l	#DialogGreyBallEnd_Process_Index-4,$34(a1)
		move.b	#(DialogGreyBallEnd_Process_Index_End-DialogGreyBallEnd_Process_Index)/8,$39(a1)

BossGreyBall_CheckTouch_TimeExplosive:
		bsr.w	BossGreyBall_CreateFire
		bra.s	BossGreyBall_CheckTouch_TimeExplosive_OnlyFlash
; ---------------------------------------------------------------------------

BossGreyBall_CheckTouch_TimeExplosive_Flash:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	BossGreyBall_CheckTouch_TimeExplosive_OnlyFlash
		sfx	sfx_BreakBridge,0,0,0

BossGreyBall_CheckTouch_TimeExplosive_OnlyFlash:
		moveq	#0,d0
		btst	#0,(Level_frame_counter+1).w
		bne.s	+
		addi.w	#7*2,d0
+		bsr.w	BossGreyBall_Defeated_PalFlash

BossGreyBall_CheckTouch_TimeExplosive_Chase:
		jsr	(Find_SonicTails).w
		subi.w	#3,x_pos(a0)
		tst.w	d0
		bne.s	+
		addi.w	#6,x_pos(a0)
+		move.w	(Camera_X_pos).w,d0
		addi.w	#$40,d0
		cmp.w	x_pos(a0),d0
		blt.s		+
		move.w	d0,x_pos(a0)
		clr.w	2+x_pos(a0)
+		addi.w	#$C0,d0
		cmp.w	x_pos(a0),d0
		bgt.s	+
		move.w	d0,x_pos(a0)
		clr.w	2+x_pos(a0)
+		lea	(Player_1).w,a1
		move.w	#$100,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectYOnly).w
		jsr	(MoveSprite2).w

BossGreyBall_CheckTouch_TimeExplosive_Draw:
		move.b	(V_int_run_count+3).w,d0
		andi.b	#1,d0
		move.b	d0,mapping_frame(a0)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

BossGreyBall_CheckTouch_SuperExplosive:
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_CheckTouch_TimeExplosive_Flash
		move.w	#$4F,$2E(a0)
		move.l	#BossGreyBall_CheckTouch_SuperExplosive_Fall,address(a0)

BossGreyBall_CheckTouch_SuperExplosive_Fall:
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_CheckTouch_TimeExplosive_Flash
		st	(Screen_shaking_flag).w
		move.b	#$7F,(Negative_flash_timer).w
		move.w	#$7F,$2E(a0)
		bset	#7,status(a0)
		move.l	#BossGreyBall_CheckTouch_SuperExplosive_End,address(a0)
		lea	ChildObjDat_BossGreyBall_FlickerMove(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossGreyBall_CheckTouch_SuperExplosive_End:
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
		bpl.s	BossGreyBall_CheckTouch_SuperExplosive_Return
		lea	(v_Breathing_bubbles).w,a2
		moveq	#4,d1
		move.w	x_pos(a0),d0
		sub.w	(Camera_X_pos).w,d0
		subi.w	#$A0,d0
		blo.s		+
		moveq	#5,d1
+		bclr	d1,$38(a2)
		lea	(Player_1).w,a1
		jsr	(Stop_Object).w
		st	(Ctrl_1_locked).w
		andi.b	#-$72,status_secondary(a1)
		clr.b	(Screen_shaking_flag).w
		clr.b	(Boss_flag).w
		move.l	#DEZ2_Resize_CheckSonicFall,(Level_data_addr_RAM.Resize).w
		addq.b	#2,(Background_event_routine).w
		jmp	(Go_Delete_Sprite_3).w
; ---------------------------------------------------------------------------

BossGreyBall_CheckTouch_SuperExplosive_Return:
		rts
; ---------------------------------------------------------------------------
; Клон (Интро)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_IntroClone:
		lea	ObjDat3_BossGreyBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#8,objoff_41(a0)
		move.b	#64,objoff_3C(a0)
		move.b	#128,objoff_3A(a0)
		move.l	#BossGreyBall_IntroClone_Frame2,address(a0)
		tst.b	subtype(a0)
		beq.s	BossGreyBall_IntroClone_Frame2
		neg.b	objoff_3C(a0)
		move.l	#BossGreyBall_IntroClone_Frame1,address(a0)

BossGreyBall_IntroClone_Frame1:
		btst	#0,(Level_frame_counter+1).w
		beq.s	BossGreyBall_IntroClone_CheckCircular

BossGreyBall_IntroClone_NoDraw:
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

BossGreyBall_IntroClone_Frame2:
		btst	#0,(Level_frame_counter+1).w
		beq.s	BossGreyBall_IntroClone_NoDraw

BossGreyBall_IntroClone_CheckCircular:
		subq.b	#2,objoff_3A(a0)
		bmi.s	BossGreyBall_IntroClone_Remove
		move.b	objoff_41(a0),d0
		add.b	d0,objoff_3C(a0)
		jsr	(MoveSprite_Circular).w

BossGreyBall_IntroClone_Draw:
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

BossGreyBall_IntroClone_Remove:
		bset	#7,status(a0)
		move.l	#Go_Delete_Sprite,address(a0)
		tst.b	subtype(a0)
		bne.s	+
		movea.w	parent3(a0),a1
		move.l	#BossGreyBall_Intro_MoveSwing,obBGB_Jump(a1)
		clr.b	obBGB_Draw(a1)
+		bra.s	BossGreyBall_IntroClone_Draw
; ---------------------------------------------------------------------------
; Указатель
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_Designator:
		lea	ObjDat3_BossGreyBall_Designator(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		tst.b	(Reverse_gravity_flag).w
		beq.s	BossGreyBall_Designator_NoGravity
		neg.b	child_dy(a0)
		bset	#1,render_flags(a0)

BossGreyBall_Designator_NoGravity:
		move.b	#8,$40(a0)
		move.l	#BossGreyBall_Designator_Frame2,address(a0)
		tst.b	subtype(a0)
		beq.s	BossGreyBall_Designator_Frame2
		neg.b	$40(a0)
		move.l	#BossGreyBall_Designator_Frame1,address(a0)

BossGreyBall_Designator_Frame1:
		btst	#0,(Level_frame_counter+1).w
		beq.s	BossGreyBall_Designator_Draw
		bra.s	BossGreyBall_Designator_CheckParent
; ---------------------------------------------------------------------------

BossGreyBall_Designator_Frame2:
		btst	#0,(Level_frame_counter+1).w
		beq.s	BossGreyBall_Designator_CheckParent

BossGreyBall_Designator_Draw:
		jsr	(Refresh_ChildPosition).w
		move.b	$40(a0),d0
		add.b	d0,child_dx(a0)
		beq.s	BossGreyBall_Designator_Remove
		bsr.s	BossGreyBall_Designator_Siren
		movea.w	parent3(a0),a1
		btst	#4,$38(a1)
		bne.s	BossGreyBall_Designator_Delete
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

BossGreyBall_Designator_Remove:
		bset	#7,status(a0)
		move.l	#Go_Delete_Sprite,address(a0)
		tst.b	subtype(a0)
		beq.s	BossGreyBall_Designator_CheckParent
		bclr	#7,status(a0)
		move.l	#Go_Delete_Sprite,obBGB_Jump(a0)
		move.l	#BossGreyBall_Designator_Main,address(a0)

BossGreyBall_Designator_Main:
		jsr	(Refresh_ChildPosition).w
		jsr	(Obj_Wait).w
		bsr.s	BossGreyBall_Designator_Siren
		movea.w	parent3(a0),a1
		btst	#4,$38(a1)
		bne.s	BossGreyBall_Designator_Delete
		btst	#1,(Level_frame_counter+1).w
		beq.s	BossGreyBall_Designator_CheckParent
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

BossGreyBall_Designator_CheckParent:
		bsr.s	BossGreyBall_Designator_Siren
		movea.w	parent3(a0),a1
		btst	#4,$38(a1)
		bne.s	BossGreyBall_Designator_Delete
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

BossGreyBall_Designator_Siren:
		move.b	(V_int_run_count+3).w,d0
		andi.b	#$F,d0
		bne.s	+
		sfx	sfx_Siren,0,0,0
+		rts
; ---------------------------------------------------------------------------

BossGreyBall_Designator_Delete:
		tst.b	subtype(a0)
		beq.s	+
		bclr	#4,$38(a1)
+		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------
; Глаза
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_Face:
		lea	ObjDat3_BossGreyBall_Face(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#BossGreyBall_Face_Main,address(a0)

BossGreyBall_Face_Main:
		movea.w	parent3(a0),a1
		move.w	y_pos(a1),y_pos(a0)
		move.w	(Player_1+x_pos).w,d0
		move.w	x_pos(a1),d1
		sub.w	d1,d0
		smi	d2
		bpl.s	+
		neg.w	d0
+		cmpi.w	#8,d0
		bls.s		+
		moveq	#8,d0
+		tst.b	d2
		beq.s	+
		neg.w	d0
+		add.w	d0,d1
		move.w	d1,x_pos(a0)
		jsr	(Find_SonicTails).w
		movea.w	parent3(a0),a1
		moveq	#2,d0
		tst.w	d1
		sne	obBGB_Looking(a1)
		bne.s	+
		addq.b	#1,d0
+		move.b	d0,mapping_frame(a0)
		tst.b	obBGB_Draw(a1)
		bne.w	BossGreyBall_IntroClone_NoDraw
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------
; Взрывающийся шипастый шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_SpikeBall_Explosion:
		lea	ObjDat3_BossGreyBall_SpikeBall(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		jsr	(Find_SonicTails).w
		move.b	#1,objoff_41(a0)
		move.b	#64,objoff_3C(a0)
		tst.w	d0
		bne.s	+
		neg.b	objoff_3C(a0)
		neg.b	objoff_41(a0)
+		move.b	#44/2,y_radius(a0)
		move.l	#BossGreyBall_SpikeBall_Explosion_Radius,address(a0)

BossGreyBall_SpikeBall_Explosion_Radius:
		jsr	(MoveSprite_Circular).w
		addq.b	#1,objoff_3A(a0)
		cmpi.b	#48,objoff_3A(a0)
		bne.w	BossGreyBall_SpikeBall_Explosion_Draw
		sfx	sfx_SpikeBall2,0,0,0
		move.w	#$100,priority(a0)

BossGreyBall_SpikeBall_Explosion_Velocity:
		move.w	#$180,x_vel(a0)
		tst.b	objoff_41(a0)
		bpl.s	+
		neg.w	x_vel(a0)
+		move.w	#$F,$2E(a0)
		move.l	#BossGreyBall_SpikeBall_Explosion_Wait,address(a0)

BossGreyBall_SpikeBall_Explosion_Wait:
		move.b	objoff_41(a0),d0
		add.b	d0,objoff_3C(a0)
		jsr	(MoveSprite_Circular).w
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_SpikeBall_Explosion_Draw
		sfx	sfx_Fire2,0,0,0
		move.l	#BossGreyBall_SpikeBall_Explosion_Fall,address(a0)

BossGreyBall_SpikeBall_Explosion_Fall:
		moveq	#5,d0
		btst	#0,(Level_frame_counter+1).w
		bne.s	+
		moveq	#$10,d0
+		move.b	d0,mapping_frame(a0)
		btst	#1,(Level_frame_counter+1).w
		beq.s	+
		lea	ChildObjDat_BossGreyBall_SpikeBall_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
+		jsr	(MoveSprite).w
		tst.w	y_vel(a0)
		bmi.s	BossGreyBall_SpikeBall_Explosion_Draw
		jsr	(ObjCheckFloorDist).l
		tst.w	d1
		bpl.s	BossGreyBall_SpikeBall_Explosion_Draw
		add.w	d1,y_pos(a0)
		move.l	#BossGreyBall_SpikeBall_CheckBounced,address(a0)

BossGreyBall_SpikeBall_CheckBounced:
		jsr	(MoveSprite).w
		move.w	y_vel(a0),d0
		bmi.s	BossGreyBall_SpikeBall_Explosion_Draw
		cmpi.w	#$180,d0
		blo.s		BossGreyBall_SpikeBall_Remove
		asr.w	d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jsr	(CreateChild6_Simple).w
		move.l	#BossGreyBall_SpikeBall_Explosion_Fall,address(a0)

BossGreyBall_SpikeBall_Explosion_Draw:
		tst.b	(vBGB_FlickerTimer).w
		bne.w	BossGreyBall_SpikeBall_FlickerDraw
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_Remove:
		move.b	#5,mapping_frame(a0)

BossGreyBall_SpikeBall_Remove2:
		sfx	sfx_BreakBridge,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		bset	#7,status(a0)
		move.l	#Go_Delete_Sprite,address(a0)
		lea	ChildObjDat_DEZRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_BossGreyBall_Splinter(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Куски шипастого шара
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_Splinter:
		lea	ObjDat3_BossGreyBall_SpikeBall(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#BossGreyBall_Splinter_Main,address(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.b	d0,d1
		lsr.b	#1,d0
		addq.b	#6,d0
		move.b	d0,mapping_frame(a0)
		addq.b	#1,d1
		lsl.b	#5,d1
		move.b	d1,d0
		jsr	(GetSineCosine).w
		move.w	#$C00,d2
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,x_vel(a0)
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,y_vel(a0)

BossGreyBall_Splinter_Main:
		jsr	(MoveSprite2).w
		btst	#1,subtype(a0)
		bne.s	BossGreyBall_Splinter_Check
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossGreyBall_Splinter_NoDraw

BossGreyBall_Splinter_Draw:
		jmp	(Sprite_CheckDeleteXY).w
; ---------------------------------------------------------------------------

BossGreyBall_Splinter_Check:
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossGreyBall_Splinter_Draw

BossGreyBall_Splinter_NoDraw:
		jmp	(Sprite_CheckDeleteXY_NoDraw).w
; ---------------------------------------------------------------------------
; Искры
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_Spark:
		lea	ObjDat3_BossGreyBall_Spark(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	d0,d1
		addq.w	#7,d0
		move.w	d0,$2E(a0)
		movea.w	parent3(a0),a1
		move.w	x_vel(a1),d0
		asl.w	#2,d0
		asl.w	#6,d1
		add.w	d1,d0
		neg.w	d0
		move.w	(HScroll_Shift).w,d1
		neg.w	d1
		add.w	d1,d0
		move.w	d0,x_vel(a0)
		jsr	(Random_Number).w
		andi.w	#$3FF,d0
		addi.w	#$100,d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		move.l	#Go_Delete_Sprite,obBGB_Jump(a0)
		move.l	#BossGreyBall_Spark_Draw,address(a0)

BossGreyBall_Spark_Draw:
		jsr	(MoveSprite2).w
		jsr	(Obj_Wait).w
		jmp	(Sprite_CheckDeleteXY).w
; ---------------------------------------------------------------------------
; Атакующий шипастый шар (рука) (первая и третья фаза)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_SpikeBall:
		lea	ObjDat3_BossGreyBall_SpikeBall(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		moveq	#3,d0
		btst	#7,(v_Breathing_bubbles+$38).w
		beq.s	+
		moveq	#2,d0
+		move.b	d0,obBGB_Count(a0)
		lea	(Player_1).w,a2
		movea.w	parent3(a0),a1
		jsr	(CalcObjAngle).w
		move.b	d0,$3C(a0)
		jsr	(MoveSprite_Circular).w
		move.b	#44/2,y_radius(a0)
		move.l	#BossGreyBall_SpikeBall_Radius,address(a0)

BossGreyBall_SpikeBall_Radius:
		jsr	(MoveSprite_Circular).w
		addq.b	#2,objoff_3A(a0)
		cmpi.b	#48,objoff_3A(a0)
		bne.w	BossGreyBall_SpikeBall_Move
		move.w	#$100,priority(a0)

BossGreyBall_SpikeBall_AimingStart:
		sfx	sfx_LaserStart,0,0,0
		move.w	#$AF,$2E(a0)
		btst	#7,(v_Breathing_bubbles+$38).w
		bne.s	BossGreyBall_SpikeBall_AimingStart_Skip
		move.w	#$9F,$2E(a0)

BossGreyBall_SpikeBall_AimingStart_Skip:
		move.l	#BossGreyBall_SpikeBall_Aiming,address(a0)

BossGreyBall_SpikeBall_Aiming:
		moveq	#5,d0
		btst	#0,(Level_frame_counter+1).w
		bne.s	+
		moveq	#$10,d0
+		move.b	d0,mapping_frame(a0)
		lea	(Player_1).w,a2
		movea.w	parent3(a0),a1
		jsr	(CalcObjAngle).w
		bsr.w	BossGreyBall_SpikeBall_CalcAngle
		jsr	(MoveSprite_Circular).w
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_SpikeBall_Move
		move.b	#5,mapping_frame(a0)
		lea	(Player_1).w,a1
		move.w	x_pos(a1),$30(a0)
		move.w	y_pos(a1),$32(a0)
		movea.w	parent3(a0),a2
		jsr	(CalcObjAngle).w
		bsr.w	BossGreyBall_SpikeBall_CalcAngle
		move.w	#$F,$2E(a0)
		move.l	#BossGreyBall_SpikeBall_AttackSonic_Wait,address(a0)

BossGreyBall_SpikeBall_AttackSonic_Wait:
		jsr	(MoveSprite_Circular).w
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_SpikeBall_Move
		sfx	sfx_SpikeAttack,0,0,0
		move.l	#BossGreyBall_SpikeBall_AttackSonic,address(a0)
		lea	ChildObjDat_BossGreyBall_SpikeBall_Chain(pc),a2
		jsr	(CreateChild8_TreeListRepeated).w

BossGreyBall_SpikeBall_AttackSonic:
		btst	#7,(v_Breathing_bubbles+$38).w
		bne.s	+
		bsr.s	BossGreyBall_SpikeBall_CheckFloor
+		move.w	$30(a0),d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.l	#BossGreyBall_SpikeBall_AttackReturn,address(a0)
		cmpi.b	#id_SonicHurt,(Player_1+routine).w
		bhs.s	+
		tst.w	$2E(a0)
		bmi.s	+
		movea.w	parent3(a0),a1
		btst	#6,status(a1)
		bne.s	+
		move.l	#BossGreyBall_SpikeBall_AttackCheck,address(a0)
+		asl.w	#5,d0
		move.w	d0,x_vel(a0)
		move.w	$32(a0),d0
		sub.w	y_pos(a0),d0
		asl.w	#5,d0
		move.w	d0,y_vel(a0)
		bra.w	BossGreyBall_SpikeBall_Move
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_CalcAngle:
		andi.b	#$FE,d0
		moveq	#2,d1
		cmp.b	$3C(a0),d0
		beq.s	BossGreyBall_SpikeBall_CalcAngle_Return
		bpl.s	+
		neg.b	d1
+		add.b	d1,$3C(a0)
		andi.b	#$FE,$3C(a0)

BossGreyBall_SpikeBall_CalcAngle_Return:
		rts
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_CheckFloor:
		tst.w	y_vel(a0)
		bmi.s	BossGreyBall_SpikeBall_CalcAngle_Return
		btst	#2,(Level_frame_counter+1).w
		bne.s	BossGreyBall_SpikeBall_CalcAngle_Return
		jsr	(ObjCheckFloorDist).l
		tst.w	d1
		bpl.s	BossGreyBall_SpikeBall_CalcAngle_Return
		add.w	d1,y_pos(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$7F,$2E(a0)
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_AttackCheck:
		move.w	a0,-(sp)
		movea.w	parent3(a0),a0
		lea	ChildObjDat_BossGreyBall_Designator(pc),a2
		jsr	(CreateChild1_Normal).w
		bne.s	+
		move.w	#$7F,$2E(a1)
+		movea.w	(sp)+,a0
		clr.l	x_vel(a0)
		move.l	#BossGreyBall_SpikeBall_AttackCheck_Wait,address(a0)

BossGreyBall_SpikeBall_AttackCheck_Wait:
		movea.w	parent3(a0),a1
		btst	#6,status(a1)
		bne.s	BossGreyBall_SpikeBall_AttackCheck_Wait_SetTime
		cmpi.b	#id_SonicHurt,(Player_1+routine).w
		bhs.s	BossGreyBall_SpikeBall_AttackCheck_Wait_RemoveDesignator
		moveq	#5,d0
		btst	#0,(Level_frame_counter+1).w
		bne.s	+
		moveq	#$10,d0
+		move.b	d0,mapping_frame(a0)
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_SpikeBall_Draw
		bra.s	BossGreyBall_SpikeBall_AttackCheck_Wait_Return
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_AttackCheck_Wait_SetTime:
		move.b	#$40,(vBGB_FlickerTimer).w

BossGreyBall_SpikeBall_AttackCheck_Wait_RemoveDesignator:
		bset	#4,$38(a1)

BossGreyBall_SpikeBall_AttackCheck_Wait_Return:
		move.b	#5,mapping_frame(a0)
		move.l	#BossGreyBall_SpikeBall_AttackReturn,address(a0)

BossGreyBall_SpikeBall_AttackReturn:
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
		move.w	#48,d1
		cmp.w	d1,d2
		bhs.w	BossGreyBall_SpikeBall_Move
		cmp.w	d1,d3
		bhs.w	BossGreyBall_SpikeBall_Move
		clr.l	x_vel(a0)
		move.b	#48,objoff_3A(a0)
		movea.w	$44(a0),a1
		bset	#7,status(a1)
		move.l	#Go_Delete_Sprite,address(a1)
		move.l	#BossGreyBall_SpikeBall_AimingStart,address(a0)
		sfx	sfx_Attachment2,0,0,0
		subq.b	#1,obBGB_Count(a0)
		bne.s	BossGreyBall_SpikeBall_Move
		move.l	#BossGreyBall_SpikeBall_Explosion_Velocity,address(a0)
		movea.w	parent3(a0),a1
		btst	#5,status(a1)
		bne.s	+
		move.l	#BossGreyBall_MoveSpikeBall_Hand_ReturnPosition,obBGB_Jump(a1)
+		btst	#7,status(a1)
		bne.s	+
		btst	#7,(v_Breathing_bubbles+$38).w
		beq.s	+
		move.w	#$12F,$2E(a1)
		move.l	#BossGreyBall_SpikeBall_Shot_Warning,address(a0)
		move.l	#BossGreyBall_ThirdPhase_FallAttack_Start,obBGB_Jump(a1)
+		lea	(Player_1).w,a2
		movea.w	parent3(a0),a1
		jsr	(CalcObjAngle).w
		bsr.w	BossGreyBall_SpikeBall_CalcAngle
		jsr	(MoveSprite_Circular).w
		jsr	(Find_SonicTails).w
		move.b	#1,objoff_41(a0)
		tst.w	d0
		bne.s	BossGreyBall_SpikeBall_Move
		neg.b	objoff_41(a0)

BossGreyBall_SpikeBall_Move:
		btst	#7,(v_Breathing_bubbles+$38).w
		beq.s	+
		bsr.w	BossGreyBall_CreateFire_SpikeBall
+		jsr	(MoveSprite2).w

BossGreyBall_SpikeBall_Draw:
		movea.w	parent3(a0),a1
		btst	#6,$38(a1)
		bne.w	BossGreyBall_SpikeBall_Remove2
		tst.b	(vBGB_FlickerTimer).w
		bne.s	BossGreyBall_SpikeBall_FlickerDraw
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_FlickerDraw:
		subq.b	#1,(vBGB_FlickerTimer).w
		btst	#0,(Level_frame_counter+1).w
		bne.w	BossGreyBall_IntroClone_NoDraw
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------
; Атакующий шипастый шар (цепь)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_SpikeBall_Chain:
		lea	ObjDat3_BossGreyBall_SpikeBall_Chain(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#BossGreyBall_SpikeBall_Chain_Main,address(a0)
		lsr	subtype(a0)
		bne.s	BossGreyBall_SpikeBall_Chain_Main
		movea.w	parent3(a0),a1
		move.w	a0,$44(a1)

BossGreyBall_SpikeBall_Chain_Main:
		movea.w	$44(a0),a1				; Spike Ball
		movea.w	parent3(a1),a2			; Boss Ball
		move.w	x_pos(a1),d1
		sub.w	x_pos(a2),d1
		move.w	d1,d3
		move.w	y_pos(a1),d2
		sub.w	y_pos(a2),d2
		move.w	d2,d4
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		move.b	subtype(a0),d2
		ext.w	d2
		muls.w	d2,d3		; X
		muls.w	d2,d4		; Y
		swap	d0
		clr.w	d0
		swap	d1
		clr.w	d1
		swap	d3
		clr.w	d3
		swap	d4
		clr.w	d4
		asr.l	d1,d3			; X
		asr.l	d0,d4			; Y
		asr.l	#3,d3
		move.l	d3,d0
		asr.l	#2,d0
		add.l	d0,d3
		asr.l	#3,d4
		move.l	d4,d0
		asr.l	#2,d0
		add.l	d0,d4
		move.l	x_pos(a2),d0
		add.l	d3,d0
		move.l	d0,x_pos(a0)
		move.l	y_pos(a2),d0
		add.l	d4,d0
		move.l	d0,y_pos(a0)
		btst	#0,subtype(a0)
		bne.s	BossGreyBall_SpikeBall_Chain_Check
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossGreyBall_SpikeBall_Chain_NoDraw

BossGreyBall_SpikeBall_Chain_Draw:
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_Chain_Check:
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossGreyBall_SpikeBall_Chain_Draw

BossGreyBall_SpikeBall_Chain_NoDraw:
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------
; Отскакивающий шипастый шар
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_SpikeBall_Bounced:
		lea	ObjDat3_BossGreyBall_SpikeBall(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		jsr	(Find_SonicTails).w
		move.b	#1,objoff_41(a0)
		move.b	#64,objoff_3C(a0)
		tst.w	d0
		bne.s	+
		neg.b	objoff_3C(a0)
		neg.b	objoff_41(a0)
+		move.b	#44/2,y_radius(a0)
		move.l	#BossGreyBall_SpikeBall_Bounced_Radius,address(a0)

BossGreyBall_SpikeBall_Bounced_Radius:
		jsr	(MoveSprite_Circular).w
		addq.b	#1,objoff_3A(a0)
		cmpi.b	#48,objoff_3A(a0)
		bne.s	BossGreyBall_SpikeBall_Bounced_Setup
		sfx	sfx_SpikeBall2,0,0,0
		move.w	#$100,priority(a0)
		jsr	(Find_SonicTails).w
		move.w	#$200,x_vel(a0)
		tst.w	d0
		bne.s	+
		neg.w	x_vel(a0)
+		move.w	#$F,$2E(a0)
		move.l	#BossGreyBall_SpikeBall_Bounced_Wait,address(a0)

BossGreyBall_SpikeBall_Bounced_Wait:
		move.b	objoff_41(a0),d0
		add.b	d0,objoff_3C(a0)
		jsr	(MoveSprite_Circular).w
		subq.w	#1,$2E(a0)
		bpl.s	BossGreyBall_SpikeBall_Bounced_Setup
		move.l	#BossGreyBall_SpikeBall_Bounced_Jump,obBGB_Jump(a0)
		move.l	#BossGreyBall_SpikeBall_Bounced_Setup2,address(a0)
		clearRAM3 Pos_objtable_Start, Pos_objtable_End
		lea	ChildObjDat_BossGreyBall_SpikeBall_Bounced_Chain_Trail(pc),a2
		jsr	(CreateChild6_Simple).w

BossGreyBall_SpikeBall_Bounced_Setup2:
		jsr	(MoveSprite).w
		jsr	(ObjHitFloor_DoRoutine).w

BossGreyBall_SpikeBall_Bounced_Setup:
		bsr.w	Obj_ChasingBall_SendPos
		jmp	(Sprite_ChildCheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_Bounced_Jump:
		move.w	#-$400,y_vel(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; Тень отскакивающего шипастого шара
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_SpikeBall_Bounced_Chain_Trail:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.b	#4,d0
		addi.b	#$24,d0
		move.b	d0,$39(a0)
		lea	ObjDat3_BossGreyBall_SpikeBall_Chain(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#+,address(a0)
+		bsr.w	Obj_ChasingBall_CopyPos
		btst	#1,subtype(a0)
		bne.s	BossGreyBall_SpikeBall_Bounced_Chain_Trail_Check
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossGreyBall_SpikeBall_Bounced_Chain_Trail_CheckParent

BossGreyBall_SpikeBall_Bounced_Chain_Trail_Draw:
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_Bounced_Chain_Trail_Check:
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossGreyBall_SpikeBall_Bounced_Chain_Trail_Draw

BossGreyBall_SpikeBall_Bounced_Chain_Trail_CheckParent:
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------
; Выстреливающий шипастый шар (вторая и третья фаза)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_SpikeBall_Shot:
		lea	ObjDat3_BossGreyBall_SpikeBall(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		lea	(Player_1).w,a2
		movea.w	parent3(a0),a1
		jsr	(CalcObjAngle).w
		move.b	d0,$3C(a0)
		jsr	(MoveSprite_Circular).w
		move.b	#44/2,y_radius(a0)
		move.l	#BossGreyBall_SpikeBall_Shot_Radius,address(a0)

BossGreyBall_SpikeBall_Shot_Radius:
		bsr.w	BossGreyBall_CreateFire_SpikeBall
		lea	(Player_1).w,a2
		movea.w	parent3(a0),a1
		jsr	(CalcObjAngle).w
		bsr.w	BossGreyBall_SpikeBall_CalcAngle
		jsr	(MoveSprite_Circular).w
		addq.b	#1,objoff_3A(a0)
		cmpi.b	#48,objoff_3A(a0)
		bne.w	BossGreyBall_SpikeBall_Shot_Move
		sfx	sfx_SpikeBall2,0,0,0
		move.w	#$100,priority(a0)
		move.l	#BossGreyBall_SpikeBall_Shot_SubtractRadius,address(a0)

BossGreyBall_SpikeBall_Shot_SubtractRadius:
		bsr.w	BossGreyBall_CreateFire_SpikeBall
		lea	(Player_1).w,a2
		movea.w	parent3(a0),a1
		jsr	(CalcObjAngle).w
		bsr.w	BossGreyBall_SpikeBall_CalcAngle
		jsr	(MoveSprite_Circular).w
		btst	#1,(Level_frame_counter+1).w
		bne.w	BossGreyBall_SpikeBall_Shot_Move
		subq.b	#1,objoff_3A(a0)
		cmpi.b	#36,objoff_3A(a0)
		bne.w	BossGreyBall_SpikeBall_Shot_Move
		move.w	#$2F,$2E(a0)
		move.l	#BossGreyBall_SpikeBall_Shot_Warning,address(a0)

BossGreyBall_SpikeBall_Shot_Warning:
		bsr.w	BossGreyBall_CreateFire_SpikeBall
		lea	(Player_1).w,a2
		movea.w	parent3(a0),a1
		jsr	(CalcObjAngle).w
		bsr.w	BossGreyBall_SpikeBall_CalcAngle
		jsr	(MoveSprite_Circular).w
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_SpikeBall_Shot_Move
		sfx	sfx_LaserStart,0,0,0
		move.w	#$9F,$2E(a0)
		move.l	#BossGreyBall_SpikeBall_Shot_Wait,address(a0)

BossGreyBall_SpikeBall_Shot_Wait:
		moveq	#5,d0
		btst	#0,(Level_frame_counter+1).w
		bne.s	+
		moveq	#$10,d0
+		move.b	d0,mapping_frame(a0)
		bsr.w	BossGreyBall_CreateFire_SpikeBall
		lea	(Player_1).w,a2
		movea.w	parent3(a0),a1
		jsr	(CalcObjAngle).w
		bsr.w	BossGreyBall_SpikeBall_CalcAngle
		jsr	(MoveSprite_Circular).w
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_SpikeBall_Shot_Move
		clearRAM3 Pos_objtable_Start, Pos_objtable_End
		move.b	#5,mapping_frame(a0)
		move.w	#$F,$2E(a0)
		move.l	#BossGreyBall_SpikeBall_Shot_Wait2,address(a0)
		lea	(Player_1).w,a1
		move.w	x_pos(a1),d1
		move.w	y_pos(a1),d2
		sub.w	x_pos(a0),d1
		sub.w	y_pos(a0),d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		move.w	#$680,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)

BossGreyBall_SpikeBall_Shot_Wait2:
		bsr.w	BossGreyBall_CreateFire_SpikeBall
		jsr	(MoveSprite_Circular).w
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_SpikeBall_Shot_Draw
		sfx	sfx_Boom,0,0,0
		move.l	#BossGreyBall_SpikeBall_Shot_CheckFloor,address(a0)
		lea	ChildObjDat_BossGreyBall_SpikeBall_Shot_Chain_Trail(pc),a2
		jsr	(CreateChild6_Simple).w
		move.w	a0,-(sp)
		movea.w	parent3(a0),a0
		lea	ChildObjDat_BossGreyBall_Designator(pc),a2
		jsr	(CreateChild1_Normal).w
		bne.s	+
		move.w	#$7F,$2E(a1)
+		movea.w	(sp)+,a0

BossGreyBall_SpikeBall_Shot_CheckFloor:
		bsr.w	BossGreyBall_CreateFire_SpikeBall
		btst	#7,(v_Breathing_bubbles+$38).w
		bne.s	BossGreyBall_SpikeBall_Shot_Move
		tst.w	y_vel(a0)
		bmi.s	BossGreyBall_SpikeBall_Shot_Move
		btst	#2,(Level_frame_counter+1).w
		bne.s	BossGreyBall_SpikeBall_Shot_Move
		jsr	(ObjCheckFloorDist).l
		tst.w	d1
		bpl.s	BossGreyBall_SpikeBall_Shot_Move
		add.w	d1,y_pos(a0)
		neg.w	y_vel(a0)
		sfx	sfx_SpikeBall,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat_BossGreyBall_Spark(pc),a2
		jsr	(CreateChild6_Simple).w

BossGreyBall_SpikeBall_Shot_Move:
		jsr	(MoveSprite2).w

BossGreyBall_SpikeBall_Shot_Draw:
		bsr.w	Obj_ChasingBall_SendPos
		movea.w	parent3(a0),a1
		btst	#6,$38(a1)
		bne.w	BossGreyBall_SpikeBall_Remove2
		tst.b	(vBGB_FlickerTimer).w
		bne.s	BossGreyBall_SpikeBall_Shot_FlickerDraw
		jmp	(Sprite_ChildCheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_Shot_FlickerDraw:
		subq.b	#1,(vBGB_FlickerTimer).w
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossGreyBall_SpikeBall_Shot_FlickerNoDraw
		jmp	(Sprite_ChildCheckDeleteXY).w
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_Shot_FlickerNoDraw:
		jmp	(Sprite_ChildCheckDeleteXY_NoDraw).w
; ---------------------------------------------------------------------------
; Цепь выстреливающего шипастого шара
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_SpikeBall_Shot_Chain_Trail:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.b	#2,d0
		addi.b	#$14,d0
		move.b	d0,$39(a0)
		lea	ObjDat3_BossGreyBall_SpikeBall_Chain(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#+,address(a0)
+		bsr.w	Obj_ChasingBall_CopyPos
		btst	#1,subtype(a0)
		bne.s	BossGreyBall_SpikeBall_Shot_Chain_Trail_Check
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossGreyBall_SpikeBall_Shot_Chain_Trail_CheckParent

BossGreyBall_SpikeBall_Shot_Chain_Trail_Draw:
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

BossGreyBall_SpikeBall_Shot_Chain_Trail_Check:
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossGreyBall_SpikeBall_Shot_Chain_Trail_Draw

BossGreyBall_SpikeBall_Shot_Chain_Trail_CheckParent:
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------
; Дым из босс шара
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_Fire:
		moveq	#1-1,d6

-		jsr	(Create_New_Sprite3).w
		bne.w	+++
		move.l	#Obj_BossGreyBall_SpikeBall_Fire_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$8530,d3
		tst.b	(HUD_RAM.draw).w
		beq.s	+
		move.w	#$530,d3
+		move.w	d3,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	$3C(a0),priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		bsr.w	loc_83E90
		jsr	(Random_Number).w
		andi.w	#$FF,d0
		addi.w	#$200,d0
		movea.w	parent3(a0),a2
		tst.w	x_vel(a2)
		bmi.s	+
		neg.w	d0
+		move.w	d0,x_vel(a1)
		jsr	(Random_Number).w
		andi.w	#$FF,d0
		addi.w	#$200,d0
		neg.w	d0
		move.w	d0,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)
		dbf	d6,-
+		bra.w	Robotnik_IntroFullExplosion_Delete
; ---------------------------------------------------------------------------
; Дым из шипастого шара
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_SpikeBall_Fire:
		moveq	#1-1,d6

-		jsr	(Create_New_Sprite3).w
		bne.s	+++
		move.l	#Obj_BossGreyBall_SpikeBall_Fire_Anim,address(a1)
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
		jsr	(Random_Number).w
		andi.w	#$FF,d0
		addi.w	#$200,d0
		movea.w	parent3(a0),a2
		tst.b	objoff_41(a2)
		bmi.s	+
		neg.w	d0
+		move.w	d0,x_vel(a1)
		jsr	(Random_Number).w
		andi.w	#$FF,d0
		addi.w	#$200,d0
		neg.w	d0
		move.w	d0,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)
		dbf	d6,-
+		bra.w	Robotnik_IntroFullExplosion_Delete
; ---------------------------------------------------------------------------

Obj_BossGreyBall_SpikeBall_Fire_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#3,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.w	Robotnik_IntroFullExplosion_Delete
+		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------
; Взрыв по радиусу
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_DEZRadiusExplosion:
		moveq	#0,d2
		moveq	#8-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	++
		move.l	#Obj_DEZRadiusExplosion_GetVelocity,address(a1)
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
		move.b	d2,angle(a1)
		move.b	#3,anim_frame_timer(a1)
		addi.w	#256/8,d2
		dbf	d1,-
+		bra.w	Robotnik_IntroFullExplosion_Delete
; ---------------------------------------------------------------------------

Obj_DEZRadiusExplosion_GetVelocity:
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	#$600,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		move.l	#Obj_DEZRadiusExplosion_Anim,address(a0)

Obj_DEZRadiusExplosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#1,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.w	Robotnik_IntroFullExplosion_Delete
+		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------
; Супер взрыв по радиусу
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_DEZRadiusSuperExplosion:
		moveq	#0,d2
		moveq	#6-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	++
		move.l	#Obj_DEZRadiusSuperExplosion_Anim,address(a1)
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
		move.w	x_pos(a0),$30(a1)
		move.w	y_pos(a0),$34(a1)
		move.b	#8,objoff_40(a1)
		move.b	d2,angle(a1)
		move.b	#$1F,anim_frame_timer(a1)
		addi.w	#256/6,d2
		dbf	d1,-
+		bra.w	Robotnik_IntroFullExplosion_Delete
; ---------------------------------------------------------------------------

Obj_DEZRadiusSuperExplosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#2,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.w	Robotnik_IntroFullExplosion_Delete
+		addq.b	#1,objoff_3A(a0)
		move.b	objoff_40(a0),d0
		add.b	d0,angle(a0)
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	objoff_3A(a0),d2
		move.w	d2,d3
		muls.w	d0,d2
		asl.l	#2,d2
		clr.w	d2
		muls.w	d1,d3
		asl.l	#2,d3
		clr.w	d3
		move.l	$30(a0),d0
		add.l	d2,d0
		move.l	d0,x_pos(a0)
		move.l	$34(a0),d1
		add.l	d3,d1
		move.l	d1,y_pos(a0)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------
; Падающий взрыв
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_DEZFallingExplosion:
		move.w	#$F,$2E(a0)
		move.l	#Obj_DEZFallingExplosion_Wait,address(a0)

Obj_DEZFallingExplosion_Start:
		moveq	#0,d2
		moveq	#16-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	Obj_DEZFallingExplosion_Wait
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

Obj_DEZFallingExplosion_Wait:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	Robotnik_IntroFullExplosion_Delete
		tst.b	render_flags(a1)
		bpl.w	Robotnik_IntroFullExplosion_Delete
		subq.w	#1,$2E(a0)
		bpl.w	BossGreyBall_Swing_Setup_Return
		move.w	#$F,$2E(a0)
		bra.w	Obj_DEZFallingExplosion_Start
; ---------------------------------------------------------------------------

Obj_DEZFallingExplosion_SetVelocity:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lea	(Obj_VelocityIndex).w,a1
		move.w	(a1,d0.w),x_vel(a0)
		jsr	(Random_Number).w
		andi.w	#$7FF,d0
		addi.w	#$100,d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		move.l	#Obj_DEZFallingExplosion_Anim,address(a0)

Obj_DEZFallingExplosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#3,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.w	Robotnik_IntroFullExplosion_Delete
+		jsr	(MoveSprite).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------
; Частицы босса
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_FlickerMove:
		lea	ObjDat3_BossGreyBall_Flicker(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#Obj_FlickerMove,address(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsr.b	#1,d0
		addi.b	#$C,d0
		move.b	d0,mapping_frame(a0)
		moveq	#0<<2,d0
		jsr	(Set_IndexedVelocity).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------
; Кольца для игрока
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_RestorePlayerRings_Load:
		moveq	#10,d6						; 10
		sub.w	(Ring_count).w,d6			; 10-8=2
		bls.s		RestorePlayerRings_Remove
		move.w	#256,d4
		divu.w	d6,d4						; 8/256
		move.b	d4,$40(a0)
		subq.w	#1,d6						; -1

-		jsr	(Create_New_Sprite).w
		bne.s	RestorePlayerRings_Remove
		move.l	#Obj_RestorePlayerRings,address(a1)
		move.b	objoff_3C(a0),objoff_3C(a1)
		move.b	$40(a0),d0
		add.b	d0,$3C(a0)
		addq.b	#1,(vBGB_RingCount).w
		dbf	d6,-
		st	subtype(a1)

RestorePlayerRings_Remove:
		bra.w	Robotnik_IntroFullExplosion_Delete
; ---------------------------------------------------------------------------
; Кольца для игрока (Объект)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_RestorePlayerRings:
		move.l	#Map_Ring,mappings(a0)
		move.w	#make_art_tile(ArtTile_Ring,3,1),art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$100,priority(a0)
		move.b	#$47,collision_flags(a0)
		moveq	#16/2,d0
		move.b	d0,width_pixels(a0)
		move.b	d0,height_pixels(a0)
		move.b	d0,y_radius(a0)
		move.b	d0,x_radius(a0)
		move.b	#100,objoff_3A(a0)
		move.w	#$4F,$2E(a0)
		move.l	#RestorePlayerRings_Circular_Wait,address(a0)

RestorePlayerRings_Circular_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	RestorePlayerRings_Circular
		move.l	#RestorePlayerRings_ReduceRadius,address(a0)

RestorePlayerRings_ReduceRadius:
		subi.w	#$80,objoff_3A(a0)
		cmpi.b	#20,objoff_3A(a0)
		bhi.s	RestorePlayerRings_Circular
		move.w	#$2F,$2E(a0)
		move.l	#RestorePlayerRings_Circular_Wait2,address(a0)
		tst.b	subtype(a0)
		beq.s	RestorePlayerRings_Circular_Wait2
		sfx	sfx_Squeak,0,0,0

RestorePlayerRings_Circular_Wait2:
		subq.w	#1,$2E(a0)
		bpl.s	RestorePlayerRings_Circular
		move.l	#RestorePlayerRings_ReduceRadius2,address(a0)

RestorePlayerRings_ReduceRadius2:
		subi.w	#$80,objoff_3A(a0)
		bpl.s	RestorePlayerRings_Circular
		move.l	#RestorePlayerRings_Circular,address(a0)

RestorePlayerRings_Circular:
		move.b	objoff_3C(a0),d0
		addq.b	#4,objoff_3C(a0)
		jsr	(GetSineCosine).w
		move.w	objoff_3A(a0),d2
		move.w	d2,d3
		muls.w	d0,d2
		asl.l	#2,d2
		clr.w	d2
		muls.w	d1,d3
		asl.l	#2,d3
		clr.w	d3
		move.l	(Player_1+x_pos).w,d0
		add.l	d2,d0
		move.l	d0,x_pos(a0)
		move.l	(Player_1+y_pos).w,d0
		add.l	d3,d0
		move.l	d0,y_pos(a0)
		tst.b routine(a0)
		beq.s	RestorePlayerRings_Draw
		move.l	#RestorePlayerRings_Collect,address(a0)

RestorePlayerRings_Draw:
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

RestorePlayerRings_Collect:
		clr.b	routine(a0)
		clr.b	collision_flags(a0)
		move.w	#$80,priority(a0)
		jsr	(GiveRing).w
		subq.b	#1,(vBGB_RingCount).w
		move.l	#RestorePlayerRings_RingSparkle,address(a0)

RestorePlayerRings_RingSparkle:
		tst.b routine(a0)
		bne.s	RestorePlayerRings_RingDelete
		lea	(Ani_RingSparkle).l,a1
		jsr	(Animate_Sprite).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

RestorePlayerRings_RingDelete:
		bra.w	Robotnik_IntroFullExplosion_Delete
; ---------------------------------------------------------------------------
; Астероиды
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreyBall_Asteroids_Load:
		move.b	(V_int_run_count+3).w,d0
		andi.w	#3,d0
		bne.w	BossGreyBall_Asteroids_Load_Return
		jsr	(Create_New_Sprite).w
		bne.w	BossGreyBall_Asteroids_Load_Return
		move.l	#BossGreyBall_Asteroids_Draw,address(a1)
		move.l	#Map_BossGreyBall_Asteroid,mappings(a1)
		move.w	#$A1F0,art_tile(a1)
		move.b	#4,render_flags(a1)
		moveq	#16/2,d0
		move.b	d0,width_pixels(a1)
		move.b	d0,height_pixels(a1)
		jsr	(Random_Number).w
		andi.w	#$1F8,d0
		add.w	(Camera_X_pos).w,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$F0,d0
		move.w	d0,y_pos(a1)

-		jsr	(Random_Number).w
		andi.w	#$7FF,d0
		beq.s	-
		addi.w	#$200,d0
		neg.w	d0
		move.w	d0,y_vel(a1)
		jsr	(Random_Number).w
		move.w	#$80,d1
		andi.w	#1,d0
		bne.s	+
		move.w	#$100,d1
+		move.w	d1,priority(a1)
		jsr	(Random_Number).w
		andi.b	#7,d0
		move.b	d0,mapping_frame(a1)

BossGreyBall_Asteroids_Load_Return:
		rts
; ---------------------------------------------------------------------------

BossGreyBall_Asteroids_Draw:
		jsr	(MoveSprite2).w
		jmp	(Sprite_CheckDeleteXY).w

; =============== S U B R O U T I N E =======================================

BossGreyBall_Swing_Setup:
		move.w	#$100,d0
		move.w	d0,$3E(a0)
		move.w	d0,y_vel(a0)
		move.w	#8,$40(a0)
		bclr	#0,$38(a0)

BossGreyBall_Swing_Setup_Return:
		rts
; ---------------------------------------------------------------------------

BossGreyBall_Swing_Setup2:
		move.w	#$100,d0
		move.w	d0,$3A(a0)
		move.w	d0,x_vel(a0)
		move.w	#8,$3C(a0)
		bclr	#3,$38(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		sub.w	x_pos(a0),d0
		bgt.s	+
		neg.w	x_vel(a0)
+		rts

; =============== S U B R O U T I N E =======================================

BossGreyBall_PalFlash:
		moveq	#0,d4
		move.b	collision_property(a0),d4
		add.b	d4,d4
		lea	BossGreyBall_PalCycle_Index(pc),a2
		adda.w	-2(a2,d4.w),a2
		lea	(a2,d0.w),a2
		lea	BossGreyBall_PalRAM(pc),a1
		jmp	(CopyWordData_7).w
; ---------------------------------------------------------------------------

BossGreyBall_PalRAM:
		dc.w Normal_palette_line_2+$1C
		dc.w Normal_palette_line_2+$1A
		dc.w Normal_palette_line_2+$18
		dc.w Normal_palette_line_2+$1E
		dc.w Normal_palette_line_2+$16
		dc.w Normal_palette_line_2+$14
		dc.w Normal_palette_line_2+$12

BossGreyBall_PalCycle_Index: offsetTable
		offsetTableEntry.w BossGreyBall_PalCycle8			; 1 (Third phase)
		offsetTableEntry.w BossGreyBall_PalCycle7			; 2 (Third phase)
		offsetTableEntry.w BossGreyBall_PalCycle6			; 3 (Second phase)
		offsetTableEntry.w BossGreyBall_PalCycle5			; 4 (Second phase)
		offsetTableEntry.w BossGreyBall_PalCycle4			; 5 (First phase)
		offsetTableEntry.w BossGreyBall_PalCycle3			; 6 (First phase)
		offsetTableEntry.w BossGreyBall_PalCycle2			; 7 (First phase)
		offsetTableEntry.w BossGreyBall_PalCycle				; 8 (First phase)

BossGreyBall_PalCycle:										; Normal palette
		dc.w $424, $644, $866, $A88, $CAA, $ECC, $222		; Normal
		dc.w $42, $64, $86, $A8, $CA, $EC, $22				; Flash
BossGreyBall_PalCycle2:									; 100 degrees palette
		dc.w $424, $644, $868, $A8A, $CAC, $ECC, $222		; Normal
		dc.w $42, $64, $86, $A8, $CA, $EC, $22				; Flash
BossGreyBall_PalCycle3:									; 200 degrees palette
		dc.w $424, $646, $868, $A8A, $CAC, $ECE, $222		; Normal
		dc.w $42, $64, $86, $A8, $CA, $EC, $22				; Flash
BossGreyBall_PalCycle4:									; 600 degrees palette
		dc.w $426, $646, $868, $A8A, $CAC, $ECE, $224		; Normal
		dc.w $42, $64, $86, $A8, $CA, $EC, $22				; Flash
BossGreyBall_PalCycle5:									; 800 degrees palette
		dc.w $428, $648, $86A, $A8C, $CAE, $EEE, $226		; Normal
		dc.w $42, $64, $86, $A8, $CA, $EC, $22				; Flash
BossGreyBall_PalCycle6:									; 900 degrees palette
		dc.w $42A, $64A, $86C, $A8E, $CCE, $CEE, $228		; Normal
		dc.w $42, $64, $86, $A8, $CA, $EC, $22				; Flash
BossGreyBall_PalCycle7:									; 1000 degrees palette
		dc.w $2E, $4E, $6E, $8E, $AE, $CE, $2E				; Normal
		dc.w $42, $64, $86, $A8, $CA, $EC, $22				; Flash
BossGreyBall_PalCycle8:									; 1250 degrees palette
		dc.w $4E, $6E, $8E, $AE, $CE, $EE, $4E				; Normal
		dc.w $42, $64, $86, $A8, $CA, $EC, $22				; Flash

; =============== S U B R O U T I N E =======================================

BossGreyBall_Defeated_PalFlash:
		lea	BossGreyBall_Defeated_PalRAM(pc),a1
		lea	BossGreyBall_Defeated_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_7).w
; ---------------------------------------------------------------------------

BossGreyBall_Defeated_PalRAM:
		dc.w Normal_palette_line_2+$1C
		dc.w Normal_palette_line_2+$1A
		dc.w Normal_palette_line_2+$18
		dc.w Normal_palette_line_2+$1E
		dc.w Normal_palette_line_2+$16
		dc.w Normal_palette_line_2+$14
		dc.w Normal_palette_line_2+$12
BossGreyBall_Defeated_PalCycle:
		dc.w $4E, $6E, $8E, $AE, $CE, $EE, $4E				; Normal
		dc.w $424, $644, $866, $A88, $CAA, $ECC, $222		; Flash

; =============== S U B R O U T I N E =======================================

ObjDat3_BossGreyBall:
		dc.l Map_BossGreyBall
		dc.w $A210
		dc.w $200
		dc.b 64/2
		dc.b 64/2
		dc.b 0
		dc.b $F
ObjDat3_BossGreyBall_SpikeBall:
		dc.w $280
		dc.b 48/2
		dc.b 48/2
		dc.b 5
		dc.b $81
ObjDat3_BossGreyBall_SpikeBall_Chain:
		dc.w $300
		dc.b 16/2
		dc.b 16/2
		dc.b 4
		dc.b 0
ObjDat3_BossGreyBall_Face:
		dc.w $180
		dc.b 48/2
		dc.b 16/2
		dc.b 2
		dc.b 0
ObjDat3_BossGreyBall_Designator:
		dc.w $80
		dc.b 32/2
		dc.b 32/2
		dc.b $B
		dc.b 0
ObjDat3_BossGreyBall_Spark:
		dc.w $80
		dc.b 16/2
		dc.b 16/2
		dc.b $A
		dc.b 0
ObjDat3_BossGreyBall_Flicker:
		dc.w 0
		dc.b 64/2
		dc.b 64/2
		dc.b $C
		dc.b 0
ChildObjDat_BossGreyBall_IntroClone:
		dc.w 2-1
		dc.l Obj_BossGreyBall_IntroClone
ChildObjDat_BossGreyBall_Face:
		dc.w 1-1
		dc.l Obj_BossGreyBall_Face
ChildObjDat_BossGreyBall_Designator:
		dc.w 2-1
		dc.l Obj_BossGreyBall_Designator
		dc.b -32, -50
		dc.l Obj_BossGreyBall_Designator
		dc.b 32, -50
ChildObjDat_BossGreyBall_SpikeBall_Explosion:
		dc.w 1-1
		dc.l Obj_BossGreyBall_SpikeBall_Explosion
ChildObjDat_BossGreyBall_SpikeBall:
		dc.w 1-1
		dc.l Obj_BossGreyBall_SpikeBall
ChildObjDat_BossGreyBall_SpikeBall_Chain:
		dc.w 7-1
		dc.l Obj_BossGreyBall_SpikeBall_Chain
ChildObjDat_BossGreyBall_Splinter:
		dc.w 4-1
		dc.l Obj_BossGreyBall_Splinter
ChildObjDat_BossGreyBall_SpikeBall_Fire:
		dc.w 1-1
		dc.l Obj_BossGreyBall_SpikeBall_Fire
ChildObjDat_BossGreyBall_SpikeBall_Bounced:
		dc.w 1-1
		dc.l Obj_BossGreyBall_SpikeBall_Bounced
ChildObjDat_BossGreyBall_SpikeBall_Bounced_Chain_Trail:
		dc.w 6-1
		dc.l Obj_BossGreyBall_SpikeBall_Bounced_Chain_Trail
ChildObjDat_BossGreyBall_SpikeBall_Shot:
		dc.w 1-1
		dc.l Obj_BossGreyBall_SpikeBall_Shot
ChildObjDat_BossGreyBall_SpikeBall_Shot_Chain_Trail:
		dc.w 8-1
		dc.l Obj_BossGreyBall_SpikeBall_Shot_Chain_Trail
ChildObjDat_BossGreyBall_Spark:
		dc.w 4-1
		dc.l Obj_BossGreyBall_Spark
ChildObjDat_DEZRadiusExplosion:
		dc.w 1-1
		dc.l Obj_DEZRadiusExplosion
ChildObjDat_BossGreyBall_Fire:
		dc.w 1-1
		dc.l Obj_BossGreyBall_Fire
ChildObjDat_DEZRadiusSuperExplosion:
		dc.w 1-1
		dc.l Obj_DEZRadiusSuperExplosion
ChildObjDat_DEZFallingExplosion:
		dc.w 1-1
		dc.l Obj_DEZFallingExplosion
ChildObjDat_RestorePlayerRings:
		dc.w 1-1
		dc.l Obj_RestorePlayerRings_Load
ChildObjDat_BossGreyBall_FlickerMove:
		dc.w 4-1
		dc.l Obj_BossGreyBall_FlickerMove
PLC_BossGreyBall_Asteroid: plrlistheader
		plreq $1F0, ArtKosM_BossGreyBall_Asteroid
PLC_BossGreyBall_Asteroid_End
; ---------------------------------------------------------------------------

		include "Objects/Boss Ball/Object Data/Map - Boss Ball.asm"
		include "Objects/Boss Ball/Object Data/Map - Asteroid.asm"