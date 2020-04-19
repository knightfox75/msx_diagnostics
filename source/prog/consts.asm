;***********************************************************
;
;   MSX DIAGNOSTICS
;   Version 1.1.4
;   ASM Z80 MSX
;   Definicion de constantes
;   (cc) 2018-2020 Cesar Rincon "NightFox"
;   https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Sistema
; ----------------------------------------------------------

SYSTEM_KEYS_NUMBER		    .EQU	6		; Numero de teclas de sistema



; ----------------------------------------------------------
; Menu principal
; ----------------------------------------------------------

MAINMENU_ITEM_START		    .EQU	7		; Offset del cursor en Y
MAINMENU_FIRST_OPTION_P1	.EQU	0		; (1 - 1)
MAINMENU_LAST_OPTION_P1		.EQU	11		; (10 + 1)
MAINMENU_FIRST_OPTION_P2	.EQU	0		; (1 - 1)
MAINMENU_LAST_OPTION_P2		.EQU	11		; (10 + 1)



; ----------------------------------------------------------
; Test SCREEN 2
; ----------------------------------------------------------

SCR2TEST_FIRST_IMAGE		.EQU	0	; (1 - 1)	Idx al que saltar a la ultima imagen	
SCR2TEST_LAST_IMAGE		    .EQU	5	; (4 + 1)	Idx al que saltar a la primera imagen



; ----------------------------------------------------------
; Test SCREEN 3
; ----------------------------------------------------------

SCR3TEST_FIRST_PATTERN		.EQU	0	; (1 - 1)	Idx al que saltar a la ultimo patron
SCR3TEST_LAST_PATTERN		.EQU	8	; (7 + 1)	Idx al que saltar a la primer patron



; ----------------------------------------------------------
; Test JOYSTICK
; ----------------------------------------------------------

JOYTEST1_COLOR_OFF		    .EQU	4
JOYTEST1_COLOR_ON		    .EQU	10
JOYTEST2_COLOR_OFF		    .EQU	6
JOYTEST2_COLOR_ON		    .EQU	12



; ----------------------------------------------------------
; Test PSG
; ----------------------------------------------------------

PSGTEST_ITEM_START          .EQU	4		; Offset del cursor en Y
PSGTEST_FIRST_OPTION		.EQU	0		; (1 - 1)
PSGTEST_LAST_OPTION		    .EQU	9		; (8 + 1)
PSGTEST_FREQ_X_START        .EQU    11      ; Offset del cursor X
PSGTEST_FREQ_X_GAP          .EQU    8       ; Espacio entre columnas
PSGTEST_VOL_X_START         .EQU    17      ; Offset del cursor X
PSGTEST_NOISE_CHAN_X_START  .EQU    18      ; Offset del cursor X
PSGTEST_NOISE_CHAN_X_GAP    .EQU    6       ; Espacio entre columnas
PSGTEST_NOISE_FREQ_X_START  .EQU    17      ; Offset del cursor X



; ----------------------------------------------------------
; Test del Color del monitor
; ----------------------------------------------------------

MONITOR_COLOR_ITEM_FIRST     .EQU        1       ; Primer test
MONITOR_COLOR_ITEM_LAST      .EQU        6       ; Ultimo test


;***********************************************************
; Fin del archivo
;***********************************************************
CONSTS_EOF: