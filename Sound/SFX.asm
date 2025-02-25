; ---------------------------------------------------------------------------
; SFX metadata (pointers, priorities, flags)

; Priority of sound. New music or SFX must have a priority higher than or equal
; to what is stored in v_sndprio or it won't play. If bit 7 of new priority is
; set ($80 and up), the new music or SFX will not set its priority -- meaning
; any music or SFX can override it (as long as it can override whatever was
; playing before). Usually, SFX will only override SFX, special SFX ($D0-$DF)
; will only override special SFX and music will only override music.
; Of course, this isn't the case anymore, as priorities no longer apply to
; special SFX or music.
; TODO Maybe I should make it apply to Special SFX, too.
; ---------------------------------------------------------------------------
SoundIndex:
ptr_snd40:	SMPS_SFX_METADATA	Sound40, $70, 0
ptr_snd41:	SMPS_SFX_METADATA	Sound41, $70, 0
ptr_snd42:	SMPS_SFX_METADATA	Sound42, $70, 0
ptr_snd43:	SMPS_SFX_METADATA	Sound43, $70, 0
ptr_snd44:	SMPS_SFX_METADATA	Sound44, $70, 0
ptr_snd45:	SMPS_SFX_METADATA	Sound45, $70, 0
ptr_snd46:	SMPS_SFX_METADATA	Sound46, $70, 0
ptr_snd47:	SMPS_SFX_METADATA	Sound47, $70, 0
ptr_snd48:	SMPS_SFX_METADATA	Sound48, $70, 0
ptr_snd49:	SMPS_SFX_METADATA	Sound49, $70, 0
ptr_snd4A:	SMPS_SFX_METADATA	Sound4A, $70, 0
ptr_snd4B:	SMPS_SFX_METADATA	Sound4B, $70, 0
ptr_snd4C:	SMPS_SFX_METADATA	Sound4C, $70, 0
ptr_snd4D:	SMPS_SFX_METADATA	Sound4D, $70, 0
ptr_snd4E:	SMPS_SFX_METADATA	Sound4E, $70, 0
ptr_snd4F:	SMPS_SFX_METADATA	Sound4F, $70, 0
ptr_snd50:	SMPS_SFX_METADATA	Sound50, $70, 0
ptr_snd51:	SMPS_SFX_METADATA	Sound51, $70, 0
ptr_snd52:	SMPS_SFX_METADATA	Sound52, $70, 0
ptr_snd53:	SMPS_SFX_METADATA	Sound53, $70, 0
ptr_snd54:	SMPS_SFX_METADATA	Sound54, $70, 0
ptr_snd55:	SMPS_SFX_METADATA	Sound55, $70, 0
ptr_snd56:	SMPS_SFX_METADATA	Sound56, $70, 0
ptr_snd57:	SMPS_SFX_METADATA	Sound57, $70, 0
ptr_snd58:	SMPS_SFX_METADATA	Sound58, $70, 0
ptr_snd59:	SMPS_SFX_METADATA	Sound59, $70, 0
ptr_snd5A:	SMPS_SFX_METADATA	Sound5A, $70, 0
ptr_snd5B:	SMPS_SFX_METADATA	Sound5B, $70, 0
ptr_snd5C:	SMPS_SFX_METADATA	Sound5C, $70, 0
ptr_snd5D:	SMPS_SFX_METADATA	Sound5D, $70, 0
ptr_snd5E:	SMPS_SFX_METADATA	Sound5E, $70, 0
ptr_snd5F:	SMPS_SFX_METADATA	Sound5F, $7F, 0
ptr_snd60:	SMPS_SFX_METADATA	Sound60, $70, 0
ptr_snd61:	SMPS_SFX_METADATA	Sound61, $70, 0
ptr_snd62:	SMPS_SFX_METADATA	Sound62, $70, 0
ptr_snd63:	SMPS_SFX_METADATA	Sound63, $70, 0
ptr_snd64:	SMPS_SFX_METADATA	Sound64, $70, 0
ptr_snd65:	SMPS_SFX_METADATA	Sound65, $70, 0
ptr_snd66:	SMPS_SFX_METADATA	Sound66, $70, 0
ptr_snd67:	SMPS_SFX_METADATA	Sound67, $70, 0
ptr_snd68:	SMPS_SFX_METADATA	Sound68, $70, 0
ptr_snd69:	SMPS_SFX_METADATA	Sound69, $70, 0
ptr_snd6A:	SMPS_SFX_METADATA	Sound6A, $70, 0
ptr_snd6B:	SMPS_SFX_METADATA	Sound6B, $70, 0
ptr_snd6C:	SMPS_SFX_METADATA	Sound6C, $70, 0
ptr_snd6D:	SMPS_SFX_METADATA	Sound6D, $70, 0
ptr_snd6E:	SMPS_SFX_METADATA	Sound6E, $70, 0
ptr_snd6F:	SMPS_SFX_METADATA	Sound6F, $70, 0
ptr_snd70:	SMPS_SFX_METADATA	Sound70, $70, 0
ptr_snd71:	SMPS_SFX_METADATA	Sound71, $70, 0
ptr_snd72:	SMPS_SFX_METADATA	Sound72, $70, 0
ptr_snd73:	SMPS_SFX_METADATA	Sound73, $70, 0
ptr_snd74:	SMPS_SFX_METADATA	Sound74, $70, 0
ptr_snd75:	SMPS_SFX_METADATA	Sound75, $70, 0
ptr_snd76:	SMPS_SFX_METADATA	Sound76, $70, 0
ptr_snd77:	SMPS_SFX_METADATA	Sound77, $70, 0
ptr_snd78:	SMPS_SFX_METADATA	Sound78, $70, 0
ptr_snd79:	SMPS_SFX_METADATA	Sound79, $70, 0
ptr_snd7A:	SMPS_SFX_METADATA	Sound7A, $70, 0
ptr_snd7B:	SMPS_SFX_METADATA	Sound7B, $70, 0
ptr_snd7C:	SMPS_SFX_METADATA	Sound7C, $70, 0
ptr_snd7D:	SMPS_SFX_METADATA	Sound7D, $70, 0
ptr_snd7E:	SMPS_SFX_METADATA	Sound7E, $70, 0
ptr_snd7F:	SMPS_SFX_METADATA	Sound7F, $70, 0
ptr_snd80:	SMPS_SFX_METADATA	Sound80, $70, 0
ptr_snd81:	SMPS_SFX_METADATA	Sound81, $70, 0
ptr_snd82:	SMPS_SFX_METADATA	Sound82, $70, 0
ptr_snd83:	SMPS_SFX_METADATA	Sound83, $70, 0
ptr_snd84:	SMPS_SFX_METADATA	Sound84, $70, 0
ptr_snd85:	SMPS_SFX_METADATA	Sound85, $70, 0
ptr_snd86:	SMPS_SFX_METADATA	Sound86, $70, 0
ptr_snd87:	SMPS_SFX_METADATA	Sound87, $70, 0
ptr_snd88:	SMPS_SFX_METADATA	Sound88, $70, 0
ptr_snd89:	SMPS_SFX_METADATA	Sound89, $70, 0
ptr_snd8A:	SMPS_SFX_METADATA	Sound8A, $70, 0
ptr_snd8B:	SMPS_SFX_METADATA	Sound8B, $70, 0
ptr_snd8C:	SMPS_SFX_METADATA	Sound8C, $70, 0
ptr_snd8D:	SMPS_SFX_METADATA	Sound8D, $70, 0
ptr_snd8E:	SMPS_SFX_METADATA	Sound8E, $70, 0
ptr_snd8F:	SMPS_SFX_METADATA	Sound8F, $70, 0
ptr_snd90:	SMPS_SFX_METADATA	Sound90, $70, 0
ptr_snd91:	SMPS_SFX_METADATA	Sound91, $70, 0
ptr_snd92:	SMPS_SFX_METADATA	Sound92, $70, 0
ptr_snd93:	SMPS_SFX_METADATA	Sound93, $70, 0
ptr_snd94:	SMPS_SFX_METADATA	Sound94, $70, 0
ptr_snd95:	SMPS_SFX_METADATA	Sound95, $70, 0
ptr_snd96:	SMPS_SFX_METADATA	Sound96, $70, 0
ptr_snd97:	SMPS_SFX_METADATA	Sound97, $70, 0
ptr_snd98:	SMPS_SFX_METADATA	Sound98, $70, 0

; Continuous
ptr_sndC01:	SMPS_SFX_METADATA	SoundC01, $70, 0
ptr_sndC02:	SMPS_SFX_METADATA	SoundC02, $70, 0
ptr_sndC03:	SMPS_SFX_METADATA	SoundC03, $70, 0
ptr_sndC04:	SMPS_SFX_METADATA	SoundC04, $70, 0
ptr_sndC05:	SMPS_SFX_METADATA	SoundC05, $70, 0
ptr_sndC06:	SMPS_SFX_METADATA	SoundC06, $70, 0

ptr_sndend
; ---------------------------------------------------------------------------
; SFX data ($40-$EF)
; ---------------------------------------------------------------------------

Sound40:	include	"Sound/SFX/Snd40 - Ring.asm"
	even
Sound41:		include	"Sound/SFX/Snd41 - Ring Left Speaker.asm"
	even
Sound42:	include	"Sound/SFX/Snd42 - Ring Loss.asm"
	even
Sound43:	include	"Sound/SFX/Snd43 - Jump.asm"
	even
Sound44:	include	"Sound/SFX/Snd44 - Roll.asm"
	even
Sound45:	include	"Sound/SFX/Snd45 - Skid.asm"
	even
Sound46:	include	"Sound/SFX/Snd46 - Death.asm"
	even
Sound47:	include	"Sound/SFX/Snd47 - SpinDash.asm"
	even
Sound48:	include	"Sound/SFX/Snd48 - Splash.asm"
	even
Sound49:	include	"Sound/SFX/Snd49 - Insta Attack.asm"
	even
Sound4A:	include	"Sound/SFX/Snd4A - Fire Shield.asm"
	even
Sound4B:	include	"Sound/SFX/Snd4B - Buble Shield.asm"
	even
Sound4C:	include	"Sound/SFX/Snd4C - Light Shield.asm"
	even
Sound4D:	include	"Sound/SFX/Snd4D - Fire Attack.asm"
	even
Sound4E:	include	"Sound/SFX/Snd4E - Buble Attack.asm"
	even
Sound4F:	include	"Sound/SFX/Snd4F - Light Attack.asm"
	even
Sound50:	include	"Sound/SFX/Snd50 - Hit Spikes.asm"
	even
Sound51:		include	"Sound/SFX/Snd51 - Spikes Move.asm"
	even
Sound52:	include	"Sound/SFX/Snd52 - Drown Death.asm"
	even
Sound53:	include	"Sound/SFX/Snd53 - Lamppost.asm"
	even
Sound54:	include	"Sound/SFX/Snd54 - Spring.asm"
	even
Sound55:	include	"Sound/SFX/Snd55 - Teleport.asm"
	even
Sound56:	include	"Sound/SFX/Snd56 - Break Item.asm"
	even
Sound57:	include	"Sound/SFX/Snd57 - Hit Boss.asm"
	even
Sound58:	include	"Sound/SFX/Snd58 - Drown Warning.asm"
	even
Sound59:	include	"Sound/SFX/Snd59 - Air.asm"
	even
Sound5A:	include	"Sound/SFX/Snd5A - Bomb.asm"
	even
Sound5B:	include	"Sound/SFX/Snd5B - Signpost.asm"
	even
Sound5C:	include	"Sound/SFX/Snd5C - Switch.asm"
	even
Sound5D:	include	"Sound/SFX/Snd5D - Cash Register.asm"
	even
Sound5E:	include	"Sound/SFX/Snd5E - ScarySignal.asm"
	even
Sound5F:	include	"Sound/SFX/Snd5F - ScarySignal2.asm"
	even
Sound60:	include	"Sound/SFX/Snd60 - Boom.asm"
	even
Sound61:		include	"Sound/SFX/Snd61 - Boom.asm"
	even
Sound62:	include	"Sound/SFX/Snd62 - Wall Smash.asm"
	even
Sound63:	include	"Sound/SFX/Snd63 - Magnet.asm"
	even
Sound64:	include	"Sound/SFX/Snd64 - BreakBridge.asm"
	even
Sound65:	include	"Sound/SFX/Snd65 - Flash.asm"
	even
Sound66:	include	"Sound/SFX/Snd66 - Laser.asm"
	even
Sound67:	include	"Sound/SFX/Snd67 - Laser.asm"
	even
Sound68:	include	"Sound/SFX/Snd68 - Laser.asm"
	even
Sound69:	include	"Sound/SFX/Snd69 - Laser.asm"
	even
Sound6A:	include	"Sound/SFX/Snd6A - Laser.asm"
	even
Sound6B:	include	"Sound/SFX/Snd6B - Squeak.asm"
	even
Sound6C:	include	"Sound/SFX/Snd6C - Emerald.asm"
	even
Sound6D:	include	"Sound/SFX/Snd6D - Bumper.asm"
	even
Sound6E:	include	"Sound/SFX/Snd6E - Fire.asm"
	even
Sound6F:	include	"Sound/SFX/Snd6F - Ghost.asm"
	even
Sound70:	include	"Sound/SFX/Snd70 - Falling.asm"
	even
Sound71:		include	"Sound/SFX/Snd71 - Attachment.asm"
	even
Sound72:	include	"Sound/SFX/Snd72 - Attachment.asm"
	even
Sound73:	include	"Sound/SFX/Snd73 - Signal.asm"
	even
Sound74:	include	"Sound/SFX/Snd74 - Lifting.asm"
	even
Sound75:	include	"Sound/SFX/Snd75 - Descend.asm"
	even
Sound76:	include	"Sound/SFX/Snd76 - Activation.asm"
	even
Sound77:	include	"Sound/SFX/Snd77 - Shaking.asm"
	even
Sound78:	include	"Sound/SFX/Snd78 - Wave.asm"
	even
Sound79:	include	"Sound/SFX/Snd79 - Circular.asm"
	even
Sound7A:	include	"Sound/SFX/Snd7A - Spike.asm"
	even
Sound7B:	include	"Sound/SFX/Snd7B - Laser Start.asm"
	even
Sound7C:	include	"Sound/SFX/Snd7C - Spike Attack.asm"
	even
Sound7D:	include	"Sound/SFX/Snd7D - Wham.asm"
	even
Sound7E:	include	"Sound/SFX/Snd7E - Bumper.asm"
	even
Sound7F:	include	"Sound/SFX/Snd7F - Fire.asm"
	even
Sound80:	include	"Sound/SFX/Snd80 - Spike.asm"
	even
Sound81:		include	"Sound/SFX/Snd81 - Jump.asm"
	even
Sound82:	include	"Sound/SFX/Snd82 - Teleport.asm"
	even
Sound83:	include	"Sound/SFX/Snd83 - Siren.asm"
	even
Sound84:	include	"Sound/SFX/Snd84 - Rotate.asm"
	even
Sound85:	include	"Sound/SFX/Snd85 - Spike Attack.asm"
	even
Sound86:	include	"Sound/SFX/Snd86 - Sega Kick.asm"
	even
Sound87:	include	"Sound/SFX/Snd87 - Sega Present.asm"
	even
Sound88:	include	"Sound/SFX/Snd88 - Electro.asm"
	even
Sound89:	include	"Sound/SFX/Snd89 - Jump.asm"
	even
Sound8A:	include	"Sound/SFX/Snd8A - Arm.asm"
	even
Sound8B:	include	"Sound/SFX/Snd8B - Jump.asm"
	even
Sound8C:	include	"Sound/SFX/Snd8C - Attack.asm"
	even
Sound8D:	include	"Sound/SFX/Snd8D - Death.asm"
	even
Sound8E:	include	"Sound/SFX/Snd8E - Open.asm"
	even
Sound8F:	include	"Sound/SFX/Snd8F - Grab.asm"
	even
Sound90:	include	"Sound/SFX/Snd90 - Trans.asm"
	even
Sound91:		include	"Sound/SFX/Snd91 - Shot.asm"
	even
Sound92:	include	"Sound/SFX/Snd92 - Dialog(Sonic).asm"
	even
Sound93:	include	"Sound/SFX/Snd93 - Dialog(Robotnik).asm"
	even
Sound94:	include	"Sound/SFX/Snd94 - Dialog(Mini Ball).asm"
	even
Sound95:	include	"Sound/SFX/Snd95 - Dialog(Ball).asm"
	even
Sound96:	include	"Sound/SFX/Snd96 - Dialog(Tails).asm"
	even
Sound97:	include	"Sound/SFX/Snd97 - Dialog(Fire Ball).asm"
	even
Sound98:	include	"Sound/SFX/Snd98 - Dialog(Fire Ball2).asm"
	even

; Continuous

SoundC01:	include	"Sound/SFX/Continuous/Snd01 - WindQuiet.asm"
	even
SoundC02:	include	"Sound/SFX/Continuous/Snd02 - WindLoud.asm"
	even
SoundC03:	include	"Sound/SFX/Continuous/Snd03 - LargeShip.asm"
	even
SoundC04:	include	"Sound/SFX/Continuous/Snd04 - Rising.asm"
	even
SoundC05:	include	"Sound/SFX/Continuous/Snd05 - Siren.asm"
	even
SoundC06:	include	"Sound/SFX/Continuous/Snd06 - RiseLoud.asm"
	even