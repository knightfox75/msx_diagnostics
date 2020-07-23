;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.2.0
;	ASM Z80 MSX
;	Menu Principal (Pagina 2)
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Funcion del Menu Principal (Pagina 2)
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_P2:

	; Valores iniciales
	ld a, [MAINMENU_LAST_ITEM]
	ld [MAINMENU_ITEM_SELECTED], a
	ld [MAINMENU_ITEM_OLD], a

	; Pon la VDP en MODO SCR0 si es necesario
	ld a, [FORCE_SET_SCREEN_0]		; Lee si hay que forzar poner el modo 0 de pantalla
	or a
	jr z, @@CLS_SCREEN
	ld bc, $0F04					; Color de frente/fondo
	ld de, $0128					; Color de borde/ancho en columnas (40)
	call NGN_SCREEN_SET_MODE_0
	; Tabla de caracteres personalizados
	call FUNCTION_SYSTEM_SCREEN0_CHARSET
	; Resetea el flag
	xor a
	ld [FORCE_SET_SCREEN_0], a
	jr @@DRAW_SCREEN

	; Borra la pantalla y pon el color adecuado
	@@CLS_SCREEN:
	call NGN_TEXT_CLS
	ld bc, $0F04
	call NGN_TEXT_COLOR

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	@@DRAW_SCREEN:
	call $0041

	; Texto del menu
	call FUNCTION_MAIN_MENU_HEADER_PRINT	; Cabecera del menu
	ld hl, $0104							; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
	ld hl, TEXT_MAIN_MENU_P2_TITLE			; Titulo de la pagina
	call NGN_TEXT_PRINT						; Imprimelo
	ld hl, TEXT_DASHED_LINE					; Linea
	call NGN_TEXT_PRINT						; Imprimelo
	ld hl, TEXT_MAIN_MENU_P2_ITEMS			; Items del menu
	call NGN_TEXT_PRINT						; Imprimelo
	call FUNCTION_MAIN_MENU_FOOTER_PRINT	; Instrucciones y pie del menu

	; Cursor
	call FUNCTION_MAIN_MENU_PRINT_CURSOR

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
		ld a, [NGN_KEY_1]								; Tecla 1
		and $02											; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_KEYBOARD				; Ejecuta la opcion

		; Si se pulsa la tecla 2
		ld a, [NGN_KEY_2]								; Tecla 2
		and $02											; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_JOYSTICK				; Ejecuta la opcion

		; Si se pulsa la tecla 3
		ld a, [NGN_KEY_3]								; Tecla 3
		and $02											; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_PSG					; Ejecuta la opcion

		; Si se pulsa la tecla 4
		ld a, [NGN_KEY_4]								; Tecla 4
		and $02											; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_MIXED_MODE			; Ejecuta la opcion

		; Si se pulsa la tecla 5
		ld a, [NGN_KEY_5]								; Tecla 5
		and $02											; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_SYSTEM_INFO			; Ejecuta la opcion

		; Si se pulsa la tecla 6
		ld a, [NGN_KEY_6]								; Tecla 6
		and $02											; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_RAM_LAYOUT			; Ejecuta la opcion
		
		; Si se pulsa la tecla 9
		ld a, [NGN_KEY_9]								; Tecla 9
		and $02											; Detecta "KEY DOWN"
		ret nz											; Reinicia el ordenador

		; Si se pulsa la tecla 0
		ld a, [NGN_KEY_0]								; Tecla 0
		and $02											; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_GOTO_PAGE1			; Ejecuta la opcion

		; Si se pulsa la tecla <=
		ld a, [SYSKEY_LEFT]								; Tecla <=
		and $02											; Detecta "KEY DOWN"
		jp nz, FUNCTION_MAIN_MENU_GOTO_PAGE1			; Ejecuta la opcion


		; ----------------------------------------------------------
		;  Seleccion por item seleccionado del menu
		; ----------------------------------------------------------

		; Si se pulsa arriba
		ld a, [SYSKEY_UP]
		and $02								; Detecta "KEY DOWN"
		jr z, @@MM_DOWN
		
		ld a, [MAINMENU_ITEM_SELECTED]		; Carga la opcion actual
		dec a								; Resta una opcion
		cp MAINMENU_FIRST_OPTION_P2			; Si es la primera
		jr nz, @@MM_UPDATE

		ld a, (MAINMENU_FIRST_OPTION_P2 + 1)	; Fijala
		jr @@MM_UPDATE

		; Si se pulsa abajo
		@@MM_DOWN:
		ld a, [SYSKEY_DOWN]
		and $02								; Detecta "KEY DOWN"
		jr z, @@MM_ACCEPT

		ld a, [MAINMENU_ITEM_SELECTED]		; Carga la opcion actual
		inc a								; Suma una opcion
		cp MAINMENU_LAST_OPTION_P2			; Si es la ultima
		jp nz, @@MM_UPDATE

		ld a, (MAINMENU_LAST_OPTION_P2 - 1)		; Fijala
		

		; Actualiza el cursor si es necesario
		@@MM_UPDATE:
		ld [MAINMENU_ITEM_SELECTED], a			; Guarda los datos del cursor
		call FUNCTION_MAIN_MENU_PRINT_CURSOR	; Imprime su posicion actualizada


		; Fin de las rutinas del menu, aceptacion de la opcion
		@@MM_ACCEPT:
		ld a, [SYSKEY_ACCEPT]
		and $02								; Detecta "KEY DOWN"
		jp z, @@MM_END						; Salta si no se pulsa


		; Opcion aceptada
		ld a, [MAINMENU_ITEM_SELECTED]				; Lee la opcion seleccionada
		
		; Opcion 1
		cp 1
		jp z, FUNCTION_MAIN_MENU_KEYBOARD			; Test del teclado
		; Opcion 2
		cp 2
		jp z, FUNCTION_MAIN_MENU_JOYSTICK			; Test de los joysticks
		; Opcion 3
		cp 3
		jp z, FUNCTION_MAIN_MENU_PSG				; Test del PSG
		; Opcion 4
		cp 4
		jp z, FUNCTION_MAIN_MENU_MIXED_MODE			; Test del mixed mode
		; Opcion 5
		cp 5
		jp z, FUNCTION_MAIN_MENU_SYSTEM_INFO		; Informacion del sistema
		; Opcion 6
		cp 6
		jp z, FUNCTION_MAIN_MENU_RAM_LAYOUT			; Disposicion de la RAM detectada
		; Opcion 7
		cp 7
		ret z										; Sal del programa (reinicia)
		; Opcion 8
		cp 8
		jp z, FUNCTION_MAIN_MENU_GOTO_PAGE1			; Pagina anteriro del menu (p1)

		; Error catastrofico (reinicia)
		ret



		; ----------------------------------------------------------
		;  Fin del menu
		; ----------------------------------------------------------

		; Espera a la interrupcion del VDP (VSYNC)
		@@MM_END:
		halt

		; Repite el bucle
		jp @@LOOP



; ----------------------------------------------------------
; Ejecuta la opcion KEYBOARD_TEST [1]
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_KEYBOARD:

	; Llama la funcion correspondiente
	call FUNCTION_KEYBOARD_TEST_MENU
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	ld a, 1
	ld [MAINMENU_LAST_ITEM], a
	jp FUNCTION_MAIN_MENU_P2



; ----------------------------------------------------------
; Ejecuta la opcion JOYSTICK_TEST [2]
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_JOYSTICK:

	; Llama la funcion correspondiente
	call FUNCTION_JOYSTICK_TEST_MENU
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	ld a, 2
	ld [MAINMENU_LAST_ITEM], a
	jp FUNCTION_MAIN_MENU_P2



; ----------------------------------------------------------
; Ejecuta la opcion PSG [3]
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_PSG:

	; Llama la funcion correspondiente
	call FUNCTION_PSG_TEST_MENU
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	ld a, 3
	ld [MAINMENU_LAST_ITEM], a
	jp FUNCTION_MAIN_MENU_P2



; ----------------------------------------------------------
; FUNCTION_MAIN_MENU_MIXED_MODE [4]
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_MIXED_MODE:

	; Llama la funcion correspondiente
	call FUNCTION_MIXED_MODE_TEST_MENU
	
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	ld a, 4
	ld [MAINMENU_LAST_ITEM], a
	jp FUNCTION_MAIN_MENU_P2



; ----------------------------------------------------------
; Ejecuta la opcion SYSTEM INFO [5]
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_SYSTEM_INFO:

	; Llama la funcion correspondiente
	call FUNCTION_SYSTEM_INFO
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	ld a, 5
	ld [MAINMENU_LAST_ITEM], a
	jp FUNCTION_MAIN_MENU_P2



; ----------------------------------------------------------
; FUNCTION_MAIN_MENU_RAM_LAYOUT [6]
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_RAM_LAYOUT:

	; Llama la funcion correspondiente
	call FUNCTION_MEMORY_REPORTS_PRINT_RAM_REPORT
	
	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	ld a, 6
	ld [MAINMENU_LAST_ITEM], a
	jp FUNCTION_MAIN_MENU_P2



; ----------------------------------------------------------
; Pagina anterior del menu (Pagina 1) [9]
; ----------------------------------------------------------

FUNCTION_MAIN_MENU_GOTO_PAGE1:

	; Deshabilita la pantalla para el cambio
	call $0041
	; Vuelve al menu
	ld a, (MAINMENU_FIRST_OPTION_P1 + 1)
	ld [MAINMENU_LAST_ITEM], a
	jp FUNCTION_MAIN_MENU_P1



;***********************************************************
; Fin del archivo
;***********************************************************
MAIN_MENU_P2_EOF: