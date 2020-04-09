;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.0.0.
;	ASM Z80 MSX
;	Menu Principal
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Funcion del Menu Principal
; ----------------------------------------------------------

FUNCTION_MAIN_MENU:

	; Valores iniciales
	ld a, (MAINMENU_FIRST_OPTION + 1)
	ld [MAINMENU_ITEM_SELECTED], a
	ld [MAINMENU_ITEM_OLD], a

	; Pon la VDP en MODO SCR0
	ld bc, $0F04			; Color de frente/fondo
	ld de, $0128			; Color de borde/ancho en columnas (40)
	call NGN_SCREEN_SET_MODE_0

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Texto del menu
	ld hl, TEXT_MENU_HEADER		; Apunta al texto a mostrar
	call NGN_TEXT_PRINT			; E imprimelo en pantalla
	ld hl, TEXT_MAIN_MENU		; Apunta al texto a mostrar
	call NGN_TEXT_PRINT			; E imprimelo en pantalla

	; Cursor
	call @@PRINT_CURSOR

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044

	; Bucle de ejecucion
	@@LOOP:

		; Lectura del HID
		call FUNCTION_SYSTEM_HID_READ


		; ----------------------------------------------------------
		;  Seleccion por pulsacion directa
		; ----------------------------------------------------------

		; Si se pulsa la tecla 1
		ld a, [NGN_KEY_1]					; Tecla 1
		and $02								; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_SCREEN0	; Ejecuta la opcion

		; Si se pulsa la tecla 2
		ld a, [NGN_KEY_2]					; Tecla 2
		and $02								; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_SCREEN1	; Ejecuta la opcion

		; Si se pulsa la tecla 3
		ld a, [NGN_KEY_3]					; Tecla 3
		and $02								; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_SCREEN2	; Ejecuta la opcion

		; Si se pulsa la tecla 4
		ld a, [NGN_KEY_4]					; Tecla 4
		and $02								; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_SCREEN3	; Ejecuta la opcion

		; Si se pulsa la tecla 5
		ld a, [NGN_KEY_5]					; Tecla 5
		and $02								; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_SPRITES	; Ejecuta la opcion

		; Si se pulsa la tecla 6
		ld a, [NGN_KEY_6]					; Tecla 6
		and $02								; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_KEYBOARD	; Ejecuta la opcion
		
		; Si se pulsa la tecla 7
		ld a, [NGN_KEY_7]					; Tecla 7
		and $02								; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_JOYSTICK	; Ejecuta la opcion

		; Si se pulsa la tecla 8
		ld a, [NGN_KEY_8]					; Tecla 8
		and $02								; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_PSG		; Ejecuta la opcion

		; Si se pulsa la tecla 0
		ld a, [NGN_KEY_0]					; Tecla 0
		and $02								; Detecta "KEY DOWN"
		ret nz								; Sal del programa


		; ----------------------------------------------------------
		;  Seleccion por item seleccionado del menu
		; ----------------------------------------------------------

		; Si se pulsa arriba
		ld a, [SYSKEY_UP]
		and $02								; Detecta "KEY DOWN"
		jr z, @@MM_DOWN
		
		ld a, [MAINMENU_ITEM_SELECTED]		; Carga la opcion actual
		dec a								; Resta una opcion
		cp MAINMENU_FIRST_OPTION			; Si es la primera
		jr nz, @@MM_UPDATE

		ld a, (MAINMENU_FIRST_OPTION + 1)	; Fijala
		jr @@MM_UPDATE

		; Si se pulsa abajo
		@@MM_DOWN:
		ld a, [SYSKEY_DOWN]
		and $02								; Detecta "KEY DOWN"
		jr z, @@MM_ACCEPT

		ld a, [MAINMENU_ITEM_SELECTED]		; Carga la opcion actual
		inc a								; Suma una opcion
		cp MAINMENU_LAST_OPTION				; Si es la ultima
		jp nz, @@MM_UPDATE

		ld a, (MAINMENU_LAST_OPTION - 1)	; Fijala
		

		; Actualiza el cursor si es necesario
		@@MM_UPDATE:
		ld [MAINMENU_ITEM_SELECTED], a		; Guarda los datos del cursor
		call @@PRINT_CURSOR					; Imprime su posicion actualizada


		; Fin de las rutinas del menu, aceptacion de la opcion
		@@MM_ACCEPT:
		ld a, [SYSKEY_ACCEPT]
		and $02								; Detecta "KEY DOWN"
		jp z, @@MM_END						; Salta si no se pulsa


		; Opcion aceptada
		ld a, [MAINMENU_ITEM_SELECTED]		; Lee la opcion seleccionada
		
		; Opcion 1
		cp 1
		jp z, FUNCTION_MAIN_MENU_SCREEN0	; Ejecuta la opcion
		; Opcion 2
		cp 2
		jp z, FUNCTION_MAIN_MENU_SCREEN1	; Ejecuta la opcion
		; Opcion 3
		cp 3
		jp z, FUNCTION_MAIN_MENU_SCREEN2	; Ejecuta la opcion
		; Opcion 4
		cp 4
		jp z, FUNCTION_MAIN_MENU_SCREEN3	; Ejecuta la opcion
		; Opcion 5
		cp 5
		jp z, FUNCTION_MAIN_MENU_SPRITES	; Ejecuta la opcion
		; Opcion 6
		cp 6
		jp z, FUNCTION_MAIN_MENU_KEYBOARD	; Ejecuta la opcion
		; Opcion 7
		cp 7
		jp z, FUNCTION_MAIN_MENU_JOYSTICK	; Ejecuta la opcion
		; Opcion 8
		cp 8
		jp z, FUNCTION_MAIN_MENU_PSG		; Ejecuta la opcion
		; Opcion 0
		cp 9
		ret z								; Sal del programa


		; ----------------------------------------------------------
		;  Fin del menu
		; ----------------------------------------------------------

		; Espera a la interrupcion del VDP (VSYNC)
		@@MM_END:
		halt	; Espera a la interrupcion del VDP

		; Repite el bucle
		jp @@LOOP



	; ----------------------------------------------------------
	;  Actualiza la posicion del cursor en la pantalla
	; ----------------------------------------------------------	
	@@PRINT_CURSOR:
		; Borra el cursor de su posicion actual
		ld h, $02							; Posicion X
		ld a, [MAINMENU_ITEM_OLD]			; Lee la posicion del borrado
		add MAINMENU_ITEM_START				; Asignale el offset de la Y
		ld l, a
		call NGN_TEXT_POSITION				; Coloca el cursor
		ld hl, TEXT_MAIN_MENU_ITEM_OFF		; Lee el espacio en blanco
		call NGN_TEXT_PRINT					; Y escribelo
		; Imprime el cursor en su nueva posicion
		ld h, $02							; Posicion X
		ld a, [MAINMENU_ITEM_SELECTED]		; Lee la posicion Y de escritura
		add MAINMENU_ITEM_START				; Asignale el offset de la Y
		ld l, a
		call NGN_TEXT_POSITION				; Coloca el cursor
		ld hl, TEXT_MAIN_MENU_ITEM_ON		; Lee el caracter del cursor
		call NGN_TEXT_PRINT					; Y escribelo
		; Guarda la coordenada de borrado
		ld a, [MAINMENU_ITEM_SELECTED]
		ld [MAINMENU_ITEM_OLD], a
		; Vuelve
		ret



; ----------------------------------------------------------
; Ejecuta la opcion SCREEN0_TEST
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_SCREEN0:

	; Llama la funcion correspondiente
	call FUNCTION_SCREEN0_TEST_MENU
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	jp FUNCTION_MAIN_MENU



; ----------------------------------------------------------
; Ejecuta la opcion SCREEN1_TEST
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_SCREEN1:

	; Llama la funcion correspondiente
	call FUNCTION_SCREEN1_TEST_MENU
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	jp FUNCTION_MAIN_MENU



; ----------------------------------------------------------
; Ejecuta la opcion SCREEN2_TEST
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_SCREEN2:

	; Llama la funcion correspondiente
	call FUNCTION_SCREEN2_TEST_MENU
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	jp FUNCTION_MAIN_MENU



; ----------------------------------------------------------
; Ejecuta la opcion SCREEN3_TEST
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_SCREEN3:

	; Llama la funcion correspondiente
	call FUNCTION_SCREEN3_TEST_MENU
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	jp FUNCTION_MAIN_MENU



; ----------------------------------------------------------
; Ejecuta la opcion SPRITES_TEST
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_SPRITES:

	; Llama la funcion correspondiente
	call FUNCTION_SPRITES_TEST_MENU
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	jp FUNCTION_MAIN_MENU



; ----------------------------------------------------------
; Ejecuta la opcion KEYBOARD_TEST
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_KEYBOARD:

	; Llama la funcion correspondiente
	call FUNCTION_KEYBOARD_TEST_MENU
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	jp FUNCTION_MAIN_MENU



; ----------------------------------------------------------
; Ejecuta la opcion JOYSTICK_TEST
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_JOYSTICK:

	; Llama la funcion correspondiente
	call FUNCTION_JOYSTICK_TEST_MENU
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	jp FUNCTION_MAIN_MENU



; ----------------------------------------------------------
; Ejecuta la opcion PSG
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_PSG:

	; Llama la funcion correspondiente
	call FUNCTION_PSG_TEST_MENU
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	jp FUNCTION_MAIN_MENU



;***********************************************************
; Fin del archivo
;***********************************************************
MAIN_MENU_EOF: