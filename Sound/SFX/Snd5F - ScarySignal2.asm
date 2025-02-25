Sound_E4_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_E4_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_E4_FM5,	$00, $00

; FM5 Data
Sound_E4_FM5:
	dc.b	nRst, $01
	smpsSetvoice        $00
	dc.b	nF3, $1E
	smpsAlterVol        $1B
	dc.b	$15, nRst, $01
	smpsStop

Sound_E4_Voices:
;	Voice $00
;	$3A
;	$71, $10, $41, $07, 	$1D, $14, $0D, $0C, 	$1F, $1C, $19, $0D
;	$1F, $10, $11, $00, 	$1F, $1F, $1F, $0F, 	$1B, $00, $16, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $04, $01, $07
	smpsVcCoarseFreq    $07, $01, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0C, $0D, $14, $1D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $19, $1C, $1F
	smpsVcDecayRate2    $00, $11, $10, $1F
	smpsVcDecayLevel    $00, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $16, $00, $1B

