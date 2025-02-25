
; =============== S U B R O U T I N E =======================================

Obj_SonicRocket:
		bset	#7,$38(a0)
		lea	(Player_1).w,a1
		move.w	x_pos(a1),$30(a0)
		move.w	y_pos(a1),$34(a0)
		move.b	#id_SonicControl,routine(a1)
		move.b	#id_Sparkster,anim(a1)
		clr.w	invulnerability_timer(a1)
		clr.l	x_vel(a1)
		clr.w	ground_vel(a1)
		clr.b	spin_dash_flag(a1)
		bclr	#Status_OnObj,status(a1)
		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
		bset	#Status_InAir,status(a1)
		move.w	#$100,$3C(a0)
		move.w	#$400,(Sonic_Knux_top_speed).w
		move.w	#$18,(Sonic_Knux_acceleration).w
		move.w	#$100,(Sonic_Knux_deceleration).w
		move.l	#SonicRocket_Intro,address(a0)

SonicRocket_Intro:
		lea	(Player_1).w,a1
		lea	(Sonic_Knux_top_speed).w,a4
		move.w	Sonic_Knux_top_speed-Sonic_Knux_top_speed(a4),d6
		move.w	Sonic_Knux_acceleration-Sonic_Knux_top_speed(a4),d5
		move.w	Sonic_Knux_deceleration-Sonic_Knux_top_speed(a4),d4
		bsr.s	SonicRocket_SwingIntroSonic
		move.w	ground_vel(a1),x_vel(a1)
		bsr.w	SonicFlying_MoveSprite
		move.w	$30(a0),x_pos(a1)
		move.w	$34(a0),y_pos(a1)
		bra.w	SonicFlying_CheckRemove		; Remove fly

; =============== S U B R O U T I N E =======================================

SonicRocket_SwingIntroSonic:
		move.b	angle(a0),d0
		addq.b	#4,angle(a0)
		jsr	(GetSineCosine).w
		muls.w	$3C(a0),d0
		asr.l	#8,d0
		neg.w	d0
		move.w	d0,y_vel(a1)
		tst.b	angle(a0)
		bne.s	SonicRocket_WaitDialog_Return
		asr.w	$3C(a0)
		cmpi.w	#$80,$3C(a0)
		bne.s	SonicRocket_WaitDialog_Return
		addq.b	#2,(Object_load_routine).w
		music	bgm_Sparkster,0,0,0
		move.l	#SonicRocket_Control,address(a0)
		clr.w	$3C(a0)
		clr.w	y_vel(a1)
		st	(NoPause_flag).w
		lea	ChildObjDat_Dialog_Process(pc),a2
		jsr	(CreateChild11_Simple2).w
		bne.s	SonicRocket_WaitDialog_Return
		move.b	#_SparksterStartup,routine(a1)
		move.l	#DialogSparksterStartup_Process_Index-4,$34(a1)
		move.b	#(DialogSparksterStartup_Process_Index_End-DialogSparksterStartup_Process_Index)/8,$39(a1)

SonicRocket_WaitDialog_Return:
		rts
; ---------------------------------------------------------------------------

Obj_SonicRocket_Restore:
		bset	#7,$38(a0)
		lea	(Player_1).w,a1
		move.w	x_pos(a1),$30(a0)
		move.w	y_pos(a1),$34(a0)
		move.b	#id_SonicControl,routine(a1)
		move.b	#$81,object_control(a1)
		move.b	#id_Sparkster,anim(a1)
		move.b	#3*60,invulnerability_timer(a1)
		clr.b	invincibility_timer(a1)
		clr.l	x_vel(a1)
		clr.w	ground_vel(a1)
		clr.b	spin_dash_flag(a1)
		bclr	#Status_OnObj,status(a1)
		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
		bset	#Status_InAir,status(a1)
		move.w	#$400,(Sonic_Knux_top_speed).w
		move.w	#$18,(Sonic_Knux_acceleration).w
		move.w	#$100,(Sonic_Knux_deceleration).w
		move.l	#SonicRocket_Control,address(a0)
		bra.s	SonicRocket_Control
; ---------------------------------------------------------------------------

SonicRocket_WaitDialog_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	SonicRocket_Control
		addq.b	#2,(Object_load_routine).w
		move.w	#10,(Ring_count).w						; set rings
		move.b	#1,(HUD_RAM.status).w

;		tst.b	(QuickStart_mode).w
;		beq.s	+
;		move.b	#1,(HUDDeath_RAM.status).w
;+

		move.b	#$80,(Update_HUD_ring_count).w
		move.l	#SonicRocket_Control,address(a0)

		lea	(Pal_DEZ2_End).l,a1
		lea	(Normal_palette_line_3).w,a2
		jsr	(PalLoad_Line16+8).w		; 8 colors

;		lea	(Pal_DEZ2_End).l,a1
;		jsr	(PalLoad_Line2).w

SonicRocket_Control:
		lea	(Player_1).w,a1
		lea	(Sonic_Knux_top_speed).w,a4
		move.w	Sonic_Knux_top_speed-Sonic_Knux_top_speed(a4),d6
		move.w	Sonic_Knux_acceleration-Sonic_Knux_top_speed(a4),d5
		move.w	Sonic_Knux_deceleration-Sonic_Knux_top_speed(a4),d4
		bsr.s	SonicRocket_SwingSonic
		bsr.s	SonicRocket_MoveControl
		move.w	ground_vel(a1),x_vel(a1)
		bsr.w	SonicFlying_LevelBound
		bsr.w	SonicFlying_MoveSprite
		move.l	a0,-(sp)
		lea	(Player_1).w,a0
		tst.b	invulnerability_timer(a0)
		bne.s	.skip
		bsr.w	SonicRocket_TouchResponse
.skip:
		movea.l	(sp)+,a0
		bra.w	SonicFlying_CheckRemove		; Remove fly

; =============== S U B R O U T I N E =======================================

SonicRocket_SwingSonic:
		move.b	angle(a0),d0
		addi.b	#$40,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#8,d0
		move.w	d0,d1
		move.w	$30(a0),d0
		add.w	d1,d0
		move.w	d0,x_pos(a1)
		move.w	$34(a0),y_pos(a1)

SonicRocket_SwingSonic_Return:
		rts

; =============== S U B R O U T I N E =======================================

SonicRocket_MoveControl:
		tst.b	(Ctrl_1_locked).w				; are controls locked?
		bne.s	.Sonic_NotRight			; if yes, branch
		btst	#6,$38(a0)
		bne.s	SonicRocket_SwingSonic_Return
		cmpi.b	#3*60-20,invulnerability_timer(a1)
		bhs.s	.Sonic_NotRight			; if yes, branch
		btst	#button_up,(Ctrl_1_held).w	; is up being pressed?
		beq.s	.Sonic_NotUp			; if not, branch
		bsr.w	SonicFlying_MoveUp

.Sonic_NotUp:
		btst	#button_down,(Ctrl_1_held).w	; is down being pressed?
		beq.s	.Sonic_NotDown			; if not, branch
		bsr.w	SonicFlying_MoveDown

.Sonic_NotDown:
		btst	#button_left,(Ctrl_1_held).w	; is left being pressed?
		beq.s	.Sonic_NotLeft			; if not, branch
		bsr.s	SonicRocket_MoveLeft

.Sonic_NotLeft:
		btst	#button_right,(Ctrl_1_held).w	; is right being pressed?
		beq.s	.Sonic_NotRight			; if not, branch
		bsr.s	SonicRocket_MoveRight

.Sonic_NotRight:
		bra.w	SonicFlying_LeftRightDeceleration

; =============== S U B R O U T I N E =======================================

SonicRocket_MoveLeft:
		move.w	ground_vel(a1),d0
		beq.s	+
		bpl.s	+++
+		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	+
		add.w	d5,d0
		cmp.w	d1,d0
		ble.s		+
		move.w	d1,d0
+		move.w	d0,ground_vel(a1)
		rts
; ---------------------------------------------------------------------------
+		sub.w	d4,d0
		bcc.s	+
		move.w	#-$80,d0
+		move.w	d0,ground_vel(a1)
		rts
; ---------------------------------------------------------------------------

SonicRocket_MoveRight:
		move.w	ground_vel(a1),d0
		bmi.s	++
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s		+
		sub.w	d5,d0
		cmp.w	d6,d0
		bge.s	+
		move.w	d6,d0
+		move.w	d0,ground_vel(a1)
		rts
; ---------------------------------------------------------------------------
+		add.w	d4,d0
		bcc.s	+
		move.w	#$80,d0
+		move.w	d0,ground_vel(a1)
		rts

; =============== S U B R O U T I N E =======================================

SonicRocket_TouchResponse:
		move.w	x_pos(a0),d2
		subq.w	#8,d2
		move.w	y_pos(a0),d3
		moveq	#0,d5
		move.b	y_radius(a0),d5
		subq.b	#3,d5
		sub.w	d5,d3
		moveq	#16,d4
		add.w	d5,d5
		lea	(Collision_response_list).w,a4
		move.w	(a4)+,d6
		beq.s	SonicRocket_Touch_Return

SonicRocket_Touch_Loop:
		movea.w	(a4)+,a1
		move.b	collision_flags(a1),d0
		bne.s	SonicRocket_Touch_Width

SonicRocket_Touch_NextObj:
		subq.w	#2,d6
		bne.s	SonicRocket_Touch_Loop
		moveq	#0,d0

SonicRocket_Touch_Return:
		rts
; ---------------------------------------------------------------------------

SonicRocket_Touch_Width:
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	(Touch_Sizes).w,a2
		lea	(a2,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	x_pos(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	.checkrightside
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	SonicRocket_Touch_Height
		bra.s	SonicRocket_Touch_NextObj
; ---------------------------------------------------------------------------

.checkrightside:
		cmp.w	d4,d0
		bhi.s	SonicRocket_Touch_NextObj

SonicRocket_Touch_Height:
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	y_pos(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	.checktop
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	SonicRocket_Touch_ChkValue
		bra.s	SonicRocket_Touch_NextObj
; ---------------------------------------------------------------------------

.checktop:
		cmp.w	d5,d0
		bhi.s	SonicRocket_Touch_NextObj

SonicRocket_Touch_ChkValue:
		move.b	collision_flags(a1),d1
		andi.b	#$C0,d1
		beq.s	SonicRocket_TouchResponse_Check
		tst.b	d1
		bmi.s	SonicRocket_Touch_ChkHurt
		rts
; ---------------------------------------------------------------------------

SonicRocket_TouchResponse_Check:
		illegal

SonicRocket_Touch_Death:
		move.b	#$80,(Update_HUD_ring_count).w

		move.l	#Obj_TransitionJetPack,(v_WaterWave).w

		lea	(Player_1).w,a1
		move.b	#id_SonicDeath,routine(a1)	; Hit animation
		move.b	#id_Hurt,anim(a1)
		clr.b	object_control(a1)
		clr.w	x_vel(a1)
		move.w	#-$400,y_vel(a1)
		clr.w	ground_vel(a1)			; Zero out inertia


		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

SonicRocket_Touch_ChkHurt:
		sfx	sfx_Death,0,0,0
		tst.w	(Ring_count).w
		beq.s	SonicRocket_Touch_Death
		subq.w	#1,(Ring_count).w
		move.w	#-$100,x_vel(a0)
		move.w	#$280,y_vel(a0)
		move.b	#$80,(Update_HUD_ring_count).w
		move.b	#3*60,invulnerability_timer(a0)
		bset	#7,status(a1)		; Destroy Rocket

; Create Ring
		jsr	(Create_New_Sprite).w
		bne.s	SonicRocket_Touch_ChkHurt_End
		move.l	#Obj_Bouncing_Ring,address(a1)
		addq.b	#2,routine(a1)
		move.b	#8,y_radius(a1)
		move.b	#8,x_radius(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	#Map_Ring,mappings(a1)
		move.w	#make_art_tile(ArtTile_Ring,3,1),art_tile(a1)
		move.b	#$84,render_flags(a1)
		move.w	#$180,priority(a1)
		move.b	#8,width_pixels(a1)
		st	(Ring_spill_anim_counter).w
		move.w	#-$100,x_vel(a1)
		move.w	#-$180,y_vel(a1)

SonicRocket_Touch_ChkHurt_End:
		moveq	#-1,d0
		rts
