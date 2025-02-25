; ---------------------------------------------------------------------------
;  нопка смены гравитации
; ---------------------------------------------------------------------------

ObjDat_DEZGravitySwitch:
		dc.w $10, $D8	; XY
		dc.w 0			; Render
		dc.w $130, 8		; XY
		dc.w 1			; Render
ObjDat_DEZGravitySwitch2:
		dc.w $10, $08	; XY
		dc.w 1			; Render
		dc.w $130, $D8	; XY
		dc.w 0			; Render

; =============== S U B R O U T I N E =======================================

Obj_DEZGravitySwitch:
		moveq	#0,d0
		movea.w	parent3(a0),a1
		move.b	subtype(a0),d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	ObjDat_DEZGravitySwitch(pc),a2
		tst.b		$40(a1)
		bmi.s	+
		lea	ObjDat_DEZGravitySwitch2(pc),a2
+		lea	(a2,d0.w),a2
		move.w	(Camera_X_pos).w,d0
		add.w	(a2)+,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		add.w	(a2)+,d0
		move.w	d0,y_pos(a0)
		move.w	(a2),d0
		bset	d0,render_flags(a0)
		move.l	#Map_DEZGravitySwitch,mappings(a0)
		move.w	#$4480,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#8,height_pixels(a0)
		move.w	#$300,priority(a0)
		move.w	#$F,$2E(a0)
		move.l	#DEZGravitySwitch_Main,$34(a0)
		move.l	#DEZGravitySwitch_MoveDownUp,address(a0)
		move.w	#$100,y_vel(a0)
		btst	#1,render_flags(a0)
		bne.s	DEZGravitySwitch_MoveDownUp
		neg.w	y_vel(a0)

DEZGravitySwitch_MoveDownUp:
		bra.w	DEZGravitySwitch_MoveUpDown
; ---------------------------------------------------------------------------

DEZGravitySwitch_Main:
		move.w	#$F,$32(a0)

		move.l	#DEZGravitySwitch_Solid,address(a0)
		tst.b		subtype(a0)
		beq.s	DEZGravitySwitch_Solid
		sfx	sfx_Attachment,0,0,0

DEZGravitySwitch_Solid:
		tst.w	$32(a0)
		beq.s	DEZGravitySwitch_Solid_NoAniPal
		subq.w	#1,$32(a0)

		move.b	(V_int_run_count+3).w,d0
		andi.w	#3,d0
		bne.s	DEZGravitySwitch_Solid_NoAniPal
		addi.w	#$2000,art_tile(a0)
		andi.w	#$6FFF,art_tile(a0)

DEZGravitySwitch_Solid_NoAniPal:
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#0,d3
		move.b	height_pixels(a0),d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectTop).w
		btst	#3,status(a0)
		beq.s	DEZGravitySwitch_MoveUpDown_CheckDelete
		move.b	#1,mapping_frame(a0)
		move.l	#DEZGravitySwitch_PressSwitch,address(a0)
		move.w	#3,$30(a0)
		moveq	#8,d0
		btst	#1,render_flags(a0)
		beq.s	+
		neg.w	d0
+		add.w	d0,y_pos(a0)
		lea	(Player_1).w,a1
		bsr.s	DEZGravitySwitch_RemovePlayerFlags
		sfx	sfx_Flash,0,0,0

DEZGravitySwitch_MoveUpDown_CheckDelete:
		movea.w	parent3(a0),a1
		tst.l	address(a1)
		beq.s	DEZGravitySwitch_MoveUpDown_Remove
		bra.s	DEZGravitySwitch_MoveUpDown_Draw
; ---------------------------------------------------------------------------

DEZGravitySwitch_MoveUpDown_Remove:
		move.w	#$F,$2E(a0)
		move.l	#DEZGravitySwitch_Remove,$34(a0)
		move.l	#DEZGravitySwitch_MoveUpDown,address(a0)
		move.w	#$100,y_vel(a0)
		btst	#1,render_flags(a0)
		beq.s	DEZGravitySwitch_MoveUpDown
		neg.w	y_vel(a0)

DEZGravitySwitch_MoveUpDown:
		jsr	(MoveSprite2).w
		jsr	(Obj_Wait).w

DEZGravitySwitch_MoveUpDown_Draw:
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

DEZGravitySwitch_Remove:
		clr.b	(Reverse_gravity_flag).w
		jmp	(Go_Delete_Sprite).w

; =============== S U B R O U T I N E =======================================

DEZGravitySwitch_RemovePlayerFlags:
		tst.b	object_control(a1)
		bne.s	+
		moveq	#0,d1
		move.b	d1,anim(a1)
		move.b	d1,flip_type(a1)
		move.b	d1,double_jump_flag(a1)
		move.b	d1,jumping(a1)
		move.b	d1,spin_dash_flag(a1)
		bset	#Status_InAir,status(a1)
		bclr	#Status_OnObj,status(a1)
		add.w	d0,y_pos(a1)
		rts

; =============== S U B R O U T I N E =======================================

DEZGravitySwitch_PressSwitch:
		subq.w	#1,$30(a0)
		bpl.s	DEZGravitySwitch_PressSwitch_Draw
		move.w	#$13,$30(a0)
		eori.b	#1,(Reverse_gravity_flag).w
		move.l	#DEZGravitySwitch_PressSwitch_Solid,address(a0)

DEZGravitySwitch_PressSwitch_Draw:
		bra.w	DEZGravitySwitch_MoveUpDown_CheckDelete
; ---------------------------------------------------------------------------

DEZGravitySwitch_PressSwitch_Solid:
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#0,d3
		move.b	height_pixels(a0),d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectTop).w
		btst	#3,status(a0)
		beq.s	+
		clr.w	$30(a0)
		bra.s	DEZGravitySwitch_PressSwitch_Draw
; ---------------------------------------------------------------------------
+		subq.w	#1,$30(a0)
		bpl.s	++
		clr.b	mapping_frame(a0)
		moveq	#8,d0
		btst	#1,render_flags(a0)
		beq.s	+
		neg.w	d0
+		sub.w	d0,y_pos(a0)
		move.l	#DEZGravitySwitch_Solid,address(a0)
+		bra.s	DEZGravitySwitch_PressSwitch_Draw
; ---------------------------------------------------------------------------

		include "Objects/Gravity Switch/Object Data/Map - Gravity Switch.asm"