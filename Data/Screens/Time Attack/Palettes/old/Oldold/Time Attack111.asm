; ---------------------------------------------------------------------------
; Time Attack Screen
; ---------------------------------------------------------------------------

; RAM
vTimeAttack_Buffer:			= $FFFF2000		; $800 bytes
vTimeAttack_FactorBuffer:		= $FFFF2800			; $800 bytes

vTimeAttack_Timer:			= Camera_RAM		; word
vTimeAttack_TextFactor:		= Camera_RAM+2	; byte
vTimeAttack_End:			= Camera_RAM+3	; byte
vTimeAttack_Wait:			= Camera_RAM+4	; byte

; =============== S U B R O U T I N E =======================================

TimeScreen_Screen:
		lea	(Pal_TimeAttack).l,a1
		lea	(Normal_palette_line_1).w,a2
		moveq	#(64/2)-1,d0

-		move.l	(a1)+,(a2)+
		dbf	d0,-


		bsr.w	TimeScreen_LoadDataToRAM
		lea	Time_MainText(pc),a1
		locVRAM	$C080,d1
		move.w	#$203C,d3
		bsr.w	Load_PlaneText
		bsr.w	TimeScreen_LoadDataToPlane
		clr.l	(Timer).w








		move.b	#$14,(vTimeAttack_TextFactor).w
		move.w	#3,(Demo_timer).w

-		move.b	#VintID_Main,(V_int_routine).w
		bsr.w	Wait_VSync
		addq.w	#1,(Level_frame_counter).w
		bsr.w	Title_Deform
		bsr.w	LevelSelect_Deform
		bsr.w	TimeScreen_Process
		bsr.w	Process_Sprites
		bsr.w	Render_Sprites
		tst.b	(vTimeAttack_End).w
		beq.s	-

TimeScreen_PressStart:
		disableInts
		dmaFillVRAM 0,$C000,$1000
		lea	Options_MainText(pc),a1
		locVRAM	$C080,d1
		move.w	#$203C,d3
		bsr.w	Load_PlaneText
		bsr.w	Options_DrawOptionsText
		enableInts
		clr.l	(Camera_RAM).w
		clr.l	(Camera_RAM+4).w
		clr.l	(Camera_RAM+8).w
		clr.l	(Camera_RAM+$C).w
		clr.b	(Object_load_routine).w

		lea	(Pal_Options).l,a1
		lea	(Normal_palette_line_1).w,a2
		moveq	#(64/2)-1,d0

-		move.l	(a1)+,(a2)+
		dbf	d0,-

;		move.w	#2*60,(Demo_timer).w

		clr.w	(HScroll_Shift).w
		move.b	#$14,(vEnding_TextFactor).w
		bsr.w	HardLine_Deform_Screen1
		move.b	#VintID_Main,(V_int_routine).w
		bsr.w	Wait_VSync
		bsr.w	Title_Deform
		bra.w	Options_Loop

; =============== S U B R O U T I N E =======================================

TimeScreen_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	TimeScreen_Process_Index(pc,d0.w),d0
		jmp	TimeScreen_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

TimeScreen_Process_Index: offsetTable
		offsetTableEntry.w TimeScreen_Process_Wait			; 0
		offsetTableEntry.w TimeScreen_Process_StopBG		; 2
		offsetTableEntry.w TimeScreen_Process_LoadText		; 4
		offsetTableEntry.w TimeScreen_Process_CheckStart	; 6
		offsetTableEntry.w TimeScreen_Process_HideText		; 8
; ---------------------------------------------------------------------------

TimeScreen_Process_Wait:
		tst.w	(Demo_timer).w
		bne.s	TimeScreen_Process_Wait_Return

TimeScreen_Process_LoadText_End:
		addq.b	#2,(Object_load_routine).w

TimeScreen_Process_Wait_Return:
		rts
; ---------------------------------------------------------------------------

TimeScreen_Process_StopBG:
		subq.w	#8,(HScroll_Shift).w
		bpl.s	TimeScreen_Process_Wait_Return
		clr.w	(HScroll_Shift).w
		bra.s	TimeScreen_Process_LoadText_End
; ---------------------------------------------------------------------------

TimeScreen_Process_LoadText:
		tst.b	(vTimeAttack_TextFactor).w
		beq.s	TimeScreen_Process_LoadText_End
		subq.w	#1,(vTimeAttack_Timer).w
		bpl.s	TimeScreen_Process_Wait_Return
		move.w	#1,(vTimeAttack_Timer).w
		lea	(vTimeAttack_Buffer).l,a1			; Mod Art
		lea	(vTimeAttack_FactorBuffer).l,a2	; Tile factor
		lea	(ArtUnc_TerminalText2).l,a0
		move.w	#((ArtUnc_TerminalText2_End-ArtUnc_TerminalText2)/$20)-1,d7		; Art size
		bsr.w	SmoothDrawArtText.loc_CDC6
		move.l	#vTimeAttack_Buffer,d1
		move.w	#tiles_to_bytes($3D),d2	; VRAM
		bra.w	SmoothLoadArtText2
; ---------------------------------------------------------------------------

TimeScreen_Process_CheckStart:
		tst.b	(Ctrl_1_pressed).w
		bpl.s	TimeScreen_Process_CheckStart_Return
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vTimeAttack_TextFactor).w

TimeScreen_Process_CheckStart_Return:
		rts
; ---------------------------------------------------------------------------

TimeScreen_Process_HideText:
		tst.b	(vTimeAttack_TextFactor).w
		beq.s	TimeScreen_Process_HideText_End
		subq.w	#1,(vTimeAttack_Timer).w
		bpl.s	TimeScreen_Process_CheckStart_Return
		move.w	#1,(vTimeAttack_Timer).w
		lea	(vTimeAttack_Buffer).l,a1			; Mod Art
		lea	(vTimeAttack_FactorBuffer).l,a2	; Tile factor
		lea	(ArtUnc_TerminalText2).l,a0
		move.w	#((ArtUnc_TerminalText2_End-ArtUnc_TerminalText2)/$20)-1,d7		; Art size
		bsr.w	SmoothHideArtText.loc_CDC6
		move.l	#vTimeAttack_Buffer,d1
		move.w	#tiles_to_bytes($3D),d2	; VRAM
		bra.w	SmoothLoadArtText2
; ---------------------------------------------------------------------------

TimeScreen_Process_HideText_End:
		st	(vTimeAttack_End).w
		rts

; =============== S U B R O U T I N E =======================================

TimeScreen_InitDataToRAM:
		lea	(TimeAttack_RAM).w,a1
		move.l	#(99*$10000)+(59*$100)+59,d1
		moveq	#10-1,d0

-		tst.l	(a1)
		bne.s	+
		move.l	d1,(a1)
+		addq.w	#4,a1
		dbf	d0,-
		tst.l	(Timer).w
		bne.s	+
		move.l	d1,(Timer).w
+		rts

; =============== S U B R O U T I N E =======================================

TimeScreen_LoadDataToRAM:
		lea	(TimeAttack_RAM).w,a1
		move.l	(Timer).w,d0
		beq.s	TimeScreen_LoadDataToRAM_Return
		cmpi.l	#(99*$10000)+(59*$100)+59,d0
		beq.s	TimeScreen_LoadDataToRAM_Return

		cmp.l	(a1),d0
		bhs.s	loc_37476
		move.l	$20(a1),$24(a1)
		move.l	$1C(a1),$20(a1)
		move.l	$18(a1),$1C(a1)
		move.l	$14(a1),$18(a1)
		move.l	$10(a1),$14(a1)
		move.l	$C(a1),$10(a1)
		move.l	8(a1),$C(a1)
		move.l	4(a1),8(a1)
		move.l	(a1),4(a1)
		move.l	d0,(a1)

		move.b	#9,(TimeAttack_Flag).w

TimeScreen_LoadDataToRAM_Return:
		rts
; ---------------------------------------------------------------------------

loc_37476:
		cmp.l	4(a1),d0
		bhs.s	loc_3749A


		move.l	$20(a1),$24(a1)
		move.l	$1C(a1),$20(a1)
		move.l	$18(a1),$1C(a1)
		move.l	$14(a1),$18(a1)
		move.l	$10(a1),$14(a1)
		move.l	$C(a1),$10(a1)
		move.l	8(a1),$C(a1)
		move.l	4(a1),8(a1)

		move.l	d0,4(a1)

		move.b	#8,(TimeAttack_Flag).w
		rts
; ---------------------------------------------------------------------------

loc_3749A:
		cmp.l	8(a1),d0
		bhs.s	loc_374AA

		move.l	$20(a1),$24(a1)
		move.l	$1C(a1),$20(a1)
		move.l	$18(a1),$1C(a1)
		move.l	$14(a1),$18(a1)
		move.l	$10(a1),$14(a1)
		move.l	$C(a1),$10(a1)
		move.l	8(a1),$C(a1)

		move.l	d0,8(a1)
		move.b	#7,(TimeAttack_Flag).w
		rts
; ---------------------------------------------------------------------------

loc_374AA:
		cmp.l	$C(a1),d0
		bhs.s	loc_374BA

		move.l	$20(a1),$24(a1)
		move.l	$1C(a1),$20(a1)
		move.l	$18(a1),$1C(a1)
		move.l	$14(a1),$18(a1)
		move.l	$10(a1),$14(a1)
		move.l	$C(a1),$10(a1)

		move.l	d0,$C(a1)
		move.b	#6,(TimeAttack_Flag).w
		rts
; ---------------------------------------------------------------------------

loc_374BA:
		cmp.l	$10(a1),d0
		bhs.s	loc_374CA

		move.l	$20(a1),$24(a1)
		move.l	$1C(a1),$20(a1)
		move.l	$18(a1),$1C(a1)
		move.l	$14(a1),$18(a1)
		move.l	$10(a1),$14(a1)

		move.l	d0,$10(a1)
		move.b	#5,(TimeAttack_Flag).w
		rts
; ---------------------------------------------------------------------------

loc_374CA:
		cmp.l	$14(a1),d0
		bhs.s	loc_374DA

		move.l	$20(a1),$24(a1)
		move.l	$1C(a1),$20(a1)
		move.l	$18(a1),$1C(a1)
		move.l	$14(a1),$18(a1)

		move.l	d0,$14(a1)
		move.b	#4,(TimeAttack_Flag).w
		rts
; ---------------------------------------------------------------------------

loc_374DA:
		cmp.l	$18(a1),d0
		bhs.s	loc_374EA

		move.l	$20(a1),$24(a1)
		move.l	$1C(a1),$20(a1)
		move.l	$18(a1),$1C(a1)

		move.l	d0,$18(a1)
		move.b	#3,(TimeAttack_Flag).w
		rts
; ---------------------------------------------------------------------------

loc_374EA:
		cmp.l	$1C(a1),d0
		bhs.s	loc_374FA

		move.l	$20(a1),$24(a1)
		move.l	$1C(a1),$20(a1)

		move.l	d0,$1C(a1)
		move.b	#2,(TimeAttack_Flag).w
		rts
; ---------------------------------------------------------------------------

loc_374FA:
		cmp.l	$20(a1),d0
		bhs.s	loc_3750A

		move.l	$20(a1),$24(a1)

		move.l	d0,$20(a1)
		move.b	#1,(TimeAttack_Flag).w
		rts
; ---------------------------------------------------------------------------

loc_3750A:
		cmp.l	$24(a1),d0
		bhs.s	locret_374B6

		move.l	d0,$24(a1)
		clr.b	(TimeAttack_Flag).w

locret_374B6:
		rts

; =============== S U B R O U T I N E =======================================

TimeScreen_LoadDataToPlane:
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5

		locVRAM	$C200,d5

		lea	(TimeAttack_RAM).w,a4

		moveq	#10-1,d6

TimeScreen_LoadDataToPlane_LoadName:
		moveq	#0,d1
		move.b	(a4)+,d1		; skip

		move.w	#$203C,d3
		cmp.b	(TimeAttack_Flag).w,d6
		bne.s	.skip
		move.w	#$403C,d3

.skip:
		lea	Time_RaceTextIndex(pc),a1
		adda.w	(a1,d1.w),a1
		move.l	d5,d1
		bsr.w	Load_PlaneText

; load numbers
		addi.l	#$3A0000,d5

		move.l	d5,d4
		moveq	#3-1,d7

-		move.l	d4,VDP_control_port-VDP_control_port(a5)
		moveq	#0,d1
		move.b	(a4)+,d1
		bsr.w	TimeScreen_DrawTwoDigitNumber
		addi.l	#$60000,d4
		dbf	d7,-

		addi.l	#$C60000,d5


		dbf	d6,TimeScreen_LoadDataToPlane_LoadName
		rts

; =============== S U B R O U T I N E =======================================

TimeScreen_DrawTwoDigitNumber:
		movem.l	d0-d3/a2,-(sp)

		lea	Hud_10(pc),a2
		moveq	#2-1,d0

.loop:
		moveq	#0,d2
		move.l	(a2)+,d3

.finddigit:
		sub.l	d3,d1
		blo.s		.write
		addq.w	#1,d2
		bra.s	.finddigit
; ---------------------------------------------------------------------------

.write:
		add.l	d3,d1
		move.w	#$203D,d3
		cmp.b	(TimeAttack_Flag).w,d6
		bne.s	.skip
		move.w	#$403D,d3

.skip:
		add.w	d3,d2
		move.w	d2,VDP_data_port-VDP_data_port(a6)
		dbf	d0,.loop

		movem.l	(sp)+,d0-d3/a2
		rts

; =============== S U B R O U T I N E =======================================

	; set the character
		CHARSET ' ', $37
		CHARSET '0','9', 1
		CHARSET '!', $B
		CHARSET '?', $C
		CHARSET '&', $D
		CHARSET '@', $E
		CHARSET '^', $F
		CHARSET '*', $10
		CHARSET '$', $11
		CHARSET ';', $12
		CHARSET ':', $13
		CHARSET '.', $14
		CHARSET ',', $15
		CHARSET '(', $16
		CHARSET ')', $17
		CHARSET '-', $18
		CHARSET '=', $19
		CHARSET '<', $1A
		CHARSET '>', $1B
		CHARSET '/', $1C
		CHARSET 'A','Z', $1D
		CHARSET 'a','z', $1D

Time_RaceTextIndex: offsetTable
		offsetTableEntry.w Time_RaceXXText	; 0
		offsetTableEntry.w Time_Race1Text		; 2
		offsetTableEntry.w Time_Race2Text		; 4
		offsetTableEntry.w Time_Race3Text		; 6
		offsetTableEntry.w Time_Race4Text		; 8
		offsetTableEntry.w Time_Race5Text		; A
		offsetTableEntry.w Time_Race6Text		; C
		offsetTableEntry.w Time_Race7Text		; E
		offsetTableEntry.w Time_Race8Text		; 10
		offsetTableEntry.w Time_Race9Text		; 12
		offsetTableEntry.w Time_Race10Text		; 14

Time_RaceXXText:
		dc.b " RACE XX                       *  ^     ",-1
Time_Race1Text:
		dc.b " RACE 01                       *  ^     ",-1
Time_Race2Text:
		dc.b " RACE 02                       *  ^     ",-1
Time_Race3Text:
		dc.b " RACE 03                       *  ^     ",-1
Time_Race4Text:
		dc.b " RACE 04                       *  ^     ",-1
Time_Race5Text:
		dc.b " RACE 05                       *  ^     ",-1
Time_Race6Text:
		dc.b " RACE 06                       *  ^     ",-1
Time_Race7Text:
		dc.b " RACE 07                       *  ^     ",-1
Time_Race8Text:
		dc.b " RACE 08                       *  ^     ",-1
Time_Race9Text:
		dc.b " RACE 09                       *  ^     ",-1
Time_Race10Text:
		dc.b " RACE 10                       *  ^     ",-1
Time_MainText:
		dc.b "SONIC EPILOGUE - TIME ATTACK                                    ",$98
		dc.b "      PRESS *START* BUTTON TO EXIT      ",-1
	even

		CHARSET ; reset character set
