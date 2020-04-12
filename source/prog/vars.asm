;***********************************************************
;
;   MSX DIAGNOSTICS
;   Version 1.1.0-wip01
;   ASM Z80 MSX
;   Declaracion de variables
;   (cc) 2018-2020 Cesar Rincon "NightFox"
;   https://nightfoxandco.com
;
;***********************************************************




; --------------------------------------------------------------
; Declara las variables	del sistema	[VARIABLE]	[BYTES]
; --------------------------------------------------------------

; -----------------------------------------------------------------------
;	Teclas
;	STATE	[PRESS]	[HELD]		Key num: 6
;	BIT	   1	  0		NGN_TOTAL_KEYS
; -----------------------------------------------------------------------

SYSKEY_UP:			    ds	1	    ; Cursor / Joy1 arriba
SYSKEY_DOWN:			ds	1	    ; Cursor / Joy1 arriba
SYSKEY_LEFT:			ds	1	    ; Cursor / Joy1 arriba
SYSKEY_RIGHT:			ds	1	    ; Cursor / Joy1 arriba
SYSKEY_ACCEPT:			ds	1	    ; Espacio / Joy1 Boton 1
SYSKEY_CANCEL:			ds	1	    ; ESC / Joy1 Boton 2



; ----------------------------------------------------------
; Menu principal
; ----------------------------------------------------------

MAINMENU_ITEM_SELECTED:		ds	1		; Posicion del cursor
MAINMENU_ITEM_OLD:		    ds	1		; Posicion anterior del cursor
MAINMENU_LAST_ITEM:         ds  1       ; Posicion al abandonar el menu



; ----------------------------------------------------------
; Sprites Demo
; ----------------------------------------------------------

SPRITE_SPEED:			ds	64		; Velocidad de los sprites [Y][X] * 2



; ----------------------------------------------------------
; Test del PSG
; ----------------------------------------------------------

PSG_TEST_OPTION_SELECTED:       ds  1		; Opcion seleccionada del menu (1-3 Freq, 4-6 Vol, 7 Noise Chan, 8 Noise Freq)
SNDCHN1_FRQ:			        ds	1		; Frecuencia de cada canal (0:off, 1:500Hz, 2:1kHz, 3:2kHz)
SNDCHN2_FRQ:			        ds	1
SNDCHN3_FRQ:			        ds	1
SNDCHN1_VOL:			        ds	1		; Volumen de cada canal (0 - 15)
SNDCHN2_VOL:			        ds	1
SNDCHN3_VOL:			        ds	1
SNDNOISE_CHAN:			        ds	1       ; Canal asignado al noise (0:off, 1-3:ON)
SNDNOISE_FRQ:			        ds	1       ; Frecuencia del canal (0 - 15 niveles)
PSG_TEST_CURSOR_X:              ds  1       ; Posicion del cursor
PSG_TEST_CURSOR_Y:              ds  1
PSG_TEST_CURSOR_OLD_X:          ds  1
PSG_TEST_CURSOR_OLD_Y:          ds  1
PSG_TEST_CHANNEL:               ds  1       ; Canal actual (1-4)
PSG_TEST_VOLUME:                ds  1       ; Volumen actual
PSG_TEST_FREQ:                  ds  1       ; Frecuencia actual



;***********************************************************
; Fin del archivo
;***********************************************************
VARS_EOF: