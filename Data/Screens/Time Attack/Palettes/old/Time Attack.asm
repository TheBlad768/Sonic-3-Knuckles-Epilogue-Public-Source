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
		jsr	(PalLoad_Line.loop).w
		lea	Time_MainText(pc),a1
		locVRAM	$C080,d1
		move.w	#$203C,d3
		jsr	(Load_PlaneText).w
		bsr.w	TimeScreen_LoadDataToPlane
		bsr.w	TimeScreen_LoadDataToPlane_Death
		move.b	#$14,(vTimeAttack_TextFactor).w
		move.w	#3,(Demo_timer).w

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	Title_Deform
		bsr.w	LevelSelect_Deform
		bsr.w	TimeScreen_Process
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		tst.b	(vTimeAttack_End).w
		beq.s	-

TimeScreen_PressStart:
		disableInts
		dmaFillVRAM 0,$C000,$1000
		enableInts
		clr.l	(Camera_RAM).w
		clr.l	(Camera_RAM+4).w
		clr.l	(Camera_RAM+8).w
		clr.l	(Camera_RAM+$C).w
		clr.b	(Object_load_routine).w
		lea	(RAM_start+$3000).l,a3
		move.w	#bytesToWcnt(2240),d1

-		clr.w	(a3)+
		dbf	d1,-
		disableInts
		bsr.w	Options_InitDraw
		enableInts
		lea	(Pal_Options).l,a1
		lea	(Normal_palette_line_1).w,a2
		moveq	#(64/2)-1,d0
		jsr	(PalLoad_Line.loop).w
		move.b	#$14,(vTimeAttack_TextFactor).w
		bsr.w	HardLine_Deform_Screen1
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.w	Title_Deform
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
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

; Reset Time and Death
		lea	(TimeAttack_RAM).w,a1
		lea	(TimeAttack_DeathRAM).w,a2
		move.l	#(99*$10000)+(59*$100)+59,d1
		moveq	#-1,d2
		moveq	#10-1,d0

-		move.l	d1,(a1)+
		move.w	d2,(a2)+
		dbf	d0,-
		rts

; =============== S U B R O U T I N E =======================================

TimeScreen_SetDataToRAM:
		addq.b	#2,(TimeAttack_count).w
		cmpi.b	#$16,(TimeAttack_count).w
		blo.s		TimeScreen_LoadDataToRAM
		move.b	#2,(TimeAttack_count).w

; =============== S U B R O U T I N E =======================================

TimeScreen_LoadDataToRAM:
		lea	(TimeAttack_RAM).w,a1	; Start
		lea	$20(a1),a2				; End
		move.l	(Timer).w,d0
		move.l	#$FFFFFF,d2
		moveq	#0,d3
		moveq	#10-1,d6

TimeScreen_LoadDataToRAM_Loop:
		move.l	(a1)+,d1
		and.l	d2,d1
		cmp.l	d1,d0
		bhs.s	TimeScreen_LoadDataToRAM_NextSlot

; load data
		jsr	TimeScreen_SaveDataToRAM_ShiftSlot(pc,d3.w)
		move.l	d0,-(a1)
		move.b	(TimeAttack_count).w,(a1)
		move.b	d6,(TimeAttack_flag).w

; load data death
		lea	(TimeAttack_DeathRAM).w,a1	; Start
		lea	$10(a1),a2					; End
		jsr	TimeScreen_SaveDataToRAM_ShiftSlot_Death(pc,d3.w)
		lsr.w	d3
		adda.w	d3,a1
		move.w	(Death_count).w,(a1)
		tst.b	(QuickStart_mode).w
		bne.s	TimeScreen_LoadDataToRAM_Return
		move.w	#-1,(a1)

TimeScreen_LoadDataToRAM_Return:
		rts
; ---------------------------------------------------------------------------

TimeScreen_LoadDataToRAM_NextSlot:
		addq.w	#4,d3
		dbf	d6,TimeScreen_LoadDataToRAM_Loop
		rts

; =============== S U B R O U T I N E =======================================

TimeScreen_SaveDataToRAM_ShiftSlot:
	rept 10-1
		move.l	(a2)+,(a2)	; $20, $24
		subq.w	#8,a2
	endm
		rts

; =============== S U B R O U T I N E =======================================

TimeScreen_SaveDataToRAM_ShiftSlot_Death:
	rept 10-1
		move.w	(a2)+,(a2)	; $10, $12
		subq.w	#4,a2
	endm
		rts

; =============== S U B R O U T I N E =======================================

TimeScreen_LoadDataToPlane:
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		lea	(TimeAttack_RAM).w,a4
		locVRAM	$C200,d4
		moveq	#10-1,d6

TimeScreen_LoadDataToPlane_LoadRace:
		move.l	(a4),d5
		andi.l	#$FFFFFF,d5
		moveq	#0,d1
		move.b	(a4)+,d1
		move.w	#$203C,d3
		cmp.b	(TimeAttack_flag).w,d6
		bne.s	.skip
		move.w	#$403C,d3

.skip:
		lea	Time_RaceTextIndex(pc),a1
		adda.w	(a1,d1.w),a1
		move.l	d4,d1
		jsr	(Load_PlaneText).w

; load numbers
		addi.l	#$3A0000,d4
		move.l	d4,d3
		moveq	#3-1,d7

-		move.l	d3,VDP_control_port-VDP_control_port(a5)
		moveq	#0,d1
		move.b	(a4)+,d1
		tst.w	d7
		bne.s	+
		mulu.w	#100,d1
		divu.w	#60,d1
		swap	d1
		clr.w	d1
		swap	d1
		cmpi.l	#(99*$10000)+(59*$100)+59,d5
		bne.s	+
		moveq	#99,d1
+		bsr.s	TimeScreen_DrawTwoDigitNumber
		addi.l	#$60000,d3
		dbf	d7,-
		addi.l	#$C60000,d4
		dbf	d6,TimeScreen_LoadDataToPlane_LoadRace
		rts

; =============== S U B R O U T I N E =======================================

TimeScreen_DrawThreeDigitNumber:
		movem.l	d0-d3/a2,-(sp)
		lea	(Hud_100).w,a2
		moveq	#3-1,d0
		bra.s	TimeScreen_DrawTwoDigitNumber.loop

; =============== S U B R O U T I N E =======================================

TimeScreen_DrawTwoDigitNumber:
		movem.l	d0-d3/a2,-(sp)
		lea	(Hud_10).w,a2
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
		cmp.b	(TimeAttack_flag).w,d6
		bne.s	.skip
		move.w	#$403D,d3

.skip:
		add.w	d3,d2
		move.w	d2,VDP_data_port-VDP_data_port(a6)
		dbf	d0,.loop
		movem.l	(sp)+,d0-d3/a2
		rts

; =============== S U B R O U T I N E =======================================

TimeScreen_LoadDataToPlane_Death:
		lea	(TimeAttack_DeathRAM).w,a1
		locVRAM	$C22E,d4
		moveq	#10-1,d6

TimeScreen_LoadDataToPlane_Death_Loop:
		move.l	d4,VDP_control_port-VDP_control_port(a5)
		move.w	(a1)+,d1
		bmi.s	TimeScreen_LoadDataToPlane_Death_Null
		bsr.s	TimeScreen_DrawThreeDigitNumber

TimeScreen_LoadDataToPlane_Death_Next:
		addi.l	#$1000000,d4
		dbf	d6,TimeScreen_LoadDataToPlane_Death_Loop
		rts
; ---------------------------------------------------------------------------

TimeScreen_LoadDataToPlane_Death_Null:
		moveq	#$33,d2
		move.w	#$203D,d3
		cmp.b	(TimeAttack_flag).w,d6
		bne.s	.skip
		move.w	#$403D,d3

.skip:
		add.w	d3,d2
		move.w	d2,VDP_data_port-VDP_data_port(a6)
		move.w	d2,VDP_data_port-VDP_data_port(a6)
		move.w	d2,VDP_data_port-VDP_data_port(a6)
		bra.s	TimeScreen_LoadDataToPlane_Death_Next

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
		dc.b " RACE XX              *   *    *  ^     ",-1
Time_Race1Text:
		dc.b " RACE 01              *   *    *  ^     ",-1
Time_Race2Text:
		dc.b " RACE 02              *   *    *  ^     ",-1
Time_Race3Text:
		dc.b " RACE 03              *   *    *  ^     ",-1
Time_Race4Text:
		dc.b " RACE 04              *   *    *  ^     ",-1
Time_Race5Text:
		dc.b " RACE 05              *   *    *  ^     ",-1
Time_Race6Text:
		dc.b " RACE 06              *   *    *  ^     ",-1
Time_Race7Text:
		dc.b " RACE 07              *   *    *  ^     ",-1
Time_Race8Text:
		dc.b " RACE 08              *   *    *  ^     ",-1
Time_Race9Text:
		dc.b " RACE 09              *   *    *  ^     ",-1
Time_Race10Text:
		dc.b " RACE 10              *   *    *  ^     ",-1
Time_MainText:
		dc.b "SONIC EPILOGUE - TIME ATTACK                                    ",$98
		dc.b "      PRESS *START* BUTTON TO EXIT      ",-1
	even

		CHARSET ; reset character set
