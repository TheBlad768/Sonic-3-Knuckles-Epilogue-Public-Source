; ---------------------------------------------------------------------------
; SHC Screen
; ---------------------------------------------------------------------------

vSHC_Timer:					= Object_load_addr_front		; word
vSHC_TextFactor:				= Object_load_addr_front+2	; word
vSHC_Index:					= Object_load_addr_front+4	; byte
vSHC_End:					= Object_load_addr_front+$A	; byte
vSHC_NoScrollFG:			= Object_load_addr_front+$E	; byte

; =============== S U B R O U T I N E =======================================

SHC_Screen:
		lea	PLC_SHC(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(Pal_SHC).l,a1
		lea	(Normal_palette).w,a2
		jsr	(PalLoad_Line16).w
		st	(vSHC_NoScrollFG).w
		move.w	#$3F,(Demo_timer).w

-		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		bsr.w	SHCScreen_Process
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w

;		tst.b	(Ctrl_1_pressed).w
;		bmi.s	SHCScreen_PressStart

		tst.b	(vSHC_End).w
		beq.s	-

SHCScreen_PressStart:
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
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		bra.w	Prologue_Screen

; =============== S U B R O U T I N E =======================================

SHCScreen_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	SHCScreen_Process_Index(pc,d0.w),d0
		jmp	SHCScreen_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SHCScreen_Process_Index: offsetTable
		offsetTableEntry.w SHCScreen_Process_Wait			; 0
		offsetTableEntry.w SHCScreen_Process_Init			; 2
		offsetTableEntry.w SHCScreen_Process_Init2			; 4
		offsetTableEntry.w SHCScreen_Process_Init3			; 6
		offsetTableEntry.w SHCScreen_Process_LoadFG		; 8
		offsetTableEntry.w SHCScreen_Process_WaitSound	; A
		offsetTableEntry.w SHCScreen_Process_Flash			; C
		offsetTableEntry.w SHCScreen_Process_WaitSound2	; E
		offsetTableEntry.w SHCScreen_Process_HideFG		; 10
		offsetTableEntry.w SHCScreen_Process_Return		; 12
; ---------------------------------------------------------------------------

SHCScreen_Process_Wait:
		tst.w	(Demo_timer).w
		bne.s	SHCScreen_Process_Init_Return
		addq.b	#2,(Object_load_routine).w

SHCScreen_Process_Init:
		tst.w	(Kos_modules_left).w
		bne.s	SHCScreen_Process_Init_Return
		addq.b	#2,(Object_load_routine).w
		sfx	sfx_SpikeAttack2,0,0,0
		lea	(MapEni_SHCFG1).l,a0
		lea	(RAM_start+$4000).l,a1
		move.w	#$8250,d0
		jsr	(Eni_Decomp).w
		disableInts
		copyTilemap	$B000, 320, 224
		move.w	#$9011,(VDP_control_port).l
		enableInts

SHCScreen_Process_Init_Return:
		rts
; ---------------------------------------------------------------------------

SHCScreen_Process_Init2:
		addq.b	#2,(Object_load_routine).w
		lea	(MapEni_SHCFG2).l,a0
		lea	(RAM_start+$4000).l,a1
		move.w	#$8250,d0
		jsr	(Eni_Decomp).w
		disableInts
		copyTilemap	$A000, 320, 224
		enableInts

SHCScreen_Process_Init2_Return:
		rts
; ---------------------------------------------------------------------------

SHCScreen_Process_Init3:
		addq.b	#2,(Object_load_routine).w
		lea	(MapEni_SHCFG3).l,a0
		lea	(RAM_start+$4000).l,a1
		move.w	#$8250,d0
		jmp	(Eni_Decomp).w
; ---------------------------------------------------------------------------

SHCScreen_Process_LoadFG:
		move.w	(vSHC_TextFactor).w,d1
		addq.w	#8,(vSHC_TextFactor).w
		locVRAM	$C000,d0
		lea	(RAM_start+$4000).l,a1
		jsr	(Copy_Map_Line_To_VRAM).w
		cmpi.w	#$100,(vSHC_TextFactor).w
		blo.s		SHCScreen_Process_Init2_Return
		addq.b	#2,(Object_load_routine).w
		clr.w	(vSHC_TextFactor).w
		move.w	#$1F,(Demo_timer).w

SHCScreen_Process_WaitSound:
		tst.w	(Demo_timer).w
		bne.s	SHCScreen_Process_Return
		addq.b	#2,(Object_load_routine).w
		sfx	sfx_Activation,0,0,0

SHCScreen_Process_Flash:
		subq.w	#1,(vSHC_Timer).w
		bpl.s	SHCScreen_Process_Return
		bsr.s	SHCScreen_Flash
		tst.w	(a1)
		bpl.s	SHCScreen_Process_Return
		addq.b	#2,(Object_load_routine).w
		move.w	#$5F,(Demo_timer).w
		disableInts
		move.w	#$9001,(VDP_control_port).l
		enableInts

SHCScreen_Process_WaitSound2:
		tst.w	(Demo_timer).w
		bne.s	SHCScreen_Process_Return
		addq.b	#2,(Object_load_routine).w
		sfx	sfx_SpikeAttack2,0,0,0

SHCScreen_Process_HideFG:
		move.w	(vSHC_TextFactor).w,d1
		addq.w	#8,(vSHC_TextFactor).w
		locVRAM	$C000,d0
		bsr.w	InsertCoin_Clear_Map_Line_To_VRAM
		cmpi.w	#$100,(vSHC_TextFactor).w
		blo.s		SHCScreen_Process_Return
		addq.b	#2,(Object_load_routine).w
		st	(vSHC_End).w
		lea	PLC_Sega(pc),a5
		jsr	(LoadPLC_Raw_KosM).w

SHCScreen_Process_Return:
		rts

; =============== S U B R O U T I N E =======================================

SHCScreen_Flash:
		move.b	(vSHC_Index).w,d0
		addq.b	#1,(vSHC_Index).w
		andi.w	#$3F,d0
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	SHCScreen_Flash_Data(pc,d0.w),a1
		move.w	(a1)+,(V_scroll_value).w
		move.w	(a1)+,(vSHC_Timer).w
		disableInts
		move.w	(a1)+,(VDP_control_port).l
		enableInts
		rts
; ---------------------------------------------------------------------------

SHCScreen_Flash_Data:

; 0
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)

; 1
		dc.w 256						; VScroll
		dc.w $F						; Timer
		dc.w $8200+($A000>>10)
; 2
		dc.w 0						; VScroll
		dc.w 7						; Timer
		dc.w $8200+($A000>>10)
; 3
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
; 4
		dc.w 256						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; 5
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; 6
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
; 7
		dc.w 256						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; 8
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; 9
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
; A
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; B
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
; C
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; D
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
; E
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; F
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
; 10
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; 11
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
; 12
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; 13
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
; 14
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; 15
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
; 16
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; 17
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
; 18
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)
; 19
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
; 1A
		dc.w 0						; VScroll
		dc.w 1						; Timer
		dc.w $8200+($A000>>10)



; End
		dc.w 0						; VScroll
		dc.w 0						; Timer
		dc.w $8200+(vram_fg>>10)	; Screen
		dc.w -1

; =============== S U B R O U T I N E =======================================

PLC_SHC: plrlistheader
		plreq $250, ArtKosM_SHC
PLC_SHC_End
