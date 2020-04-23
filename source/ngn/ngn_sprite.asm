;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.3.1
;
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;	Rutinas de sprites
;
;***********************************************************



; ----------------------------------------------------------
; NGN_SPRITE_MODE
; Cambia el modo de los Sprites
; NGN_SPR_8x8 NGN_SPR_8x8_D NGN_SPR_16x16 NGN_SPR_16x16_D
; Modifica A, BC
; ----------------------------------------------------------

; 8x8
NGN_SPRITE_MODE_8x8:
	ld a, [NGN_VDPR1]	; Consulta el valor del registro 1
	and $FC			; xxxxxx00
	jp @@SETUP_VDP

; 8x8_D
NGN_SPRITE_MODE_8x8_D:
	ld a, [NGN_VDPR1]	; Consulta el valor del registro 1
	and $FC			; xxxxxx00
	or $01			; xxxxxx01
	jp @@SETUP_VDP

; 16x16
NGN_SPRITE_MODE_16x16:
	ld a, [NGN_VDPR1]	; Consulta el valor del registro 1
	and $FC			; xxxxxx00
	or $02			; xxxxxx10
	jp @@SETUP_VDP

; 16x16_D
NGN_SPRITE_MODE_16x16_D:
	ld a, [NGN_VDPR1]	; Consulta el valor del registro 1
	or $03			; xxxxxx11

; Actualiza el VDP
@@SETUP_VDP:
	di				; Deshabilita las interrupciones
	ld b, a			; B = Valor a escribir en el registro del VDP
	ld c, $01		; C = Seleccion del registro
	call $0047		; [WRTVDP]	Escribe los datos
	ei				; Habilita las interrupciones
	ret



; ----------------------------------------------------------
; NGN_SPRITE_RESET
; Reinicia el sistema de sprites
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_SPRITE_RESET:

	call $0069					; Borra los sprites con la rutina [CLRSPR] de la BIOS
	ld hl, NGN_SPRATR			; Puntero a la tabla de sprites en VRAM
	ld de, NGN_SPRITE_00		; Puntero al primer sprite en RAM
	ld bc, $0080				; 128 bytes de datos (32*4)
	jp $0059					; Ejecuta la rutina [LDIRMV] (Mueve datos de VRAM a RAM)
	; El RET lo aplica la propia rutina de BIOS



; ----------------------------------------------------------
; NGN_SPRITE_UPDATE
; Actualiza los atributos de todos los sprites
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_SPRITE_UPDATE:

	ld hl, NGN_SPRITE_00		; Puntero al primer sprite en RAM
	ld bc, $0080				; 128 bytes de datos (32*4)
	ld de, NGN_SPRATR			; Puntero a la tabla de sprites en VRAM

	; Transfiere los datos a la VRAM (usando la BIOS)	
	jp $005C		; Ejecuta la rutina [LDIRVM]
					; HL Origen de los datos (RAM)
					; BC Cantidad de datos a transferir
					; DE Destino de los datos (VRAM)

	; El RET lo aplica la propia rutina de BIOS



; ----------------------------------------------------------
; NGN_SPRITE_LOAD_DATA
; Carga los graficos de un Sprite en la VRAM
; HL = Direccion de los CHR del Sprite (Origen de los datos)
; B = Nº de Slot (0-255) o (0-63)
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_SPRITE_LOAD_DATA:

	; Guarda el origen de los datos
	push hl

	; Posicion inicial
	ld hl, NGN_SPRTBL
	ld c, 0

	; Calcula el tamaño del slot
	ld a, [NGN_VDPR1]	; Consulta el modo actual de los sprites
	and $02
	jr nz, @@MODE_16
	ld de, $0008	; +8
	@@MODE_16:
	ld de, $0020	; +32

	; Busca el slot de destino
	@@SEARCH_SLOT:
		; Si ya estas en el slot correcto
		ld a, c
		cp b
		jr z, @@DATA_TO_VRAM
		; Añade el desplazamiento del tamaño del slot
		add hl, de
		; Conteo de slot
		inc c
		; Loop
		jr @@SEARCH_SLOT

	; Transfiere los datos a la VRAM
	@@DATA_TO_VRAM:
	ld d, h			; Direccion de destino (DE)
	ld e, l
	pop hl			; Recupera la posicion de los datos (HL)
	ld b, [hl]		; Tamaño de los datos a transferir (BC)
	inc hl
	ld c, [hl]
	inc hl			; Datos a transferir

	; Transfiere los datos a la VRAM (usando la BIOS)	
	jp $005C		; Ejecuta la rutina [LDIRVM]
					; HL Origen de los datos (RAM)
					; BC Cantidad de datos a transferir
					; DE Destino de los datos (VRAM)

	; El RET lo aplica la propia rutina de BIOS



; ----------------------------------------------------------
; NGN_SPRITE_CREATE
; Crea un Sprite los graficos cargados en la VRAM
; A = Nº de slot del Sprite (0-31)
; B = Nº de slot del grafico (0-255) o (0-63)
; C = Nº de color de la paleta 
; D = Coordenada X
; E = Coordenada Y
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_SPRITE_CREATE:

	; Guarda el numero de slot de Sprite
	push af

	ld a, [NGN_VDPR1]	; Consulta el modo actual de los sprites
	and $02
	jr z, @@SET_ATTRIB	; Si es modo 8x8, continua
	ld a, b			; Slot de graficos
	sla a			; Multiplicalo x4
	sla a
	ld b, a			; Actualiza el contenido


	; Guarda los atributos dados en el buffer
	@@SET_ATTRIB:
	pop af			; Recupera el numero de slot del sprite
	push bc			; Guarda BC (Slot grafico / Color)
	
	sla a			; Desplazamiento de 4 bytes * nº de slot de sprite
	sla a

	ld b, 0			; Prepara el offset
	ld c, a

	ld hl, NGN_SPRITE_00	; Puntero al primer sprite
	add hl, bc		; Posicionalo en el slot correcto (Inicial + offset)

	pop bc			; Recupera BC (Slot grafico / Color)

	ld [hl], e		; Posicion Y
	inc hl
	ld [hl], d		; Posicion X
	inc hl
	ld [hl], b		; nº Slot del grafico
	inc hl
	ld [hl], c		; nº de color de la paleta

	ret			; Sal de la funcion



; ----------------------------------------------------------
; NGN_SPRITE_POSITION
; Posiciona un Sprite en las coordenadas dadas
; HL = Direccion del sprite NGN_SPRITE_XX
; B = Coordenada X
; C = Coordenada Y
; Modifica BC, HL
; ----------------------------------------------------------

NGN_SPRITE_POSITION:

	; Actualiza los parametros
	ld [hl], c		; Y
	inc hl
	ld [hl], b		; X
	
	ret			; Sal de la funcion



; ----------------------------------------------------------
; NGN_SPRITE_COLOR
; Cambia el color de un Sprite
; HL = Direccion del sprite NGN_SPRITE_XX
; B = Color de la paleta (0-15)
; Modifica DE, HL
; ----------------------------------------------------------

NGN_SPRITE_COLOR:

	; Actualiza los parametros
	ld de, $0003
	add hl, de
	ld [hl], b

	ret			; Sal de la funcion



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_SPRITE_EOF: