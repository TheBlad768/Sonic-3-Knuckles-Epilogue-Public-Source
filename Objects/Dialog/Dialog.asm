; ---------------------------------------------------------------------------
; Диалоги (Интро)
; ---------------------------------------------------------------------------

; Attributes
_Null						= 0
_Startup						= 2
_Startup2					= 4
_Defeated					= 6
_GreyBallStart				= 8
_GreyBallThirdPhase			= $A
_GreyBallEnd					= $C
_MiniOrbinautStart			= $E
_MiniOrbinautEnd			= $10
_MiniOrbinautAlt				= $12
_MiniOrbinautBossStart		= $14
_MiniOrbinautBossBattle		= $16
_FinalBallStart				= $18
_FinalBallEnd				= $1A
_TitleStartup					= $1C
_TitleStartup2				= $1E
_TitleStartup3				= $20
_TitleStartup4				= $22
_TitleStartup5				= $24
_TitleTails					= $26
_SparksterStartup				= $28

; Misc
_WindowSize:				= 5		; .b

; Dynamic object variables
obDialogWinowsPos:			= $18	; .l
obDialogWinowsSavePos:		= $1C	; .l
obDialogWinowsCom:			= $20	; .w
obDialogTimer:				= $2E	; .w
obDialogTextPointer:			= $30	; .l
obDialogTextSavePointer:		= $34	; .l
obDialogWinowsSize:			= $38	; .b
obDialogWinowsText:			= $39	; .b
obDialogTextLock:			= $3A	; .b
obDialogSaveSound:			= $3B	; .b

; =============== S U B R O U T I N E =======================================

