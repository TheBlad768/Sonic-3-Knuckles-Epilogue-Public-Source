; ===========================================================================
; Level Size Array
; ===========================================================================

;		xstart, xend, ystart, yend			; Level
LevelSizes:
		dc.w 0, $A20, 0, $4A0				; DEZ 1
		dc.w $A20, $A20, 0, $6F0			; DEZ 2
		dc.w $A20, $A20, $370, $370		; DEZ 3
		dc.w $A20, $A20, $370, $370		; DEZ 4

		zonewarning LevelSizes,(8*4)