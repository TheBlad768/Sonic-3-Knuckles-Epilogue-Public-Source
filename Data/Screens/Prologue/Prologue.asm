; ---------------------------------------------------------------------------
; Prologue Screen
; ---------------------------------------------------------------------------

; RAM
vPrologue_Buffer:				= $FFFF2000		; $800 bytes
vPrologue_FactorBuffer:		= $FFFF2800			; $800 bytes

vPrologue_Timer:				= Object_load_addr_front		; word
vPrologue_TextFactor:			= Object_load_addr_front+2	; byte
vPrologue_End:				= Object_load_addr_front+3	; byte
vPrologue_Wait:				= Object_load_addr_front+4	; byte

; =============== S U B R O U T I N E =======================================

Prologue_Screen:
		lea	(Pal_Title).l,a1
		jsr	(PalLoad_Line0).w
		move.b	#$14,(vPrologue_TextFactor).w
		move.l	#Obj_Prologue_Shadow,(Object_RAM).w
		move.w	#$8225,(Object_RAM+art_tile).w

-		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		bsr.w	PrologueScreen_Process
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		tst.b	(vPrologue_End).w
		beq.s	-

PrologueScreen_PressStart:
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
		clr.w	(Camera_Y_pos).w
		lea	(Object_RAM).w,a1
		jsr	(Delete_Referenced_Sprite).w
		move.w	#2*60,(Demo_timer).w
		bsr.w	HardLine_Deform_Screen1
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		bra.w	Transition_Screen

; =============== S U B R O U T I N E =======================================

PrologueScreen_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	PrologueScreen_Process_Index(pc,d0.w),d0
		jmp	PrologueScreen_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

PrologueScreen_Process_Index: offsetTable
		offsetTableEntry.w PrologueScreen_Process_Wait			; 0
		offsetTableEntry.w PrologueScreen_Process_PlaySound		; 2
		offsetTableEntry.w PrologueScreen_Process_LoadText		; 4
		offsetTableEntry.w PrologueScreen_Process_CheckScroll	; 6
		offsetTableEntry.w PrologueScreen_Process_HideText		; 8
		offsetTableEntry.w PrologueScreen_Process_Wait			; A
		offsetTableEntry.w PrologueScreen_Process_End			; C
; ---------------------------------------------------------------------------

PrologueScreen_Process_Wait:
		tst.w	(Demo_timer).w
		bne.s	PrologueScreen_Process_Wait_Return

PrologueScreen_Process_PlaySound_End:
		addq.b	#2,(Object_load_routine).w

PrologueScreen_Process_Wait_Return:
		rts
; ---------------------------------------------------------------------------

PrologueScreen_Process_PlaySound:
		music	bgm_Prologue,0,0,0
		bra.s	PrologueScreen_Process_PlaySound_End
; ---------------------------------------------------------------------------

PrologueScreen_Process_LoadText:
		cmpi.w	#32,(Camera_Y_pos).w
		blo.s		PrologueScreen_Process_CheckScroll
		tst.b	(vPrologue_TextFactor).w
		beq.s	PrologueScreen_Process_LoadText_End
		subq.w	#1,(vPrologue_Timer).w
		bpl.s	PrologueScreen_Process_CheckScroll
		move.w	#1,(vPrologue_Timer).w
		lea	(vPrologue_Buffer).l,a1			; Mod Art
		lea	(vPrologue_FactorBuffer).l,a2	; Tile factor
		bsr.w	SmoothDrawArtText
		move.l	#vPrologue_Buffer>>1,d1
		move.w	#tiles_to_bytes($340),d2	; VRAM
		bsr.w	SmoothLoadArtText
		bra.s	PrologueScreen_Process_CheckScroll
; ---------------------------------------------------------------------------

PrologueScreen_Process_LoadText_End:
		addq.b	#2,(Object_load_routine).w

PrologueScreen_Process_CheckScroll:
		tst.b	(vPrologue_Wait).w
		beq.s	PrologueScreen_Process_NoSkipScroll
		tst.b	(Ctrl_1_pressed).w
		bmi.s	PrologueScreen_Process_SkipScroll

PrologueScreen_Process_NoSkipScroll:
		cmpi.w	#60,(Camera_Y_pos).w
		bne.s	PrologueScreen_Process_ToScroll
		st	(vPrologue_Wait).w

PrologueScreen_Process_ToScroll:
		cmpi.w	#572,(Camera_Y_pos).w
		blo.s		PrologueScreen_Process_Scroll

PrologueScreen_Process_SkipScroll:
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vPrologue_TextFactor).w

PrologueScreen_Process_Scroll:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#3,d0
		bne.s	+
		addq.w	#1,(Camera_Y_pos).w
+		move.w	(Camera_Y_pos).w,d1
		lea	Prologue_MainTextIndex(pc),a1
		locVRAM	$C000,d3
		bra.w	Copy_Map_Line_To_VRAM_Prologue
; ---------------------------------------------------------------------------

PrologueScreen_Process_HideText:
		tst.b	(vPrologue_TextFactor).w
		beq.s	PrologueScreen_Process_HideText_End
		subq.w	#1,(vPrologue_Timer).w
		bpl.s	PrologueScreen_Process_Scroll
		move.w	#1,(vPrologue_Timer).w
		lea	(vPrologue_Buffer).l,a1			; Mod Art
		lea	(vPrologue_FactorBuffer).l,a2	; Tile factor
		bsr.w	SmoothHideArtText
		move.l	#vPrologue_Buffer>>1,d1
		move.w	#tiles_to_bytes($340),d2	; VRAM
		bsr.w	SmoothLoadArtText
		bra.s	PrologueScreen_Process_Scroll
; ---------------------------------------------------------------------------

PrologueScreen_Process_HideText_End:
		addq.b	#2,(Object_load_routine).w
		move.w	#1*90,(Demo_timer).w
		rts
; ---------------------------------------------------------------------------

PrologueScreen_Process_End:
		st	(vPrologue_End).w
		rts

; =============== S U B R O U T I N E =======================================

Copy_Map_Line_To_VRAM_Prologue:
		subi.w	#32,d1
		bcs.s	Copy_Map_Line_To_VRAM_Prologue_Return
		move.w	d1,d0
		andi.w	#$F,d0
		bne.s	Copy_Map_Line_To_VRAM_Prologue_Return

; Calc Map
		move.w	d1,d2			; copy 16
		lsr.w	#3,d1
		adda.w	(a1,d1.w),a1

; Calc VRAM
		andi.w	#$F8,d2			; 256 pixel
		lsl.w	#4,d2
		swap	d3
		add.w	d2,d3
		swap	d3
		moveq	#320/8-1,d1		; Max 40 characters
		bsr.w	Calculate_TextPosition

; Load Tiles
		disableInts
		move.l	d3,VDP_control_port-VDP_control_port(a5)
		moveq	#0,d3
		move.b	(a1)+,d3
		ror.w	#3,d3

-		moveq	#0,d1
		move.b	(a1)+,d1
		bmi.s	Copy_Map_Line_To_VRAM_Prologue_Clear
		or.w	d3,d1
		addi.w	#$33F,d1
		move.w	d1,VDP_data_port-VDP_data_port(a6)
		dbf	d6,-
		enableInts

Copy_Map_Line_To_VRAM_Prologue_Return:
		rts
; ---------------------------------------------------------------------------

Copy_Map_Line_To_VRAM_Prologue_Clear:
		moveq	#0,d1
		moveq	#320/8-1,d6

-		move.w	d1,VDP_data_port-VDP_data_port(a6)
		dbf	d6,-
		enableInts
		rts
; ---------------------------------------------------------------------------
; Calculates the position to display text in the middle of the screen
; Inputs:
; d3 = plane address
; a1 = source address
; Outputs:
; d1 = calculated data
; d3 = calculated plane address
; d6 = text size
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Calculate_TextPosition:
		disableIntsSave
		movem.l	d0/d2/d4,-(sp)
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		moveq	#0,d0
		moveq	#1,d4
		move.w	d1,d6
		move.l	d3,VDP_control_port-VDP_control_port(a5)

-		move.w	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d6,-
		move.l	d3,VDP_control_port-VDP_control_port(a5)
		move.b	(a1)+,d0
		move.w	d0,d6
		add.w	d4,d0
		sub.w	d0,d1
		move.w	d1,d2
		and.w	d4,d2
		lsr.w	d1
		add.w	d2,d1

;		add.w	d4,d1

		add.w	d1,d1
		swap	d1
		clr.w	d1
		add.l	d1,d3
		movem.l	(sp)+,d0/d2/d4
		enableIntsSave
		rts

; =============== S U B R O U T I N E =======================================

Obj_Prologue_Shadow:
		move.l	#Map_PrologueShadow,mappings(a0)
		move.w	#$80,x_pos(a0)
		move.w	#$100,y_pos(a0)
		move.l	#Prologue_Shadow_Draw,address(a0)

Prologue_Shadow_Draw:
		move.w	#$80,d0
		btst	#0,(Level_frame_counter+1).w
		beq.s	+
		addq.w	#1,d0
+		move.w	d0,x_pos(a0)
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Prologue_MainTextIndex: offsetTable
		offsetTableEntry.w Prologue_MainText1
		offsetTableEntry.w Prologue_MainText2
		offsetTableEntry.w Prologue_MainText3
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainText4
		offsetTableEntry.w Prologue_MainText5
		offsetTableEntry.w Prologue_MainText6
		offsetTableEntry.w Prologue_MainText7
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainText8
		offsetTableEntry.w Prologue_MainText9
		offsetTableEntry.w Prologue_MainText10
		offsetTableEntry.w Prologue_MainText11
		offsetTableEntry.w Prologue_MainText12
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainText13
		offsetTableEntry.w Prologue_MainText14
		offsetTableEntry.w Prologue_MainText15
		offsetTableEntry.w Prologue_MainText16
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainText17

; Null
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull
		offsetTableEntry.w Prologue_MainTextNull

Prologue_MainText1:		prologuestr $00, "With his surprise attack Dr. Robotnik"
Prologue_MainText2:		prologuestr $00, "was able to get his dastardly hands"
Prologue_MainText3:		prologuestr $00, "on the Master Emerald once again."

Prologue_MainText4:		prologuestr $00, "Sonic was able to jump onto"
Prologue_MainText5:		prologuestr $00, "the emerald just in the nick of time"
Prologue_MainText6:		prologuestr $00, "and is now floating in space near"
Prologue_MainText7:		prologuestr $00, "the Death Egg."

Prologue_MainText8:		prologuestr $00, "He would*ve perished if not for Tails*"
Prologue_MainText9:		prologuestr $00, "latest invention, the jetpack."
Prologue_MainText10:		prologuestr $00, "It will help the hedgehog infiltrate"
Prologue_MainText11:		prologuestr $00, "the base and put an end to"
Prologue_MainText12:		prologuestr $00, "Dr. Robotnik*s plans."

Prologue_MainText13:		prologuestr $00, "The final battle would not be fought"
Prologue_MainText14:		prologuestr $00, "in the future."
Prologue_MainText15:		prologuestr $00, "It would be fought here, in our"
Prologue_MainText16:		prologuestr $00, "present.  "
Prologue_MainText17:		prologuestr $00, "Tonight..."
Prologue_MainTextNull:	dc.b 0, 0, -1
	even
; ---------------------------------------------------------------------------

		include "Data/Screens/Prologue/Object Data/Map - Shadow.asm"