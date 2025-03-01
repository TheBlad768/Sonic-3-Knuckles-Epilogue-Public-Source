; ===========================================================================
; Levels Data
; ===========================================================================

		;		1st 8x8 data		1st 16x16 data		1st 128x128 data	palette
LevelLoadBlock:
		levartptrs DEZ_8x8_KosM, DEZ_16x16_Unc, DEZ_128x128_Kos, palid_DEZ		; DEZ1
		levartptrs DEZ_8x8_KosM, DEZ_16x16_Unc, DEZ_128x128_Kos, palid_DEZ2		; DEZ2
		levartptrs DEZ_8x8_KosM, DEZ_16x16_Unc, DEZ_128x128_Kos, palid_DEZ2		; DEZ3
		levartptrs DEZ_8x8_KosM, DEZ_16x16_Unc, DEZ_128x128_Kos, palid_DEZ2		; DEZ4

		zonewarning LevelLoadBlock,(12*4)

; ===========================================================================
; Levels Pointer Data
; ===========================================================================

LevelLoadPointer:

; DEZ1
		dc.l AnPal_DEZ, DEZ1_Resize, No_WaterResize, AfterBoss_Null
		dc.l DEZ1_ScreenInit, DEZ1_BackgroundInit, DEZ1_ScreenEvent, DEZ1_BackgroundEvent
		dc.l AnimateTiles_DEZ1, AniPLC_DEZ

; DEZ2
		dc.l AnPal_DEZ, DEZ2_Resize, No_WaterResize, AfterBoss_Null
		dc.l DEZ1_ScreenInit, DEZ1_BackgroundInit, DEZ1_ScreenEvent, DEZ1_BackgroundEvent
		dc.l AnimateTiles_DoAniPLC, AniPLC_DEZ

; DEZ3
		dc.l AnPal_DEZ, DEZ3_Resize, No_WaterResize, AfterBoss_Null
		dc.l DEZ1_ScreenInit, DEZ1_BackgroundInit, DEZ1_ScreenEvent, DEZ3_BackgroundEvent
		dc.l AnimateTiles_DoAniPLC, AniPLC_DEZ

; DEZ4
		dc.l AnPal_DEZ, DEZ4_Resize, No_WaterResize, AfterBoss_Null
		dc.l DEZ1_ScreenInit, DEZ1_BackgroundInit, DEZ1_ScreenEvent, DEZ3_BackgroundEvent
		dc.l AnimateTiles_DoAniPLC, AniPLC_DEZ

		zonewarning LevelLoadPointer,(40*4)

; ===========================================================================
; Collision index pointers
; ===========================================================================

SolidIndexes:
		dc.l DEZ1_Solid		; DEZ1
		dc.l DEZ1_Solid		; DEZ2
		dc.l DEZ1_Solid		; DEZ3
		dc.l DEZ1_Solid		; DEZ4

		zonewarning SolidIndexes,(4*4)

; ===========================================================================
; Level layout index
; ===========================================================================

LevelPtrs:
		dc.l DEZ1_Layout		; DEZ1
		dc.l DEZ2_Layout		; DEZ2
		dc.l DEZ3_Layout		; DEZ3
		dc.l DEZ3_Layout		; DEZ4

		zonewarning LevelPtrs,(4*4)

; ===========================================================================
; Sprite locations index
; ===========================================================================

SpriteLocPtrs:
		dc.l DEZ1_Sprites		; DEZ1
		dc.l DEZ1_Sprites		; DEZ2
		dc.l DEZ1_Sprites		; DEZ3
		dc.l DEZ1_Sprites		; DEZ4

		zonewarning SpriteLocPtrs,(4*4)

; ===========================================================================
; Ring locations index
; ===========================================================================

RingLocPtrs:
		dc.l DEZ1_Rings		; DEZ1
		dc.l DEZ1_Rings		; DEZ2
		dc.l DEZ1_Rings		; DEZ3
		dc.l DEZ1_Rings		; DEZ4

		zonewarning RingLocPtrs,(4*4)

; ===========================================================================
; Compressed level graphics - tile, primary patterns and block mappings
; ===========================================================================

DEZ_8x8_KosM:		binclude "Levels/DEZ/Tiles/Primary.bin"
	even
DEZ_16x16_Unc:		binclude	"Levels/DEZ/Blocks/Primary.bin"
	even
DEZ_128x128_Kos:	binclude	"Levels/DEZ/Chunks/Primary.bin"
	even

; ===========================================================================
; Collision data
; ===========================================================================

AngleArray:			binclude	"Misc Data/Angle Map.bin"
	even
HeightMaps:			binclude	"Misc Data/Height Maps.bin"
	even
HeightMapsRot:		binclude	"Misc Data/Height Maps Rotated.bin"
	even

; ===========================================================================
; Level collision data
; ===========================================================================

DEZ1_Solid:			binclude	"Levels/DEZ/Collision/1.bin"
	even

; ===========================================================================
; Level layout data
; ===========================================================================

		align $8000

DEZ1_Layout:				binclude	"Levels/DEZ/Layout/1.1.bin"
	even
DEZ1_Layout_WallExplosion:	binclude	"Levels/DEZ/Layout/1.2.bin"
	even
DEZ1_Layout_FloorExplosion:	binclude	"Levels/DEZ/Layout/1.3.bin"
	even
DEZ2_Layout:				binclude	"Levels/DEZ/Layout/2.1.bin"
	even
DEZ2_Layout_FloorExplosion:	binclude	"Levels/DEZ/Layout/2.2.bin"
	even
DEZ3_Layout:				binclude	"Levels/DEZ/Layout/3.1.bin"
	even
Title_Layout:					binclude	"Levels/Title/Layout/1.bin"
	even

; ===========================================================================
; Level sprite data
; ===========================================================================

		dc.w -1, 0, 0
DEZ1_Sprites:		binclude	"Levels/DEZ/Object Pos/1.bin"
		dc.w -1, 0, 0
	even

; ===========================================================================
; Level ring data
; ===========================================================================

		dc.w -1, 0, 0
DEZ1_Rings:			binclude	"Levels/DEZ/Ring Pos/1.bin"
		dc.w -1, 0, 0
	even