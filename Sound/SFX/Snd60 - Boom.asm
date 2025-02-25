Sound_041_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_041_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $03

	smpsHeaderSFXChannel cFM5, Sound_041_FM5,		$00, $00
	smpsHeaderSFXChannel cFM4, Sound_041_FM4,		$00, $00
	smpsHeaderSFXChannel cPSG3, Sound_041_PSG3,	$00, $02

; FM5 Data
Sound_041_FM5:
	smpsSetvoice        $02
	smpsModSet          $00, $01, $C6, $FF
	dc.b	nA0, $04, nRst, $01
	smpsSetvoice        $01
	smpsModSet          $00, $01, $D4, $FF

Sound_041_Loop01:
	dc.b	nFs1, $08
	smpsAlterVol        $04
	smpsLoop            $00, $0C, Sound_041_Loop01
	smpsStop

; FM4 Data
Sound_041_FM4:
	smpsSetvoice        $02
	smpsModSet          $00, $01, $A6, $FF
	dc.b	nD0, $04, nRst, $01
	smpsSetvoice        $00
	smpsModSet          $00, $01, $C4, $FF

Sound_041_Loop00:
	dc.b	nE1, $0A
	smpsAlterVol        $04
	smpsLoop            $00, $0C, Sound_041_Loop00
	smpsStop

; PSG3 Data
Sound_041_PSG3:
	smpsPSGform         $E7
	smpsModSet          $00, $02, $01, $FF
	dc.b	nC3, $04, nRst, $01

Sound_041_Loop02:
	dc.b	nAb5, $0B, smpsNoAttack
	smpsPSGAlterVol     $00
	smpsLoop            $00, $09, Sound_041_Loop02

Sound_041_Loop03:
	dc.b	nAb5, $0B, smpsNoAttack
	smpsPSGAlterVol     $01
	smpsLoop            $00, $03, Sound_041_Loop03
	smpsStop

Sound_041_Voices:
;	Voice $00
;	$3D
;	$03, $03, $03, $03, 	$1F, $1F, $1F, $1E, 	$1E, $1B, $1F, $1F
;	$04, $00, $00, $00, 	$19, $1A, $09, $0F, 	$09, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $03, $03, $03, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1E, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1B, $1E
	smpsVcDecayRate2    $00, $00, $00, $04
	smpsVcDecayLevel    $00, $00, $01, $01
	smpsVcReleaseRate   $0F, $09, $0A, $09
	smpsVcTotalLevel    $00, $00, $00, $09

;	Voice $01
;	$3D
;	$00, $50, $31, $75, 	$1F, $1F, $1F, $1F, 	$10, $1D, $1F, $1F
;	$00, $00, $00, $00, 	$1F, $0F, $0F, $0F, 	$05, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $05, $00
	smpsVcCoarseFreq    $05, $01, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1D, $10
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $05

;	Voice $02
;	$38
;	$27, $72, $11, $53, 	$1F, $1F, $1F, $1F, 	$1C, $1D, $1F, $1F
;	$18, $10, $02, $00, 	$19, $2F, $0F, $0F, 	$0C, $12, $00, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $05, $01, $07, $02
	smpsVcCoarseFreq    $03, $01, $02, $07
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1D, $1C
	smpsVcDecayRate2    $00, $02, $10, $18
	smpsVcDecayLevel    $00, $00, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $09
	smpsVcTotalLevel    $00, $00, $12, $0C

