Snd_Falling_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Snd_Falling_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $0C

	smpsHeaderDAC       Snd_Falling_DAC
	smpsHeaderFM        Snd_Falling_FM1,	$00, $04
	smpsHeaderFM        Snd_Falling_FM2,	$00, $06
	smpsHeaderFM        Snd_Falling_FM4,	$00, $06
	smpsHeaderFM        Snd_Falling_FM3,	$00, $0D
	smpsHeaderFM        Snd_Falling_FM5,	$00, $06
	smpsHeaderPSG       Snd_Falling_PSG1,	$00, $01, $00, $00
	smpsHeaderPSG       Snd_Falling_PSG2,	$00, $03, $00, $00
	smpsHeaderPSG       Snd_Falling_PSG3,	$00, $01, $00, $00

; DAC Data
Snd_Falling_DAC:
	smpsPan             panCenter, $00

Snd_Falling_Jump00:
	dc.b	$A0, $50, $0D, $50, $6B, dSnare, $07, $06, $07, $07, $06, $07
	dc.b	$A0, $50, $0D, $0E, $42, $6B, dSnare, $07, $06, $07, $07, $06
	dc.b	$07, $A0, $0D, $9E, $0E, $9F, $0D, $A1, $0A, $A2, $A3, $A4

Snd_Falling_Loop00:
	dc.b	dKick, $0D, $07, dSnare, $21, dKick, $07, dSnare, $14
	smpsLoop            $00, $03, Snd_Falling_Loop00
	dc.b	dKick, $0D, $07, dSnare, $21, dKick, $07, dSnare, dSnare, $06, $07, $9B
	dc.b	$0D, dKick

Snd_Falling_Loop01:
	dc.b	$07, dSnare, $21, dKick, $07, dSnare, $14, dKick, $0D
	smpsLoop            $00, $03, Snd_Falling_Loop01
	dc.b	$07, dSnare, dSnare, $06, $07, $07, $06

Snd_Falling_Loop04:
	dc.b	$07, $9B, $0D, dKick

Snd_Falling_Loop02:
	dc.b	$07, dSnare, $21, dKick, $07, dSnare, $14, dKick, $0D
	smpsLoop            $00, $03, Snd_Falling_Loop02
	dc.b	$07, dSnare, $21, dKick, $07, dSnare, dSnare, $06, $07, $9B, $0D, dKick

Snd_Falling_Loop03:
	dc.b	$07, dSnare, $21, dKick, $07, dSnare, $14, dKick, $0D
	smpsLoop            $00, $03, Snd_Falling_Loop03
	dc.b	$07, dSnare, $96, $06, $98, $07, $07, $9A, $06
	smpsLoop            $01, $02, Snd_Falling_Loop04
	dc.b	$07, $9B, $0D, dKick, $07, dSnare, $1B, dKick, $06, $07, dSnare, $14
	dc.b	dKick, $0D, $07, dSnare, $14, $9B, $0D, dKick, $07, dSnare, $1B, dKick
	dc.b	$06, $07, dSnare, $14, dKick, $0D, $07, dSnare, dSnare, $06, $07, $9B
	dc.b	$0D, dKick, $07, dSnare, $1B, dKick, $06, $07, dSnare, $14, dKick, $0D
	dc.b	$07, dSnare, $14, $9B, $0D, dKick, $07, dSnare, $1B, dKick, $06, $07
	dc.b	dSnare, $14, dKick, $07, $96, $06, $98, $07, $07, $9A, $06, $07
	dc.b	$9B, $0D, dKick, $07, dSnare, $1B, dKick, $06, $07, dSnare, $14, dKick
	dc.b	$0D, $07, dSnare, $14, $9B, $0D, dKick, $07, dSnare, $1B, dKick, $06
	dc.b	$07, dSnare, $14, dKick, $0D, $07, dSnare, dSnare, $06, $07, $9B, $0D
	dc.b	dKick, $07, dSnare, $1B, dKick, $06, $07, dSnare, $14, dKick, $0D, $07
	dc.b	dSnare, $14, $9B, $0D, dKick, $07, dSnare, $1B, dKick, $06, $07, dSnare
	dc.b	$14, dKick, $0D, $98, $07, $07, $9A, $06, $07, dSnare, $0A, $32
	dc.b	$0A, dKick, $17, $07, dSnare, $21, dKick, $07, dSnare, dSnare, $06, $07
	dc.b	$A0, $0A, $32, dSnare, $0A, dKick, $17, $07, dSnare, $21, dKick, $07
	dc.b	dSnare, dSnare, $06, $07, $9B, $0D, dKick, $07, dSnare, $21, dKick, $07
	dc.b	dSnare, $14, $9B, $07, dKick, $06, $9A, $07, dKick, $9A, $06, dKick
	dc.b	$07, dSnare, $0D, $98, $07, $07, $9A, $06, $07, $A0, $A0, $06
	dc.b	$0E, $06, $07, $0D, $07, dKick, dSnare, $21, $A0, $07, $06, $0E
	dc.b	$06, $07, $0D, $0E, dSnare, $06, $9B, $0E, $98, $06, $9A, $07
	dc.b	$A0, $A0, $06, $0E, $06, $07, $0D, $07, dKick, $9B, $21, $A0
	dc.b	$07, $06, $0E, $06, $07, $0D, $0E, dSnare, $06, $9B, $07, $98
	dc.b	$9A, $06, dKick, $07
	smpsJump            Snd_Falling_Jump00

; FM1 Data
Snd_Falling_FM1:
	smpsSetvoice        $00
	smpsPan             panCenter, $00

Snd_Falling_Jump05:
	dc.b	nE2, $4D, nRst, $03, nE2, $07, nRst, $06, nE2, $07, nRst, $49
	dc.b	nE2, $6B, nA2, $07, nB2, $06, nD3, $07, nG3, nFs3, $06, nD3
	dc.b	$07, nE2, $4D, nRst, $03, nE2, $07, nRst, $06, nE2, $07, nRst
	dc.b	nE2, $06, nRst, $3C, nE2, $6B, nA2, $07, nB2, $06, nD3, $07
	dc.b	nG3, nFs3, $06, nD3, $07, $0D, nG3, $0E, nFs3, $0D, nD3, $0A
	dc.b	nA2, nG2, nFs2

Snd_Falling_Loop23:
	dc.b	nE2, $0D, $07, nRst, nB2, $03, nRst, nD3, $04, nRst, $03
	smpsLoop            $00, $07, Snd_Falling_Loop23
	dc.b	nA2, nRst, $04, nB2, $03, nRst, nD3, $04, nRst, $03, nG3, nRst
	dc.b	$04, nFs3, $03

Snd_Falling_Loop24:
	dc.b	nRst, nD3, $04, nRst, $03, nE2, $0D, $07, nRst, nB2, $03
	smpsLoop            $00, $06, Snd_Falling_Loop24
	dc.b	nRst, nD3, $04

Snd_Falling_Loop29:
	dc.b	nRst, $03, nE2, $0D, $07, nB2, $03, nRst, $04, nFs3, $03, nRst
	dc.b	nG3, $04, nRst, $03, nA3, nRst, $04, nB3, $03, nRst, nFs3, $04

Snd_Falling_Loop25:
	dc.b	nRst, $03, nC3, $0D, $07, nRst, nG3, $03, nRst, nC3, $04
	smpsLoop            $00, $04, Snd_Falling_Loop25

Snd_Falling_Loop26:
	dc.b	nRst, $03, nE2, $0D, $07, nRst, nB2, $03, nRst, nD3, $04
	smpsLoop            $00, $03, Snd_Falling_Loop26
	dc.b	nRst, $03, nA2, nRst, $04, nB2, $03, nRst, nD3, $04, nRst, $03
	dc.b	nG3, nRst, $04, nFs3, $03, nRst, nD3, $04

Snd_Falling_Loop27:
	dc.b	nRst, $03, nC3, $0D, $07, nRst, nG3, $03, nRst, nC3, $04
	smpsLoop            $00, $04, Snd_Falling_Loop27

Snd_Falling_Loop28:
	dc.b	nRst, $03, nE2, $0D, $07, nRst, nB2, $03, nRst, nD3, $04
	smpsLoop            $00, $02, Snd_Falling_Loop28
	smpsLoop            $01, $02, Snd_Falling_Loop29
	dc.b	nRst, $03, nE2, $0D, $07, nB2, $03, nRst, $04, nFs3, $03, nRst
	dc.b	nG3, $04, nRst, $03, nA3, nRst, $04, nB3, $03, nRst, nFs3, $04

Snd_Falling_Loop2A:
	dc.b	nRst, $03, nC3, $0D, $07, nRst, nG3, $03, nRst, nC3, $04
	smpsLoop            $00, $03, Snd_Falling_Loop2A

Snd_Falling_Loop2B:
	dc.b	nRst, $03, nA2, $0D, $07, nRst, nE3, $03, nRst, nA2, $04
	smpsLoop            $00, $03, Snd_Falling_Loop2B

Snd_Falling_Loop2C:
	dc.b	nRst, $03, nFs2, $0D, $07, nRst, nCs3, $03, nRst, nFs2, $04
	smpsLoop            $00, $03, Snd_Falling_Loop2C

Snd_Falling_Loop2D:
	dc.b	nRst, $03, nB2, $0D, $07, nRst, nFs3, $03, nRst, nB2, $04
	smpsLoop            $00, $03, Snd_Falling_Loop2D
	smpsLoop            $01, $02, Snd_Falling_Loop2A
	dc.b	nRst, $03, nE3, $0A, nC4, nB3, nD3, nFs3, nA2, nB2, nE2, $17
	dc.b	$07, nRst, nB2, $03, nRst, nD3, $04, nRst, $03, nE2, $0D, $07
	dc.b	nRst, nB2, $03, nRst, nD3, $04, nRst, $03, nE3, $0A, nC4, nB3
	dc.b	nD3, nFs3, nA2, nB2, nC3, $17, $07, nRst, nG3, $03, nRst, nC3
	dc.b	$04, nRst, $03, nC3, $0D, $07, nRst, nG3, $03, nRst, nC3, $04

Snd_Falling_Loop2E:
	dc.b	nRst, $03, nB2, $0D, $07, nRst, nFs3, $03, nRst, nA3, $04
	smpsLoop            $00, $02, Snd_Falling_Loop2E
	dc.b	nRst, $03, nC3, $07, nG2, $06, nC3, $07, nD3, nC3, $06, nB2
	dc.b	$07, nA2, nG2, $06, nFs2, $07, nE2, nFs2, $06, nB2, $07, nE2
	dc.b	nE2, $06, $07, nRst, nE2, $06, $07, $07, nRst, $06, nE2, $07
	dc.b	nRst, nBb2, $21, nE2, $07, $06, $07, nRst, nE2, $06, $07, $07
	dc.b	nRst, $06, nE2, $07, nRst, nBb2, $06, nB2, $0E, nBb2, $06, nA2
	dc.b	$07, nE2, nE2, $06, $07, nRst, nE2, $06, $07, $07, nRst, $06
	dc.b	nE2, $07, nRst, nBb2, $21, nE2, $07, $06, $07, nRst, nE2, $06
	dc.b	$07, $07, nRst, $06, nE2, $07, nRst, nBb2, $06, nB2, $07, nBb2
	dc.b	nA2, $0D
	smpsJump            Snd_Falling_Jump05

; FM2 Data
Snd_Falling_FM2:
	smpsModSet			$32,	$01,	$06,	$03
	smpsPan             panCenter, $00

Snd_Falling_Jump04:
	smpsSetvoice        $01
	dc.b	nRst, $78, $78, $78, $78, $78, $78, nE4, $07, nB4, $06, nFs5
	dc.b	$07, nB4, nG5, $06, nFs5, $07, nB4, nB5, $06, nB4, $07, nA5
	dc.b	nG5, $06, nFs5, $07, nE4, nB4, $06, nFs5, $07, nB4, nG5, $06
	dc.b	nFs5, $07, nG5, nA4, $06, nB4, $07, nD5, nE5, $06, nFs5, $07
	dc.b	nE4, nB4, $06, nFs5, $07, nB4, nG5, $06, nFs5, $07, nB4, nB5
	dc.b	$06, nB4, $07, nA5, nG5, $06, nFs5, $07, nE4, nB4, $06, nFs5
	dc.b	$07, nB4, nG5, $06, nFs5, $07, nA5, nG5, $06, nFs5, $07, nD5
	dc.b	nE5, $06, nA4, $07, nE4, nB4, $06, nFs5, $07, nB4, nG5, $06
	dc.b	nFs5, $07, nB4, nB5, $06, nB4, $07, nA5, nG5, $06, nFs5, $07
	dc.b	nE4, nB4, $06, nFs5, $07, nB4, nG5, $06, nFs5, $07, nG5, nA4
	dc.b	$06, nB4, $07, nD5, nE5, $06, nFs5, $07, nE4, nB4, $06, nFs5
	dc.b	$07, nB4, nG5, $06, nFs5, $07, nB4, nB5, $06, nB4, $07, nA5
	dc.b	nG5, $06, nFs5, $07, nE4, nB4, $06, nFs5, $07, nB4, nFs5, $06
	dc.b	nG5, $07, nA5, nB5, $06, nFs5, $07
	smpsSetvoice        $04

Snd_Falling_Loop21:
	smpsAlterNote       $F6
	dc.b	nB5, $05
	smpsAlterNote       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FA
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $3E, nA5, $05, nG5, nFs5, $1B
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, $06
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $FC
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, $03
	smpsAlterNote       $FA
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F9
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F8
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F7
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $F5
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F4
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $F3
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F1
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F0
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $EF
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $EE
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $ED
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $EC
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $EB
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $EA
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $E9
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $E7
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $19
	dc.b	smpsNoAttack, nF5
	smpsAlterNote       $17
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $16
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $14
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $13
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $12
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $10
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $0E
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $0C
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $0A
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $08
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $05
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $03
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	nB4, $0D, nG5, $0E, nFs5, $0D, nE5, nA4, $0E, nG4, $0D, nD5
	dc.b	nFs4, $43
	smpsAlterNote       $F6
	dc.b	nB5, $05
	smpsAlterNote       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FA
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $3E, nA5, $05, nG5, nFs5, $1B
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, $06
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $FC
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, $03
	smpsAlterNote       $FA
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F9
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F8
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F7
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $F5
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F4
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $F3
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F1
	dc.b	smpsNoAttack, $02
	smpsAlterNote       $F0
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $EF
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $EE
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $ED
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $EC
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $EB
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $EA
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $E9
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $E7
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $19
	dc.b	smpsNoAttack, nF5
	smpsAlterNote       $17
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $16
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $14
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $13
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $12
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $10
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $0E
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $0C
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $0A
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $08
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $05
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $03
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	nB4, $0D, nG5, $0E, nFs5, $0D, nE5, nA4, $0E, nG4, $0D, nD5
	dc.b	$07, nE4, $06, nFs4, $07, nG4, nA4, $06, nB4, $07, nC5, nD5
	dc.b	$06, nB4, $07
	smpsLoop            $00, $02, Snd_Falling_Loop21

Snd_Falling_Loop22:
	dc.b	nG5, $02, nA5, $05, nG5, $06, nFs5, $07, nG5, $0D, nFs5, $07
	dc.b	nE5, nB4, $49
	smpsLoop            $00, $02, Snd_Falling_Loop22
	dc.b	nG5, $02, nA5, $05, nG5, $06, nFs5, $07, nG5, $0D, nFs5, $07
	dc.b	nE5, nC5, $49, nG5, $02, nA5, $05, nG5, $06, nFs5, $07, nG5
	dc.b	nFs5, $06, nE5, $07, nB4, nEb5, $0D, nE5, $07, nFs5, $06, nG5
	dc.b	$07, nA5, $0D, nB5, $07, nG5, nFs5, $06, nB4, $07
	smpsLoop            $01, $02, Snd_Falling_Loop22
	dc.b	nE5, $0A, nC6, nB5, nD5, nFs5, nA4, nB4, nE4, $5A, nE5, $0A
	dc.b	nC6, nB5, nD5, nFs5, nA4, nB4, nC5, $39, nD5, $06, nE5, $07
	dc.b	nFs5, nG5, $06, nA5, $07, nB5, $50, nC6, $07, nG5, $06, nC6
	dc.b	$07, nD6, nC6, $06, nB5, $07, nA5, nG5, $06, nFs5, $07, nE5
	dc.b	nB4, $06, nFs4, $07, nRst, $7F, $7F, $7F, $13
	smpsJump            Snd_Falling_Jump04

; FM3 Data
Snd_Falling_FM3:
	smpsPan             panRight, $00
	smpsModSet			$32,	$01,	$07,	$03
	smpsAlterNoteEcho       $0
Snd_Falling_Jump03:
	smpsSetvoice        $01
	dc.b	nRst, $7A, $7A, $7A, $7A, $7A, $7B, nE4, $07, nB4, $06, nFs5
	dc.b	$07, nB4, nG5, $06, nFs5, $07, nB4, nB5, $06, nB4, $07, nA5
	dc.b	nG5, $06, nFs5, $07, nE4, nB4, $06, nFs5, $07, nB4, nG5, $06
	dc.b	nFs5, $07, nG5, nA4, $06, nB4, $07, nD5, nE5, $06, nFs5, $07
	dc.b	nE4, nB4, $06, nFs5, $07, nB4, nG5, $06, nFs5, $07, nB4, nB5
	dc.b	$06, nB4, $07, nA5, nG5, $06, nFs5, $07, nE4, nB4, $06, nFs5
	dc.b	$07, nB4, nG5, $06, nFs5, $07, nA5, nG5, $06, nFs5, $07, nD5
	dc.b	nE5, $06, nA4, $07, nE4, nB4, $06, nFs5, $07, nB4, nG5, $06
	dc.b	nFs5, $07, nB4, nB5, $06, nB4, $07, nA5, nG5, $06, nFs5, $07
	dc.b	nE4, nB4, $06, nFs5, $07, nB4, nG5, $06, nFs5, $07, nG5, nA4
	dc.b	$06, nB4, $07, nD5, nE5, $06, nFs5, $07, nE4, nB4, $06, nFs5
	dc.b	$07, nB4, nG5, $06, nFs5, $07, nB4, nB5, $06, nB4, $07, nA5
	dc.b	nG5, $06, nFs5, $07, nE4, nB4, $06, nFs5, $07, nB4, nFs5, $06
	dc.b	nG5, $07, nA5, nB5, $06, nFs5, $07
	smpsSetvoice        $04
Snd_Falling_Loop1F:
	smpsAlterNoteEcho       $F6
	dc.b	nB5, $05
	smpsAlterNoteEcho       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $FA
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $FD
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $00
	dc.b	smpsNoAttack, $3E, nA5, $05, nG5, nFs5, $1B
	smpsAlterNoteEcho       $FF
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $FE
	dc.b	smpsNoAttack, $06
	smpsAlterNoteEcho       $FD
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $FC
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $FB
	dc.b	smpsNoAttack, $03
	smpsAlterNoteEcho       $FA
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $F9
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $F7
	dc.b	smpsNoAttack, $03
	smpsAlterNoteEcho       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $F5
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $F4
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $F3
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $F1
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $F0
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $EF
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $EE
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $ED
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $EC
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $EB
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $EA
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $E9
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $E7
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $19
	dc.b	smpsNoAttack, nF5
	smpsAlterNoteEcho       $17
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $16
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $14
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $13
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $11
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $10
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $0E
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $0C
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $0A
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $07
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $05
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $03
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $00
	dc.b	nB4, $0D, nG5, $0E, nFs5, $0D, nE5, nA4, $0E, nG4, $0D, nD5
	dc.b	nFs4, $43
	smpsAlterNoteEcho       $F6
	dc.b	nB5, $05
	smpsAlterNoteEcho       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $FA
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $FD
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $00
	dc.b	smpsNoAttack, $3E, nA5, $05, nG5, nFs5, $1B
	smpsAlterNoteEcho       $FF
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $FE
	dc.b	smpsNoAttack, $06
	smpsAlterNoteEcho       $FD
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $FC
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $FB
	dc.b	smpsNoAttack, $03
	smpsAlterNoteEcho       $FA
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $F9
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $F7
	dc.b	smpsNoAttack, $03
	smpsAlterNoteEcho       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $F5
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $F4
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $F3
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $F1
	dc.b	smpsNoAttack, $02
	smpsAlterNoteEcho       $F0
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $EF
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $EE
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $ED
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $EC
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $EB
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $EA
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $E9
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $E7
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $19
	dc.b	smpsNoAttack, nF5
	smpsAlterNoteEcho       $17
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $16
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $14
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $13
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $11
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $10
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $0E
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $0C
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $0A
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $07
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $05
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $03
	dc.b	smpsNoAttack, $01
	smpsAlterNoteEcho       $00
	dc.b	nB4, $0D, nG5, $0E, nFs5, $0D, nE5, nA4, $0E, nG4, $0D, nD5
	dc.b	$07, nE4, $06, nFs4, $07, nG4, nA4, $06, nB4, $07, nC5, nD5
	dc.b	$06, nB4, $07
	smpsLoop            $00, $02, Snd_Falling_Loop1F

Snd_Falling_Loop20:
	dc.b	nG5, $02, nA5, $05, nG5, $06, nFs5, $07, nG5, $0D, nFs5, $07
	dc.b	nE5, nB4, $49
	smpsLoop            $00, $02, Snd_Falling_Loop20
	dc.b	nG5, $02, nA5, $05, nG5, $06, nFs5, $07, nG5, $0D, nFs5, $07
	dc.b	nE5, nC5, $49, nG5, $02, nA5, $05, nG5, $06, nFs5, $07, nG5
	dc.b	nFs5, $06, nE5, $07, nB4, nEb5, $0D, nE5, $07, nFs5, $06, nG5
	dc.b	$07, nA5, $0D, nB5, $07, nG5, nFs5, $06, nB4, $07
	smpsLoop            $01, $02, Snd_Falling_Loop20
	dc.b	nE5, $0A, nC6, nB5, nD5, nFs5, nA4, nB4, nE4, $5A, nE5, $0A
	dc.b	nC6, nB5, nD5, nFs5, nA4, nB4, nC5, $39, nD5, $06, nE5, $07
	dc.b	nFs5, nG5, $06, nA5, $07, nB5, $50, nC6, $07, nG5, $06, nC6
	dc.b	$07, nD6, nC6, $06, nB5, $07, nA5, nG5, $06, nFs5, $07, nE5
	dc.b	nB4, $06, nFs4, $07, nRst, $7F, $7F, $7F, $06
	smpsJump            Snd_Falling_Jump03

; FM4 Data
Snd_Falling_FM4:
	smpsSetvoice        $02
	smpsPan             panCenter, $00

Snd_Falling_Jump02:
	dc.b	nB2, $4D, nRst, $03, nB2, $07, nRst, $06, nB2, $07, nRst, $49
	dc.b	nB2, $7F, smpsNoAttack, $11, nRst, $03, nB2, $4D, nRst, $03, nB2, $07
	dc.b	nRst, $06, nB2, $07, nRst, nB2, $06, nRst, $3C, nB2, $7F, smpsNoAttack
	dc.b	$11, nRst, $53

Snd_Falling_Loop14:
	dc.b	nE2, $0D, $07, $03, nRst, $04, nE2, $03, nRst, nE2, $04, nRst
	dc.b	$03
	smpsLoop            $00, $0F, Snd_Falling_Loop14

Snd_Falling_Loop19:
	dc.b	nE2, nRst, $04, nE2, $03, nRst, nE2, $04

Snd_Falling_Loop15:
	dc.b	nRst, $03, nC2, $0D, $07, $03, nRst, $04, nC2, $03, nRst, nC2
	dc.b	$04
	smpsLoop            $00, $04, Snd_Falling_Loop15

Snd_Falling_Loop16:
	dc.b	nRst, $03, nE2, $0D, $07, $03, nRst, $04, nE2, $03, nRst, nE2
	dc.b	$04
	smpsLoop            $00, $04, Snd_Falling_Loop16

Snd_Falling_Loop17:
	dc.b	nRst, $03, nC2, $0D, $07, $03, nRst, $04, nC2, $03, nRst, nC2
	dc.b	$04
	smpsLoop            $00, $04, Snd_Falling_Loop17

Snd_Falling_Loop18:
	dc.b	nRst, $03, nE2, $0D, $07, $03, nRst, $04, nE2, $03, nRst, nE2
	dc.b	$04
	smpsLoop            $00, $03, Snd_Falling_Loop18
	dc.b	nRst, $03
	smpsLoop            $01, $02, Snd_Falling_Loop19
	dc.b	nE2, nRst, $04, nE2, $03, nRst, nE2, $04

Snd_Falling_Loop1A:
	dc.b	nRst, $03, nC2, $0D, $07, $03, nRst, $04, nC2, $03, nRst, nC2
	dc.b	$04
	smpsLoop            $00, $03, Snd_Falling_Loop1A

Snd_Falling_Loop1B:
	dc.b	nRst, $03, nA2, $0D, $07, $03, nRst, $04, nA2, $03, nRst, nA2
	dc.b	$04
	smpsLoop            $00, $03, Snd_Falling_Loop1B

Snd_Falling_Loop1C:
	dc.b	nRst, $03, nFs2, $0D, $07, $03, nRst, $04, nFs2, $03, nRst, nFs2
	dc.b	$04
	smpsLoop            $00, $03, Snd_Falling_Loop1C

Snd_Falling_Loop1D:
	dc.b	nRst, $03, nB2, $0D, $07, $03, nRst, $04, nB2, $03, nRst, nB2
	dc.b	$04
	smpsLoop            $00, $03, Snd_Falling_Loop1D
	smpsLoop            $01, $02, Snd_Falling_Loop1A
	dc.b	nRst, $03, nE2, $0A, nC3, nB2, nD2, nFs2, nA2, nB2, nE2, $17
	dc.b	$07, $03, nRst, $04, nE2, $03, nRst, nE2, $04, nRst, $03, nE2
	dc.b	$0D, $07, $03, nRst, $04, nE2, $03, nRst, nE2, $04, nRst, $03
	dc.b	nE2, $0A, nC3, nB2, nD2, nFs2, nA2, nB2, nC2, $17, $07, $03
	dc.b	nRst, $04, nC2, $03, nRst, nC2, $04, nRst, $03, nC2, $0D, $07
	dc.b	$03, nRst, $04, nC2, $03, nRst, nC2, $04

Snd_Falling_Loop1E:
	dc.b	nRst, $03, nB2, $0D, $07, $03, nRst, $04, nB2, $03, nRst, nB2
	dc.b	$04
	smpsLoop            $00, $02, Snd_Falling_Loop1E
	dc.b	nRst, $03, nC3, $07, nG2, $06, nC3, $07, nD3, nC3, $06, nB2
	dc.b	$07, nA2, nG2, $06, nFs2, $07, nE2, nRst, $06, nB1, $07, nE2
	dc.b	$03, nRst, $04, nE2, $03, nRst, nE2, $04, nRst, $0A, nE2, $03
	dc.b	nRst, nE2, $04, nRst, $03, nE2, nRst, $0A, nE2, $04, nRst, $0A
	dc.b	nF2, $21, nE2, $03, nRst, $04, nE2, $03, nRst, nE2, $04, nRst
	dc.b	$0A, nE2, $03, nRst, nE2, $04, nRst, $03, nE2, nRst, $0A, nE2
	dc.b	$04, nRst, $0A, nF2, $06, nFs2, $0E, nF2, $06, nE2, $07, $03
	dc.b	nRst, $04, nE2, $03, nRst, nE2, $04, nRst, $0A, nE2, $03, nRst
	dc.b	nE2, $04, nRst, $03, nE2, nRst, $0A, nE2, $04, nRst, $0A, nF2
	dc.b	$21, nE2, $03, nRst, $04, nE2, $03, nRst, nE2, $04, nRst, $0A
	dc.b	nE2, $03, nRst, nE2, $04, nRst, $03, nE2, nRst, $0A, nE2, $04
	dc.b	nRst, $0A, nF2, $06, nFs2, $07, nF2, nE2, $0D
	smpsJump            Snd_Falling_Jump02

; FM5 Data
Snd_Falling_FM5:
	smpsSetvoice        $03
	smpsPan             panCenter, $00

Snd_Falling_Jump01:
	dc.b	nB2, $4C, nRst, $04, nB2, $06, nRst, $07, nB2, $06, nRst, $4A
	dc.b	nB2, $7F, smpsNoAttack, $10, nRst, $04, nB2, $4C, nRst, $04, nB2, $06
	dc.b	nRst, $07, nB2, $06, nRst, $08, nB2, $06, nRst, $3C, nB2, $7F
	dc.b	smpsNoAttack, $10, nRst, $54

Snd_Falling_Loop05:
	dc.b	nB2, $0D, $06, nRst, $01, nE2, $03, nRst, $04, nE2, $02, nRst
	dc.b	$04, nE2, $03, nRst, $04
	smpsLoop            $00, $0F, Snd_Falling_Loop05
	dc.b	nE2, $03, nRst, $04, nE2, $02, nRst, $04, nE2, $03

Snd_Falling_Loop06:
	dc.b	nRst, $04, nG2, $0D, $06, nRst, $01, nC2, $03, nRst, $04, nC2
	dc.b	$02, nRst, $04, nC2, $03
	smpsLoop            $00, $04, Snd_Falling_Loop06

Snd_Falling_Loop07:
	dc.b	nRst, $04, nB2, $0D, $06, nRst, $01, nE2, $03, nRst, $04, nE2
	dc.b	$02, nRst, $04, nE2, $03
	smpsLoop            $00, $04, Snd_Falling_Loop07

Snd_Falling_Loop08:
	dc.b	nRst, $04, nG2, $0D, $06, nRst, $01, nC2, $03, nRst, $04, nC2
	dc.b	$02, nRst, $04, nC2, $03
	smpsLoop            $00, $04, Snd_Falling_Loop08

Snd_Falling_Loop09:
	dc.b	nRst, $04, nB2, $0D, $06, nRst, $01, nE2, $03, nRst, $04, nE2
	dc.b	$02, nRst, $04, nE2, $03
	smpsLoop            $00, $03, Snd_Falling_Loop09
	dc.b	nRst, $04, nE2, $03, nRst, $04, nE2, $02, nRst, $04, nE2, $03

Snd_Falling_Loop0A:
	dc.b	nRst, $04, nG2, $0D, $06, nRst, $01, nC2, $03, nRst, $04, nC2
	dc.b	$02, nRst, $04, nC2, $03
	smpsLoop            $00, $04, Snd_Falling_Loop0A

Snd_Falling_Loop0B:
	dc.b	nRst, $04, nB2, $0D, $06, nRst, $01, nE2, $03, nRst, $04, nE2
	dc.b	$02, nRst, $04, nE2, $03
	smpsLoop            $00, $04, Snd_Falling_Loop0B

Snd_Falling_Loop0C:
	dc.b	nRst, $04, nG2, $0D, $06, nRst, $01, nC2, $03, nRst, $04, nC2
	dc.b	$02, nRst, $04, nC2, $03
	smpsLoop            $00, $04, Snd_Falling_Loop0C

Snd_Falling_Loop0D:
	dc.b	nRst, $04, nB2, $0D, $06, nRst, $01, nE2, $03, nRst, $04, nE2
	dc.b	$02, nRst, $04, nE2, $03
	smpsLoop            $00, $02, Snd_Falling_Loop0D
	dc.b	nRst, $04, nB2, $0D, nE2, $06, nRst, $01

Snd_Falling_Loop0E:
	dc.b	nE2, $03, nRst, $04, nE2, $02, nRst, $04, nE2, $03, nRst, $04
	smpsLoop            $00, $02, Snd_Falling_Loop0E

Snd_Falling_Loop0F:
	dc.b	nG2, $0D, $06, nRst, $01, nC2, $03, nRst, $04, nC2, $02, nRst
	dc.b	$04, nC2, $03, nRst, $04
	smpsLoop            $00, $03, Snd_Falling_Loop0F

Snd_Falling_Loop10:
	dc.b	nA2, $0D, $06, nRst, $01, nA2, $03, nRst, $04, nA2, $02, nRst
	dc.b	$04, nA2, $03, nRst, $04
	smpsLoop            $00, $03, Snd_Falling_Loop10

Snd_Falling_Loop11:
	dc.b	nCs3, $0D, $06, nRst, $01, nFs2, $03, nRst, $04, nFs2, $02, nRst
	dc.b	$04, nFs2, $03, nRst, $04
	smpsLoop            $00, $03, Snd_Falling_Loop11

