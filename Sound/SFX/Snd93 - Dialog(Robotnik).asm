Sound_DialogRobotnik_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_DialogRobotnik_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM4, Sound_DialogRobotnik_FM4,	$32, $12

; FM4 Data
Sound_DialogRobotnik_FM4:
	smpsSetvoice        $00
	dc.b	nC0, $01
	smpsStop

Sound_DialogRobotnik_Voices:
;	Voice $03
;	$07
;	$01, $01, $01, $01, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$00, $00, $7F, $7F
	smpsVcAlgorithm     $07
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $7F, $7F, $00, $00