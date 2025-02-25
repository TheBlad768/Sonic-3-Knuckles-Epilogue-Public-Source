; ---------------------------------------------------------------------------
; HardLine Screen
; ---------------------------------------------------------------------------

vHardLine_Timer:			= Object_load_addr_front		; word
vHardLine_Pixel:				= Object_load_addr_front+2	; word
vHardLine_Deform:			= Object_load_addr_front+4	; long
vHardLine_Deform_Speed:		= Object_load_addr_front+8	; word
vHardLine_End:				= Object_load_addr_front+$A	; byte
vHardLine_Flag:				= Object_load_addr_front+$B	; byte
vHardLine_Deform_Adder:		= Object_load_addr_front+$C	; word

; =============== S U B R O U T I N E =======================================

HardLine_Screen:
		jsr	(Random_Number).w
		andi.w	#1,d0
		seq	(vHardLine_Flag).w
		disableInts
		lea	(MapEni_HardLineFG).l,a0
		lea	(RAM_start+$4000).l,a1
		move.w	#$C229,d0
		jsr	(Eni_Decomp).w
		copyTilemap	(vram_fg+$390), 192, 112
		enableInts

-		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		addq.w	#1,(vHardLine_Deform_Adder).w
		bsr.w	InsertCoinScreen_ScreenEvents
		bsr.w	HardLine_Process
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w

;		tst.b	(Ctrl_1_pressed).w
;		bmi.s	HardLine_PressStart

		tst.b	(vHardLine_End).w
		beq.s	-

HardLine_PressStart:
		disableInts
		stopZ80
		dmaFillVRAM 0,$C000,$1000
		startZ80
		enableInts
		clr.l	(Object_load_addr_front).w
		clr.l	(Object_load_addr_front+4).w
		clr.l	(Object_load_addr_front+8).w
		clr.l	(Object_load_addr_front+$C).w
		clr.b	(Object_load_routine).w
		move.w	#2*60,(Demo_timer).w
		bsr.w	HardLine_Deform_Screen1
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		bra.w	SHC_Screen

; =============== S U B R O U T I N E =======================================

HardLine_Process:
		lea	HardLine_Process_Screen1_Index(pc),a0
		tst.b	(vHardLine_Flag).w
		beq.s	HardLine_Process_Load
		lea	HardLine_Process_Screen2_Index(pc),a0

HardLine_Process_Load:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		adda.w	(a0,d0.w),a0
		jmp	(a0)

; =============== S U B R O U T I N E =======================================

HardLine_Process_Screen1_Index: offsetTable
		offsetTableEntry.w HardLine_Process_Screen1_Init		; 0
		offsetTableEntry.w HardLine_Process_Screen1_Wait		; 2
		offsetTableEntry.w HardLine_Process_Screen1_Show		; 4
		offsetTableEntry.w HardLine_Process_Screen1_Wait		; 6
		offsetTableEntry.w HardLine_Process_Screen1_Sound		; 8
		offsetTableEntry.w HardLine_Process_Screen1_Flash		; A
		offsetTableEntry.w HardLine_Process_Screen1_Wait		; C
		offsetTableEntry.w HardLine_Process_Screen1_Sound2		; E
		offsetTableEntry.w HardLine_Process_Screen1_Leave		; 10
		offsetTableEntry.w HardLine_Process_Screen1_Wait		; 12
		offsetTableEntry.w HardLine_Process_Screen1_End		; 14
; ---------------------------------------------------------------------------

HardLine_Process_Screen1_Init:
		addq.b	#2,(Object_load_routine).w
		move.w	#256,(vHardLine_Deform).w
		bsr.w	HardLine_Deform_Screen1
		bsr.w	HardLine_Process_LoadPalette_Screen2

HardLine_Process_Screen1_Show:
		bsr.w	HardLine_Deform_Screen1_Assembly
		cmpi.w	#$1C0,(vHardLine_Deform_Speed).w
		bne.s	HardLine_Process_Screen1_Wait_Return
		addq.b	#2,(Object_load_routine).w
		clr.w	(vHardLine_Deform).w
		move.w	#1*90,(Demo_timer).w

HardLine_Process_Screen1_Wait:
		tst.w	(Demo_timer).w
		bne.s	HardLine_Process_Screen1_Wait_Return
		addq.b	#2,(Object_load_routine).w

HardLine_Process_Screen1_Wait_Return:
		rts
; ---------------------------------------------------------------------------

HardLine_Process_Screen1_Sound:
		addq.b	#2,(Object_load_routine).w
		move.w	#60,(Demo_timer).w
		sfx	sfx_Electro,0,0,0
		rts
; ---------------------------------------------------------------------------

HardLine_Process_Screen1_Flash:
		lea	(Normal_palette_line_3+8).w,a1
		move.l	#$0408000C,(a1)+
		move.l	#$0A0E0CCA,(a1)+
		btst	#1,(Level_frame_counter+1).w
		beq.s	HardLine_Process_Screen1_Return
		move.l	#$0ACE0EEE,-(a1)
		move.l	#$046800AC,-(a1)
		tst.w	(Demo_timer).w
		bne.s	HardLine_Process_Screen1_Wait_Return
		addq.b	#2,(Object_load_routine).w
		move.w	#1*60,(Demo_timer).w
		rts
; ---------------------------------------------------------------------------

HardLine_Process_Screen1_Sound2:
		addq.b	#2,(Object_load_routine).w
		bsr.w	HardLine_Process_LoadPalette2_Screen1
		sfx	sfx_SpikeAttack,1,0,0
; ---------------------------------------------------------------------------

HardLine_Process_Screen1_Leave:
		move.w	(vHardLine_Deform_Speed).w,d0
		addi.w	#$40,(vHardLine_Deform_Speed).w
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,(vHardLine_Deform).w
		bsr.w	HardLine_Deform_Screen1
		move.w	#256,d0
		cmp.w	(vHardLine_Deform).w,d0
		bhs.s	HardLine_Process_Screen1_Return
		move.w	d0,(vHardLine_Deform).w
		clr.w	(vHardLine_Deform+2).w
		bsr.w	HardLine_Deform_Screen1
		addq.b	#2,(Object_load_routine).w
		clr.w	(vHardLine_Deform_Speed).w
		rts
; ---------------------------------------------------------------------------

HardLine_Process_Screen1_End:
		st	(vHardLine_End).w

HardLine_Process_Screen1_Return:
		rts

; =============== S U B R O U T I N E =======================================

HardLine_Process_Screen2_Index: offsetTable
		offsetTableEntry.w HardLine_Process_Screen2_Init		; 0
		offsetTableEntry.w HardLine_Process_Screen2_Show		; 2
		offsetTableEntry.w HardLine_Process_Screen2_Fix		; 4
		offsetTableEntry.w HardLine_Process_Screen1_Wait		; 6
		offsetTableEntry.w HardLine_Process_Screen1_Sound		; 8
		offsetTableEntry.w HardLine_Process_Screen1_Flash		; A
		offsetTableEntry.w HardLine_Process_Screen1_Wait		; C
		offsetTableEntry.w HardLine_Process_Screen2_Leave		; E
		offsetTableEntry.w HardLine_Process_Screen1_Wait		; 10
		offsetTableEntry.w HardLine_Process_Screen1_End		; 12
; ---------------------------------------------------------------------------

HardLine_Process_Screen2_Init:
		addq.b	#2,(Object_load_routine).w
		move.w	#$138,(vHardLine_Deform_Speed).w

HardLine_Process_Screen2_Show:
		cmpi.w	#$BC,(vHardLine_Deform_Speed).w
		bne.s	+
		bsr.w	HardLine_Process_LoadPalette_Screen2
+
		subq.w	#2,(vHardLine_Deform_Speed).w
		bsr.w	HardLine_Process_Scroll_Screen2
		tst.w	(vHardLine_Deform_Speed).w
		bne.s	HardLine_Process_Screen2_Return
		addq.b	#2,(Object_load_routine).w
		move.w	#1*60,(Demo_timer).w

HardLine_Process_Screen2_Fix:
		bsr.w	HardLine_DeformLoad_Screen2
		tst.w	(Demo_timer).w
		bne.s	HardLine_Process_Screen2_Return
		addq.b	#2,(Object_load_routine).w
		move.w	#0,(Demo_timer).w

HardLine_Process_Screen2_Return:
		rts
; ---------------------------------------------------------------------------

HardLine_Process_Screen2_Leave:
		addq.w	#2,(vHardLine_Deform_Speed).w
		cmpi.w	#$8C,(vHardLine_Deform_Speed).w
		bne.s	+
		bsr.w	HardLine_Process_LoadPalette2_Screen2
+
		bsr.w	HardLine_Process_Scroll_Screen2
		cmpi.w	#$F8,(vHardLine_Deform_Speed).w
		bne.s	HardLine_Process_Screen2_Leave_Return
		addq.b	#2,(Object_load_routine).w
		move.w	#1*60,(Demo_timer).w
		clr.w	(vHardLine_Deform_Speed).w

HardLine_Process_Screen2_Leave_Return:
		rts

; =============== S U B R O U T I N E =======================================

HardLine_Process_Scroll_Screen2:
		bsr.w	HardLine_DeformLoad_Screen2
		lea	(SineTable).w,a1
		lea	(H_scroll_buffer+$E0).w,a0
		move.w	(vHardLine_Deform_Adder).w,d1
		andi.w	#$7F,d1
		lsl.w	#1,d1
		adda.w	d1,a1
		move.w	(a1),d1
		move.w	(vHardLine_Deform_Speed).w,d7
		muls.w	d7,d1
		asr.l	#8,d1
		move.w	d1,(a0)+
		addq.w	#2,a0
		neg.w	d1
		move.w	d1,(a0)
		rts

; =============== S U B R O U T I N E =======================================

HardLine_Process_LoadPalette_Screen2:
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_SmoothPalette,address(a1)
		move.w	#7,subtype(a1)
		move.l	#Pal_HardLine,$30(a1)
		move.w	#Normal_palette_line_3,$34(a1)
		move.w	#16-1,$38(a1)
+		rts

; =============== S U B R O U T I N E =======================================

HardLine_Process_LoadPalette2_Screen1:
		moveq	#4,d3
		bra.s	HardLine_Process_LoadPalette2_Screen2_Load

; =============== S U B R O U T I N E =======================================

HardLine_Process_LoadPalette2_Screen2:
		moveq	#7,d3

HardLine_Process_LoadPalette2_Screen2_Load:
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_SmoothPalette,address(a1)
		move.w	d3,subtype(a1)
		move.l	#Pal_Sega+$40,$30(a1)
		move.w	#Normal_palette_line_3,$34(a1)
		move.w	#16-1,$38(a1)
+		rts

; =============== S U B R O U T I N E =======================================

HardLine_DeformLoad_Screen2:
		lea	(H_scroll_buffer+$15C).w,a0
		lea	(H_scroll_buffer+$158).w,a1
		lea	(H_scroll_buffer+$154).w,a2
		lea	(H_scroll_buffer+$150).w,a3
		moveq	#4-1,d6

-		move.w	#$F,d7

-		move.w	(a2),(a0)
		move.w	(a3),(a1)
		subq.w	#8,a0
		subq.w	#8,a1
		subq.w	#8,a2
		subq.w	#8,a3
		dbf	d7,-
		lea	$F0(a0),a0
		lea	$F0(a1),a1
		lea	$F0(a2),a2
		lea	$F0(a3),a3
		dbf	d6,--
		rts

; =============== S U B R O U T I N E =======================================

HardLine_Deform_Screen1:
		move.w	(vHardLine_Deform).w,d0
		bmi.s	HardLine_Deform_Return
		lea	(H_scroll_buffer).w,a1
		move.w	#(224/2)-1,d6

-	rept 2
		move.w	d0,d1
		move.w	d1,(a1)+
		addq.w	#2,a1
		neg.w	d0
	endm
		dbf	d6,-

HardLine_Deform_Return:
		rts

; =============== S U B R O U T I N E =======================================

HardLine_Deform_Screen2:
		move.w	(vHardLine_Deform).w,d0

		lea	(H_scroll_buffer).w,a1
		move.w	#(224/2)-1,d6

-	rept 2
		move.w	d0,d1
		move.w	d1,(a1)+
		addq.w	#2,a1
		neg.w	d0
	endm
		dbf	d6,-
		rts

; =============== S U B R O U T I N E =======================================

HardLine_Deform_Screen1_Assembly:	; Avengers Assemble!
		move.b	(vHardLine_Deform_Adder+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_SegaKick,0,0,0
+		move.w	(vHardLine_Deform_Speed).w,d0
		lea	(H_scroll_buffer+$E0).w,a1
		adda.w	d0,a1
		move.w	#2-1,d6

HardLine_Deform_Screen1_Loop:
		move.w	#$80,d1
		tst.w	(a1)
		beq.s	HardLine_Deform_Screen1_End
		bpl.s	+
		neg.w	d1
+		sub.w	d1,(a1)+
		addq.w	#2,a1
		dbf	d6,HardLine_Deform_Screen1_Loop
		rts
; ---------------------------------------------------------------------------

HardLine_Deform_Screen1_End:
		addq.w	#4,(vHardLine_Deform_Speed).w
		rts
