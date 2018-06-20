;***********************************************************
;
; MSX DIAGNOSTICS
; Version 0.0.1-a
; ASM Z80 MSX
;
; (cc)2018 Cesar Rincon "NightFox"
; http://www.nightfoxandco.com
;
;***********************************************************





;***********************************************************
; Directivas para el compilador
;***********************************************************

; ----------------------------------------------------------
; Definicion de variables [PAGE 3] $C000
; ----------------------------------------------------------
; Almacena las variables en la pagina 3 (Comentar si no es una ROM)
.PAGE 3
.INCLUDE "ngn/ngn_vars.asm"
.INCLUDE "prog/vars.asm"



; ----------------------------------------------------------
; Otras directivas
; ----------------------------------------------------------

.PAGE 1					; Selecciona la pagina 1 [$4000] (Codigo del programa)
.BIOS					; Nombres de las llamadas a BIOS
.ROM					; Se creara el binario en formato ROM de hasta 32kb
.START PROGRAM_START_ADDRESS		; Indicale al compilador donde empieza el programa
.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0	; 12 ceros para completar la cabecera de la ROM



;***********************************************************
; Programa
;***********************************************************

PROGRAM_START_ADDRESS:

	; ----------------------------------------------------------
	; Punto de incicio
	; ----------------------------------------------------------

	.SEARCH			; Busca un punto de inicio valido


	; ----------------------------------------------------------
	; Ejecuta el programa
	; ----------------------------------------------------------

	; Ejecuta el programa
	jp FUNCTION_MAIN

	; Punto final del programa
	ret


	; ----------------------------------------------------------
	; Definicion de constantes
	; ----------------------------------------------------------

	.INCLUDE "ngn/ngn_consts.asm"	; Constantes de N'gine
	.INCLUDE "prog/consts.asm"	; Constantes del programa



	; ----------------------------------------------------------
	; Codigo principal
	; ----------------------------------------------------------

	; Archivo principal
	.INCLUDE "prog/main.asm"

	; Pantalla de bienvenida
	.INCLUDE "prog/welcome.asm"
	; Menu principal
	.INCLUDE "prog/main_menu.asm"
	; Test SCREEN 0
	.INCLUDE "prog/screen0_test.asm"
	; Test SCREEN 2
	.INCLUDE "prog/screen2_test.asm"
	; Test SPRITES
	.INCLUDE "prog/sprites_test.asm"
	; Test KEYBOARD
	.INCLUDE "prog/keyboard_test.asm"

	; Procesos comunes
	.INCLUDE "prog/system.asm"
	.INCLUDE "prog/sfx.asm"
	
	

	; ----------------------------------------------------------
	; Libreria N'gine
	; ----------------------------------------------------------

	.INCLUDE "ngn/ngn.asm"



	; ----------------------------------------------------------
	; Datos del programa
	; ----------------------------------------------------------

	; Imagenes de fondo
	.INCLUDE "data/bg/bg_ngnlogo.asm"		; Total de datos: 2635 bytes
	.INCLUDE "data/bg/bg_line_pattern_b.asm"	; Total de datos: 922 bytes
	.INCLUDE "data/bg/bg_line_pattern_w.asm"	; Total de datos: 904 bytes
	.INCLUDE "data/bg/bg_color_bars.asm"		; Total de datos: 1158 bytes
	.INCLUDE "data/bg/bg_hello.asm"			; Total de datos: 1003 bytes

	; Sprites
	.INCLUDE "data/sprite/ball_16x16.asm"		; Total de datos: 34 bytes

	; Textos del programa
	.INCLUDE "data/txt/text.asm"
	.INCLUDE "data/txt/key_names.asm"




;***********************************************************
; Fin del archivo
;***********************************************************
MSXDIAG_EOF: