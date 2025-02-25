; ---------------------------------------------------------------------------
; SRAM Error Screen
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SRAMError_Screen:
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
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		jsr	(Clear_Palette).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM Oscillating_variables, Oscillating_variables_End
		ResetDMAQueue
		move.l	#ArtUnc_TerminalText2>>1,d1
		move.w	#tiles_to_bytes(1),d2			; VRAM
		move.w	#(ArtUnc_TerminalText2_End-ArtUnc_TerminalText2)/2,d3		; Size/2
		jsr	(Add_To_DMA_Queue).w
		move.l	#$0EEE0EEE,d0
		lea	(Target_palette_line_1+$18).w,a0
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	#$000E000E,d0
		lea	(Target_palette_line_2+$18).w,a0
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		lea	SRAMError_MainText(pc),a1
		locVRAM	$C180,d1
		move.w	#$A000,d3
		jsr	(Load_PlaneText).w
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.s	SRAMError_Deform
		enableScreen
		jsr	(Pal_FadeFromBlack).w

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.s	SRAMError_Deform
		tst.b	(Ctrl_1_pressed).w
		bpl.s	-
		rts

; =============== S U B R O U T I N E =======================================

SRAMError_Deform:
		lea	(V_scroll_buffer).w,a3
		lea	SRAMErrorScroll_Data(pc),a2
		jmp	(HScroll_Deform).w
; ---------------------------------------------------------------------------

SRAMErrorScroll_Data: dScroll_Header
		dScroll_Data 0, 86, -$600, 8
		dScroll_Data 0, 102, $600, 8
		dScroll_Data 0, 118, -$600, 8
		dScroll_Data 0, 134, $600, 8
SRAMErrorScroll_Data_End

; =============== S U B R O U T I N E =======================================

	; set the character
		CHARSET ' ', 0
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

SRAMError_MainText:
		dc.b "      THE SRAM DATA WAS CORRUPTED.",$81
		dc.b "     THE INITIAL DATA WERE RESTORED.",$81
		dc.b "    ALL YOUR RECORDS HAVE BEEN LOST.",$83

		dc.b "SONIC 2077 SONIC 2021 SONIC 2077 SONIC 2021 SONIC 2077 SONIC 20 ",$81
		dc.b "2077 SONIC 2021 SONIC 2077 SONIC 2021 SONIC 2077 SONIC 2021 2077",$81
		dc.b "SONIC 2077 SONIC 2021 SONIC 2077 SONIC 2021 SONIC 2077 SONIC 20 ",$81
		dc.b "2077 SONIC 2021 SONIC 2077 SONIC 2021 SONIC 2077 SONIC 2021 2077",$83
		dc.b "         We Are Deeply Sorry...",$84

		dc.b "    PRESS *START* BUTTON TO CONTINUE",-1
	even

		CHARSET ; reset character set