Snd_Falling_Loop12:
	dc.b	nB2, $0D, $06, nRst, $01, nB2, $03, nRst, $04, nB2, $02, nRst
	dc.b	$04, nB2, $03, nRst, $04
	smpsLoop            $00, $03, Snd_Falling_Loop12
	smpsLoop            $01, $02, Snd_Falling_Loop0F
	dc.b	nE2, $09, nRst, $01, nC3, $09, nRst, $01, nB2, $09, nRst, $01
	dc.b	nD2, $09, nRst, $01, nFs2, $09, nRst, $01, nA2, $09, nRst, $01
	dc.b	nB2, $09, nRst, $01, nB2, $17, $06, nRst, $01, nE2, $03, nRst
	dc.b	$04, nE2, $02, nRst, $04, nE2, $03, nRst, $04, nB2, $0D, $06
	dc.b	nRst, $01, nE2, $03, nRst, $04, nE2, $02, nRst, $04, nE2, $03
	dc.b	nRst, $04, nE2, $09, nRst, $01, nC3, $09, nRst, $01, nB2, $09
	dc.b	nRst, $01, nD2, $09, nRst, $01, nFs2, $09, nRst, $01, nA2, $09
	dc.b	nRst, $01, nB2, $09, nRst, $01, nG2, $17, $06, nRst, $01, nC2
	dc.b	$03, nRst, $04, nC2, $02, nRst, $04, nC2, $03, nRst, $04, nG2
	dc.b	$0D, $06, nRst, $01, nC2, $03, nRst, $04, nC2, $02, nRst, $04
	dc.b	nC2, $03

Snd_Falling_Loop13:
	dc.b	nRst, $04, nB2, $0D, $06, nRst, $01, nB2, $03, nRst, $04, nB2
	dc.b	$02, nRst, $04, nB2, $03
	smpsLoop            $00, $02, Snd_Falling_Loop13
	dc.b	nRst, $04, nC3, $06, nRst, $01, nG2, $06, nC3, nRst, $01, nD3
	dc.b	$06, nRst, $01, nC3, $06, nB2, nRst, $01, nA2, $06, nRst, $01
	dc.b	nG2, $06, nFs2, nRst, $01, nE2, $06, nRst, $01, nB2, $06, nB1
	dc.b	nRst, $01, nE2, $03, nRst, $04, nE2, $02, nRst, $04, nE2, $03
	dc.b	nRst, $0B, nE2, $02, nRst, $04, nE2, $03, nRst, $04, nE2, $03
	dc.b	nRst, $0A, nE2, $03, nRst, $0B, nF2, $20, nRst, $01, nE2, $03
	dc.b	nRst, $04, nE2, $02, nRst, $04, nE2, $03, nRst, $0B, nE2, $02
	dc.b	nRst, $04, nE2, $03, nRst, $04, nE2, $03, nRst, $0A, nE2, $03
	dc.b	nRst, $0B, nF2, $06, nFs2, $0D, nRst, $01, nF2, $06, nE2, nRst
	dc.b	$01, nE2, $03, nRst, $04, nE2, $02, nRst, $04, nE2, $03, nRst
	dc.b	$0B, nE2, $02, nRst, $04, nE2, $03, nRst, $04, nE2, $03, nRst
	dc.b	$0A, nE2, $03, nRst, $0B, nF2, $20, nRst, $01, nE2, $03, nRst
	dc.b	$04, nE2, $02, nRst, $04, nE2, $03, nRst, $0B, nE2, $02, nRst
	dc.b	$04, nE2, $03, nRst, $04, nE2, $03, nRst, $0A, nE2, $03, nRst
	dc.b	$0B, nF2, $06, nFs2, nRst, $01, nF2, $06, nRst, $01, nE2, $0C
	dc.b	nRst, $01
	smpsJump            Snd_Falling_Jump01

; PSG1 Data
Snd_Falling_PSG1:
	smpsPSGvoice        $07
	dc.b	nE1, $07, nB1, $06, nFs2, $07, nB1, nG2, $06, nFs2, $07, nB1
	dc.b	nB2, $06, nB1, $07, nA2, nG2, $06, nFs2, $07, nE1, nB1, $06
	dc.b	nFs2, $07, nB1, nG2, $06, nFs2, $07, nG2, nA1, $06, nB1, $07
	dc.b	nD2, nE2, $06, nFs2, $07, nE1, nB1, $06, nFs2, $07, nB1, nG2
	dc.b	$06, nFs2, $07, nB1, nB2, $06, nB1, $07, nA2, nG2, $06, nFs2
	dc.b	$07, nE1, nB1, $06, nFs2, $07, nB1, nG2, $06, nFs2, $07, nA2
	dc.b	nG2, $06, nFs2, $07, nD2, nE2, $06, nA1, $07, nE1, nB1, $06
	dc.b	nFs2, $07, nB1, nG2, $06, nFs2, $07, nB1, nB2, $06, nB1, $07
	dc.b	nA2, nG2, $06, nFs2, $07, nE1, nB1, $06, nFs2, $07, nB1, nG2
	dc.b	$06, nFs2, $07, nG2, nA1, $06, nB1, $07, nD2, nE2, $06, nFs2
	dc.b	$07, nE1, nB1, $06, nFs2, $07, nB1, nG2, $06, nFs2, $07, nB1
	dc.b	nB2, $06, nB1, $07, nA2, nG2, $06, nFs2, $07, nE1, nB1, $06
	dc.b	nFs2, $07, nB1, nG2, $06, nFs2, $07, nB2, nA2, $06, nG2, $07
	dc.b	nA2, nG2, $06, nFs2, $07, nD2, $0A, nRst, $03, nG2, $0A, nRst
	dc.b	$04, nFs2, $0A, nRst, $03, nD2, $07, nRst, $03, nA1, $07, nRst
	dc.b	$03, nG1, $07, nRst, $03, nFs1, $07, nRst, $03

Snd_Falling_Loop3A:
	dc.b	nE1, $07, nB1, $06, nFs2, $07, nB1, nG2, $06, nFs2, $07, nB1
	dc.b	nB2, $06, nB1, $07, nA2, nG2, $06, nFs2, $07, nE1, nB1, $06
	dc.b	nFs2, $07, nB1, nG2, $06, nFs2, $07, nG2, nA1, $06, nB1, $07
	dc.b	nD2, nE2, $06, nFs2, $07, nE1, nB1, $06, nFs2, $07, nB1, nG2
	dc.b	$06, nFs2, $07, nB1, nB2, $06, nB1, $07, nA2, nG2, $06, nFs2
	dc.b	$07, nE1, nB1, $06, nFs2, $07, nB1, nG2, $06, nFs2, $07, nA2
	dc.b	nG2, $06, nFs2, $07, nD2, nE2, $06, nA1, $07, nE1, nB1, $06
	dc.b	nFs2, $07, nB1, nG2, $06, nFs2, $07, nB1, nB2, $06, nB1, $07
	dc.b	nA2, nG2, $06, nFs2, $07, nE1, nB1, $06, nFs2, $07, nB1, nG2
	dc.b	$06, nFs2, $07, nG2, nA1, $06, nB1, $07, nD2, nE2, $06, nFs2
	dc.b	$07, nE1, nB1, $06, nFs2, $07, nB1, nG2, $06, nFs2, $07, nB1
	dc.b	nB2, $06, nB1, $07, nA2, nG2, $06, nFs2, $07, nE1, nB1, $06
	dc.b	nFs2, $07, nB1, nFs2, $06, nG2, $07, nA2, nB2, $06, nFs2, $07
	smpsLoop            $00, $03, Snd_Falling_Loop3A

Snd_Falling_Loop3B:
	dc.b	nC2, nG1, $06, nC2, $07, nD2, nG1, $06, nD2, $07, nE2, nG1
	dc.b	$06, nE2, $07, nD2, nC2, $06, nB1, $07, nC2, nG1, $06, nC2
	dc.b	$07, nB1, nA1, $06, nG1, $07
	smpsLoop            $00, $02, Snd_Falling_Loop3B
	dc.b	nC2, nFs1, $06, nC2, $07, nD2, nFs1, $06, nD2, $07, nE2, nFs1
	dc.b	$06, nE2, $07, nD2, nC2, $06, nB1, $07, nC2, nFs1, $06, nC2
	dc.b	$07, nB1, nA1, $06, nFs1, $07, nB1, nFs1, $06, nB1, $07, nCs2
	dc.b	nFs1, $06, nCs2, $07, nEb2, nFs1, $06, nEb2, $07, nCs2, nB1, $06
	dc.b	nBb1, $07, nB1, nFs1, $06, nB1, $07, nBb1, nAb1, $06, nFs1, $07
	smpsLoop            $01, $02, Snd_Falling_Loop3B
	dc.b	nE2, $0A, nC3, nB2, nD2, nFs2, nA1, nB1, nE1, $5A, nE2, $0A
	dc.b	nC3, nB2, nD2, nFs2, nA1, nB1, nC2, $39, nD2, $06, nE2, $07
	dc.b	nFs2, nG2, $06, nA2, $07, nB2, $50, nC3, $07, nG2, $06, nC3
	dc.b	$07, nD3, nC3, $06, nB2, $07, nA2, nG2, $06, nFs2, $07, nE2
	dc.b	nB1, $06, nFs1, $07, nE1, nB1, $06, nE1, $07, nB1, nC2, $06
	dc.b	nE1, $07, nE2, nB1, $06, nG2, $07, nB1, nBb1, $06, nE1, $07
	dc.b	nC2, nE1, $06, nC2, $07, nE1, nB1, $06, nE1, $07, nB1, nC2
	dc.b	$06, nE1, $07, nE2, nB1, $06, nG2, $07, nB1, nBb1, $06, nB1
	dc.b	$0E, nBb1, $06, nA1, $07, nE1, nB1, $06, nE1, $07, nB1, nC2
	dc.b	$06, nE1, $07, nE2, nB1, $06, nG2, $07, nB1, nBb1, $06, nE1
	dc.b	$07, nC2, nE1, $06, nC2, $07, nE1, nB1, $06, nE1, $07, nB1
	dc.b	nC2, $06, nE1, $07, nE2, nB1, $06, nG2, $07, nB1, nBb1, $06
	dc.b	nB1, $07, nBb1, nA1, $0D
	smpsJump            Snd_Falling_PSG1

; PSG2 Data
Snd_Falling_PSG2:
	smpsPSGvoice        $07
	dc.b	nRst, $08
	smpsAlterNote       $01
	dc.b	nE1, $07, nB1, nFs2, $06, nB1, $07, nG2, nFs2, $06, nB1, $07
	dc.b	nB2, nB1, $06, nA2, $07, nG2, nFs2, $06, nE1, $07, nB1, nFs2
	dc.b	$06, nB1, $07, nG2, nFs2, $06, nG2, $07, nA1, nB1, $06, nD2
	dc.b	$07, nE2, nFs2, $06, nE1, $07, nB1, nFs2, $06, nB1, $07, nG2
	dc.b	nFs2, $06, nB1, $07, nB2, nB1, $06, nA2, $07, nG2, nFs2, $06
	dc.b	nE1, $07, nB1, nFs2, $06, nB1, $07, nG2, nFs2, $06, nA2, $07
	dc.b	nG2, nFs2, $06, nD2, $07, nE2, nA1, $06, nE1, $07, nB1, nFs2
	dc.b	$06, nB1, $07, nG2, nFs2, $06, nB1, $07, nB2, nB1, $06, nA2
	dc.b	$07, nG2, nFs2, $06, nE1, $07, nB1, nFs2, $06, nB1, $07, nG2
	dc.b	nFs2, $06, nG2, $07, nA1, nB1, $06, nD2, $07, nE2, nFs2, $06
	dc.b	nE1, $07, nB1, nFs2, $06, nB1, $07, nG2, nFs2, $06, nB1, $07
	dc.b	nB2, nB1, $06, nA2, $07, nG2, nFs2, $06, nE1, $07, nB1, nFs2
	dc.b	$06, nB1, $07, nG2, nFs2, $06, nB2, $07, nA2, nG2, $06, nA2
	dc.b	$07, nG2, nFs2, $06, nD2, $0A, nRst, $04, nG2, $0A, nRst, $03
	dc.b	nFs2, $0A, nRst, $03, nD2, $07, nRst, $03, nA1, $07, nRst, $03
	dc.b	nG1, $07, nRst, $03, nFs1, $07, nRst, $03

Snd_Falling_Loop38:
	dc.b	nE1, $07, nB1, nFs2, $06, nB1, $07, nG2, nFs2, $06, nB1, $07
	dc.b	nB2, nB1, $06, nA2, $07, nG2, nFs2, $06, nE1, $07, nB1, nFs2
	dc.b	$06, nB1, $07, nG2, nFs2, $06, nG2, $07, nA1, nB1, $06, nD2
	dc.b	$07, nE2, nFs2, $06, nE1, $07, nB1, nFs2, $06, nB1, $07, nG2
	dc.b	nFs2, $06, nB1, $07, nB2, nB1, $06, nA2, $07, nG2, nFs2, $06
	dc.b	nE1, $07, nB1, nFs2, $06, nB1, $07, nG2, nFs2, $06, nA2, $07
	dc.b	nG2, nFs2, $06, nD2, $07, nE2, nA1, $06, nE1, $07, nB1, nFs2
	dc.b	$06, nB1, $07, nG2, nFs2, $06, nB1, $07, nB2, nB1, $06, nA2
	dc.b	$07, nG2, nFs2, $06, nE1, $07, nB1, nFs2, $06, nB1, $07, nG2
	dc.b	nFs2, $06, nG2, $07, nA1, nB1, $06, nD2, $07, nE2, nFs2, $06
	dc.b	nE1, $07, nB1, nFs2, $06, nB1, $07, nG2, nFs2, $06, nB1, $07
	dc.b	nB2, nB1, $06, nA2, $07, nG2, nFs2, $06, nE1, $07, nB1, nFs2
	dc.b	$06, nB1, $07, nFs2, nG2, $06, nA2, $07, nB2, nFs2, $06
	smpsLoop            $00, $03, Snd_Falling_Loop38

Snd_Falling_Loop39:
	dc.b	nC2, $07, nG1, nC2, $06, nD2, $07, nG1, nD2, $06, nE2, $07
	dc.b	nG1, nE2, $06, nD2, $07, nC2, nB1, $06, nC2, $07, nG1, nC2
	dc.b	$06, nB1, $07, nA1, nG1, $06
	smpsLoop            $00, $02, Snd_Falling_Loop39
	dc.b	nC2, $07, nFs1, nC2, $06, nD2, $07, nFs1, nD2, $06, nE2, $07
	dc.b	nFs1, nE2, $06, nD2, $07, nC2, nB1, $06, nC2, $07, nFs1, nC2
	dc.b	$06, nB1, $07, nA1, nFs1, $06, nB1, $07, nFs1, nB1, $06, nCs2
	dc.b	$07, nFs1, nCs2, $06, nEb2, $07, nFs1, nEb2, $06, nCs2, $07, nB1
	dc.b	nBb1, $06, nB1, $07, nFs1, nB1, $06, nBb1, $07, nAb1, nFs1, $06
	smpsLoop            $01, $02, Snd_Falling_Loop39
	dc.b	nE2, $0A, nC3, nB2, nD2, nFs2, nA1, nB1, nE1, $5A, nE2, $0A
	dc.b	nC3, nB2, nD2, nFs2, nA1, nB1, nC2, $39, nD2, $07, nE2, $06
	dc.b	nFs2, $07, nG2, nA2, $06, nB2, $50, nC3, $07, nG2, nC3, $06
	dc.b	nD3, $07, nC3, nB2, $06, nA2, $07, nG2, nFs2, $06, nE2, $07
	dc.b	nB1, nFs1, $06, nE1, $07, nB1, nE1, $06, nB1, $07, nC2, nE1
	dc.b	$06, nE2, $07, nB1, nG2, $06, nB1, $07, nBb1, nE1, $06, nC2
	dc.b	$07, nE1, nC2, $06, nE1, $07, nB1, nE1, $06, nB1, $07, nC2
	dc.b	nE1, $06, nE2, $07, nB1, nG2, $06, nB1, $07, nBb1, nB1, $0D
	dc.b	nBb1, $07, nA1, $06, nE1, $07, nB1, nE1, $06, nB1, $07, nC2
	dc.b	nE1, $06, nE2, $07, nB1, nG2, $06, nB1, $07, nBb1, nE1, $06
	dc.b	nC2, $07, nE1, nC2, $06, nE1, $07, nB1, nE1, $06, nB1, $07
	dc.b	nC2, nE1, $06, nE2, $07, nB1, nG2, $06, nB1, $07, nBb1, nB1
	dc.b	$06, nBb1, $07, nA1, $05
	smpsJump            Snd_Falling_PSG2

; PSG3 Data
Snd_Falling_PSG3:
	smpsPSGform         $E7

Snd_Falling_Jump06:
	dc.b	nRst

Snd_Falling_Loop2F:
	dc.b	$4A
	smpsLoop            $00, $0A, Snd_Falling_Loop2F
	smpsPSGvoice        fTone_01
	dc.b	nMaxPSG

Snd_Falling_Loop30:
	dc.b	$14
	smpsLoop            $00, $0E, Snd_Falling_Loop30

Snd_Falling_Loop32:
	dc.b	$28

Snd_Falling_Loop31:
	dc.b	$14
	smpsLoop            $00, $0D, Snd_Falling_Loop31
	smpsLoop            $01, $02, Snd_Falling_Loop32
	dc.b	$14, $28

Snd_Falling_Loop33:
	dc.b	$14
	smpsLoop            $00, $0B, Snd_Falling_Loop33
	dc.b	$50

Snd_Falling_Loop34:
	dc.b	$14
	smpsLoop            $00, $0E, Snd_Falling_Loop34
	dc.b	$28

Snd_Falling_Loop35:
	dc.b	$14
	smpsLoop            $00, $0B, Snd_Falling_Loop35

Snd_Falling_Loop37:
	dc.b	$50

Snd_Falling_Loop36:
	dc.b	$14, $14, $14, $14, $28
	smpsLoop            $00, $03, Snd_Falling_Loop36
	dc.b	$14, $14
	smpsLoop            $01, $02, Snd_Falling_Loop37
	dc.b	$7F, smpsNoAttack, $21, $14, $14, $78, $14, $14, $28, $14, $14, $7F
	dc.b	smpsNoAttack, $7F, smpsNoAttack, $7F, smpsNoAttack, $77
	smpsJump            Snd_Falling_Jump06

Snd_Falling_Voices:
;	Voice $00
;	$2B
;	$3E, $51, $50, $50, 	$DF, $DF, $1B, $1F, 	$07, $0E, $07, $04
;	$07, $01, $01, $01, 	$54, $55, $F6, $77, 	$1F, $1C, $17, $0C
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
	smpsVcTotalLevel    $0D, $17, $1C, $1F

;	Voice $01
;	$3D
;	$71, $62, $51, $01, 	$14, $0F, $0E, $0F, 	$00, $03, $04, $04
;	$00, $00, $00, $00, 	$00, $16, $16, $16, 	$1B, $10, $10, $10
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $05, $06, $07
	smpsVcCoarseFreq    $01, $01, $02, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0F, $0E, $0F, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $04, $03, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $01, $01, $00
	smpsVcReleaseRate   $06, $06, $06, $00
	smpsVcTotalLevel    $11, $11, $11, $1B

;	Voice $02
;	$28
;	$33, $53, $70, $30, 	$DF, $DC, $1F, $1F, 	$14, $05, $01, $01
;	$00, $01, $00, $1D, 	$11, $21, $10, $F7, 	$0E, $1B, $12, $0C
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
	smpsVcReleaseRate   $07, $00, $01, $01
	smpsVcTotalLevel    $0B, $12, $1B, $0E

;	Voice $03
;	$38
;	$53, $51, $51, $51, 	$DF, $DF, $1F, $1F, 	$07, $0E, $07, $04
;	$04, $03, $03, $08, 	$F7, $31, $71, $67, 	$1B, $11, $10, $0C
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
	smpsVcTotalLevel    $0B, $10, $11, $1B

;	Voice $04
;	$3A
;	$32, $01, $02, $01, 	$10, $13, $10, $1B, 	$00, $00, $00, $00
;	$09, $08, $08, $00, 	$F6, $F6, $F6, $26, 	$16, $14, $18, $0C
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $07
	smpsVcCoarseFreq    $01, $02, $01, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1B, $10, $13, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $08, $08, $09
	smpsVcDecayLevel    $02, $0F, $0F, $0F
	smpsVcReleaseRate   $06, $06, $06, $06
	smpsVcTotalLevel    $04, $18, $14, $16

