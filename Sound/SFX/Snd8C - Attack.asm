Sound_AttackSMS_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_AttackSMS_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_AttackSMS_PSG3,	$00, $00

; FM5 Data
Sound_AttackSMS_PSG3:
	dc.b	nC0, $07, smpsNoAttack, nA1
	smpsStop

Sound_AttackSMS_Voices: