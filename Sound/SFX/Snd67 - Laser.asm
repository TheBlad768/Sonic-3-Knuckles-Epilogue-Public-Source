Sound_DD_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_DD_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_DD_FM5,	$00, $00

; FM5 Data
Sound_DD_FM5:
	dc.b	nRst, $01
	smpsSetvoice        $00
	smpsModSet          $00, $01, $F3, $66
	dc.b	nEb1, $2E
	smpsStop

Sound_DD_Voices:
;	Voice $00
;	$3A
;	$03, $00, $00, $3A, 	$11, $15, $1F, $1F, 	$1F, $1C, $0A, $1F
;	$0A, $0B, $10, $01, 	$1F, $0F, $12, $0F, 	$10, $07, $00, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $00, $00, $00
	smpsVcCoarseFreq    $0A, $00, $00, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $15, $11
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $0A, $1C, $1F
	smpsVcDecayRate2    $01, $10, $0B, $0A
	smpsVcDecayLevel    $00, $01, $00, $01
	smpsVcReleaseRate   $0F, $02, $0F, $0F
	smpsVcTotalLevel    $00, $00, $07, $10

