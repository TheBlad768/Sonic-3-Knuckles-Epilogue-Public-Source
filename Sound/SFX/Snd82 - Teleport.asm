Sound_F8_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_F8_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_F8_FM5,	$00, $03

; FM5 Data
Sound_F8_FM5:
	dc.b	nRst, $01
	smpsSetvoice        $00
	smpsModSet          $00, $01, $DD, $FF
	dc.b	nC0, $07, nRst, $02
	smpsStop

Sound_F8_Voices:
;	Voice $00
;	$08
;	$50, $10, $07, $5F, 	$1F, $1F, $0C, $0F, 	$1F, $1F, $1F, $1F
;	$00, $0E, $0E, $00, 	$07, $07, $16, $0A, 	$00, $3F, $00, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $01
	smpsVcUnusedBits    $00
	smpsVcDetune        $05, $00, $01, $05
	smpsVcCoarseFreq    $0F, $07, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0F, $0C, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $1F
	smpsVcDecayRate2    $00, $0E, $0E, $00
	smpsVcDecayLevel    $00, $01, $00, $00
	smpsVcReleaseRate   $0A, $06, $07, $07
	smpsVcTotalLevel    $00, $00, $3F, $00

