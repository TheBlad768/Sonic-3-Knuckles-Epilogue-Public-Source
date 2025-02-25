Snd_Prologue_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoiceNull
	smpsHeaderChan      $00, $00
	smpsHeaderTempo     $00, $00

	smpsHeaderDAC       Snd_Prologue_DAC
	smpsHeaderFM        Snd_Prologue_FM1,	$00, $00
	smpsHeaderFM        Snd_Prologue_FM2,	$00, $00
	smpsHeaderFM        Snd_Prologue_FM3,	$00, $00
	smpsHeaderFM        Snd_Prologue_FM4,	$00, $00
	smpsHeaderFM        Snd_Prologue_FM5,	$00, $00
	smpsHeaderPSG       Snd_Prologue_PSG1,	$00, $00, $00, $00
	smpsHeaderPSG       Snd_Prologue_PSG2,	$00, $00, $00, $00
	smpsHeaderPSG       Snd_Prologue_PSG3,	$00, $00, $00, $00

; DAC Data
Snd_Prologue_DAC:
; FM1 Data
Snd_Prologue_FM1:
; FM2 Data
Snd_Prologue_FM2:
; FM3 Data
Snd_Prologue_FM3:
; FM4 Data
Snd_Prologue_FM4:
; FM5 Data
Snd_Prologue_FM5:
; PSG1 Data
Snd_Prologue_PSG1:
; PSG2 Data
Snd_Prologue_PSG2:
; PSG3 Data
Snd_Prologue_PSG3:
	smpsStop