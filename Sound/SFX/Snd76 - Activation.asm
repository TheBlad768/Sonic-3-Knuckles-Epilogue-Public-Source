Sound_70_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_70_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $03

	smpsHeaderSFXChannel cFM4, Sound_70_FM4,	$FA, $04
	smpsHeaderSFXChannel cFM5, Sound_70_FM5,	$00, $04
	smpsHeaderSFXChannel cPSG3, Sound_70_PSG3,	$00, $00

; FM4 Data
Sound_70_FM4:
	smpsSetvoice        $00
	dc.b	nF4, $03, nRst, $01
	smpsSetvoice        $01
	smpsModSet          $01, $01, $0E, $FF

Sound_70_Loop01:
	dc.b	nCs3, $0B
	smpsAlterVol        $04
	smpsLoop            $00, $08, Sound_70_Loop01
	smpsStop

; FM5 Data
Sound_70_FM5:
	smpsSetvoice        $02
	dc.b	nF0, $03, nRst, $01

Sound_70_Loop00:
	dc.b	nC1, $0B
	smpsAlterVol        $04
	smpsLoop            $00, $08, Sound_70_Loop00
	smpsStop

; PSG3 Data
Sound_70_PSG3:
	smpsPSGform         $E7
	dc.b	nC3, $03, nRst, $01
	smpsModSet          $00, $02, $FE, $FF

Sound_70_Loop02:
	dc.b	nG5, $0B
	smpsPSGAlterVol     $01
	smpsLoop            $00, $08, Sound_70_Loop02
	smpsStop

Sound_70_Voices:
;	Voice $00
;	$3D
;	$1E, $7D, $3F, $0C, 	$1F, $1F, $1F, $1F, 	$1F, $1F, $1F, $1F
;	$10, $00, $00, $00, 	$0E, $0F, $0F, $0F, 	$0E, $87, $88, $88
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $07, $01
	smpsVcCoarseFreq    $0C, $0F, $0D, $0E
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $1F
	smpsVcDecayRate2    $00, $00, $00, $10
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0E
	smpsVcTotalLevel    $08, $08, $07, $0E

;	Voice $01
;	$3C
;	$75, $24, $19, $30, 	$1F, $1F, $1F, $1F, 	$1F, $1F, $15, $1F
;	$0F, $00, $01, $00, 	$0F, $0F, $2F, $0F, 	$08, $80, $10, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $01, $02, $07
	smpsVcCoarseFreq    $00, $09, $04, $05
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $15, $1F, $1F
	smpsVcDecayRate2    $00, $01, $00, $0F
	smpsVcDecayLevel    $00, $02, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $10, $00, $08

;	Voice $02
;	$38
;	$02, $20, $22, $64, 	$1F, $1F, $1F, $1F, 	$1F, $1F, $1F, $1F
;	$1B, $10, $10, $00, 	$0F, $0F, $0F, $0F, 	$1D, $10, $02, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $06, $02, $02, $00
	smpsVcCoarseFreq    $04, $02, $00, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $1F
	smpsVcDecayRate2    $00, $10, $10, $1B
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $02, $10, $1D

