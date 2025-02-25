Sound_DF_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_DF_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_DF_FM5,	$0F, $00

; FM5 Data
Sound_DF_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $0D, $46

Sound_DF_Loop00:
	dc.b	nFs0, $1D
	smpsAlterVol        $20
	smpsLoop            $00, $02, Sound_DF_Loop00
	smpsStop

Sound_DF_Voices:
;	Voice $00
;	$3A
;	$7F, $00, $01, $1F, 	$1D, $1F, $1F, $1F, 	$1F, $1C, $0A, $1F
;	$00, $00, $0D, $00, 	$17, $00, $09, $0F, 	$1D, $10, $13, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $00, $00, $07
	smpsVcCoarseFreq    $0F, $01, $00, $0F
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $0A, $1C, $1F
	smpsVcDecayRate2    $00, $0D, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $01
	smpsVcReleaseRate   $0F, $09, $00, $07
	smpsVcTotalLevel    $00, $13, $10, $1D

