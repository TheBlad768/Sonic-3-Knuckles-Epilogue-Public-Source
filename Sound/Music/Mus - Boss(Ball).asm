Snd_MBoss_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Snd_MBoss_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $0D

	smpsHeaderDAC       Snd_MBoss_DAC
	smpsHeaderFM        Snd_MBoss_FM1,	$00, $08
	smpsHeaderFM        Snd_MBoss_FM2,	$00, $06
	smpsHeaderFM        Snd_MBoss_FM3,	$00, $06
	smpsHeaderFM        Snd_MBoss_FM4,	$00, $06
	smpsHeaderFM        Snd_MBoss_FM5,	$00, $06
	smpsHeaderPSG       Snd_MBoss_PSG2,	$0C, $03, $00, $00
	smpsHeaderPSG       Snd_MBoss_PSG1,	$0C, $01, $00, $00
	smpsHeaderPSG       Snd_MBoss_PSG3,	$0C, $02, $00, sTone_01

; DAC Data
Snd_MBoss_DAC:
	smpsPan             panCenter, $00
	dc.b	nRst, $01
	dc.b	$9B
	dc.b	nRst, $3A, $9B, $28, $81, $05, $05, $05, $05

Snd_MBoss_Jump00:
	dc.b	$9B, $14, $82, $81, $0A, $0A, $82, $14, $81, $82, $0A, $81
	dc.b	$14, $0A, $82, $14, $81, $82, $81, $0A, $0A, $82, $14, $81
	dc.b	$82, $0A, $81, $14, $0A, $82, $82, $05, $05, $81, $14, $82
	dc.b	$81, $0A, $0A, $82, $14, $81, $82, $0A, $81, $14, $0A, $82
	dc.b	$14, $81, $82, $81, $0A, $0A, $82, $14, $81, $82, $0A, $81
	dc.b	$81, $05, $05, $0A, $82, $05, $05, $91, $91, $9B, $14

Snd_MBoss_Loop00:
	dc.b	$82, $81, $0A, $0A, $82, $14, $81, $82, $0A, $81, $14, $0A
	dc.b	$82, $14, $81
	smpsLoop            $00, $03, Snd_MBoss_Loop00
	dc.b	$82, $81, $0A, $0A, $82, $14, $81, $82, $0A, $81, $81, $05
	dc.b	$82, $81, $0A, $82, $05, $05, $91, $91, $9B, $14, $81, $81
	dc.b	$81, $81, $81, $81, $0A, $0A, $0A, $03, $02, $03, $02, $14
	dc.b	$82, $81, $0A, $0A, $82, $14, $81, $82, $0A, $81, $14, $0A
	dc.b	$82, $14, $9B, $81, $81, $81, $81, $81, $81, $0A, $0A, $0A
	dc.b	$03, $02, $03, $02, $9B, $14, $82, $81, $0A, $0A, $82, $14
	dc.b	$81, $82, $0A, $81, $14, $0A, $82, $14
	smpsPan             panCenter, $00
	smpsJump            Snd_MBoss_Jump00

; FM1 Data
Snd_MBoss_FM1:
	smpsSetvoice        $00
	smpsPan             panCenter, $00

Snd_MBoss_Loop19:
	dc.b	nE2, $0A, nE3, nB2, nB3, nBb3, nRst
	smpsLoop            $00, $02, Snd_MBoss_Loop19

Snd_MBoss_Loop1A:
	dc.b	nE2, $0A, $0A, nA2, nBb2, nE2, nE2, nA2, nBb2, nFs2, nFs2, nA2
	dc.b	nBb2, nE2, nE3, nEb3, nD3
	smpsLoop            $00, $08, Snd_MBoss_Loop1A

Snd_MBoss_Loop1B:
	dc.b	nE3, $05, $05, nRst, nEb3, nEb3, nRst, nD3, nD3, nRst, nCs3, nCs3
	dc.b	nRst, nA2, nB2, nD3, nEb3, nE3, nE3, nRst, nEb3, nEb3, nRst, nD3
	dc.b	nD3, nRst, nCs3, nCs3, nRst, nE4, nD4, nD4, nC4, nE2, $0A, $0A
	dc.b	nA2, nBb2, nE2, nE2, nA2, nBb2, nFs2, nFs2, nA2, nBb2, nE2, nE3
	dc.b	nEb3, nD3
	smpsLoop            $00, $02, Snd_MBoss_Loop1B
	smpsJump            Snd_MBoss_Loop1A

; FM2 Data
Snd_MBoss_FM2:
	smpsSetvoice        $01
	smpsPan             panCenter, $00

Snd_MBoss_Loop13:
	dc.b	nE2, $09, nRst, $01, nE3, $09, nRst, $01, nB2, $09, nRst, $01
	dc.b	nB3, $09, nRst, $01, nBb3, $09, nRst, $0B
	smpsLoop            $00, $02, Snd_MBoss_Loop13

Snd_MBoss_Loop14:
	dc.b	nE2, $04, nRst, $06, nE2, $04, nRst, $01, nE2, $04, nRst, $01
	dc.b	nA2, $09, nRst, $01, nA2, $09, nRst, $01
	smpsLoop            $00, $02, Snd_MBoss_Loop14
	dc.b	nFs2, $04, nRst, $06, nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	dc.b	nA2, $09, nRst, $01, nA2, $09, nRst, $01, nE2, $04, nRst, $01
	dc.b	nE2, $04

Snd_MBoss_Loop15:
	dc.b	nRst, $01, nD3, $09
	smpsLoop            $00, $03, Snd_MBoss_Loop15
	dc.b	nRst, $01
	smpsLoop            $01, $08, Snd_MBoss_Loop14

Snd_MBoss_Loop18:
	dc.b	nE3, $04, nRst, $01, nE3, $04, nRst, $06, nEb3, $04, nRst, $01
	dc.b	nEb3, $04, nRst, $06, nD3, $04, nRst, $01, nD3, $04, nRst, $06
	dc.b	nCs3, $04, nRst, $01, nCs3, $04, nRst, $06, nA2, $04, nRst, $01
	dc.b	nB2, $04, nRst, $01, nD3, $04, nRst, $01, nEb3, $04, nRst, $01
	dc.b	nE3, $04, nRst, $01, nE3, $04, nRst, $06, nEb3, $04, nRst, $01
	dc.b	nEb3, $04, nRst, $06, nD3, $04, nRst, $01, nD3, $04, nRst, $06
	dc.b	nCs3, $04, nRst, $01, nCs3, $04, nRst, $06, nE4, $05, nD4, nD4
	dc.b	nC4

Snd_MBoss_Loop16:
	dc.b	nE2, $04, nRst, $06, nE2, $04, nRst, $01, nE2, $04, nRst, $01
	dc.b	nA2, $09, nRst, $01, nA2, $09, nRst, $01
	smpsLoop            $00, $02, Snd_MBoss_Loop16
	dc.b	nFs2, $04, nRst, $06, nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	dc.b	nA2, $09, nRst, $01, nA2, $09, nRst, $01, nE2, $04, nRst, $01
	dc.b	nE2, $04

Snd_MBoss_Loop17:
	dc.b	nRst, $01, nD3, $09
	smpsLoop            $00, $03, Snd_MBoss_Loop17
	dc.b	nRst, $01
	smpsLoop            $01, $02, Snd_MBoss_Loop18
	smpsJump            Snd_MBoss_Loop14

; FM3 Data
Snd_MBoss_FM3:
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	dc.b	nRst, $0A, nE3, $09, nRst, $01, nB2, $09, nRst, $01, nB3, $09
	dc.b	nRst, $01, nBb3, $09, nRst, $0B, nE2, $09, nRst, $01, nE3, $09
	dc.b	nRst, $01, nB2, $09, nRst, $01, nB3, $09, nRst, $01, nBb3, $09
	dc.b	nRst, $0B

Snd_MBoss_Loop10:
	dc.b	nE2, $04, nRst, $06, nE2, $04, nRst, $01, nE2, $04, nRst, $01
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01
	smpsLoop            $00, $02, Snd_MBoss_Loop10
	dc.b	nFs2, $04, nRst, $06, nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01, nE2, $04, nRst, $01
	dc.b	nE2, $04, nRst, $01, nE3, $09, nRst, $01, nEb3, $09, nRst, $01
	dc.b	nD3, $09, nRst, $01
	smpsLoop            $01, $08, Snd_MBoss_Loop10

Snd_MBoss_Loop12:
	dc.b	nE3, $04, nRst, $01, nE3, $04, nRst, $06, nEb3, $04, nRst, $01
	dc.b	nEb3, $04, nRst, $06, nD3, $04, nRst, $01, nD3, $04, nRst, $06
	dc.b	nCs3, $04, nRst, $01, nCs3, $04, nRst, $06, nA2, $04, nRst, $01
	dc.b	nB2, $04, nRst, $01, nD3, $04, nRst, $01, nEb3, $04, nRst, $01
	dc.b	nE3, $04, nRst, $01, nE3, $04, nRst, $06, nEb3, $04, nRst, $01
	dc.b	nEb3, $04, nRst, $06, nD3, $04, nRst, $01, nD3, $04, nRst, $06
	dc.b	nCs3, $04, nRst, $01, nCs3, $04, nRst, $06, nE4, $05, nD4, nD4
	dc.b	nC4

Snd_MBoss_Loop11:
	dc.b	nE2, $04, nRst, $06, nE2, $04, nRst, $01, nE2, $04, nRst, $01
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01
	smpsLoop            $00, $02, Snd_MBoss_Loop11
	dc.b	nFs2, $04, nRst, $06, nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01, nE2, $04, nRst, $01
	dc.b	nE2, $04, nRst, $01, nE3, $09, nRst, $01, nEb3, $09, nRst, $01
	dc.b	nD3, $09, nRst, $01
	smpsLoop            $01, $02, Snd_MBoss_Loop12
	smpsJump            Snd_MBoss_Loop10

; FM4 Data
Snd_MBoss_FM4:
	smpsSetvoice        $01
	smpsPan             panCenter, $00

Snd_MBoss_Loop07:
	dc.b	nC2, $09, nRst, $01, nC3, $09, nRst, $01, nG2, $09, nRst, $01
	dc.b	nG3, $09, nRst, $01, nFs3, $09, nRst, $0B
	smpsLoop            $00, $02, Snd_MBoss_Loop07

Snd_MBoss_Loop08:
	smpsPan             panLeft, $00

Snd_MBoss_Jump02:
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsLoop            $00, $02, Snd_MBoss_Loop08
	smpsPan             panLeft, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nB2, $09, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09

Snd_MBoss_Loop09:
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09
	smpsLoop            $00, $02, Snd_MBoss_Loop09
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nB2, $09, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09

Snd_MBoss_Loop0A:
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09
	smpsLoop            $00, $02, Snd_MBoss_Loop0A
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nB2, $09, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09

Snd_MBoss_Loop0B:
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09
	smpsLoop            $00, $02, Snd_MBoss_Loop0B
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nB2, $09, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09

Snd_MBoss_Loop0C:
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09
	smpsLoop            $00, $02, Snd_MBoss_Loop0C
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nB2, $09, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09

Snd_MBoss_Loop0D:
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09
	smpsLoop            $00, $02, Snd_MBoss_Loop0D
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nB2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nB2, $09, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $06, nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nB2, $09, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09

Snd_MBoss_Loop0E:
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09
	smpsLoop            $00, $02, Snd_MBoss_Loop0E

Snd_MBoss_Loop0F:
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nB2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nB2, $09, nRst, $01
	smpsFMAlterVol      $FC
	smpsPan             panCenter, $00
	dc.b	nB2, $04, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nB2, $04, nRst, $06, nBb2, $04, nRst, $01, nBb2, $04, nRst, $06
	dc.b	nA2, $04, nRst, $01, nA2, $04, nRst, $06, nAb2, $04, nRst, $01
	dc.b	nAb2, $04, nRst, $06, nF2, $04, nRst, $01, nB2, $04, nRst, $01
	dc.b	nA2, $04, nRst, $01, nBb2, $04, nRst, $01, nB2, $04, nRst, $01
	dc.b	nB2, $04, nRst, $06, nBb2, $04, nRst, $01, nBb2, $04, nRst, $06
	dc.b	nA2, $04, nRst, $01, nA2, $04, nRst, $06, nAb2, $04, nRst, $01
	dc.b	nAb2, $04, nRst, $06, nB3, $05, nA3, nA3, nG3
	smpsPan             panLeft, $00
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $06, nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09
	smpsLoop            $00, $02, Snd_MBoss_Loop0F
	dc.b	nRst, $01
	smpsPan             panLeft, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nFs2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nFs2, $09, nRst, $01
	smpsPan             panLeft, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09, nRst, $01
	smpsFMAlterVol      $04
	dc.b	nB2, $09, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nB2, $09, nRst, $01
	smpsJump            Snd_MBoss_Jump02

; FM5 Data
Snd_MBoss_FM5:
	smpsSetvoice        $02
	smpsPan             panCenter, $00

Snd_MBoss_Loop02:
	dc.b	nE2, $09, nRst, $01, nE3, $09, nRst, $01, nB2, $09, nRst, $01
	dc.b	nB3, $09, nRst, $01, nBb3, $09, nRst, $0B
	smpsLoop            $00, $02, Snd_MBoss_Loop02

Snd_MBoss_Loop03:
	smpsPan             panRight, $00

Snd_MBoss_Jump01:
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01
	smpsLoop            $00, $02, Snd_MBoss_Loop03

Snd_MBoss_Loop04:
	smpsPan             panRight, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01
	smpsPan             panRight, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nE3, $09, nRst, $01, nEb3, $09, nRst, $01, nD3, $09, nRst, $01
	smpsPan             panRight, $00
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $06, nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01
	smpsPan             panRight, $00
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01
	smpsLoop            $00, $07, Snd_MBoss_Loop04
	smpsPan             panRight, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01
	smpsPan             panRight, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nE3, $09, nRst, $01, nEb3, $09, nRst, $01, nD3, $09, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nE3, $04, nRst, $01, nE3, $04, nRst, $06, nEb3, $04, nRst, $01
	dc.b	nEb3, $04, nRst, $06, nD3, $04, nRst, $01, nD3, $04, nRst, $06
	dc.b	nCs3, $04, nRst, $01, nCs3, $04, nRst, $06, nA2, $04, nRst, $01
	dc.b	nB2, $04, nRst, $01, nD3, $04, nRst, $01, nEb3, $04, nRst, $01
	dc.b	nE3, $04, nRst, $01, nE3, $04, nRst, $06, nEb3, $04, nRst, $01
	dc.b	nEb3, $04, nRst, $06, nD3, $04, nRst, $01, nD3, $04, nRst, $06
	dc.b	nCs3, $04, nRst, $01, nCs3, $04, nRst, $06, nE4, $05, nD4, nD4
	dc.b	nC4

Snd_MBoss_Loop05:
	smpsPan             panRight, $00
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01
	smpsLoop            $00, $02, Snd_MBoss_Loop05
	smpsPan             panRight, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01
	smpsPan             panRight, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nE3, $09, nRst, $01, nEb3, $09, nRst, $01, nD3, $09, nRst, $01
	smpsPan             panCenter, $00
	dc.b	nE3, $04, nRst, $01, nE3, $04, nRst, $06, nEb3, $04, nRst, $01
	dc.b	nEb3, $04, nRst, $06, nD3, $04, nRst, $01, nD3, $04, nRst, $06
	dc.b	nCs3, $04, nRst, $01, nCs3, $04, nRst, $06, nA2, $04, nRst, $01
	dc.b	nB2, $04, nRst, $01, nD3, $04, nRst, $01, nEb3, $04, nRst, $01
	dc.b	nE3, $04, nRst, $01, nE3, $04, nRst, $06, nEb3, $04, nRst, $01
	dc.b	nEb3, $04, nRst, $06, nD3, $04, nRst, $01, nD3, $04, nRst, $06
	dc.b	nCs3, $04, nRst, $01, nCs3, $04, nRst, $06, nE4, $05, nD4, nD4
	dc.b	nC4

Snd_MBoss_Loop06:
	smpsPan             panRight, $00
	dc.b	nE2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01, nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01
	smpsLoop            $00, $02, Snd_MBoss_Loop06
	smpsPan             panRight, $00
	dc.b	nFs2, $04, nRst, $06
	smpsFMAlterVol      $FC
	dc.b	nFs2, $04, nRst, $01, nFs2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nA2, $09, nRst, $01, nBb2, $09, nRst, $01
	smpsPan             panRight, $00
	dc.b	nE2, $04, nRst, $01
	smpsFMAlterVol      $FC
	dc.b	nE2, $04, nRst, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $04
	dc.b	nE3, $09, nRst, $01, nEb3, $09, nRst, $01, nD3, $09, nRst, $01
	smpsPan             panRight, $00
	smpsJump            Snd_MBoss_Jump01

; PSG1 Data
Snd_MBoss_PSG1:
	smpsModSet          $01, $02, $02, $06
	dc.b	nRst, $78

Snd_MBoss_Jump05:
	dc.b	nE2, $50, nEb2, $28, nB1, $14, nBb1, nA1, $50, nAb1, $28, nG1
	dc.b	$14, nEb1, nE1, $7F, smpsNoAttack, $16
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $08
	dc.b	nF1
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, nFs1
	smpsAlterNote       $02
	dc.b	smpsNoAttack, nG1
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nAb1
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, nA1
	smpsAlterNote       $06
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $02
	dc.b	smpsNoAttack, nC2, smpsNoAttack, nCs2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, nEb2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nE2, $6E
	smpsAlterNote       $03
	dc.b	$01
	smpsAlterNote       $FC
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, nCs2
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nC2
	smpsAlterNote       $02
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $06
	dc.b	smpsNoAttack, nBb1
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, nAb1, smpsNoAttack, nG1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nFs1
	smpsAlterNote       $05
	dc.b	smpsNoAttack, nF1
	smpsAlterNote       $00
	dc.b	nRst, $28, nE2, $50, nEb2, $28, nB1, $14, nBb1, nA1, $50, nAb1
	dc.b	$28, nG1, $14, nEb1, nE1, $7F, smpsNoAttack, $17
	smpsAlterNote       $08
	dc.b	nF1, $01
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, nFs1
	smpsAlterNote       $02
	dc.b	smpsNoAttack, nG1
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nAb1
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, nA1
	smpsAlterNote       $06
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $02
	dc.b	smpsNoAttack, nC2, smpsNoAttack, nCs2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, nEb2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nE2, $6E
	smpsAlterNote       $03
	dc.b	$01
	smpsAlterNote       $FC
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, nCs2
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nC2
	smpsAlterNote       $02
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $06
	dc.b	smpsNoAttack, nBb1
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, nAb1, smpsNoAttack, nG1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nFs1
	smpsAlterNote       $05
	dc.b	smpsNoAttack, nF1
	smpsAlterNote       $00
	dc.b	nRst, $7F, nRst, $49, nE1, $46
	smpsAlterNote       $08
	dc.b	nF1, $01
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, nFs1
	smpsAlterNote       $02
	dc.b	smpsNoAttack, nG1
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nAb1
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, nA1
	smpsAlterNote       $06
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $02
	dc.b	smpsNoAttack, nC2, smpsNoAttack, nCs2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, nEb2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nE2, $32
	smpsAlterNote       $03
	dc.b	$01
	smpsAlterNote       $FC
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, nCs2
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nC2
	smpsAlterNote       $02
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $06
	dc.b	smpsNoAttack, nBb1
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, nAb1, smpsNoAttack, nG1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nFs1
	smpsAlterNote       $05
	dc.b	smpsNoAttack, nF1
	smpsAlterNote       $00
	dc.b	nRst, $7F, nRst, $35, nE2, $46
	smpsAlterNote       $04
	dc.b	nF2, $01
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nFs2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG2
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nAb2
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, nA2
	smpsAlterNote       $03
	dc.b	smpsNoAttack, nB2
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nC3, smpsNoAttack, nCs3
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD3
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, nEb3
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nE3, $32
	smpsAlterNote       $01
	dc.b	$01
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nD3, smpsNoAttack, nCs3
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, nC3
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nB2
	smpsAlterNote       $03
	dc.b	smpsNoAttack, nBb2
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, nAb2, smpsNoAttack, nG2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nFs2
	smpsAlterNote       $02
	dc.b	smpsNoAttack, nF2
	smpsAlterNote       $00
	dc.b	nRst, $14
	smpsJump            Snd_MBoss_Jump05

; PSG2 Data
Snd_MBoss_PSG2:
	dc.b	nRst, $08
	smpsModSet          $01, $02, $02, $06
	dc.b	nRst, $70
	smpsAlterNote       $00+2

Snd_MBoss_Jump04:
	dc.b	nRst, $08, nE2, $50, nEb2, $28, nB1, $14, nBb1, nA1, $50, nAb1
	dc.b	$28, nG1, $14, nEb1, nE1, $7F, smpsNoAttack, $17	
	dc.b	$01
	smpsAlterNote       $08+2
	dc.b	smpsNoAttack, nFs1
	smpsAlterNote       $06+2
	dc.b	smpsNoAttack, nG1
	smpsAlterNote       $02+2
	dc.b	smpsNoAttack, nAb1, smpsNoAttack, nA1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nBb1
	smpsAlterNote       $FC+2
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $05+2
	dc.b	smpsNoAttack, nCs2
	smpsAlterNote       $03+2
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $02+2
	dc.b	smpsNoAttack, nEb2
	smpsAlterNote       $00+2
	dc.b	smpsNoAttack, nE2, $6E, nE1, $01, smpsNoAttack, nEb2
	smpsAlterNote       $04+2
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $FB+2
	dc.b	smpsNoAttack, nC2
	smpsAlterNote       $FC+2
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nBb1
	smpsAlterNote       $03+2
	dc.b	smpsNoAttack, nA1
	smpsAlterNote       $07+2
	dc.b	smpsNoAttack, nAb1
	smpsAlterNote       $FB+2
	dc.b	smpsNoAttack, nFs1, smpsNoAttack, nF1
	smpsAlterNote       $00+2
	dc.b	nRst, $28, nE2, $50, nEb2, $28, nB1, $14, nBb1, nA1, $50, nAb1
	dc.b	$28, nG1, $14, nEb1, nE1, $7F, smpsNoAttack, $17, $01
	smpsAlterNote       $08+2
	dc.b	smpsNoAttack, nFs1
	smpsAlterNote       $06+2
	dc.b	smpsNoAttack, nG1
	smpsAlterNote       $02+2
	dc.b	smpsNoAttack, nAb1, smpsNoAttack, nA1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nBb1
	smpsAlterNote       $FC+2
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $05+2
	dc.b	smpsNoAttack, nCs2
	smpsAlterNote       $03+2
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $02+2
	dc.b	smpsNoAttack, nEb2
	smpsAlterNote       $00+2
	dc.b	smpsNoAttack, nE2, $6E, nE1, $01, smpsNoAttack, nEb2
	smpsAlterNote       $04+2
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $FB+2
	dc.b	smpsNoAttack, nC2
	smpsAlterNote       $FC+2
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nBb1
	smpsAlterNote       $03+2
	dc.b	smpsNoAttack, nA1
	smpsAlterNote       $07+2
	dc.b	smpsNoAttack, nAb1
	smpsAlterNote       $FB+2
	dc.b	smpsNoAttack, nFs1, smpsNoAttack, nF1
	smpsAlterNote       $00+2
	dc.b	nRst, $7F, nRst, $49, nE1, $46, $01
	smpsAlterNote       $08+2
	dc.b	smpsNoAttack, nFs1
	smpsAlterNote       $06+2
	dc.b	smpsNoAttack, nG1
	smpsAlterNote       $02+2
	dc.b	smpsNoAttack, nAb1, smpsNoAttack, nA1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nBb1
	smpsAlterNote       $FC+2
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $05+2
	dc.b	smpsNoAttack, nCs2
	smpsAlterNote       $03+2
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $02+2
	dc.b	smpsNoAttack, nEb2
	smpsAlterNote       $00+2
	dc.b	smpsNoAttack, nE2, $32, nE1, $01, smpsNoAttack, nEb2
	smpsAlterNote       $04
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $FB+2
	dc.b	smpsNoAttack, nC2
	smpsAlterNote       $FC+2
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nBb1
	smpsAlterNote       $03+2
	dc.b	smpsNoAttack, nA1
	smpsAlterNote       $07+2
	dc.b	smpsNoAttack, nAb1
	smpsAlterNote       $FB+2
	dc.b	smpsNoAttack, nFs1, smpsNoAttack, nF1
	smpsAlterNote       $00+2
	dc.b	nRst, $7F, nRst, $35, nE2, $46, $01
	smpsAlterNote       $04+2
	dc.b	smpsNoAttack, nFs2
	smpsAlterNote       $02+2
	dc.b	smpsNoAttack, nG2
	smpsAlterNote       $00+2
	dc.b	smpsNoAttack, nAb2
	smpsAlterNote       $01+2
	dc.b	smpsNoAttack, nA2
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nBb2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nB2
	smpsAlterNote       $02+2
	dc.b	smpsNoAttack, nCs3
	smpsAlterNote       $01+2
	dc.b	smpsNoAttack, nD3, smpsNoAttack, nEb3
	smpsAlterNote       $00+2
	dc.b	smpsNoAttack, nE3, $32, nE2, $01, smpsNoAttack, nEb3
	smpsAlterNote       $02+2
	dc.b	smpsNoAttack, nD3
	smpsAlterNote       $FD+2
	dc.b	smpsNoAttack, nC3
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nB2
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nBb2
	smpsAlterNote       $01+2
	dc.b	smpsNoAttack, nA2
	smpsAlterNote       $03+2
	dc.b	smpsNoAttack, nAb2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nFs2, smpsNoAttack, nF2
	smpsAlterNote       $00+2
	dc.b	nRst, $0C
	smpsJump            Snd_MBoss_Jump04

; PSG3 Data
Snd_MBoss_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $01, (nMaxPSG1-$C)&$FF, smpsNoAttack, $08, $0A, $0A, $0A, $14, $0A, $0A, $0A
	dc.b	$0A, $14

Snd_MBoss_Jump03:
	dc.b	(nMaxPSG1-$C)&$FF, $05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	dc.b	$05, $05

Snd_MBoss_Loop1C:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop1C

Snd_MBoss_Loop1D:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop1D
	dc.b	$05, $05

Snd_MBoss_Loop1E:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop1E

Snd_MBoss_Loop1F:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop1F
	dc.b	$05, $05

Snd_MBoss_Loop20:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop20

Snd_MBoss_Loop21:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop21
	dc.b	$05, $05

Snd_MBoss_Loop22:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop22

Snd_MBoss_Loop23:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop23
	dc.b	$05, $05

Snd_MBoss_Loop24:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop24

Snd_MBoss_Loop25:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop25
	dc.b	$05, $05

Snd_MBoss_Loop26:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop26

Snd_MBoss_Loop27:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop27
	dc.b	$05, $05

Snd_MBoss_Loop28:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop28

Snd_MBoss_Loop29:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop29
	dc.b	$05, $05

Snd_MBoss_Loop2A:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop2A

Snd_MBoss_Loop2B:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop2B
	dc.b	$05, $05

Snd_MBoss_Loop2C:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop2C

Snd_MBoss_Loop2D:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop2D
	dc.b	$05, $05

Snd_MBoss_Loop2E:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop2E

Snd_MBoss_Loop2F:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop2F
	dc.b	$05, $05

Snd_MBoss_Loop30:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop30

Snd_MBoss_Loop31:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop31
	dc.b	$05, $05

Snd_MBoss_Loop32:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop32

Snd_MBoss_Loop33:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop33
	dc.b	$05, $05

Snd_MBoss_Loop34:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop34

Snd_MBoss_Loop35:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop35
	dc.b	$05, $05

Snd_MBoss_Loop36:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop36

Snd_MBoss_Loop37:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop37
	dc.b	$05, $05

Snd_MBoss_Loop38:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop38

Snd_MBoss_Loop39:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop39
	dc.b	$05, $05

Snd_MBoss_Loop3A:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop3A
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	dc.b	$05, $0A, $05, $0A, $05, $0F

Snd_MBoss_Loop3B:
	dc.b	$05, $0A
	smpsLoop            $00, $04, Snd_MBoss_Loop3B
	dc.b	$05, $0F, $05, $0A, $05, $0A, $05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	dc.b	$05, $05

Snd_MBoss_Loop3C:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop3C

Snd_MBoss_Loop3D:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop3D
	dc.b	$05, $05

Snd_MBoss_Loop3E:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop3E
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	dc.b	$05, $0A, $05, $0A, $05, $0F

Snd_MBoss_Loop3F:
	dc.b	$05, $0A
	smpsLoop            $00, $04, Snd_MBoss_Loop3F
	dc.b	$05, $0F, $05, $0A, $05, $0A, $05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	dc.b	$05, $05

Snd_MBoss_Loop40:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop40

Snd_MBoss_Loop41:
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsPSGvoice        sTone_01
	smpsLoop            $00, $02, Snd_MBoss_Loop41
	dc.b	$05, $05

Snd_MBoss_Loop42:
	smpsPSGvoice        sTone_04
	dc.b	$05
	smpsPSGvoice        sTone_01
	dc.b	$0A
	smpsLoop            $00, $02, Snd_MBoss_Loop42
	dc.b	$05, $05
	smpsPSGvoice        sTone_04
	dc.b	$0A
	smpsAlterNote       $00
	smpsPSGvoice        sTone_01
	smpsJump            Snd_MBoss_Jump03

Snd_MBoss_Voices:
;	Voice $00
;	$2B
;	$3E, $51, $50, $50, 	$DF, $DF, $1B, $1F, 	$07, $0E, $07, $04
;	$07, $01, $01, $01, 	$54, $55, $F6, $77, 	$1F, $1C, $17, $8C
	smpsVcAlgorithm     $03
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $05, $05, $05, $03
	smpsVcCoarseFreq    $00, $00, $01, $0E
	smpsVcRateScale     $00, $00, $03, $03
	smpsVcAttackRate    $1F, $1B, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $07, $0E, $07
	smpsVcDecayRate2    $01, $01, $01, $07
	smpsVcDecayLevel    $07, $0F, $05, $05
	smpsVcReleaseRate   $07, $06, $05, $04
	smpsVcTotalLevel    $0C, $17, $1C, $1F

;	Voice $01
;	$28
;	$33, $53, $70, $30, 	$DF, $DC, $1F, $1F, 	$14, $05, $01, $01
;	$00, $01, $00, $1D, 	$11, $21, $10, $F8, 	$0E, $1B, $12, $8C
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

;	Voice $02
;	$38
;	$53, $51, $51, $51, 	$DF, $DF, $1F, $1F, 	$07, $0E, $07, $04
;	$04, $03, $03, $08, 	$F7, $31, $71, $67, 	$1B, $11, $10, $8C
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
	smpsVcReleaseRate   $07, $01, $01, $07
	smpsVcTotalLevel    $0C, $10, $11, $1B

;	Voice $03
;	$3D
;	$01, $02, $02, $02, 	$1F, $1D, $9F, $1D, 	$08, $05, $02, $05
;	$00, $08, $08, $08, 	$1F, $1F, $1F, $1F, 	$1A, $9E, $B3, $8C
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $02, $02, $01
	smpsVcRateScale     $00, $02, $00, $00
	smpsVcAttackRate    $1D, $1F, $1D, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $02, $05, $08
	smpsVcDecayRate2    $08, $08, $08, $00
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $0C, $33, $1E, $1A

