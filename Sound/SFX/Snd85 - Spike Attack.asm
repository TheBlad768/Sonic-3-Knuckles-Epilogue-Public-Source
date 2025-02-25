Sound_124_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_124_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_124_FM5,	$00, $01

; FM5 Data
Sound_124_FM5:
	dc.b	nRst, $01
	smpsSetvoice        $00
	smpsModSet          $00, $01, $26, $FF

Sound_124_Loop00:
	dc.b	nC1, $0B
	smpsAlterVol        $0A
	smpsLoop            $00, $03, Sound_124_Loop00
	smpsStop

Sound_124_Voices:
;	Voice $00
;	$3A
;	$7B, $30, $30, $75, 	$0E, $0F, $0E, $12, 	$1F, $12, $1F, $1F
;	$00, $00, $07, $00, 	$1F, $0F, $1F, $0F, 	$1A, $1C, $05, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $03, $07
	smpsVcCoarseFreq    $05, $00, $00, $0B
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $12, $0E, $0F, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $12, $1F
	smpsVcDecayRate2    $00, $07, $00, $00
	smpsVcDecayLevel    $00, $01, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $05, $1C, $1A

