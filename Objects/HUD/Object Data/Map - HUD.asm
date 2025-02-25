Map_HUD:
		dc.w word_DBC2-Map_HUD	; 0 ; Normal
		dc.w word_DC00-Map_HUD	; 1 ; Hide Rings
		dc.w word_DC32-Map_HUD	; 2 ; Hide Time
		dc.w word_DC6A-Map_HUD	; 3 ; Hide Rings and Time
		dc.w word_DC96-Map_HUD	; 4 ; Draw Rings only(Bonus Stage)
		dc.w word_DCB6-Map_HUD	; 5 ; Hide Rings(Bonus Stage)
word_DBC2:
		dc.w 2
		dc.b $80, 5, $67, $F8,  0,  0
		dc.b $80,  9, 0,$38,  0,$18
word_DC00:
		dc.w 2
		dc.b $80, 5, 7, $F8,  0,  0
		dc.b $80,  9, 0,$38,  0,$18
word_DC32:
		dc.w 2
		dc.b $80, 5, $67, $F8,  0,  0
		dc.b $80,  9, 0,$38,  0,$18
word_DC6A:
		dc.w 2
		dc.b $80, 5, 7, $F8,  0,  0
		dc.b $80,  9, 0,$38,  0,$18
word_DC96:
		dc.w 2
		dc.b $80, 5, $67, $F8,  0,  0
		dc.b $80,  9, 0,$38,  0,$18
word_DCB6:
		dc.w 2
		dc.b $80, 5, 7, $F8,  0,  0
		dc.b $80,  9, 0,$38,  0,$18