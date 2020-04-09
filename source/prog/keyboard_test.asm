;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.0.0.
;	ASM Z80 MSX
;	Test del teclado
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Menu del Test KEYBOARD
; ----------------------------------------------------------

FUNCTION_KEYBOARD_TEST_MENU:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Texto del menu
	ld hl, TEXT_MENU_HEADER		; Apunta al texto a mostrar
	call NGN_TEXT_PRINT		; E imprimelo en pantalla
	ld hl, TEXT_KEYBOARD_MENU	; Apunta al texto a mostrar
	call NGN_TEXT_PRINT		; E imprimelo en pantalla
	ld hl, TEXT_KEYBOARD_CANCEL	; Apunta al texto a mostrar
	call NGN_TEXT_PRINT		; E imprimelo en pantalla
	ld hl, TEXT_MENU_FOOTER		; Apunta al texto a mostrar
	call NGN_TEXT_PRINT		; E imprimelo en pantalla

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044

	; Bucle de ejecucion
	@@LOOP:

		; Lectura del HID
		call FUNCTION_SYSTEM_HID_READ

		; Si se pulsa la tecla "ACCEPT"
		ld a, [SYSKEY_ACCEPT]
		and $02						; Detecta "KEY DOWN"
		jp nz, FUNCTION_KEYBOARD_TEST_WAIT_FREE_KEYS	; Ejecuta el test si se pulsa

		; Si se pulsa la tecla "CANCEL"
		ld a, [SYSKEY_CANCEL]
		and $02					; Detecta "KEY DOWN"
		ret nz					; Vuelve al menu principal si se pulsa

		; Espera a la interrupcion del VDP (VSYNC)
		halt	; Espera a la interrupcion del VDP

		; Repite el bucle
		jr @@LOOP



; ----------------------------------------------------------
; Espera a que el teclado este libre
; ----------------------------------------------------------

FUNCTION_KEYBOARD_TEST_WAIT_FREE_KEYS:

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Texto de espera
	ld hl, $060B				; Posicion del cursor de texto [XXYY]
	call NGN_TEXT_POSITION			; Posiciona el cursor
	ld hl, TEXT_KEYBOARD_TEST_WAIT_RELEASE	; Apunta al texto a mostrar
	call NGN_TEXT_PRINT			; E imprimelo en pantalla

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044

	; Espera a que no se pulse ninguna tecla
	@@LOOP:
		
		; Lee la entrada
		call FUNCTION_SYSTEM_HID_READ

		ld a, [NGN_KEY_ANY]			; Si esta pulsada "Cualquier tecla"
		and $FF					; Detecta "KEY DOWN"
		jp z, FUNCTION_KEYBOARD_TEST_RUN	; Ejecuta el test si no hay pulsada ninguna tecla

		ld a, [SYSKEY_CANCEL]			; Si se pulsa "CANCELAR"
		and $02					; Detecta "KEY DOWN"
		ret nz					; Vuelve al menu principal si se pulsa

		; Espera el VSYNC
		halt	; Espera a la interrupcion del VDP

		; Repite el bucle
		jr @@LOOP



; ----------------------------------------------------------
; Ejecuta el test
; ----------------------------------------------------------

FUNCTION_KEYBOARD_TEST_RUN:

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Texto de cabecera
	ld hl, TEXT_KEYBOARD_TEST_READY		; Apunta al texto a mostrar
	call NGN_TEXT_PRINT			; E imprimelo en pantalla

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044

	; Bucle de ejecucion
	@@LOOP:

		; Lee la entrada
		call FUNCTION_SYSTEM_HID_READ

		; Color de fondo segun la pulsacion
		call FUNCTION_KEYBOARD_TEST_BGCOLOR

		; Test de todas las teclas
		call FUNCTION_KEYBOARD_TEST_KEYPRESS

		; Deteccion de salida del test
		ld a, [NGN_JOY1_TG2]			; Si se pulsa "BOTON 2"
		and $02					; Detecta "KEY DOWN"
		jr nz, @@EXIT				; Vuelve al menu principal

		ld a, [NGN_KEY_CTRL]			; Si se pulsa "CTRL"
		and $01					; Detecta "KEY HELD"
		jr z, @@NO_ESC				; Si no esta presionada, no verifiques ESC

		ld a, [NGN_KEY_ESC]			; Si se pulsa "ESC"
		and $02					; Detecta "KEY DOWN"
		jr nz, @@EXIT				; Vuelve al menu principal

		; No hay que salir
		@@NO_ESC:

		; Actualiza el sonido
		call SFX_FUNCTION_UPDATE

		; Espera el VSYNC
		halt	; Espera a la interrupcion del VDP

		; Repite el bucle
		jr @@LOOP


	; Sal al menu principal
	@@EXIT:
		
		call SFX_FUNCTION_CLOSE		; Cierra el sonido
		ret				; Vuelve al menu principal



; ----------------------------------------------------------
; Color de fondo segun la presion de las teclas
; ----------------------------------------------------------

FUNCTION_KEYBOARD_TEST_BGCOLOR:

	ld a, [NGN_KEY_ANY]	; Cualquier tecla
	and $01			; Estado HELD
	jr nz, @@HELD

	; Ninguna tecla presionada
	ld bc, $0F04
	call NGN_TEXT_COLOR
	ret

	; Alguna tecla presionada
	@@HELD:
	ld bc, $040E
	call NGN_TEXT_COLOR
	ret



; ----------------------------------------------------------
; ID de tecla segun la presion de las teclas
; ----------------------------------------------------------

FUNCTION_KEYBOARD_TEST_KEYPRESS:

	ld hl, NGN_KEY_0			; Puntero donde esta la primera tecla
	ld de, $0000				; Numero de tecla

	@@READ_KEYS:			

		ld c, [hl]			; Lee la tecla

		ld a, c
		and $02				; Si es PRESS
		call nz, @@KEY_PRESS

		ld a, c				; Si es RELEASED
		and $04
		call nz, @@KEY_UP

		@@NEXT_KEY:
		inc hl				; Siguiente tecla
		inc e				; Cuenta las teclas iniciadas
		ld a, e
		cp NGN_TOTAL_KEYS - 1		; Cuenta todas las teclas, excepto "ANY KEY"
		jr nz, @@READ_KEYS		; Repite el proceso
	
	; Sal de la funcion
	ret

	
	; Si se ha pulsado la tecla
	@@KEY_PRESS:

		push hl				; Guarda los registros
		push de
		push bc

		ld hl, KEY_NAMES_KEYS		; Apunta a la tabla de nombres de teclas
		add hl, de			; Desplazamiento segun la tecla
		ld a, [hl]			; Lee el texto
		call $00A2			; Imprime el caracter. Rutina [CHPUT] de la BIOS

		ld hl, TEXT_KEYBOARD_TEST_PRESSED	; Texto de coletilla
		call NGN_TEXT_PRINT			; Imprime el texto

		call SFX_FUNCTION_PLAY_PING		; Sonido

		pop bc				; Recupera los registros
		pop de
		pop hl

		ret				; Sal de la subrutina


	; Si se ha soltado la tecla
	@@KEY_UP:

		push hl				; Guarda los registros
		push de
		push bc

		ld hl, KEY_NAMES_KEYS		; Apunta a la tabla de nombres de teclas
		add hl, de			; Desplazamiento segun la tecla
		ld a, [hl]			; Lee el texto
		call $00A2			; Imprime el caracter. Rutina [CHPUT] de la BIOS

		ld hl, TEXT_KEYBOARD_TEST_RELEASED	; Texto de coletilla
		call NGN_TEXT_PRINT			; Imprime el texto

		call SFX_FUNCTION_PLAY_PONG		; Sonido

		pop bc				; Recupera los registros
		pop de
		pop hl

		ret				; Sal de la subrutina



;***********************************************************
; Fin del archivo
;***********************************************************
KEYBOARD_TEST_EOF: