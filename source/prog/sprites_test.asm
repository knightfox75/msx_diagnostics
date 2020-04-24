;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.6
;	ASM Z80 MSX
;	Test de los Sprites (MODO SCREEN 2)
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Menu del Test SPRITES
; ----------------------------------------------------------

FUNCTION_SPRITES_TEST_MENU:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Texto del menu
	call FUNCTION_MAIN_MENU_HEADER_PRINT		; Cabecera
	ld hl, $0104								; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
	ld hl, TEXT_SPRITES_MENU_TITLE				; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_SPRITES_MENU_INSTRUCTIONS		; Instrucciones de uso
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
		jp nz, FUNCTION_SPRITES_TEST_RUN	; Ejecuta el test si se pulsa

		; Si se pulsa la tecla "CANCEL"
		ld a, [SYSKEY_CANCEL]
		and $02					; Detecta "KEY DOWN"
		ret nz					; Vuelve al menu principal si se pulsa

		; Espera a la interrupcion del VDP (VSYNC)
		halt

		; Repite el bucle
		jr @@LOOP



; ----------------------------------------------------------
; Ejecuta el test
; ----------------------------------------------------------

FUNCTION_SPRITES_TEST_RUN:

	; Pon la VDP en MODO SCR2
	ld bc, $0F01			; Color de frente/fondo
	ld de, $0100			; Color de borde/sin uso
	call NGN_SCREEN_SET_MODE_2

	; Reinicia el sistema de sprites
	call NGN_SPRITE_RESET
	; Modo de sprites 16x16 sin double
	call NGN_SPRITE_MODE_16x16

	; Carga el grafico del sprite en el slot 0
	ld b, 0
	ld hl, BALL_16X16_SPRITE
	call NGN_SPRITE_LOAD_DATA

	; Crea los sprites
	call FUNCTION_SPRITES_TEST_CREATE
	; Velocidades iniciales
	call FUNCTION_SPRITES_TEST_SET_SPEED

	; Control del programa
	ld b, 0


	; Bucle de ejecucion
	@@LOOP:

		push bc		; Guarda el estado

		; Lee la entrada
		call FUNCTION_SYSTEM_HID_READ

		; Reinicia la posicion de los sprites
		ld a, [SYSKEY_UP]
		and $02		; Detecta "KEY DOWN"
		jr z, @@MODE
		; Crea los sprites
		call FUNCTION_SPRITES_TEST_CREATE
		; Velocidades iniciales
		call FUNCTION_SPRITES_TEST_SET_SPEED

		; Decide el modo que estas
		@@MODE:
		pop bc				; Recupera el estado
		ld a, b				; Consulta el modo
		cp 0				; Si es 0, modo STANDBY
		jr nz, @@MOVE		; Si es 1, modo MOVE

		; Modo espera
		@@STANDBY:
		ld a, [SYSKEY_ACCEPT]		; Si se pulsa ACEPTAR, cambia el modo
		and $02						; Detecta "KEY DOWN"
		jr z, @@CANCEL				; Si no se ha pulsado, salta
		ld b, 1						; Cambia el modo
		jr @@CANCEL

		; Modo movimiento
		@@MOVE:
		push bc								; Guarda el estado
		call FUNCTION_SPRITES_TEST_MOVE		; Mueve los sprites
		call NGN_SPRITE_UPDATE				; Actualiza los sprites
		pop bc								; Recuperalo
		ld a, [SYSKEY_ACCEPT]				; Si se pulsa ACEPTAR, cambia el modo
		and $02								; Detecta "KEY DOWN"
		jr z, @@CANCEL						; Si no se ha pulsado, salta
		ld b, 0								; Cambia el modo
		jr @@CANCEL

		@@CANCEL:
		ld a, [SYSKEY_CANCEL]				; Si se pulsa "CANCELAR"
		and $02								; Detecta "KEY DOWN"
		ret nz								; Vuelve al menu principal si se pulsa

		; Espera el VSYNC
		halt

		; Repite el bucle
		jp @@LOOP



; ----------------------------------------------------------
; Crea los sprites
; ----------------------------------------------------------

FUNCTION_SPRITES_TEST_CREATE:

	; Genera 32 Sprites (Colores 2-15)
	xor a				; Slot del sprite [A] 0
	ld de, $1803		; Posicion del sprite [D = Pos X] [E = Pos Y]
	ld bc, $0002		; Slot grafico [B] / Color de la paleta [C]

	; Loop de generacion
	@@LOOP:

		push af				; Guarda los registros
		push bc
		push de

		call NGN_SPRITE_CREATE		; Genera el sprite

		pop de				; Recupera los registros
		pop bc
		
		ld a, d
		add $40				; X +64
		ld d, a

		jr nc, @@NEXT_COLOR		; Salta al siguiente sprite (X > 255)

		ld d, $18			; Reset de posicion X
		ld a, e
		add $18				; Y +24
		ld e, a

		@@NEXT_COLOR:
		inc c				; Siguiente color
		ld a, c
		cp 16				; Si has llegado al ultimo color, reinicia
		jr nz, @@NEXT_SPRITE
		ld c, 2

		@@NEXT_SPRITE:
		pop af				; Recupera el numero de sprite
		inc a				; Siguiente slot de sprite

		cp 32				; Si aun no has generado 32 sprites
		jp nz, @@LOOP		; Repite el bucle


	; Actualiza los atributos de los sprites
	call NGN_SPRITE_UPDATE

	; Sal de la funcion
	ret


; ----------------------------------------------------------
; Velocidades iniciales de los sprites
; ----------------------------------------------------------

FUNCTION_SPRITES_TEST_SET_SPEED:

	ld hl, NGN_RAM_BUFFER		; Variables (Usa el NGN_RAM_BUFFER para almacenar los valores)
	ld b, 0						; Contador

	; Loop
	@@LOOP:
		
		push bc		; Salva los registros alterados por el call NGN_SYSTEM_RANDOM_NUMBER
		push hl
		call NGN_SYSTEM_RANDOM_NUMBER
		pop hl		; Restaura los registros alterados por el call NGN_SYSTEM_RANDOM_NUMBER
		pop bc
		add 128
		jr nc, @@ZERO
		
		ld [hl], 1
		jr @@NEXT

		@@ZERO:
		ld [hl], 0

		@@NEXT:
		inc hl		; Siguiente variable
		inc b		; Siguiente interacion
		ld a, b
		cp 64
		jr nz, @@LOOP

	; Sal de la funcion
	ret



; ----------------------------------------------------------
; Mueve los sprites
; ----------------------------------------------------------

FUNCTION_SPRITES_TEST_MOVE:

	xor a						; Contador de sprites (0)
	ld bc, NGN_RAM_BUFFER			; Primera variable de velocidad
	ld de, NGN_SPRITE_00		; Primer sprite

	; Loop de movimiento
	@@LOOP:

		; Guarda el sprite actual
		push af

		; Eje Y
		ld a, [bc]				; Analiza si suma o resta
		or a
		jr z, @@ADD_Y			; Si es 0 Suma, si no resta

		; Resta en Y
		ld a, [de]				; Restale 1
		dec a
		ld [de], a
		or a					; Si llegas al limite, invierte la velocidad
		jr nz, @@AXIS_X			; Si no continua al eje X
		xor a
		ld [bc], a				; Guarda la inversion
		jr @@AXIS_X

		; Suma en Y
		@@ADD_Y:
		ld a, [de]				; Sumale 1
		inc a
		ld [de], a
		cp 175					; Si llegas al limite, invierte la velocidad
		jr nz, @@AXIS_X			; Si no continua al eje X
		ld a, 1
		ld [bc], a				; Guarda la inversion

		; Eje X
		@@AXIS_X:
		inc bc					; Velocidad X
		inc de					; Posicion X

		ld a, [bc]				; Analiza si suma o resta
		or a
		jr z, @@ADD_X			; Si es 0 Suma, si no resta

		; Resta en X
		ld a, [de]				; Restale 1
		dec a
		ld [de], a
		or a					; Si llegas al limite, invierte la velocidad
		jr nz, @@NEXT			; Si no continua al siguiente sprite
		xor a
		ld [bc], a				; Guarda la inversion
		jr @@NEXT

		; Suma en X
		@@ADD_X:
		ld a, [de]				; Sumale 1
		inc a
		ld [de], a
		cp 239					; Si llegas al limite, invierte la velocidad
		jr nz, @@NEXT			; Si no continua al siguiente sprite
		ld a, 1
		ld [bc], a				; Guarda la inversion

		; Siguiente Sprite
		@@NEXT:

		inc bc					; Siguiente Velocidad
		inc de					; Siguiente Sprite
		inc de
		inc de		

		pop af					; Recupera en numero de sprite
		inc a
		cp 32					; Si no has movido los 32 sprite, repite
		jp nz, @@LOOP


	; Sal de la funcion
	ret



;***********************************************************
; Fin del archivo
;***********************************************************
SPRITES_TEST_EOF: