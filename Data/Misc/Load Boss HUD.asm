
; =============== S U B R O U T I N E =======================================

Render_HUDBoss:
		lea	(HUDBoss_RAM).w,a1
		move.b	HUDBoss_RAM.status-HUDBoss_RAM(a1),d0
		beq.s	Render_HUDBoss_Return
		bmi.s	Render_HUDBoss_Up
		cmpi.b	#3,d0
		beq.s	Render_HUDBoss_Check
		subq.b	#1,d0
		bne.s	Render_HUDBoss_Down						; If 2, branch

Render_HUDBoss_Init:
		move.w	#$110,HUDBoss_RAM.Xpos-HUDBoss_RAM(a1)
		move.w	#$68,HUDBoss_RAM.Ypos-HUDBoss_RAM(a1)
		addq.b	#1,HUDBoss_RAM.status-HUDBoss_RAM(a1)		; Set 2

Render_HUDBoss_Down:
		addq.w	#1,HUDBoss_RAM.Ypos-HUDBoss_RAM(a1)
		cmpi.w	#$88,HUDBoss_RAM.Ypos-HUDBoss_RAM(a1)
		bne.s	Render_HUDBoss_Check
		addq.b	#1,HUDBoss_RAM.status-HUDBoss_RAM(a1)		; Set 3

Render_HUDBoss_Check:
		movea.w	HUDBoss_RAM.parent-HUDBoss_RAM(a1),a2
		btst	#7,status(a2)
		beq.s	Render_HUDBoss_Draw
		st	HUDBoss_RAM.status-HUDBoss_RAM(a1)

Render_HUDBoss_Up:
		subq.w	#1,HUDBoss_RAM.Ypos-HUDBoss_RAM(a1)
		cmpi.w	#$78,HUDBoss_RAM.Ypos-HUDBoss_RAM(a1)
		bhs.s	Render_HUDBoss_Draw
		clr.b	HUDBoss_RAM.status-HUDBoss_RAM(a1)

Render_HUDBoss_Draw:
		tst.b	HUD_RAM.draw-HUDBoss_RAM(a1)
		bne.s	Render_HUDBoss_Return
		move.w	HUDBoss_RAM.Xpos-HUDBoss_RAM(a1),d0		; Xpos
		move.w	HUDBoss_RAM.Ypos-HUDBoss_RAM(a1),d1		; Ypos
		move.w	#make_art_tile(ArtTile_HUDBoss,0,1),d5			; VRAM
		moveq	#0,d4
		lea	Map_BossHUD(pc),a1
		bra.w	sub_1AF6C									; Draw
; ---------------------------------------------------------------------------

Render_HUDBoss_Return:
		rts
; End of function Render_HUDBoss
; ---------------------------------------------------------------------------

		include "Objects/HUD Boss/Object Data/Map - Boss HUD.asm"