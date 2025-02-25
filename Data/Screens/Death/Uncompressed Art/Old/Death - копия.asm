; ---------------------------------------------------------------------------
; Ending Screen
; ---------------------------------------------------------------------------

vDeath_Buffer:			= $FFFF2000		; $800 bytes
vDeath_FactorBuffer:		= $FFFF2800			; $800 bytes

vDeath_Timer:			= Object_load_addr_front		; word
vDeath_TextFactor:		= Object_load_addr_front+2	; byte
vDeath_End:				= Object_load_addr_front+3	; byte
vDeath_Wait:			= Object_load_addr_front+4	; byte

; =============== S U B R O U T I N E =======================================

Death_Screen:
		sfx	bgm_Stop,0,1,1
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Clear_Nem_Queue).w
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
		lea	PLC_InsertCoin(pc),a6
		jsr	(LoadPLC_Raw_KosM).w


		jsr	(LoadLevelLoadBlock2).w





		lea	(DEZ2_Layout_FloorExplosion).l,a0
		jsr	(Load_Level2).w


		moveq	#palid_Sonic,d0
		move.w	d0,d1
		jsr	(LoadPalette).w								; load Sonic's palette
		move.w	d1,d0
		jsr	(LoadPalette_Immediate).w
		moveq	#palid_DEZ,d0
		jsr	(LoadPalette).w


;		lea	(Pal_Options).l,a1
;		lea	(Target_palette_line_1).w,a2
;		moveq	#(64/2)-1,d0
;		jsr	(PalLoad_Line.loop).w

		music	bgm_GameOver,0,0,0


		move.w	#$920,(Camera_X_pos).w
		move.w	#$7A0,(Camera_Y_pos).w



		jsr	(LevelSetup).l


;		lea	Ending_MainText(pc),a1
;		locVRAM	$C202,d1
;		move.w	#$2FF,d3
;		jsr	(Load_PlaneText).w


		move.l	#Obj_SonicSurfboarding_DeathScreen,(Object_RAM).w


		move.b	#$14,(vDeath_TextFactor).w
		move.w	#3,(Demo_timer).w
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		jsr	(ScreenEvents).l
		jsr	(Process_Sprites).w
		jsr	(Process_Nem_Queue_Init).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

-		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		jsr	(ScreenEvents).l
		jsr	(Process_Sprites).w
		bsr.w	DeathScreen_Process
		jsr	(Process_Nem_Queue_Init).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
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






		offsetTableEntry.w DeathScreen_Process_Wait_Return
; ---------------------------------------------------------------------------

DeathScreen_Process_Wait:
		tst.w	(Demo_timer).w
		bne.s	DeathScreen_Process_Wait_Return
		addq.b	#2,(Object_load_routine).w

DeathScreen_Process_Wait_Return:
		rts
; ---------------------------------------------------------------------------








; ---------------------------------------------------------------------------
; �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SonicSurfboarding_DeathScreen:
		move.l	#Map_SurfboardIntro,mappings(a0)
		move.w	#make_art_tile(ArtTile_Sonic,0,0),art_tile(a0)
		move.w	#$100,priority(a0)
		move.b	#4,render_flags(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$60,d0
		move.w	d0,y_pos(a0)
;		addq.b	#2,mapping_frame(a0)
		move.b	#64/2,width_pixels(a0)
		move.b	#48/2,height_pixels(a0)
		move.l	#SonicSurfboarding_DeathScreen_Draw,address(a0)

SonicSurfboarding_DeathScreen_Draw:
		bsr.s	SonicSurfboarding_DeathScreen_PLC
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

SurfboardIntro_Move:
		move.w	#2,d1
		move.w	(Player_1+x_pos).w,d0
		cmp.w	x_pos(a0),d0
		bcc.s	+
		neg.w	d1
+
		add.w	d1,x_vel(a0)


		moveq	#0,d2
		lea	SurfboardIntro_DownFrames(pc),a1
		move.w	#3,d1
		move.w	(Player_1+y_pos).w,d0
		cmp.w	y_pos(a0),d0
		bcc.s	loc_20D76
		moveq	#1,d2
		lea	SurfboardIntro_UpFrames(pc),a1
		move.w	#4,d1
		neg.w	d1

loc_20D76:
		add.w	d1,y_vel(a0)
		jsr	(MoveSprite2).w
		move.w	y_vel(a0),d0
		tst.w	d2
		bne.s	loc_20D8A
		neg.w	d0

loc_20D8A:
		addi.w	#$80,d0
		cmpi.w	#$100,d0
		bcs.s	loc_20D98
		move.w	#$100,d0

loc_20D98:
		lsr.w	#5,d0
		move.b	(a1,d0.w),d0
		addq.b	#1,d0
		move.b	d0,mapping_frame(a0)

; =============== S U B R O U T I N E =======================================

SonicSurfboarding_DeathScreen_PLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		cmp.b	(v_SonFrameNum).w,d0
		beq.s	+
		move.b	d0,(v_SonFrameNum).w
		lea	(PLC_SonicSurfboarding).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	+
		move.w	#$D000,d4
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

		include "Data/Screens/Death/Object Data/DPLC - Sonic Surfboarding.asm"
		include "Data/Screens/Death/Object Data/Map - Sonic Surfboarding.asm"