Sound_DeathSMS_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_DeathSMS_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_DeathSMS_FM5,	$00, $00

; FM5 Data
Sound_DeathSMS_FM5:
	dc.b	nCs0, $07, smpsNoAttack, $17
	smpsStop

Sound_DeathSMS_Voices: