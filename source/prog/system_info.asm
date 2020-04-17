;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.1-WIP02
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
	; 		Modelo de MSX
	; ----------------------------------------------------------

	ld a, [$002D]		; Direccion del BIOS con el modelo
	
	; Seleccion del modelo de MSX
	or a	; 0
	jr nz, @@MODEL_MSX2
	ld hl, TEXT_SYSTEM_INFO_MSX1
	jr @@MODEL_SET

	@@MODEL_MSX2:
	cp 1
	jr nz, @@MODEL_MSX2PLUS
	ld hl, TEXT_SYSTEM_INFO_MSX2
	jr @@MODEL_SET

	@@MODEL_MSX2PLUS:
	cp 2
	jr nz, @@MODEL_MSXTR
	ld hl, TEXT_SYSTEM_INFO_MSX2PLUS
	jr @@MODEL_SET

 	@@MODEL_MSXTR:
	cp 3
	jr nz, @@MODEL_UNKNOW
	ld hl, TEXT_SYSTEM_INFO_MSXTR
	jr @@MODEL_SET

	@@MODEL_UNKNOW:
	ld hl, TEXT_SYSTEM_INFO_UNKNOW

	; Guarda el modelo de MSX
	@@MODEL_SET:
	ld [SYS_INFO_MODEL], hl



	; ----------------------------------------------------------
	; 		RAM
	; ----------------------------------------------------------

	ld hl, $FFFF
	ld [SYS_INFO_RAM], hl



	; ----------------------------------------------------------
	; 		VRAM
	; ----------------------------------------------------------

	ld a, [$FAFC]								; BIOS, tamaño de la VRAM
	and $06										; 0 0 0 0 0 X X 0
												;           | | 	00 -  16 kb
												;	        |  ---> 01 -  64 kb
												;            -----> 10 - 128 kb
												;					11 - 192 kb

	; 16kb
	;or a	; 0000
	jr nz, @@VRAM64
	ld hl, $0016
	jr @@VRAM_SET

	; 64kb
	@@VRAM64:
	cp 2	; 0010
	jr nz, @@VRAM128
	ld hl, $0064
	jr @@VRAM_SET

	; 128kb
	@@VRAM128:
	cp 4	; 0100
	jr nz, @@VRAM192
	ld hl, $0128
	jr @@VRAM_SET

	; 192kb
	@@VRAM192:
	cp 6	; 0110
	jr nz, @@VRAM_UNKNOW
	ld hl, $0192
	jr @@VRAM_SET

	; Desconocido
	@@VRAM_UNKNOW:
	ld hl, $FFFF

	; Guarda el tamaño de la VRAM
	@@VRAM_SET:
	ld [SYS_INFO_VRAM], hl



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

	ld a, [VDP_TYPE_ID]							; Recupera el ID del VDP
	
	; Si es 0 - TMS9918A/28A/29A
	or a
	jr nz, @@V9938
	; Si es un TMS, selecciona el modelo segun el refresco detectado
	ld a, [VDP_HZ]
	or a
	jr nz, @@TMS9918A
	ld hl, TEXT_SYSTEM_INFO_TMS9929A			; TMS9929A
	jr @@VDP_SET
	@@TMS9918A:
	ld hl, TEXT_SYSTEM_INFO_TMS9918A			; TMS9918A/28A
	jr @@VDP_SET

	; Si es 1 - V9938
	@@V9938:
	cp 1
	jr nz, @@V9958
	ld hl, TEXT_SYSTEM_INFO_V9938				; V9938
	jr @@VDP_SET

	; Si es 2 - V9958
	@@V9958:
	cp 2
	jr nz, @@VDP_UNKNOW
	ld hl, TEXT_SYSTEM_INFO_V9958				; V9958
	jr @@VDP_SET

	; VDP desconocida
	@@VDP_UNKNOW:
	ld hl, TEXT_SYSTEM_INFO_UNKNOW				; Desconocida

	; Guarda el tipo de VDP instalado
	@@VDP_SET:
	ld [SYS_INFO_VDP], hl


	; HZ del VDP
	ld a, [VDP_HZ]

	; 50hz
	or a
	jr nz, @@VDP60HZ
	ld hl, $0050			; 50hz
	jr @@SET_HZ

	; 60hz
	@@VDP60HZ:
	ld hl, $0060			; 60hz

	; Guarda los HZ
	@@SET_HZ:
	ld [SYS_INFO_HZ], hl



	; ----------------------------------------------------------
	; 		Distribucion del teclado
	; ----------------------------------------------------------

	ld a, [KEYBOARD_LAYOUT]						; Distribucion

	; Japon
	or a	; 0
	jr nz, @@KB_INTERNATIONAL
	ld hl, TEXT_SYSTEM_INFO_KB_JAPAN
	jr @@KB_SET

	; Internacional
	@@KB_INTERNATIONAL:
	cp 1
	jr nz, @@KB_FRANCE
	ld hl, TEXT_SYSTEM_INFO_KB_INTERNATIONAL
	jr @@KB_SET

	; Francia
	@@KB_FRANCE:
	cp 2
	jr nz, @@KB_UK
	ld hl, TEXT_SYSTEM_INFO_KB_FRANCE
	jr @@KB_SET

	; UK
	@@KB_UK:
	cp 3
	jr nz, @@KB_GERMANY
	ld hl, TEXT_SYSTEM_INFO_KB_UK
	jr @@KB_SET

	; GERMANY
	@@KB_GERMANY:
	cp 4
	jr nz, @@KB_USSR
	ld hl, TEXT_SYSTEM_INFO_KB_GERMANY
	jr @@KB_SET

	; USSR
	@@KB_USSR:
	cp 5
	jr nz, @@KB_SPAIN
	ld hl, TEXT_SYSTEM_INFO_KB_USSR
	jr @@KB_SET

	; SPAIN
	@@KB_SPAIN:
	ld hl, TEXT_SYSTEM_INFO_KB_SPAIN

	; Guarda la distribucion
	@@KB_SET:
	ld [SYS_INFO_KB], hl



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
	; 		Informacion
	; ----------------------------------------------------------

	; Modelo de MSX
	ld hl, $0205
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_MSX_MODEL
	call NGN_TEXT_PRINT
	ld hl, [SYS_INFO_MODEL]
	call NGN_TEXT_PRINT
	; Distribucion de teclado
	ld hl, $1605
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_KEYBOARD
	call NGN_TEXT_PRINT
	ld hl, [SYS_INFO_KB]
	call NGN_TEXT_PRINT
	; Memoria RAM
	ld hl, $0207
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_RAM
	call NGN_TEXT_PRINT
	ld b, $00	; Valor de RAM
	ld hl, [SYS_INFO_RAM]
	ld c, h
	ld d, l
	call NGN_TEXT_PRINT_BCD
	ld hl, TEXT_SYSTEM_INFO_KB
	call NGN_TEXT_PRINT
	; Memoria VRAM
	ld hl, $1607
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_VRAM
	call NGN_TEXT_PRINT
	ld b, $00	; Valor de VRAM
	ld hl, [SYS_INFO_VRAM]
	ld c, h
	ld d, l
	call NGN_TEXT_PRINT_BCD
	ld hl, TEXT_SYSTEM_INFO_KB
	call NGN_TEXT_PRINT
	; VDP
	ld hl, $0209
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_VDP
	call NGN_TEXT_PRINT
	ld hl, [SYS_INFO_VDP]
	call NGN_TEXT_PRINT
	; VDP FREQUENCY
	ld hl, $1609
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_VDPFREQ
	call NGN_TEXT_PRINT
	ld b, $00	; Valor de Hercios
	ld hl, [SYS_INFO_HZ]
	ld c, h
	ld d, l
	call NGN_TEXT_PRINT_BCD
	ld hl, TEXT_SYSTEM_INFO_HZ
	call NGN_TEXT_PRINT



	; ----------------------------------------------------------
	; 		Pie de pagina
	; ----------------------------------------------------------

	ld hl, $0014
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_EXIT				; Cancelar para salir
	call NGN_TEXT_PRINT							; Imprimelo



	; ----------------------------------------------------------
	; 		Muestra la pagina
	; ----------------------------------------------------------

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