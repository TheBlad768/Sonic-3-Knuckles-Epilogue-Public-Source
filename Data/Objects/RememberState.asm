; ---------------------------------------------------------------------------
; Subroutine to remember whether an object is destroyed/collected
; ---------------------------------------------------------------------------

MarkObjGone:
RememberState:
Sprite_OnScreen_Test:
		move.w	x_pos(a0),d0

Sprite_OnScreen_Test2:
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		bra.w	Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

MarkObjGone_Collision:
RememberState_Collision:
Sprite_OnScreen_Test_Collision:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		bsr.w	Add_SpriteToCollisionResponseList
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		bra.w	Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

Delete_Sprite_If_Not_In_Range:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		rts
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		bra.w	Delete_Current_Sprite
; End of function Delete_Sprite_If_Not_In_Range

; =============== S U B R O U T I N E =======================================

Sprite_CheckDelete:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		bset	#7,status(a0)
		move.l	#Delete_Current_Sprite,address(a0)
		rts

; =============== S U B R O U T I N E =======================================

Sprite_CheckDelete2:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		bset	#4,$38(a0)
		move.l	#Delete_Current_Sprite,address(a0)

.return:
		rts

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteXY:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		bra.w	Draw_Sprite

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteXY_NoDraw:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		rts

; =============== S U B R O U T I N E =======================================

Sprite_ChildCheckDeleteXY:
		move.w	$10(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	$14(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	loc_849E2
		bra.w	Draw_Sprite

; =============== S U B R O U T I N E =======================================

Sprite_ChildCheckDeleteXY_NoDraw:
		move.w	$10(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	$14(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	loc_849E2

Sprite_ChildCheckDeleteXY_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_FlickerMove_Explosion:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	Obj_FlickerMove
		lea	(ChildObjDat_BossGreyBall_Fire).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	Obj_FlickerMove
		move.b	#16/2,$3A(a1)
		move.b	#16/2,$3B(a1)
		move.w	#$100,$3C(a1)

Obj_FlickerMove:
		bsr.w	MoveSprite_TestGravity
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite_3
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite_3
		bchg	#6,$38(a0)
		beq.s	Sprite_ChildCheckDeleteXY_Return
		bra.w	Draw_Sprite

; =============== S U B R O U T I N E =======================================

Obj_FlickerMove2:
		bsr.w	MoveSprite2_TestGravity
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite_3
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite_3
		bchg	#6,$38(a0)
		beq.w	Sprite_ChildCheckDeleteXY_Return
		bra.w	Draw_Sprite

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouch:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Sprite_CheckDelete.offscreen
		bsr.w	Add_SpriteToCollisionResponseList
		bra.w	Draw_Sprite

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouch2:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Sprite_CheckDelete2.offscreen
		bsr.w	Add_SpriteToCollisionResponseList
		bra.w	Draw_Sprite

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouchXY:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		bsr.w	Add_SpriteToCollisionResponseList
		bra.w	Draw_Sprite

; =============== S U B R O U T I N E =======================================

Sprite_ChildCheckDeleteTouchXY:
		move.w	x_pos(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite

Sprite_ChildCheckDeleteTouchY:
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	loc_849E2
		bsr.w	Add_SpriteToCollisionResponseList
		bra.w	Draw_Sprite

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteSlotted:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	Go_Delete_SpriteSlotted
		bra.w	Draw_Sprite

; =============== S U B R O U T I N E =======================================

Go_Delete_SpriteSlotted:
		move.w	respawn_addr(a0),d0
		beq.s	Go_Delete_SpriteSlotted2
		movea.w	d0,a2
		bclr	#7,(a2)

Go_Delete_SpriteSlotted2:
		move.l	#Delete_Current_Sprite,address(a0)
		bset	#7,status(a0)

Remove_From_TrackingSlot:
		move.b	$3B(a0),d0
		movea.w	$3C(a0),a1
		bclr	d0,(a1)
		rts
; End of function Remove_From_TrackingSlot

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouchSlotted:
		tst.b	status(a0)
		bmi.s	Go_Delete_SpriteSlotted3
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	Go_Delete_SpriteSlotted
		bsr.w	Add_SpriteToCollisionResponseList
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

Go_Delete_SpriteSlotted3:
		move.l	#Delete_Current_Sprite,address(a0)
		bra.s	Remove_From_TrackingSlot

; =============== S U B R O U T I N E =======================================

Obj_WaitOffscreen:
		move.l	#Map_Offscreen,mappings(a0)
		bset	#2,render_flags(a0)
		move.b	#64/2,width_pixels(a0)
		move.b	#64/2,height_pixels(a0)
		move.l	(sp)+,$34(a0)
		move.l	#+,address(a0)
+		tst.b	render_flags(a0)
		bmi.s	+
		bra.w	Sprite_OnScreen_Test
; ---------------------------------------------------------------------------
+		move.l	$34(a0),address(a0)			; Restore normal object operation when onscreen
		rts
; End of function Obj_WaitOffscreen
; ---------------------------------------------------------------------------
Map_Offscreen:	dc.w 0
