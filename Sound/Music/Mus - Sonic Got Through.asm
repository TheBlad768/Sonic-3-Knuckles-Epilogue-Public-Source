End_Level_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     End_Level_Voices
	smpsHeaderChan      $05, $03
	smpsHeaderTempo     $02, $09

	smpsHeaderDAC       End_Level_DAC
	smpsHeaderFM        End_Level_FM1,	$00, $FE
	smpsHeaderFM        End_Level_FM2,	$00, $02
	smpsHeaderFM        End_Level_FM3,	$00, $02
	smpsHeaderFM        End_Level_FM4,	$00, $02
	smpsHeaderPSG       End_Level_PSG1,	$00, $00, $00, $00
	smpsHeaderPSG       End_Level_PSG2,	$00, $02, $00, $00
	smpsHeaderPSG       End_Level_PSG3,	$00, $01, $00, fTone_02

; DAC Data
End_Level_DAC:
	smpsPan             panCenter, $00
	dc.b	nRst, $01, dKick, $09

End_Level_Loop00:
	dc.b	dSnare, $0F, dKick, $05, dSnare, $0A, dKick
	smpsLoop            $00, $02, End_Level_Loop00
	dc.b	dSnare, $0F, dKick, $05, dSnare, $0A, $05, dKick, $03, $02, dSnare, $05
	dc.b	dKick, $03, $02, dSnare, $05, dKick, $03, $02, dSnare, $03, $02, $03
	dc.b	$02, dKick, $32
	smpsStop

; FM1 Data
End_Level_FM1:
	smpsSetvoice        $00
	smpsPan             panCenter, $00

End_Level_Loop0A:
	dc.b	nD2, $05, nD3, $03, nRst, $02
	smpsLoop            $00, $04, End_Level_Loop0A

End_Level_Loop0B:
	dc.b	nBb1, $05, nBb2, $03, nRst, $02
	smpsLoop            $00, $04, End_Level_Loop0B

End_Level_Loop0C:
	dc.b	nG1, $05, nG2, $03, nRst, $02
	smpsLoop            $00, $07, End_Level_Loop0C
	dc.b	nBb1, $05, nBb2, $03, nRst, $02, nD2, $1E, nCs2, $01, nC2, $02
	dc.b	nB1, $01, nBb1, nA1, nG1, $02, nF1, $01, nD1
	smpsStop

; FM3 Data
End_Level_FM3:
	smpsPan             panCenter, $00
	smpsSetvoice        $02
	dc.b	nA4, $03, nRst, $02, nA4, $03, nRst, $02, nA4, $03, nRst, $07

End_Level_Loop07:
	dc.b	nA4, $03, nRst, $02
	smpsLoop            $00, $03, End_Level_Loop07
	smpsAlterVol        $01
	dc.b	nA4, $03, nRst, $02
	smpsAlterVol        $FF
	dc.b	nF4, $03, nRst, $02, nF4, $03, nRst, $02, nF4, $03, nRst, $07

End_Level_Loop08:
	dc.b	nF4, $03, nRst, $02
	smpsLoop            $00, $04, End_Level_Loop08
	dc.b	nG4, $03, nRst, $02, nG4, $03, nRst, $02, nG4, $03, nRst, $07

End_Level_Loop09:
	dc.b	nG4, $03, nRst, $02
	smpsLoop            $00, $06, End_Level_Loop09
	dc.b	nG4, $03, nRst, $07, nG4, $03, nRst, $02, nG4, $03, nRst, $02
	smpsAlterVol        $01
	dc.b	nG4, $03, nRst, $02, nG4, $03, nRst, $02
	smpsSetvoice        $03
	smpsAlterVol        $FF
	dc.b	nD3, $1E, nCs3, $01, nC3, $02, nB2, $01, nBb2, nA2, nG2, $02
	dc.b	nF2, $01, nD2
	smpsStop

; FM2 Data
End_Level_FM2:
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	dc.b	nD4, $03, nRst, $02, nD4, $03, nRst, $02, nD4, $03, nRst, $07

End_Level_Loop04:
	dc.b	nD4, $03, nRst, $02
	smpsLoop            $00, $03, End_Level_Loop04
	smpsAlterVol        $01
	dc.b	nD4, $03, nRst, $02
	smpsAlterVol        $FF
	dc.b	nBb3, $03, nRst, $02, nBb3, $03, nRst, $02

End_Level_Loop06:
	dc.b	nBb3, $03, nRst, $07

End_Level_Loop05:
	dc.b	nBb3, $03, nRst, $02
	smpsLoop            $00, $06, End_Level_Loop05
	smpsLoop            $01, $02, End_Level_Loop06
	dc.b	nBb3, $03, nRst, $07, nBb3, $03, nRst, $02, nBb3, $03, nRst, $02
	smpsAlterVol        $01
	dc.b	nBb3, $03, nRst, $02, nBb3, $03, nRst, $02
	smpsAlterNote       $FE
	smpsSetvoice        $04
	smpsAlterVol        $FF
	dc.b	nD3, $1E, nCs3, $01, nC3, $02, nB2, $01, nBb2, nA2, nG2, $02
	dc.b	nF2, $01, nD2
	smpsStop

; FM4 Data
End_Level_FM4:
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	dc.b	nF4, $03, nRst, $02, nF4, $03, nRst, $02, nF4, $03, nRst, $07

End_Level_Loop01:
	dc.b	nF4, $03, nRst, $02
	smpsLoop            $00, $03, End_Level_Loop01
	smpsAlterVol        $01
	dc.b	nF4, $03, nRst, $02
	smpsAlterVol        $FF
	dc.b	nD4, $03, nRst, $02, nD4, $03, nRst, $02, nD4, $03, nRst, $07

End_Level_Loop02:
	dc.b	nD4, $03, nRst, $02
	smpsLoop            $00, $06, End_Level_Loop02
	dc.b	nD4, $03, nRst, $07

End_Level_Loop03:
	dc.b	nD4, $03, nRst, $02
	smpsLoop            $00, $04, End_Level_Loop03
	dc.b	nE4, $03, nRst, $02, nE4, $03, nRst, $02, nE4, $03, nRst, $07
	dc.b	nE4, $03, nRst, $02, nE4, $03, nRst, $02
	smpsAlterVol        $01
	dc.b	nE4, $03, nRst, $02, nE4, $03
	smpsStop

; PSG1 Data
End_Level_PSG1:
	dc.b	nRst, $37, nD2, $05, nF2, nD2, nBb1, nD2, nBb1, $0A, nRst, $05
	dc.b	nBb1, nA1, nG1, $0A, nA1, $05, nD1, $03, nF1, $02, nA1, $03
	dc.b	nD2, $02, nF2, $03, nA2, $02, nD3, $03, nF3, $02, nA3, $03
	dc.b	nF3, $02, nD3, $03, nA2, $02, nF2, $03, nD2, $02, nA1, $03
	dc.b	nF1, $02, nD1, $28
	smpsStop

; PSG2 Data
End_Level_PSG2:
	dc.b	nRst, $04
	smpsAlterNote       $02
	smpsJump            End_Level_PSG1

; PSG3 Data
End_Level_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $01, nMaxPSG, $04

End_Level_Loop0D:
	dc.b	$05
	smpsPSGvoice        fTone_01
	dc.b	$05
	smpsPSGvoice        fTone_02
	dc.b	$05, $05
	smpsLoop            $00, $05, End_Level_Loop0D
	dc.b	$05
	smpsPSGvoice        fTone_01
	dc.b	$05
	smpsPSGvoice        fTone_02
	dc.b	$5F
	smpsStop

End_Level_Voices:
;	Voice $00
;	$20
;	$36, $35, $30, $31, 	$DF, $DF, $9F, $9F, 	$07, $06, $09, $06
;	$07, $06, $06, $08, 	$20, $10, $10, $F8, 	$19, $37, $13, $0C
	smpsVcAlgorithm     $00
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $00, $05, $06
	smpsVcRateScale     $02, $02, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $09, $06, $07
	smpsVcDecayRate2    $08, $06, $06, $07
	smpsVcDecayLevel    $0F, $01, $01, $02
	smpsVcReleaseRate   $08, $00, $00, $00
	smpsVcTotalLevel    $0C, $13, $37, $19

;	Voice $01
;	$2C
;	$31, $31, $71, $71, 	$5F, $54, $5F, $5F, 	$05, $0A, $03, $0C
;	$00, $03, $03, $03, 	$00, $87, $00, $A7, 	$17, $00, $19, $02
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $07, $03, $03
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $01, $01, $01, $01
	smpsVcAttackRate    $1F, $1F, $14, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0C, $03, $0A, $05
	smpsVcDecayRate2    $03, $03, $03, $00
	smpsVcDecayLevel    $0A, $00, $08, $00
	smpsVcReleaseRate   $07, $00, $07, $00
	smpsVcTotalLevel    $02, $19, $00, $17

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

;	Voice $03
;	$28
;	$33, $53, $70, $30, 	$DF, $DC, $1F, $1F, 	$14, $05, $01, $01
;	$00, $01, $00, $1D, 	$11, $21, $10, $F8, 	$0E, $1B, $12, $0C
	smpsVcAlgorithm     $00
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $05, $03
	smpsVcCoarseFreq    $00, $00, $03, $03
	smpsVcRateScale     $00, $00, $03, $03
	smpsVcAttackRate    $1F, $1F, $1C, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $01, $01, $05, $14
	smpsVcDecayRate2    $1D, $00, $01, $00
	smpsVcDecayLevel    $0F, $01, $02, $01
	smpsVcReleaseRate   $08, $00, $01, $01
	smpsVcTotalLevel    $0C, $12, $1B, $0E

;	Voice $04
;	$38
;	$53, $51, $51, $51, 	$DF, $DF, $1F, $1F, 	$07, $0E, $07, $04
;	$04, $03, $03, $08, 	$F7, $31, $71, $69, 	$1B, $11, $10, $0C
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $05, $05, $05, $05
	smpsVcCoarseFreq    $01, $01, $01, $03
	smpsVcRateScale     $00, $00, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $07, $0E, $07
	smpsVcDecayRate2    $08, $03, $03, $04
	smpsVcDecayLevel    $06, $07, $03, $0F
	smpsVcReleaseRate   $09, $01, $01, $07
	smpsVcTotalLevel    $0C, $10, $11, $1B

