; ---------------------------------------------------------------------------
; Add points subroutine
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

AddPoints:
HUD_AddToScore:
		move.b	#1,(Update_HUD_score).w			; set score counter to update
		lea	(Score).w,a3
		add.l	d0,(a3)							; add d0*10 to the score
		move.l	#999999,d1						; 9999990 maximum points
		cmp.l	(a3),d1							; is score below 999999?
		bhi.s	.locret							; if yes, branch
		move.l	d1,(a3)							; reset score to 999999

.locret:
		rts
; End of function HUD_AddToScore
; ---------------------------------------------------------------------------
; Subroutine to update the HUD
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

UpdateHUD:
		tst.b	(Boss_flag).w
		beq.s	.notboss
		bsr.w	HUDBoss_Draw

.notboss:
		lea	(VDP_data_port).l,a6
		tst.w	(Debug_placement_mode).w		; is debug mode on?
		bne.w	HudDebug						; if yes, branch
		tst.b	(Update_HUD_score).w				; does the score need updating?
		beq.s	.chkrings							; if not, branch
		clr.b	(Update_HUD_score).w
		locVRAM	tiles_to_bytes($6D6),d0		; set VRAM address
		move.l	(Score).w,d1						; load score
		bsr.w	DrawSixDigitNumber

.chkrings:
		tst.b	(Update_HUD_ring_count).w			; does the ring counter	need updating?
		beq.s	.chktime							; if not, branch
		bpl.s	.notzero
		bsr.w	HUD_DrawZeroRings				; reset rings to 0 if Sonic is hit

.notzero:
		clr.b	(Update_HUD_ring_count).w
		locVRAM	tiles_to_bytes($6F4),d0		; set VRAM address
		moveq	#0,d1
		move.w	(Ring_count).w,d1					; load number of rings
		bsr.w	DrawThreeDigitNumber

.chktime:
		tst.b	(Update_HUD_timer).w				; does the time	need updating?
		bpl.s	loc_DD64						; if not, branch
		move.b	#1,(Update_HUD_timer).w
		bra.s	loc_DD9E
; ---------------------------------------------------------------------------

loc_DD64:
		beq.s	UpdateHUD_Death
		tst.b	(Game_paused).w						; is the game paused?
		bne.s	UpdateHUD_Death				; if yes, branch
		lea	(Timer).w,a1
		cmpi.l	#(99*$10000)+(59*$100)+59,(a1)+	; is the time 99:59:59?
		beq.w	UpdateHUD_TimeOver			; if yes, branch

		addq.b	#1,-(a1)							; increment 1/60s counter
		cmpi.b	#60,(a1)							; check if passed 60
		blo.s		loc_DD9E
		clr.b	(a1)
		addq.b	#1,-(a1)							; increment second counter
		cmpi.b	#60,(a1)							; check if passed 60
		blo.s		loc_DD9E
		clr.b	(a1)
		addq.b	#1,-(a1)							; increment minute counter
		cmpi.b	#99,(a1)							; check if passed 99
		blo.s		loc_DD9E
		move.b	#99,(a1)							; keep as 99

loc_DD9E:
		locVRAM	tiles_to_bytes($6E4),d0
		moveq	#0,d1
		move.b	(Timer_minute).w,d1 				; load minutes
		bsr.w	DrawTwoDigitNumber
		locVRAM	tiles_to_bytes($6EA),d0
		moveq	#0,d1
		move.b	(Timer_second).w,d1 				; load seconds
		bsr.w	DrawTwoDigitNumber
		locVRAM	tiles_to_bytes($6F0),d0
		moveq	#0,d1
		move.b	(Timer_frame).w,d1 				; load centisecond
		mulu.w	#100,d1
		divu.w	#60,d1
		swap	d1
		clr.w	d1
		swap	d1
		cmpi.l	#(99*$10000)+(59*$100)+59,(Timer).w	; is the time 99:59:59?
		bne.s	+
		moveq	#99,d1
+		bsr.w	DrawTwoDigitNumber

UpdateHUD_Death:
		tst.b	(Update_death_count).w
		beq.s	.notdeath
		bpl.s	.notdeathzero
		bsr.w	HUD_DrawZeroDeath				; reset rings to 0 if Sonic is hit

.notdeathzero:
		clr.b	(Update_death_count).w
		locVRAM	tiles_to_bytes($7C4),d0		; set VRAM address
		moveq	#0,d1
		move.w	(Death_count).w,d1				; load number of rings
		bsr.w	DrawThreeDigitNumber

.notdeath:
		rts
; ---------------------------------------------------------------------------

UpdateHUD_TimeOver:
		clr.b	(Update_HUD_timer).w
		lea	(Player_1).w,a0
		cmpi.b	#id_SonicDeath,routine(a0)
		bhs.s	.finish
		movea.l	a0,a2
		bsr.w	Kill_Character

.finish:
		st	(Time_over_flag).w

UpdateHUD_TimeOver_Return:
		rts
; ---------------------------------------------------------------------------

HudDebug:
		bsr.w	HUD_Debug
		tst.b	(Update_HUD_ring_count).w			; does the ring	counter	need updating?
		beq.s	.objcounter						; if not, branch
		bpl.s	.notzero
		bsr.w	HUD_DrawZeroRings				; reset rings to 0 if Sonic is hit

.notzero:
		clr.b	(Update_HUD_ring_count).w
		locVRAM	tiles_to_bytes($6F4),d0		; set VRAM address
		moveq	#0,d1
		move.w	(Ring_count).w,d1					; load number of rings
		bsr.w	DrawThreeDigitNumber

.objcounter:
		locVRAM	tiles_to_bytes($6E4),d0		; set VRAM address
		moveq	#0,d1
		move.w	(Lag_frame_count).w,d1
		bsr.w	DrawTwoDigitNumber
		locVRAM	tiles_to_bytes($6EA),d0		; set VRAM address
		moveq	#0,d1
		move.b	(Sprites_drawn).w,d1				; load "number of objects" counter
		bsr.w	DrawTwoDigitNumber
		bsr.w	UpdateHUD_Death
		tst.b	(Game_paused).w
		bne.s	locret_DE7C
		lea	(Timer).w,a1
		cmpi.l	#(99*$10000)+(59*$100)+59,(a1)+	; is the time 99:59:59?
		nop
		addq.b	#1,-(a1)							; increment 1/60s counter
		cmpi.b	#60,(a1)							; check if passed 60
		blo.s		locret_DE7C
		clr.b	(a1)
		addq.b	#1,-(a1)							; increment second counter
		cmpi.b	#60,(a1)							; check if passed 60
		blo.s		locret_DE7C
		clr.b	(a1)
		addq.b	#1,-(a1)							; increment minute counter
		cmpi.b	#99,(a1)							; check if passed 99
		blo.s		locret_DE7C
		move.b	#99,(a1)							; keep as 99

locret_DE7C:
		rts
; End of function UpdateHUD
; ---------------------------------------------------------------------------
; Subroutine to load "0" on the HUD
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HUD_DrawZeroDeath:
		locVRAM	tiles_to_bytes($7C4),VDP_control_port-VDP_data_port(a6)
		bra.s	HUD_DrawZeroRings2
; End of function HUD_DrawZeroDeath

; =============== S U B R O U T I N E =======================================

HUD_DrawZeroRings:
		locVRAM	tiles_to_bytes($6F4),VDP_control_port-VDP_data_port(a6)

HUD_DrawZeroRings2:
		lea	HUD_Zero_Rings(pc),a2
		move.w	#2,d2
		bra.s	loc_1C83E
; End of function HUD_DrawZeroRings
; ---------------------------------------------------------------------------
; Subroutine to load uncompressed HUD patterns ("E", "0", colon)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HUD_DrawInitial:
		lea	(VDP_data_port).l,a6
		bsr.w	HUD_DrawZeroDeath
		locVRAM	tiles_to_bytes($6D4),VDP_control_port-VDP_data_port(a6)
		lea	HUD_Initial_Parts(pc),a2
		move.w	#(HUD_Initial_Parts_End-HUD_Initial_Parts)-1,d2

loc_1C83E:
		lea	(ArtUnc_Hud).l,a1

-		moveq	#(8*2)-1,d1
		move.b	(a2)+,d0
		bmi.s	loc_1C85E
		ext.w	d0
		lsl.w	#5,d0
		lea	(a1,d0.w),a3

-		move.l	(a3)+,VDP_data_port-VDP_data_port(a6)
		dbf	d1,-

loc_1C858:
		dbf	d2,--
		rts
; ---------------------------------------------------------------------------

loc_1C85E:
		move.l	#0,VDP_data_port-VDP_data_port(a6)
		dbf	d1,loc_1C85E
		bra.s	loc_1C858
; End of function HUD_DrawInitial
; ---------------------------------------------------------------------------

	; set the character set for HUD
		charset	' ',$FF
		charset	'0',0
		charset	'1',2
		charset	'2',4
		charset	'3',6
		charset	'4',8
		charset	'5',$A
		charset	'6',$C
		charset	'7',$E
		charset	'8',$10
		charset	'9',$12
		charset	'*',$14
		charset	':',$16
		charset	'E',$18

HUD_Initial_Parts:
		dc.b "E      0"
		dc.b "00*00:00"
HUD_Zero_Rings:
		dc.b "  0"		; (zero rings)
HUD_Initial_Parts_End

		charset ; reset character set
		even
; ---------------------------------------------------------------------------
; Subroutine to load debug mode	numbers	patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HUD_Debug:
		locVRAM	tiles_to_bytes($6D4),VDP_control_port-VDP_data_port(a6)	; set VRAM address
		move.w	(Camera_X_pos).w,d1	; load camera x-position
		swap	d1
		move.w	(Player_1+x_pos).w,d1	; load Sonic's x-position
		bsr.s	HUD_Debug2
		move.w	(Camera_Y_pos).w,d1	; load camera y-position
		swap	d1
		move.w	(Player_1+y_pos).w,d1	; load Sonic's y-position

HUD_Debug2:
		moveq	#8-1,d6
		lea	(ArtUnc_DebugText).l,a1

HUD_DebugLoop:
		rol.w	#4,d1
		move.w	d1,d2
		andi.w	#$F,d2
		cmpi.w	#$A,d2
		blo.s		+
		addq.w	#7,d2
+		lsl.w	#5,d2
		lea	(a1,d2.w),a3
	rept 8
		move.l	(a3)+,VDP_data_port-VDP_data_port(a6)
	endm
		swap	d1
		dbf	d6,HUD_DebugLoop	; repeat 7 more	times
		rts
; End of function HUD_Debug
; ---------------------------------------------------------------------------
; Subroutine to	load rings numbers patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

DrawThreeDigitNumber:
		lea	Hud_100(pc),a2
		moveq	#3-1,d6
		bra.s	Hud_LoadArt
; End of function DrawThreeDigitNumber
; ---------------------------------------------------------------------------
; Subroutine to	load score numbers patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

DrawSixDigitNumber:
		lea	Hud_100000(pc),a2
		moveq	#6-1,d6

Hud_LoadArt:
		moveq	#0,d4
		lea	(ArtUnc_Hud).l,a1

Hud_ScoreLoop:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1C8EC:
		sub.l	d3,d1
		blo.s		loc_1C8F4
		addq.w	#1,d2
		bra.s	loc_1C8EC
; ---------------------------------------------------------------------------

loc_1C8F4:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1C8FE
		move.w	#1,d4

loc_1C8FE:
		tst.w	d4
		beq.s	loc_1C92C
		lsl.w	#6,d2
		move.l	d0,VDP_control_port-VDP_data_port(a6)
		lea	(a1,d2.w),a3
	rept 16
		move.l	(a3)+,VDP_data_port-VDP_data_port(a6)
	endm

loc_1C92C:
		addi.l	#$400000,d0
		dbf	d6,Hud_ScoreLoop
		rts
; End of function DrawSixDigitNumber
; ---------------------------------------------------------------------------
; HUD counter sizes
; ---------------------------------------------------------------------------
Hud_100000:	dc.l 100000
Hud_10000:		dc.l 10000
Hud_1000:		dc.l 1000
Hud_100:		dc.l 100
Hud_10:			dc.l 10
Hud_1:			dc.l 1
; ---------------------------------------------------------------------------
; Subroutine to	load time numbers patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

DrawSingleDigitNumber:
		lea	Hud_1(pc),a2
		moveq	#1-1,d6
		bra.s	loc_1C9BA
; End of function DrawSingleDigitNumber

; =============== S U B R O U T I N E =======================================

DrawTwoDigitNumber:
		lea	Hud_10(pc),a2
		moveq	#2-1,d6

loc_1C9BA:
		moveq	#0,d4
		lea	(ArtUnc_Hud).l,a1

Hud_TimeLoop:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1C9C4:
		sub.l	d3,d1
		blo.s		loc_1C9CC
		addq.w	#1,d2
		bra.s	loc_1C9C4
; ---------------------------------------------------------------------------

loc_1C9CC:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1C9D6
		move.w	#1,d4

loc_1C9D6:
		lsl.w	#6,d2
		move.l	d0,VDP_control_port-VDP_data_port(a6)
		lea	(a1,d2.w),a3
	rept 16
		move.l	(a3)+,VDP_data_port-VDP_data_port(a6)
	endm
		addi.l	#$400000,d0
		dbf	d6,Hud_TimeLoop

DrawTwoDigitNumber_Return:
		rts
; End of function DrawTwoDigitNumber

; =============== S U B R O U T I N E =======================================

HUDBoss_Draw:
		cmpi.b	#id_SonicDeath,(Player_1+routine).w	; has Sonic just died?
		bhs.s	DrawTwoDigitNumber_Return			; if yes, branch

; Siren
		lea	(Hud_BossMapData).l,a1			; tiles id
		lea	(ArtUnc_HudBoss).l,a2
		lea	(Hud_Boss_ArtBuffer).w,a3
		move.b	(Level_frame_counter+1).w,d0
		move.b	d0,d1
		lsr.b	d0
		add.b	d1,d0						; speed
		andi.w	#$3C,d0						; get upper half only
		adda.w	d0,a1
		moveq	#2-1,d6						; load upper and lower half

-		moveq	#4-1,d2						; number of tiles

-		move.b	(a1)+,d0						; get tile id
		ext.w	d0
		lsl.w	#5,d0
		lea	(a2,d0.w),a4
	rept	8
		move.l	(a4)+,(a3)+
	endm
		lea	$20(a3),a3						; next tile
		dbf	d2,-
		lea	-$E0(a3),a3						; return
		lea	$3C(a1),a1						; get lower half
		dbf	d6,--

; Numbers
		moveq	#0,d1
		moveq	#2-1,d6
		movea.w	(HUDBoss_RAM.parent).w,a1
		move.b	collision_property(a1),d1 		; load number of hits
		lea	Hud_10(pc),a2
		lea	(ArtUnc_HudBoss_Number).l,a1
		lea	(Hud_Boss_ArtBuffer+$50).w,a3

.loop:
		moveq	#0,d2
		move.l	(a2)+,d3						; 10=>1

.finddigit:
		sub.l	d3,d1
		bcs.s	.write
		addq.w	#1,d2						; add 1 to digit
		bra.s	.finddigit
; ---------------------------------------------------------------------------

.write:
		add.l	d3,d1
		lsl.w	#5,d2
		lea	(a1,d2.w),a4
		lea	$140(a4),a5						; load silhouette numbers	; It's not exactly a graphic, it's a $FF bytes

	rept 8
		move.l	(a3),d4
		and.l	(a5)+,d4
		or.l	(a4)+,d4
		move.l	d4,(a3)+
	endm

		lea	$20(a3),a3						; next tile
		dbf	d6,.loop
		rts
; End of function HUDBoss_Draw
