; ---------------------------------------------------------------------------
; Transition Screen
; ---------------------------------------------------------------------------

vTransition_Wait:				= Object_load_addr_front		; word
vTransition_Count:			= Object_load_addr_front+2	; byte
vTransition_End:				= Object_load_addr_front+3	; byte

; =============== S U B R O U T I N E =======================================

Transition_Screen:
		move.b	#1,(FirsStart_Flag).w
		jsr	(SRAM_Save).l

Transition_Screen_Restart:
		tst.b	(QuickStart_mode).w
		bne.s	*
		music	bgm_Fade,0,0,0
		moveq	#palid_Sonic,d0
		move.w	d0,d1
		jsr	(LoadPalette).w								; load Sonic's palette
		move.w	d1,d0
		jsr	(LoadPalette_Immediate).w
		move.l	#AnPal_DEZ,(Level_data_addr_RAM.AnPal).w
		lea	PLC_Transition(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(PLC_Main).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(PLC_Main2).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(Pal_Transition).l,a1
		lea	(Normal_palette_line_2).w,a2
		jsr	(PalLoad_Line48).w
		move.b	#1,(Level_started_flag).w
		move.w	#1*60,(vTransition_Wait).w

-		jsr	(Pause_Game).w
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		jsr	(Animate_Palette).l
		bsr.w	TransitionScreen_ScreenEvents
		bsr.w	TransitionScreen_Process
		move.w	(Camera_Y_pos).w,d1
		subi.w	#128,d1
		andi.w	#-128,d1
		move.w	d1,(Camera_Y_pos_coarse_back).w
		move.w	(Camera_X_pos).w,d1
		subi.w	#128,d1
		andi.w	#-128,d1
		move.w	d1,(Camera_X_pos_coarse_back).w
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(SynchroAnimate).w
		jsr	(Render_Sprites).w
		tst.b	(Restart_level_flag).w
		bne.w	Transition_SkipIntro
		tst.b	(vTransition_End).w
		beq.s	-
		clr.b	(vTransition_End).w

-		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		jsr	(Animate_Palette).l
		bsr.w	TransitionScreen_ScreenEvents
		bsr.w	TransitionScreen_Process
		clr.w	(H_scroll_amount).w
		clr.w	(V_scroll_amount).w
		lea	(Player_1).w,a0
		lea	(Camera_X_pos).w,a1
		lea	(Camera_min_X_pos).w,a2
		lea	(H_scroll_amount).w,a4
		lea	(H_scroll_frame_offset).w,a5
		lea	(Pos_table).w,a6
		jsr	(MoveCameraX).w
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		tst.b	(vTransition_End).w
		beq.s	-
		clr.w	(Camera_Y_pos_coarse_back).w
		clr.w	(Camera_X_pos_coarse_back).w
		clr.l	(HScroll_Shift).w
		clr.w	(HScroll_Shift+4).w
		clr.b	(Object_load_routine).w
		clr.l	(Object_load_addr_front).w
		clr.l	(Object_load_addr_front+4).w
		clr.l	(Object_load_addr_front+8).w
		clr.l	(Object_load_addr_front+$C).w
		moveq	#palid_Sonic,d0
		move.w	d0,d1
		jsr	(LoadPalette).w								; load Sonic's palette
		move.w	d1,d0
		jsr	(LoadPalette_Immediate).w
		lea	(PLC_Main).l,a5
		jsr	(LoadPLC_Raw_KosM).w						; load hud and ring art
		disableInts
		jsr	(HUD_DrawInitial).w
		enableInts
		move.b	#id_LevelScreen,(Game_mode).w
		jsr	(LoadLevelPointer).w

;		jsr	(Get_LevelSizeStart).l

		move.w	#$800,d0
		sub.w	d0,(Player_1+x_pos).w
		sub.w	d0,(Camera_X_pos).w
		sub.w	d0,(Camera_X_pos_copy).w


		moveq	#0,d0
		move.b	d0,(Deform_Lock).w
		move.b	d0,(Scroll_Lock).w
		move.b	d0,(Fast_V_scroll_flag).w
		jsr	(Change_ActSizes).w
		move.w	#$60,(Distance_from_screen_top).w
		move.w	#-1,(Screen_X_wrap_value).w
		move.w	#-1,(Screen_Y_wrap_value).w







		jsr	(DeformBgLayer).w
		jsr	(LoadLevelLoadBlock2).w
		lea	(Pal_DEZ).l,a1
		jsr	(PalLoad_Line1).w
		lea	(Pal_DEZ+$40).l,a1
		jsr	(PalLoad_Line3).w

;		disableInts
;		jsr	(LevelSetup).l
;		enableInts

		move.w	#$FFF,(Screen_Y_wrap_value).w
		move.w	#$FF0,(Camera_Y_pos_mask).w
		move.w	#$7C,(Layout_row_index_mask).w
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		move.w	(Camera_Y_pos_copy).w,(V_scroll_value).w
		move.w	(Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
		jsr	(Load_Solids).w
		moveq	#0,d0
		move.w	d0,(Ctrl_1_logical).w
		move.w	d0,(Ctrl_1).w
		move.b	d0,(HUD_RAM.status).w
		move.b	d0,(HUDBoss_RAM.status).w
		move.b	d0,(HUDDeath_RAM.status).w
		move.w	#10,(Ring_count).w						; set rings
		move.l	d0,(Timer).w								; clear time
		move.b	d0,(Saved_status_secondary).w
		move.w	d0,(Death_Count).w
		move.b	d0,(Time_over_flag).w
		jsr	(OscillateNumInit).w
		moveq	#1,d0
		move.b	d0,(Ctrl_1_locked).w
		move.b	d0,(Update_HUD_score).w					; update score counter
		move.b	d0,(Update_HUD_ring_count).w			; update rings counter
		move.b	d0,(Update_HUD_timer).w					; update time counter
		move.b	d0,(Update_death_count).w
		move.b	d0,(Level_started_flag).w
		jsr	(Load_Sprites).w
		jsr	(Load_Rings).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Animate_Tiles).l

;		move.w	#$202F,(Palette_fade_info).w
;		move.w	#$16,(Palette_fade_timer).w
;		move.w	#$7F00,(Ctrl_1).w
;		andi.b	#$7F,(Last_star_post_hit).w


		move.w	#$600,(Sonic_Knux_top_speed).w
		move.w	#$C,(Sonic_Knux_acceleration).w
		move.w	#$80,(Sonic_Knux_deceleration).w

TransitionScreen_Loop:
		jsr	(Pause_Game).w
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		jsr	(Animate_Palette).l
		jsr	(Load_Sprites).w
		jsr	(Process_Sprites).w
		tst.b	(Restart_level_flag).w
		bne.w	GM_Level
		jsr	(DeformBgLayer).w
		jsr	(ScreenEvents).l
		jsr	(Handle_Onscreen_Water_Height).l
		jsr	(Load_Rings).w
		jsr	(Animate_Tiles).l
		jsr	(Process_Kos_Module_Queue).w
		jsr	(OscillateNumDo).w
		jsr	(SynchroAnimate).w
		jsr	(Render_Sprites).w
		btst	#Status_InAir,(Player_1+status).w
		bne.s	TransitionScreen_Loop
		move.l	#Obj_TitleCard,(Dynamic_object_RAM+(object_size*5)).w		; load title card object
		addq.w	#1,(Dynamic_object_RAM+(object_size*5)+objoff_3E).w
		st	(FirsStart_Flag).w
		jsr	(SRAM_Save).l
		bra.w	Level_Loop

; =============== S U B R O U T I N E =======================================

Transition_SkipIntro:
		tst.b	(QuickStart_mode).w
		beq.s	Transition_SkipIntro_Restart
		clr.w	(Current_zone_and_act).w
		move.b	#id_LevelScreen,(Game_mode).w		; set Game Mode
		st	(Restart_level_flag).w
		rts
; ---------------------------------------------------------------------------

Transition_SkipIntro_Restart:
		clr.b	(HUD_RAM.status).w
		clr.b	(Level_started_flag).w
		bra.w	Options_Screen

; =============== S U B R O U T I N E =======================================

TransitionScreen_ScreenEvents:
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		lea	(Plane_buffer).w,a0
		movea.l	(Block_table_addr_ROM).w,a2
		movea.l	(Level_layout2_addr_ROM).w,a3
		move.w	#vram_fg,d7
		bsr.s	TransitionScreenScreenEvent
		addq.w	#2,a3
		move.w	#vram_bg,d7
		bsr.s	TransitionScreenBackgroundEvent
		move.w	(Camera_Y_pos_copy).w,(V_scroll_value).w
		move.w	(Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
		rts
; ---------------------------------------------------------------------------

TransitionScreenScreenInit:
		jsr	(Reset_TileOffsetPositionActual).w
		jmp	(Refresh_PlaneFull).w
; ---------------------------------------------------------------------------

TransitionScreenScreenEvent:
		move.w	(Screen_shaking_flag+2).w,d0
		add.w	d0,(Camera_Y_pos_copy).w
		jmp	(DrawTilesAsYouMove).w
; ---------------------------------------------------------------------------

TransitionScreenBackgroundInit:
		bsr.w	TransitionScreen_Deform
		jsr	(Reset_TileOffsetPositionEff).w
		moveq	#0,d1	; Set XCam BG pos
		jsr	(Refresh_PlaneFull).w
		jmp	(ShakeScreen_Setup).w
; ---------------------------------------------------------------------------

TransitionScreenBackgroundEvent:
		bsr.w	TransitionScreen_Deform
		jmp	(ShakeScreen_Setup).w

; =============== S U B R O U T I N E =======================================

TransitionScreen_Deform:
		cmpi.b	#id_SonicDeath,(Player_1+routine).w	; has Sonic just died?
		bhs.s	+									; if yes, branch
		bsr.s	TransitionScreen_Deform2
+
		move.w	(HScroll_Shift).w,d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,(HScroll_Shift+2).w
		lea	Title_BGDrawArray(pc),a4
		lea	(H_scroll_table).w,a5
		jmp	(ApplyDeformation).w
; ---------------------------------------------------------------------------

TransitionScreen_Deform2:
		lea	Title_ParallaxScript(pc),a1
		jmp	(ExecuteParallaxScript).w

; =============== S U B R O U T I N E =======================================

TransitionScreen_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	TransitionScreen_Process_Index(pc,d0.w),d0
		jmp	TransitionScreen_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

TransitionScreen_Process_Index: offsetTable
		offsetTableEntry.w TransitionScreen_Process_Wait				; 0
		offsetTableEntry.w TransitionScreen_Process_Return				; 2
		offsetTableEntry.w TransitionScreen_Process_CreateStars			; 4
		offsetTableEntry.w TransitionScreen_Process_CreateRocket			; 6
		offsetTableEntry.w TransitionScreen_Process_AttackRocket			; 8
		offsetTableEntry.w TransitionScreen_Process_AttackRocket_End		; A
		offsetTableEntry.w TransitionScreen_Process_MoveCenter			; C
		offsetTableEntry.w TransitionScreen_Process_AddRings			; E
		offsetTableEntry.w TransitionScreen_Process_MoveWait			; 10
		offsetTableEntry.w TransitionScreen_Process_MoveCamera			; 12
		offsetTableEntry.w TransitionScreen_Process_CheckSonic			; 14
		offsetTableEntry.w TransitionScreen_Process_CheckSonic_Return	; 16
; ---------------------------------------------------------------------------

TransitionScreen_Process_Wait:
		subq.w	#1,(vTransition_Wait).w
		bne.s	TransitionScreen_Process_Return
		addq.b	#2,(Object_load_routine).w
		move.w	(Camera_X_pos).w,d0
		move.w	d0,(Camera_min_X_pos).w
		move.w	d0,(Camera_max_X_pos).w
		bsr.w	SpawnLevelMainSprites
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)
		move.b	#id_Hurt,anim(a1)
		bclr	#Status_OnObj,status(a1)
		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
		bset	#Status_InAir,status(a1)
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w

; Load
		jsr	(Create_New_Sprite).w
		bne.s	TransitionScreen_Process_Return
		move.l	#Obj_Crane_TransitionScreen,address(a1)

TransitionScreen_Process_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_Process_CreateRocket:
		addq.b	#2,(Object_load_routine).w
		jsr	(Create_New_Sprite).w
		bne.s	TransitionScreen_Process_AttackRocket
		move.l	#Obj_TransitionScreen_LoadRocket,address(a1)

TransitionScreen_Process_AttackRocket:
		bsr.w	Transition_Asteroids_Load

TransitionScreen_Process_CreateStars:
		tst.b	(Player_1+invulnerability_timer).w
		bne.s	TransitionScreen_Process_CheckPress_Return
		move.b	(V_int_run_count+3).w,d0
		andi.b	#7,d0
		bne.s	TransitionScreen_Process_CheckPress_Return
		lea	(Player_1).w,a0
		lea	ChildObjDat_TransitionRocketStars(pc),a2
		jsr	(CreateChild7_Normal2).w

TransitionScreen_Process_CheckPress_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_Process_AttackRocket_End:
		addq.b	#2,(Object_load_routine).w
		bset	#6,(v_Breathing_bubbles+$38).w
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w

TransitionScreen_Process_MoveCenter:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$70,d0
		sub.w	(Player_1+y_pos).w,d0
		asl.w	#4,d0
		move.w	d0,(Player_1+y_vel).w
		move.w	(Camera_X_pos).w,d0
		addi.w	#$20,d0
		sub.w	(Player_1+x_pos).w,d0
		beq.s	TransitionScreen_Process_MoveCenter_Next
		asl.w	#4,d0
		move.w	d0,(Player_1+ground_vel).w

TransitionScreen_Process_MoveCenter_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_Process_MoveCenter_Next:
		addq.b	#2,(Object_load_routine).w
		move.w	#$2000,(HScroll_Shift).w
		move.w	#3*60,(vTransition_Wait).w
		music	bgm_Fade,0,0,0

TransitionScreen_Process_MoveCenter_Next_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_Process_AddRings:
		moveq	#1,d0
		jsr	(AddRings).w
		moveq	#10,d0
		cmp.w	(Ring_count).w,d0
		bhs.s	TransitionScreen_Process_MoveCenter_Next_Return
		move.w	d0,(Ring_count).w
		addq.b	#2,(Object_load_routine).w

TransitionScreen_Process_MoveWait:
		cmpi.w	#3*60-10,(vTransition_Wait).w
		bne.s	.NotHideHUD
		st	(HUD_RAM.status).w

.NotHideHUD:
		subq.w	#1,(vTransition_Wait).w
		bne.s	TransitionScreen_Process_MoveCenter_Return
		addq.b	#2,(Object_load_routine).w
		lea	(Pal_DEZ+$20).l,a1
		jsr	(PalLoad_Line2).w

TransitionScreen_Process_MoveCamera:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$10,(Camera_X_pos).w
		move.w	d0,(Camera_min_X_pos).w
		move.w	d0,(Camera_max_X_pos).w
		move.w	(Camera_X_pos_copy).w,d0
		addi.w	#$20,d0
		move.w	d0,(v_Breathing_bubbles+$30).w
		move.w	d0,(v_Breathing_bubbles+x_pos).w

; Check
		cmpi.w	#$460,(Camera_X_pos_copy).w
		ble.s		+
		moveq	#signextendB(sfx_WallSmash),d0
		moveq	#7,d2
		jsr	(Wait_Play_Sound).w
+
		cmpi.w	#$760,(Camera_X_pos_copy).w
		ble.s		TransitionScreen_Process_MoveCamera_Return
		addq.b	#2,(Object_load_routine).w
		st	(vTransition_End).w
		lea	(v_Breathing_bubbles).w,a1
		jsr	(Delete_Referenced_Sprite).w
		sfx	sfx_WallSmash,0,0,0
		move.l	#Obj_TransitionJetPack,(v_WaterWave).w
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_DEZParticlesExplosion,address(a1)
+		move.w	#$880,d0
		move.w	d0,(Camera_max_X_pos).w
		move.w	d0,(Camera_target_max_X_pos).w
		move.w	#$300,d0
		move.w	d0,(Camera_max_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		lea	(Player_1).w,a1
		move.b	#id_SonicHurt,routine(a1)	; Hit animation
		move.b	#id_Hurt,anim(a1)
		clr.b	object_control(a1)
		bclr	#Status_OnObj,status(a1)
		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
		bset	#Status_InAir,status(a1)
		move.w	#$800,x_vel(a1)			; Set speed of player
		move.w	#-$800,y_vel(a1)
		clr.w	ground_vel(a1)			; Zero out inertia

TransitionScreen_Process_MoveCamera_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_Process_CheckSonic:
		lea	(Player_1).w,a1
		cmpi.w	#$8EC,x_pos(a1)
		ble.s		TransitionScreen_Process_CheckSonic_Return
		subi.w	#$100,x_vel(a1)
		bpl.s	TransitionScreen_Process_CheckSonic_Return
		clr.w	x_vel(a1)					; Zero out speed
		clr.w	ground_vel(a1)			; Zero out inertia
		move.b	#id_SonicHurt,routine(a1)	; Hit animation
		addq.b	#2,(Object_load_routine).w
		st	(vTransition_End).w

TransitionScreen_Process_CheckSonic_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_Crane_TransitionScreen:
		move.l	#Map_SSZRobotnikShipCrane,mappings(a0)
		move.w	#$227,art_tile(a0)
		move.w	#$80,priority(a0)
		move.b	#4,render_flags(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		subi.w	#$40,d0
		move.w	d0,y_pos(a0)
		move.b	#32/2,width_pixels(a0)
		move.b	#32/2,height_pixels(a0)
		move.w	#$1F,$2E(a0)
		move.l	#Crane_TransitionScreen_Wait,address(a0)

Crane_TransitionScreen_Wait:
		subq.w	#1,$2E(a0)
		bpl.w	Crane_TransitionScreen_HoldSonic
		sfx	sfx_Arm,0,0,0
		move.l	#Crane_TransitionScreen_Down,address(a0)
		lea	Crane_InsertCoinScreen_ObjData(pc),a2
		moveq	#2-1,d6

-		jsr	(Create_New_Sprite3).w
		bne.s	Crane_TransitionScreen_Down
		move.l	(a2)+,address(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	a0,parent3(a1)
		dbf	d6,-

Crane_TransitionScreen_Down:
		addq.w	#4,y_pos(a0)
		addq.b	#4,child_dy(a0)
		cmpi.b	#176,child_dy(a0)
		blo.s		Crane_TransitionScreen_HoldSonic
		addq.b	#2,mapping_frame(a0)
		sfx	sfx_Attachment2,0,0,0
		move.l	#Crane_TransitionScreen_Up,address(a0)

		sfx	sfx_Trans,0,0,0

;		lea	(Object_RAM).w,a1
;		move.b	#id_SonicControl,routine(a1)
;		move.b	#id_Sparkster,anim(a1)


		move.l	#Obj_SonicRocket,(v_Breathing_bubbles).w

		clr.b	(Ctrl_1_locked).w

;		clr.b	(Player_1+object_control).w

Crane_TransitionScreen_Up:
		tst.b	render_flags(a0)							; Object visible on the screen?
		bpl.s	Crane_TransitionScreen_Remove		; If not, branch
		subq.w	#4,y_pos(a0)
		subq.b	#4,child_dy(a0)
		bhs.s	Crane_TransitionScreen_Draw
		clr.b	child_dy(a0)

Crane_TransitionScreen_Remove:
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------

Crane_TransitionScreen_HoldSonic:
		lea	(Object_RAM).w,a1
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),d0
		addi.w	#17,d0
		move.w	d0,y_pos(a1)

Crane_TransitionScreen_Draw:
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_DEZParticlesExplosion:
		moveq	#32-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	+
		move.l	#Obj_DEZParticles_SetFall,address(a1)
		move.l	#Map_CluesTestingCursor,mappings(a1)
		move.w	#$C002,art_tile(a1)
		move.b	#4,render_flags(a1)
		bset	#5,render_flags(a1)				; set static mappings flag
		move.w	#$100,priority(a1)
		move.b	#8/2,width_pixels(a1)
		move.b	#8/2,height_pixels(a1)
		move.w	(Camera_X_pos).w,x_pos(a1)
		move.w	(Camera_Y_pos).w,d3
		addi.w	#$60,d3
		move.w	d3,y_pos(a1)
		dbf	d1,-
+		bra.s	DEZParticles_CheckDelete_Remove
; ---------------------------------------------------------------------------

Obj_DEZParticles_SetFall:
		jsr	(Random_Number).w
		andi.w	#$7FF,d0
		addi.w	#$100,d0
		move.w	d0,x_vel(a0)
		jsr	(Random_Number).w
		andi.w	#$7FF,d0
		addi.w	#$100,d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		andi.w	#$7F,d1
		addi.w	#$A0,d1
		add.w	d1,art_tile(a0)
		move.l	#Obj_DEZParticles_Fall,address(a0)

Obj_DEZParticles_Fall:
		moveq	#$70,d1
		jsr	(MoveSprite_CustomGravity).w
		bsr.s	DEZParticles_CheckDelete
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

DEZParticles_CheckDelete:
		cmpi.w	#$160,y_pos(a0)
		blo.s		DEZParticles_Delete_Return

DEZParticles_CheckDelete_Remove:
		move.l	#Delete_Current_Sprite,address(a0)
		addq.w	#4,sp

DEZParticles_Delete_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_TransitionScreen_LoadRocket:
		move.w	#$9F,$2E(a0)
		move.l	#TransitionScreen_LoadRocket_Process,address(a0)

TransitionScreen_LoadRocket_Process:
		subq.w	#1,$2E(a0)
		bpl.s	TransitionScreen_LoadRocket_Process_Return

TransitionScreen_LoadRocket_Process_Main:

; load index
		move.b	routine(a0),d0
		addq.b	#1,routine(a0)
		andi.w	#$FF,d0
		add.w	d0,d0
		lea	TransitionScreen_LoadRocket_Index(pc),a3
		adda.w	(a3,d0.w),a3

; load data
		move.w	(a3)+,d6
		bmi.s	TransitionScreen_LoadRocket_Process_Remove

-		jsr	(Create_New_Sprite).w
		bne.s	TransitionScreen_LoadRocket_Process_End

		move.w	(a3)+,d3
		move.l	TransitionScreen_Obj_Index(pc,d3.w),address(a1)

		move.w	(Camera_X_pos).w,d3
		add.w	(a3)+,d3
		move.w	d3,x_pos(a1)
		move.w	(Camera_Y_pos).w,d3
		add.w	(a3)+,d3
		move.w	d3,y_pos(a1)
		move.w	(a3)+,$2E(a1)
		move.b	(a3)+,subtype(a1)
		move.b	(a3)+,d3
		bmi.s	.skipbitfield
		andi.w	#1,d3
		bset	d3,render_flags(a1)

.skipbitfield:
		addq.b	#1,(vTransition_Count).w
		dbf	d6,-

TransitionScreen_LoadRocket_Process_End:
		move.l	#TransitionScreen_LoadRocket_Process_WaitRestart,address(a0)

TransitionScreen_LoadRocket_Process_WaitRestart:
		tst.b	(vTransition_Count).w
		bne.s	TransitionScreen_LoadRocket_Process_Return
		move.w	#7,$2E(a0)
		move.l	#TransitionScreen_LoadRocket_Process,address(a0)

TransitionScreen_LoadRocket_Process_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_LoadRocket_Process_Remove:
		addq.b	#2,(Object_load_routine).w
		move.l	#Delete_Current_Sprite,address(a0)
		rts
; ---------------------------------------------------------------------------

TransitionScreen_Obj_Index:
		dc.l Obj_TransitionRocket					; 0
		dc.l Obj_TransitionRocket_ShotBall			; 1
; ---------------------------------------------------------------------------

TransitionScreen_LoadRocket_Index: offsetTable
		offsetTableEntry.w .Data1					; 0
		offsetTableEntry.w .Data2					; 1
		offsetTableEntry.w .Data3					; 2
		offsetTableEntry.w .Data4					; 3
		offsetTableEntry.w .Data5					; 4
		offsetTableEntry.w .Data6					; 5
		offsetTableEntry.w .Data14					; 6
		offsetTableEntry.w .Data7					; 7
		offsetTableEntry.w .DataA					; 8
		offsetTableEntry.w .DataC					; 11
		offsetTableEntry.w .DataD					; 12
		offsetTableEntry.w .Data15					; 13
		offsetTableEntry.w .DataE					; 14
		offsetTableEntry.w .DataF					; 15
		offsetTableEntry.w .Data11					; 16
		offsetTableEntry.w .Data14					; 17
		offsetTableEntry.w .Data12					; 18
		offsetTableEntry.w .Data13					; 19
		offsetTableEntry.w .Data12					; 20
		offsetTableEntry.w .Data16					; 21

		offsetTableEntry.w .End
; ---------------------------------------------------------------------------

RocketMap_Header macro {INTLABEL}
__LABEL__ label *
	dc.w (((__LABEL___End - __LABEL__) / $A) - 1)
    endm

RocketMap macro id, xpos, ypos, wait, subtype, render
		dc.w id<<2
		dc.w xpos, ypos, wait
		dc.b subtype, render
    endm
; ---------------------------------------------------------------------------

.End:
		dc.w -1
; ---------------------------------------------------------------------------

.Data1: RocketMap_Header
		RocketMap 0, $180, $20, $F, 1, 0		; 1
.Data1_End
; ---------------------------------------------------------------------------

.Data2: RocketMap_Header
		RocketMap 0, $180, $C0, $F, 1, 0		; 1
.Data2_End
; ---------------------------------------------------------------------------

.Data3: RocketMap_Header
		RocketMap 0, $180, $40, $F, 1, 0		; 1
		RocketMap 0, $180, $A0, $F, 1, 0		; 2
.Data3_End
; ---------------------------------------------------------------------------

.Data4: RocketMap_Header
		RocketMap 0, $180, $20, $F, 1, 0		; 1
		RocketMap 0, $180, $50, $4F, 1, 0		; 2
		RocketMap 0, $180, $90, $4F, 1, 0		; 3
		RocketMap 0, $180, $C0, $F, 1, 0		; 4
.Data4_End
; ---------------------------------------------------------------------------

.Data5: RocketMap_Header
		RocketMap 0, $180, $20, $F, 1, 0		; 1
		RocketMap 0, $180, $60, $2F, 1, 0		; 2
		RocketMap 0, $180, $A0, $4F, 1, 0		; 3
.Data5_End
; ---------------------------------------------------------------------------

.Data6: RocketMap_Header
		RocketMap 0, $180, $40, $4F, 1, 0		; 1
		RocketMap 0, $180, $80, $2F, 1, 0		; 2
		RocketMap 0, $180, $C0, $F, 1, 0		; 3
.Data6_End
; ---------------------------------------------------------------------------

.Data7: RocketMap_Header
		RocketMap 0, $20, $100, $F, $81, 0		; 1
		RocketMap 0, $40, $100, $3F, $81, 0		; 2
		RocketMap 0, $60, $100, $6F, $81, 0	; 3
		RocketMap 0, $80, $100, $9F, $81, 0	; 4
		RocketMap 0, $A0, $100, $CF, $81, 0	; 5
		RocketMap 0, $C0, $100, $FF, $81, 0	; 6
		RocketMap 0, $E0, $100, $12F, $81, 0	; 7
		RocketMap 0, $100, $100, $15F, $81, 0	; 8
		RocketMap 0, $120, $100, $18F, $81, 0	; 9
.Data7_End
; ---------------------------------------------------------------------------

.Data8: RocketMap_Header
		RocketMap 0, $20, $100, $18F, $81, 0	; 1
		RocketMap 0, $40, $100, $15F, $81, 0	; 2
		RocketMap 0, $60, $100, $12F, $81, 0	; 3
		RocketMap 0, $80, $100, $FF, $81, 0	; 4
		RocketMap 0, $A0, $100, $CF, $81, 0	; 5
		RocketMap 0, $C0, $100, $9F, $81, 0	; 6
		RocketMap 0, $E0, $100, $6F, $81, 0	; 7
		RocketMap 0, $100, $100, $3F, $81, 0	; 8
		RocketMap 0, $120, $100, $F, $81, 0		; 9
.Data8_End
; ---------------------------------------------------------------------------

.Data9: RocketMap_Header
		RocketMap 0, $48, $100, $F, $81, 0		; 1
		RocketMap 0, $A8, $100, $3F, $81, 0	; 2
		RocketMap 0, $108, $100, $F, $81, 0		; 3
		RocketMap 0, $68, $100, $6F, $81, 0		; 4
		RocketMap 0, $E8, $100, $6F, $81, 0	; 5
		RocketMap 0, $28, $100, $9F, $81, 0		; 6
		RocketMap 0, $128, $100, $9F, $81, 0	; 7
.Data9_End
; ---------------------------------------------------------------------------

.DataA: RocketMap_Header
		RocketMap 0, $40, $100, $F, $81, 0		; 1
		RocketMap 0, $A4, $100, $F, $81, 0		; 2
		RocketMap 0, $108, $100, $F, $81, 0		; 3
.DataA_End
; ---------------------------------------------------------------------------

.DataB: RocketMap_Header
		RocketMap 0, $20, $100, $F, $81, 0		; 1
		RocketMap 0, $70, $100, $F, $81, 0		; 2
		RocketMap 0, $D0, $100, $F, $81, 0		; 3
		RocketMap 0, $120, $100, $F, $81, 0		; 4
.DataB_End
; ---------------------------------------------------------------------------

.DataC: RocketMap_Header
		RocketMap 0, $180, $20, $F, 1, 0		; 1
		RocketMap 0, $180, $40, $3F, 1, 0		; 2
		RocketMap 0, $180, $60, $6F, 1, 0		; 3
		RocketMap 0, $180, $80, $9F, 1, 0		; 4
		RocketMap 0, $180, $A0, $CF, 1, 0		; 5
		RocketMap 0, $180, $C0, $FF, 1, 0		; 6
.DataC_End
; ---------------------------------------------------------------------------

.DataD: RocketMap_Header
		RocketMap 0, $180, $20, $FF, 1, 0		; 1
		RocketMap 0, $180, $40, $CF, 1, 0		; 2
		RocketMap 0, $180, $60, $9F, 1, 0		; 3
		RocketMap 0, $180, $80, $6F, 1, 0		; 4
		RocketMap 0, $180, $A0, $3F, 1, 0		; 5
		RocketMap 0, $180, $C0, $F, 1, 0		; 6
.DataD_End
; ---------------------------------------------------------------------------

.DataE: RocketMap_Header
		RocketMap 0, $180, $20, $F, 2, 0		; 1
.DataE_End
; ---------------------------------------------------------------------------

.DataF: RocketMap_Header
		RocketMap 0, $180, $C0, $F, 2, 0		; 1
.DataF_End
; ---------------------------------------------------------------------------

.Data10: RocketMap_Header
		RocketMap 0, $20, $100, $F, $82, 0		; 1
		RocketMap 0, $40, $100, $2F, $82, 0	; 2
		RocketMap 0, $60, $100, $4F, $82, 0	; 3
		RocketMap 0, $80, $100, $6F, $82, 0	; 4
		RocketMap 0, $A0, $100, $8F, $82, 0	; 5
		RocketMap 0, $C0, $100, $AF, $82, 0	; 6
		RocketMap 0, $E0, $100, $CF, $82, 0	; 7
		RocketMap 0, $100, $100, $EF, $82, 0	; 8
		RocketMap 0, $120, $100, $10F, $82, 0	; 9
.Data10_End
; ---------------------------------------------------------------------------

.Data11: RocketMap_Header
		RocketMap 0, $20, $100, $10F, $82, 0	; 1
		RocketMap 0, $40, $100, $EF, $82, 0	; 2
		RocketMap 0, $60, $100, $CF, $82, 0	; 3
		RocketMap 0, $80, $100, $AF, $82, 0	; 4
		RocketMap 0, $A0, $100, $8F, $82, 0	; 5
		RocketMap 0, $C0, $100, $6F, $82, 0	; 6
		RocketMap 0, $E0, $100, $4F, $82, 0	; 7
		RocketMap 0, $100, $100, $2F, $82, 0	; 8
		RocketMap 0, $120, $100, $F, $82, 0	; 9
.Data11_End
; ---------------------------------------------------------------------------

.Data12: RocketMap_Header
		RocketMap 0, $180, $40, $F, 2, 0		; 1
		RocketMap 0, $180, $A0, $F, 2, 0		; 2
.Data12_End
; ---------------------------------------------------------------------------

.Data13: RocketMap_Header
		RocketMap 0, $180, $20, $F, 3, 0		; 1
		RocketMap 0, $180, $C0, $4F, 3, 0		; 2
		RocketMap 0, $180, $60, $8F, 3, 0		; 3
		RocketMap 0, $180, $40, $CF, 3, 0		; 4
		RocketMap 0, $180, $A0, $10F, 3, 0		; 5
		RocketMap 0, $180, $20, $14F, 3, 0		; 6
		RocketMap 0, $180, $60, $18F, 3, 0		; 7
		RocketMap 0, $180, $C0, $1CF, 3, 0		; 8
		RocketMap 0, $180, $40, $20F, 3, 0		; 9
		RocketMap 0, $180, $20, $24F, 3, 0		; 10
		RocketMap 0, $180, $60, $28F, 3, 0		; 11
		RocketMap 0, $180, $C0, $2CF, 3, 0		; 12
		RocketMap 0, $180, $80, $30F, 3, 0		; 13
		RocketMap 0, $180, $20, $34F, 3, 0		; 14
.Data13_End
; ---------------------------------------------------------------------------

.Data14: RocketMap_Header
		RocketMap 1, $140, $100, $F, $20, 0		; 1
		RocketMap 1, $20, $140, $6F, -$20, 0	; 2
.Data14_End
; ---------------------------------------------------------------------------

.Data15: RocketMap_Header
		RocketMap 1, $40, $140, $F, -$10, 0		; 1
		RocketMap 1, $120, $100, $6F, $10, 0	; 2
		RocketMap 1, $A0, $140, $CF, $08, 0	; 3
.Data15_End
; ---------------------------------------------------------------------------

.Data16: RocketMap_Header
		RocketMap 0, $180, $20, $F, 1, 0		; 1
		RocketMap 0, $180, $C0, $F, 1, 0		; 2
.Data16_End
; ---------------------------------------------------------------------------








; =============== S U B R O U T I N E =======================================

TransitionRocket_NoDraw:
		jmp	(Sprite_CheckDeleteXY_NoDraw).w
; ---------------------------------------------------------------------------

Obj_TransitionRocket:
		move.l	#TransitionRocket_Wait,address(a0)
		lea	ObjDat3_TransitionRocket(pc),a1
		jsr	(SetUp_ObjAttributes).w

TransitionRocket_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	TransitionRocket_NoDraw

; Start
		sfx	sfx_Shot,0,0,0
		move.l	#TransitionRocket_Main,address(a0)
		moveq	#0,d3
		move.b	subtype(a0),d3
		move.l	#AniRaw_TransitionRocketH,d2
		lea	ChildObjDat_TransitionRocketFaceH(pc),a2
		lea	TransitionRocket_VelDataH(pc),a4
		tst.b	d3
		bpl.s	.notvertical
		move.l	#AniRaw_TransitionRocketV,d2
		lea	ChildObjDat_TransitionRocketFaceV(pc),a2
		lea	TransitionRocket_VelDataV(pc),a4

.notvertical:
		move.l	d2,$30(a0)
		jsr	(CreateChild1_Normal).w
		bne.s	.fail
		move.l	#AniRaw_TransitionRocketFaceV,d2
		tst.b	d3
		bmi.s	.nothorizontal
		move.l	#AniRaw_TransitionRocketFaceH,d2

.nothorizontal:
		move.l	d2,$30(a1)

.fail:
		lea	ChildObjDat_TransitionRocketFireH(pc),a2
		tst.b	d3
		bpl.s	.notvertical2
		lea	ChildObjDat_TransitionRocketFireV(pc),a2

.notvertical2:
		jsr	(CreateChild1_Normal).w
		bne.s	.fail2
		moveq	#$11,d0
		tst.b	d3
		bmi.s	.nothorizontal2
		moveq	#$13,d0

.nothorizontal2:
		move.b	d0,mapping_frame(a1)

.fail2:
		andi.w	#$F,d3
		add.w	d3,d3
		add.w	d3,d3
		move.l	(a4,d3.w),x_vel(a0)

TransitionRocket_Main:
		jsr	(MoveSprite2).w
		jsr	(Animate_Raw).w
		btst	#7,status(a0)
		bne.s	TransitionRocket_Remove
		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

TransitionRocket_Remove:
		sfx	sfx_Bomb,0,0,0
		lea	(ChildObjDat_DEZRadiusExplosion).l,a2
		jsr	(CreateChild6_Simple).w
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------

TransitionRocket_VelDataH:
		dc.w -$200, 0
		dc.w -$300, 0
		dc.w -$400, 0
		dc.w -$500, 0

TransitionRocket_VelDataV:
		dc.w 0, -$200
		dc.w 0, -$300
		dc.w 0, -$400
		dc.w 0, -$500

; =============== S U B R O U T I N E =======================================

Obj_TransitionRocketFace:
		lea	ObjDat3_TransitionRocketFace(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#TransitionRocketFace_Main,address(a0)

TransitionRocketFace_Main:
		jsr	(Animate_RawMultiDelay).w
		jsr	(Refresh_ChildPositionAdjusted).w
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.s	TransitionRocketFace_Remove
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

TransitionRocketFace_Remove:
		subq.b	#1,(vTransition_Count).w
		bmi.s	TransitionRocketFace_RemoveBUG
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------

TransitionRocketFace_RemoveBUG:
		illegal

; =============== S U B R O U T I N E =======================================

Obj_TransitionRocketFire:
		lea	ObjDat3_TransitionRocketFire(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		movea.w	parent3(a0),a1
		moveq	#$11,d0
		tst.b	subtype(a1)
		bpl.s	.notvertical
		addq.b	#2,d0

.notvertical:
		move.b	d0,mapping_frame(a0)
		move.l	#TransitionRocketFire_Main,address(a0)

TransitionRocketFire_Main:
		move.b	(V_int_run_count+3).w,d0
		andi.b	#7,d0
		bne.s	TransitionRocketFire_Skip
		movea.w	parent3(a0),a1
		lea	ChildObjDat_TransitionRocketSmokeH(pc),a2
		tst.b	subtype(a1)
		bpl.s	.notvertical
		lea	ChildObjDat_TransitionRocketSmokeV(pc),a2

.notvertical:
		jsr	(CreateChild1_Normal).w

TransitionRocketFire_Skip:
		jsr	(Refresh_ChildPositionAdjusted).w
		btst	#0,(V_int_run_count+3).w
		bne.s	TransitionRocketFire_NoDraw
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

TransitionRocketFire_NoDraw:
		jmp	(Child_CheckParent).w

; =============== S U B R O U T I N E =======================================

Obj_TransitionRocketSmoke:
		lea	ObjDat3_TransitionRocketSmoke(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#Go_Delete_Sprite,$34(a0)
		move.l	#AniRaw_TransitionRocketSmoke,$30(a0)
		move.l	#TransitionRocketSmoke_Main,address(a0)
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a1
		tst.b	subtype(a1)
		bmi.s	.nothorizontal
		move.w	x_vel(a1),d2
		asl.w	#1,d2
		neg.w	d2
		move.w	d2,x_vel(a0)
		jsr	(Random_Number).w
		jsr	(GetSineCosine).w
		move.w	y_vel(a1),d2
		add.w	d0,d2
		neg.w	d2
		move.w	d2,y_vel(a0)
		bra.s	TransitionRocketSmoke_Main
; ---------------------------------------------------------------------------

.nothorizontal:
		jsr	(Random_Number).w
		jsr	(GetSineCosine).w
		move.w	x_vel(a1),d2
		add.w	d0,d2
		neg.w	d2
		move.w	d2,x_vel(a0)
		move.w	y_vel(a1),d2
		asl.w	#1,d2
		neg.w	d2
		move.w	d2,y_vel(a0)

TransitionRocketSmoke_Main:
		jsr	(MoveSprite2).w
		jsr	(Animate_RawMultiDelay).w
		jmp	(Child_Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_TransitionRocketStars:
		lea	(Player_1).w,a1
		move.w	#-$400,x_vel(a0)
		jsr	(Random_Number).w
		jsr	(GetSineCosine).w
		move.w	y_vel(a1),d2
		add.w	d0,d2
		neg.w	d2
		move.w	d2,y_vel(a0)
		jsr	(Random_Number).w
		andi.w	#$1F,d0
		subi.w	#$10,d0
		add.w	d0,x_pos(a0)
		swap	d0
		andi.w	#$1F,d0
		subi.w	#$10,d0
		add.w	d0,y_pos(a0)
		move.l	#Map_TRocket,mappings(a0)
		move.w	#$252,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$80,priority(a0)
		move.b	#8/2,width_pixels(a0)
		move.b	#8/2,height_pixels(a0)
		move.l	#Go_Delete_Sprite,$34(a0)
		move.l	#AniRaw_TransitionRocketStars,$30(a0)
		move.l	#TransitionRocketStars_Main,address(a0)

TransitionRocketStars_Main:
		jsr	(MoveSprite2).w
		jsr	(Animate_RawMultiDelay).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------
; Астероиды
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Transition_Asteroids_Load:
		move.b	(V_int_run_count+3).w,d0
		andi.w	#$F,d0
		bne.w	Transition_Asteroids_Load_Return
		jsr	(Create_New_Sprite).w
		bne.w	Transition_Asteroids_Load_Return
		move.l	#BossGreyBall_Asteroids_Draw,address(a1)
		move.l	#Map_BossGreyBall_Asteroid,mappings(a1)
		move.w	#$C2B2,art_tile(a1)
		move.b	#4,render_flags(a1)
		moveq	#16/2,d0
		move.b	d0,width_pixels(a1)
		move.b	d0,height_pixels(a1)
		jsr	(Random_Number).w
		andi.w	#$F8,d0
		add.w	(Camera_Y_pos).w,d0
		move.w	d0,y_pos(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$180,d0
		move.w	d0,x_pos(a1)

-		jsr	(Random_Number).w
		andi.w	#$7FF,d0
		beq.s	-
		addi.w	#$200,d0
		neg.w	d0
		move.w	d0,x_vel(a1)
		jsr	(Random_Number).w
		move.w	#$80,d1
		andi.w	#1,d0
		bne.s	+
		move.w	#$100,d1
+		move.w	d1,priority(a1)
		jsr	(Random_Number).w
		andi.b	#7,d0
		move.b	d0,mapping_frame(a1)

Transition_Asteroids_Load_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_TransitionJetPack:
		lea	(Player_1).w,a1
		move.w	x_pos(a1),d0
		addq.w	#8,d0
		move.w	d0,x_pos(a0)
		move.w	y_pos(a1),d0
		addi.w	#24,d0
		move.w	d0,y_pos(a0)
		move.w	#-$200,x_vel(a0)
		move.w	#-$600,y_vel(a0)
		move.l	#Map_TRocket,mappings(a0)
		move.w	#$8252,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$180,priority(a0)
		move.b	#24/2,width_pixels(a0)
		move.b	#16/2,height_pixels(a0)
		move.b	#$1F,mapping_frame(a0)
		move.l	#TransitionJetPack_Main,address(a0)

TransitionJetPack_Main:
		jsr	(MoveSprite).w
		jmp	(Sprite_CheckDeleteXY).w

; =============== S U B R O U T I N E =======================================

Obj_TransitionRocket_ShotBall:
		subq.w	#1,$2E(a0)
		bpl.s	TransitionRocket_ShotBall_Return
		move.w	#$5F,$2E(a0)
		move.b	subtype(a0),d0
		jsr	(GetSineCosine).w
		move.w	#-$600,d2
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,x_vel(a0)
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,y_vel(a0)
		move.l	#TransitionRocket_ShotBall_Wait,address(a0)
		lea	ChildObjDat_TransitionRocket_ShotBall_Attack(pc),a2
		jsr	(CreateChild6_Simple).w

TransitionRocket_ShotBall_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	TransitionRocket_ShotBall_Return
		move.l	#TransitionRocketFace_Remove,address(a0)

TransitionRocket_ShotBall_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_TransitionRocket_ShotBall_Attack:
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.w	d0,$2E(a0)
		move.l	#TransitionRocket_ShotBall_Attack_Wait,address(a0)

TransitionRocket_ShotBall_Attack_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	TransitionRocket_ShotBall_Attack_NoDraw
		movea.w	parent3(a0),a1
		move.l	x_vel(a1),x_vel(a0)
		sfx	sfx_Shot,0,0,0
		lea	ObjDat3_TransitionRocket_ShotBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#TransitionRocket_ShotBall_Attack_Main,address(a0)

TransitionRocket_ShotBall_Attack_Main:
		jsr	(Random_Number).w
		andi.b	#3,d0
		addi.b	#$20,d0
		move.b	d0,mapping_frame(a0)
		jsr	(MoveSprite2).w
		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

TransitionRocket_ShotBall_Attack_NoDraw:
		jmp	(Sprite_CheckDeleteXY_NoDraw).w
; ---------------------------------------------------------------------------

ObjDat3_TransitionRocket:
		dc.l Map_TRocket
		dc.w $2252
		dc.w $200
		dc.b 32/2
		dc.b 32/2
		dc.b 0
		dc.b $1A|$80
ObjDat3_TransitionRocket_ShotBall:
		dc.l Map_TRocket
		dc.w $252
		dc.w $280
		dc.b 16/2
		dc.b 16/2
		dc.b $20
		dc.b $18|$80
ObjDat3_TransitionRocketFace:
		dc.w $180
		dc.b 16/2
		dc.b 16/2
		dc.b 2
		dc.b 0
ObjDat3_TransitionRocketFire:
		dc.w $180
		dc.b 16/2
		dc.b 16/2
		dc.b $11
		dc.b 0
ObjDat3_TransitionRocketSmoke:
		dc.w $100
		dc.b 16/2
		dc.b 16/2
		dc.b $17
		dc.b 0
ChildObjDat_TransitionRocketFaceH:
		dc.w 1-1
		dc.l Obj_TransitionRocketFace
		dc.b 8, 0
ChildObjDat_TransitionRocketFaceV:
		dc.w 1-1
		dc.l Obj_TransitionRocketFace
		dc.b 8, -8


ChildObjDat_TransitionRocketFireH:
		dc.w 1-1
		dc.l Obj_TransitionRocketFire
		dc.b -24, 0
ChildObjDat_TransitionRocketFireV:
		dc.w 1-1
		dc.l Obj_TransitionRocketFire
		dc.b 4, 24



ChildObjDat_TransitionRocketSmokeH:
		dc.w 1-1
		dc.l Obj_TransitionRocketSmoke
		dc.b -12, 0
ChildObjDat_TransitionRocketSmokeV:
		dc.w 1-1
		dc.l Obj_TransitionRocketSmoke
		dc.b 0, -8

ChildObjDat_TransitionRocketStars:
		dc.w 4-1
		dc.l Obj_TransitionRocketStars
		dc.b 0, 16
		dc.l Obj_TransitionRocketStars
		dc.b 0, 16
		dc.l Obj_TransitionRocketStars
		dc.b 0, 16
		dc.l Obj_TransitionRocketStars
		dc.b 0, 16

ChildObjDat_TransitionRocket_ShotBall_Attack:
		dc.w 8-1
		dc.l Obj_TransitionRocket_ShotBall_Attack

AniRaw_TransitionRocketH:	dc.b 1, 0, 1, $FC
AniRaw_TransitionRocketV:	dc.b 1, 7, 8, $FC
AniRaw_TransitionRocketFaceH:
		dc.b 2, 3
		dc.b 3, 3
		dc.b 4, 3
		dc.b $E, 7
		dc.b 6, 3
		dc.b 5, 3
		dc.b $FC
AniRaw_TransitionRocketFaceV:
		dc.b 9, 3
		dc.b $A, 3
		dc.b $B, 3
		dc.b $E, 7
		dc.b $D, 3
		dc.b $C, 3
		dc.b $FC
AniRaw_TransitionRocketSmoke:
		dc.b $17, 1
		dc.b $17, 1
		dc.b $18, 1
		dc.b $19, 2
		dc.b $1A, 3
		dc.b $F4
AniRaw_TransitionRocketStars:
		dc.b $1B, 1
		dc.b $1B, 1
		dc.b $1C, 1
		dc.b $1D, 2
		dc.b $1E, 3
		dc.b $F4
	even

PLC_Transition: plrlistheader
		plreq $1F0, ArtKosM_TitleMasterEmerald
		plreq $252, ArtKosM_TransitionRocket
		plreq $2B2, ArtKosM_BossGreyBall_Asteroid
PLC_Transition_End

; =============== S U B R O U T I N E =======================================


















; ---------------------------------------------------------------------------

		include "Data/Screens/Transition/Object Data/Map - Rocket.asm"