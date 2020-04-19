;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.4
;	ASM Z80 MSX
;	Funciones comunes del sistema
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************





; ----------------------------------------------------------
; Valores iniciales del programa
; ----------------------------------------------------------

FUNCTION_SYSTEM_START:

	; Post	(3 pitidos con parpadeo del led CAPS)
	call FUNCTION_SYSTEM_POST

	; Identifica al VDP instalada
	call FUNCTION_SYSTEM_GET_VDP_TYPE

	; Inicializa la matriz del teclado
	call FUNCTION_SYSTEM_RESET_KEYBOARD_MATRIX

	; Tabla de nombres de las teclas
	call FUNCTION_SYSTEM_SET_KEY_NAMES_TABLE

	; Ultima opcion usada del menu
	ld a, (MAINMENU_FIRST_OPTION_P1 + 1)
	ld [MAINMENU_LAST_ITEM], a

	; Deshabilita la visualizacion de las teclas de funcion
	call NGN_SCREEN_KEYS_OFF

	; Fin de la funcion
	ret



; ----------------------------------------------------------
; Post del programa
; ----------------------------------------------------------
FUNCTION_SYSTEM_POST:

	ld b, 3					; Numero de pitidos/parpadeos
	ld d, 12				; Intervalo inicial
	@@POST_COUNT:
		push bc
		push de
		xor a
		call $0132			; Enciende el led CAPS con la rutina de BIOS [CHGCAP]
		call $00C0			; Emite un pitido con la rutina de BIOS [BEEP]
		pop de
		ld b, d
		@@WAIT_ON_LOOP:
			halt
			djnz @@WAIT_ON_LOOP
		ld a, $FF
		push de
		call $0132			; Apaga el led CAPS con la rutina de BIOS [CHGCAP]
		pop de
		ld b, d
		@@WAIT_OFF_LOOP:
			halt
			djnz @@WAIT_OFF_LOOP
		srl d				; Divide el intervalo entre 2
		pop bc
		djnz @@POST_COUNT

	ret		; Sal de la funcion





; ----------------------------------------------------------
; Inicializa la matriz del teclado
; ----------------------------------------------------------

FUNCTION_SYSTEM_RESET_KEYBOARD_MATRIX:

	; Variables del teclado del sistema
	ld hl, SYSKEY_UP
	ld b, $00

	;  Bucle de puesta a 0 de las variables
	@@LOOP:
		xor a		; Registro A a 0
		ld [hl], a	; Resetea el valor de la variable
		inc hl		; Siguiente variable
		inc b		; Contador del bucle
		ld a, b
		cp SYSTEM_KEYS_NUMBER	; Si se ha completado el bucle
		jr nz, @@LOOP

	; Sal de la subrutina
	ret





; ----------------------------------------------------------
; Apunta a la tabla de nombre de teclas correcta
; segun el idioma del teclado desde $002C
;
;	  7   6   5   4   3   2   1   0
;	+---+---+---+---+---------------+
;	|Cur|SRC|SLS|SSM| Keyboard Type |
;	+---+---+---+---+---------------+
;   Keyboard Type: 0000 (0) = Japan;
;                  0001 (1) = International;
;                  0010 (2) = France (AZERTY);
;                  0011 (3) = United Kingdom;
;                  0100 (4) = Germany;
;                  0101 (5) = USSR;
;                  0110 (6) = Spain.
; ----------------------------------------------------------

FUNCTION_SYSTEM_SET_KEY_NAMES_TABLE:

	; Usa la tabla internacional por defecto
	ld hl, KEY_NAMES_INTERNATIONAL
	ld [KEY_NAMES_TABLE], hl

	; Lee la informacion regional de la BIOS
	ld a, [$002C]
	; Informacion del teclado [Mascara 00001111]
	and $0F

	; Guarda el resultado para futuras referencias
	ld [KEYBOARD_LAYOUT], a

	; Si se identifica como Francia...
	@@FRANCE:
	cp 2		; Francia
	jr nz, @@DEFAULT
	ld hl, KEY_NAMES_FRANCE
	ld [KEY_NAMES_TABLE], hl
	ret

	; Si es cualquier otro pais
	@@DEFAULT:
	ret





; ----------------------------------------------------------
; Lee el estado del teclado y joysticks
; ----------------------------------------------------------

FUNCTION_SYSTEM_HID_READ:	; (Human Interface Devices)

	call NGN_KEYBOARD_READ		; Lee el teclado
	call NGN_PSG_READ_JOY1		; Puerto 1 del Joystick
	call NGN_PSG_READ_JOY2		; Puerto 2 del Joystick


	; --------------------------------
	; Actualiza las teclas del sistema
	; --------------------------------
	
	; Arriba
	ld a, [NGN_KEY_UP]	; Valor de la tecla UP
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_UP]	; Valor del Joy1 UP
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_UP], a	; Almacena el valor en la variable

	; Abajo
	ld a, [NGN_KEY_DOWN]	; Valor de la tecla DOWN
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_DOWN]	; Valor del Joy1 DOWN
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_DOWN], a	; Almacena el valor en la variable

	; Izquierda
	ld a, [NGN_KEY_LEFT]	; Valor de la tecla LEFT
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_LEFT]	; Valor del Joy1 LEFT
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_LEFT], a	; Almacena el valor en la variable

	; Derecha
	ld a, [NGN_KEY_RIGHT]	; Valor de la tecla RIGHT
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_RIGHT]	; Valor del Joy1 RIGHT
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_RIGHT], a	; Almacena el valor en la variable

	; Aceptar
	ld a, [NGN_KEY_SPACE]	; Valor de la tecla SPACE
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_TG1]	; Valor del Joy1 TG1
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_ACCEPT], a	; Almacena el valor en la variable

	; Cancelar
	ld a, [NGN_KEY_ESC]	; Valor de la tecla ESC
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	ld b, a			; Guarda el valor en B
	ld a, [NGN_JOY1_TG2]	; Valor del Joy1 TG2
	and $07			; Filtra el valor de los BITS 0, 1 y 2 (HELD/PRESS/UP)
	or b			; Añadele el valor del estado de la tecla (B)
	ld [SYSKEY_CANCEL], a	; Almacena el valor en la variable

	; Fin de la funcion
	ret





; ----------------------------------------------------------
; Identifica el VDP instalado		[VDP_TYPE_ID]
;	
;	0 - TMS9918A/28A/29A
;	1 - V9938
;	2 - V9958
;	255 - Otros
;
; Y la frecuencia de refresco		[VDP_HZ]
;
;	1 - 50hz
;	0 - 60hz
;
; ----------------------------------------------------------

FUNCTION_SYSTEM_GET_VDP_TYPE:

	; Verifica si la VDP es un TMS9918A/28A/29A

	xor a
	ld [$F3F6], a			; [SCNCNT] Fuerza saltarse la lectura del teclado
	ld [$FCA2], a			; [INTCNT] Fuerza saltarse la lectura de ON INTERVAL

	ld a, [$0006]			; Puerto de lectura
	inc a
	ld c, a	
	in a, [c]				; Lee el valor del Registro S0 del VDP
	
	di								; Deshabilita las interrupciones
	@@WAIT_INTERRUPT:
		in a, [c]					; Lee el valor del Registro S0 del VDP
		and a 						; Bitmask para el flag F (Vsync)
		jp p, @@WAIT_INTERRUPT		; Si no hay flag de Vsync, repite

	ld a, [$0007]		; Puerto de escritura
	inc a
	ld c, a
	ld a, 2				; Selecciona el registro S2 del VDP V9938 (si es posible)
	out [c], a
	ld a, $8F      		; Selecciona el registro R7/R15 en la VDP (1000 1111)
	out [c], a			; Si se ha podido seleccionar S1, sera R15, si no R7

	ld a, [$0006]		; Puerto de lectura
	inc a
	ld c, a	
	in a, [c]			; Lee el registro S0/S2
	
	ei					; Vuelve a habilitar las interrupciones

	and $40				; Mascara con el bit 6
						; Si es cero, flag del 5º sprite del registro S0 (TMS9918A)
						; Si es uno, flag del sync vertical del registro S2 (V99xx)

	jr nz, @@V99XX
	xor a				; TMS9918A/29A
	ld [VDP_TYPE_ID], a
	jp @@GET_VDP_HZ


	; Verifica si la VDP es un V99XX

	@@V99XX:

	ld a, [$0007]		; Puerto de escritura
	inc a
	ld c, a
	ld a, 1				; Selecciona el registro S1
	di					; Deshabilita la interrupciones
	out [c], a			; Aplica la seleccion de registro 

	ld a, $8F      		; Selecciona el registro R15 en la VDP (1000 1111)
	out [c], a			; Aplica la seleccion de S1 como registro de estado

	ld a, [$0006]		; Puerto de lectura
	inc a
	ld c, a	
	in a, [c]			; El el contenido de S1
	ei					; Habilita las interrupciones

	and $3E				; Bitmask para obtener el ID del VDP (0011 1110)
						; 0 = V9938
						; 2 = TMS99XX
						; 4 = V9958

	; 0 = V9938
	or a
	jr nz, @@V9958
	ld a, 1
	ld [VDP_TYPE_ID], a
	jp @@GET_VDP_HZ

	; 4 = V9958
	@@V9958:
	cp 4
	jr nz, @@UNKNOW
	ld a, 2
	ld [VDP_TYPE_ID], a
	jp @@GET_VDP_HZ

	; Desconocida
	@@UNKNOW:
	ld a, $FF
	ld [VDP_TYPE_ID], a


	; Frecuencia del VDP
	@@GET_VDP_HZ:

	; Asegurate que el registro  de estado S0 esta seleccionado en modelos MSX2 y superiores
	ld a, [$0007]		; Puerto de escritura
	inc a
	ld c, a
	xor a				; Selecciona el registro S0
	di					; Deshabilita la interrupciones
	out [c], a			; Aplica la seleccion de registro 

	ld a, $8F      		; Selecciona el registro R15 en la VDP (1000 1111)
	out [c], a			; Aplica la seleccion de S1 como registro de estado

	; Espera a la interrupcion de la VDP, antes de calcular los HZ
	ei
	halt

	; Rutina de conteo de ciclos para el calculo de los HZ
	ld hl, $0000			; Contador a 0

	xor a
	ld [$F3F6], a			; [SCNCNT] Fuerza saltarse la lectura del teclado
	ld [$FCA2], a			; [INTCNT] Fuerza saltarse la lectura de ON INTERVAL

	ld a, [$0006]			; Puerto de lectura
	inc a
	ld c, a	
	in a, [c]				; Lee el valor del Registro S0 del VDP (resetea la interrupcion)
	di						; Deshabilita las interrupciones
	@@WAIT_VBL:
		inc hl				; Conteo de ciclos
		in a, [c]			; Lee el valor del Registro S0 del VDP
		and a 				; Bitmask para el flag F (Vsync)
		jp p, @@WAIT_VBL	; Si no hay flag de Vsync, repite
	ei						; Habilita las interrupciones

	; Guarda el resultado del contador
	ld d, h
	ld e, l

	; Son 60hz?
	ld hl, $06EE		; Numero de ciclos superior a 60hz, pero inferior a 50hz
	sbc hl, de			; (en medio de los dos, 1774 ciclos del bucle)
	jr c, @@HZ50
	xor a
	ld [VDP_HZ], a		; 60hz
	jr @@EXIT

	@@HZ50:
	ld a, 1
	ld [VDP_HZ], a		; 50hz

	@@EXIT:
	ret



; ----------------------------------------------------------
; Tabla de caracteres personalizados en SCREEN 0
; La tabla de caracteres (patterns) empieza en $0800 (2048)
; ----------------------------------------------------------

FUNCTION_SYSTEM_SCREEN0_CHARSET:

	; Carga la tabla de 16 caracteres ($C0 a CF) Offset en $600
	ld de, $0E00					; Direccion de destino ($0800 + $0600)
	ld hl, CUSTOM_CHARACTERS_SET
	ld bc, $0080					; Bytes a copiar (8 * 16)
	call $005C						; Ejecuta la rutina [LDIRVM]
	ret								; Fin de la rutina





;***********************************************************
; Fin del archivo
;***********************************************************
SYSTEM_EOF: