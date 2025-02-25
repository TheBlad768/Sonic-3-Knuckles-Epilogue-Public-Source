Sound_SegaPresent_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_SegaPresent_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_SegaPresent_FM5,	$50, $05

; FM5 Data
Sound_SegaPresent_FM5:
	dc.b	nRst, $03
	smpsSetvoice        $00
	dc.b	nC0, $7F, smpsNoAttack, $30
	smpsStop

Sound_SegaPresent_Voices:
;	Voice $00
;	$0D
;	$7E, $37, $17, $07, 	$06, $0D, $0D, $0E, 	$1F, $1A, $0A, $1F
;	$01, $06, $06, $06, 	$07, $09, $09, $09, 	$00, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $01
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $01, $03, $07
	smpsVcCoarseFreq    $07, $07, $07, $0E
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0E, $0D, $0D, $06
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $0A, $1A, $1F
	smpsVcDecayRate2    $06, $06, $06, $01
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $09, $09, $09, $07
	smpsVcTotalLevel    $00, $00, $00, $00

