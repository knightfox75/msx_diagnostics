;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.0-wip02
;	ASM Z80 MSX
;	Funciones comunes del sistema
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************





; ----------------------------------------------------------
; Valores iniciales del programa
; ----------------------------------------------------------

FUNCTION_SYSTEM_START:

	; Inicializa la matriz del teclado
	call FUNCTION_SYSTEM_RESET_KEYBOARD_MATRIX

	; Tabla de nombres de las teclas
	call FUNCTION_SYSTEM_SET_KEY_NAMES_TABLE

	; Ultima opcion usada del menu
	ld a, (MAINMENU_FIRST_OPTION_P1 + 1)
	ld [MAINMENU_LAST_ITEM], a

	; Deshabilita la visualizacion de las teclas de funcion
	call NGN_SCREEN_KEYS_OFF

	; Fin de la funcion
	ret




; ----------------------------------------------------------
; Inicializa la matriz del teclado
; ----------------------------------------------------------

FUNCTION_SYSTEM_RESET_KEYBOARD_MATRIX:

	; Variables del teclado del sistema
	ld hl, SYSKEY_UP
	ld b, $00

	;  Bucle de puesta a 0 de las variables
	@@LOOP:
		xor a		; Registro A a 0
		ld [hl], a	; Resetea el valor de la variable
		inc hl		; Siguiente variable
		inc b		; Contador del bucle
		ld a, b
		cp SYSTEM_KEYS_NUMBER	; Si se ha completado el bucle
		jr nz, @@LOOP

	; Sal de la subrutina
	ret





; ----------------------------------------------------------
; Apunta a la tabla de nombre de teclas correcta
; segun el idioma del teclado desde $002C

;	  7   6   5   4   3   2   1   0
;	+---+---+---+---+---------------+
;	|Cur|SRC|SLS|SSM| Keyboard Type |
;	+---+---+---+---+---------------+
;   Keyboard Type: 0000 (0) = Japan;
;                  0001 (1) = International;
;                  0010 (2) = France;
;                  0011 (3) = United Kingdom;
;                  0100 (4) = Germany;
;                  0101 (5) = USSR;
;                  0110 (6) = Spain.
; ----------------------------------------------------------

FUNCTION_SYSTEM_SET_KEY_NAMES_TABLE:

	; Lee la informacion regional de la BIOS
	ld a, [$002C]
	; Informacion del teclado [Mascara 00001111]
	and $0F

	@@INTERNATIONAL:
	cp 1		; Internacional
	jr nz, @@FRANCE
	ld hl, KEY_NAMES_INTERNATIONAL
	ld [KEY_NAMES_TABLE], hl
	ret

	@@FRANCE:
	cp 2		; Francia
	jr nz, @@DEFAULT
	ld hl, KEY_NAMES_FRANCE
	ld [KEY_NAMES_TABLE], hl
	ret

	@@DEFAULT:	; Por defecto / Resto de paises
	ld hl, KEY_NAMES_INTERNATIONAL
	ld [KEY_NAMES_TABLE], hl
	ret





; ----------------------------------------------------------
; Lee el estado del teclado y joysticks
; ----------------------------------------------------------

FUNCTION_SYSTEM_HID_READ:	; (Human Interface Devices)

	call NGN_KEYBOARD_READ		; Lee el teclado
	call NGN_PSG_READ_JOY1		; Puerto 1 del Joystick
	call NGN_PSG_READ_JOY2		; Puerto 2 del Joystick


	; --------------------------------
	; Actualiza las teclas del sistema
	; --------------------------------
	
	; Arriba
	ld a, [NGN_KEY_UP]	; Valor de la tecla UP
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_UP]	; Valor del Joy1 UP
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_UP], a	; Almacena el valor en la variable

	; Abajo
	ld a, [NGN_KEY_DOWN]	; Valor de la tecla DOWN
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_DOWN]	; Valor del Joy1 DOWN
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_DOWN], a	; Almacena el valor en la variable

	; Izquierda
	ld a, [NGN_KEY_LEFT]	; Valor de la tecla LEFT
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_LEFT]	; Valor del Joy1 LEFT
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_LEFT], a	; Almacena el valor en la variable

	; Derecha
	ld a, [NGN_KEY_RIGHT]	; Valor de la tecla RIGHT
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_RIGHT]	; Valor del Joy1 RIGHT
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_RIGHT], a	; Almacena el valor en la variable

	; Aceptar
	ld a, [NGN_KEY_SPACE]	; Valor de la tecla SPACE
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_TG1]	; Valor del Joy1 TG1
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_ACCEPT], a	; Almacena el valor en la variable

	; Cancelar
	ld a, [NGN_KEY_ESC]	; Valor de la tecla ESC
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_TG2]	; Valor del Joy1 TG2
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_CANCEL], a	; Almacena el valor en la variable

	; Fin de la funcion
	ret





;***********************************************************
; Fin del archivo
;***********************************************************
SYSTEM_EOF: