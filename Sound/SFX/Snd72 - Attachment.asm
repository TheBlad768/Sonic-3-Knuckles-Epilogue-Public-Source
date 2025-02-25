Sound_26_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_26_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM4, Sound_26_FM4,	$00, $00

; FM4 Data
Sound_26_FM4:
	smpsSetvoice        $00
	dc.b	nBb0, $04, nRst, $01
	smpsSetvoice        $01

Sound_26_Loop00:
	dc.b	nC0, $07
	smpsAlterVol        $0E
	smpsLoop            $00, $03, Sound_26_Loop00
	smpsStop

Sound_26_Voices:
;	Voice $00
;	$32
;	$33, $6F, $10, $03, 	$1F, $1F, $1F, $1F, 	$1F, $1C, $1F, $11
;	$12, $13, $0D, $00, 	$1F, $2F, $1F, $0A, 	$00, $09, $18, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $01, $06, $03
	smpsVcCoarseFreq    $03, $00, $0F, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $11, $1F, $1C, $1F
	smpsVcDecayRate2    $00, $0D, $13, $12
	smpsVcDecayLevel    $00, $01, $02, $01
	smpsVcReleaseRate   $0A, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $18, $09, $00

;	Voice $01
;	$12
;	$01, $77, $40, $0F, 	$1E, $1F, $1F, $1F, 	$0F, $0C, $0F, $1F
;	$1B, $1B, $05, $00, 	$0F, $1F, $0F, $0F, 	$1C, $1B, $10, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $02
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $04, $07, $00
	smpsVcCoarseFreq    $0F, $00, $07, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $0F, $0C, $0F
	smpsVcDecayRate2    $00, $05, $1B, $1B
	smpsVcDecayLevel    $00, $00, $01, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $10, $1B, $1C

