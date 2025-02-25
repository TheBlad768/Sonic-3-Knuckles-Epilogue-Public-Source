Sound_48_1_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_48_1_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_48_1_FM5,	$37, $04

; FM5 Data
Sound_48_1_FM5:
	dc.b	nRst, $01
	smpsSetvoice        $00
	dc.b	nAb1, $0C, nRst, $01

Sound_48_1_Loop00:
	dc.b	nF2, $08, nRst, $01
	smpsAlterVol        $1D
	smpsLoop            $00, $02, Sound_48_1_Loop00
	smpsStop

Sound_48_1_Voices:
;	Voice $00
;	$3A
;	$7F, $08, $33, $1F, 	$1D, $16, $0F, $1F, 	$1F, $1C, $1A, $1F
;	$10, $12, $0D, $00, 	$1F, $1F, $2F, $0F, 	$1D, $10, $00, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $03, $00, $07
	smpsVcCoarseFreq    $0F, $03, $08, $0F
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $0F, $16, $1D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1A, $1C, $1F
	smpsVcDecayRate2    $00, $0D, $12, $10
	smpsVcDecayLevel    $00, $02, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $10, $1D

