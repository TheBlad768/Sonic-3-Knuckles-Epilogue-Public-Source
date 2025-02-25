; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

Map_MiniSonic:
		dc.w SME_LT3zs_E-Map_MiniSonic, SME_LT3zs_16-Map_MiniSonic
		dc.w SME_LT3zs_1E-Map_MiniSonic, SME_LT3zs_26-Map_MiniSonic
		dc.w SME_LT3zs_2E-Map_MiniSonic, SME_LT3zs_36-Map_MiniSonic
		dc.w SME_LT3zs_3E-Map_MiniSonic
SME_LT3zs_E:	dc.b 0, 1
		dc.b $F0, 6, 0, 0, $FF, $F8
SME_LT3zs_16:	dc.b 0, 1
		dc.b $F0, 6, 0, 6, $FF, $F8
SME_LT3zs_1E:	dc.b 0, 1
		dc.b $F0, 6, 0, $C, $FF, $F8
SME_LT3zs_26:	dc.b 0, 1
		dc.b $F0, $A, 0, $12, $FF, $F8
SME_LT3zs_2E:	dc.b 0, 1
		dc.b $F0, $A, 0, $1B, $FF, $F8
SME_LT3zs_36:	dc.b 0, 1
		dc.b $E8, 7, 0, $24, $FF, $F8
SME_LT3zs_3E:	dc.b 0, 1
		dc.b $F0, $E, 0, $2C, $FF, $F0
		even