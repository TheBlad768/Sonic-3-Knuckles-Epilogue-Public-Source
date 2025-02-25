; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

Map_MiniEnemy:
		dc.w Map_MiniEnemy_E-Map_MiniEnemy, Map_MiniEnemy_16-Map_MiniEnemy
		dc.w Map_MiniEnemy_24-Map_MiniEnemy, Map_MiniEnemy_2C-Map_MiniEnemy
		dc.w Map_MiniEnemy_34-Map_MiniEnemy, Map_MiniEnemy_3C-Map_MiniEnemy
		dc.w Map_MiniEnemy_4A-Map_MiniEnemy, Map_MiniEnemy_5C-Map_MiniEnemy
		dc.w Map_MiniEnemy_64-Map_MiniEnemy
Map_MiniEnemy_E:	dc.b 0, 1
		dc.b $F0, $A, 0, 0, $FF, $F4
Map_MiniEnemy_16:	dc.b 0, 2
		dc.b $F0, 6, 0, 9, $FF, $F0
		dc.b $F0, 6, 8, 9, 0, 0
Map_MiniEnemy_24:	dc.b 0, 1
		dc.b $F0, $A, 8, 0, $FF, $F4
Map_MiniEnemy_2C:	dc.b 0, 1
		dc.b $F8, 5, 0, $F, $FF, $F4
Map_MiniEnemy_34:	dc.b 0, 1
		dc.b $F8, 5, 0, $13, $FF, $F4
Map_MiniEnemy_3C:	dc.b 0, 2
		dc.b $E8, 7, 0, $17, $FF, $F4
		dc.b $F8, 1, 0, $1F, 0, 4
Map_MiniEnemy_4A:	dc.b 0, 2
		dc.b $E8, 7, 0, $21, $FF, $F4
		dc.b $F8, 1, 0, $29, 0, 4
Map_MiniEnemy_5C:	dc.b 0, 1
		dc.b $F8, 5, 0, $2B, $FF, $F8
Map_MiniEnemy_64:	dc.b 0, 1
		dc.b $F8, 5, 0, $2F, $FF, $F8
		even