Sound_C7_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_C7_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, Sound_C7_FM5,	$0F, $03
	smpsHeaderSFXChannel cPSG3, Sound_C7_PSG3,	$00, $00

; FM5 Data
Sound_C7_FM5:
	smpsSetvoice        $00
	smpsModSet          $00, $01, $03, $FF

Sound_C7_Loop00:
	dc.b	nBb2, $0A
	smpsAlterVol        $05
	smpsLoop            $00, $03, Sound_C7_Loop00
	smpsStop

; PSG3 Data
Sound_C7_PSG3:
	smpsPSGform         $E7
	smpsPSGvoice        fTone_05
	smpsModSet          $00, $01, $FB, $FF

Sound_C7_Loop01:
	dc.b	nC4, $0A
	smpsPSGAlterVol     $01
	smpsLoop            $00, $03, Sound_C7_Loop01
	smpsStop

Sound_C7_Voices:
;	Voice $00
;	$3A
;	$0E, $3D, $7B, $0D, 	$1F, $1D, $19, $1B, 	$1F, $1F, $16, $1F
;	$1F, $11, $10, $00, 	$1F, $1F, $1F, $0F, 	$12, $34, $05, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $07, $03, $00
	smpsVcCoarseFreq    $0D, $0B, $0D, $0E
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1B, $19, $1D, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $16, $1F, $1F
	smpsVcDecayRate2    $00, $10, $11, $1F
	smpsVcDecayLevel    $00, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $05, $34, $12

