Sound_6C_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_6C_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_6C_FM5,	$10, $00

; FM5 Data
Sound_6C_FM5:
	smpsSetvoice        $00
	smpsModSet          $00, $01, $E3, $FF
	dc.b	nC0, $04, nRst, $01

Sound_6C_Loop00:
	dc.b	nE0, $08
	smpsAlterVol        $0C
	smpsLoop            $00, $04, Sound_6C_Loop00
	smpsStop

Sound_6C_Voices:
;	Voice $00
;	$3A
;	$30, $10, $10, $03, 	$1F, $1F, $1F, $1F, 	$1F, $1F, $1F, $1F
;	$0F, $11, $00, $04, 	$0F, $0F, $0F, $0F, 	$00, $27, $20, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $01, $01, $03
	smpsVcCoarseFreq    $03, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $1F
	smpsVcDecayRate2    $04, $00, $11, $0F
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $20, $27, $00

