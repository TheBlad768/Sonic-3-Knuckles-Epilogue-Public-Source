Snd_TitleScreen_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Snd_TitleScreen_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $0F

	smpsHeaderDAC       Snd_TitleScreen_DAC
	smpsHeaderFM        Snd_TitleScreen_FM1,	$00, $04
	smpsHeaderFM        Snd_TitleScreen_FM2,	$00, $04
	smpsHeaderFM        Snd_TitleScreen_FM3,	$00, $04
	smpsHeaderFM        Snd_TitleScreen_FM4,	$00, $04
	smpsHeaderFM        Snd_TitleScreen_FM5,	$00, $0A
	smpsHeaderPSG       Snd_TitleScreen_PSG1,	$00, $02, $00, $00
	smpsHeaderPSG       Snd_TitleScreen_PSG2,	$00, $04, $00, $00
	smpsHeaderPSG       Snd_TitleScreen_PSG3,	$00, $02, $00, fTone_02

; DAC Data
Snd_TitleScreen_DAC:
	smpsPan             panCenter, $00
	dc.b	nRst, $18, dSnare

Snd_TitleScreen_Loop00:
	dc.b	$03
	smpsLoop            $00, $08, Snd_TitleScreen_Loop00

Snd_TitleScreen_Loop02:
	dc.b	$8F, $0C

Snd_TitleScreen_Loop01:
	dc.b	dSnare, dKick
	smpsLoop            $00, $0F, Snd_TitleScreen_Loop01
	dc.b	dSnare
	smpsLoop            $01, $02, Snd_TitleScreen_Loop02
	dc.b	$8F

Snd_TitleScreen_Loop03:
	dc.b	dSnare, dKick
	smpsLoop            $00, $0B, Snd_TitleScreen_Loop03
	dc.b	dSnare, $8F, $18, $18, $0C, $0C, $0C, dSnare, $03, $03, $03, $03
	dc.b	$8F

Snd_TitleScreen_Loop04:
	dc.b	$09, dKick, dKick, $06, dSnare, $0C, dKick, $03, $03, $06
	smpsLoop            $00, $08, Snd_TitleScreen_Loop04
	dc.b	$8F

Snd_TitleScreen_Loop05:
	dc.b	$09, dKick, dKick, $06, dSnare, $0C, dKick, $03, $03, $06
	smpsLoop            $00, $07, Snd_TitleScreen_Loop05
	dc.b	dSnare, dKick, $03, $03, dSnare, $06, dKick, $03, $03, $97, $97, $97
	dc.b	$97, $97, $97, $98, $98, dKick, $24, $03, $03, dSnare, $06
	smpsStop

; FM1 Data
Snd_TitleScreen_FM1:
	smpsSetvoice        $00
	smpsPan             panCenter, $00
	dc.b	nRst, $30, nD3

Snd_TitleScreen_Loop29:
	dc.b	$03, nRst, nD3, nD3
	smpsLoop            $00, $07, Snd_TitleScreen_Loop29
	dc.b	nD3, nD4, $02, nRst, $01, nD3, $03, $03
	smpsLoop            $01, $05, Snd_TitleScreen_Loop29

Snd_TitleScreen_Loop2A:
	dc.b	nC3, nRst, nC3, nC3
	smpsLoop            $00, $07, Snd_TitleScreen_Loop2A
	dc.b	nC3, nC4, $02, nRst, $01, nC3, $03

Snd_TitleScreen_Loop2B:
	dc.b	$03, nBb2, nRst, nBb2
	smpsLoop            $00, $07, Snd_TitleScreen_Loop2B
	dc.b	nBb2, nBb2, nBb3, $02, nRst, $01, nBb2, $03

Snd_TitleScreen_Loop2C:
	dc.b	$03, nA2, nRst, nA2
	smpsLoop            $00, $07, Snd_TitleScreen_Loop2C
	dc.b	nA2, nA2, nA3, $02, nRst, $01, nA2, $03

Snd_TitleScreen_Loop2D:
	dc.b	$03, nD3, nRst, nD3
	smpsLoop            $00, $07, Snd_TitleScreen_Loop2D
	dc.b	nD3, nD3, nD4, $02, nRst, $01, nD3, $03

Snd_TitleScreen_Loop2E:
	dc.b	$03, nC3, nRst, nC3
	smpsLoop            $00, $07, Snd_TitleScreen_Loop2E
	dc.b	nC3, nC3, nC4, $02, nRst, $01, nC3, $03

Snd_TitleScreen_Loop2F:
	dc.b	$03, nBb2, nRst, nBb2
	smpsLoop            $00, $07, Snd_TitleScreen_Loop2F
	dc.b	nBb2, nBb2, nBb3, $02, nRst, $01, nBb2, $03

Snd_TitleScreen_Loop30:
	dc.b	$03, nA2, nRst, nA2
	smpsLoop            $00, $07, Snd_TitleScreen_Loop30
	dc.b	nA2, nA2, nA3, $02, nRst, $01, nA2, $03, $03

Snd_TitleScreen_Loop31:
	dc.b	nD3, $06, nRst, nD3, nC3, nD3, nRst, nD3, nC3, nBb2, nRst, nA2
	dc.b	nBb2, nC3, nA2, nBb2, nA2, nG2, nRst, nG2, nF2, nG2, nRst, nG2
	dc.b	nA2, nG2, nRst, nG2, nF2, nG2, nA2, nBb2, nA2, nD3, nRst, nD3
	dc.b	nC3, nD3, nRst, nD3, nC3, nBb2, nRst, nA2, nBb2, nC3, nA2, nBb2
	dc.b	nA2, nG2, nRst, nG2, nF2, nG2, nRst, nG2, nA2, nG3, nG2, $03
	dc.b	nG3, $06, nG2, $03, nG3, $06, nG2, nA2, nBb2, nA2
	smpsLoop            $00, $02, Snd_TitleScreen_Loop31
	dc.b	nD2, $30
	smpsStop

; FM2 Data
Snd_TitleScreen_FM2:
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	dc.b	nRst, $01, smpsNoAttack, nG4, smpsNoAttack, nC5, smpsNoAttack, nCs5, smpsNoAttack, nC5, $02, smpsNoAttack
	dc.b	nB4, smpsNoAttack, nBb4, smpsNoAttack, nA4, smpsNoAttack, nAb4, smpsNoAttack, nG4, smpsNoAttack, nFs4, smpsNoAttack
	dc.b	nF4, $01, smpsNoAttack, nE4, $02, smpsNoAttack, nEb4, smpsNoAttack, nD4, smpsNoAttack, nCs4, smpsNoAttack
	dc.b	nC4, smpsNoAttack, nB3, smpsNoAttack, nBb3, smpsNoAttack, nA3, $01, smpsNoAttack, nAb3, $02, smpsNoAttack
	dc.b	nG3, smpsNoAttack, nFs3, smpsNoAttack, nF3, smpsNoAttack, nE3, smpsNoAttack, nEb3, smpsNoAttack, nD3

Snd_TitleScreen_Loop26:
	dc.b	nD5, $03, nA4, nF4
	smpsLoop            $00, $05, Snd_TitleScreen_Loop26
	dc.b	nA4
	smpsLoop            $01, $03, Snd_TitleScreen_Loop26

Snd_TitleScreen_Loop27:
	dc.b	nD5, nA4, nF4
	smpsLoop            $00, $04, Snd_TitleScreen_Loop27
	dc.b	smpsNoAttack, nD4, $01, smpsNoAttack, nCs4, smpsNoAttack, nC4, smpsNoAttack, nB3, smpsNoAttack, nBb3, smpsNoAttack
	dc.b	nA3, smpsNoAttack, nAb3, smpsNoAttack, nFs3, smpsNoAttack, nF3, smpsNoAttack, nE3, smpsNoAttack, nEb3, smpsNoAttack
	dc.b	nD3, nD5, $03, nA4, nF4, nD4, nC5, nA4, nF4, nD4, nD5, nA4
	dc.b	nF4, nD4, nG5, nA4, nF4, nD4, nD5, nD4, nF4, nD4, nA4, nD4
	dc.b	nD5, nD4, nE5, nD4, nF5, nD4, nE5, nD5, nA4, nD4, nA5, nF5
	dc.b	nD5, nF5, nD5, nA4, nD5, nA4, nF4, nA4, nF4, nD4, nA3, nF3
	dc.b	nD3, nA2, nF2, nA2, nD3, nF3, nA3, nD4, nF4, nA4, nD4, nA3
	dc.b	nD4, nF4, nA4, nD5, nF5, nA5, nD6, nRst, $7F, $7F, $7F
	smpsSetvoice        $04
	smpsPan             panCenter, $00
	dc.b	nA4, $60, nG4, nF4, nE4

Snd_TitleScreen_Loop28:
	smpsAlterVol        $F7
	dc.b	nA4, $03, nRst, nA4, nRst, nA4, nRst, $1B
	smpsAlterVol        $01
	dc.b	nA4, $03, nRst
	smpsAlterVol        $FF
	dc.b	nF4, nRst, nF4, nRst, nF4, nRst, $15, nF4, $0C, nG4, $03, nRst
	dc.b	nG4, nRst, nG4, nRst, $21, nG4, $03, nRst, nG4, nRst, nG4, nRst
	dc.b	$15
	smpsAlterVol        $01
	dc.b	nG4, $03, nRst, nG4, nRst
	smpsAlterVol        $FF
	smpsLoop            $00, $03, Snd_TitleScreen_Loop28
	dc.b	nA4, nRst, nA4, nRst, nA4, nRst, $1B
	smpsAlterVol        $01
	dc.b	nA4, $03, nRst
	smpsAlterVol        $FF
	dc.b	nF4, nRst, nF4, nRst, nF4, nRst, $15, nF4, $0C, nG4, $03, nRst
	dc.b	nG4, nRst, nG4, nRst, $21, nG4, $03, nRst, nG4, nRst, nG4, nRst
	dc.b	$15
	smpsAlterVol        $01
	dc.b	nG4, $0C
	smpsStop

; FM3 Data
Snd_TitleScreen_FM3:
	smpsSetvoice        $01

Snd_TitleScreen_Jump00:
	dc.b	nRst, $01, smpsNoAttack, nG3, smpsNoAttack, nC4, smpsNoAttack, nCs4, smpsNoAttack, nC4, $02, smpsNoAttack
	dc.b	nB3, smpsNoAttack, nBb3, smpsNoAttack, nA3, smpsNoAttack, nAb3, smpsNoAttack, nG3, smpsNoAttack, nFs3, smpsNoAttack
	dc.b	nF3, $01, smpsNoAttack, nE3, $02, smpsNoAttack, nEb3, smpsNoAttack, nD3, smpsNoAttack, nCs3, smpsNoAttack
	dc.b	nC3, smpsNoAttack, nB2, smpsNoAttack, nBb2, smpsNoAttack, nA2, $01, smpsNoAttack, nAb2, $02, smpsNoAttack
	dc.b	nG2, smpsNoAttack, nFs2, smpsNoAttack, nF2, smpsNoAttack, nE2, smpsNoAttack, nEb2, nRst, nD2

Snd_TitleScreen_Loop09:
	dc.b	nRst, $01, nD2, $02
	smpsLoop            $00, $03, Snd_TitleScreen_Loop09
	dc.b	nRst, $01

Snd_TitleScreen_Loop0D:
	dc.b	nG2, $06

Snd_TitleScreen_Loop0A:
	dc.b	nD2, $02, nRst, $01
	smpsLoop            $00, $06, Snd_TitleScreen_Loop0A
	dc.b	nA2, $06

Snd_TitleScreen_Loop0B:
	dc.b	nD2, $02, nRst, $01
	smpsLoop            $00, $04, Snd_TitleScreen_Loop0B
	dc.b	nBb2, $06, nD2, $02, nRst, $01, nD2, $02, nRst, $01, nA2, $06
	dc.b	nD2, $02, nRst, $01, nD2, $02, nRst, $01, nG2, $06, nA2

Snd_TitleScreen_Loop0C:
	dc.b	nD2, $02, nRst, $01
	smpsLoop            $00, $06, Snd_TitleScreen_Loop0C
	smpsLoop            $01, $04, Snd_TitleScreen_Loop0D
	dc.b	nG2, $06

Snd_TitleScreen_Loop0E:
	dc.b	nD2, $02, nRst, $01
	smpsLoop            $00, $06, Snd_TitleScreen_Loop0E
	dc.b	nA2, $06

Snd_TitleScreen_Loop0F:
	dc.b	nD2, $02, nRst, $01
	smpsLoop            $00, $04, Snd_TitleScreen_Loop0F
	dc.b	nBb2, $06, nD2, $02, nRst, $01, nD2, $02, nRst, $01, nA2, $06
	dc.b	nD2, $02, nRst, $01, nD2, $02, nRst, $01, nG2, $06, nA2, nD2
	dc.b	$02, nRst, $01, nD2, $02

Snd_TitleScreen_Loop10:
	dc.b	nRst, $01, nC2, $02
	smpsLoop            $00, $04, Snd_TitleScreen_Loop10
	dc.b	nRst, $01, nG2, $06

Snd_TitleScreen_Loop11:
	dc.b	nC2, $02, nRst, $01
	smpsLoop            $00, $06, Snd_TitleScreen_Loop11
	dc.b	nA2, $06

Snd_TitleScreen_Loop12:
	dc.b	nC2, $02, nRst, $01
	smpsLoop            $00, $04, Snd_TitleScreen_Loop12
	dc.b	nBb2, $06, nC2, $02, nRst, $01, nC2, $02, nRst, $01, nA2, $06
	dc.b	nC2, $02, nRst, $01, nC2, $02, nRst, $01, nG2, $06, nA2, nC2
	dc.b	$02, nRst, $01, nC2, $02

Snd_TitleScreen_Loop13:
	dc.b	nRst, $01, nBb1, $02
	smpsLoop            $00, $04, Snd_TitleScreen_Loop13
	dc.b	nRst, $01, nG2, $06

Snd_TitleScreen_Loop14:
	dc.b	nBb1, $02, nRst, $01
	smpsLoop            $00, $06, Snd_TitleScreen_Loop14
	dc.b	nA2, $06

Snd_TitleScreen_Loop15:
	dc.b	nBb1, $02, nRst, $01
	smpsLoop            $00, $04, Snd_TitleScreen_Loop15
	dc.b	nBb2, $06, nBb1, $02, nRst, $01, nBb1, $02, nRst, $01, nA2, $06
	dc.b	nBb1, $02, nRst, $01, nBb1, $02, nRst, $01, nG2, $06, nA2, nBb1
	dc.b	$02, nRst, $01, nBb1, $02

Snd_TitleScreen_Loop16:
	dc.b	nRst, $01, nA1, $02
	smpsLoop            $00, $04, Snd_TitleScreen_Loop16
	dc.b	nRst, $01, nG2, $06

Snd_TitleScreen_Loop17:
	dc.b	nA1, $02, nRst, $01
	smpsLoop            $00, $06, Snd_TitleScreen_Loop17
	dc.b	nA2, $06

Snd_TitleScreen_Loop18:
	dc.b	nA1, $02, nRst, $01
	smpsLoop            $00, $04, Snd_TitleScreen_Loop18
	dc.b	nBb2, $06, nA1, $02, nRst, $01, nA1, $02, nRst, $01, nA2, $06
	dc.b	nA1, $02, nRst, $01, nA1, $02, nRst, $01, nG2, $06, nA2, nA1
	dc.b	$02, nRst, $01, nA1, $02

Snd_TitleScreen_Loop19:
	dc.b	nRst, $01, nD2, $02
	smpsLoop            $00, $04, Snd_TitleScreen_Loop19
	dc.b	nRst, $01, nG2, $06

Snd_TitleScreen_Loop1A:
	dc.b	nD2, $02, nRst, $01
	smpsLoop            $00, $06, Snd_TitleScreen_Loop1A
	dc.b	nA2, $06

Snd_TitleScreen_Loop1B:
	dc.b	nD2, $02, nRst, $01
	smpsLoop            $00, $04, Snd_TitleScreen_Loop1B
	dc.b	nBb2, $06, nD2, $02, nRst, $01, nD2, $02, nRst, $01, nA2, $06
	dc.b	nD2, $02, nRst, $01, nD2, $02, nRst, $01, nG2, $06, nA2, nD2
	dc.b	$02, nRst, $01, nD2, $02

Snd_TitleScreen_Loop1C:
	dc.b	nRst, $01, nC2, $02
	smpsLoop            $00, $04, Snd_TitleScreen_Loop1C
	dc.b	nRst, $01, nG2, $06

Snd_TitleScreen_Loop1D:
	dc.b	nC2, $02, nRst, $01
	smpsLoop            $00, $06, Snd_TitleScreen_Loop1D
	dc.b	nA2, $06

Snd_TitleScreen_Loop1E:
	dc.b	nC2, $02, nRst, $01
	smpsLoop            $00, $04, Snd_TitleScreen_Loop1E
	dc.b	nBb2, $06, nC2, $02, nRst, $01, nC2, $02, nRst, $01, nA2, $06
	dc.b	nC2, $02, nRst, $01, nC2, $02, nRst, $01, nG2, $06, nA2, nC2
	dc.b	$02, nRst, $01, nC2, $02

Snd_TitleScreen_Loop1F:
	dc.b	nRst, $01, nBb1, $02
	smpsLoop            $00, $04, Snd_TitleScreen_Loop1F
	dc.b	nRst, $01, nG2, $06

Snd_TitleScreen_Loop20:
	dc.b	nBb1, $02, nRst, $01
	smpsLoop            $00, $06, Snd_TitleScreen_Loop20
	dc.b	nA2, $06

Snd_TitleScreen_Loop21:
	dc.b	nBb1, $02, nRst, $01
	smpsLoop            $00, $04, Snd_TitleScreen_Loop21
	dc.b	nBb2, $06, nBb1, $02, nRst, $01, nBb1, $02, nRst, $01, nA2, $06
	dc.b	nBb1, $02, nRst, $01, nBb1, $02, nRst, $01, nG2, $06, nA2, nBb1
	dc.b	$02, nRst, $01, nBb1, $02

Snd_TitleScreen_Loop22:
	dc.b	nRst, $01, nA1, $02
	smpsLoop            $00, $04, Snd_TitleScreen_Loop22
	dc.b	nRst, $01, nG2, $06

Snd_TitleScreen_Loop23:
	dc.b	nA1, $02, nRst, $01
	smpsLoop            $00, $06, Snd_TitleScreen_Loop23
	dc.b	nA2, $06

Snd_TitleScreen_Loop24:
	dc.b	nA1, $02, nRst, $01
	smpsLoop            $00, $04, Snd_TitleScreen_Loop24
	dc.b	nBb2, $06, nA1, $02, nRst, $01, nA1, $02, nRst, $01, nA2, $06
	dc.b	nA1, $02, nRst, $01, nA1, $02, nRst, $01, nG2, $06, nA2, nA1
	dc.b	$02, nRst, $01, nA1, $02, nRst, $01
	smpsAlterVol        $01

Snd_TitleScreen_Loop25:
	dc.b	nD2, $06, nRst, nD2, nC2, nD2, nRst, nD2, nC2, nBb1, nRst, nA1
	dc.b	nBb1, nC2, nA1, nBb1, nA1, nG1, nRst, nG1, nF1, nG1, nRst, nG1
	dc.b	nA1, nG1, nRst, nG1, nF1, nG1, nA1, nBb1, nA1
	smpsLoop            $00, $04, Snd_TitleScreen_Loop25
	smpsAlterVol        $FF
	dc.b	nD2, $30
	smpsStop

; FM4 Data
Snd_TitleScreen_FM4:
	smpsSetvoice        $03
	smpsPan             panCenter, $00
	smpsAlterNote       $FA
	smpsJump            Snd_TitleScreen_Jump00

; FM5 Data
Snd_TitleScreen_FM5:
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	dc.b	nRst, $04
	smpsAlterNote       $F6
	dc.b	smpsNoAttack, nD4, $01, smpsNoAttack, nBb4, smpsNoAttack, nCs5, $02, smpsNoAttack, nC5, smpsNoAttack, nB4
	dc.b	smpsNoAttack, nBb4, smpsNoAttack, nA4, $01, smpsNoAttack, nAb4, $02, smpsNoAttack, nG4, smpsNoAttack, nFs4
	dc.b	smpsNoAttack, nF4, smpsNoAttack, nE4, smpsNoAttack, nEb4, smpsNoAttack, nD4, smpsNoAttack, nCs4, $01, smpsNoAttack
	dc.b	nC4, $02, smpsNoAttack, nB3, smpsNoAttack, nBb3, smpsNoAttack, nA3, smpsNoAttack, nAb3, smpsNoAttack, nG3
	dc.b	smpsNoAttack, nFs3, smpsNoAttack, nF3, $01, smpsNoAttack, nE3, $02, smpsNoAttack, nEb3, smpsNoAttack, nD3
	dc.b	nRst, $01

Snd_TitleScreen_Loop06:
	dc.b	nD5, $03, nA4, nF4
	smpsLoop            $00, $05, Snd_TitleScreen_Loop06
	dc.b	nA4
	smpsLoop            $01, $03, Snd_TitleScreen_Loop06

Snd_TitleScreen_Loop07:
	dc.b	nD5, nA4, nF4
	smpsLoop            $00, $04, Snd_TitleScreen_Loop07
	dc.b	smpsNoAttack, nCs4, $01, smpsNoAttack, nC4, smpsNoAttack, nB3, smpsNoAttack, nBb3, smpsNoAttack, nA3, smpsNoAttack
	dc.b	nAb3, smpsNoAttack, nG3, smpsNoAttack, nFs3, smpsNoAttack, nF3, smpsNoAttack, nE3, smpsNoAttack, nEb3, smpsNoAttack
	dc.b	nD3, nD5, $03, nA4, nF4, nD4, nC5, nA4, nF4, nD4, nD5, nA4
	dc.b	nF4, nD4, nG5, nA4, nF4, nD4, nD5, nD4, nF4, nD4, nA4, nD4
	dc.b	nD5, nD4, nE5, nD4, nF5, nD4, nE5, nD5, nA4, nD4, nA5, nF5
	dc.b	nD5, nF5, nD5, nA4, nD5, nA4, nF4, nA4, nF4, nD4, nA3, nF3
	dc.b	nD3, nA2, nF2, nA2, nD3, nF3, nA3, nD4, nF4, nA4, nD4, nA3
	dc.b	nD4, nF4, nA4, nD5, nF5, nA5, nD6, nRst, $7F, $7F, $7B
	smpsSetvoice        $05
	smpsAlterNote       $00
	smpsAlterVol        $F9
	smpsPan             panCenter, $00
	dc.b	nF4, $60, nE4, nD4, nC4

Snd_TitleScreen_Loop08:
	smpsAlterVol        $F7
	dc.b	nF4, $03, nRst, nF4, nRst, nF4, nRst, $1B
	smpsAlterVol        $01
	dc.b	nF4, $03, nRst
	smpsAlterVol        $FF
	dc.b	nD4, nRst, nD4, nRst, nD4, nRst, $15, nD4, $0C, $03, nRst, nD4
	dc.b	nRst, nD4, nRst, $21, nE4, $03, nRst, nE4, nRst, nE4, nRst, $15
	smpsAlterVol        $01
	dc.b	nE4, $03, nRst, nE4, nRst
	smpsAlterVol        $FF
	smpsLoop            $00, $03, Snd_TitleScreen_Loop08
	dc.b	nF4, nRst, nF4, nRst, nF4, nRst, $1B
	smpsAlterVol        $01
	dc.b	nF4, $03, nRst
	smpsAlterVol        $FF
	dc.b	nD4, nRst, nD4, nRst, nD4, nRst, $15, nD4, $0C, $03, nRst, nD4
	dc.b	nRst, nD4, nRst, $21, nE4, $03, nRst, nE4, nRst, nE4, nRst, $15
	smpsAlterVol        $01
	dc.b	nE4, $0C
	smpsStop

; PSG1 Data
Snd_TitleScreen_PSG1:
	dc.b	nRst, $30
	smpsModSet          $00, $02, $02, $02
	dc.b	nD0, $3F, nEb0, $03, nE0, nF0, nFs0, nG0, nAb0, nA0, nBb0, nB0
	dc.b	nC1, nCs1, nD1, $48, nRst, $18, nD1, $3F, nEb1, $03, nE1, nF1
	dc.b	nFs1, nG1, nAb1, nA1, nBb1, nB1, nC2, nCs2, nD2, $54, smpsNoAttack, nCs2
	dc.b	$01, smpsNoAttack, nC2, smpsNoAttack, nB1, smpsNoAttack, nBb1, smpsNoAttack, nA1, smpsNoAttack, nAb1, smpsNoAttack
	dc.b	nG1, smpsNoAttack, nFs1, smpsNoAttack, nF1, smpsNoAttack, nE1, smpsNoAttack, nEb1, smpsNoAttack, nD1

Snd_TitleScreen_Loop37:
	dc.b	nD2, $09, nC2, nD2, nF2, nE2, $06, nF2
	smpsLoop            $00, $02, Snd_TitleScreen_Loop37
	dc.b	nE2, $0C, nD2, $06, nE2, nD2, nF2, $0C, nG2, $06, nE2, $19
	smpsAlterNote       $02
	dc.b	smpsNoAttack, $07
	smpsAlterNote       $04
	dc.b	smpsNoAttack, $08
	smpsAlterNote       $06
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $00
	dc.b	nRst, $06, nC2, $09, nBb1, nG1, nBb1, nA1, $06, nD2, nC2, $09
	dc.b	nBb1, nG1, nBb1, nA1, $06, nC2, nG1, nRst, nG1, nE1, $0C, nG1
	dc.b	$06, nRst, nA1, nG1, nRst, nG1, nE1, $0C, nG1, $06, nA1, nBb1

Snd_TitleScreen_Loop38:
	dc.b	nD2, $09, nC2, nD2, nF2, nE2, $06, nF2
	smpsLoop            $00, $02, Snd_TitleScreen_Loop38
	dc.b	nE2, $0C, nD2, $06, nE2, nD2, nF2, $0C, nG2, $06, nE2, $2A
	dc.b	nRst, $06, nC2, $09, nBb1, nG1, nBb1, nA1, $06, nD2, nC2, $09
	dc.b	nBb1, nG1, nBb1, nA1, $06, nC2, nG1, nRst, nG1, nE1, $0C, nG1
	dc.b	$06, nA1, nBb1, nG1, nRst, nG1, nA1, nBb1, nA1, nBb1, nC2

Snd_TitleScreen_Loop39:
	dc.b	nD2, $12, nC2, $06, nD2, $0C, nF2, nD2, nRst, $06, nF2, nD2
	dc.b	nF2, nD2, nBb1, nD2, $0C, nRst, $06, nF2, nE2, nF2, $0C, nD2
	dc.b	$06, nE2, $0C, nRst, $06, nE2, nF2, nG2, nA2, nG2
	smpsLoop            $00, $03, Snd_TitleScreen_Loop39
	dc.b	nD2, $12, nC2, $06, nD2, $0C, nF2, nD2, nRst, $06, nD2, nF2
	dc.b	nD2, nBb1, nF2, nBb1, $0C, nRst, $06, nBb1, nA1, nG1, $0C, nA1
	dc.b	$06, nD1, $03, nF1, nA1, nD2, nF2, nA2, nD3, nF3, nA3, nF3
	dc.b	nD3, nA2, nF2, nD2, nA1, nF1
	smpsStop

; PSG2 Data
Snd_TitleScreen_PSG2:
	dc.b	nRst, $34
	smpsAlterNote       $03
	smpsModSet          $00, $02, $02, $02
	dc.b	nD0, $3F, nEb0, $03, nE0, nF0, nFs0, nG0, nAb0, nA0, nBb0, nB0
	dc.b	nC1, nCs1, nD1, $48, nRst, $18, nD1, $3F, nEb1, $03, nE1, nF1
	dc.b	nFs1, nG1, nAb1, nA1, nBb1, nB1, nC2, nCs2, nD2, $54, smpsNoAttack, nCs2
	dc.b	$01, smpsNoAttack, nC2, smpsNoAttack, nB1, smpsNoAttack, nBb1, smpsNoAttack, nA1, smpsNoAttack, nAb1, smpsNoAttack
	dc.b	nG1, smpsNoAttack, nFs1, smpsNoAttack, nF1, smpsNoAttack, nE1, smpsNoAttack, nEb1, smpsNoAttack, nD1

Snd_TitleScreen_Loop34:
	dc.b	nD2, $09, nC2, nD2, nF2, nE2, $06, nF2
	smpsLoop            $00, $02, Snd_TitleScreen_Loop34
	dc.b	nE2, $0C, nD2, $06, nE2, nD2, nF2, $0C, nG2, $06, nE2, $18
	smpsAlterNote       $05
	dc.b	smpsNoAttack, $08
	smpsAlterNote       $07
	dc.b	smpsNoAttack, $08
	smpsAlterNote       $09
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $03
	dc.b	nRst, $06, nC2, $09, nBb1, nG1, nBb1, nA1, $06, nD2, nC2, $09
	dc.b	nBb1, nG1, nBb1, nA1, $06, nC2, nG1, nRst, nG1, nE1, $0C, nG1
	dc.b	$06, nRst, nA1, nG1, nRst, nG1, nE1, $0C, nG1, $06, nA1, nBb1

Snd_TitleScreen_Loop35:
	dc.b	nD2, $09, nC2, nD2, nF2, nE2, $06, nF2
	smpsLoop            $00, $02, Snd_TitleScreen_Loop35
	dc.b	nE2, $0C, nD2, $06, nE2, nD2, nF2, $0C, nG2, $06, nE2, $2A
	dc.b	nRst, $06, nC2, $09, nBb1, nG1, nBb1, nA1, $06, nD2, nC2, $09
	dc.b	nBb1, nG1, nBb1, nA1, $06, nC2, nG1, nRst, nG1, nE1, $0C, nG1
	dc.b	$06, nA1, nBb1, nG1, nRst, nG1, nA1, nBb1, nA1, nBb1, nC2

Snd_TitleScreen_Loop36:
	dc.b	nD2, $12, nC2, $06, nD2, $0C, nF2, nD2, nRst, $06, nF2, nD2
	dc.b	nF2, nD2, nBb1, nD2, $0C, nRst, $06, nF2, nE2, nF2, $0C, nD2
	dc.b	$06, nE2, $0C, nRst, $06, nE2, nF2, nG2, nA2, nG2
	smpsLoop            $00, $03, Snd_TitleScreen_Loop36
	dc.b	nD2, $12, nC2, $06, nD2, $0C, nF2, nD2, nRst, $06, nD2, nF2
	dc.b	nD2, nBb1, nF2, nBb1, $0C, nRst, $06, nBb1, nA1, nG1, $0C, nA1
	dc.b	$06, nD1, $03, nF1, nA1, nD2, nF2, nA2, nD3, nF3, nA3, nF3
	dc.b	nD3, nA2, nF2, nD2, nA1, nF1
	smpsStop

; PSG3 Data
Snd_TitleScreen_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $30, nMaxPSG

Snd_TitleScreen_Loop32:
	dc.b	$03, $03, $06
	smpsLoop            $00, $58, Snd_TitleScreen_Loop32
	dc.b	$03, $15, $03, $15, $03, $09, $03, $09, $03, $09, $03, $03
	dc.b	$03, $03
	smpsPSGvoice        fTone_01

Snd_TitleScreen_Loop33:
	dc.b	$0C
	smpsLoop            $00, $3B, Snd_TitleScreen_Loop33
	dc.b	$6C
	smpsStop

Snd_TitleScreen_Voices:
;	Voice $00
;	$2B
;	$3E, $51, $50, $50, 	$DF, $DF, $1B, $1F, 	$07, $0E, $07, $04
;	$07, $01, $01, $01, 	$54, $55, $F6, $72, 	$1F, $1C, $17, $0E
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
	smpsVcReleaseRate   $02, $06, $05, $04
	smpsVcTotalLevel    $0E, $17, $1C, $1F

;	Voice $01
;	$28
;	$33, $53, $70, $30, 	$DF, $DC, $1F, $1F, 	$14, $05, $01, $01
;	$00, $01, $00, $1D, 	$11, $21, $10, $F8, 	$0E, $1B, $12, $10
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
	smpsVcTotalLevel    $10, $12, $1B, $0E

;	Voice $02
;	$3A
;	$32, $01, $02, $01, 	$10, $13, $10, $1B, 	$00, $00, $00, $00
;	$09, $08, $08, $00, 	$F7, $F7, $F7, $27, 	$16, $14, $18, $0C
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $03
	smpsVcCoarseFreq    $01, $02, $01, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1B, $10, $13, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $08, $08, $09
	smpsVcDecayLevel    $02, $0F, $0F, $0F
	smpsVcReleaseRate   $07, $07, $07, $07
	smpsVcTotalLevel    $0C, $18, $14, $16

;	Voice $03
;	$38
;	$53, $51, $51, $51, 	$DF, $DF, $1F, $1F, 	$07, $0E, $07, $04
;	$04, $03, $03, $08, 	$F7, $31, $71, $69, 	$1B, $11, $10, $10
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
	smpsVcTotalLevel    $10, $10, $11, $1B

;	Voice $04
;	$38
;	$58, $54, $31, $31, 	$1A, $1A, $14, $13, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$07, $07, $07, $07, 	$1C, $26, $20, $0E
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
	smpsVcReleaseRate   $07, $07, $07, $07
	smpsVcTotalLevel    $0E, $20, $26, $1C

;	Voice $05
;	$38
;	$58, $54, $31, $31, 	$1A, $1A, $14, $13, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$07, $07, $07, $07, 	$1C, $26, $20, $0A
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
	smpsVcReleaseRate   $07, $07, $07, $07
	smpsVcTotalLevel    $0A, $20, $26, $1C

