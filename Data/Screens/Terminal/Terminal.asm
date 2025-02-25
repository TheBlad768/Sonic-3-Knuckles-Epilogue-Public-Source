; ---------------------------------------------------------------------------
; Terminal Screen
; ---------------------------------------------------------------------------

; RAM
vTerminal_Timer:				= Object_load_addr_front		; word
vTerminal_VRAM:			= Object_load_addr_front+2	; long
vTerminal_VRAM2:			= Object_load_addr_front+6	; long
vTerminal_TextRoutine:		= Object_load_addr_front+$A	; byte
vTerminal_Result:				= Object_load_addr_front+$B	; byte
vTerminal_Routine:			= Object_load_addr_front+$C	; byte

; =============== S U B R O U T I N E =======================================

Terminal_Screen:
		sfx	bgm_Stop,0,1,1
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Pal_FadeToBlack).w
		disableInts
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)					; Command $8004 - Disable HInt, HV Counter
		move.w	#$8200+(vram_fg>>10),(a6)	; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)	; Command $8407 - Nametable B at $E000
		move.w	#$8700+(0<<4),(a6)			; Command $8700 - BG color is Pal 0 Color 0
		move.w	#$8B00,(a6)					; Command $8B03 - Vscroll full, HScroll line-based
		move.w	#$8C81,(a6)					; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		jsr	(Clear_Palette).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM Oscillating_variables, Oscillating_variables_End
		ResetDMAQueue
		LoadArtUnc	ArtUnc_TerminalText2, (ArtUnc_TerminalText2_End-ArtUnc_TerminalText2), $20
		move.l	#$0EEE0EEE,d0
		lea	(Target_palette_line_1+$18).w,a0
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	#$000E000E,d0
		lea	(Target_palette_line_2+$18).w,a0
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		locVRAM	$C084,d0
		move.l	d0,(vTerminal_VRAM).w
		move.l	d0,(vTerminal_VRAM2).w
		addi.w	#$1A-$80,(vTerminal_VRAM2).w
		move.w	#1*60,(vTerminal_Timer).w
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.s	Terminal_Process
		bne.s	-
		subq.b	#5,(vTerminal_Result).w
		seq	(GoodMode_flag).w
		bne.w	MiniGame_Screen
		tst.b	(SRAMNone_flag).w
		bne.w	SRAMError_Screen
		tst.b	(SRAMCorrupt_flag).w
		bne.w	SRAMError_Screen
		rts

; =============== S U B R O U T I N E =======================================

Terminal_Process:

; Timer
		subq.w	#1,(vTerminal_Timer).w
		bpl.s	Terminal_CheckTestROM_Bad2
		move.w	#1*10,(vTerminal_Timer).w

; Load text
		moveq	#0,d0
		move.b	(vTerminal_TextRoutine).w,d0
		tst.b	(vTerminal_Routine).w
		bne.s	Terminal_RightText
		st	(vTerminal_Routine).w

; Load left text
		lea	Terminal_MainTextIndex(pc),a2
		move.w	(a2,d0.w),d0
		beq.s	Terminal_CheckTestROM_Done2
		lea	(a2,d0.w),a1
		move.l	(vTerminal_VRAM).w,d1
		move.w	#$80,d0
		add.w	d0,(vTerminal_VRAM).w
		add.w	d0,(vTerminal_VRAM2).w
		moveq	#0,d3
		jsr	(Load_PlaneText).w
		bra.s	Terminal_CheckTestROM_Bad2
; ---------------------------------------------------------------------------

Terminal_RightText:
		clr.b	(vTerminal_Routine).w

; Load right text
		addq.b	#2,(vTerminal_TextRoutine).w
		lea	Terminal_MainText2Index(pc),a2
		move.w	(a2,d0.w),d0
		beq.s	Terminal_CheckTestROM_Bad2
		jsr	(a2,d0.w)
		bne.s	+
		addq.b	#1,(vTerminal_Result).w
+		move.l	(vTerminal_VRAM2).w,d1
		jsr	(Load_PlaneText).w
		bra.s	Terminal_CheckTestROM_Bad2

; =============== S U B R O U T I N E =======================================

Terminal_CheckTestROM:
		lea	OK_Text(pc),a1
		tst.b	(Checksum_flag).w
		bne.s	Terminal_CheckTestROM_Done
		lea	BAD_Text(pc),a1

Terminal_CheckTestROM_Bad:
		move.w	#$2000,d3

Terminal_CheckTestROM_Bad2:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

Terminal_CheckTestSRAM_Done:
		gotoROM
		enableIntsSave

Terminal_CheckTestROM_Done:
		moveq	#0,d3

Terminal_CheckTestROM_Done2:
		moveq	#0,d0
		rts

; =============== S U B R O U T I N E =======================================

Terminal_CheckTestSRAM:
		disableIntsSave
		gotoSRAM
		lea	ON_Text(pc),a1
		move.l	(SRAM_Size+SRAM_Type.Initial_Startup).l,d0
		cmp.l	(Checksum_string).w,d0
		sne	(SRAMNone_flag).w
		beq.s	Terminal_CheckTestSRAM_Done
		lea	NONE_Text(pc),a1
		bra.s	Terminal_CheckTestSRAM_Done

; =============== S U B R O U T I N E =======================================

Terminal_CheckTestRegion:
		moveq	#0,d0
		btst	#6,(Graphics_flags).w
		beq.s	Terminal_CheckTestRegion_Frequency	; Set NTSC
		addq.w	#2*2,d0								; Set PAL

Terminal_CheckTestRegion_Frequency:
		btst	#0,(VDP_control_port+1).l
		beq.s	Terminal_CheckTestRegion_LoadText	; Set 60hz
		addq.w	#1*2,d0								; Set 50hz

Terminal_CheckTestRegion_LoadText:
		move.w	Terminal_RegionTextIndex(pc,d0.w),d0
		lea	Terminal_RegionTextIndex(pc,d0.w),a1
		bra.s	Terminal_CheckTestROM_Done

; =============== S U B R O U T I N E =======================================

Terminal_CheckTestEmulator:
		moveq	#0,d0
		lea	NONE_Text(pc),a1
		move.b	(Emulator_flag).w,d0
		beq.s	Terminal_CheckTestROM_Bad
		add.w	d0,d0
		move.w	Terminal_EmulatorTextIndex-2(pc,d0.w),d0
		lea	Terminal_EmulatorTextIndex(pc,d0.w),a1
		bra.s	Terminal_CheckTestROM_Done

; =============== S U B R O U T I N E =======================================

Terminal_CheckTestMSU:
		lea	NONE_Text(pc),a1
		tst.b	(SegaCD_flag).w
		beq.s	Terminal_CheckTestROM_Done
		lea	ON_Text(pc),a1
		cmpi.b	#EMU_KEGA,(Emulator_flag).w
		sne	(SegaCD_Mode).w
		bne.s	Terminal_CheckTestMSU_CheckMSU
		bra.w	Terminal_CheckTestROM_Bad
; ---------------------------------------------------------------------------

Terminal_CheckTestMSU_CheckMSU:
		tst.b	(Kega_flag).w
		bne.w	Terminal_CheckTestROM_Done
		moveq	#0,d3	; Fake
		bra.w	Terminal_CheckTestROM_Bad2
; ---------------------------------------------------------------------------

	; set the character
		CHARSET ' ', 0
		CHARSET '0','9', 1
		CHARSET '!', $B
		CHARSET '?', $C
		CHARSET '*', $10
		CHARSET ':', $13
		CHARSET '.', $14
		CHARSET 'A','Z', $1D
		CHARSET 'a','z', $1D

Terminal_MainTextIndex: offsetTable
		offsetTableEntry.w EpilogueTerminal_Text	; 0
		offsetTableEntry.w BeatorDeath_Text		; 1
		offsetTableEntry.w TurnOff_Text			; 2
		offsetTableEntry.w NotJoke_Text			; 3
		offsetTableEntry.w Wait_Text				; 4
		offsetTableEntry.w ROM_Text				; 5
		offsetTableEntry.w SRAM_Text				; 6
		offsetTableEntry.w EMULATOR_Text		; 7
		offsetTableEntry.w REGION_Text			; 8
		offsetTableEntry.w MSU_Text				; 9
		offsetTableEntry.w PleaseWait_Text			; 10
		offsetTableEntry.w Terminal_MainTextIndex	; End

Terminal_MainText2Index: offsetTable
		offsetTableEntry.w Terminal_MainText2Index		; 0 (Null)
		offsetTableEntry.w Terminal_MainText2Index		; 1 (Null)
		offsetTableEntry.w Terminal_MainText2Index		; 2 (Null)
		offsetTableEntry.w Terminal_MainText2Index		; 3 (Null)
		offsetTableEntry.w Terminal_MainText2Index		; 4 (Null)
		offsetTableEntry.w Terminal_CheckTestROM		; 5
		offsetTableEntry.w Terminal_CheckTestSRAM		; 6
		offsetTableEntry.w Terminal_CheckTestEmulator	; 7
		offsetTableEntry.w Terminal_CheckTestRegion	; 8
		offsetTableEntry.w Terminal_CheckTestMSU		; 9
		offsetTableEntry.w Terminal_MainText2Index		; 10

Terminal_RegionTextIndex: offsetTable
		offsetTableEntry.w NTSC60_Text				; 0
		offsetTableEntry.w NTSC50_Text				; 1
		offsetTableEntry.w PAL60_Text					; 2
		offsetTableEntry.w PAL50_Text					; 3

Terminal_EmulatorTextIndex: offsetTable
		offsetTableEntry.w TerminalHardware_Text		; 1
		offsetTableEntry.w TerminalGPGX_Text			; 2
		offsetTableEntry.w TerminalRegen_Text			; 3
		offsetTableEntry.w TerminalKega_Text			; 4
		offsetTableEntry.w TerminalGens_Text			; 5
		offsetTableEntry.w TerminalBlastem_Text		; 6
		offsetTableEntry.w TerminalExodus_Text			; 7
		offsetTableEntry.w TerminalMegaSG_Text		; 8
		offsetTableEntry.w TerminalSteam_Text			; 9
		offsetTableEntry.w TerminalPicodrive_Text		; A
		offsetTableEntry.w TerminalFlashback_Text		; B
		offsetTableEntry.w TerminalFirecore_Text		; C
		offsetTableEntry.w TerminalGenecyst_Text		; D

EpilogueTerminal_Text:	dc.b "Epilogue Terminal",-1
BeatorDeath_Text:		dc.b "Fight or Flight!",-1
TurnOff_Text:			dc.b "Don*t turn off the system!",-1
NotJoke_Text:			dc.b "This is not a joke!",-1
Wait_Text:				dc.b "...",-1
ROM_Text:				dc.b "ROM        :",-1
SRAM_Text:				dc.b "SRAM       :",-1
REGION_Text:			dc.b "REGION     :",-1
EMULATOR_Text:		dc.b "SYSTEM     :",-1
MSU_Text:				dc.b "MSU        :",-1
PleaseWait_Text:			dc.b "Please Wait...",-1
OK_Text:				dc.b "OK",-1
ON_Text:				dc.b "ON",-1
NONE_Text:				dc.b "NONE",-1
BAD_Text:				dc.b "BAD",-1
NTSC60_Text:			dc.b "NTSC 60",-1
NTSC50_Text:			dc.b "NTSC 50",-1
PAL50_Text:				dc.b "PAL 50",-1
PAL60_Text:				dc.b "PAL 60",-1
TerminalHardware_Text:	dc.b "HARDWARE",-1
TerminalGPGX_Text:		dc.b "GENESIS PLUS GX",-1
TerminalRegen_Text:		dc.b "REGEN",-1
TerminalKega_Text:		dc.b "KEGA FUSION",-1
TerminalGens_Text:		dc.b "GENS",-1
TerminalBlastem_Text:	dc.b "BLASTEM",-1
TerminalExodus_Text:		dc.b "EXODUS",-1
TerminalMegaSG_Text:	dc.b "MEGASG",-1
TerminalSteam_Text:		dc.b "STEAM EMULATOR",-1
TerminalPicodrive_Text:	dc.b "PICODRIVE",-1
TerminalFlashback_Text:	dc.b "FLASHBACK",-1
TerminalFirecore_Text:	dc.b "FIRECORE",-1
TerminalGenecyst_Text:	dc.b "GENECYST",-1
	even

		CHARSET ; reset character set
