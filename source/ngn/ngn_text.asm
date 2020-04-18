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
; NGN_TEXT_PRINT_BCD
; Imprime un numero en formato BCD
; BCD = Numero en formato BCD empaquetado
;
; 	B				C				D
;	0000	0000	0000	0000	0000	0000
;	||||	0-9		0-9		0-9		0-9		0-9
;	||||
;	|||| ----
;	|| ------|-->	Numero de ceros a mostrar (0 - 5)	
;	| -------
;	------------>	Muestra el signo (-)
;
;
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_TEXT_PRINT_BCD:

	; Signo	-				High	B
	bit 7, b
	jr z, @@DIGITS
	ld a, $2D
	call @@PRINT_DIGIT		; Imprimelo

	@@DIGITS:
	; Guarda el numero de ceros a imprimir
	ld a, b
	srl a						; Manda los bits a la parte baja >> 4
	srl a
	srl a
	srl a
	and 7						; Mascara de los 3 primeros bits
	ld [NGN_RAM_BUFFER], a		; Usa el primer bit del RAM_BUFFER para almacenar el valor
	
	; Decenas de millar		x____	Low		B
	ld e, b
	call @@LO_HALF
	; Unidades de millar	_x___	High	C
	ld e, c
	call @@HI_HALF
	; Centenas				__x__	Low		C
	ld e, c
	call @@LO_HALF
	; Decenas				___x_	High	D
	ld e, d
	call @@HI_HALF
	; Unidades				____x	Low 	D
	ld e, d
	call @@LO_HALF

	; Termina la rutina
	ret


	; Subrutina de impresion de los digitos

	@@HI_HALF:
		srl	e					; Desplaza 4 bits a la derecha
		srl e
		srl e
		srl e

	@@LO_HALF:
		ld a, [NGN_RAM_BUFFER]	; Recupera el numero de 0 pendientes
		or e					; OR logico del numero de ceros con el valor a imprimir
		and $0F					; Analiza solo los 4 bits bajos
		jr nz, @@DO_PRINT		; Si no es cero, o es cero y hay que imprimirlo...
		ret						; Vuelve si es cero y no hay que imprimirlo

		; Imprime el caracter en E
		@@DO_PRINT:
		ld a, e
		and $0F				; Bitmask de los bits menos significativos
		ld e, a				; Respalda el valor filtrado
		add a, $30			; Desplazamiento en la tabla ASCII hasta el 0
		call @@PRINT_DIGIT	; Imprimelo

		; Si es diferente de 0, marca que a partir de ahora se impriman los 0 que se encuentrenten
		ld a, e						; El ultimo valor mostrado
		or a						; era un 0?
		jr z, @@LAST_ZERO			; Descuenta uno al contador de zeros restantes
		ld a, 7						; Si no, muestra todos los 0 a partir de ahora
		ld [NGN_RAM_BUFFER], a		; Guardalo
		ret							; Vuelve

		; Resta un cero al contador
		@@LAST_ZERO:
		ld a, [NGN_RAM_BUFFER]
		dec a
		ld [NGN_RAM_BUFFER], a
		ret

		; Imprime el digito usando la rutina de la BIOS, preservando los registros
		@@PRINT_DIGIT:
		push bc
		push de
		call $00A2			; Imprime el caracter en A. Rutina [CHPUT] de la BIOS
		pop de
		pop bc
		ret




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