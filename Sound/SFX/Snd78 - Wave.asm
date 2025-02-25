Sound_110_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_110_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_110_FM5,	$06, $04

; FM5 Data
Sound_110_FM5:
	dc.b	nRst, $01
	smpsSetvoice        $00
	dc.b	nBb4, $24
	smpsAlterVol        $19
	dc.b	$15
	smpsStop

Sound_110_Voices:
;	Voice $00
;	$38
;	$00, $40, $00, $0F, 	$0C, $0F, $0E, $0F, 	$1F, $1F, $1F, $0F
;	$02, $0C, $00, $0A, 	$1F, $1F, $0F, $0F, 	$1F, $03, $0A, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $04, $00
	smpsVcCoarseFreq    $0F, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0F, $0E, $0F, $0C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0F, $1F, $1F, $1F
	smpsVcDecayRate2    $0A, $00, $0C, $02
	smpsVcDecayLevel    $00, $00, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $0A, $03, $1F

