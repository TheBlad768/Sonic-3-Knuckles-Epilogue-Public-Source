Sound_SegaKick_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Sound_SegaKick_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_SegaKick_FM5,	$00, $05

; FM5 Data
Sound_SegaKick_FM5:
	dc.b	nRst, $02
	smpsSetvoice        $00
	smpsModSet          $00, $01, $C0, $FF
	dc.b	nC0, $06
	smpsStop

Sound_SegaKick_Voices:
;	Voice $00
;	$3B
;	$32, $02, $10, $1E, 	$10, $1F, $1F, $12, 	$16, $1E, $19, $1F
;	$03, $0B, $00, $00, 	$0F, $0D, $0F, $0E, 	$18, $01, $00, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $01, $00, $03
	smpsVcCoarseFreq    $0E, $00, $02, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $12, $1F, $1F, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $19, $1E, $16
	smpsVcDecayRate2    $00, $00, $0B, $03
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0E, $0F, $0D, $0F
	smpsVcTotalLevel    $00, $00, $01, $18

