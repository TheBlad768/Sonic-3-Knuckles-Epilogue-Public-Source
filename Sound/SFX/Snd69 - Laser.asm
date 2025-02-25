Sound_2C_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_2C_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_2C_FM5,	$00, $00

; FM5 Data
Sound_2C_FM5:
	dc.b	nRst, $01
	smpsSetvoice        $00
	smpsModSet          $00, $01, $8C, $06
	dc.b	nAb0, $20
	smpsStop

Sound_2C_Voices:
;	Voice $00
;	$3A
;	$0B, $12, $00, $2F, 	$11, $15, $1C, $1F, 	$1F, $1F, $0E, $07
;	$0B, $08, $00, $0C, 	$0F, $0F, $02, $1F, 	$16, $1D, $10, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $02, $00, $01, $00
	smpsVcCoarseFreq    $0F, $00, $02, $0B
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1C, $15, $11
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $0E, $1F, $1F
	smpsVcDecayRate2    $0C, $00, $08, $0B
	smpsVcDecayLevel    $01, $00, $00, $00
	smpsVcReleaseRate   $0F, $02, $0F, $0F
	smpsVcTotalLevel    $00, $10, $1D, $16

