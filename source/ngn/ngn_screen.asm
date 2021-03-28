;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.3.4-alpha
;
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;	Rutinas de acceso al la pantalla
;
;***********************************************************


; ----------------------------------------------------------
; NGN_SCREEN_SET_MODE_0
; Inicializa la pantalla en modo SCREEN 0
; (SPRITES habilitados, 8x8 sin magnificar)
; B = Color de frente
; C = Color de fondo
; D = Color de borde (sin uso)
; E = Ancho de la pantalla en columnas
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_SCREEN_SET_MODE_0:

	; Guarda los parametros de la funcion
	push bc
	push de

	; Borra la pantalla (CLS)
	xor a
	call $00C3		; Borra la pantalla con la rutina [CLS] de la BIOS

	; Recupera los parametros de la funcion
	pop de
	pop bc

	; Ancho de la pantalla
	ld a, e
	ld [$F3AE], a		; Cambia el ancho en columnas de la pantalla [LINL40]

	; Color por defecto
	ld hl, NGN_COLOR_ADDR
	ld [hl], b		; Color de frente
	inc l
	ld [hl], c		; Color de fondo
	inc l
	ld [hl], 1		; Color del borde (Negro)
	call $0062		; Aplica el color con la rutina [CHGCLR] de la BIOS

	; Ajusta el VDP
	call UPDATE_SCREEN_VDP

	; Inicializa el VDP con la rutina [INITXT] de la BIOS
	jp $006C

	; El RET lo aplica la propia rutina de BIOS



; ----------------------------------------------------------
; NGN_SCREEN_SET_MODE_1
; Inicializa la pantalla en modo SCREEN 1
; (SPRITES habilitados, 8x8 sin magnificar)
; B = Color de frente
; C = Color de fondo
; D = Color de borde
; E = Ancho de la pantalla en columnas
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_SCREEN_SET_MODE_1:

	; Guarda los parametros de la funcion
	push bc
	push de

	; Borra la pantalla (CLS)
	xor a
	call $00C3		; Borra la pantalla con la rutina [CLS] de la BIOS

	; Recupera los parametros de la funcion
	pop de
	pop bc

	; Ancho de la pantalla
	ld a, e
	ld [$F3AF], a		; Cambia el ancho en columnas de la pantalla [LINL32]

	; Color por defecto
	ld hl, NGN_COLOR_ADDR
	ld [hl], b		; Color de frente
	inc l
	ld [hl], c		; Color de fondo
	inc l
	ld [hl], 1		; Color del borde (Negro)
	call $0062		; Aplica el color con la rutina [CHGCLR] de la BIOS

	; Ajusta el VDP
	call UPDATE_SCREEN_VDP

	; Inicializa el VDP con la rutina [INIT32] de la BIOS
	jp $006F

	; El RET lo aplica la propia rutina de BIOS



; ----------------------------------------------------------
; NGN_SCREEN_SET_MODE_2
; Inicializa la pantalla en modo SCREEN 2
; (SPRITES habilitados, 8x8 sin magnificar)
; B = Color de frente
; C = Color de fondo
; D = Color de borde
; E = Sin uso
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_SCREEN_SET_MODE_2:

	; Guarda los parametros de la funcion
	push bc
	push de

	; Borra la pantalla (CLS)
	xor a
	call $00C3		; Borra la pantalla con la rutina [CLS] de la BIOS

	; Recupera los parametros de la funcion
	pop de
	pop bc

	; Color por defecto
	ld hl, NGN_COLOR_ADDR
	ld [hl], b		; Color de frente (Blanco)
	inc l
	ld [hl], c		; Color de fondo (Negro)
	inc l
	ld [hl], d		; Color del borde (Negro)
	call $0062		; Aplica el color con la rutina [CHGCLR] de la BIOS

	; Ajusta el VDP
	call UPDATE_SCREEN_VDP

	; Inicializa el VDP con la rutina [INIGRP] de la BIOS
	jp $0072

	; El RET lo aplica la propia rutina de BIOS




; ----------------------------------------------------------
; NGN_SCREEN_SET_MODE_3
; Inicializa la pantalla en modo SCREEN 3
; (SPRITES habilitados, 8x8 sin magnificar)
; B = Color de frente
; C = Color de fondo
; D = Color de borde
; E = Sin uso
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_SCREEN_SET_MODE_3:

	; Guarda los parametros de la funcion
	push bc
	push de

	; Borra la pantalla (CLS)
	xor a
	call $00C3		; Borra la pantalla con la rutina [CLS] de la BIOS

	; Recupera los parametros de la funcion
	pop de
	pop bc

	; Color por defecto
	ld hl, NGN_COLOR_ADDR
	ld [hl], b		; Color de frente (Blanco)
	inc l
	ld [hl], c		; Color de fondo (Negro)
	inc l
	ld [hl], d		; Color del borde (Negro)
	call $0062		; Aplica el color con la rutina [CHGCLR] de la BIOS

	; Ajusta el VDP
	call UPDATE_SCREEN_VDP

	; Inicializa el VDP con la rutina [INIMLT] de la BIOS
	jp $0075

	; El RET lo aplica la propia rutina de BIOS





