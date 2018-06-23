;***********************************************************
; MSX DIAGNOSTICS
; Version 0.1.0-a
; ASM Z80 MSX
; Definicion de constantes
; (c) 2018 Cesar Rincon "NightFox"
; http://www.nightfoxandco.com
;***********************************************************



; ----------------------------------------------------------
; Sistema
; ----------------------------------------------------------

SYSTEM_KEYS_NUMBER		.EQU	6		; Numero de teclas de sistema



; ----------------------------------------------------------
; Menu principal
; ----------------------------------------------------------

MAINMENU_ITEM_START		.EQU	7		; Offset del cursor en Y
MAINMENU_FIRST_OPTION		.EQU	0		; (1 - 1)
MAINMENU_LAST_OPTION		.EQU	8		; (7 + 1)



; ----------------------------------------------------------
; Test SCREEN 2
; ----------------------------------------------------------

SCR2TEST_FIRST_IMAGE		.EQU	0	; (1 - 1)	Idx al que saltar a la ultima imagen	
SCR2TEST_LAST_IMAGE		.EQU	5	; (4 + 1)	Idx al que saltar a la primera imagen



; ----------------------------------------------------------
; Test JOYSTICK
; ----------------------------------------------------------

JOYTEST1_COLOR_OFF		.EQU	4
JOYTEST1_COLOR_ON		.EQU	10
JOYTEST2_COLOR_OFF		.EQU	6
JOYTEST2_COLOR_ON		.EQU	12



;***********************************************************
; Fin del archivo
;***********************************************************
CONSTS_EOF: