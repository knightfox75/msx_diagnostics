;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.4
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
	call FUNCTION_MAIN_MENU_HEADER_PRINT		; Cabecera
	ld hl, $0104								; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
	ld hl, TEXT_KEYBOARD_MENU_TITLE				; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_KEYBOARD_MENU_INSTRUCTIONS		; Instrucciones de uso
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_MENU_FOOTER						; Pie del menu
	call NGN_TEXT_PRINT							; Imprimelo

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
		halt

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

		ld a, [NGN_KEY_ANY]		; Si esta pulsada "Cualquier tecla"
		and $FF					; Detecta "KEY DOWN"
		jp z, FUNCTION_KEYBOARD_TEST_RUN	; Ejecuta el test si no hay pulsada ninguna tecla

		ld a, [SYSKEY_CANCEL]	; Si se pulsa "CANCELAR"
		and $02					; Detecta "KEY DOWN"
		ret nz					; Vuelve al menu principal si se pulsa

		; Espera el VSYNC
		halt

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
		ld a, [NGN_JOY1_TG2]		; Si se pulsa "BOTON 2"
		and $02						; Detecta "KEY DOWN"
		jr nz, @@EXIT				; Vuelve al menu principal

		ld a, [NGN_KEY_SHIFT]		; Si se pulsa "SHIFT"
		and $01						; Detecta "KEY HELD"
		jr z, @@NO_ESC				; Si no esta presionada, no verifiques ESC

		ld a, [NGN_KEY_ESC]			; Si se pulsa "ESC"
		and $02						; Detecta "KEY DOWN"
		jr nz, @@EXIT				; Vuelve al menu principal

		; No hay que salir
		@@NO_ESC:

		; Actualiza el sonido
		call SFX_FUNCTION_UPDATE

		; Espera el VSYNC
		halt

		; Repite el bucle
		jr @@LOOP


	; Sal al menu principal
	@@EXIT:
		
		call SFX_FUNCTION_CLOSE		; Cierra el sonido
		ret							; Vuelve al menu principal



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

		ld c, [hl]				; Lee la tecla

		ld a, c
		and $02					; Si es PRESS
		call nz, @@KEY_PRESS

		ld a, c					; Si es RELEASED
		and $04
		call nz, @@KEY_UP

		@@NEXT_KEY:
		inc hl					; Siguiente tecla
		inc e					; Cuenta las teclas iniciadas
		ld a, e
		cp NGN_TOTAL_KEYS - 1	; Cuenta todas las teclas, excepto "ANY KEY"
		jr nz, @@READ_KEYS		; Repite el proceso
	
	; Sal de la funcion
	ret

	
	; Si se ha pulsado la tecla
	@@KEY_PRESS:

		push hl		; Guarda los registros
		push de
		push bc

		call @@KEY_NAME						; Imprime la tecla [Registro DE]
		ld hl, TEXT_KEYBOARD_TEST_PRESSED	; Texto de coletilla
		call NGN_TEXT_PRINT					; Imprime el texto
		call SFX_FUNCTION_PLAY_PING			; Sonido

		pop bc		; Recupera los registros
		pop de
		pop hl

		ret			; Sal de la subrutina


	; Si se ha soltado la tecla
	@@KEY_UP:

		push hl		; Guarda los registros
		push de
		push bc

		call @@KEY_NAME						; Imprime la tecla [Registro DE]
		ld hl, TEXT_KEYBOARD_TEST_RELEASED	; Texto de coletilla
		call NGN_TEXT_PRINT					; Imprime el texto
		call SFX_FUNCTION_PLAY_PONG			; Sonido

		pop bc		; Recupera los registros
		pop de
		pop hl

		ret			; Sal de la subrutina


	; Imprime la tecla pulsada/soltada [Registro DE]
	@@KEY_NAME:

		; Es el ROW 00?
		ld a, 7						; Ultima tecla de la primera fila (contando la nº0)
		sub e						; Restale el nº de tecla
		jr c, @@BOTTOM_ROWS			; Si da negativo, no esta en esa fila, continua buscando
		ld hl, KEY_NAMES_TOP_ROW	; Apunta a la primera fila
		jr @@PRINT_KEY

		; Son las filas de abajo?
		@@BOTTOM_ROWS:
		ld a, 47					; Ultima tecla del bloque medio (contando la nº0)
		sub e						; Restale el numero de tecla
		jr nc, @@MIDDLE_ROWS		; Si no da negativo, esta en la fila intermedia, continua buscando
		ld a, e						; Compensa el desplazamiento de fila (Reg E - 48)
		sub 48
		ld e, a
		ld hl, KEY_NAMES_BOTTOM_ROWS
		jr @@PRINT_KEY

		; Filas intermedias (Valor determinado por la disposicion del teclado QWERTY o AZERTY)
		@@MIDDLE_ROWS:
		ld a, e						; Compensa el desplazamiento de la primera final
		sub 8
		ld e, a
		ld hl, [KEY_NAMES_TABLE]	; Apunta a la tabla de nombres de teclas

		; Imprime el valor de la tecla
		@@PRINT_KEY:
		add hl, de						; Desplazamiento segun la tecla
		ld a, [hl]						; Lee el texto
		jp $00A2						; Imprime el caracter. Rutina [CHPUT] de la BIOS
		; El return lo realiza la propia rutina de la bios



;***********************************************************
; Fin del archivo
;***********************************************************
KEYBOARD_TEST_EOF: