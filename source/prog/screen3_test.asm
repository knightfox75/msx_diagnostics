;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.0-wip03
;	ASM Z80 MSX
;	Test SCREEN 3
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Menu del Test SCREEN 3
; ----------------------------------------------------------

FUNCTION_SCREEN3_TEST_MENU:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Texto del menu
	call FUNCTION_MAIN_MENU_HEADER_PRINT		; Cabecera
	ld hl, TEXT_SCREEN3_MENU_TITLE				; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_SCREEN3_MENU_INSTRUCTIONS		; Instrucciones de uso
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
		jp nz, FUNCTION_SCREEN3_TEST_RUN	; Ejecuta el test si se pulsa

		; Si se pulsa la tecla "CANCEL"
		ld a, [SYSKEY_CANCEL]
		and $02					; Detecta "KEY DOWN"
		ret nz					; Vuelve al menu principal si se pulsa

		; Espera a la interrupcion del VDP (VSYNC)
		ei		; Asegurate que las interrupciones estan habilitadas
		nop		; Espera el ciclo necesario para que se habiliten
		halt	; Espera a la interrupcion del VDP

		; Repite el bucle
		jr @@LOOP



; ----------------------------------------------------------
; Ejecuta el test
; ----------------------------------------------------------

FUNCTION_SCREEN3_TEST_RUN:

	; Pon la VDP en MODO SCR3
	ld bc, $0F01			; Color de frente/fondo
	ld de, $0100			; Color de borde/sin uso
	call NGN_SCREEN_SET_MODE_3

	; Rellena la tabla de nombres (mapa)
	ld hl, $0800			; Apunta a la tabla de nombres
	ld bc, $0300			; Longitud de 768 celdas
	xor a				; Pon A a 0
	call $0056			; Ejecuta la rutina [FILVRM]

	; Patron y color de borde
	ld bc, $0101

	; Genera el tileset para SCREEN 3
	push bc
	call FUNCTION_SCREEN3_CHANGE_PATTERN	; Cambialo
	pop bc

	; Bucle de ejecucion
	@@LOOP:

		; Lectura del HID
		push bc
		call FUNCTION_SYSTEM_HID_READ
		pop bc

		; Si se pulsa derecha, siguiente patron
		ld a, [SYSKEY_RIGHT]
		and $02				; Detecta "KEY DOWN"
		jp z, @@KEY_LEFT
		inc b				; Siguiente patron
		ld a, b
		cp SCR3TEST_LAST_PATTERN	; Si es superado el ultimo, vuelve al primero
		jp nz, @@NOT_LAST
		ld b, 1				; Reinicia al primero
		@@NOT_LAST:
		push bc				; Guarda los registros
		call FUNCTION_SCREEN3_CHANGE_PATTERN	; Cambia el patron
		pop bc				; Recupera los registros
		jr @@KEY_UP

		; Si se pulsa izquierda, patron  anterior
		@@KEY_LEFT:
		ld a, [SYSKEY_LEFT]
		and $02				; Detecta "KEY DOWN"
		jp z, @@KEY_UP
		dec b				; Siguiente patron
		ld a, b
		cp 0				; Si es superado el primero, vuelve al ultimo
		jp nz, @@NOT_FIRST
		ld b, SCR3TEST_LAST_PATTERN - 1	; Reinicia al primero
		@@NOT_FIRST:
		push bc				; Guarda los registros
		call FUNCTION_SCREEN3_CHANGE_PATTERN	; Cambia el patron
		pop bc				; Recupera los registros

		; Si se pulsa arriba, siguiente color
		@@KEY_UP:
			ld a, [SYSKEY_UP]		; Tecla UP
			and $02				; Detecta "KEY DOWN"
			jr z, @@KEY_DOWN
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
				jr @@LOOP_END

		; Si se pulsa abajo, color anterior
		@@KEY_DOWN:
			ld a, [SYSKEY_DOWN]		; Tecla DOWN
			and $02				; Detecta "KEY DOWN"
			jr z, @@LOOP_END
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

		; Parte final del LOOP
		@@LOOP_END:

		; Si se pulsa la tecla  "CANCELAR"
		ld a, [SYSKEY_CANCEL]
		and $02			; Detecta "KEY DOWN"
		ret nz			; Vuelve al menu principal si se pulsa

		; Espera a la interrupcion del VDP (VSYNC)
		ei		; Asegurate que las interrupciones estan habilitadas
		nop		; Espera el ciclo necesario para que se habiliten
		halt	; Espera a la interrupcion del VDP

		; Repite el bucle
		jp @@LOOP


	
; ----------------------------------------------------------
; Cambia el patron
; ----------------------------------------------------------

FUNCTION_SCREEN3_CHANGE_PATTERN:

	ld de, $0008
	xor a
	ld hl, SCREEN3_PATTERN

	@@LOOP:
		inc a
		cp b
		jr z, @@LOOP_EXIT
		add hl, de
		jr @@LOOP

	@@LOOP_EXIT:
	ld de, $0000			; Destino de los datos
	ld bc, $0008			; Cantidad de bytes a copiar
	call $005C			; Ejecuta la rutina [LDIRVM]
	ret				; Vuelve



;***********************************************************
; Fin del archivo
;***********************************************************
SCREEN3_TEST_EOF: