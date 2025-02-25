; ---------------------------------------------------------------------------
; Generates a pseudo-random number in d0
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

RandomNumber:
Random_Number:
		move.l	(RNG_seed).w,d0
		add.l	d0,d0
		add.l	d0,d0
		add.l	(RNG_seed).w,d0
		add.l	(VDP_counter).l,d0
		add.l	(V_int_run_count).w,d0
		addi.l	#$98765432,d0
		move.l	d0,(RNG_seed).w
		swap	d0
		move.l	d0,d1
		rts
; End of function Random_Number