Obj_Dialog_Process:
		disableInts
		lea	(MapUnc_DialogWindow).l,a1
		copyTilemap2	$8000, $C450, 320, 40
		move.w	#$8300+($8000>>10),VDP_control_port-VDP_data_port(a6)
		enableInts
		lea	PLC_Dialog(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		move.w	(Normal_palette_line_4-2).w,(Normal_palette_line_1+$A).w
		move.w	(Normal_palette_line_4-2).w,(Normal_palette_line_2+$A).w
		move.w	#$9200,obDialogWinowsCom(a0)
		move.b	#_WindowSize,obDialogWinowsSize(a0)
		move.w	#$4F,$2E(a0)
		move.l	#Dialog_Process_ShowWindow,address(a0)

Dialog_Process_ShowWindow:
		subq.w	#1,$2E(a0)
		bpl.w	Dialog_Process_Return
		move.w	#1,$2E(a0)
		disableInts
		move.w	obDialogWinowsCom(a0),d0
		addq.w	#1,d0
		move.w	d0,obDialogWinowsCom(a0)
		move.w	d0,(VDP_control_port).l
		enableInts
		cmpi.b	#_WindowSize,obDialogWinowsSize(a0)
		bne.s	+
		st	(HUD_RAM.draw).w
+		subq.b	#1,obDialogWinowsSize(a0)
		bne.w	Dialog_Process_Return

Dialog_Process_SetPrint:
		moveq	#0,d0
		movea.l	obDialogTextSavePointer(a0),a1
		move.b	obDialogWinowsText(a0),d0
		lsl.w	#3,d0
		adda.w	d0,a1
		move.w	(a1),d3
		andi.w	#$E000,d3
		addi.w	#$459,d3
		locVRAM	$8082,d0
		moveq	#(40/8-1),d1
		moveq	#(24/8-1),d2
		move.l	a1,-(sp)
		disableInts
		lea	(MapUnc_DialogIcon).l,a1
		jsr	(Plane_Map_To_Add_VRAM).w
		enableInts
		movea.l	(sp)+,a1
		move.l	(a1),d0
		andi.l	#$FFFFFF,d0
		move.l	d0,obDialogTextPointer(a0)
		move.l	-(a1),d0
		move.b	(a1),obDialogSaveSound(a0)
		andi.l	#$FFFFFF,d0
		movea.l	d0,a1
		move.w	#tiles_to_bytes($459),d2
		jsr	(Queue_Kos_Module).w
		locVRAM	$808E,d0
		move.l	d0,obDialogWinowsPos(a0)
		move.l	d0,obDialogWinowsSavePos(a0)
		move.w	#$F,$2E(a0)
		move.l	#Dialog_Process_CheckPrint,address(a0)

Dialog_Process_CheckPrint:
		move.b	(Ctrl_1_held).w,d0
		andi.b	#JoyABC+JoyStart,d0
		bne.s	Dialog_Process_WaitPrint
		move.l	#Dialog_Process_Print,address(a0)

Dialog_Process_Print:
		move.b	(Ctrl_1_held).w,d0
		andi.b	#JoyABC+JoyStart,d0
		bne.s	Dialog_Process_SkipPrint

Dialog_Process_WaitPrint:
		subq.w	#1,$2E(a0)
		bpl.s	Dialog_Process_Return
		move.w	#1,$2E(a0)

Dialog_Process_SkipPrint:
		move.b	obDialogSaveSound(a0),(Clone_Driver_RAM+SMPS_RAM.variables.queue.v_playsnd3).w
		move.w	#$8400,d3
		bsr.w	Dialog_LoadText
		beq.s	Dialog_Process_Return
		move.l	#Dialog_Process_WaitButton,address(a0)
		subq.b	#1,obDialogWinowsText(a0)
		beq.s	Dialog_Process_SetHideWindow

Dialog_Process_WaitButton:
		tst.b	obDialogTextLock(a0)
		bne.s	Dialog_Process_Return
		move.b	(Ctrl_1_pressed).w,d0
		andi.b	#JoyABC+JoyStart,d0
		beq.s	Dialog_Process_Return
		lea	Dialog_ProcessTextNull(pc),a1
		locVRAM	$808E,d1
		move.w	#$8400,d3
		jsr	(Load_PlaneText).w
		move.l	#Dialog_Process_SetPrint,address(a0)

Dialog_Process_Return:
		rts
; ---------------------------------------------------------------------------

Dialog_Process_SetHideWindow:
		move.b	#_WindowSize,obDialogWinowsSize(a0)
		move.w	#$4F,$2E(a0)
		move.l	#Dialog_Process_HideWindow,address(a0)
		moveq	#0,d0
		move.b	routine(a0),d0
		beq.s	Dialog_Process_HideWindow
		movea.w	parent3(a0),a1
		move.w	DialogBefore_Index-2(pc,d0.w),d0
		jsr	DialogBefore_Index(pc,d0.w)

Dialog_Process_HideWindow:
		subq.w	#1,$2E(a0)
		bpl.s	Dialog_Process_Return
		move.w	#1,$2E(a0)
		disableInts
		move.w	obDialogWinowsCom(a0),d0
		subq.w	#1,d0
		move.w	d0,obDialogWinowsCom(a0)
		move.w	d0,(VDP_control_port).l
		enableInts
		cmpi.b	#_WindowSize-3,obDialogWinowsSize(a0)
		bne.s	+
		clr.b	(HUD_RAM.draw).w
+		subq.b	#1,obDialogWinowsSize(a0)
		bne.s	Dialog_Process_HideWindow_Return
		move.w	(Target_palette_line_1+$A).w,(Normal_palette_line_1+$A).w
		move.w	(Target_palette_line_2+$A).w,(Normal_palette_line_2+$A).w
		moveq	#0,d0
		move.b	routine(a0),d0
		beq.s	Dialog_Process_HideWindow_Remove
		movea.w	parent3(a0),a1
		move.w	DialogAfter_Index-2(pc,d0.w),d0
		jsr	DialogAfter_Index(pc,d0.w)

Dialog_Process_HideWindow_Remove:
		move.l	#Delete_Current_Sprite,address(a0)

Dialog_Process_HideWindow_Return:
		rts
; ---------------------------------------------------------------------------

DialogBefore_Index: offsetTable
		offsetTableEntry.w DialogBefore_Process1		; 2
		offsetTableEntry.w DialogBefore_Null		; 4
		offsetTableEntry.w DialogBefore_Null		; 6
		offsetTableEntry.w DialogBefore_Null		; 8
		offsetTableEntry.w DialogBefore_Null		; $A
		offsetTableEntry.w DialogBefore_Null		; $C
		offsetTableEntry.w DialogBefore_Null		; $E
		offsetTableEntry.w DialogBefore_Null		; $10
		offsetTableEntry.w DialogBefore_Null		; $12
		offsetTableEntry.w DialogBefore_Null		; $14
		offsetTableEntry.w DialogBefore_Null		; $16
		offsetTableEntry.w DialogBefore_Null		; $18
		offsetTableEntry.w DialogBefore_Null		; $1A
		offsetTableEntry.w DialogBefore_Null		; $1C
		offsetTableEntry.w DialogBefore_Null		; $1E
		offsetTableEntry.w DialogBefore_Null		; $20
		offsetTableEntry.w DialogBefore_Null		; $22
		offsetTableEntry.w DialogBefore_Null		; $24
		offsetTableEntry.w DialogBefore_Null		; $26
		offsetTableEntry.w DialogBefore_Null		; $28
DialogAfter_Index: offsetTable
		offsetTableEntry.w DialogAfter_Process1		; 2
		offsetTableEntry.w DialogAfter_Process2		; 4
		offsetTableEntry.w DialogAfter_Process3		; 6
		offsetTableEntry.w DialogAfter_Process4		; 8
		offsetTableEntry.w DialogAfter_Process5		; $A
		offsetTableEntry.w DialogAfter_Process6		; $C
		offsetTableEntry.w DialogAfter_Process7		; $E
		offsetTableEntry.w DialogAfter_Process8		; $10
		offsetTableEntry.w DialogAfter_Process9		; $12
		offsetTableEntry.w DialogAfter_ProcessA		; $14
		offsetTableEntry.w DialogAfter_ProcessB		; $16
		offsetTableEntry.w DialogAfter_ProcessC		; $18
		offsetTableEntry.w DialogAfter_ProcessD		; $1A
		offsetTableEntry.w DialogAfter_ProcessE		; $1C
		offsetTableEntry.w DialogAfter_ProcessF		; $1E
		offsetTableEntry.w DialogAfter_Process10		; $20
		offsetTableEntry.w DialogAfter_Process11		; $22
		offsetTableEntry.w DialogAfter_Process12		; $24
		offsetTableEntry.w DialogAfter_Process13		; $26
		offsetTableEntry.w DialogAfter_Process14		; $28
; ---------------------------------------------------------------------------

DialogBefore_Process1:		; _Startup
		move.b	#_Setup2,routine(a1)
		sfx	bgm_Fade,0,1,1	; fade out music
		st	(Screen_shaking_flag).w

DialogBefore_Null:
		rts
; ---------------------------------------------------------------------------

DialogAfter_Process1:		; _Startup
		move.l	#Robotnik_Intro_Waiting,$34(a1)
		rts
; ---------------------------------------------------------------------------

DialogAfter_Process2:		; _Startup2
		move.l	#BossRobot_Startup,$34(a1)
		clr.b	(NoPause_flag).w
		move.b	#1,(Update_HUD_timer).w
		move.b	#1,(HUDBoss_RAM.status).w
		move.w	parent3(a0),(HUDBoss_RAM.parent).w
		rts
; ---------------------------------------------------------------------------

DialogAfter_Process3:		; _Defeated
		move.l	#BossRobot_CheckTouch_Explosive,address(a1)
		clr.b	(Ctrl_1_locked).w
		clr.b	(NoPause_flag).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------

DialogAfter_Process4:		; _GreyBallStart
		move.w	#$F,$2E(a1)
		move.w	#-$100,y_vel(a1)
		move.b	#_Setup1,routine(a1)
		move.l	#BossGreyBall_Intro_CheckPosition,$34(a1)
		move.b	#1,(Update_HUD_timer).w
		move.b	#1,(HUDBoss_RAM.status).w
		move.w	parent3(a0),(HUDBoss_RAM.parent).w
		clr.b	(Ctrl_1_locked).w
		clr.b	(NoPause_flag).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------

DialogAfter_Process5:		; _GreyBallThirdPhase
		move.l	#BossGreyBall_ThirdPhase_FallAttack,$34(a1)
		bset	#6,(v_Breathing_bubbles+$38).w
		clr.b	(NoPause_flag).w
		move.b	#1,(Update_HUD_timer).w
		rts
; ---------------------------------------------------------------------------

DialogAfter_Process6:		; _GreyBallEnd
		move.w	#$9F,$2E(a1)
		move.l	#BossGreyBall_CheckTouch_SuperExplosive,address(a1)
		move.w	a0,-(sp)
		movea.w	parent3(a0),a0
		lea	ChildObjDat_DEZFallingExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		movea.w	(sp)+,a0
		rts
; ---------------------------------------------------------------------------

DialogAfter_Process7:		; _MiniOrbinautStart
		move.b	#_Setup2,routine(a1)
		move.b	#16,$39(a1)
		move.l	#MiniOrbinaut_Intro_FindSonic,$34(a1)
		clr.b	(Ctrl_1_locked).w
		clr.b	(NoPause_flag).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------

DialogAfter_Process8:		; _MiniOrbinautEnd
		move.l	#DEZ1_Resize_setplayerpos,(Level_data_addr_RAM.Resize).w
		st	(Ctrl_1_locked).w
		clr.b	(NoPause_flag).w
		lea	(ArtKosM_BossGreyBall).l,a1
		move.w	#tiles_to_bytes($210),d2
		jmp	(Queue_Kos_Module).w
; ---------------------------------------------------------------------------

DialogAfter_Process9:		; _MiniOrbinautAlt
		move.b	#_Setup1,routine(a1)
		move.w	#$1F,$2E(a1)
		move.l	#MiniOrbinaut_Intro_AltWay_SetCheckPosition,$34(a1)
		lea	(ArtKosM_BossGreyBall).l,a1
		move.w	#tiles_to_bytes($210),d2
		jmp	(Queue_Kos_Module).w
; ---------------------------------------------------------------------------

DialogAfter_ProcessA:		; _MiniOrbinautBossStart
		move.l	#BossMiniOrbinaut_Process_Start,address(a1)
		clr.b	(NoPause_flag).w
		move.b	#1,(Update_HUD_timer).w
		rts
; ---------------------------------------------------------------------------

DialogAfter_ProcessB:		; _MiniOrbinautBossBattle
		movea.w	(Boss_Events).w,a1
		move.w	#$9F,$2E(a1)
		move.l	#BossMiniOrbinaut_Process_Wait,address(a1)
		clr.b	(NoPause_flag).w
		rts
; ---------------------------------------------------------------------------

DialogAfter_ProcessC:		; _FinalBallStart
		move.w	#$2F,$2E(a1)
		move.l	#BossFinalBall_Intro_MoveSwing,$34(a1)
		clr.b	(NoPause_flag).w
		rts
; ---------------------------------------------------------------------------

DialogAfter_ProcessD:		; _FinalBallEnd
		move.w	#$2F,$2E(a1)
		move.l	#BossFinalBall_CheckTouch_SuperExplosive_Fall,address(a1)
		clr.b	(NoPause_flag).w
		rts
; ---------------------------------------------------------------------------

DialogAfter_ProcessE:		; _TitleStartup
		move.w	#$2F,$2E(a1)
		move.l	#ShotBall_InsertCoinScreen_Process_WaitBinoculars,address(a1)
		rts
; ---------------------------------------------------------------------------

DialogAfter_ProcessF:		; _TitleStartup2
		move.l	#ShotBall_InsertCoinScreen_Process_ScrollUp_Wait,address(a1)
		rts
; ---------------------------------------------------------------------------

DialogAfter_Process10:	; _TitleStartup3
		move.w	#$1F,$2E(a1)
		move.l	#ShotBall_InsertCoinScreen_Process_ScrollDown_Wait,address(a1)
		rts
; ---------------------------------------------------------------------------

DialogAfter_Process11:		; _TitleStartup4
		move.w	#$1F,$2E(a1)
		move.l	#ShotBall_InsertCoinScreen_Process_Attack,address(a1)
		rts
; ---------------------------------------------------------------------------

DialogAfter_Process12:		; _TitleStartup5
		move.w	#$1F,$2E(a1)
		move.l	#ShotBall_InsertCoinScreen_Process_Remove,address(a1)
		rts
; ---------------------------------------------------------------------------

DialogAfter_Process13:		; _TitleTails
		move.w	#$1F,$2E(a1)
		move.l	#TailsPlane_InsertCoinScreen_Flash_SonicJump_Wait,address(a1)
		rts
; ---------------------------------------------------------------------------

DialogAfter_Process14:		; _SparksterStartup
		move.w	#$1F,$2E(a1)
		move.l	#SonicRocket_WaitDialog_Wait,address(a1)
		clr.b	(NoPause_flag).w
		rts
; ---------------------------------------------------------------------------
; Загрузка текста
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Dialog_LoadText:
		disableInts
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		movea.l	obDialogTextPointer(a0),a1
		move.l	obDialogWinowsPos(a0),d1		; Plane position
		move.l	#$1000000,d2				; Next line

Dialog_LoadText_Loop:
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		moveq	#0,d0
		move.b	(a1)+,d0
		bmi.s	Dialog_LoadText_Set
		add.w	d3,d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		move.l	a1,obDialogTextPointer(a0)
		addi.l	#$20000,obDialogWinowsPos(a0)
		enableInts
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

Dialog_LoadText_Set:
		cmpi.b	#-1,d0
		beq.s	Dialog_LoadText_Done
		move.l	obDialogWinowsSavePos(a0),d1
		add.l	d2,d1
		move.l	d1,obDialogWinowsPos(a0)
		move.l	d1,obDialogWinowsSavePos(a0)
		bra.s	Dialog_LoadText_Loop
; ---------------------------------------------------------------------------

Dialog_LoadText_Done:
		enableInts
		moveq	#1,d0
		rts
; End of function Dialog_LoadText
; ---------------------------------------------------------------------------

ChildObjDat_Dialog_Process:
		dc.w 1-1
		dc.l Obj_Dialog_Process
PLC_Dialog: plrlistheader
		plreq $420, ArtKosM_DialogText
		plreq $450, ArtKosM_DialogWindow
PLC_Dialog_End
; ---------------------------------------------------------------------------

DialogTitleStartup_Process_Index:
		dc.l ArtKosM_DialogEggmanLaugh|sfx_DialogRobotnik<<24
		dc.l DialogTitleStartup_ProcessText1|$80<<24		; 1
DialogTitleStartup_Process_Index_End

DialogTitleStartup2_Process_Index:
		dc.l ArtKosM_DialogEggmanLaugh|sfx_DialogRobotnik<<24
		dc.l DialogTitleStartup2_ProcessText1|$80<<24		; 1
DialogTitleStartup2_Process_Index_End

DialogTitleStartup3_Process_Index:
		dc.l ArtKosM_DialogEggmanLaugh|sfx_DialogRobotnik<<24
		dc.l DialogTitleStartup3_ProcessText1|$80<<24		; 1
DialogTitleStartup3_Process_Index_End

DialogTitleStartup4_Process_Index:
		dc.l ArtKosM_DialogEggmanLaugh|sfx_DialogRobotnik<<24
		dc.l DialogTitleStartup4_ProcessText1|$80<<24		; 1
DialogTitleStartup4_Process_Index_End

DialogTitleStartup5_Process_Index:
		dc.l ArtKosM_DialogEggmanLaugh|sfx_DialogRobotnik<<24
		dc.l DialogStartup_ProcessText1|$80<<24			; 1
DialogTitleStartup5_Process_Index_End

DialogTitleTails_Process_Index:
		dc.l ArtKosM_DialogTailsScared|sfx_DialogTails<<24
		dc.l DialogTitleTails_ProcessText1|$80<<24			; 1
DialogTitleTails_Process_Index_End

DialogSparksterStartup_Process_Index:
		dc.l ArtKosM_DialogSonic|sfx_DialogSonic<<24
		dc.l DialogSparksterStartup_ProcessText1|$80<<24	; 1
DialogSparksterStartup_Process_Index_End


DialogStartup_Process_Index:
		dc.l ArtKosM_DialogEggmanLaugh|sfx_DialogRobotnik<<24
		dc.l DialogStartup_ProcessText1|$80<<24			; 8
		dc.l ArtKosM_DialogSonic|sfx_DialogSonic<<24
		dc.l DialogStartup_ProcessText7|$80<<24			; 7
		dc.l ArtKosM_DialogEggmanLaugh|sfx_DialogRobotnik<<24
		dc.l DialogStartup_ProcessText6|$80<<24			; 6
		dc.l ArtKosM_DialogEggmanLaugh|sfx_DialogRobotnik<<24
		dc.l DialogStartup_ProcessText5|$80<<24			; 5
		dc.l ArtKosM_DialogSonic|sfx_DialogSonic<<24
		dc.l DialogStartup_ProcessText4|$80<<24			; 4
		dc.l ArtKosM_DialogSonic|sfx_DialogSonic<<24
		dc.l DialogStartup_ProcessText3|$80<<24			; 3
		dc.l ArtKosM_DialogEggmanLaugh|sfx_DialogRobotnik<<24
		dc.l DialogStartup_ProcessText2|$80<<24			; 2
		dc.l ArtKosM_DialogEggmanLaugh|sfx_DialogRobotnik<<24
		dc.l DialogStartup_ProcessText1|$80<<24			; 1
DialogStartup_Process_Index_End
DialogStartup2_Process_Index:
		dc.l ArtKosM_DialogEggmanAngry|sfx_DialogRobotnik<<24
		dc.l DialogStartup2_ProcessText1|$80<<24			; 1
DialogStartup2_Process_Index_End
DialogDefeated_Process_Index:
		dc.l ArtKosM_DialogEggmanDefeated|sfx_DialogRobotnik<<24
		dc.l DialogDefeated_ProcessText2|$80<<24			; 2
		dc.l ArtKosM_DialogEggmanDefeated|sfx_DialogRobotnik<<24
		dc.l DialogDefeated_ProcessText1|$80<<24			; 1
DialogDefeated_Process_Index_End
DialogMiniOrbinautStart_Process_Index:
		dc.l ArtKosM_DialogMiniBallNormal|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautStart_ProcessText3|$A0<<24	; 3
		dc.l ArtKosM_DialogSonic|sfx_DialogSonic<<24
		dc.l DialogMiniOrbinautStart_ProcessText2|$80<<24	; 2
		dc.l ArtKosM_DialogMiniBallNormal|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautStart_ProcessText1|$A0<<24	; 1
DialogMiniOrbinautStart_Process_Index_End
DialogMiniOrbinautEnd_Process_Index:
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautEnd_ProcessText1|$A0<<24	; 1
DialogMiniOrbinautEnd_Process_Index_End
DialogGreyBallStart_Process_Index:
		dc.l ArtKosM_DialogGrayBallNormal|sfx_DialogBall<<24
		dc.l DialogGreyBallStart_ProcessText2|$A0<<24		; 2
		dc.l ArtKosM_DialogGrayBallNormal|sfx_DialogBall<<24
		dc.l DialogGreyBallStart_ProcessText1|$A0<<24		; 1
DialogGreyBallStart_Process_Index_End
DialogGreyBallThirdPhase_Process_Index:
		dc.l ArtKosM_DialogGrayBallNormal|sfx_DialogFireBall<<24
		dc.l DialogGreyBallThirdPhase_ProcessText2|$A0<<24	; 2
		dc.l ArtKosM_DialogGrayBallNormal|sfx_DialogFireBall<<24
		dc.l DialogGreyBallThirdPhase_ProcessText1|$A0<<24	; 1
DialogGreyBallThirdPhase_Process_Index_End
DialogGreyBallEnd_Process_Index:
		dc.l ArtKosM_DialogGrayBallNormal|sfx_DialogFireBall2<<24
		dc.l DialogGreyBallEnd_ProcessText1|$A0<<24		; 1
DialogGreyBallEnd_Process_Index_End
DialogMiniOrbinautAlt_Process_Index:
		dc.l ArtKosM_DialogMiniBallNormal|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautAlt_ProcessText2|$A0<<24	; 2
		dc.l ArtKosM_DialogMiniBallNormal|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautAlt_ProcessText1|$A0<<24	; 1
DialogMiniOrbinautAlt_Process_Index_End
DialogMiniOrbinautBossStart_Process_Index:
		dc.l ArtKosM_DialogSonic|sfx_DialogSonic<<24
		dc.l DialogMiniOrbinautBossStart_ProcessText5|$80<<24		; 5
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossStart_ProcessText4|$A0<<24		; 4
		dc.l ArtKosM_DialogMiniBallNormal|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossStart_ProcessText3|$A0<<24		; 3
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossStart_ProcessText2|$A0<<24		; 2
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossStart_ProcessText1|$A0<<24		; 1
DialogMiniOrbinautBossStart_Process_Index_End



DialogMiniOrbinautBattle1_Process_Index:
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle1_ProcessText2|$A0<<24	; 2
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle1_ProcessText1|$A0<<24		; 1
DialogMiniOrbinautBattle1_Process_Index_End

DialogMiniOrbinautBattle2_Process_Index:
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle2_ProcessText2|$A0<<24	; 2
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle2_ProcessText1|$A0<<24	; 1
DialogMiniOrbinautBattle2_Process_Index_End

DialogMiniOrbinautBattle3_Process_Index:
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle3_ProcessText1|$A0<<24		; 1
DialogMiniOrbinautBattle3_Process_Index_End

DialogMiniOrbinautBattle4_Process_Index:
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle4_ProcessText1|$A0<<24	; 1
DialogMiniOrbinautBattle4_Process_Index_End

DialogMiniOrbinautBattle5_Process_Index:
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle5_ProcessText2|$A0<<24	; 2
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle5_ProcessText1|$A0<<24		; 1
DialogMiniOrbinautBattle5_Process_Index_End

DialogMiniOrbinautBattle6_Process_Index:
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle6_ProcessText2|$A0<<24	; 2
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle6_ProcessText1|$A0<<24	; 1
DialogMiniOrbinautBattle6_Process_Index_End

DialogMiniOrbinautBattle7_Process_Index:
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle7_ProcessText2|$A0<<24	; 2
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle7_ProcessText1|$A0<<24	; 1
DialogMiniOrbinautBattle7_Process_Index_End

DialogMiniOrbinautBattle8_Process_Index:
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogMiniOrbinautBossBattle8_ProcessText1|$A0<<24	; 1
DialogMiniOrbinautBattle8_Process_Index_End





DialogFinalBallStart_Process_Index:
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogFinalBallStart_ProcessText3|$A0<<24		; 3
		dc.l ArtKosM_DialogMiniBallEvil|sfx_DialogMiniBall<<24
		dc.l DialogFinalBallStart_ProcessText2|$A0<<24		; 2
		dc.l ArtKosM_DialogMiniBallNormal|sfx_DialogMiniBall<<24
		dc.l DialogFinalBallStart_ProcessText1|$A0<<24		; 1
DialogFinalBallStart_Process_Index_End

DialogFinalBallEnd_Process_Index:
		dc.l ArtKosM_DialogGrayBallNormal|sfx_DialogBall<<24
		dc.l DialogFinalBallEnd_ProcessText3|$A0<<24		; 3
		dc.l ArtKosM_DialogGrayBallNormal|sfx_DialogBall<<24
		dc.l DialogFinalBallEnd_ProcessText2|$A0<<24		; 2
		dc.l ArtKosM_DialogGrayBallNormal|sfx_DialogBall<<24
		dc.l DialogFinalBallEnd_ProcessText1|$A0<<24		; 1
DialogFinalBallEnd_Process_Index_End
; ---------------------------------------------------------------------------

	; set the character
		CHARSET ' ', 77
		CHARSET '0','9', 32
		CHARSET 'A','Z', 51
		CHARSET 'a','z', 51
		CHARSET '-', 45
		CHARSET '.', 46
		CHARSET '*', 47
		CHARSET '!', 48
		CHARSET '?', 49
		CHARSET ',', 50

Dialog_ProcessTextNull:
		dc.b "                                ",$81
		dc.b "                                ",-1



; 32 max


DialogTitleStartup_ProcessText1:
		dc.b "Now where are you...",$80
		dc.b "MUHAHAHA. Engage the weapons.",-1
DialogTitleStartup2_ProcessText1:
		dc.b "Ready.",-1
DialogTitleStartup3_ProcessText1:
		dc.b "Now I see you.",$80
		dc.b "No... That would be too easy.",-1
DialogTitleStartup4_ProcessText1:
		dc.b "Perfect!",$80
		dc.b "Attack!!!",-1
DialogTitleTails_ProcessText1:
		dc.b "Sonic! Don*t worry about me! You",$80
		dc.b "must save the Master Emerald!",-1


DialogSparksterStartup_ProcessText1:
		dc.b "I must stop Dr. Robotnik!",$80
		dc.b "Let*s go!",-1



DialogStartup_ProcessText1:
		dc.b "HA-HA-HA!",-1
DialogStartup_ProcessText2:
		dc.b "You*re finally here! I hope you",$80
		dc.b "didn*t get hurt on your way.",-1
DialogStartup_ProcessText3:
		dc.b "Enough of your tricks!",$80
		dc.b "You have nowhere to run!",-1
DialogStartup_ProcessText4:
		dc.b "Return the stolen",$80
		dc.b "Master Emerald immediately!",-1
DialogStartup_ProcessText5:
		dc.b "Stupid hedgehog!",$80
		dc.b "I*m not running away.",-1
DialogStartup_ProcessText6:
		dc.b "You*ve fallen into my trap",$80
		dc.b "again! So predictable...",-1
DialogStartup_ProcessText7:
		dc.b "A trap?",$80
		dc.b "What are you talking about?",-1
DialogStartup2_ProcessText1:
		dc.b "Enough with the jokes!",$80
		dc.b "Prepare to die!",-1
DialogDefeated_ProcessText1:
		dc.b "Noooo! Impossible...",$80
		dc.b "I*ve lost again! Damn it!",-1
DialogDefeated_ProcessText2:
		dc.b "You*ll regret this!",$80
		dc.b "Next time, I*ll destroy you!",-1
DialogMiniOrbinautStart_ProcessText1:
		dc.b "Hi Sonic!",$80
		dc.b "Let*s be friends!",-1
DialogMiniOrbinautStart_ProcessText2:
		dc.b "Who are you?",$80
		dc.b "I ain*t afraid of you!",-1
DialogMiniOrbinautStart_ProcessText3:
		dc.b "That doesn*t matter.",$80
		dc.b "Let*s play catch!",-1
DialogMiniOrbinautEnd_ProcessText1:
		dc.b "You thought I*m dead? Nope.",$80
DialogFinalBallStart_ProcessText3:
		dc.b "The game has only just begun.",-1
DialogGreyBallStart_ProcessText1:
		dc.b "How*s my new look?",-1
DialogGreyBallStart_ProcessText2:
		dc.b "Now we have more capacity for",$80
		dc.b "our play!",-1
DialogGreyBallThirdPhase_ProcessText1:
		dc.b "That*s not fair! You have the",$80
		dc.b "advantage on the ground...",-1
DialogGreyBallThirdPhase_ProcessText2:
		dc.b "But now we*re up in the air!",$80
		dc.b "I will never lose to you!",-1
DialogGreyBallEnd_ProcessText1:
		dc.b "We had fun, but now it*s time",$80
		dc.b "for me to perish. Bye!",-1

DialogMiniOrbinautAlt_ProcessText1:
		dc.b "You*re too fast for me.",$80
		dc.b "I don*t stand a chance...",-1
DialogMiniOrbinautAlt_ProcessText2:
		dc.b "But I have a different idea.",$80
		dc.b "Hang in there...",-1
DialogMiniOrbinautBossStart_ProcessText1:
		dc.b "You*ll regret choosing the",$80
		dc.b "alternate route!",-1
DialogMiniOrbinautBossStart_ProcessText2:
		dc.b "I will destroy you!",-1
DialogMiniOrbinautBossStart_ProcessText3:
		dc.b "No...",-1
DialogMiniOrbinautBossStart_ProcessText4:
		dc.b "We will destroy you!",-1
DialogMiniOrbinautBossStart_ProcessText5:
		dc.b "We?",-1






DialogMiniOrbinautBossBattle1_ProcessText1:
		dc.b "Not bad...",$80
		dc.b "But this is only the beginning!",-1
DialogMiniOrbinautBossBattle1_ProcessText2:
		dc.b "I have a present for you!",-1

DialogMiniOrbinautBossBattle2_ProcessText1:
		dc.b "Are you actually trying to",$80
		dc.b "destroy me?",-1
DialogMiniOrbinautBossBattle2_ProcessText2:
		dc.b "This is pointless!",-1

DialogMiniOrbinautBossBattle3_ProcessText1:
		dc.b "This battle will be an endurance",$80
		dc.b "test! I will tire you out!",-1

DialogMiniOrbinautBossBattle4_ProcessText1:
		dc.b "Did I ever tell you what the",$80
		dc.b "definition of insanity is?",-1

DialogMiniOrbinautBossBattle5_ProcessText1:
		dc.b "Why are you still fighting?",-1
DialogMiniOrbinautBossBattle5_ProcessText2:
		dc.b "You*re just wasting your time!",-1

DialogMiniOrbinautBossBattle6_ProcessText1:
		dc.b "Think Sonic, Think!",$80
		dc.b "You can stop this.",-1
DialogMiniOrbinautBossBattle6_ProcessText2:
		dc.b "Just... give up!",-1

DialogMiniOrbinautBossBattle7_ProcessText1:
		dc.b "Nooooooooo...",$80
		dc.b "This isn*t fair!",-1
DialogMiniOrbinautBossBattle7_ProcessText2:
		dc.b "I won*t lose this easily!",$80
		dc.b "Next phase!",-1

DialogMiniOrbinautBossBattle8_ProcessText1:
		dc.b "Now we*ll be playing by your",$80
		dc.b "rules! You won*t outrun me!",-1













DialogFinalBallStart_ProcessText1:
		dc.b "I will show you my new form,",-1
DialogFinalBallStart_ProcessText2:
		dc.b "and now it*s you who won*t",$80
		dc.b "stand a chance!",-1

DialogFinalBallEnd_ProcessText1:
		dc.b "Yes, I have lost now.",$80
		dc.b "But if you dare, choose a",-1
DialogFinalBallEnd_ProcessText2:
		dc.b "different route next time.",$80
		dc.b "I*ll get back at you, just you",-1
DialogFinalBallEnd_ProcessText3:
		dc.b "wait...",-1





	even

		CHARSET ; reset character set
