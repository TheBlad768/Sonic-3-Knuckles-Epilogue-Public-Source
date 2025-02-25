
; =============== S U B R O U T I N E =======================================

Obj_SmoothPalette:
		subq.w	#1,$2E(a0)
		bpl.s	SmoothPalette_Return
	        move.w  subtype(a0),$2E(a0)
		movea.l	$30(a0),a1			; palette pointer
		movea.w	$34(a0),a2			; palette ram
		move.w	$38(a0),d6			; palette size
		jsr	(Pal_FadeToPal).w
		bne.s	SmoothPalette_Return
		move.l	#Delete_Current_Sprite,address(a0)

SmoothPalette_Return:
		rts