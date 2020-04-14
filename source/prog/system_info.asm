;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.0-wip03
;	ASM Z80 MSX
;	Informacion del sistema
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Informacion del sistema
; ----------------------------------------------------------

FUNCTION_SYSTEM_INFO:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041



	; ----------------------------------------------------------
	; 		Cabecera
	; ----------------------------------------------------------

	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_SYSTEM_INFO_TITLE				; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo



	; ----------------------------------------------------------
	; 		Modelo de MSX
	; ----------------------------------------------------------

	ld hl, TEXT_SYSTEM_INFO_MSX_MODEL			; Modelo
	call NGN_TEXT_PRINT							; Imprimelo

	ld a, [$002D]		; Direccion del BIOS con el modelo
	

	; Seleccion del modelo de MSX
	cp 0
	jr nz, @@MODEL_MSX2
	ld hl, TEXT_SYSTEM_INFO_MSX1
	jr @@PRINT_MSX_MODEL

	@@MODEL_MSX2:
	cp 1
	jr nz, @@MODEL_MSX2PLUS
	ld hl, TEXT_SYSTEM_INFO_MSX2
	jr @@PRINT_MSX_MODEL

	@@MODEL_MSX2PLUS:
	cp 2
	jr nz, @@MODEL_MSXTR
	ld hl, TEXT_SYSTEM_INFO_MSX2PLUS
	jr @@PRINT_MSX_MODEL

 	@@MODEL_MSXTR:
	cp 3
	jr nz, @@MODEL_UNKNOW
	ld hl, TEXT_SYSTEM_INFO_MSXTR
	jr @@PRINT_MSX_MODEL

	@@MODEL_UNKNOW:
	ld hl, TEXT_SYSTEM_INFO_MODEL_UNKNOW

	@@PRINT_MSX_MODEL:
	call NGN_TEXT_PRINT							; Imprimelo



	; ----------------------------------------------------------
	; 		Distribucion del teclado
	; ----------------------------------------------------------

	ld hl, TEXT_SYSTEM_INFO_KEYBOARD			; Distribucion del teclado
	call NGN_TEXT_PRINT							; Imprimelo

	ld a, [KEYBOARD_LAYOUT]						; Distribucion

	; Japon
	cp 0
	jr nz, @@KB_INTERNATIONAL
	ld hl, TEXT_SYSTEM_INFO_KB_JAPAN
	jr @@PRINT_KB_LAYOUT

	; Internacional
	@@KB_INTERNATIONAL:
	cp 1
	jr nz, @@KB_FRANCE
	ld hl, TEXT_SYSTEM_INFO_KB_INTERNATIONAL
	jr @@PRINT_KB_LAYOUT

	; Francia
	@@KB_FRANCE:
	cp 2
	jr nz, @@KB_UK
	ld hl, TEXT_SYSTEM_INFO_KB_FRANCE
	jr @@PRINT_KB_LAYOUT

	; UK
	@@KB_UK:
	cp 3
	jr nz, @@KB_GERMANY
	ld hl, TEXT_SYSTEM_INFO_KB_UK
	jr @@PRINT_KB_LAYOUT

	; GERMANY
	@@KB_GERMANY:
	cp 4
	jr nz, @@KB_USSR
	ld hl, TEXT_SYSTEM_INFO_KB_GERMANY
	jr @@PRINT_KB_LAYOUT

	; USSR
	@@KB_USSR:
	cp 5
	jr nz, @@KB_SPAIN
	ld hl, TEXT_SYSTEM_INFO_KB_USSR
	jr @@PRINT_KB_LAYOUT

	; SPAIN
	@@KB_SPAIN:
	ld hl, TEXT_SYSTEM_INFO_KB_SPAIN
	jr @@PRINT_KB_LAYOUT

	@@PRINT_KB_LAYOUT:
	call NGN_TEXT_PRINT							; Imprimelo




	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044

	; Bucle de ejecucion
	@@LOOP:

		; Lectura del HID
		call FUNCTION_SYSTEM_HID_READ

		; Si se pulsa la tecla  "ACEPTAR"
		ld a, [SYSKEY_ACCEPT]
		and $02								; Detecta "KEY DOWN"
		ret nz								; Vuelve al menu principal

		; Si se pulsa la tecla  "CANCELAR"
		ld a, [SYSKEY_CANCEL]
		and $02								; Detecta "KEY DOWN"
		ret nz								; Vuelve al menu principal

		; Espera a la interrupcion del VDP (VSYNC)
		ei		; Asegurate que las interrupciones estan habilitadas
		nop		; Espera el ciclo necesario para que se habiliten
		halt	; Espera a la interrupcion del VDP

		; Repite el bucle
		jr @@LOOP





;***********************************************************
; Fin del archivo
;***********************************************************
SYSTEM_INFO_EOF: