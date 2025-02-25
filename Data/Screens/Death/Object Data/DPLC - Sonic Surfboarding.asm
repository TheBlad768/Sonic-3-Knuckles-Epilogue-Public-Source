PLC_SonicSurfboarding:
DPLC_SurfboardIntro:
		dc.w 0
		dc.w SME_XFWHD_10-DPLC_SurfboardIntro
		dc.w SME_XFWHD_18-DPLC_SurfboardIntro
		dc.w SME_XFWHD_20-DPLC_SurfboardIntro
		dc.w SME_XFWHD_2A-DPLC_SurfboardIntro
		dc.w SME_XFWHD_32-DPLC_SurfboardIntro
		dc.w SME_XFWHD_3A-DPLC_SurfboardIntro
SME_XFWHD_10:	dc.b 0, 3, $F0, 0, $70, $10, $70, $18
SME_XFWHD_18:	dc.b 0, 3, $F0, $20, $70, $30, $70, $38
SME_XFWHD_20:	dc.b 0, 4, $F0, $40, $50, $50, $70, $56, $70, $5E
SME_XFWHD_2A:	dc.b 0, 3, $B0, $66, $B0, $72, $B0, $7E
SME_XFWHD_32:	dc.b 0, 3, $B0, $8A, $B0, $96, $B0, $A2
SME_XFWHD_3A:	dc.b 0, 4, $F0, $AE, $50, $BE, $70, $C4, $70, $CC
		even