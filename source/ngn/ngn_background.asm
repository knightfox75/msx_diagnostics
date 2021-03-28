;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.3.4-alpha
;
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;	Rutinas de creacion de fondos (SCREEN 2)
;
;***********************************************************



; ----------------------------------------------------------
; NGN_BACKGROUND_CREATE
; Carga una imagen y muestrala a la pantalla
; HL = Direccion de la imagen (Origen de los datos)
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_BACKGROUND_CREATE:

	; Guarda el puntero de los datos de la imagen
	push hl

	; Deshabilita la pantalla
	call $0041		; Ejecuta la rutina [DISSCR]

	; Borra la tabla de nombres (mapa) usando FILVRM
	; ----------------------------------------------------------
	; Address ... 0815H (from 0056H)
	; Name ...... FILVRM (Fill VRAM)
	; Input ..... A=Data byte, BC=Length, HL=VRAM address
	; Exit ...... None
	; Modifies .. AF, BC, EI
	; ----------------------------------------------------------
	
	ld hl, NGN_NAMTBL	; Apunta a la tabla de nombres
	ld bc, $0300		; Longitud de 768 celdas
	xor a				; Pon A a 0
	call $0056			; Ejecuta la rutina [FILVRM]

	; Copia los datos a la VRAM
	; ----------------------------------------------------------
	; Address ... 0744H (from 005CH)
	; Name ...... LDIRVM (Load, Increment and Repeat to VRAM from Memory)
	; Input ..... BC=Length, DE=VRAM address, HL=RAM address
	; Exit ...... None
	; Modifies .. AF, BC, DE, HL, EI
	; ----------------------------------------------------------

	; Recupera el puntero a los datos de la imagen
	pop hl

	; Copia el banco 1 de patterns
	ld de, NGN_CHRTBL				; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 2 de patterns
	ld de, NGN_CHRTBL + 2048		; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 3 de patterns
	ld de, NGN_CHRTBL + 4096		; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 1 de colors
	ld de, NGN_CLRTBL				; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 2 de colors
	ld de, NGN_CLRTBL + 2048		; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 3 de colors
	ld de, NGN_CLRTBL + 4096		; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 1 de names
	ld de, NGN_NAMTBL				; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 2 de names
	ld de, NGN_NAMTBL + 256			; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 3 de names
	ld de, NGN_NAMTBL + 512			; Destino de los datos
	call @@DATA_TO_VRAM


	; Habilita la pantalla
	jp $0044		; Ejecuta la rutina [ENASCR]

	; El RET lo aplica la propia rutina de BIOS



	; Rutina de carga de datos en VRAM desde la ROM/RAM
	@@DATA_TO_VRAM:

		ld b, [hl]			; Carga el tamaño de los datos
		inc hl
		ld c, [hl]
		inc hl
		push hl				; Guarda el puntero a los datos de la imagen
		push bc

		call $005C			; Ejecuta la rutina [LDIRVM]

		pop bc				; Recupera los parametros de la ultima imagen
		pop hl				
		add hl, bc			; Y actualiza el puntero

		ret					; Sal de la subrutina



; ----------------------------------------------------------
; NGN_BACKGROUND_CREATE_RLE
; Carga una imagen y muestrala a la pantalla
; HL = Direccion de la imagen (Origen de los datos)
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_BACKGROUND_CREATE_RLE:

	; Guarda el puntero de los datos de la imagen
	push hl

	; Deshabilita la pantalla
	call $0041		; Ejecuta la rutina [DISSCR]

	; Borra la tabla de nombres (mapa) usando FILVRM
	; ----------------------------------------------------------
	; Address ... 0815H (from 0056H)
	; Name ...... FILVRM (Fill VRAM)
	; Input ..... A=Data byte, BC=Length, HL=VRAM address
	; Exit ...... None
	; Modifies .. AF, BC, EI
	; ----------------------------------------------------------
	
	ld hl, NGN_NAMTBL	; Apunta a la tabla de nombres
	ld bc, $300			; Longitud de 768 celdas
	xor a				; Pon A a 0
	call $0056			; Ejecuta la rutina [FILVRM]

	; Copia los datos a la VRAM
	; ----------------------------------------------------------
	; Address ... 0744H (from 005CH)
	; Name ...... LDIRVM (Load, Increment and Repeat to VRAM from Memory)
	; Input ..... BC=Length, DE=VRAM address, HL=RAM address
	; Exit ...... None
	; Modifies .. AF, BC, DE, HL, EI
	; ----------------------------------------------------------


	; Recupera el puntero a los datos de la imagen
	pop hl

	; Copia el banco 1 de patterns
	ld de, NGN_CHRTBL				; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 2 de patterns
	ld de, NGN_CHRTBL + 2048		; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 3 de patterns
	ld de, NGN_CHRTBL + 4096		; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 1 de colors
	ld de, NGN_CLRTBL				; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 2 de colors
	ld de, NGN_CLRTBL + 2048		; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 3 de colors
	ld de, NGN_CLRTBL + 4096		; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 1 de names
	ld de, NGN_NAMTBL				; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 2 de names
	ld de, NGN_NAMTBL + 256			; Destino de los datos
	call @@DATA_TO_VRAM

	; Copia el banco 3 de names
	ld de, NGN_NAMTBL + 512			; Destino de los datos
	call @@DATA_TO_VRAM

	; Habilita la pantalla
	jp $0044		; Ejecuta la rutina [ENASCR]

	; El RET lo aplica la propia rutina de BIOS



	; Rutina de carga de datos en VRAM desde el RAM_BUFFER del RLE
	@@DATA_TO_VRAM:

		push de						; Guarda la direccion de destino en VRAM

		ld de, NGN_RAM_BUFFER		; Destino de los datos RLE
		call NGN_RLE_DECOMPRESS		; Descomprime los datos

		ld hl, NGN_RLE_NORMAL_SIZE	; Recupera el tamaño de los datos descomprimidos
		ld b, [hl]
		inc hl
		ld c, [hl]

		ld hl, NGN_RAM_BUFFER		; Puntero a los datos
		pop de						; Destino de los datos
		call $005C					; Ejecuta la rutina [LDIRVM]

		ld hl, NGN_RLE_COMPRESSED_SIZE	; Recupera el tamaño de los datos comprimidos
		ld b, [hl]
		inc hl
		ld c, [hl]

		ld hl, NGN_RLE_POINTER		; Recupera el puntero
		ld d, [hl]
		inc hl
		ld e, [hl]
		ld h, d
		ld l, e

		add hl, bc					; Y sumale el tamaño de los datos comprimidos

		ret							; Sal de la subrutina



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_BACKGROUND_EOF: