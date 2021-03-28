;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.3.4-alpha
;
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;	Inicializacion de la libreria
;
;***********************************************************



; ----------------------------------------------------------
; NGN_START
; Inicializa la libreria
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_START:

	; Espera a que se limpien las interrupciones iniciales
	call NGN_WAIT_FOR_START_UP_INTERRUPTS

	; Habilita el parche de las interrupciones
	call NGN_SYSTEM_FD9A_PATCH_ON

	; Inicializa las variables
	call @@INIT_VARIABLES

	; Inicializa el PSG
	call NGN_PSG_INIT

	; Deshabilita el sonido del teclado
	xor a				; Fuerza a que A sea 0
	ld [$F3DB], a		; [CLIKSW]

	; Sal de la rutina
	@@END:
	ret



; ----------------------------------------------------------
; Inicializa las variables
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

@@INIT_VARIABLES:

	; Teclas
	ld hl, NGN_KEY_0				; Puntero donde esta la primera tecla
	ld b, NGN_TOTAL_KEYS			; Numero de teclas a reiniciar
	@@RESET_KEYS:			
		xor a						; Registro A a 0
		ld [hl], a					; Borra el contenido de la tecla
		inc hl						; Siguiente tecla
		djnz @@RESET_KEYS			; Repite el proceso
	
	; Joysticks
	ld hl, NGN_JOY1_UP				; Puntero donde esta la primera tecla de joystick
	ld b, NGN_TOTAL_JOYKEYS			; Numero de teclas a reiniciar
	@@RESET_JOYKEYS:			
		xor a						; Registro A a 0
		ld [hl], a					; Borra el contenido de la tecla
		inc hl						; Siguiente tecla
		djnz @@RESET_JOYKEYS		; Repite el proceso

	; Atributos de sprites (0-31)
	call $0069						; Borra los sprites con la rutina [CLRSPR] de la BIOS
	ld hl, NGN_SPRATR				; Puntero a la tabla de sprites en VRAM
	ld de, NGN_SPRITE_00			; Puntero al primer sprite en RAM
	ld bc, $0080					; 128 bytes de datos (32*4)
	call $0059						; Ejecuta la rutina [LDIRMV] (Mueve datos de VRAM a RAM)

	; Random Seed
	ld a, 13
	ld [NGN_RANDOM_SEED], a

	; Vuelve
	ret



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_START_EOF: