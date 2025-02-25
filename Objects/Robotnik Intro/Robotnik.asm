; ---------------------------------------------------------------------------
; Роботник интро
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Robotnik_Intro:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Robotnik_Intro_Index(pc,d0.w),d0
		jsr	Robotnik_Intro_Index(pc,d0.w)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Robotnik_Intro_Index: offsetTable
		offsetTableEntry.w Robotnik_Intro_Init		; 0
		offsetTableEntry.w Robotnik_Intro_Setup		; 2
		offsetTableEntry.w Robotnik_Intro_Setup2	; 4
; ---------------------------------------------------------------------------

Robotnik_Intro_Init:
		lea	ObjDat3_Robotnik(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$B30,x_pos(a0)
		move.w	#$424,y_pos(a0)
		move.l	#Robotnik_Intro_CheckCamera,$34(a0)
		move.l	#AniRaw_Robotnik,$30(a0)

Robotnik_Intro_Return:
		rts
; ---------------------------------------------------------------------------

Robotnik_Intro_Setup2:
		moveq	#signextendB(sfx_Shaking),d0
		moveq	#$1F,d2
		jsr	(Wait_Play_Sound).w

Robotnik_Intro_Setup:
		jsr	(Animate_Raw).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

Robotnik_Intro_CheckCamera:
		jsr	(Find_SonicTails).w
		cmpi.w	#$C0,d2
		bhs.s	Robotnik_Intro_Return
		move.l	#Robotnik_Intro_SetWaiting,$34(a0)
		sfx	sfx_Laser5,0,0,0
		lea	ChildObjDat_Robotnik_Intro_WallBall(pc),a2
		jsr	(CreateChild6_Simple).w
		tst.b	(Intro_flag).w
		bne.s	Robotnik_Intro_SkipIntro
		addq.b	#1,(Intro_flag).w
		st	(NoPause_flag).w
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	Robotnik_Intro_SetWaiting
		move.b	#_Startup,routine(a1)
		move.l	#DialogStartup_Process_Index-4,$34(a1)
		move.b	#(DialogStartup_Process_Index_End-DialogStartup_Process_Index)/8,$39(a1)

Robotnik_Intro_SetWaiting:
		cmpi.w	#$A20,(Camera_X_pos).w
		bne.s	Robotnik_Intro_Return
		move.w	#$4F,$2E(a0)
		move.l	#Robotnik_Intro_SetPlayerAnim,$34(a0)
		clr.w	(Ctrl_1_logical).w
		lea	(Player_1).w,a1
		jmp	(Stop_Object).w
; ---------------------------------------------------------------------------

Robotnik_Intro_SkipIntro:
		movea.w	parent3(a0),a1
		move.w	#$BA0,x_pos(a1)
		move.w	#$4F,$2E(a0)
		move.w	#$2F,$2E(a1)
		move.l	#Obj_Wait,address(a0)
		move.l	#BossRobot_Startup,$34(a1)
		move.l	#Robotnik_Intro_SkipIntro_Start,$34(a0)
		lea	PLC_BossRobot(pc),a5
		jmp	(LoadPLC_Raw_KosM).w
; ---------------------------------------------------------------------------

Robotnik_Intro_SkipIntro_Start:
		move.l	#Delete_Current_Sprite,$34(a0)
		move.b	#1,(Update_HUD_timer).w
		move.b	#1,(HUDBoss_RAM.status).w
		move.w	parent3(a0),(HUDBoss_RAM.parent).w
		music	bgm_DeathBallBoss,0,0,0
		rts
; ---------------------------------------------------------------------------

Robotnik_Intro_SetPlayerAnim:
		move.l	#Robotnik_Intro_Return,$34(a0)
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)
		move.w	#id_Wait2<<8,anim(a1)
		music	bgm_ZoneBoss,0,0,0
		rts
; ---------------------------------------------------------------------------

Robotnik_Intro_Waiting:
		movea.w	parent3(a0),a1
		move.w	a0,$44(a1)
		move.w	#$3F,$2E(a0)
		move.w	#$4F,$2E(a1)
		move.l	#Robotnik_Intro_Check,$34(a0)
		move.l	#BossRobot_Robotnik_Intro_FindRobotnik_Start,$34(a1)
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)
		move.w	#id_LookUp<<8,anim(a1)
		music	bgm_DeathBallBoss,0,0,0
		rts
; ---------------------------------------------------------------------------

Robotnik_Intro_Check:
		sfx	sfx_Signal,0,0,0
		move.l	#Robotnik_Intro_Return,$34(a0)
		lea	ChildObjDat_RobotnikShipCrane_Intro(pc),a2
		jmp	(CreateChild1_Normal).w
; ---------------------------------------------------------------------------
; Роботник интро (Цепь)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_RobotnikShipCrane_Intro:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	RobotnikShipCrane_Intro_Index(pc,d0.w),d0
		jmp	RobotnikShipCrane_Intro_Index(pc,d0.w)
; ---------------------------------------------------------------------------

RobotnikShipCrane_Intro_Index: offsetTable
		offsetTableEntry.w RobotnikShipCrane_Intro_Init		; 0
		offsetTableEntry.w RobotnikShipCrane_Intro_Setup	; 2
		offsetTableEntry.w RobotnikShipCrane_Intro_Setup2	; 4
; ---------------------------------------------------------------------------

RobotnikShipCrane_Intro_Init:
		lea	ObjDat3_RobotnikShipCrane(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$6F,$2E(a0)
		move.l	#RobotnikShipCrane_Intro_Chain,$34(a0)
		lea	ChildObjDat_RobotnikShipCrane_Intro_Platform(pc),a2
		jsr	(CreateChild6_Simple).w
		movea.w	$44(a0),a1
		jmp	(Refresh_ChildPosition2).w
; ---------------------------------------------------------------------------

RobotnikShipCrane_Intro_Setup2:
		movea.w	parent3(a0),a1
		move.w	x_pos(a0),d0
		addq.w	#8,d0
		move.w	d0,x_pos(a1)
		move.w	y_pos(a0),d0
		addq.w	#7,d0
		move.w	d0,y_pos(a1)

RobotnikShipCrane_Intro_Setup:
		movea.w	$44(a0),a1
		jsr	(Refresh_ChildPosition2).w
		jsr	(Obj_Wait).w
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

RobotnikShipCrane_Intro_Chain:
		movea.w	parent3(a0),a1
		move.w	parent3(a1),$44(a0)
		movea.w	parent3(a1),a1
		move.b	#setOpen,anim(a1)
		move.w	#$F,$2E(a0)
		move.l	#RobotnikShipCrane_Intro_ChangeFrameChain_Sound,$34(a0)

RobotnikShipCrane_Intro_Chain_Return:
		rts
; ---------------------------------------------------------------------------

RobotnikShipCrane_Intro_ChangeFrameChain_Sound:
		sfx	sfx_Descend,0,0,0
		move.l	#RobotnikShipCrane_Intro_ChangeFrameChain,$34(a0)

RobotnikShipCrane_Intro_ChangeFrameChain:
		move.b	child_dy(a0),d0
		addq.b	#1,child_dy(a0)
		andi.w	#$F,d0
		bne.s	RobotnikShipCrane_Intro_Chain_Return
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#8,mapping_frame(a0)
		bne.s	RobotnikShipCrane_Intro_Chain_Return
		move.b	#_Setup2,routine(a0)
		move.w	#$F,$2E(a0)
		move.l	#RobotnikShipCrane_Intro_SetRobotnikPosChain,$34(a0)
		sfx	sfx_Lifting,0,0,0

RobotnikShipCrane_Intro_SetRobotnikPosChain:
		move.b	child_dy(a0),d0
		subq.b	#1,child_dy(a0)
		andi.w	#$F,d0
		bne.s	RobotnikShipCrane_Intro_ChangeFrameChain_Return
		cmpi.b	#2,mapping_frame(a0)
		bne.s	+
		bsr.s	RobotnikShipCrane_Intro_RobotnikRemove
+		subq.b	#1,mapping_frame(a0)
		bne.s	RobotnikShipCrane_Intro_ChangeFrameChain_Return
		movea.w	$44(a0),a1
		move.b	#setClose,anim(a1)
		move.l	#BossRobot_Robotnik_Intro_Return,$34(a1)
		move.l	#RobotnikShipCrane_Intro_Remove,$34(a0)
		lea	PLC_BossRobot(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		sfx	sfx_Activation,0,0,0
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	RobotnikShipCrane_Intro_ChangeFrameChain_Return
		move.b	#_Startup2,routine(a1)
		move.l	#DialogStartup2_Process_Index-4,$34(a1)
		move.b	#(DialogStartup2_Process_Index_End-DialogStartup2_Process_Index)/8,$39(a1)
		move.w	$44(a0),parent3(a1)

RobotnikShipCrane_Intro_ChangeFrameChain_Return:
		rts
; ---------------------------------------------------------------------------

RobotnikShipCrane_Intro_RobotnikRemove:
		movea.w	parent3(a0),a1
		jmp	(Delete_Referenced_Sprite).w
; ---------------------------------------------------------------------------

RobotnikShipCrane_Intro_Remove:
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------
; Роботник интро (Платформа)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_RobotnikShipCrane_Intro_Platform:
		lea	ObjDat3_RobotnikShipCrane(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#$A,mapping_frame(a0)
		move.l	#+,address(a0)
+		jsr	(Refresh_ChildPosition).w
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------
; Роботник интро (Защитный луч)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Robotnik_Intro_WallBall:
		lea	ObjDat3_ShootingBall_Missile(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$B62,x_pos(a0)
		move.w	#$3B0,y_pos(a0)
		move.w	#-$C00,x_vel(a0)
		move.w	#$A00,y_vel(a0)
		move.l	#+,address(a0)
+		bsr.s	Robotnik_Intro_WallBall_FindSonic
		bsr.s	Robotnik_Intro_WallBall_Floor
		jsr	(MoveSprite2).w
		jmp	(Sprite_ChildCheckDeleteXY).w
; ---------------------------------------------------------------------------

Robotnik_Intro_WallBall_FindSonic:
		jsr	(Find_SonicTails).w
		cmpi.w	#20,d2
		bhs.s	Robotnik_Intro_WallBall_Return
		cmpi.w	#20,d3
		bhs.s	Robotnik_Intro_WallBall_Return
		jmp	(HurtCharacter_WithoutDamage).w
; ---------------------------------------------------------------------------

Robotnik_Intro_WallBall_Floor:
		jsr	(ObjCheckFloorDist).l
		tst.w	d1
		bpl.s	Robotnik_Intro_WallBall_Return
		add.w	d1,y_pos(a0)
		sfx	sfx_BreakBridge,0,0,0
		move.w	#$14,(Screen_shaking_flag).w
		move.l	#Obj_DEZExplosion,address(a0)

Robotnik_Intro_WallBall_Return:
		rts
; ---------------------------------------------------------------------------
; Роботник интро (Джетпак)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

RobotnikJetpack_Intro_FireProcess:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#3,d0
		bne.s	Robotnik_Intro_WallBall_Return
		lea	ChildObjDat_RobotnikJetpackFire_Intro(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

Obj_RobotnikJetpack_Intro:
		lea	ObjDat3_Robotnik(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$80,priority(a0)
		ori.w	#$8000,art_tile(a0)
		addq.b	#2,mapping_frame(a0)
		move.l	#RobotnikJetpack_Intro_Main,address(a0)
		move.w	#$400,x_vel(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		sub.w	x_pos(a0),d0
		bhs.s	RobotnikJetpack_Intro_Main
		neg.w	x_vel(a0)
		bset	#0,render_flags(a0)

RobotnikJetpack_Intro_Main:
		bsr.s	RobotnikJetpack_Intro_FireProcess
		moveq	#-$20,d1
		jsr	(MoveSprite_CustomGravity).w
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	RobotnikJetpack_Intro_Remove
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.s	RobotnikJetpack_Intro_Remove
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

RobotnikJetpack_Intro_Remove:
		moveq	#palid_DEZ2,d0
		jsr	(LoadPalette_Immediate).w
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------
; Роботник интро (Огонь из джетпака)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_RobotnikJetpackFire_Intro:
		moveq	#1-1,d6

-		jsr	(Create_New_Sprite3).w
		bne.s	+
		move.l	#Obj_RobotnikJetpackFire_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$8530,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	#$100,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		jsr	(Random_Number).w
		andi.w	#$FF,d0
		addi.w	#$200,d0
		neg.w	d0
		move.w	d0,x_vel(a1)
		jsr	(Random_Number).w
		andi.w	#$FF,d0
		addi.w	#$200,d0
		move.w	d0,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)
		dbf	d6,-
+		bra.w	Robotnik_IntroFullExplosion_Delete
; ---------------------------------------------------------------------------

Obj_RobotnikJetpackFire_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#3,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.w	Robotnik_IntroFullExplosion_Delete
+		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------
; Роботник интро (Взрывы по всему экрану)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Robotnik_IntroFullExplosion:
		moveq	#1,d2
		moveq	#16-1,d6

-		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_Robotnik_IntroFullExplosion_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$8530,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	#$100,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		jsr	(Random_Number).w
		andi.w	#$F0,d0
		add.w	(Camera_X_pos).w,d0
		addi.w	#$80,d0
		move.w	d0,x_pos(a1)
		jsr	(Random_Number).w
		andi.w	#$F0,d0
		add.w	(Camera_Y_pos).w,d0
		move.w	d0,y_pos(a1)
		move.w	d2,d3
		asl.w	#8,d3
		addi.w	#$100,d3
		neg.w	d3
		move.w	d3,x_vel(a1)
		move.b	#3,anim_frame_timer(a1)
		addq.w	#1,d2
		dbf	d6,-
+		bra.s	Robotnik_IntroFullExplosion_Delete
; ---------------------------------------------------------------------------

Obj_Robotnik_IntroFullExplosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#7,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.s	Robotnik_IntroFullExplosion_Delete
+		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Robotnik_IntroFullExplosion_Delete:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

ObjDat3_Robotnik:
		dc.l Map_Robotnik
		dc.w $82E1
		dc.w $300
		dc.b 48/2
		dc.b 40/2
		dc.b 0
		dc.b 0
ObjDat3_RobotnikShipCrane:
		dc.l Map_RobotnikShipCrane
		dc.w $A341
		dc.w $280
		dc.b 40/2
		dc.b 40/2
		dc.b 0
		dc.b 0
AniRaw_Robotnik:
		dc.b 7, 0, 1, $FC
ChildObjDat_Robotnik_Intro:
		dc.w 1-1
		dc.l Obj_Robotnik_Intro
ChildObjDat_RobotnikJetpack_Intro:
		dc.w 1-1
		dc.l Obj_RobotnikJetpack_Intro
ChildObjDat_RobotnikShipCrane_Intro:
		dc.w 1-1
		dc.l Obj_RobotnikShipCrane_Intro
		dc.b 0
		dc.b -32
ChildObjDat_RobotnikShipCrane_Intro_Platform:
		dc.w 1-1
		dc.l Obj_RobotnikShipCrane_Intro_Platform
ChildObjDat_Robotnik_Intro_WallBall:
		dc.w 1-1
		dc.l Obj_Robotnik_Intro_WallBall
ChildObjDat_RobotnikJetpackFire_Intro:
		dc.w 1-1
		dc.l Obj_RobotnikJetpackFire_Intro
PLC_Robotnik: plrlistheader
		plreq $2E1, ArtKosM_Robotnik
PLC_Robotnik_End
; ---------------------------------------------------------------------------

		include "Objects/Robotnik Intro/Object Data/Map - Robotnik.asm"
		include "Objects/Robotnik Intro/Object Data/Map - Robotnik Ship Crane.asm"