; ----------------------------------------------------------
; NGN_SCREEN_KEYS_ON
; Muestra las teclas de funcion en pantalla
; Modifica todos los registros
; ----------------------------------------------------------

NGN_SCREEN_KEYS_ON:

	; Muestra las teclas de funcion llamando a la funcion de la BIOS [DSPFNK]
	jp $00CF

	; El RET lo aplica la propia rutina de BIOS





; ----------------------------------------------------------
; NGN_SCREEN_KEYS_OFF
; Oculta las teclas de funcion en pantalla
; Modifica todos los registros
; ----------------------------------------------------------

NGN_SCREEN_KEYS_OFF:

	; Oculta las teclas de funcion llamando a la funcion de la BIOS [ERAFNK]
	jp $00CC

	; El RET lo aplica la propia rutina de BIOS





; ----------------------------------------------------------
; Ajusta los parametros por defecto del VDP
; Modifica A, BC
; ----------------------------------------------------------

UPDATE_SCREEN_VDP:

	di			; Deshabilita las interrupciones

	; Address ... 057FH (from 0047H)
	; Name ...... WRTVDP (Write to VDP Register)
	; Input ..... B=Data byte, C=VDP Mode Register number
	; Exit ...... None
	; Modifies .. AF, B, EI

	;	M1	M2	M3	M4	M5	Mode		MSX Version	BASIC Screen
	;      --------------------------------------------------------------------------------------
	;	0	0	0	0	0	32x24 Text	1 2 2+ tR	1
	;	1	0	0	0	0	40x24 Text	1 2 2+ tR	0
	;	1	0	0	1	0	80x24 Text	  2 2+ tR	0
	;	0	1	0	0	0	Multicolour	1 2 2+ tR	3
	;	0	0	1	0	0	Graphics 1	1 2 2+ tR	2
	;	0	0	0	1	0	Graphics 2	  2 2+ tR	4
	;	0	0	1	1	0	Graphics 4	  2 2+ tR	5
	;	0	0	0	0	1	Graphics 5	  2 2+ tR	6
	;	0	0	1	0	1	Graphics 6	  2 2+ tR	7
	;	0	0	1	1	1	Graphics 7	  2 2+ tR	8

	; Modifica el registro 0 del VDP
	; BIT 0		The External VDP (EV) bit determines whether external VDP input is to be enabled or disabled: 0=Disabled, 1=Enabled.
	; BIT 1		The M3, one of the five VDP mode Selection bits that define the VDP display mode.
	; BIT 2		The M4, one of the five VDP mode Selection bits that define the VDP display mode.
	; BIT 3		The M5, one of the five VDP mode Selection bits that define the VDP display mode.
	; BIT 4		The Interruption Enable 1 (IE1) bit, when set to "1", enables the line interruption.
	; BIT 5		The Interruption Enable 2 (IE2) bit, when set to "1", enables light-pen interruption.
	; BIT 6		The Digitizer (DG) bit, when set to "1", enables the colour bus input mode, capturing data into the VRAM.
	; BIT 7		Always 0

	ld bc, $0200		; B = 00000010	C = VDP REG 0
	call $0047			; [WRTVDP]

	; Modifica el registro 1 del VDP
	; BIT 0		The Magnification (Mag) bit determines whether sprites will be normal or doubled in size: 0=Normal, 1=Doubled.
	; BIT 1		The Size bit determines whether each sprite pattern will be 8x8 bits or 16x16 bits: 0=8x8, 1=16x16.
	; BIT 2		Always 0
	; BIT 3		The M2, one of the five VDP mode Selection bits that define the VDP display mode.
	; BIT 4		The M1, one of the five VDP mode Selection bits that define the VDP display mode.
	; BIT 5		The Interrupt Enable bit enables or disables the interrupt output signal from the VDP: 0=Disable, 1=Enable.
	; BIT 6		The Blank bit is used to enable or disable the entire video display: 0=Disable, 1=Enable.
	; BIT 7		The 4/16K bit alters the VDP VRAM addressing characteristics to suit either 4 KB or 16 KB chips: 0=4 KB, 1=16 KB.

	ld bc, $E001		; B = 11100000	C = VDP REG 1
	call $0047			; [WRTVDP]

	ei			; Habilita las interrupciones

	; Sal de la subrutina
	ret



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_SCREEN_EOF: