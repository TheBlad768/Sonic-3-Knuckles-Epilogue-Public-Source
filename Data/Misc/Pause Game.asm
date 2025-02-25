; ---------------------------------------------------------------------------
; Subroutine to pause the game
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Pause_Game:
		tst.b	(Game_paused).w
		bne.s	+
		tst.b	(Ctrl_1_pressed).w					; is Start pressed?
		bpl.s	Pause_NoPause					; if not, branch
+		tst.b	(GoodMode_flag).w
		beq.s	Pause_NoPause
		tst.b	(NoPause_flag).w
		bne.s	Pause_NoPause
		st	(Game_paused).w
		SMPS_PauseMusic

Pause_Loop:
		move.b	#VintID_Level,(V_int_routine).w
		bsr.w	Wait_VSync
	if GameDebug=1
		btst	#bitA,(Ctrl_1_pressed).w				; is button A pressed?
		beq.s	Pause_ChkFrameAdvance			; if not, branch
		move.b	#id_LevelSelectScreen,(Game_mode).w	; set game mode
		bra.s	Pause_ResumeMusic
; ---------------------------------------------------------------------------

Pause_ChkFrameAdvance:
		btst	#bitB,(Ctrl_1_held).w					; is button B held?
		bne.s	Pause_FrameAdvance				; if yes, branch
		btst	#bitC,(Ctrl_1_pressed).w				; is button C pressed?
		bne.s	Pause_FrameAdvance				; if yes, branch
Pause_ChkStart:
	endif
	if GameDebug=0
		bsr.s	Pause_Code
	endif
		tst.b	(Ctrl_1_pressed).w					; is Start pressed?
		bpl.s	Pause_Loop						; if not, branch

Pause_ResumeMusic:
		SMPS_UnpauseMusic

Pause_Unpause:
		clr.b	(Game_paused).w

Pause_NoPause:
		rts
; ---------------------------------------------------------------------------
	if GameDebug=1
Pause_FrameAdvance:
		st	(Game_paused).w
		SMPS_UnpauseMusic
		rts
	endif
; End of function Pause_Game
; ---------------------------------------------------------------------------

	if GameDebug=0

Pause_CodeDat:
		dc.b btnB, btnA, btnDn, btnB, btnA, btnDn, btnL, btnUp, btnC
		dc.b 0		; Stop
	even

; =============== S U B R O U T I N E =======================================

Pause_Code:
		lea	Pause_CodeDat(pc),a1
		lea	(MiniGame_SaveScore).w,a2
		moveq	#0,d0
		move.b	(a2),d0
		adda.w	d0,a1
		move.b	(Ctrl_1_pressed).w,d0
		andi.b	#$7F,d0
		beq.s	Pause_Code_Return
		move.b	(Ctrl_1).w,d0
		cmp.b	(a1)+,d0
		bne.s	Pause_Code_Fail
		addq.b	#1,(a2)
		tst.b	(a1)
		bne.s	Pause_Code_Return
		addq.b	#1,(Current_act).w
		andi.b	#1,(Current_act).w
		move.b	#id_LevelScreen,(Game_mode).w	; set Game Mode
		st	(PauseSkip_Flag).w
		clr.b	(Intro_flag).w
		SMPS_UnpauseMusic
		addq.w	#8,sp

Pause_Code_Fail:
		clr.b	(a2)

Pause_Code_Return:
		rts

	endif
