Ani_BossRobot:
		dc.w BossRobot_Normal-Ani_BossRobot
		dc.w BossRobot_Open-Ani_BossRobot
		dc.w BossRobot_Closed-Ani_BossRobot
BossRobot_Normal:	dc.b $F, 0, $FF
BossRobot_Open:		dc.b	3, 0, 1, 2, $FE, 1
BossRobot_Closed: 	dc.b 3, 2, 1, 0, $FE, 1
	even