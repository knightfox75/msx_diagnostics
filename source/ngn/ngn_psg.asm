;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.3.1
;
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;	Rutinas de acceso al PSG
;	(Programable Sound Generator)
;
;***********************************************************



; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	$A0 = Reg Select	$A1 = Write Data	$A2 = Read Data
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;										Register Bits
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	Reg.	Function		7		6		5		4		3		2		1		0
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R0	Channel A Period	pa7		pa6		pa5		pa4		pa3		pa2		pa1		pa0
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R1	Channel A Period	-		-		-		-		paB		paA		pa9		pa8
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R2	Channel B Period	pb7		pb6		pb5		pb4		pb3		pb2		pb1		pb0
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R3	Channel B Period	-		-		-		-		pbB		pbA		pb9		pb8
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R4	Channel C Period	pc7		pc6		pc5		pc4		pc3		pc2		pc1		pc0
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R5	Channel C Period	-		-		-		-		pcB		pcA		pc9		pc8
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R6	Noise Tone		-		-		-		n4		n3		n2		n1		n0
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R7	/Enable			Port B Dir.	Port A Dir.	C Noise		B Noise		A Noise		C Tone		B Tone		A Tone
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R8	Channel A Volume	-		-		-		A Mode		va3		va2		va1		va0
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R9	Channel B Volume	-		-		-		B Mode		vb3		vb2		vb1		vb0
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R10	Channel C Volume	-		-		-		C Mode		vc3		vc2		vc1		vc0
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R11	Envelope Period		ep7		ep6		ep5		ep4		ep3		ep2		ep1		ep0
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R12	Envelope Period		epF		epE		epD		epC		epB		epA		ep9		ep8
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R13	Envelope Wave Shape	-		-		-		-		es3		es2		es1		es0
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R14	I/O Port A		Cas Input	Kbd Mode	Joy Trg.B	Joy Trg.A	Joy Right	Joy Left	Joy Back	Joy Fwd
; --------------------------------------------------------------------------------------------------------------------------------------------------------------
;	R15	I/O Port B		Kana LED	Joy Sel		Pulse 2		Pulse 1		1		1		1		1
; --------------------------------------------------------------------------------------------------------------------------------------------------------------

; --------------------------------------------------------------------------------------------------------------------------------------------------------------
; Important note: the PSG registers R14 and R15 can be programmed for input or output. On MSX, R14 must be ever programmed for input and, R15, for output.
; Thus, bit 6 of R7 must ever be set to "0" (input) and, bit 7, to "1" (output). Programming them otherwise may cause severe damage to the machine, putting
; active coupling circuitry connected to R14 and R15 in short-circuit. More details on PSG register 7 section.
; --------------------------------------------------------------------------------------------------------------------------------------------------------------



; ----------------------------------------------------------
; NGN_PSG_COMMAND
; Envia comandos al PSG
; B = Registro
; C = Dato
; Modifica A
; ----------------------------------------------------------

NGN_PSG_COMMAND:

	di			; Deshabilita las interrupciones

	ld a, b
	out [$A0], a		; Selecciona el registro
	ld a, c
	out [$A1], a		; Escribe el dato

	ei			; Habilita las interrupciones

	; Vuelve
	ret



; ----------------------------------------------------------
; NGN_PSG_INIT
; Inicializa el PSG
; Habilita los 3 canales de Melodia
; No asignes ruido a ningun canal
; Volumen al maximo en todos los canales
; Modifica A
; ----------------------------------------------------------

NGN_PSG_INIT:

	; Deshabilita las interrupciones
	di

	; Configura el I/O del PSG mediante el registro nº7
	ld a, 7
	out [$A0], a

	; Datos a enviar al registro 7
	ld a, $38		; Canales A, B y C como melodia				[xx111000] (Usa logica inversa)
	and $3F			; Proteccion al PSG, los BITs 6 y 7 a 0		[00xxxxxx]
	or $80			; Pon el BIT 7 a 1 y el BIT 6 a 0			[10xxxxxx]
	out [$A1], a	; Escribe los datos en el registro

	xor a		; Frecuencia del canal A (low-byte)
	out [$A0], a
	xor a
	out [$A1], a
	ld a, 1		; Frecuencia del canal A (hi-byte)
	out [$A0], a
	xor a
	out [$A1], a

	ld a, 8		; Volumen del canal A
	out [$A0], a
	xor a		; Volumen a 0 (sin modulacion)
	out [$A1], a

	ld a, 2		; Frecuencia del canal B (low-byte)
	out [$A0], a
	xor a
	out [$A1], a
	ld a, 3		; Frecuencia del canal B (hi-byte)
	out [$A0], a
	xor a
	out [$A1], a

	ld a, 9		; Volumen del canal B
	out [$A0], a
	xor a		; Volumen a 0 (sin modulacion)
	out [$A1], a

	ld a, 4		; Frecuencia del canal C (low-byte)
	out [$A0], a
	xor a
	out [$A1], a
	ld a, 5		; Frecuencia del canal C (hi-byte)
	out [$A0], a
	xor a
	out [$A1], a

	ld a, 10	; Volumen del canal C
	out [$A0], a
	xor a		; Volumen a 0 (sin modulacion)
	out [$A1], a

	; Frecuencia del ruido
	ld a, 6					; Seleccion del canal de ruido
	out [$A0], a
	xor a					; Frecuencia
	out [$A1], a

	; Habilita las interupciones
	ei

	; Vuelve
	ret





