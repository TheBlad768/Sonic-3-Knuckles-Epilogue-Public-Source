; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

Map_MiniRing:
		dc.w 0
		dc.w Map_MiniRing_C-Map_MiniRing
		dc.w Map_MiniRing_10-Map_MiniRing
		dc.w Map_MiniRing_14-Map_MiniRing
Map_MiniRing_C:
		dc.w 1
		dc.b $F0, 5, 0, 0, $FF, $F8
Map_MiniRing_10:
		dc.w 2
		dc.b $F0, 5, 0, 0, $FF, $F8
		dc.b $F0, 5, 0, 0, $0, 8
Map_MiniRing_14:
		dc.w 3
		dc.b $F0, 5, 0, 0, $FF, $F8
		dc.b $F0, 5, 0, 0, $0, 8
		dc.b $F0, 5, 0, 0, $0, $18
	even