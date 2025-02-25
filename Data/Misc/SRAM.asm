
; =============== S U B R O U T I N E =======================================

SRAM_Load:
		disableIntsSave
		gotoSRAM
		lea	(SRAM_Size+SRAM_Type.Initial_Startup).l,a0
		move.l	(a0),d0						; Загрузить 'BOSS'
		cmp.l	(Checksum_string).w,d0
		beq.s	SRAM_Load_SavedData

SRAM_Load_DefaultData:						; Загрузить стандартные данные в SRAM
		move.l	(Checksum_string).w,(a0)		; Установить флаг первого запуска
		bsr.s	TimeScreen_InitDataToRAM	; Стандартные данные
		clr.l	(MiniGame_SaveScore).w
		lea	(SRAM_Size+SRAM_Type.TimeAttack_SRAM).l,a0
		lea	(TimeAttack_Start).w,a1
		bsr.s	SRAM_CopyWordData
		bsr.s	SRAM_Checksum
		move.w	d0,(a2)						; Сохранить Checksum

SRAM_Load_SendData_End:
		gotoROM
		enableIntsSave

SRAM_Load_SendData_Return:
		rts
; ---------------------------------------------------------------------------

SRAM_Load_SavedData:
		bsr.s	SRAM_Checksum
		cmp.w	(a2),d0						; Проверить Checksum
		sne	(SRAMCorrupt_flag).w
		bne.s	SRAM_Load_DefaultData		; Маленький читер, стираем все данные
		lea	(TimeAttack_Start).w,a0
		lea	(SRAM_Size+SRAM_Type.TimeAttack_SRAM).l,a1
		bsr.s	SRAM_CopyWordData
		bra.s	SRAM_Load_SendData_End

; =============== S U B R O U T I N E =======================================

SRAM_Save:									; Сохранить данные в SRAM
		tst.b	(SRAMNone_flag).w
		bne.s	SRAM_Load_SendData_Return
		disableIntsSave
		gotoSRAM
		lea	(SRAM_Size+SRAM_Type.TimeAttack_SRAM).l,a0
		lea	(TimeAttack_Start).w,a1
		bsr.s	SRAM_CopyWordData
		bsr.s	SRAM_Checksum
		move.w	d0,(a2)						; Сохранить Checksum
		bra.s	SRAM_Load_SendData_End

; =============== S U B R O U T I N E =======================================

SRAM_CopyWordData:
		moveq	#((TimeAttack_End-TimeAttack_Start)/2)-1,d6

-		move.w	(a1)+,(a0)+
		dbf	d6,-
		rts

; =============== S U B R O U T I N E =======================================

TimeScreen_InitDataToRAM:

; Reset Time and Death
		lea	(TimeAttack_RAM).w,a1
		lea	(TimeAttack_DeathRAM).w,a2
		move.l	#(99*$10000)+(59*$100)+59,d1
		moveq	#-1,d2
		moveq	#10-1,d0

-		move.l	d1,(a1)+
		move.w	d2,(a2)+
		dbf	d0,-
		rts

; =============== S U B R O U T I N E =======================================

SRAM_Checksum:
		lea	(SRAM_Size+SRAM_Type.TimeAttack_SRAM).l,a2
		moveq	#0,d0
		moveq	#((SRAM_Type.Checksum_SRAM-SRAM_Type.TimeAttack_SRAM)/2)-1,d6

-		add.w	(a2)+,d0
		move.w	d0,d1
		rol.w	#2,d0
		add.w	d1,d0
		rol.w	#3,d0
		add.w	d1,d0
		dbf	d6,-
		rts
