;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.4
;	ASM Z80 MSX
;	Test SCREEN 1
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Menu del Test SCREEN 1
; ----------------------------------------------------------

FUNCTION_SCREEN1_TEST_MENU:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Texto del menu
	call FUNCTION_MAIN_MENU_HEADER_PRINT		; Cabecera
	ld hl, $0104								; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
	ld hl, TEXT_SCREEN1_MENU_TITLE				; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_SCREEN1_MENU_INSTRUCTIONS		; Instrucciones de uso
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_MENU_CANCEL						; Como cancelar
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_MENU_FOOTER						; Pie del menu
	call NGN_TEXT_PRINT							; Imprimelo

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044

	; Bucle de ejecucion
	@@LOOP:

		; Lectura del HID
		call FUNCTION_SYSTEM_HID_READ

		; Si se pulsa la tecla  "ACEPTAR"
		ld a, [SYSKEY_ACCEPT]
		and $02					; Detecta "KEY DOWN"
		jp nz, FUNCTION_SCREEN1_TEST_RUN	; Ejecuta el test

		; Si se pulsa la tecla  "CANCELAR"
		ld a, [SYSKEY_CANCEL]
		and $02					; Detecta "KEY DOWN"
		ret nz					; Vuelve al menu principal

		; Espera a la interrupcion del VDP (VSYNC)
		halt

		; Repite el bucle
		jr @@LOOP



; ----------------------------------------------------------
; Ejecuta el test
; ----------------------------------------------------------

FUNCTION_SCREEN1_TEST_RUN:

	; Pon la VDP en MODO SCR1
	ld bc, $0F04			; Color de frente/fondo
	ld de, $0120			; Color de borde/ancho en columnas (32)
	call NGN_SCREEN_SET_MODE_1

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Rellena la pantalla con todos los caracteres disponibles
	
	ld a, 32	; Primer caracter de la tabla ASCII (32, Espacio)
	ld bc, $0000	; Fila 0, Columna 0

	@@DRAW:

		call $00A2	; Imprime el caracter del registro A. Rutina [CHPUT] de la BIOS

		; Siguiente caracter
		inc a		; Sumale 1
		cp 127		; Si es el caracter "DEL", evitalo
		jr nz, @@SKIP_DEL
		inc a		; Sumale 1 mas para saltarte el caracter "DEL"

		@@SKIP_DEL:
		cp 255		; Si llegas al final de la tabla, reinicia
		jr nz, @@NEXT_CHAR
		ld a, 32	; Reinicia la tabla

		@@NEXT_CHAR:
		ld d, a		; Guarda el caracter actual
		inc c		; Siguiente columna
		ld a, c
		cp 32		; Si es la ultima columna, cambia de fila y reinicia la columna
		jr nz, @@NEXT_COLUMN

		ld c, 0		; Fila a 0
		inc b		; Columna +1
		ld a, b
		cp 23		; Si es la ultima fila, sal
		jr z, @@MAIN_PROGRAM 

		@@NEXT_COLUMN:
		ld a, d		; Recupera el caracter actual
		jr @@DRAW	; Y repite el bucle



	@@MAIN_PROGRAM:

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044

	; Colores por defecto
	ld bc, $0F04	; Texto blanco, Fondo Azul
	ld de, $0100	; Color del borde

	; Bucle de ejecucion
	@@LOOP:

		; Guarda los colores actuales
		push bc
		push de

		; Lectura del HID
		call FUNCTION_SYSTEM_HID_READ

		; Recupera los colores actuales
		pop de
		pop bc

		; Si se pulsa "ARRIBA", cambia el color de fondo (+)
		ld a, [SYSKEY_UP]
		and $02					; Detecta "KEY DOWN"
		jp nz, @@BG_COLOR_UP

		; Si se pulsa "ABAJO", cambia el color de fondo (-)
		ld a, [SYSKEY_DOWN]
		and $02					; Detecta "KEY DOWN"
		jp nz, @@BG_COLOR_DOWN

		; Si se pulsa "DERECHA", cambia el color de fondo (+)
		ld a, [SYSKEY_RIGHT]
		and $02					; Detecta "KEY DOWN"
		jp nz, @@TEXT_COLOR_UP

		; Si se pulsa "IZQUIERDA", cambia el color de fondo (-)
		ld a, [SYSKEY_LEFT]
		and $02					; Detecta "KEY DOWN"
		jp nz, @@TEXT_COLOR_DOWN

		; Si se pulsa "ACEPTAR", cambia el color de borde
		ld a, [SYSKEY_ACCEPT]
		and $02					; Detecta "KEY DOWN"
		jp nz, @@BORDER_COLOR

		; Punto de final del bucle
		@@LOOP_END:

		; Si se pulsa la tecla  "CANCELAR"
		ld a, [SYSKEY_CANCEL]
		and $02					; Detecta "KEY DOWN"
		ret nz					; Vuelve al menu principal

		; Espera a la interrupcion del VDP (VSYNC)
		halt

		; Repite el bucle
		jp @@LOOP


	; Color de fondo arriba
	@@BG_COLOR_UP:
		ld a, c
		inc a
		cp 16			; Si es el ultimo color, repite
		jr nz, @@NEXT_BG_UP
		ld a, 1			; Primer color
		@@NEXT_BG_UP:
		ld c, a
		push bc			; Guarda el color actual
		push de
		call NGN_TEXT_COLOR	; Actualiza el color
		pop de
		pop bc			; Recupera el color actual
		jp @@LOOP_END 

	; Color de fondo abajo
	@@BG_COLOR_DOWN:
		ld a, c
		dec a
		cp 0			; Si es el ultimo color, repite
		jr nz, @@NEXT_BG_DOWN
		ld a, 15		; Primer color
		@@NEXT_BG_DOWN:
		ld c, a
		push bc			; Guarda el color actual
		push de
		call NGN_TEXT_COLOR	; Actualiza el color
		pop de
		pop bc			; Recupera el color actual
		jp @@LOOP_END

	; Color de texto arriba
	@@TEXT_COLOR_UP:
		ld a, b
		inc a
		cp 16			; Si es el ultimo color, repite
		jr nz, @@NEXT_TEXT_UP
		ld a, 1			; Primer color
		@@NEXT_TEXT_UP:
		ld b, a
		push bc			; Guarda el color actual
		push de
		call NGN_TEXT_COLOR	; Actualiza el color
		pop de
		pop bc			; Recupera el color actual
		jp @@LOOP_END

	; Color de texto abajo
	@@TEXT_COLOR_DOWN:
		ld a, b
		dec a
		cp 0			; Si es el ultimo color, repite
		jr nz, @@NEXT_TEXT_DOWN
		ld a, 15		; Primer color
		@@NEXT_TEXT_DOWN:
		ld b, a
		push bc			; Guarda el color actual
		push de
		call NGN_TEXT_COLOR	; Actualiza el color
		pop de
		pop bc			; Recupera el color actual
		jp @@LOOP_END


	; Color de borde
	@@BORDER_COLOR:
		; Siguiente color de borde
		inc d		; +1
		ld a, d		; Verifica si has superado el ultimo color
		cp 16		; Si lo has superado, resetealo a 1
		jr nz, @@UPDATE_BORDER_COLOR
		; Reinicia el color de borde
		ld d, 1
		; Aplica el cambio de color
		@@UPDATE_BORDER_COLOR:
		ld hl, NGN_COLOR_ADDR
		inc l			; Salta el color frontal
		inc l			; Salta el color de fondo
		ld [hl], d		; Color del borde
		push bc			; Guarda los colores actuales
		push de
		call $0062		; Aplica el color con la rutina [CHGCLR] de la BIOS
		pop de
		pop bc			; Recupera los colores actuales
		jp @@LOOP_END



;***********************************************************
; Fin del archivo
;***********************************************************
SCREEN1_TEST_EOF: