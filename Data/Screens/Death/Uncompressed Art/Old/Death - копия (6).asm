; ---------------------------------------------------------------------------
; Death Screen
; ---------------------------------------------------------------------------

vDeath_Buffer:			= $FFFF2000		; $800 bytes
vDeath_FactorBuffer:		= $FFFF2800			; $800 bytes

vDeath_Timer:			= Object_load_addr_front		; word
vDeath_TextFactor:		= Object_load_addr_front+2	; byte
vDeath_End:				= Object_load_addr_front+3	; byte
vDeath_Wait:			= Object_load_addr_front+4	; byte
vDeath_TextIndex:		= Object_load_addr_front+5	; byte

; BG
long_464A:				= PalRotation_buffer		; long
long_464E:				= PalRotation_buffer+4	; long
word_4652:				= PalRotation_buffer+8	; word
word_4654:				= PalRotation_buffer+$A	; word
word_4656:				= PalRotation_buffer+$C	; word
word_4658:				= PalRotation_buffer+$E	; word

; =============== S U B R O U T I N E =======================================

Death_Screen:

	if GameDebug=0
		tst.b	(QuickStart_mode).w
		beq.s	*
	endif

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
		move.w	#$8B03,(a6)					; Command $8B00 - Vscroll full, HScroll full
		move.w	#$8C81,(a6)					; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM Oscillating_variables, Oscillating_variables_End
		ResetDMAQueue
		lea	PLC_Sega(pc),a6
		jsr	(LoadPLC_Raw_KosM).w
		jsr	(LoadLevelLoadBlock2).w
		lea	(DEZ2_Layout_FloorExplosion).l,a0
		jsr	(Load_Level2).w
		jsr	(OscillateNumInit).w
		moveq	#palid_Sonic,d0
		move.w	d0,d1
		jsr	(LoadPalette).w								; load Sonic's palette
		move.w	d1,d0
		jsr	(LoadPalette_Immediate).w
		moveq	#palid_DEZ,d0
		jsr	(LoadPalette).w
		lea	(Pal_Options).l,a1
		jsr	(PalTLoad_Line1).w
		music	bgm_GameOver,0,0,0
		addq.w	#1,(word_4656).w
		addq.w	#1,(word_4658).w
		bsr.w	DeathScreen_ScrollingBG
		jsr	(LevelSetup).l


		move.l	#Obj_SonicSurfboarding_DeathScreen,(Object_RAM).w






		move.b	#$14,(vDeath_TextFactor).w
		move.w	#$4F,(Demo_timer).w

-		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.l (Kos_module_queue).w
		bne.s	-
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		jsr	(Animate_Palette).l
		jsr	(ScreenEvents).l
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(OscillateNumDo).w
		jsr	(Render_Sprites).w
		bsr.w	DeathScreen_ScrollingBG
		enableScreen
		jsr	(Pal_FadeFromBlack).w

-		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		jsr	(Animate_Palette).l
		jsr	(ScreenEvents).l
		jsr	(Process_Sprites).w
		bsr.w	DeathScreen_Process
		jsr	(Process_Kos_Module_Queue).w
		jsr	(OscillateNumDo).w





		jsr	(Render_Sprites).w




		bsr.w	DeathScreen_LoadSpriteText





		bsr.w	DeathScreen_ScrollingBG
		tst.b	(vDeath_End).w
		beq.s	-

Death_PressStart:
		illegal

; =============== S U B R O U T I N E =======================================

DeathScreen_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	DeathScreen_Process_Index(pc,d0.w),d0
		jmp	DeathScreen_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

DeathScreen_Process_Index: offsetTable
		offsetTableEntry.w DeathScreen_Process_Wait			; 0
		offsetTableEntry.w DeathScreen_Process_NextText			; 2
		offsetTableEntry.w DeathScreen_Process_DrawText		; 4
		offsetTableEntry.w DeathScreen_Process_HideText			; 6
		offsetTableEntry.w DeathScreen_Process_End				; 8

		offsetTableEntry.w DeathScreen_Process_Wait_Return
; ---------------------------------------------------------------------------

DeathScreen_Process_Wait:
		tst.w	(Demo_timer).w
		bne.s	DeathScreen_Process_Wait_Return
		addq.b	#2,(Object_load_routine).w

DeathScreen_Process_Wait_Return:
		rts
; ---------------------------------------------------------------------------

DeathScreen_Process_NextText:
		addq.b	#2,(vDeath_TextIndex).w
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vDeath_TextFactor).w
		move.w	#$5F,(vDeath_Timer).w
		rts
; ---------------------------------------------------------------------------

DeathScreen_Process_DrawText:
		tst.b	(vDeath_TextFactor).w
		beq.s	DeathScreen_Process_DrawText_Skip
		subq.w	#1,(vDeath_Timer).w
		bpl.s	DeathScreen_Process_DrawText_Skip_Return
		move.w	#1,(vDeath_Timer).w
		lea	(vDeath_Buffer).l,a1			; Mod Art
		lea	(vDeath_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothDrawArtText
		move.l	#vDeath_Buffer,d1
		move.w	#tiles_to_bytes($340),d2	; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

DeathScreen_Process_DrawText_Skip:
		addq.b	#2,(Object_load_routine).w
		move.b	#$14,(vDeath_TextFactor).w
		move.w	#$9F,(vDeath_Timer).w

DeathScreen_Process_DrawText_Skip_Return:
		rts
; ---------------------------------------------------------------------------

DeathScreen_Process_HideText:
		tst.b	(vDeath_TextFactor).w
		beq.s	DeathScreen_Process_HideText_Skip
		subq.w	#1,(vDeath_Timer).w
		bpl.s	DeathScreen_Process_DrawText_Skip_Return
		move.w	#1,(vDeath_Timer).w
		lea	(vDeath_Buffer).l,a1			; Mod Art
		lea	(vDeath_FactorBuffer).l,a2		; Tile factor
		bsr.w	SmoothHideArtText
		move.l	#vDeath_Buffer,d1
		move.w	#tiles_to_bytes($340),d2	; VRAM
		bra.w	SmoothLoadArtText
; ---------------------------------------------------------------------------

DeathScreen_Process_HideText_Skip:
		move.b	#2,(Object_load_routine).w
		cmpi.b	#(Death_TextIndex_Cheat-Death_TextIndex),(vDeath_TextIndex).w
		bne.s	DeathScreen_Process_HideText_Return
		move.b	#8,(Object_load_routine).w
		clr.b	(vDeath_TextIndex).w

DeathScreen_Process_HideText_Return:
		rts
; ---------------------------------------------------------------------------

DeathScreen_Process_End:
		rts


		illegal


















; ---------------------------------------------------------------------------
; Соник
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SonicSurfboarding_DeathScreen:
		move.l	#Map_SurfboardIntro,mappings(a0)
		move.w	#$8400,art_tile(a0)
		move.w	#$100,priority(a0)
		move.b	#4,render_flags(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$60,d0
		move.w	d0,y_pos(a0)
		move.b	#64/2,width_pixels(a0)
		move.b	#48/2,height_pixels(a0)
		move.l	#SonicSurfboarding_DeathScreen_Create,address(a0)

SonicSurfboarding_DeathScreen_Create:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	SonicSurfboarding_DeathScreen_Draw
		moveq	#2-1,d6

-		jsr	(Create_New_Sprite).w
		bne.s	SonicSurfboarding_DeathScreen_Draw
		move.l	#Obj_SonicSurfboarding_Spark_DeathScreen,address(a1)
		move.w	x_pos(a0),d0
		subi.w	#28,d0
		move.w	d0,x_pos(a1)
		move.w	y_pos(a0),d0
		addi.w	#24,d0
		move.w	d0,y_pos(a1)
		move.w	a0,parent3(a1)
		dbf	d6,-

SonicSurfboarding_DeathScreen_Draw:
		pea	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

SonicSurfboarding_DeathScreen_Move:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		moveq	#0,d3
		move.b	(Oscillating_Data+4).w,d3
		lsr.w	d3
		add.w	d3,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$60,d0
		moveq	#0,d3
		move.b	(Oscillating_Data+4).w,d3
		add.w	d3,d0
		move.w	d0,y_pos(a0)
		moveq	#0,d0
		move.b	(Oscillating_Data+4).w,d0
		lsr.b	#2,d0
		move.b	SurfboardIntro_DownFrames(pc,d0.w),d0
		addq.b	#1,d0
		move.b	d0,mapping_frame(a0)

; =============== S U B R O U T I N E =======================================

SonicSurfboarding_DeathScreen_PLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		cmp.b	(Player_prev_frame).w,d0
		beq.s	+
		move.b	d0,(Player_prev_frame).w
		lea	(PLC_SonicSurfboarding).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	+
		move.w	#$8000,d4
		move.l	#ArtUnc_SonicSurfboarding,d6

-		moveq	#0,d1
		move.w	(a2)+,d1
		move.w	d1,d3
		lsr.w	#8,d3
		andi.w	#$F0,d3
		addi.w	#$10,d3
		andi.w	#$FFF,d1
		lsl.l	#5,d1
		add.l	d6,d1
		move.w	d4,d2
		add.w	d3,d4
		add.w	d3,d4
		jsr	(Add_To_DMA_Queue).w
		dbf	d5,-
+		rts
; End of function SonicSurfboarding_DeathScreen_PLC
; ---------------------------------------------------------------------------

SurfboardIntro_DownFrames:	dc.b 2, 1, 1, 0, 0, 0, 0, 1, 2, 2
SurfboardIntro_UpFrames:		dc.b 3, 4, 4, 4, 5, 5, 5, 4, 3, 3
; ---------------------------------------------------------------------------
; Искры
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SonicSurfboarding_Spark_DeathScreen:
		move.l	#Map_CluesTestingCursor,mappings(a0)
		move.w	#$8170,art_tile(a0)
		move.w	#$80,priority(a0)
		move.b	#4,render_flags(a0)
		bset	#5,render_flags(a0)				; set static mappings flag
		move.b	#$A,mapping_frame(a0)
		move.b	#16/2,width_pixels(a0)
		move.b	#16/2,height_pixels(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	d0,d1
		addq.w	#7,d0
		move.w	d0,$2E(a0)
		movea.w	parent3(a0),a1
		move.w	x_vel(a1),d0
		asl.w	#2,d0
		asl.w	#6,d1
		add.w	d1,d0
		neg.w	d0
		move.w	d0,x_vel(a0)
		jsr	(Random_Number).w
		andi.w	#$3FF,d0
		addi.w	#$100,d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		jsr	(Random_Number).w
		andi.w	#4-1,d0
		move.w	#$8171,d1
		add.w	d0,d1
		move.w	d1,art_tile(a0)
		move.l	#Go_Delete_Sprite,$34(a0)
		move.l	#SonicSurfboarding_Spark_DeathScreen_Draw,address(a0)

SonicSurfboarding_Spark_DeathScreen_Draw:
		jsr	(MoveSprite2).w
		jsr	(Obj_Wait).w
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

DeathScreen_ScrollingBG:
		tst.w	(word_4652).w
		bmi.s	.loc_2FD6
		cmpi.w	#512,(word_4652).w
		bhi.s	.loc_2FE6
		bra.s	.loc_3014
; ---------------------------------------------------------------------------

.loc_2FD6:
		cmpi.w	#-512,(word_4652).w
		blt.s		.loc_2FE6
		bra.s	.loc_3014
; ---------------------------------------------------------------------------

.loc_2FE6:
		neg.w	(word_4656).w
		move.w	(word_4656).w,d0
		add.w	d0,(word_4652).w
		jsr	(Random_Number).w
		andi.w	#7,d0
		addq.w	#1,d0
		tst.w (word_4656).w
		bpl.s	.skip
		neg.w	d0

.skip:
		move.w	d0,(word_4656).w

.loc_3014:
		move.w	(word_4656).w,d0
		add.w	d0,(word_4652).w
		move.w	(word_4652).w,d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,(long_464A).w
		tst.w	(word_4654).w
		bmi.s	.loc_304A
		cmpi.w	#512,(word_4654).w
		bhi.s	.loc_305A
		bra.s	.loc_3088
; ---------------------------------------------------------------------------

.loc_304A:
		cmpi.w	#-512,(word_4654).w
		blt.s		.loc_305A
		bra.s	.loc_3088
; ---------------------------------------------------------------------------

.loc_305A:
		neg.w	(word_4658).w
		move.w	(word_4658).w,d0
		add.w	d0,(word_4654).w
		jsr	(Random_Number).w
		andi.w	#7,d0
		addq.w	#1,d0
		tst.w	(word_4658).w
		bpl.s	.skip2
		neg.w	d0

.skip2:
		move.w	d0,(word_4658).w

.loc_3088:
		move.w	(word_4658).w,d0
		add.w	d0,(word_4654).w
		move.w	(word_4654).w,d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,(long_464E).w
		move.w	(long_464A).w,d0
		addi.w	#$620,d0
		move.w	d0,(Camera_X_pos).w
		move.w	(long_464E).w,d0
		addi.w	#$5A0,d0
		move.w	d0,(Camera_Y_pos).w

Select_ScrollingBG_Return:
		rts

; =============== S U B R O U T I N E =======================================

DeathScreen_LoadSpriteText:
		moveq	#0,d0
		lea	(Sprite_table_buffer+(8*6)).w,a6
		lea	Death_TextIndex(pc),a1
		move.b	(vDeath_TextIndex).w,d0
		adda.w	(a1,d0.w),a1
		moveq	#0,d6
		moveq	#320/8-1,d1				; Max 20 characters
		move.b	(a1)+,d6
		bmi.s	DeathScreen_LoadSpriteText_End
		move.w	d6,d0
		moveq	#1,d4
		add.w	d4,d0
		sub.w	d0,d1
		move.w	d1,d2
		and.w	d4,d2
		lsr.w	d1
		add.w	d2,d1
		add.w	d1,d1
		add.w	d1,d1
		add.w	d1,d1
		addi.w	#$80,d1					; Main Xpos

DeathScreen_LoadSpriteText_Loop:
		cmpi.b	#$37,(a1)				; Space
		beq.s	DeathScreen_LoadSpriteText_Skip

; Set Ypos
		move.w	#$98,(a6)+				; Ypos

; Set Misc
		clr.b	(a6)							; load the size of the sprite
		addq.w	#2,a6					; skip link parameter

; VRAM
		move.w	#$A33F,d2				; VRAM
		add.b	(a1),d2
		move.w	d2,(a6)+					; load art address

; Set Xpos
		move.w	d1,(a6)+					; Xpos

DeathScreen_LoadSpriteText_Skip:
		addq.w	#1,a1
		addq.w	#8,d1
		dbf	d6,DeathScreen_LoadSpriteText_Loop

DeathScreen_LoadSpriteText_End:
		rts
; ---------------------------------------------------------------------------

Death_TextIndex: offsetTable
		offsetTableEntry.w Death_TextNull	; 0
		offsetTableEntry.w Death_Text1		; 2
		offsetTableEntry.w Death_Text2		; 4
		offsetTableEntry.w Death_Text3		; 6
		offsetTableEntry.w Death_Text2		; 8
		offsetTableEntry.w Death_Text4		; A
		offsetTableEntry.w Death_Text5		; C
		offsetTableEntry.w Death_Text6		; E
		offsetTableEntry.w Death_Text7		; 10
		offsetTableEntry.w Death_Text8		; 12

Death_TextIndex_Cheat

		offsetTableEntry.w Death_Text9		; 14
		offsetTableEntry.w Death_Text10	; 16
		offsetTableEntry.w Death_Text11	; 18

Death_TextIndex_End

Death_Text1:		optionstr "Did you lose? Again?"
Death_Text2:		optionstr "Why?"
Death_Text3:		optionstr "Is this game too hard?"
Death_Text4:		optionstr "I was sure you*d win!"
Death_Text5:		optionstr "Okay..."
Death_Text6:		optionstr "Don*t be sad!"
Death_Text7:		optionstr "I*ll help you!"
Death_Text8:		optionstr "Title Screen Code:"
Death_Text9:		optionstr "U, C, D, B, L, A, R, B, A, C"
Death_Text10:	optionstr "Use it!"
Death_Text11:	optionstr "Good luck!"

Death_TextNull: dc.b -1
	even
; ---------------------------------------------------------------------------

		include "Data/Screens/Death/Object Data/DPLC - Sonic Surfboarding.asm"
		include "Data/Screens/Death/Object Data/Map - Sonic Surfboarding.asm"