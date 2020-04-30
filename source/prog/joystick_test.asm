;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.8
;	ASM Z80 MSX
;	Test de los Joysticks
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Menu del Test JOYSTICK
; ----------------------------------------------------------

FUNCTION_JOYSTICK_TEST_MENU:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Texto del menu
	call FUNCTION_MAIN_MENU_HEADER_PRINT		; Cabecera
	ld hl, $0104								; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
	ld hl, TEXT_JOYSTICK_MENU_TITLE				; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_JOYSTICK_MENU_INSTRUCTIONS		; Instrucciones de uso
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
		jp nz, FUNCTION_JOYSTICK_TEST_RUN		; Ejecuta el test si se pulsa

		; Si se pulsa la tecla "CANCEL"
		ld a, [SYSKEY_CANCEL]
		and $02					; Detecta "KEY DOWN"
		ret nz					; Vuelve al menu principal si se pulsa

		; Espera a la interrupcion del VDP (VSYNC)
		halt

		; Repite el bucle
		jr @@LOOP



; ----------------------------------------------------------
; Ejecuta el test
; ----------------------------------------------------------

FUNCTION_JOYSTICK_TEST_RUN:

	; Fuerza recargar el modo 0 al volver al menu
	ld a, 1
	ld [FORCE_SET_SCREEN_0], a

	; Pon la VDP en MODO SCR2
	ld bc, $0F01			; Color de frente/fondo
	ld de, $0100			; Color de borde/sin uso
	call NGN_SCREEN_SET_MODE_2

	; Carga la imagen de fondo
	ld hl, BG_JOYTEST_IMAGE		; Direccion de la imagen
	call NGN_BACKGROUND_CREATE_RLE	; Crea el fondo y mandalo a la VRAM

	; Ejecuta la rutina [DISSCR]
	call $0041

	; Reinicia el sistema de sprites
	call NGN_SPRITE_RESET
	; Modo de sprites 16x16 sin double
	call NGN_SPRITE_MODE_16x16

	; Carga el grafico del sprite en el slot 0
	ld b, 0
	ld hl, SPR_JOYTEST_SPRITE
	call NGN_SPRITE_LOAD_DATA

	; Joy 1
	; Crea el sprite P1 UP [0]
	xor a						; Slot del sprite [A]
	ld de, $403F				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0001				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite
	; Crea el sprite P1 RIGHT [1]
	ld a, 1						; Slot del sprite [A]
	ld de, $5857				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0101				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite
	; Crea el sprite P1 DOWN [2]
	ld a, 2						; Slot del sprite [A]
	ld de, $406F				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0201				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite
	; Crea el sprite P1 LEFT [3]
	ld a, 3						; Slot del sprite [A]
	ld de, $2857				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0301				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite
	; Crea el sprite P1 TG1 [4]
	ld a, 4						; Slot del sprite [A]
	ld de, $308F				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0401				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite
	; Crea el sprite P1 TG2 [5]
	ld a, 5						; Slot del sprite [A]
	ld de, $508F				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0401				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite

	; Joy 2
	; Crea el sprite P2 UP [6]
	ld a, 6						; Slot del sprite [A]
	ld de, $B03F				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0001				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite
	; Crea el sprite P2 RIGHT [7]
	ld a, 7						; Slot del sprite [A]
	ld de, $C857				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0101				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite
	; Crea el sprite P2 DOWN [8]
	ld a, 8						; Slot del sprite [A]
	ld de, $B06F				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0201				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite
	; Crea el sprite P2 LEFT [9]
	ld a, 9						; Slot del sprite [A]
	ld de, $9857				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0301				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite
	; Crea el sprite P2 TG1 [10]
	ld a, 10					; Slot del sprite [A]
	ld de, $A08F				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0401				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite
	; Crea el sprite P2 TG2 [11]
	ld a, 11					; Slot del sprite [A]
	ld de, $C08F				; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0401				; Slot grafico [B] / Color de la paleta [C]
	call NGN_SPRITE_CREATE		; Genera el sprite

	; Actualiza los atributos de los sprites
	call NGN_SPRITE_UPDATE

	; Ejecuta la rutina [ENASCR]
	call $0044



	; ----------------------------------------------------------
	; Bucle principal
	; ----------------------------------------------------------

	@@LOOP:

		; Lee la entrada
		call FUNCTION_SYSTEM_HID_READ

		; Si se pulsa la tecla  "ESC"
		ld a, [NGN_KEY_ESC]
		and $02			; Detecta "KEY DOWN"
		ret nz			; Vuelve al menu principal si se pulsa

		; Si se pulsa el Joy1 UP
		ld a, [NGN_JOY1_UP]
		and $01			; Detecta "KEY HELD"
		jr z, @@NO_EXIT		; Si no se esta pulsando, salta
		; Si se pulsa el Joy1 TG1
		ld a, [NGN_JOY1_TG1]
		and $02			; Detecta "KEY DOWN"
		ret nz			; Vuelve al menu principal si se pulsa
		@@NO_EXIT:

		; Pulsacion UP Joy 1
		ld hl, NGN_SPRITE_00	; Apunta al sprite
		ld b, JOYTEST1_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY1_UP]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J1_UP	; Salta si no esta presionando
		ld b, JOYTEST1_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J1_UP:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color

		; Pulsacion RIGHT Joy 1
		ld hl, NGN_SPRITE_01	; Apunta al sprite
		ld b, JOYTEST1_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY1_RIGHT]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J1_RIGHT	; Salta si no esta presionando
		ld b, JOYTEST1_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J1_RIGHT:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color

		; Pulsacion DOWN Joy 1
		ld hl, NGN_SPRITE_02	; Apunta al sprite
		ld b, JOYTEST1_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY1_DOWN]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J1_DOWN	; Salta si no esta presionando
		ld b, JOYTEST1_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J1_DOWN:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color

		; Pulsacion LEFT Joy 1
		ld hl, NGN_SPRITE_03	; Apunta al sprite
		ld b, JOYTEST1_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY1_LEFT]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J1_LEFT	; Salta si no esta presionando
		ld b, JOYTEST1_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J1_LEFT:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color

		; Pulsacion TG1 Joy 1
		ld hl, NGN_SPRITE_04	; Apunta al sprite
		ld b, JOYTEST1_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY1_TG1]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J1_TG1	; Salta si no esta presionando
		ld b, JOYTEST1_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J1_TG1:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color

		; Pulsacion TG2 Joy 1
		ld hl, NGN_SPRITE_05	; Apunta al sprite
		ld b, JOYTEST1_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY1_TG2]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J1_TG2	; Salta si no esta presionando
		ld b, JOYTEST1_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J1_TG2:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color


		; Pulsacion UP Joy 2
		ld hl, NGN_SPRITE_06	; Apunta al sprite
		ld b, JOYTEST2_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY2_UP]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J2_UP	; Salta si no esta presionando
		ld b, JOYTEST2_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J2_UP:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color

		; Pulsacion RIGHT Joy 2
		ld hl, NGN_SPRITE_07	; Apunta al sprite
		ld b, JOYTEST2_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY2_RIGHT]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J2_RIGHT	; Salta si no esta presionando
		ld b, JOYTEST2_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J2_RIGHT:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color

		; Pulsacion DOWN Joy 2
		ld hl, NGN_SPRITE_08	; Apunta al sprite
		ld b, JOYTEST2_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY2_DOWN]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J2_DOWN	; Salta si no esta presionando
		ld b, JOYTEST2_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J2_DOWN:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color

		; Pulsacion LEFT Joy 2
		ld hl, NGN_SPRITE_09	; Apunta al sprite
		ld b, JOYTEST2_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY2_LEFT]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J2_LEFT	; Salta si no esta presionando
		ld b, JOYTEST2_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J2_LEFT:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color

		; Pulsacion TG1 Joy 2
		ld hl, NGN_SPRITE_10	; Apunta al sprite
		ld b, JOYTEST2_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY2_TG1]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J2_TG1	; Salta si no esta presionando
		ld b, JOYTEST2_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J2_TG1:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color

		; Pulsacion TG2 Joy 2
		ld hl, NGN_SPRITE_11	; Apunta al sprite
		ld b, JOYTEST2_COLOR_OFF ; Por defecto, color rojo
		ld a, [NGN_JOY2_TG2]	; Lee el estado
		and $01			; Filtra el estado "held"
		jp z, @@NO_J2_TG2	; Salta si no esta presionando
		ld b, JOYTEST2_COLOR_ON	; Si se ha presionado, color verde
		@@NO_J2_TG2:
		call NGN_SPRITE_COLOR	; Aplica el cambio de color


		; Actualiza los atributos de los sprites
		call NGN_SPRITE_UPDATE

		; Espera a la interrupcion del VDP (VSYNC)
		halt

		; Repite el bucle
		jp @@LOOP





;***********************************************************
; Fin del archivo
;***********************************************************
JOYSTICK_TEST_EOF: