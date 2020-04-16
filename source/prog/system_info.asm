;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.1-WIP01
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
	ld hl, TEXT_SYSTEM_INFO_UNKNOW

	@@PRINT_MSX_MODEL:
	call NGN_TEXT_PRINT							; Imprimelo



	; ----------------------------------------------------------
	; 		VRAM
	; ----------------------------------------------------------

	ld hl, TEXT_SYSTEM_INFO_VRAM				; VRAM
	call NGN_TEXT_PRINT							; Imprimelo

	ld a, [$FAFC]								; BIOS, tamaño de la VRAM
	and $06										; 0 0 0 0 0 X X 0
												;           | |      00 -  16 kb
												;	        |  --->  01 -  64 kb
												;            ----->  10 - 128 kb

	; 16kb
	;or a	; 0000
	jr nz, @@VRAM64
	ld hl, TEXT_SYSTEM_INFO_N_16
	jr @@PRINT_VRAM

	; 64kb
	@@VRAM64:
	cp 2	; 0010
	jr nz, @@VRAM128
	ld hl, TEXT_SYSTEM_INFO_N_64
	jr @@PRINT_VRAM

	; 128kb
	@@VRAM128:
	cp 4	; 0100
	jr nz, @@VRAM_UNKNOW
	ld hl, TEXT_SYSTEM_INFO_N_128
	jr @@PRINT_VRAM

	; Desconocido
	@@VRAM_UNKNOW:
	ld hl, TEXT_SYSTEM_INFO_UNKNOW
	call NGN_TEXT_PRINT
	jr @@KEYBOARD_LAYOUT

	; Imprime el tamaño de la VRAM
	@@PRINT_VRAM:
	call NGN_TEXT_PRINT
	ld hl, TEXT_SYSTEM_INFO_KB
	call NGN_TEXT_PRINT



	; ----------------------------------------------------------
	; 	Identifica el VDP instalado		[VDP_TYPE_ID]
	;	
	;	0 - TMS9918A/28A/29A
	;	1 - V9938
	;	2 - V9958
	;	255 - Otros
	;
	; 	Y la frecuencia de refresco		[VDP_HZ]
	;
	;	0 - 50hz
	;	1 - 60hz
	;
	; ----------------------------------------------------------

	ld hl, TEXT_SYSTEM_INFO_VDP					; VDP
	call NGN_TEXT_PRINT							; Imprimelo

	ld a, [VDP_TYPE_ID]							; Recupera el ID del VDP
	
	; Si es 0 - TMS9918A/28A/29A
	or a
	jr nz, @@V9938
	; Si es un TMS, selecciona el modelo segun el refresco detectado
	ld a, [VDP_HZ]
	or a
	jr nz, @@TMS9918A
	ld hl, TEXT_SYSTEM_INFO_TMS9929A			; TMS9929A
	jr @@PRINT_VDP
	@@TMS9918A:
	ld hl, TEXT_SYSTEM_INFO_TMS9918A			; TMS9918A/28A
	jr @@PRINT_VDP

	; Si es 1 - V9938
	@@V9938:
	cp 1
	jr nz, @@V9958
	ld hl, TEXT_SYSTEM_INFO_V9938				; V9938
	jr @@PRINT_VDP

	; Si es 2 - V9958
	@@V9958:
	cp 2
	jr nz, @@VDP_UNKNOW
	ld hl, TEXT_SYSTEM_INFO_V9958				; V9958
	jr @@PRINT_VDP

	; VDP desconocida
	@@VDP_UNKNOW:
	ld hl, TEXT_SYSTEM_INFO_UNKNOW				; Desconocida

	; Imprime el tipo de VDP instalado
	@@PRINT_VDP:
	call NGN_TEXT_PRINT							; Imprimelo


	; HZ del VDP
	ld a, [VDP_HZ]

	; 50hz
	or a
	jr nz, @@VDP60HZ
	ld hl, TEXT_SYSTEM_INFO_50HZ				; 50hz
	jr @@PRINT_HZ

	; 60hz
	@@VDP60HZ:
	ld hl, TEXT_SYSTEM_INFO_60HZ				; 60hz

	; Imprime los HZ
	@@PRINT_HZ:
	call NGN_TEXT_PRINT							; Imprimelo


	; ----------------------------------------------------------
	; 		Distribucion del teclado
	; ----------------------------------------------------------

	@@KEYBOARD_LAYOUT:

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


	; ----------------------------------------------------------
	; 		Pie de pagina
	; ----------------------------------------------------------

	ld hl, TEXT_SYSTEM_INFO_EXIT	; Cancelar para salir
	call NGN_TEXT_PRINT				; Imprimelo


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
		call NGN_SCREEN_WAIT_VBL

		; Repite el bucle
		jr @@LOOP





;***********************************************************
; Fin del archivo
;***********************************************************
SYSTEM_INFO_EOF: