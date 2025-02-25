Sound_6D_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_6D_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_6D_FM5,	$00, $02

; FM5 Data
Sound_6D_FM5:
	smpsSetvoice        $00

Sound_6D_Loop00:
	dc.b	nCs3, $0C
	smpsAlterVol        $06
	smpsLoop            $00, $05, Sound_6D_Loop00
	smpsStop

Sound_6D_Voices:
;	Voice $00
;	$1A
;	$75, $30, $20, $6F, 	$1F, $1F, $1B, $1F, 	$1F, $1C, $1A, $1F
;	$08, $10, $09, $00, 	$17, $0F, $0E, $0F, 	$07, $16, $10, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $03
	smpsVcUnusedBits    $00
	smpsVcDetune        $06, $02, $03, $07
	smpsVcCoarseFreq    $0F, $00, $00, $05
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1B, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1A, $1C, $1F
	smpsVcDecayRate2    $00, $09, $10, $08
	smpsVcDecayLevel    $00, $00, $00, $01
	smpsVcReleaseRate   $0F, $0E, $0F, $07
	smpsVcTotalLevel    $00, $10, $16, $07

