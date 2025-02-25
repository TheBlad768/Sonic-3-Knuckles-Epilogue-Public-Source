
; =============== S U B R O U T I N E =======================================

LevelSetup:
		move.w	#$FFF,(Screen_Y_wrap_value).w
		move.w	#$FF0,(Camera_Y_pos_mask).w
		move.w	#$7C,(Layout_row_index_mask).w
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		lea	(Plane_buffer).w,a0
		movea.l	(Block_table_addr_ROM).w,a2
		movea.l	(Level_layout2_addr_ROM).w,a3
		move.w	#vram_fg,d7
		movea.l	(Level_data_addr_RAM.ScreenInit).w,a1
		jsr	(a1)
		addq.w	#2,a3
		move.w	#vram_bg,d7
		movea.l	(Level_data_addr_RAM.BackgroundInit).w,a1
		jsr	(a1)
		move.w	(Camera_Y_pos_copy).w,(V_scroll_value).w
		move.w	(Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
		rts
; ---------------------------------------------------------------------------

ScreenEvents:
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		lea	(Plane_buffer).w,a0
		movea.l	(Block_table_addr_ROM).w,a2
		movea.l	(Level_layout2_addr_ROM).w,a3
		move.w	#vram_fg,d7
		movea.l	(Level_data_addr_RAM.ScreenEvent).w,a1
		jsr	(a1)
		addq.w	#2,a3
		move.w	#vram_bg,d7
		movea.l	(Level_data_addr_RAM.BackgroundEvent).w,a1
		jsr	(a1)
		move.w	(Camera_Y_pos_copy).w,(V_scroll_value).w
		move.w	(Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
		rts

; =============== S U B R O U T I N E =======================================

DEZ1_ScreenInit:
		bsr.w	Reset_TileOffsetPositionActual
		bra.w	Refresh_PlaneFull

; =============== S U B R O U T I N E =======================================

DEZ1_ScreenEvent:
		tst.b	(Screen_event_flag).w
		bne.s	DEZ1_ScreenEvent_RefreshPlane
		move.w	(Screen_shaking_flag+2).w,d0
		add.w	d0,(Camera_Y_pos_copy).w
		bra.w	DrawTilesAsYouMove
; ---------------------------------------------------------------------------

DEZ1_ScreenEvent_RefreshPlane:
		bpl.s	DEZ1_ScreenEvent_RefreshPlaneFull
		clr.b	(Screen_event_flag).w
		bra.w	Refresh_PlaneScreenDirect
; ---------------------------------------------------------------------------

DEZ1_ScreenEvent_RefreshPlaneFull:
		clr.b	(Screen_event_flag).w
		bra.w	Refresh_PlaneFullDirect

; =============== S U B R O U T I N E =======================================

DEZ1_BackgroundInit:
		bsr.s	DEZ1_Deform
		bsr.w	Reset_TileOffsetPositionEff
		moveq	#0,d1	; Set XCam BG pos
		bsr.w	Refresh_PlaneFull
		bra.s	DEZ1_BackgroundEvent.deform

; =============== S U B R O U T I N E =======================================

DEZ1_BackgroundEvent:
		tst.b (Background_event_flag).w
		bne.s	DEZ1_Transition
		bsr.s	DEZ1_Deform

.deform:
		lea	DEZ1_BGDrawArray(pc),a4
		lea	(H_scroll_table).w,a5
		bsr.w	ApplyDeformation
		bsr.s	DEZ1_BackgroundEvent_Resize
		bra.w	ShakeScreen_Setup

; =============== S U B R O U T I N E =======================================

DEZ1_BGDrawArray:
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w 16
		dc.w $7FFF
; ---------------------------------------------------------------------------

DEZ1_ParallaxScript:
			; Mode	Speed coef.	Number of lines(Linear only)
		dc.w	_moving|$03,	$0060		; BG
		dc.w	_moving|$02,	$0040		; BG
		dc.w	_moving|$03,	$0060		; BG
		dc.w	_moving|$02,	$0040		; BG
		dc.w	_moving|$03,	$0060		; BG
		dc.w	_moving|$02,	$0040		; BG
		dc.w	_moving|$03,	$0060		; BG
		dc.w	_moving|$02,	$0040		; BG
		dc.w	_moving|$03,	$0060		; BG
		dc.w	_moving|$02,	$0040		; BG
		dc.w	_moving|$03,	$0060		; BG
		dc.w	_moving|$02,	$0040		; BG
		dc.w	_moving|$03,	$0060		; BG
		dc.w	_moving|$02,	$0040		; BG
		dc.w	-1
; ---------------------------------------------------------------------------

DEZ1_Deform:
		lea	DEZ1_ParallaxScript(pc),a1
		bra.w	ExecuteParallaxScript

; =============== S U B R O U T I N E =======================================

DEZ1_Transition:
		clr.b	(Background_event_flag).w
		rts

; =============== S U B R O U T I N E =======================================

DEZ1_BackgroundEvent_Resize:
		moveq	#0,d0
		move.b	(Background_event_routine).w,d0
		beq.s	DEZ1_BackgroundEvent_Resize_Return
		move.w	DEZ1_BackgroundEvent_Resize_Index-2(pc,d0.w),d0
		jmp	DEZ1_BackgroundEvent_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------

DEZ1_BackgroundEvent_Resize_Index: offsetTable
		offsetTableEntry.w DEZ1_BackgroundEvent_Resize_SpeedUp			; 2
		offsetTableEntry.w DEZ1_BackgroundEvent_Resize_MoveVertical		; 4
		offsetTableEntry.w DEZ1_BackgroundEvent_Resize_StopMoveVertical	; 6
		offsetTableEntry.w DEZ1_BackgroundEvent_Resize_MoveBGVertical		; 8
; ---------------------------------------------------------------------------

DEZ1_BackgroundEvent_Resize_SpeedUp:
		addq.b	#2,(Background_event_routine).w
		addq.b	#2,(Special_V_int_routine).w
		move.w	#$900,(V_scroll_speed).w

DEZ1_BackgroundEvent_Resize_MoveVertical:
		cmpi.b	#id_SonicDeath,(Player_1+routine).w		; has Sonic just died?
		bhs.s	DEZ1_BackgroundEvent_Resize_Return		; if yes, branch
		move.w	(V_scroll_speed).w,d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,(V_scroll_shift).w

DEZ1_BackgroundEvent_Resize_Return:
		rts
; ---------------------------------------------------------------------------

DEZ1_BackgroundEvent_Resize_StopMoveVertical:
		addq.b	#2,(Background_event_routine).w
		clr.b	(Special_V_int_routine).w
		clr.w	(V_scroll_speed).w
		move.w	(V_scroll_value).w,d0
		move.w	d0,(V_scroll_shift).w
		move.w	#$A20,d0
		move.w	d0,(Camera_max_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		rts
; ---------------------------------------------------------------------------

DEZ1_BackgroundEvent_Resize_MoveBGVertical:
		addq.w	#8,(Camera_Y_pos_BG_copy).w
		rts

; =============== S U B R O U T I N E =======================================

DEZ3_BackgroundEvent:
		tst.b (Background_event_flag).w
		bne.s	DEZ1_Transition
		bsr.s	DEZ1_Deform

.deform:
		lea	DEZ1_BGDrawArray(pc),a4
		lea	(H_scroll_table).w,a5
		bsr.w	ApplyDeformation
		bsr.s	DEZ3_BackgroundEvent_Resize
		bra.w	ShakeScreen_Setup

; =============== S U B R O U T I N E =======================================

DEZ3_BackgroundEvent_Resize:
		moveq	#0,d0
		move.b	(Background_event_routine).w,d0
		beq.s	DEZ3_BackgroundEvent_Resize_Return
		move.w	DEZ3_BackgroundEvent_Resize_Index-2(pc,d0.w),d0
		jmp	DEZ3_BackgroundEvent_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------

DEZ3_BackgroundEvent_Resize_Index: offsetTable
		offsetTableEntry.w DEZ3_BackgroundEvent_Resize_SpeedUp	; 2
		offsetTableEntry.w DEZ3_BackgroundEvent_Resize_Scroll		; 4
		offsetTableEntry.w DEZ3_BackgroundEvent_Resize_Slowdown	; 6
		offsetTableEntry.w DEZ3_BackgroundEvent_Resize_Scroll		; 8
; ---------------------------------------------------------------------------

DEZ3_BackgroundEvent_Resize_SpeedUp:
		addi.w	#8*2,(HScroll_Shift).w
		cmpi.w	#$600,(HScroll_Shift).w
		bne.s	DEZ3_BackgroundEvent_Resize_Scroll
		addq.b	#2,(Background_event_routine).w
		moveq	#id_Walk,d0
		cmp.b	(Player_1+anim).w,d0
		beq.s	DEZ3_BackgroundEvent_Resize_Scroll
		move.b	d0,(Player_1+anim).w

DEZ3_BackgroundEvent_Resize_Scroll:
		cmpi.b	#id_SonicDeath,(Player_1+routine).w		; has Sonic just died?
		bhs.w	FGScroll_Deformation2					; if yes, branch
		bsr.w	FGScroll_Deformation

DEZ3_BackgroundEvent_Resize_Return:
		rts
; ---------------------------------------------------------------------------

DEZ3_BackgroundEvent_Resize_Slowdown:
		subq.w	#8,(HScroll_Shift).w
		bne.s	DEZ3_BackgroundEvent_Resize_Scroll
		addq.b	#2,(Background_event_routine).w
		move.l	#DEZ4_Resize_End,(Level_data_addr_RAM.Resize).w
		clr.b	(Ctrl_1_locked).w
		jsr	(Restore_PlayerControl).w
		bra.s	DEZ3_BackgroundEvent_Resize_Scroll
; ---------------------------------------------------------------------------






















