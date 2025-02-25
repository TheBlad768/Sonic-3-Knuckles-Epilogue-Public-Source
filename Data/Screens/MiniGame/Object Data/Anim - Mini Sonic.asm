Ani_MiniSonic:
		dc.w Ani_MiniSonic_Wait-Ani_MiniSonic
		dc.w Ani_MiniSonic_Run-Ani_MiniSonic
		dc.w Ani_MiniSonic_Attack-Ani_MiniSonic
		dc.w Ani_MiniSonic_Jump-Ani_MiniSonic
		dc.w Ani_MiniSonic_Hurt-Ani_MiniSonic
Ani_MiniSonic_Wait:		dc.b 5, 0, $FF
Ani_MiniSonic_Run:		dc.b 5, 1, 2, $FF
Ani_MiniSonic_Attack:	dc.b 5, 3, 4, $FE, 1
Ani_MiniSonic_Jump:		dc.b 5, 5, $FF
Ani_MiniSonic_Hurt:		dc.b 5, 6, $FF
	even