; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Do_ResizeEvents:
		movea.l	(Level_data_addr_RAM.Resize).w,a0
		jsr	(a0)
		moveq	#2,d1
		move.w	(Camera_target_max_Y_pos).w,d0
		sub.w	(Camera_max_Y_pos).w,d0
		beq.s	++
		bcc.s	+++
		neg.w	d1
		move.w	(Camera_Y_pos).w,d0
		cmp.w	(Camera_target_max_Y_pos).w,d0
		bls.s		+
		move.w	d0,(Camera_max_Y_pos).w
		andi.w	#-2,(Camera_max_Y_pos).w
+		add.w	d1,(Camera_max_Y_pos).w
		move.b	#1,(Camera_max_Y_pos_changing).w
+		rts
; ---------------------------------------------------------------------------
+		move.w	(Camera_Y_pos).w,d0
		addq.w	#8,d0
		cmp.w	(Camera_max_Y_pos).w,d0
		blo.s		+
		btst	#1,(Player_1+status).w
		beq.s	+
		add.w	d1,d1
		add.w	d1,d1
+		add.w	d1,(Camera_max_Y_pos).w
		move.b	#1,(Camera_max_Y_pos_changing).w

No_Resize:
		rts
; End of function Do_ResizeEvents

; =============== S U B R O U T I N E =======================================

DEZ1_Resize:
		cmpi.w	#$320,(Camera_X_pos).w
		blo.s		No_Resize
		move.l	#DEZ1_Resize_sound,(Level_data_addr_RAM.Resize).w
		sfx	bgm_Fade,0,0,0 ; fade out music
		move.w	#$370,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		clr.b	(Update_HUD_timer).w	; Stop
		lea	(Player_1).w,a1
		jsr	(Stop_Object).w
		st	(Ctrl_1_locked).w
		move.w	#btnR<<8,(Ctrl_1_logical).w

DEZ1_Resize_sound:
		lea	(Player_1+x_vel).w,a1
		cmpi.w	#$700,(a1)
		bhs.s	+
		moveq	#2,d0
		add.w	d0,(a1)+
		add.w	d0,2(a1)
+		cmpi.w	#$900,(Camera_X_pos).w
		blo.s		DEZ1_Resize_wait
		move.l	#DEZ1_Resize_soundend,(Level_data_addr_RAM.Resize).w
		jsr	(Create_New_Sprite).w
		bne.s	DEZ1_Resize_soundend
		move.l	#Obj_BossRobot,address(a1)
		move.w	#$C00,x_pos(a1)
		move.w	#$3C0,y_pos(a1)

DEZ1_Resize_soundend:
		cmpi.w	#$A20,(Camera_X_pos).w
		bne.s	DEZ1_Resize_wait
		move.l	#DEZ1_Resize_wait,(Level_data_addr_RAM.Resize).w
		move.w	(Camera_target_max_X_pos).w,(Camera_min_X_pos).w
		sfx	sfx_ScarySignal2,0,0,0

DEZ1_Resize_wait:
		rts
; ---------------------------------------------------------------------------

DEZ1_Resize_timer:
		move.l	#DEZ1_Resize_explosion,(Level_data_addr_RAM.Resize).w
		move.w	#4*60,(Demo_timer).w
		lea	(DEZ1_Layout_WallExplosion).l,a0
		jsr	(Load_Level2).w
		sfx	bgm_Fade,0,0,0	; fade out music
		st	(Screen_shaking_flag).w
		st	(NoPause_flag).w
		clr.b	(Update_HUD_timer).w	; Stop
		rts
; ---------------------------------------------------------------------------

DEZ1_Resize_explosion:
		tst.w	(Demo_timer).w
		bne.s	+
		move.l	#DEZ1_Resize_createEndSign,(Level_data_addr_RAM.Resize).w
		move.b	#1,(Screen_event_flag).w		; Full
+		move.b	(Level_frame_counter+1).w,d1
		andi.w	#$F,d1
		bne.s	+
		sfx	sfx_Boom2,0,0,0
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_Robotnik_IntroFullExplosion,address(a1)
+		rts
; ---------------------------------------------------------------------------

DEZ1_Resize_createEndSign:
		move.l	#DEZ1_Resize_wait,(Level_data_addr_RAM.Resize).w
		clr.b	(Screen_shaking_flag).w
		clr.b	(NoPause_flag).w
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_MiniOrbinaut,address(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$160,d2
		move.w	d2,x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		addi.w	#$80,d2
		move.w	d2,y_pos(a1)
+		rts
; ---------------------------------------------------------------------------

DEZ1_Resize_breakdist:
		move.l	#DEZ1_Resize_breakdistexplosion,(Level_data_addr_RAM.Resize).w
		move.w	#1*60,(Demo_timer).w
		st	(NoPause_flag).w

DEZ1_Resize_breakdistexplosion:
		tst.w	(Demo_timer).w
		bne.s	DEZ1_Resize_breakcheckplayer_Return
		move.l	#DEZ1_Resize_breakcheckplayer,(Level_data_addr_RAM.Resize).w
		st	(Screen_event_flag).w
		move.w	#$6F0,d0
		move.w	d0,(Camera_max_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		lea	(Player_1).w,a1
		move.w	#$300,d0
		cmp.w	y_vel(a1),d0
		bge.s	DEZ1_Resize_breakcheckplayer
		move.w	d0,y_vel(a1)

DEZ1_Resize_breakcheckplayer:
		lea	(Player_1).w,a1
		btst	#Status_InAir,status(a1)
		bne.s	DEZ1_Resize_wait_2
		move.l	#DEZ1_Resize_checkfade2,(Level_data_addr_RAM.Resize).w
		clr.b	(Screen_shaking_flag).w
		clr.b	(NoPause_flag).w
		sfx	bgm_Fade,0,0,0	; fade out music
		move.w	#$6F0,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w

DEZ1_Resize_breakcheckplayer_Return:
		rts
; ---------------------------------------------------------------------------

DEZ1_Resize_checkfade2:
		move.l	#DEZ1_Resize_wait,(Level_data_addr_RAM.Resize).w
		st	(NoPause_flag).w
		jsr	(Create_New_Sprite).w
		bne.s	DEZ1_Resize_wait_2
		move.l	#Obj_Dialog_Process,address(a1)
		move.b	#_MiniOrbinautEnd,routine(a1)
		move.l	#DialogMiniOrbinautEnd_Process_Index-4,$34(a1)
		move.b	#(DialogMiniOrbinautEnd_Process_Index_End-DialogMiniOrbinautEnd_Process_Index)/8,$39(a1)

DEZ1_Resize_wait_2:
		rts
; ---------------------------------------------------------------------------

DEZ1_Resize_setplayerpos:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$110,d0
		move.w	#btnL<<8,d1
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s		+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		rts
; ---------------------------------------------------------------------------
+		btst	#Status_InAir,status(a1)
		bne.s	-
		move.l	#DEZ1_Resize_createorbinaut,(Level_data_addr_RAM.Resize).w
		clr.w	(Ctrl_1_logical).w
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)
		move.w	#id_LookUp<<8,anim(a1)
		bset	#Status_Facing,status(a1)
		jmp	(Stop_Object).w
; ---------------------------------------------------------------------------

DEZ1_Resize_createorbinaut:
		move.b	#1,(Current_act).w
		clr.b	(Intro_flag).w
		jsr	(LoadLevelPointer).w
		move.l	#DEZ2_Resize_wait,(Level_data_addr_RAM.Resize).w
		music	bgm_BallBoss,0,0,0
		jsr	(Create_New_Sprite).w
		bne.s	DEZ1_Resize_wait_2
		move.l	#Obj_BossGreyBall,address(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$40,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$60,d0
		move.w	d0,y_pos(a1)
		st	$33(a1)
		rts
; ---------------------------------------------------------------------------

DEZ1_Resize_loadminiboss:
		move.b	#2,(Current_act).w
		clr.b	(Intro_flag).w
		jsr	(LoadLevelPointer).w
		move.l	#DEZ3_Resize_wait,(Level_data_addr_RAM.Resize).w
		music	bgm_MiniBallBoss,0,0,0

		tst.b	(SegaCD_flag).w
		beq.s	+
		bset	#0,(Clone_Driver_RAM+SMPS_RAM.variables.v_cda_ignore).w
+

		st	(SpinDash_flag).w
		jsr	(Create_New_Sprite).w
		bne.s	DEZ1_Resize_loadminiboss_Return
		move.l	#Obj_BossMiniOrbinaut_Process,address(a1)

DEZ1_Resize_loadminiboss_Return:
		rts

; =============== S U B R O U T I N E =======================================

DEZ2_Resize:
		lea	(Player_1).w,a1
		bset	#Status_Facing,status(a1)
		tst.b	routine(a1)
		beq.s	DEZ1_Resize_loadminiboss_Return
		move.l	#DEZ2_Resize_start,(Level_data_addr_RAM.Resize).w
		move.b	#id_Hurt,anim(a1)		; Set falling animation
		bclr	#Status_OnObj,status(a1)
		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
		bset	#Status_InAir,status(a1)

DEZ2_Resize_start:
		cmpi.w	#$6F0,(Camera_Y_pos).w
		bne.s	DEZ1_Resize_loadminiboss_Return
		move.l	#DEZ2_Resize_endtimer,(Level_data_addr_RAM.Resize).w
		move.w	#2*60,(Demo_timer).w
		move.w	#$6F0,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w

DEZ2_Resize_endtimer:
		tst.w	(Demo_timer).w
		bne.s	DEZ1_Resize_loadminiboss_Return
		move.l	#DEZ2_Resize_setplayerpos,(Level_data_addr_RAM.Resize).w
		clr.b	(Update_HUD_timer).w	; Stop
		st	(Ctrl_1_locked).w

DEZ2_Resize_setplayerpos:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		move.w	#btnL<<8,d1
		addi.w	#$110,d0
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s		+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		rts
; ---------------------------------------------------------------------------
+		btst	#Status_InAir,status(a1)
		bne.s	-
		move.l	#DEZ2_Resize_loadboss,(Level_data_addr_RAM.Resize).w
		clr.w	(Ctrl_1_logical).w
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)
		move.w	#id_LookUp<<8,anim(a1)
		bset	#Status_Facing,status(a1)
		jmp	(Stop_Object).w
