Sound_JumpSMS_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_JumpSMS_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_JumpSMS_PSG3,	$00, $02

; PSG1 Data
Sound_JumpSMS_PSG3:
	smpsPSGvoice        sTone_05
	smpsModSet          $02, $01, $F8, $65
	dc.b	nAb1, $08
	smpsStop

; Song seems to not use any FM voices
Sound_JumpSMS_Voices:
