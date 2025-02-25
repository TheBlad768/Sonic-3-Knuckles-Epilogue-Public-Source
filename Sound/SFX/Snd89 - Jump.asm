Sound_3DAS_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_3DAS_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_3DAS_FM5,	$00, $03

; FM5 Data
Sound_3DAS_FM5:
	smpsSetvoice        $00
	smpsModSet          $00, $01, $33, $FF
	dc.b	nBb4, $01, nRst, $01
	smpsSetvoice        $01
	dc.b	nEb5, $05
	smpsStop

Sound_3DAS_Voices:
;	Voice $00
;	$34
;	$70, $24, $60, $77, 	$1F, $1F, $1F, $1F, 	$1F, $10, $10, $0E
;	$1F, $0E, $10, $02, 	$1E, $1F, $08, $1F, 	$18, $80, $00, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $06, $02, $07
	smpsVcCoarseFreq    $07, $00, $04, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0E, $10, $10, $1F
	smpsVcDecayRate2    $02, $10, $0E, $1F
	smpsVcDecayLevel    $01, $00, $01, $01
	smpsVcReleaseRate   $0F, $08, $0F, $0E
	smpsVcTotalLevel    $00, $00, $00, $18

;	Voice $01
;	$30
;	$70, $00, $00, $70, 	$1F, $1F, $1F, $1F, 	$1F, $10, $16, $1F
;	$10, $11, $0E, $08, 	$1E, $1F, $17, $1F, 	$10, $16, $10, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $00, $00, $07
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $16, $10, $1F
	smpsVcDecayRate2    $08, $0E, $11, $10
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0F, $07, $0F, $0E
	smpsVcTotalLevel    $00, $10, $16, $10

