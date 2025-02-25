; ---------------------------------------------------------------------------
; Palette cycling routine loading subroutine
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Animate_Palette:
		tst.w	(Palette_fade_timer).w
		bmi.s	AnPal_None
		beq.s	AnPal_Load
		subq.w	#1,(Palette_fade_timer).w
		bra.w	Pal_FromBlack
; ---------------------------------------------------------------------------

AnPal_None:
		rts
; ---------------------------------------------------------------------------

AnPal_Load:
		movea.l	(Level_data_addr_RAM.AnPal).w,a0
		jmp	(a0)

; =============== S U B R O U T I N E =======================================

AnPal_DEZ:
		lea	(Palette_cycle_counters).w,a0
		subq.w	#1,(a0)
		bpl.s	.anpal2
		addq.w	#5,(a0)

		move.w	2(a0),d0
		addq.w	#6,2(a0)
		cmpi.w	#6*3,2(a0)
		blo.s		.skip
		clr.w	2(a0)

.skip:
		lea	AnPal_PalDEZ12_1(pc,d0.w),a1
		lea	(Normal_palette_line_3+$18).w,a2
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+

.anpal2:
		subq.w	#1,4(a0)
		bpl.s	.return
		move.w	#$13,4(a0)

		move.w	6(a0),d0
		addq.w	#8,6(a0)
		cmpi.w	#8*4,6(a0)
		blo.s		.skip2
		clr.w	6(a0)

.skip2:
		lea	AnPal_PalDEZ12_2(pc,d0.w),a1
		lea	(Normal_palette_line_3+$10).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+

.return:
		rts
; End of function AnPal_DEZ
; ---------------------------------------------------------------------------

AnPal_PalDEZ12_1:	binclude "Levels/DEZ/Palettes/Animate/1.bin"
	even
AnPal_PalDEZ12_2:	binclude "Levels/DEZ/Palettes/Animate/2.bin"
	even