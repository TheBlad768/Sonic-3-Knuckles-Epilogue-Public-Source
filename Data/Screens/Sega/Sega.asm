; ---------------------------------------------------------------------------
; Sega Screen
; ---------------------------------------------------------------------------

vSega_Timer:					= Object_load_addr_front		; word
vSega_Pixel:					= Object_load_addr_front+2	; word
vSega_Deform:				= Object_load_addr_front+4	; long
vSega_Deform_Speed:			= Object_load_addr_front+8	; word
vSega_End:					= Object_load_addr_front+$A	; byte

; =============== S U B R O U T I N E =======================================

Sega_Screen:
		disableInts
		lea	(MapEni_SegaFG).l,a0
		lea	(RAM_start+$4000).l,a1
		move.w	#$81EF,d0
		jsr	(Eni_Decomp).w
		copyTilemap	(vram_fg+$5DC), 98, 32
		btst	#6,(Graphics_flags).w
		bne.s	+				; branch if it isn't a PAL system
		locVRAM	(vram_fg+$5F0)
		move.l	#$821F8220,(VDP_data_port).l
+		enableInts
		lea	(Pal_Sega).l,a1
		lea	(Normal_palette).w,a2
		jsr	(PalLoad_Line64).w
		move.w	#2*60,(Demo_timer).w

-		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	InsertCoinScreen_ScreenEvents
		bsr.w	SegaScreen_Process
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w

;		tst.b	(Ctrl_1_pressed).w
;		bmi.s	SegaScreen_PressStart

		tst.b	(vSega_End).w
		beq.s	-

SegaScreen_PressStart:
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
		bra.w	HardLine_Screen

; =============== S U B R O U T I N E =======================================

SegaScreen_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	SegaScreen_Process_Index(pc,d0.w),d0
		jmp	SegaScreen_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SegaScreen_Process_Index: offsetTable
		offsetTableEntry.w SegaScreen_Process_Wait					; 0
		offsetTableEntry.w SegaScreen_Process_LoadParticles			; 2
		offsetTableEntry.w SegaScreen_Process_AnPal				; 4
		offsetTableEntry.w SegaScreen_Process_LoadParticles2_Init		; 6
		offsetTableEntry.w SegaScreen_Process_LoadParticles2			; 8
		offsetTableEntry.w SegaScreen_Process_Wait					; A
		offsetTableEntry.w SegaScreen_Process_End					; C
; ---------------------------------------------------------------------------

SegaScreen_Process_AnPal:
		bsr.w	AnPal_SegaScreen
		cmpi.w	#5*52,(Demo_timer).w
		bne.s	SegaScreen_Process_Wait
		sfx	sfx_SegaPresent,0,0,0

SegaScreen_Process_Wait:
		tst.w	(Demo_timer).w
		bne.s	SegaScreen_Process_Wait_Return
		addq.b	#2,(Object_load_routine).w

SegaScreen_Process_Wait_Return:
		rts
; ---------------------------------------------------------------------------

SegaScreen_Process_LoadParticles:
		bsr.w	Sega_Deform
		bsr.w	Sega_LoadParticles
		btst	#2,(Demo_timer+1).w
		beq.s	+
		sfx	sfx_SegaKick,0,0,0
+		tst.w	(Demo_timer).w
		bne.s	SegaScreen_Process_Wait_Return
		move.w	#8,(Demo_timer).w
		addq.w	#2,(vSega_Pixel).w
		cmpi.w	#36,(vSega_Pixel).w
		bne.s	SegaScreen_Process_Wait_Return
		addq.b	#2,(Object_load_routine).w
		move.w	#(5*60)-20,(Demo_timer).w
		rts
; ---------------------------------------------------------------------------

SegaScreen_Process_LoadParticles2_Init:
		addq.b	#2,(Object_load_routine).w
		clr.w	(vSega_Pixel).w

SegaScreen_Process_LoadParticles2:
		bsr.w	Sega_Deform2
		bsr.w	Sega_LoadParticles2
		btst	#2,(Demo_timer+1).w
		beq.s	+
		sfx	sfx_SegaKick,0,0,0
+		tst.w	(Demo_timer).w
		bne.s	SegaScreen_Process_Wait_Return
		move.w	#8,(Demo_timer).w
		addq.w	#2,(vSega_Pixel).w
		cmpi.w	#36,(vSega_Pixel).w
		bne.s	SegaScreen_Process_Wait_Return
		addq.b	#2,(Object_load_routine).w
		move.w	#(1*60)+20,(Demo_timer).w
		rts
; ---------------------------------------------------------------------------

SegaScreen_Process_End:
		st	(vSega_End).w
		rts

; =============== S U B R O U T I N E =======================================

AnPal_SegaScreen:
		lea	(Palette_cycle_counters).w,a0
		subq.w	#1,(a0)
		bpl.s	AnPal_SegaScreen_Return
		addq.w	#3,(a0)
		lea	(Pal_SegaAni).l,a1
		move.w	2(a0),d0
		addq.w	#2,2(a0)
		cmpi.w	#$20,2(a0)
		blo.s		.skip
		clr.w	2(a0)

.skip:
		lea	(a1,d0.w),a1
		lea	(Normal_palette_line_2-4).w,a2
	rept 12
		move.w	(a1)+,-(a2)
	endm

AnPal_SegaScreen_Return:
		rts

; =============== S U B R O U T I N E =======================================

Sega_Deform:
		move.w	(vSega_Pixel).w,d5
		lea	(H_scroll_buffer+(86*4)).w,a1

-		move.w	#256,(a1)+
		addq.w	#2,a1
		dbf	d5,-
		rts
; ---------------------------------------------------------------------------

Sega_Deform2:
		move.w	(vSega_Pixel).w,d5
		lea	(H_scroll_buffer+(120*4)).w,a1

-		clr.w	(a1)
		subq.w	#4,a1
		dbf	d5,-
		rts

; =============== S U B R O U T I N E =======================================

Sega_LoadParticles:
		subq.w	#1,(vSega_Timer).w
		bpl.s	Sega_LoadParticles_Return
		move.w	#7,(vSega_Timer).w
		move.w	#$F0,d3
		moveq	#0,d2
		moveq	#10-1,d6

-		jsr	(Create_New_Sprite).w
		bne.s	Sega_LoadParticles_Return
		move.l	#Obj_SegaParticles,address(a1)
		move.w	#$80+96,d4
		add.w	(vSega_Pixel).w,d4
		move.w	d4,y_pos(a1)
		move.w	d3,x_pos(a1)
		addq.w	#8,d3
		move.b	d2,subtype(a1)
		addq.w	#2,d2
		dbf	d6,-

Sega_LoadParticles_Return:
		rts

; =============== S U B R O U T I N E =======================================

Sega_LoadParticles2:
		subq.w	#1,(vSega_Timer).w
		bpl.s	Sega_LoadParticles2_Return
		move.w	#7,(vSega_Timer).w
		move.w	#$F0,d3
		moveq	#0,d2
		moveq	#10-1,d6

-		jsr	(Create_New_Sprite).w
		bne.s	Sega_LoadParticles2_Return
		move.l	#Obj_SegaParticles2,address(a1)
		move.w	#$80+128,d4
		sub.w	(vSega_Pixel).w,d4
		move.w	d4,y_pos(a1)
		move.w	d3,x_pos(a1)
		addq.w	#8,d3
		move.b	d2,subtype(a1)
		addq.w	#2,d2
		dbf	d6,-

Sega_LoadParticles2_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_SegaParticles2:
		jsr	(Random_Number).w
		andi.w	#$1F,d0
		move.w	#$81F0,d1
		bra.s	SegaParticles_Load

; =============== S U B R O U T I N E =======================================

Obj_SegaParticles:
		jsr	(Random_Number).w
		andi.w	#4-1,d0
		move.w	#$8221,d1

SegaParticles_Load:
		add.w	d0,d1
		move.w	d1,art_tile(a0)
		move.l	#Map_CluesTestingCursor,mappings(a0)
		bset	#5,render_flags(a0)				; set static mappings flag
		move.l	#SegaParticles_Main,address(a0)
		moveq	#1<<2,d0
		jsr	(Set_IndexedVelocity).w

SegaParticles_Main:
		jsr	(MoveSprite).w
		bsr.s	SegaParticles_CheckDelete
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

SegaParticles_CheckDelete:
		cmpi.w	#256,(vSega_Deform).w
		beq.s	SegaParticles_CheckDelete_Remove
		cmpi.w	#$160,y_pos(a0)
		blo.s		SegaParticles_Delete_Return

SegaParticles_CheckDelete_Remove:
		move.l	#Delete_Current_Sprite,address(a0)
		addq.w	#4,sp

SegaParticles_Delete_Return:
		rts
; ---------------------------------------------------------------------------

Map_CluesTestingCursor:
		dc.b $F8			; Ypos
		dc.b 0			; Tile size(0=8x8)
		dc.w 0			; VRAM
		dc.w 0			; Xpos
PLC_Sega:
		dc.w ((PLC_Sega_End-PLC_Sega)/6)-1
		plreq 0, DEZ_8x8_KosM
		plreq $1F0, ArtKosM_Sega
		plreq $229, ArtKosM_HardLine
PLC_Sega_End