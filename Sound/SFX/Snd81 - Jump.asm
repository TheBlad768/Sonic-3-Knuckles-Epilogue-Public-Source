Sound_09_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_09_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_09_FM5,	$00, $01

; FM5 Data
Sound_09_FM5:
	smpsSetvoice        $00
	dc.b	nG0, $05
	smpsSetvoice        $01

Sound_09_Loop00:
	dc.b	nB1, $0A
	smpsAlterVol        $06
	smpsLoop            $00, $06, Sound_09_Loop00
	smpsStop

Sound_09_Voices:
;	Voice $00
;	$30
;	$01, $60, $61, $41, 	$1F, $1F, $1F, $1F, 	$1C, $1F, $1F, $10
;	$10, $08, $0C, $00, 	$1B, $1A, $0C, $1F, 	$10, $00, $1B, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $06, $06, $00
	smpsVcCoarseFreq    $01, $01, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $10, $1F, $1F, $1C
	smpsVcDecayRate2    $00, $0C, $08, $10
	smpsVcDecayLevel    $01, $00, $01, $01
	smpsVcReleaseRate   $0F, $0C, $0A, $0B
	smpsVcTotalLevel    $00, $1B, $00, $10

;	Voice $01
;	$30
;	$4C, $16, $20, $6F, 	$1F, $1F, $1E, $1F, 	$1F, $1F, $1F, $1F
;	$09, $0E, $0A, $00, 	$1B, $1A, $1C, $0F, 	$1F, $1A, $0C, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $06, $02, $01, $04
	smpsVcCoarseFreq    $0F, $00, $06, $0C
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1E, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $1F
	smpsVcDecayRate2    $00, $0A, $0E, $09
	smpsVcDecayLevel    $00, $01, $01, $01
	smpsVcReleaseRate   $0F, $0C, $0A, $0B
	smpsVcTotalLevel    $00, $0C, $1A, $1F