; ----------------------------------------------------------
; Lee los puertos de JoyStick usando el PSG
; Modifica A, BC, HL
; ----------------------------------------------------------

; Lectura del puerto 1
; NGN_PSG_READ_JOY1
NGN_PSG_READ_JOY1:

	; Deshabilita las interrupciones
	di

	; Seleccion del Puerto 1
	ld a, 15	; Seleccion del registro 15
	out [$A0], a
	out [$A1], a	; Puerto 1 seleccionado [00001111] = 15

	; Selecciona el registro de datos de puerto de JoyStick [14]
	ld a, 14
	out [$A0], a

	; Habilita las interrupciones
	ei

	; Guarda la informacion de este Joystick en el registro C
	in a, [$A2]
	ld c, a

	; JOY1: ARRIBA		[BIT 0]
	ld hl, NGN_JOY1_UP
	ld b, 1
	call @@GET_KEY

	; JOY1: ABAJO		[BIT 1]
	ld hl, NGN_JOY1_DOWN
	ld b, 2
	call @@GET_KEY

	; JOY1: IZQUIERDA	[BIT 2]
	ld hl, NGN_JOY1_LEFT
	ld b, 4
	call @@GET_KEY

	; JOY1: DERECHA		[BIT 3]
	ld hl, NGN_JOY1_RIGHT
	ld b, 8
	call @@GET_KEY

	; JOY1: BOTON A		[BIT 4]
	ld hl, NGN_JOY1_TG1
	ld b, 16
	call @@GET_KEY

	; JOY1: BOTON B		[BIT 5]
	ld hl, NGN_JOY1_TG2
	ld b, 32
	call @@GET_KEY

	; Sal de la rutina
	ret



; Lectura del puerto 2
; NGN_PSG_READ_JOY2
NGN_PSG_READ_JOY2:

	; Deshabilita las interrupciones
	di

	; Seleccion del Puerto 2
	ld a, 15	; Seleccion del registro 15
	out [$A0], a
	ld a, 79	; Puerto 1 seleccionado [01001111] = 79
	out [$A1], a

	; Selecciona el registro de datos de puerto de JoyStick [14]
	ld a, 14
	out [$A0], a

	; Habilita las interrupciones
	ei

	; Guarda la informacion de este Joystick en el registro C
	in a, [$A2]
	ld c, a

	; JOY2: ARRIBA		[BIT 0]
	ld hl, NGN_JOY2_UP
	ld b, 1
	call @@GET_KEY

	; JOY2: ABAJO		[BIT 1]
	ld hl, NGN_JOY2_DOWN
	ld b, 2
	call @@GET_KEY

	; JOY2: IZQUIERDA	[BIT 2]
	ld hl, NGN_JOY2_LEFT
	ld b, 4
	call @@GET_KEY

	; JOY2: DERECHA		[BIT 3]
	ld hl, NGN_JOY2_RIGHT
	ld b, 8
	call @@GET_KEY

	; JOY2: BOTON A		[BIT 4]
	ld hl, NGN_JOY2_TG1
	ld b, 16
	call @@GET_KEY

	; JOY2: BOTON B		[BIT 5]
	ld hl, NGN_JOY2_TG2
	ld b, 32
	call @@GET_KEY

	; Sal de la rutina
	ret



; @@GET_KEY
; Lee un valor en concreto
; Lee el estado de la tecla solicitada usando el puerto $A2
; BC = Datos de la tecla del Joystick		B = BIT		C = Datos
; HL = Direccion de la variable asignada a la tecla

@@GET_KEY:		
			
	ld a, c				; Carga los datos guardados del puerto
	and b				; Comparalos con el bit correspondiente

	jr z, @@KEY_HELD			; En caso de que se haya pulsado, salta

	; Si no se ha pulsado
	ld a, [hl]
	and $08				; Pero lo estabas
	jr z, @@NO_KEY
	ld [hl], $04			; B0100
	ret

	; La tecla no se ha pulsado ni estaba pulsada
	@@NO_KEY:
	ld [hl], $00			; B0000
	ret

	; Si se ha pulsado
	@@KEY_HELD:
	ld a, [hl]		; Carga el estado anterior
	and $08			; Si no estava pulsada...
	jr z, @@KEY_PRESS	; Salta a NEW PRESS
	ld [hl], $09		; Si ya estava pulsada, B1001
	ret

	; Si era una nueva pulsacion
	@@KEY_PRESS:
	ld [hl], $0B		; B1011
	ret



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_PSG_EOF: