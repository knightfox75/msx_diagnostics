;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.9
;	ASM Z80 MSX
;	Test SCREEN 2
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Menu del Test SCREEN 2
; ----------------------------------------------------------

FUNCTION_SCREEN2_TEST_MENU:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Texto del menu
	call FUNCTION_MAIN_MENU_HEADER_PRINT		; Cabecera
	ld hl, $0104								; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
	ld hl, TEXT_SCREEN2_MENU_TITLE				; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_SCREEN2_MENU_INSTRUCTIONS		; Instrucciones de uso
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

		; Si se pulsa la tecla "ACCEPT"
		ld a, [SYSKEY_ACCEPT]
		and $02					; Detecta "KEY DOWN"
		jp nz, FUNCTION_SCREEN2_TEST_RUN	; Ejecuta el test si se pulsa

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

FUNCTION_SCREEN2_TEST_RUN:

	; Fuerza recargar el modo 0 al volver al menu
	ld a, 1
	ld [FORCE_SET_SCREEN_0], a

	; Pon la VDP en MODO SCR2
	ld bc, $0F01			; Color de frente/fondo
	ld de, $0100			; Color de borde/sin uso
	call NGN_SCREEN_SET_MODE_2

	; Registro BC para nº de fondo / color de borde
	ld bc, $0101

	; Carga al primera imagen
	push bc
	call FUNCTION_SCREEN2_TEST_LOAD_IMAGE
	pop bc



; ----------------------------------------------------------
; Cambia las imagenes/color segun las teclas
; ----------------------------------------------------------

	; Bucle de ejecucion
	@@LOOP:

		; Lectura del HID
		push bc
		call FUNCTION_SYSTEM_HID_READ
		pop bc

		; Siguiente imagen
		ld a, [SYSKEY_RIGHT]		; Tecla RIGHT
		and $02				; Detecta "KEY DOWN"
		jr z, @@IMG_BACK
			; Suma 1
			inc b
			ld a, b		; Si has superado la ultima imagen
			cp SCR2TEST_LAST_IMAGE
			jr nz, @@IMG_NEXT_LOAD
			ld b, (SCR2TEST_FIRST_IMAGE + 1)		; Pon la primera imagen
			@@IMG_NEXT_LOAD:
			push bc
			call FUNCTION_SCREEN2_TEST_LOAD_IMAGE
			pop bc
			jp @@LOOP_END

		; Imagen anterior
		@@IMG_BACK:
			ld a, [SYSKEY_LEFT]		; Tecla LEFT
			and $02				; Detecta "KEY DOWN"
			jr z, @@COLOR_NEXT
				; Resta 1
				dec b
				ld a, b		; Si has superado la primera imagen
				cp SCR2TEST_FIRST_IMAGE
				jr nz, @@IMG_BACK_LOAD
				ld b, (SCR2TEST_LAST_IMAGE - 1)		; Pon la ultima imagen
				@@IMG_BACK_LOAD:
				push bc
				call FUNCTION_SCREEN2_TEST_LOAD_IMAGE
				pop bc
				jp @@LOOP_END

		; Siguiente color
		@@COLOR_NEXT:
			ld a, [SYSKEY_UP]		; Tecla UP
			and $02				; Detecta "KEY DOWN"
			jr z, @@COLOR_BACK
				; Suma 1
				inc c
				ld a, c		; Si has superado el ultimo color
				cp 16
				jr nz, @@COLOR_UP_CHANGE
				ld c, 1		; Primer color (negro)
				; Aplica el cambio de color
				@@COLOR_UP_CHANGE:
				push bc
				ld hl, NGN_COLOR_ADDR
				inc l
				inc l
				ld [hl], c		; Color del borde (Negro)
				call $0062		; Aplica el color con la rutina [CHGCLR] de la BIOS
				pop bc
				jp @@LOOP_END

		; Color anterior
		@@COLOR_BACK:
			ld a, [SYSKEY_DOWN]		; Tecla DOWN
			and $02				; Detecta "KEY DOWN"
			jr z, @@CHECK_EXIT
				; Resta 1
				dec c
				ld a, c		; Si has superado el primer color
				cp 0
				jr nz, @@COLOR_DOWN_CHANGE
				ld c, 15	; Ultimo color (blanco)
				; Aplica el cambio de color
				@@COLOR_DOWN_CHANGE:
				push bc
				ld hl, NGN_COLOR_ADDR
				inc l
				inc l
				ld [hl], c		; Color del borde (Negro)
				call $0062		; Aplica el color con la rutina [CHGCLR] de la BIOS
				pop bc

		
		; Procesos comunes del LOOP
		@@LOOP_END:

		; Si se pulsa la tecla  "CANCELAR"
		@@CHECK_EXIT:
		ld a, [SYSKEY_CANCEL]
		and $02			; Detecta "KEY DOWN"
		ret nz			; Vuelve al menu principal si se pulsa

		; Espera a la interrupcion del VDP (VSYNC)
		halt

		; Repite el bucle
		jp @@LOOP



; ----------------------------------------------------------
; Carga una imagen segun el registro B
; ----------------------------------------------------------

FUNCTION_SCREEN2_TEST_LOAD_IMAGE:

	; Guarda el registro actual de imagen/color
	push bc

	; Analiza el registro
	ld a, b

	; Img1
	cp 1
	jr nz, @@IMG2
	ld hl, BG_LINE_PATTERN_B_IMAGE		; Direccion de la imagen
	jp @@IMG_LOAD

	; Img2
	@@IMG2:
	cp 2
	jr nz, @@IMG3
	ld hl, BG_LINE_PATTERN_W_IMAGE		; Direccion de la imagen
	jp @@IMG_LOAD

	; Img3
	@@IMG3:
	cp 3
	jr nz, @@IMG4
	ld hl, BG_COLOR_BARS_IMAGE		; Direccion de la imagen
	jp @@IMG_LOAD

	; Img4 (default if error)
	@@IMG4:
	ld hl, BG_HELLO_IMAGE			; Direccion de la imagen
	
	; Carga la imagen
	@@IMG_LOAD:
	call NGN_BACKGROUND_CREATE_RLE		; Crea el fondo y mandalo a la VRAM

	; Guarda el registro actual de imagen/color
	pop bc

	; Sal de la funcion
	ret



;***********************************************************
; Fin del archivo
;***********************************************************
SCREEN2_TEST_EOF: