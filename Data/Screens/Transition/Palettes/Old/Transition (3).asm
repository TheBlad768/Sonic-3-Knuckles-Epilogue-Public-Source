; ---------------------------------------------------------------------------
; Transition Screen
; ---------------------------------------------------------------------------

vTransition_Count:			= Object_load_addr_front+2	; byte
vTransition_End:				= Object_load_addr_front+3	; byte

; =============== S U B R O U T I N E =======================================

Transition_Screen:
		music	bgm_Fade,0,0,0
		moveq	#palid_Sonic,d0
		move.w	d0,d1
		jsr	(LoadPalette).w								; load Sonic's palette
		move.w	d1,d0
		jsr	(LoadPalette_Immediate).w
		move.l	#AnPal_DEZ,(Level_data_addr_RAM.AnPal).w
		lea	(Pal_DEZ+$20).l,a1
		jsr	(PalLoad_Line2).w

		lea	(Pal_Transition).l,a1
		jsr	(PalLoad_Line1).w

;		clr.w	(HScroll_Shift).w

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
		jsr	(Render_Sprites).w
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
		jsr	MoveCameraX.w




		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		tst.b	(vTransition_End).w
		beq.s	-




		clr.w	(HScroll_Shift).w


		clr.l	(Object_load_addr_front).w
		clr.l	(Object_load_addr_front+4).w
		clr.l	(Object_load_addr_front+8).w
		clr.l	(Object_load_addr_front+$C).w


		clr.l	(Object_load_addr_front).w
		clr.b	(Object_load_routine).w
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
		jsr	Change_ActSizes.l
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


;		move.b	#$81,object_control(a1)
;		move.b	#id_Hurt,anim(a1)
;		bclr	#Status_OnObj,status(a1)
;		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
;		bset	#Status_InAir,status(a1)
;		st	(Ctrl_1_locked).w
;		clr.w	(Ctrl_1_logical).w

;		lea	(ArtKosM_TitleMasterEmerald).l,a1
;		move.w	#tiles_to_bytes($1DE),d2
;		jsr	(Queue_Kos_Module).w
;		move.l	#Obj_Crane_TransitionScreen,(Dynamic_object_RAM).w	; load crane

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
		bsr.s	TransitionScreen_Deform2
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
		offsetTableEntry.w TransitionScreen_Process_Wait		; 0

		offsetTableEntry.w TransitionScreen_Process_CheckPress	; 2






		offsetTableEntry.w TransitionScreen_Process_MoveCenter
		offsetTableEntry.w TransitionScreen_Process_MoveWait
		offsetTableEntry.w TransitionScreen_Process_MoveCamera
		offsetTableEntry.w TransitionScreen_Process_CheckSonic


		offsetTableEntry.w TransitionScreen_Process_Return	; 4
; ---------------------------------------------------------------------------

TransitionScreen_Process_Wait:
		addq.w	#2,(Camera_X_pos).w
		cmpi.w	#$3A0,(Camera_X_pos).w
		blt.s		TransitionScreen_Process_Return

		addq.b	#2,(Object_load_routine).w


		move.w	(Camera_X_pos).w,d0
		move.w	d0,(Camera_min_X_pos).w
		move.w	d0,(Camera_max_X_pos).w


		lea	(ArtKosM_TitleMasterEmerald).l,a1
		move.w	#tiles_to_bytes($1DE),d2
		jsr	(Queue_Kos_Module).w


		lea	(ArtKosM_TransitionRocket).l,a1
		move.w	#tiles_to_bytes($240),d2
		jsr	(Queue_Kos_Module).w


		bsr.w	SpawnLevelMainSprites
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)
		move.b	#id_Hurt,anim(a1)
		bclr	#Status_OnObj,status(a1)
		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
		bset	#Status_InAir,status(a1)
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w

		jsr	(Create_New_Sprite).w
		bne.s	TransitionScreen_Process_Return
		move.l	#Obj_Crane_TransitionScreen,address(a1)	; load crane


		jsr	(Create_New_Sprite).w
		bne.s	TransitionScreen_Process_Return
		move.l	#Obj_TransitionScreen_LoadRocket,address(a1)	; load crane


TransitionScreen_Process_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_Process_CheckPress:
		btst	#button_B,(Ctrl_1_pressed).w
		bne.s	TransitionScreen_Process_CheckPress_Exit


TransitionScreen_Process_CheckPress_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_Process_CheckPress_Exit:
		addq.b	#2,(Object_load_routine).w

		bset	#6,(v_Breathing_bubbles+$38).w


;		lea	(v_Breathing_bubbles).w,a1
;		jsr	(Delete_Referenced_Sprite).w

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
		asl.w	#3,d0
		move.w	d0,(Player_1+ground_vel).w