; ---------------------------------------------------------------------------

DEZ2_Resize_loadboss:
		music	bgm_BallBoss,0,0,0
		move.l	#DEZ2_Resize_wait,(Level_data_addr_RAM.Resize).w
		jsr	(Create_New_Sprite).w
		bne.s	DEZ2_Resize_wait
		move.l	#Obj_BossGreyBall,address(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$40,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$60,d0
		move.w	d0,y_pos(a1)
		st	$33(a1)

DEZ2_Resize_wait:
		rts
; ---------------------------------------------------------------------------

DEZ2_Resize_FloorExplosion:
		tst.w	(Demo_timer).w
		bne.s	DEZ2_Resize_wait
		move.l	#DEZ2_Resize_CheckSonicPos,(Level_data_addr_RAM.Resize).w
		st	(Screen_event_flag).w
		move.w	#$840,d0
		move.w	d0,(Camera_max_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		lea	(Player_1).w,a1
		move.w	#$300,d0
		cmp.w	y_vel(a1),d0
		bge.s	DEZ2_Resize_CheckSonicPos
		move.w	d0,y_vel(a1)

DEZ2_Resize_CheckSonicPos:
		cmpi.w	#$830,(Camera_Y_pos).w
		blo.s		DEZ2_Resize_wait
		move.w	(Camera_max_Y_pos).w,(Camera_min_Y_pos).w
		move.l	#DEZ2_Resize_wait,(Level_data_addr_RAM.Resize).w
		addq.b	#2,(Background_event_routine).w
		move.l	#Obj_SonicFlying,(v_Breathing_bubbles).w
		rts
; ---------------------------------------------------------------------------

DEZ2_Resize_CheckSonicFall:
		addq.w	#8,(v_Breathing_bubbles+$34).w
		cmpi.w	#$9F0,(Camera_Y_pos).w
		blo.s		DEZ2_Resize_CheckSonicFall_Return
		move.l	#DEZ2_Resize_setfade,(Level_data_addr_RAM.Resize).w

DEZ2_Resize_CheckSonicFall_Return:
		rts
; ---------------------------------------------------------------------------

DEZ2_Resize_setfade:
		move.l	#DEZ2_Resize_createEndSign,(Level_data_addr_RAM.Resize).w
		music	bgm_Fade,0,0,0	; fade out music
		clr.b	(NoPause_flag).w
		clr.b	(Intro_flag).w
		sfx	sfx_Wave,0,0,0
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_BossGreyBall_Asteroids_Load,address(a1)
+		lea	(Pal_DEZ2_End).l,a1
		lea	(Normal_palette_line_2).w,a2
		jsr	(PalLoad_Line16+8).w		; 8 colors
		lea	(PLC_BossGreyBall_Asteroid).l,a5
		jmp	(LoadPLC_Raw_KosM).w
; ---------------------------------------------------------------------------

DEZ2_Resize_createEndSign:
		tst.b	(Clone_Driver_RAM+SMPS_RAM.variables.v_fadeout_counter).w
		bne.s	+
		move.l	#DEZ2_Resize_EndLevel,(Level_data_addr_RAM.Resize).w
		clr.b	(TitleCard_end_flag).w
		st	(NoBackground_event_flag).w
		st	(Level_end_flag).w		; End of level is in effect
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_LevelResults,address(a1)
+		rts
; ---------------------------------------------------------------------------

DEZ2_Resize_EndLevel:
		tst.b	(Level_end_flag).w
		bne.s	DEZ2_Resize_CheckSonicFall_Return
		move.b	#id_EndingScreen,(Game_mode).w	; set Game Mode
	if GameDebug=0
		jsr	(TimeScreen_SetDataToRAM).l
		jmp	(SRAM_Save).l
	else
		rts
	endif

; =============== S U B R O U T I N E =======================================

DEZ3_Resize:
		move.l	#DEZ3_Resize_loadminiboss,(Level_data_addr_RAM.Resize).w
		music	bgm_Fade,0,0,0	; fade out music
		rts
; ---------------------------------------------------------------------------

DEZ3_Resize_loadminiboss:
		tst.b	(Clone_Driver_RAM+SMPS_RAM.variables.v_fadeout_counter).w
		bne.s	DEZ3_Resize_loadminiboss_Return
		music	bgm_MiniBallBoss,0,0,0

		tst.b	(SegaCD_flag).w
		beq.s	+
		bset	#0,(Clone_Driver_RAM+SMPS_RAM.variables.v_cda_ignore).w
+
		st	(SpinDash_flag).w
		move.l	#DEZ3_Resize_wait,(Level_data_addr_RAM.Resize).w
		jsr	(Create_New_Sprite).w
		bne.s	DEZ3_Resize_loadminiboss_Return
		move.l	#Obj_BossMiniOrbinaut_Process,address(a1)

DEZ3_Resize_loadminiboss_Return:
		rts
; ---------------------------------------------------------------------------

DEZ3_Resize_lockplayerpos:
		music	bgm_Fade,0,0,0	; fade out music
		move.l	#DEZ3_Resize_lockplayerpos_CheckFade,(Level_data_addr_RAM.Resize).w

DEZ3_Resize_lockplayerpos_Return:
		rts
; ---------------------------------------------------------------------------

DEZ3_Resize_lockplayerpos_CheckFade:
		tst.b	(Clone_Driver_RAM+SMPS_RAM.variables.v_fadeout_counter).w
		bne.s	DEZ3_Resize_lockplayerpos_Return
		move.l	#DEZ3_Resize_lockplayerpos_AddRings,(Level_data_addr_RAM.Resize).w

DEZ3_Resize_lockplayerpos_AddRings:
		moveq	#1,d0
		jsr	(AddRings).w
		moveq	#10,d0
		cmp.w	(Ring_count).w,d0
		bhs.s	DEZ3_Resize_lockplayerpos_Return
		move.w	d0,(Ring_count).w
		move.l	#DEZ3_Resize_setplayerpos,(Level_data_addr_RAM.Resize).w
		clr.b	(Update_HUD_timer).w	; Stop
		st	(Ctrl_1_locked).w

DEZ3_Resize_setplayerpos:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		move.w	#btnL<<8,d1
		addi.w	#$A0,d0
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s		+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		rts
; ---------------------------------------------------------------------------
+		btst	#Status_InAir,status(a1)
		bne.s	-
		move.l	#DEZ3_Resize_loadboss,(Level_data_addr_RAM.Resize).w
		clr.w	(Ctrl_1_logical).w
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)

;		move.w	#id_Walk<<8,anim(a1)

		move.b	#id_Walk,anim(a1)

		bclr	#Status_Facing,status(a1)
		jmp	(Stop_Object).w
; ---------------------------------------------------------------------------

DEZ3_Resize_loadboss:
		move.b	#3,(Current_act).w
		clr.b	(Intro_flag).w
		jsr	(LoadLevelPointer).w
		move.l	#DEZ4_Resize_wait,(Level_data_addr_RAM.Resize).w
		addq.b	#2,(Background_event_routine).w
		music	bgm_BallBoss,0,0,0
		jsr	(Create_New_Sprite).w
		bne.s	DEZ3_Resize_wait
		move.l	#Obj_BossFinalBall,address(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$30,d0
		move.w	d0,y_pos(a1)
		st	$33(a1)

DEZ3_Resize_wait:
		rts

; =============== S U B R O U T I N E =======================================

DEZ4_Resize:
		move.l	#DEZ4_Resize_lockplayerpos,(Level_data_addr_RAM.Resize).w
		music	bgm_Fade,0,0,0	; fade out music
		rts
; ---------------------------------------------------------------------------

DEZ4_Resize_lockplayerpos:
		tst.b	(Clone_Driver_RAM+SMPS_RAM.variables.v_fadeout_counter).w
		bne.s	DEZ3_Resize_wait
		move.l	#DEZ4_Resize_setplayerpos,(Level_data_addr_RAM.Resize).w
		clr.b	(Update_HUD_timer).w	; Stop
		st	(Ctrl_1_locked).w

DEZ4_Resize_setplayerpos:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		move.w	#btnL<<8,d1
		addi.w	#$A0,d0
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s		+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		rts
; ---------------------------------------------------------------------------
+		btst	#Status_InAir,status(a1)
		bne.s	-
		move.l	#DEZ4_Resize_loadboss,(Level_data_addr_RAM.Resize).w
		clr.w	(Ctrl_1_logical).w
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)

;		move.w	#id_Walk<<8,anim(a1)

		move.b	#id_Walk,anim(a1)


		bclr	#Status_Facing,status(a1)
		jmp	(Stop_Object).w
; ---------------------------------------------------------------------------

DEZ4_Resize_loadboss:
		tst.b	(Clone_Driver_RAM+SMPS_RAM.variables.v_fadeout_counter).w
		bne.s	DEZ4_Resize_wait
		music	bgm_BallBoss,0,0,0
		move.l	#DEZ4_Resize_wait,(Level_data_addr_RAM.Resize).w
		addq.b	#2,(Background_event_routine).w
		jsr	(Create_New_Sprite).w
		bne.s	DEZ4_Resize_wait
		move.l	#Obj_BossFinalBall,address(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$30,d0
		move.w	d0,y_pos(a1)
		st	$33(a1)

DEZ4_Resize_wait:
		rts
; ---------------------------------------------------------------------------

DEZ4_Resize_End:
		move.l	#DEZ4_Resize_createEndSign,(Level_data_addr_RAM.Resize).w
		music	bgm_Fade,0,0,0	; fade out music
		rts
; ---------------------------------------------------------------------------

DEZ4_Resize_createEndSign:
		tst.b	(Clone_Driver_RAM+SMPS_RAM.variables.v_fadeout_counter).w
		bne.s	DEZ4_Resize_wait
		move.l	#DEZ2_Resize_EndLevel,(Level_data_addr_RAM.Resize).w
		clr.b	(NoPause_flag).w
		clr.b	(Intro_flag).w
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_EndSignControl,address(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$A0,d2
		move.w	d2,x_pos(a1)
+		rts