;***********************************************************
; MSX DIAGNOSTICS
; Version 0.1.0-a
; ASM Z80 MSX
; Declaracion de variables
; (c) 2018 Cesar Rincon "NightFox"
; http://www.nightfoxandco.com
;***********************************************************




; --------------------------------------------------------------
; Declara las variables	del sistema	[VARIABLE]	[BYTES]
; --------------------------------------------------------------

; -----------------------------------------------------------------------
;	Teclas
;	STATE	[PRESS]	[HELD]		Key num: 6
;	BIT	   1	  0		NGN_TOTAL_KEYS
; -----------------------------------------------------------------------

SYSKEY_UP:			ds	1	; Cursor / Joy1 arriba
SYSKEY_DOWN:			ds	1	; Cursor / Joy1 arriba
SYSKEY_LEFT:			ds	1	; Cursor / Joy1 arriba
SYSKEY_RIGHT:			ds	1	; Cursor / Joy1 arriba
SYSKEY_ACCEPT:			ds	1	; Espacio / Joy1 Boton 1
SYSKEY_CANCEL:			ds	1	; ESC / Joy1 Boton 2



; ----------------------------------------------------------
; Menu principal
; ----------------------------------------------------------

MAINMENU_ITEM_SELECTED:		ds	1		; Posicion del cursor
MAINMENU_ITEM_OLD:		ds	1		; Posicion anterior del cursor

; ----------------------------------------------------------
; Sprites Demo
; ----------------------------------------------------------
SPRITE_SPEED:			ds	64		; Velocidad de los sprites [Y][X] * 2


;***********************************************************
; Fin del archivo
;***********************************************************
VARS_EOF: