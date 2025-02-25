
; =============== S U B R O U T I N E =======================================

Obj_SonicFlying:
		bset	#7,$38(a0)
		lea	(Player_1).w,a1
		move.b	#id_SonicControl,routine(a1)
		move.b	#$81,object_control(a1)
		move.b	#id_Hurt,anim(a1)
		clr.w	invulnerability_timer(a1)
		clr.l	x_vel(a1)
		clr.w	ground_vel(a1)
		clr.b	spin_dash_flag(a1)
		bclr	#Status_OnObj,status(a1)
		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
		bset	#Status_InAir,status(a1)
		move.w	x_pos(a1),$30(a0)
		move.w	y_pos(a1),$34(a0)
		move.w	#$400,(Sonic_Knux_top_speed).w
		move.w	#$18,(Sonic_Knux_acceleration).w
		move.w	#$100,(Sonic_Knux_deceleration).w
		move.l	#SonicFlying_FallingControl,address(a0)

SonicFlying_FallingControl:
		lea	(Player_1).w,a1
		lea	(Sonic_Knux_top_speed).w,a4
		move.w	Sonic_Knux_top_speed-Sonic_Knux_top_speed(a4),d6
		move.w	Sonic_Knux_acceleration-Sonic_Knux_top_speed(a4),d5
		move.w	Sonic_Knux_deceleration-Sonic_Knux_top_speed(a4),d4
		bsr.w	SonicFlying_SwingSonic
		bsr.w	SonicFlying_MoveControl
		move.w	ground_vel(a1),x_vel(a1)
		bsr.w	SonicFlying_LevelBound
		bsr.w	SonicFlying_MoveSprite
		move.l	a0,-(sp)
		lea	(Player_1).w,a0
		bsr.w	TouchResponse
		movea.l	(sp)+,a0
		bsr.w	SonicFlying_CheckRemove		; Remove fly
		btst	#6,$38(a0)
		bne.w	SonicFlying_Control_Init
		rts

; =============== S U B R O U T I N E =======================================

Obj_SonicFlying_Control:
		bset	#6,$38(a0)
		bset	#7,$38(a0)
		lea	(Player_1).w,a1
		btst	#3,$38(a0)
		bne.s	SonicFlying_Control_Skip
		move.b	#id_SonicControl,routine(a1)
		move.b	#$81,object_control(a1)
		move.b	#id_Float2,anim(a1)
		clr.w	invulnerability_timer(a1)
		clr.l	x_vel(a1)
		clr.w	ground_vel(a1)
		clr.b	spin_dash_flag(a1)
		bclr	#Status_OnObj,status(a1)
		bclr	#Status_Push,status(a1)		; Player is not standing on/pushing an object
		bset	#Status_InAir,status(a1)

SonicFlying_Control_Skip:
		move.w	x_pos(a1),$30(a0)
		move.w	y_pos(a1),$34(a0)
		move.w	#$400,(Sonic_Knux_top_speed).w
		move.w	#$18,(Sonic_Knux_acceleration).w
		move.w	#$100,(Sonic_Knux_deceleration).w
		move.l	#SonicFlying_Control,address(a0)
		bra.s	SonicFlying_Control

; =============== S U B R O U T I N E =======================================

SonicFlying_MoveSprite:
		move.w	x_vel(a1),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,objoff_30(a0)
		move.w	y_vel(a1),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,objoff_34(a0)
		rts

; =============== S U B R O U T I N E =======================================

SonicFlying_Control_Init:
		lea	(Player_1).w,a1
		move.b	#id_Float2,anim(a1)
		move.l	#SonicFlying_Control,address(a0)

SonicFlying_Control:
		lea	(Player_1).w,a1
		btst	#3,$38(a0)
		bne.s	SonicFlying_Control_SkipShieldAttack
		bsr.w	SonicFlying_ShieldAttack

SonicFlying_Control_SkipShieldAttack:
		lea	(Sonic_Knux_top_speed).w,a4
		move.w	Sonic_Knux_top_speed-Sonic_Knux_top_speed(a4),d6
		move.w	Sonic_Knux_acceleration-Sonic_Knux_top_speed(a4),d5
		move.w	Sonic_Knux_deceleration-Sonic_Knux_top_speed(a4),d4
		bsr.s	SonicFlying_SwingSonic
		bsr.s	SonicFlying_MoveControl
		move.w	ground_vel(a1),x_vel(a1)
		bsr.w	SonicFlying_LevelBound
		bsr.s	SonicFlying_MoveSprite
		move.l	a0,-(sp)
		lea	(Player_1).w,a0
		bsr.w	TouchResponse
		movea.l	(sp)+,a0
		bra.w	SonicFlying_CheckRemove		; Remove fly

; =============== S U B R O U T I N E =======================================

SonicFlying_SwingSonic:
		btst	#3,$38(a0)
		bne.s	SonicFlying_NoSwingSonic
		tst.w	$2E(a0)
		bne.s	SonicFlying_NoSwingSonic
		tst.w	y_vel(a1)
		bne.s	SonicFlying_NoSwingSonic
		move.b	angle(a0),d0
		addq.b	#2,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#6,d0
		move.w	d0,d1
		bra.s	SonicFlying_SwingSonic_SetPosition
; ---------------------------------------------------------------------------

SonicFlying_NoSwingSonic:
		moveq	#0,d1

SonicFlying_SwingSonic_SetPosition:
		move.w	$34(a0),d0
		add.w	d1,d0
		move.w	d0,y_pos(a1)
		move.w	$30(a0),x_pos(a1)
		rts

; =============== S U B R O U T I N E =======================================

SonicFlying_MoveControl:
		tst.w	$2E(a0)
		bne.s	.Sonic_NotRight
		tst.b	(Ctrl_1_locked).w				; are controls locked?
		bne.s	.Sonic_NotRight			; if yes, branch
		btst	#6,$38(a0)
		beq.s	.Sonic_NotDown
		btst	#button_up,(Ctrl_1_held).w	; is up being pressed?
		beq.s	.Sonic_NotUp			; if not, branch
		bsr.s	SonicFlying_MoveUp

.Sonic_NotUp:
		btst	#button_down,(Ctrl_1_held).w	; is down being pressed?
		beq.s	.Sonic_NotDown			; if not, branch
		bsr.s	SonicFlying_MoveDown

.Sonic_NotDown:
		btst	#button_left,(Ctrl_1_held).w	; is left being pressed?
		beq.s	.Sonic_NotLeft			; if not, branch
		bsr.s	SonicFlying_MoveLeft

.Sonic_NotLeft:
		btst	#button_right,(Ctrl_1_held).w	; is right being pressed?
		beq.s	.Sonic_NotRight			; if not, branch
		bsr.w	SonicFlying_MoveRight

.Sonic_NotRight:
		bra.w	SonicFlying_LeftRightDeceleration

; =============== S U B R O U T I N E =======================================

SonicFlying_MoveUp:
		move.w	y_vel(a1),d0
		bpl.s	++
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	+
		add.w	d5,d0
		cmp.w	d1,d0
		ble.s		+
		move.w	d1,d0
+		move.w	d0,y_vel(a1)
		rts
; ---------------------------------------------------------------------------
+		sub.w	d4,d0
		bcc.s	+
		move.w	#-$80,d0
+		move.w	d0,y_vel(a1)
		rts
; ---------------------------------------------------------------------------

SonicFlying_MoveDown:
		move.w	y_vel(a1),d0
		bmi.s	++
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s		+
		sub.w	d5,d0
		cmp.w	d6,d0
		bge.s	+
		move.w	d6,d0
+		move.w	d0,y_vel(a1)
		rts
; ---------------------------------------------------------------------------
+		add.w	d4,d0
		bcc.s	+
		move.w	#$80,d0
+		move.w	d0,y_vel(a1)
		rts

; =============== S U B R O U T I N E =======================================

SonicFlying_MoveLeft:
		move.w	ground_vel(a1),d0
		beq.s	+
		bpl.s	+++
+		bset	#Status_Facing,status(a1)
		sub.w	d5,d0
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

SonicFlying_MoveRight:
		move.w	ground_vel(a1),d0
		bmi.s	++
		bclr	#Status_Facing,status(a1)
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

SonicFlying_LeftRightDeceleration:
		move.b	(Ctrl_1_held).w,d0
		andi.b	#JoyLeftRight,d0
		bne.s	SonicFlying_UpDownDeceleration
		move.w	ground_vel(a1),d0
		beq.s	SonicFlying_UpDownDeceleration
		bmi.s	++
		sub.w	d5,d0
		bcc.s	+
		moveq	#0,d0
+		move.w	d0,ground_vel(a1)
		rts
; ---------------------------------------------------------------------------
+		add.w	d5,d0
		bcc.s	+
		moveq	#0,d0
+		move.w	d0,ground_vel(a1)

SonicFlying_UpDownDeceleration:
		move.b	(Ctrl_1_held).w,d0
		andi.b	#JoyUpDown,d0
		bne.s	SonicFlying_Deceleration_Return
		move.w	y_vel(a1),d0
		beq.s	SonicFlying_Deceleration_Return
		bmi.s	++
		sub.w	d5,d0
		bcc.s	+
		moveq	#0,d0
+		move.w	d0,y_vel(a1)
		rts
; ---------------------------------------------------------------------------
+		add.w	d5,d0
		bcc.s	+
		moveq	#0,d0
+		move.w	d0,y_vel(a1)

SonicFlying_Deceleration_Return:
		rts

; =============== S U B R O U T I N E =======================================

SonicFlying_ShieldAttack:
		moveq	#id_Float2,d2
		tst.w	$2E(a0)
		beq.s	SonicFlying_ShieldAttack_Check
		subq.w	#1,$2E(a0)
		moveq	#id_Roll,d2
		bra.s	SonicFlying_ShieldAttack_SetAnim
; ---------------------------------------------------------------------------

SonicFlying_ShieldAttack_Check:
		move.b	(Ctrl_1_pressed).w,d0
		andi.b	#JoyABC,d0
		beq.s	SonicFlying_ShieldAttack_SetAnim
		move.w	#$1F,$2E(a0)
		moveq	#id_Roll,d2
		move.b	#1,(v_Shield+anim).w
		move.w	#$800,d0
		btst	#Status_Facing,status(a1)					; is Sonic facing left?
		beq.s	.NoLeft								; if not, branch
		neg.w	d0									; reverse speed value, moving Sonic left

.NoLeft:
		move.w	d0,x_vel(a1)							; apply velocity...
		move.w	d0,ground_vel(a1)						; ...both ground and air
		clr.w	y_vel(a1)								; kill y-velocity
		sfx	sfx_FireAttack,0,0,0						; play Fire Shield attack sound

SonicFlying_ShieldAttack_SetAnim:
		move.b	d2,anim(a1)
		rts

; =============== S U B R O U T I N E =======================================

SonicFlying_LevelBound:
		move.l	$30(a0),d1
		move.w	x_vel(a1),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(Camera_min_X_pos).w,d0
		move.w	#$10,d2
		btst	#4,$38(a0)
		beq.s	+
		move.w	#$A0,d2
+		add.w	d2,d0
		cmp.w	d1,d0
		bhi.s	SonicFlying_Boundary_StopX
		move.w	(Camera_max_X_pos).w,d0
		move.w	#$128,d2
		btst	#5,$38(a0)
		beq.s	+
		move.w	#$98,d2
+		add.w	d2,d0
		cmp.w	d1,d0
		bhs.s	SonicFlying_Boundary_CheckBottom

SonicFlying_Boundary_StopX:
		move.w	d0,$30(a0)
		clr.w	$32(a0)
		clr.w	x_vel(a1)
		clr.w	ground_vel(a1)

SonicFlying_Boundary_CheckBottom:
		move.l	$34(a0),d1
		move.w	y_vel(a1),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(Camera_min_Y_pos).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0
		bgt.s	SonicFlying_Boundary_StopY
		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#$C8,d0
		cmp.w	d1,d0
		bgt.s	SonicFlying_Boundary_Return

SonicFlying_Boundary_StopY:
		move.w	d0,$34(a0)
		clr.w	$36(a0)
		clr.w	y_vel(a1)

SonicFlying_Boundary_Return:
		rts

; =============== S U B R O U T I N E =======================================

SonicFlying_CheckRemove:
		cmpi.b	#id_SonicDeath,(Player_1+routine).w
		bhs.s	SonicFlying_SonicDeath
		tst.w	(Debug_placement_mode).w		; is debug mode on?
		bne.s	SonicFlying_Remove				; if yes, branch
		btst	#7,$38(a0)
		beq.s	SonicFlying_Remove
		rts
; ---------------------------------------------------------------------------

SonicFlying_SonicDeath:
		lea	(Player_1).w,a1
		move.b	#id_Hurt,anim(a1)
		move.b	#$81,object_control(a1)
		clr.w	x_vel(a1)

SonicFlying_Remove:
		move.w	#$600,(Sonic_Knux_top_speed).w
		move.w	#$C,(Sonic_Knux_acceleration).w
		move.w	#$80,(Sonic_Knux_deceleration).w
		move.l	#Delete_Current_Sprite,address(a0)

SonicFlying_CheckRemove_Return:
		rts
