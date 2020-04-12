;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.2.1-WIP01
;
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;	Rutinas para la impresion de texto
;
;***********************************************************



; ----------------------------------------------------------
; NGN_TEXT_PRINT
; Imprime un texto en pantalla
; HL = Direccion del texto a imprimir (Origen de los datos)
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_TEXT_PRINT:

	@@WRITE_TEXT:

		ld a, [hl]		; Lee el caracter

		cp $00			; Si es el final del texto, sal
		ret z

		call $00A2		; Imprime el caracter. Rutina [CHPUT] de la BIOS

		inc hl			; Siguiente caracter

		jr @@WRITE_TEXT		; Repite el bucle



; ----------------------------------------------------------
; NGN_TEXT_POSITION
; Mueve el cabezal de escritura de texto
; H = Coordenada X del cursor
; L = Coordenada Y del cursor
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_TEXT_POSITION:

	jp $00C6;		; Rutina de BIOS [POSIT] (El RET lo aplica la propia rutina de BIOS)



; ----------------------------------------------------------
; NGN_TEXT_CLS
; Borra la pantalla
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_TEXT_CLS:

	xor a
	jp $00C3		; Borra la pantalla con la rutina [CLS] de la BIOS (El RET lo aplica la propia rutina de BIOS)



; ----------------------------------------------------------
; NGN_TEXT_COLOR
; B = Color del texto
; C = Color del fondo
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_TEXT_COLOR:

	ld hl, NGN_COLOR_ADDR
	ld [hl], b		; Color de frente
	inc l
	ld [hl], c		; Color de fondo
	jp $0062		; Aplica el color con la rutina [CHGCLR] de la BIOS (El RET lo aplica la propia rutina de BIOS)



; ----------------------------------------------------------
; NGN_TEXT_WIDTH
; A = Ancho del texto
; ----------------------------------------------------------

NGN_TEXT_WIDTH:

	ld [$F3AE], a		; Cambia el ancho en columnas de la pantalla [LINL40]
	ret



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_TEXT_EOF: