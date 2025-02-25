; ---------------------------------------------------------------------------
; Seizure Warning
; ---------------------------------------------------------------------------

Seizure_Speed:			= Object_load_addr_front		; word
Seizure_Deform:			= Object_load_addr_front+2	; word
Seizure_Velocity:			= Object_load_addr_front+4	; long
Seizure_ProcessEnd:		= Object_load_addr_front+8	; byte

; =============== S U B R O U T I N E =======================================

Seizure_Screen:
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
		move.w	#$8B03,(a6)					; Command $8B03 - Vscroll full, HScroll line-based
		move.w	#$8C81,(a6)					; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9011,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		jsr	(Clear_Palette).w
		clr.b	(Intro_flag).w
		clr.l	(Timer).w						; clear time
		clr.b	(Time_over_flag).w
		clr.w	(Water_full_screen_flag).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM Oscillating_variables, Oscillating_variables_End
		ResetDMAQueue
		move.l	#ArtUnc_TerminalText2>>1,d1
		move.w	#tiles_to_bytes(1),d2			; VRAM
		move.w	#(ArtUnc_TerminalText2_End-ArtUnc_TerminalText2)/2,d3		; Size/2
		jsr	(Add_To_DMA_Queue).w
		lea	(Target_palette_line_1+$18).w,a0
		move.l	#$C000A,(a0)+
		move.l	#$80006,(a0)+
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.s	Seizure_Process
		enableScreen
		jsr	(Pal_FadeFromBlack).w

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.s	Seizure_Process
		tst.b	(Seizure_ProcessEnd).w
		beq.s	-
		tst.b	(Ctrl_1_pressed).w
		bpl.s	-
		addq.b	#2,(Object_load_routine).w
		move.w	#-$200,(Seizure_Speed).w
		clr.w	(Seizure_Deform).w
		clr.b	(Seizure_ProcessEnd).w

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.w	Seizure_Process
		tst.b	(Seizure_ProcessEnd).w
		beq.s	-
		moveq	#id_InsertCoinScreen,d0	; set Game Mode
		tst.b	(InsertCoin_Flag).w
		beq.s	+
		moveq	#id_OptionsScreen,d0		; set Game Mode
+		move.b	d0,(Game_mode).w
		rts

; =============== S U B R O U T I N E =======================================

Seizure_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	Seizure_Process_Index(pc,d0.w),d0
		jmp	Seizure_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

Seizure_Process_Index: offsetTable
		offsetTableEntry.w Seizure_Process_SetFGDeform		; 0
		offsetTableEntry.w Seizure_Process_FGDeform		; 2
		offsetTableEntry.w Seizure_Process_ScrollBGText		; 4
		offsetTableEntry.w Seizure_Process_Return			; 6
		offsetTableEntry.w Seizure_Process_ScrollBGText2		; 8
		offsetTableEntry.w Seizure_Process_FGDeform2		; A
		offsetTableEntry.w Seizure_Process_Return			; C
; ---------------------------------------------------------------------------

Seizure_Process_SetFGDeform:
		addq.b	#2,(Object_load_routine).w
		move.w  #$1F,(Seizure_Deform).w

Seizure_Process_FGDeform:
		move.w	#224-1,d6
		move.w	(Seizure_Deform).w,d2
		lea	(H_scroll_buffer).w,a0

-		jsr	(Random_Number).w
		and.w	d2,d0
		move.w	d0,(a0)+
		addq.w	#2,a0
		dbf	d6,-
		cmpi.w	#$18,d2
		bne.s	Seizure_Process_BGDeform_Check
		lea	Seizure_MainText(pc),a1
		locVRAM	$C402,d1
		moveq	#0,d3
		jsr	(Load_PlaneText).w

Seizure_Process_BGDeform_Check:
		subq.w	#1,(Seizure_Deform).w
		bpl.s	Seizure_Process_Return
		addq.b	#2,(Object_load_routine).w
		move.w	#$100,(Seizure_Speed).w
		lea	Seizure_StartText(pc),a1
		locVRAM	$EE14,d1
		moveq	#0,d3
		jmp	(Load_PlaneText).w
; ---------------------------------------------------------------------------

Seizure_Process_ScrollBGText:
		move.w	(Seizure_Speed).w,d0
		subq.w	#8,(Seizure_Speed).w
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,(Seizure_Velocity).w
		move.w	(Seizure_Velocity).w,(V_scroll_value+2).w
		tst.w	(Seizure_Speed).w
		bpl.s	Seizure_Process_Return
		addq.b	#2,(Object_load_routine).w
		st	(Seizure_ProcessEnd).w

Seizure_Process_Return:
		rts
; ---------------------------------------------------------------------------

Seizure_Process_ScrollBGText2:
		move.w	(Seizure_Speed).w,d0
		addi.w	#$20,(Seizure_Speed).w
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,(Seizure_Velocity).w
		move.w	(Seizure_Velocity).w,(V_scroll_value+2).w
		tst.w	(Seizure_Speed).w
		bmi.s	Seizure_Process_Return
		addq.b	#2,(Object_load_routine).w

Seizure_Process_FGDeform2:
		move.w	#224-1,d6
		move.w	(Seizure_Deform).w,d2
		lea	(H_scroll_buffer).w,a0

-		jsr	(Random_Number).w
		and.w	d2,d0
		move.w	d0,(a0)+
		addq.w	#2,a0
		dbf	d6,-
		addq.w	#1,(Seizure_Deform).w
		cmpi.w	#$1F,(Seizure_Deform).w
		blo.s		Seizure_Process_Return
		addq.b	#2,(Object_load_routine).w
		st	(Seizure_ProcessEnd).w
		lea	(Target_palette_line_1+$18).w,a0
		clr.l	(a0)+
		clr.l	(a0)+
		rts

; =============== S U B R O U T I N E =======================================

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

Seizure_MainText:
		dc.b "           EPILEPSY WARNING",$82
		dc.b "  The game contains flashing lights",$81
		dc.b "and particle effects. See Options for",$81
		dc.b "        how to disable them.",-1
Seizure_StartText:
		dc.b "Press *Start* button",-1
	even

		CHARSET ; reset character set
