SVA_INVIN_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SVA_INVIN_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $04

	smpsHeaderDAC       SVA_INVIN_DAC
	smpsHeaderFM        SVA_INVIN_FM1,	$0C, $00
	smpsHeaderFM        SVA_INVIN_FM2,	$00, $02
	smpsHeaderFM        SVA_INVIN_FM3,	$00, $0C
	smpsHeaderFM        SVA_INVIN_FM4,	$00, $00
	smpsHeaderFM        SVA_INVIN_FM5,	$00, $00
	smpsHeaderPSG       SVA_INVIN_PSG1,	$00, $02, $00, $00
	smpsHeaderPSG       SVA_INVIN_PSG2,	$00, $04, $00, $00
	smpsHeaderPSG       SVA_INVIN_PSG3,	$00, $00, $00, fTone_02

; DAC Data
SVA_INVIN_DAC:
	smpsPan             panCenter, $00

SVA_INVIN_Loop00:
	dc.b	dKick, $0F, dSnare, $17, dKick, $07, dSnare, $0F
	smpsLoop            $00, $10, SVA_INVIN_Loop00
	smpsJump            SVA_INVIN_Loop00

; FM1 Data
SVA_INVIN_FM1:
	smpsSetvoice        $00
	smpsPan             panCenter, $00

SVA_INVIN_Loop0C:
	dc.b	nD2, $08, nD3, $03, nRst, $04
	smpsLoop            $00, $04, SVA_INVIN_Loop0C

SVA_INVIN_Loop0D:
	dc.b	nBb1, $08, nBb2, $03, nRst, $04
	smpsLoop            $00, $04, SVA_INVIN_Loop0D

SVA_INVIN_Loop0E:
	dc.b	nG1, $08, nG2, $03, nRst, $04
	smpsLoop            $00, $07, SVA_INVIN_Loop0E
	dc.b	nBb1, $08, nBb2, $03, nRst, $04
	smpsLoop            $01, $04, SVA_INVIN_Loop0C
	smpsJump            SVA_INVIN_Loop0C

; FM2 Data
SVA_INVIN_FM2:
	smpsSetvoice        $01
	smpsPan             panCenter, $00

SVA_INVIN_Loop0B:
	dc.b	nD4, $17, nC4, $07, nD4, $0F, nF4, nD4, nRst, $08, nF4, $07
	dc.b	nD4, $08, nF4, $07, nD4, $08, nBb3, $07, nD4, $0F, nRst, $08
	dc.b	nF4, $07, nE4, $08, nF4, $0F, nD4, $07, nE4, $0F, nRst, $08
	dc.b	nE4, $07, nF4, $08, nG4, $07, nA4, $08, nG4, $07
	smpsLoop            $00, $03, SVA_INVIN_Loop0B
	dc.b	nD4, $17, nC4, $07, nD4, $0F, nF4, nD4, nRst, $08, nD4, $07
	dc.b	nF4, $08, nD4, $07, nBb3, $08, nD4, $07, nBb3, $0F, nRst, $08
	dc.b	nBb3, $07, nA3, $08, nG3, $0F, nA3, $07, nD3, $04, nF3, nA3
	dc.b	$03, nD4, $04, nF4, nA4, nD5, $03, nF5, $04, nA5, nF5, nD5
	dc.b	$03, nA4, $04, nF4, nD4, nA3, $03, nF3, $04
	smpsJump            SVA_INVIN_Loop0B

; FM3 Data
SVA_INVIN_FM3:
	dc.b	nRst, $06
	smpsAlterNote       $F6
	smpsJump            SVA_INVIN_FM2

; FM4 Data
SVA_INVIN_FM4:
	smpsSetvoice        $02
	smpsPan             panCenter, $00

SVA_INVIN_Loop0A:
	dc.b	nA4, $04, nRst, nA4, $03, nRst, $04, nA4, nRst, $0B

SVA_INVIN_Loop06:
	dc.b	nA4, $04, nRst, nA4, $03, nRst, $04
	smpsLoop            $00, $02, SVA_INVIN_Loop06
	dc.b	nF4, nRst, nF4, $03, nRst, $04, nF4, nRst, $0B

SVA_INVIN_Loop07:
	dc.b	nF4, $04, nRst, nF4, $03, nRst, $04
	smpsLoop            $00, $02, SVA_INVIN_Loop07
	dc.b	nG4, nRst, nG4, $03, nRst, $04, nG4, nRst, $0B

SVA_INVIN_Loop08:
	dc.b	nG4, $04, nRst, nG4, $03, nRst, $04
	smpsLoop            $00, $03, SVA_INVIN_Loop08
	dc.b	nG4, nRst, $0B

SVA_INVIN_Loop09:
	dc.b	nG4, $04, nRst, nG4, $03, nRst, $04
	smpsLoop            $00, $02, SVA_INVIN_Loop09
	smpsLoop            $01, $04, SVA_INVIN_Loop0A
	smpsJump            SVA_INVIN_Loop0A

; FM5 Data
SVA_INVIN_FM5:
	smpsSetvoice        $02
	smpsPan             panCenter, $00

SVA_INVIN_Loop05:
	dc.b	nF4, $04, nRst, nF4, $03, nRst, $04, nF4, nRst, $0B

SVA_INVIN_Loop01:
	dc.b	nF4, $04, nRst, nF4, $03, nRst, $04
	smpsLoop            $00, $02, SVA_INVIN_Loop01
	dc.b	nD4, nRst, nD4, $03, nRst, $04, nD4, nRst, $0B

SVA_INVIN_Loop02:
	dc.b	nD4, $04, nRst, nD4, $03, nRst, $04
	smpsLoop            $00, $03, SVA_INVIN_Loop02
	dc.b	nD4, nRst, $0B

SVA_INVIN_Loop03:
	dc.b	nD4, $04, nRst, nD4, $03, nRst, $04
	smpsLoop            $00, $02, SVA_INVIN_Loop03
	dc.b	nE4, nRst, nE4, $03, nRst, $04, nE4, nRst, $0B

SVA_INVIN_Loop04:
	dc.b	nE4, $04, nRst, nE4, $03, nRst, $04
	smpsLoop            $00, $02, SVA_INVIN_Loop04
	smpsLoop            $01, $04, SVA_INVIN_Loop05
	smpsJump            SVA_INVIN_Loop05

; PSG1 Data
SVA_INVIN_PSG1:
	dc.b	nD2, $04, nF2, nA2, $03, nD3, $04, nF3, nD3, nA2, $03, nF2
	dc.b	$04, nA2, nD3, nF3, $03, nA3, $04, nD4, nA3, nF3, $03, nD3
	dc.b	$04, nBb2, nF2, nBb1, $03, nF1, $04, nD1, nF1, nBb1, $03, nD2
	dc.b	$04, nF2, nD2, nBb1, $03, nD2, $04, nF2, nBb2, nD3, $03, nF3
	dc.b	$04

SVA_INVIN_Loop10:
	dc.b	nG2, nD2, nBb1, $03, nG1, $04
	smpsLoop            $00, $02, SVA_INVIN_Loop10
	dc.b	nBb1, nD2, nG2, $03, nBb2, $04, nG2, nD2, nBb1, $03, nG1, $04

SVA_INVIN_Loop11:
	dc.b	nBb2, nG2, nE2, $03, nBb1, $04, nE3, nBb2, nG2, $03, nE2, $04
	smpsLoop            $00, $02, SVA_INVIN_Loop11
	smpsLoop            $01, $04, SVA_INVIN_PSG1
	smpsJump            SVA_INVIN_PSG1

; PSG2 Data
SVA_INVIN_PSG2:
	dc.b	nRst, $06
	smpsAlterNote       $01
	smpsJump            SVA_INVIN_PSG1

; PSG3 Data
SVA_INVIN_PSG3:
	smpsPSGform         $E7

SVA_INVIN_Jump00:
	dc.b	nMaxPSG

SVA_INVIN_Loop0F:
	dc.b	$08, $07
	smpsPSGvoice        fTone_01
	dc.b	$08
	smpsPSGvoice        fTone_02
	dc.b	$07
	smpsLoop            $00, $20, SVA_INVIN_Loop0F
	smpsJump            SVA_INVIN_Jump00

SVA_INVIN_Voices:
;	Voice $00
;	$20
;	$66, $65, $60, $61, 	$DF, $DF, $9F, $9F, 	$07, $06, $09, $06
;	$07, $06, $06, $08, 	$20, $10, $10, $F8, 	$19, $37, $13, $10
	smpsVcAlgorithm     $00
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $06, $06, $06, $06
	smpsVcCoarseFreq    $01, $00, $05, $06
	smpsVcRateScale     $02, $02, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $09, $06, $07
	smpsVcDecayRate2    $08, $06, $06, $07
	smpsVcDecayLevel    $0F, $01, $01, $02
	smpsVcReleaseRate   $08, $00, $00, $00
	smpsVcTotalLevel    $10, $13, $37, $19

;	Voice $01
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $04
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $04, $27, $28, $18

;	Voice $02
;	$38
;	$58, $54, $31, $31, 	$1A, $1A, $14, $13, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$00, $00, $00, $07, 	$1C, $26, $20, $0C
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $05, $05
	smpsVcCoarseFreq    $01, $01, $04, $08
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $13, $14, $1A, $1A
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $07, $00, $00, $00
	smpsVcTotalLevel    $0C, $20, $26, $1C

