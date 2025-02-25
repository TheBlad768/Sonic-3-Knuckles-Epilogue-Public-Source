
; =============== S U B R O U T I N E =======================================

Render_HUDDeath:
		lea	(HUDDeath_RAM).w,a1
		move.b	HUDDeath_RAM.status-HUDDeath_RAM(a1),d0
		beq.s	Render_HUDDeath_Return
		bmi.s	Render_HUDDeath_Left
		cmpi.b	#3,d0
		beq.s	Render_HUDDeath_Check
		subq.b	#1,d0
		bne.s	Render_HUDDeath_Right						; If 2, branch

Render_HUDDeath_Init:
		move.w	#$208,HUDDeath_RAM.Xpos-HUDDeath_RAM(a1)
		move.w	#$108,HUDDeath_RAM.Ypos-HUDDeath_RAM(a1)
		addq.b	#1,HUDDeath_RAM.status-HUDDeath_RAM(a1)	; Set 2

Render_HUDDeath_Right:
		subq.w	#2,HUDDeath_RAM.Xpos-HUDDeath_RAM(a1)
		cmpi.w	#$188,HUDDeath_RAM.Xpos-HUDDeath_RAM(a1)
		bne.s	Render_HUDDeath_Check
		addq.b	#1,HUDDeath_RAM.status-HUDDeath_RAM(a1)	; Set 3

Render_HUDDeath_Check:
		tst.b	(Level_end_flag).w
		beq.s	Render_HUDDeath_Draw
		st	HUDDeath_RAM.status-HUDDeath_RAM(a1)

Render_HUDDeath_Left:
		addq.w	#2,HUDDeath_RAM.Xpos-HUDDeath_RAM(a1)
		cmpi.w	#$208,HUDDeath_RAM.Xpos-HUDDeath_RAM(a1)
		bhs.s	Render_HUDDeath_Draw
		clr.b	HUDDeath_RAM.status-HUDDeath_RAM(a1)

Render_HUDDeath_Draw:
		tst.b	HUD_RAM.draw-HUDDeath_RAM(a1)
		bne.s	Render_HUDDeath_Return
		move.w	HUDDeath_RAM.Xpos-HUDDeath_RAM(a1),d0	; Xpos
		move.w	HUDDeath_RAM.Ypos-HUDDeath_RAM(a1),d1	; Ypos
		move.w	#make_art_tile(ArtTile_HUDDeath,0,1),d5		; VRAM
		lea	Map_DeathHUD(pc),a1
		move.w	(a1)+,d4
		subq.w	#1,d4
		bmi.s	Render_HUDDeath_Return
		bra.w	sub_1AF6C									; Draw
; ---------------------------------------------------------------------------

Render_HUDDeath_Return:
		rts
; End of function Render_HUDDeath
; ---------------------------------------------------------------------------

		include	"Objects/HUD Death/Object Data/Map - HUD.asm"