TransitionScreen_Process_MoveCenter_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_Process_MoveCenter_Next:


		addq.b	#2,(Object_load_routine).w


		move.w	#$200,(HScroll_Shift).w

		move.w	#3*60,(Demo_timer).w


TransitionScreen_Process_MoveCenter_Next_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_Process_MoveWait:
		tst.w	(Demo_timer).w
		bne.s	TransitionScreen_Process_MoveCenter_Next_Return

		addq.b	#2,(Object_load_routine).w


TransitionScreen_Process_MoveCamera:

		addi.w	#$10,(Camera_X_pos).w

		move.w	(Camera_X_pos).w,d0
		move.w	d0,(Camera_min_X_pos).w
		move.w	d0,(Camera_max_X_pos).w



		addi.w	#$20,d0
		move.w	d0,(v_Breathing_bubbles+$30).w
		move.w	d0,(v_Breathing_bubbles+x_pos).w


		cmpi.w	#$760,(Camera_X_pos).w
		ble.s		TransitionScreen_Process_MoveCamera_Return
		addq.b	#2,(Object_load_routine).w


		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_DEZParticlesExplosion,address(a1)
+



;		clr.w	(HScroll_Shift).w


		st	(vTransition_End).w


		lea	(v_Breathing_bubbles).w,a1
		jsr	(Delete_Referenced_Sprite).w


;		bset	#7,(v_Breathing_bubbles).w


		lea	(Player_1).w,a1
		move.b	#id_SonicControl,routine(a1)	; Hit animation
		move.b	#id_Hurt,anim(a1)

		move.w	#$800,x_vel(a1)			; Set speed of player
		move.w	#-$800,y_vel(a1)
		clr.w	ground_vel(a1)			; Zero out inertia


		clr.b	object_control(a1)

		bclr	#Status_OnObj,status(a1)
		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
		bset	#Status_InAir,status(a1)


;		move.w	#$000,(Camera_min_X_pos).w
;		move.w	#$000,(Camera_target_min_X_pos).w

		move.w	#$000,(Camera_min_Y_pos).w
		move.w	#$000,(Camera_target_min_Y_pos).w

		move.w	#$880,(Camera_max_X_pos).w
		move.w	#$880,(Camera_target_max_X_pos).w

		move.w	#$300,(Camera_max_Y_pos).w
		move.w	#$300,(Camera_target_max_Y_pos).w

TransitionScreen_Process_MoveCamera_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_Process_CheckSonic:
		cmpi.w	#$8EC,(Player_1+x_pos).w
		ble.s		TransitionScreen_Process_CheckSonic_Return

		lea	(Player_1).w,a1
		clr.w	ground_vel(a1)			; Zero out inertia

		subi.w	#$100,x_vel(a1)
		bpl.s	TransitionScreen_Process_CheckSonic_Return
		clr.w	x_vel(a1)					; Zero out speed


		move.b	#id_SonicHurt,routine(a1)	; Hit animation

		addq.b	#2,(Object_load_routine).w

		st	(vTransition_End).w

;		illegal

TransitionScreen_Process_CheckSonic_Return:
		rts
; ---------------------------------------------------------------------------




; =============== S U B R O U T I N E =======================================

Obj_Crane_TransitionScreen:
		move.l	#Map_SSZRobotnikShipCrane,mappings(a0)
		move.w	#$215,art_tile(a0)
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



		lea	(Object_RAM).w,a1
		move.b	#id_SonicControl,routine(a1)

		move.b	#id_Float1,anim(a1)


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
		add.w	d1,art_tile(a0)
		move.l	#Obj_DEZParticles_Fall,address(a0)

Obj_DEZParticles_Fall:
		jsr	(MoveSprite).w
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
		move.w	#$7F,$2E(a0)
		move.l	#TransitionScreen_LoadRocket_Process,address(a0)

TransitionScreen_LoadRocket_Process:
		subq.w	#1,$2E(a0)
		bpl.s	TransitionScreen_LoadRocket_Process_Return

; load index
		move.b	routine(a0),d0
		addq.b	#1,routine(a0)
		andi.w	#$FF,d0
		add.w	d0,d0
		lea	TransitionScreen_LoadRocket_Index(pc),a3
		adda.w	(a3,d0.w),a3

; load data
		move.w	(a3)+,d6
		bmi.s	TransitionScreen_LoadRocket_Process_End

-		jsr	(Create_New_Sprite3).w
		bne.s	TransitionScreen_LoadRocket_Process_End

		move.l	#Obj_TransitionRocket,address(a1)

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

;		illegal

		move.w	#$4F,$2E(a0)
		move.l	#TransitionScreen_LoadRocket_Process,address(a0)

TransitionScreen_LoadRocket_Process_Return:
		rts
; ---------------------------------------------------------------------------

TransitionScreen_LoadRocket_Index: offsetTable
		offsetTableEntry.w .Data1					; 1
		offsetTableEntry.w .Data2					; 2
		offsetTableEntry.w .Data3					; 3
		offsetTableEntry.w .Data4					; 4
		offsetTableEntry.w .Data5					; 5

		offsetTableEntry.w .Data5					; 5
		offsetTableEntry.w .Data5					; 5
		offsetTableEntry.w .Data5					; 5
		offsetTableEntry.w .Data5					; 5
; ---------------------------------------------------------------------------

.Data1:
		dc.w 1-1				; Count

; 1
		dc.w $180, $20		; Xpos, Ypos
		dc.w $F				; Wait
		dc.b 1, 0				; Subtype, Render bitfield

.Data2:
		dc.w 1-1				; Count

; 1
		dc.w $180, $C0
		dc.w $F
		dc.b 1, 0

.Data3:
		dc.w 2-1				; Count

; 1
		dc.w $180, $60
		dc.w $F
		dc.b 1, 0

; 2
		dc.w $180, $80
		dc.w $F
		dc.b 1, 0


.Data4:
		dc.w 4-1				; Count

; 1
		dc.w $180, $20		; Xpos, Ypos
		dc.w $F				; Wait
		dc.b 1, 0				; Subtype, Render bitfield

; 2
		dc.w $180, $60
		dc.w $3F
		dc.b 1, 0

; 3
		dc.w $180, $80
		dc.w $3F
		dc.b 1, 0

; 4
		dc.w $180, $C0
		dc.w $F
		dc.b 1, 0

.Data5:
		dc.w 7-1				; Count

; 1
		dc.w $20, $100		; Xpos, Ypos
		dc.w $F				; Wait
		dc.b $81, 0			; Subtype, Render bitfield

; 2
		dc.w $40, $100		; Xpos, Ypos
		dc.w $2F				; Wait
		dc.b $81, 0			; Subtype, Render bitfield

; 3
		dc.w $60, $100		; Xpos, Ypos
		dc.w $4F				; Wait
		dc.b $81, 0			; Subtype, Render bitfield

; 4
		dc.w $80, $100		; Xpos, Ypos
		dc.w $6F				; Wait
		dc.b $81, 0			; Subtype, Render bitfield

; 5
		dc.w $A0, $100		; Xpos, Ypos
		dc.w $8F				; Wait
		dc.b $81, 0			; Subtype, Render bitfield

; 6
		dc.w $C0, $100		; Xpos, Ypos
		dc.w $AF			; Wait
		dc.b $81, 0			; Subtype, Render bitfield

; 7
		dc.w $E0, $100		; Xpos, Ypos
		dc.w $CF				; Wait
		dc.b $81, 0			; Subtype, Render bitfield



; =============== S U B R O U T I N E =======================================

Obj_TransitionRocket:
		move.l	#TransitionRocket_Wait,address(a0)
		lea	ObjDat3_TransitionRocket(pc),a1
		jsr	(SetUp_ObjAttributes).w

TransitionRocket_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	TransitionRocket_NoDraw

; Start
		sfx	sfx_Boom,0,0,0
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
		andi.w	#$F,d3
		add.w	d3,d3
		add.w	d3,d3
		move.l	(a4,d3.w),x_vel(a0)

TransitionRocket_Main:
		jsr	(MoveSprite2).w
		jsr	(Animate_Raw).w
		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

TransitionRocket_NoDraw:
		jmp	(Sprite_CheckDeleteXY_NoDraw).w
; ---------------------------------------------------------------------------

TransitionRocket_VelDataH:
		dc.w -$200, 0
		dc.w -$300, 0
		dc.w -$400, 0
		dc.w -$400, 0

TransitionRocket_VelDataV:
		dc.w 0, -$200
		dc.w 0, -$300
		dc.w 0, -$400
		dc.w 0, -$400

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
; ---------------------------------------------------------------------------

ObjDat3_TransitionRocket:
		dc.l Map_TRocket
		dc.w $2240
		dc.w $200
		dc.b 32/2
		dc.b 32/2
		dc.b 0
		dc.b $1A|$80
ObjDat3_TransitionRocketFace:
		dc.w $180
		dc.b 16/2
		dc.b 16/2
		dc.b 2
		dc.b 0
ChildObjDat_TransitionRocketFaceH:
		dc.w 1-1
		dc.l Obj_TransitionRocketFace
		dc.b 8, 0
ChildObjDat_TransitionRocketFaceV:
		dc.w 1-1
		dc.l Obj_TransitionRocketFace
		dc.b 8, -8
AniRaw_TransitionRocketH:		dc.b 1, 0, 1, $FC
AniRaw_TransitionRocketV:		dc.b 1, 7, 8, $FC
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
	even

; =============== S U B R O U T I N E =======================================


















; ---------------------------------------------------------------------------

		include "Data/Screens/Transition/Object Data/Map - Rocket.asm"