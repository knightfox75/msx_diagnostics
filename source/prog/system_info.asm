;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.7
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
	;  Identifica el modelo de MSX
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
	ld [(NGN_RAM_BUFFER + SYS_INFO_MODEL)], hl




	; ----------------------------------------------------------
	;  Detecta la VRAM instalada
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
	ld [(NGN_RAM_BUFFER + SYS_INFO_VRAM)], hl



	; ----------------------------------------------------------
	; 		Identifica el VDP instalado		[VDP_TYPE_ID]
	;	
	;	0 - TMS9918A/28A/29A
	;	1 - V9938
	;	2 - V9958
	;	255 - Otros
	;
	; 	Y la frecuencia de refresco		[VDP_HZ]
	;
	;	1 - 50hz
	;	0 - 60hz
	;
	; ----------------------------------------------------------

	ld a, [VDP_TYPE_ID]							; Recupera el ID del VDP
	
	; Si es 0 - TMS9918A/28A/29A
	or a
	jr nz, @@V9938
	; Si es un TMS, selecciona el modelo segun el refresco detectado
	ld a, [VDP_HZ]
	or a
	jr z, @@TMS9918A
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
	ld [(NGN_RAM_BUFFER + SYS_INFO_VDP)], hl


	; HZ del VDP
	ld a, [VDP_HZ]

	; 50hz
	or a
	jr z, @@VDP60HZ
	ld hl, $0050			; 50hz
	jr @@SET_HZ

	; 60hz
	@@VDP60HZ:
	ld hl, $0060			; 60hz

	; Guarda los HZ
	@@SET_HZ:
	ld [(NGN_RAM_BUFFER + SYS_INFO_HZ)], hl



	; ----------------------------------------------------------
	;  Identifica la distribucion del teclado
	; ----------------------------------------------------------

	ld a, [KEYBOARD_LAYOUT]						; Distribucion

	; Japon
	or a	; 0
	jr nz, @@KB_INTERNATIONAL
	ld hl, TEXT_SYSTEM_INFO_LANG_JAPAN
	jr @@KB_SET

	; Internacional
	@@KB_INTERNATIONAL:
	cp 1
	jr nz, @@KB_FRANCE
	ld hl, TEXT_SYSTEM_INFO_LANG_INTERNATIONAL
	jr @@KB_SET

	; Francia
	@@KB_FRANCE:
	cp 2
	jr nz, @@KB_UK
	ld hl, TEXT_SYSTEM_INFO_LANG_FRANCE
	jr @@KB_SET

	; UK
	@@KB_UK:
	cp 3
	jr nz, @@KB_GERMANY
	ld hl, TEXT_SYSTEM_INFO_LANG_UK
	jr @@KB_SET

	; GERMANY
	@@KB_GERMANY:
	cp 4
	jr nz, @@KB_USSR
	ld hl, TEXT_SYSTEM_INFO_LANG_GERMANY
	jr @@KB_SET

	; USSR
	@@KB_USSR:
	cp 5
	jr nz, @@KB_SPAIN
	ld hl, TEXT_SYSTEM_INFO_LANG_USSR
	jr @@KB_SET

	; SPAIN
	@@KB_SPAIN:
	ld hl, TEXT_SYSTEM_INFO_LANG_SPAIN

	; Guarda la distribucion
	@@KB_SET:
	ld [(NGN_RAM_BUFFER + SYS_INFO_KB)], hl





	; ----------------------------------------------------------
	;  Impresion de la informacion: Cabecera
	; ----------------------------------------------------------

	ld hl, TEXT_SYSTEM_INFO_TITLE				; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo



	; ----------------------------------------------------------
	;  Impresion de la informacion: Modelo de MSX
	; ----------------------------------------------------------

	ld hl, $0205
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_MSX_MODEL
	call NGN_TEXT_PRINT
	ld hl, [(NGN_RAM_BUFFER + SYS_INFO_MODEL)]
	call NGN_TEXT_PRINT



	; ----------------------------------------------------------
	;  Impresion de la informacion: Distribucion del teclado
	; ----------------------------------------------------------

	ld hl, $1605
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_KEYBOARD
	call NGN_TEXT_PRINT
	ld hl, [(NGN_RAM_BUFFER + SYS_INFO_KB)]
	call NGN_TEXT_PRINT



	; ----------------------------------------------------------
	;  Impresion de la informacion: RAM
	; ----------------------------------------------------------

	ld hl, $0207
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_RAM
	call NGN_TEXT_PRINT
	ld b, $00	; Valor de RAM
	ld hl, [RAM_DETECTED]
	ld c, h
	ld d, l
	call NGN_TEXT_PRINT_BCD
	ld hl, TEXT_SYSTEM_INFO_KB
	call NGN_TEXT_PRINT



	; ----------------------------------------------------------
	;  Impresion de la informacion: VRAM
	; ----------------------------------------------------------

	ld hl, $0209
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_VRAM
	call NGN_TEXT_PRINT
	ld b, $00	; Valor de VRAM
	ld hl, [(NGN_RAM_BUFFER + SYS_INFO_VRAM)]
	ld c, h
	ld d, l
	call NGN_TEXT_PRINT_BCD
	ld hl, TEXT_SYSTEM_INFO_KB
	call NGN_TEXT_PRINT



	; ----------------------------------------------------------
	;  Impresion de la informacion: VDP
	; ----------------------------------------------------------

	ld hl, $1607
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_VDP
	call NGN_TEXT_PRINT
	ld hl, [(NGN_RAM_BUFFER + SYS_INFO_VDP)]
	call NGN_TEXT_PRINT



	; ----------------------------------------------------------
	;  Impresion de la informacion: Frecuencia del VDP
	; ----------------------------------------------------------

	ld hl, $1609
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_VDPFREQ
	call NGN_TEXT_PRINT
	ld b, $00	; Valor de Hercios
	ld hl, [(NGN_RAM_BUFFER + SYS_INFO_HZ)]
	ld c, h
	ld d, l
	call NGN_TEXT_PRINT_BCD
	ld hl, TEXT_SYSTEM_INFO_HZ
	call NGN_TEXT_PRINT
	; Verifica que coincidan los HZ detectados con los de la BIOS
	ld a, [$002B]		; Info en la BIOS de los HZ
	and $80				; En el bit 7	(0 = 60Hz, 1 = 50Hz)
	rlc a				; Pasa el bit 7 al 0
	ld b, a				; Guarda el resultado en B
	ld a, [VDP_HZ]		; Carga los herzios calculados (0 = 60Hz, 1 = 50Hz)
	xor b				; Coinciden?
	jr z, @@HZ_MATCH	; Si coinciden, no hagas nada mas
	ld a, $CF			; Imprime un indicador de no coincidencia
	call $00A2			; Imprime el caracter en A. Rutina [CHPUT] de la BIOS
	@@HZ_MATCH:



	; ----------------------------------------------------------
	;  Impresion de la informacion: Layout de slots
	; ----------------------------------------------------------

	; Linea de cabecera
	ld hl, $020B
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_SLOT_GUI_TOP
	call NGN_TEXT_PRINT

	; Filas de datos
	ld hl, $020C									; Poscion inicial
	ld b, 5											; 5 filas
	@@SLOT_GUI_DRAW_DATA_ROWS:
		push hl										; Guarda la linea actual
		push bc										; Conteo inicial
		call NGN_TEXT_POSITION						; Cabezal de escritura
		ld hl, TEXT_SYSTEM_INFO_SLOT_GUI_DATA		; Texto a mostrar
		call NGN_TEXT_PRINT							; Imprimelo
		pop bc										; Recupera el conteo
		pop hl										; Recupera la posicion del texto
		inc hl										; 2 posiciones
		inc hl										; para la siguiente fila
		djnz @@SLOT_GUI_DRAW_DATA_ROWS				; Repite hasta dibujar todas las filas de datos

	; Separadores de filas
	ld hl, $020D									; Poscion inicial
	ld b, 4											; 4 separadores
	@@SLOT_GUI_DRAW_LINE_ROWS:
		push hl										; Guarda la linea actual
		push bc										; Conteo inicial
		call NGN_TEXT_POSITION						; Cabezal de escritura
		ld hl, TEXT_SYSTEM_INFO_SLOT_GUI_LINE		; Texto a mostrar
		call NGN_TEXT_PRINT							; Imprimelo
		pop bc										; Recupera el conteo
		pop hl										; Recupera la posicion del texto
		inc hl										; 2 posiciones
		inc hl										; para la siguiente fila
		djnz @@SLOT_GUI_DRAW_LINE_ROWS				; Repite hasta dibujar todas las filas de datos

	; Linea de pie
	ld hl, $0215
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_SLOT_GUI_BOTTOM
	call NGN_TEXT_PRINT

	; Texto de slots
	ld hl, $030C									; Posicion inicial
	push hl											; Guarda la posicion
	call NGN_TEXT_POSITION							; Coloca el cursor de texto
	ld a, $53										; Letra "S"
	call $00A2										; Imprime el caracter en A. Rutina [CHPUT] de la BIOS 
	pop hl											; Recupera la posicion
	inc hl											; Siguiente fila
	inc hl
	ld bc, $0400									; 4 repeticiones (B), contador a 0 (C)
	@@SLOT_GUI_DRAW_SLOT_NUMBER:
		push hl										; Guarda la posicion
		push bc										; Guarda los contadores
		call NGN_TEXT_POSITION						; Coloca el cursor de texto
		pop bc										; Recupera los contadores
		push bc										; Vuelve a guardarlos
		ld d, c										; Prepara la impresion del numero en BCD
		ld bc, $0000
		call NGN_TEXT_PRINT_BCD						; Imprime el digito
		pop bc										; Recupera el contador
		pop hl										; Recupera la posicion del texto
		inc c										; Suma un digito al contador
		inc hl										; Siguiente fila
		inc hl										
		djnz @@SLOT_GUI_DRAW_SLOT_NUMBER			; Repite hasta imprimir los 4 digitos

	;Texto de sub-slots
	ld hl, NGN_RAM_BUFFER							; Crea una cadena de texto temporal
	ld [hl], $53									; Letra "S"
	inc hl
	ld [hl], $55									; Letra "U"
	inc hl
	ld [hl], $42									; Letra "B"
	inc hl											; +2 para omitir el espacio del digito
	inc hl
	ld [hl], $00									; FIN del texto
	ld hl, $050C									; Posicion inicial
	ld bc, $0400									; 4 repeticiones (B), contador a 0 (C)
	@@SLOT_GUI_DRAW_SUBSLOT_NUMBER:
		push hl										; Guarda la posicion
		push bc										; Guarda los contadores
		call NGN_TEXT_POSITION						; Coloca el cursor de texto
		pop bc										; Recupera los contadores
		ld a, $30									; Primer digito "0" ($30)
		add a, c									; Sumale el contador
		ld [(NGN_RAM_BUFFER + 3)], a				; Modifica la cadena de texto
		ld hl, NGN_RAM_BUFFER						; Seleccion la cadena de texto
		push bc										; Guarda los contadores
		call NGN_TEXT_PRINT							; E imprimela
		pop bc										; Recupera los contadores
		pop hl										; Recupera la posicion
		inc c										; Siguiente digito
		ld de, $0500								; Suma 5 columnas a la posicion del texto
		add hl, de
		djnz @@SLOT_GUI_DRAW_SUBSLOT_NUMBER			; Repite hasta imprimir los 4 digitos

	; Slots expandidos?
	ld hl, $190C									; Posicion
	call NGN_TEXT_POSITION							; Coloca el cursor de texto
	ld a, $45										; Letra "E"
	call $00A2										; Imprime el caracter en A. Rutina [CHPUT] de la BIOS
	ld hl, $190E									; Posicion inicial
	ld bc, $0400									; 4 repeticiones (B), contador a 0 (C)
	@@SLOT_GUI_DRAW_SLOT_EXPANDED:
		push hl										; Guarda la posicion
		push bc										; Guarda los contadores
		call NGN_TEXT_POSITION						; Coloca el cursor de texto
		pop bc										; Preserva el contador
		push bc
		ld hl, SLOT_EXPANDED						; Variable con la informacion
		ld b, 0										; Indice de slot (C)
		add hl, bc
		ld b, $4E									; Letra "N"
		ld a, [hl]									; Esta expandido?	$00 = NO	$0B = SI
		add a, b									; Desplazamiento para el caracter a mostrar
		call $00A2									; Imprime el caracter en A. Rutina [CHPUT] de la BIOS
		pop bc										; Recupera los contadores
		pop hl										; Recupera la posicion
		inc c										; Siguiente digito
		inc hl										; Siguiente fila
		inc hl
		djnz @@SLOT_GUI_DRAW_SLOT_EXPANDED			; Repite hasta imprimir los 4 digitos


	; Impresion de los bancos de memoria
	ld hl, $050E												; Posicion del texto
	ld [(NGN_RAM_BUFFER + SYS_INFO_RAM_PAGES_TEXT_POS)], hl
	call NGN_TEXT_POSITION										; Coloca el cursor de texto

	ld hl, RAM_SLOT_0		; Variable con la informacion de paginas ocupadas

	; Slots
	ld b, 4
	@@RAM_PAGES_SLOTS_LOOP:

		push bc		; Preserva los registros

		; Sub-slots
		ld b, 4		; 4 Sub-slots
		@@RAM_PAGES_SUBSLOTS_LOOP:

			push bc			; Preserva los registro
			push hl			; y el numero de subslot

			; Imprime 
			call @@PRINT_RAM_IN_SLOTS

			; Reposiciona el texto
			ld hl, [(NGN_RAM_BUFFER + SYS_INFO_RAM_PAGES_TEXT_POS)]		; Posicion del texto
			ld de, $0500
			add hl, de
			ld [(NGN_RAM_BUFFER + SYS_INFO_RAM_PAGES_TEXT_POS)], hl
			call NGN_TEXT_POSITION

			pop hl			; Recupera los registros
			pop bc

			inc hl			; Siguiente sub-slot

			djnz @@RAM_PAGES_SUBSLOTS_LOOP

		; Preserva la posicion de la variable
		push hl

		; Reposiciona el texto
		ld hl, [(NGN_RAM_BUFFER + SYS_INFO_RAM_PAGES_TEXT_POS)]		; Posicion del texto
		ld h, $05
		ld de, $0002
		add hl, de
		ld [(NGN_RAM_BUFFER + SYS_INFO_RAM_PAGES_TEXT_POS)], hl
		call NGN_TEXT_POSITION

		; Recupera los registros
		pop hl
		pop bc

		djnz @@RAM_PAGES_SLOTS_LOOP


	; Fin de la impresion de las paginas
	jp @@PRINT_RAM_PAGES_END


	; Rutina de impresion de RAM en slots
	@@PRINT_RAM_IN_SLOTS:
	ld a, [hl]		; Variable con la informacion
	ld d, a
	ld b, 4
	ld c, 1
	ld e, $30		; Pagina
	@@PRINT_RAM_PAGES_LOOP:
		ld a, d
		and c
		jp z, @@PRINT_EMPTY_PAGE
		ld a, e
		jr @@PRINT_RAM_PAGE
		@@PRINT_EMPTY_PAGE:
		ld a, $20
		@@PRINT_RAM_PAGE:
		push bc
		push de
		call $00A2	; Imprime el caracter
		pop de
		pop bc
		sla c		; Siguiente BIT
		inc e		; Siguiente nº de pagina
		djnz @@PRINT_RAM_PAGES_LOOP
	; Fin de la impresion del slot/subslot
	ret

	; Final de la impresion de paginas de RAM
	@@PRINT_RAM_PAGES_END:

	; ----------------------------------------------------------
	;  Impresion de la informacion: Fecha
	; ----------------------------------------------------------

	ld hl, $1D0C
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_RTC_DATE
	call NGN_TEXT_PRINT



	; ----------------------------------------------------------
	;  Impresion de la informacion: Hora
	; ----------------------------------------------------------

	ld hl, $1D12
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_RTC_TIME
	call NGN_TEXT_PRINT
	


	; ----------------------------------------------------------
	; 		Pie de pagina
	; ----------------------------------------------------------

	ld hl, $0117
	call NGN_TEXT_POSITION
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_SYSTEM_INFO_EXIT				; Aceptar/Cancelar para salir
	call NGN_TEXT_PRINT							; Imprimelo



	; ----------------------------------------------------------
	; 		Muestra la pagina
	; ----------------------------------------------------------

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044





	; ----------------------------------------------------------
	;  Bucle de ejecucion
	; ----------------------------------------------------------

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

		; Lectura del RTC
		call @@RTC_READ
		

		; Espera a la interrupcion del VDP (VSYNC)
		halt

		; Repite el bucle
		jr @@LOOP





	; ----------------------------------------------------------
	; 		Lectura del RTC
	;
	;			Block 0       Block 1       Block 2       Block 3
	;	Index  (BCD Timer)   (BCD Alarm)   (Screen)      (Ascii)
	;	-----  ------------  ------------  ------------  ------------
	;	0      Seconds, low  ---           Scratch       Type
	;	1      Seconds, hi   ---           X-Adjust      Char 1, low
	;	2      Minutes, low  Minutes, low  Y-Adjust      Char 1, hi
	;	3      Minutes, hi   Minutes, hi   Screen        Char 2, low
	;	4      Hours, low    Hours, low    Width, low    Char 2, hi
	;	5      Hours, hi     Hours, hi     Width, hi     Char 3, low
	;	6      Day of Week   Day of Week   Color, Text   Char 3, hi
	;	7      Day, low      Day, low      Color, BG     Char 4, low
	;	8      Day, hi       Day, hi       Color, Border Char 4, hi
	;	9      Month, low    ---           Cas/Prn/Key   Char 5, low
	;	A      Month, hi     12/24 hours   Beep Frq/Vol  Char 5, hi
	;	B      Year, low     Leap Year     Color, Title  Char 6, low
	;	C      Year, hi      ---           Native Code?  Char 6, hi
	;	D  Mode Register  (Read/Write)
	;	E  Test Register  (Write Only)
	;	F  Reset Register (Write Only)
	; ----------------------------------------------------------

	@@RTC_READ:

		; Posiciona el texto (Fecha)
		ld hl, $1D0E
		call NGN_TEXT_POSITION
		; Mes
		ld hl, $090A
		call @@RTC_PRINT_DATA
		; Separador
		ld a, $2F
		call $00A2					; Imprime el caracter en A. Rutina [CHPUT] de la BIOS
		; Dia
		ld hl, $0708
		call @@RTC_PRINT_DATA
		; Separador
		ld a, $2F
		call $00A2					; Imprime el caracter en A. Rutina [CHPUT] de la BIOS
		; Año
		ld hl, $0B0C
		call @@RTC_PRINT_DATA

		; Posiciona el texto (Hora)
		ld hl, $1D14
		call NGN_TEXT_POSITION
		; Horas
		ld hl, $0405
		call @@RTC_PRINT_DATA
		; Separador
		ld a, $3A
		call $00A2					; Imprime el caracter en A. Rutina [CHPUT] de la BIOS
		; Minutos
		ld hl, $0203
		call @@RTC_PRINT_DATA
		; Separador
		ld a, $3A
		call $00A2					; Imprime el caracter en A. Rutina [CHPUT] de la BIOS
		; Segundos
		ld hl, $0001
		call @@RTC_PRINT_DATA

		; Sal de la rutina de actualizacion del RTC
		ret


	@@RTC_PRINT_DATA:				; Solo MSX2 y posteriores
		ld a, [$002D]				; Direccion del BIOS con el modelo
		or a						; Si la ID de modelo es superior a 0
		jp nz, @@RTC_MSX2			; Lee la informacion REAL del RTC
		ld bc, $0000				; Si marcala como desconocida
		ld d, $FF					; para mostrar ??
		call NGN_TEXT_PRINT_BCD		; Imprime el numero en formato BCD
		ret							; y vuelve al terminar
		@@RTC_MSX2:
		ld c, h						; Selecciona la lectura de las unidades
		call @@RTC_GET_DATA
		and $0F						; Ultimos 4 bits
		ld d, a						; Guarda las unidades en D
		ld c, l						; Selecciona la lectura de las decenas
		call @@RTC_GET_DATA
		and $0F						; Ultimos 4 bits
		ld e, a						; Guarda la decenas en E
		call @@RTC_SET_TENS			; Calcula las decenas (0 extra?)
		ld a, d						; Coloca las unidades en el digito D del BCD
		or e						; Coloca las decenas en el digito D del BCD
		ld d, a						; Manda el digito empaquetado a D
		ld a, h						; Es el año? Si es asi, calcula el valor correcto
		cp $0B
		call z, @@RTC_CALCULATE_YEAR	; Salta a la rutina de compensacion de año
		call NGN_TEXT_PRINT_BCD			; Imprime el numero en formato BCD
		ret								; Vuelve al terminar


	@@RTC_SET_TENS:
		ld bc, $0000				; De los 5 digitos del BCD, los tres primeros son 0 sin signo
		sla e						; Coloca las decenas en la parte alta (<< 4)
		sla e
		sla e
		sla e
		xor a						; Analiza las decenas (E)
		or e						; Si es 0, fuerza que se muestre
		ret nz						; Si no es 0, ya puedes volver
		ld b, $10					; Si la decena es 0, fuerza que se muestre 1 cero a la izquierda
		ret							; Vuelve

	@@RTC_GET_DATA:
		push bc				; Salva los registros
		push de
		push hl
		ld ix, $01F5		; Apunta a la rutina de lectura del RTC [REDCLK]
		call $015F			; Realiza una Inter Slot Call [EXTROM]
		pop hl				; Recupera los registros
		pop de
		pop bc
		ret					; vuelve

	@@RTC_CALCULATE_YEAR:

		; Año base (1980) en RAM_BUFFER 
		ld hl, NGN_RAM_BUFFER
		ld [hl], $80		; D
		inc hl
		ld [hl], $19		; C
		inc hl
		ld [hl], $00		; B

		; Suma de el año del RTC en RAM_BUFFER + 3
		ld hl, NGN_RAM_BUFFER + 3
		ld [hl], d			; D
		inc hl
		ld [hl], $00		; C
		inc hl
		ld [hl], $00		; B

		; Realiza la suma BCD
		ld de, NGN_RAM_BUFFER			; Numero base
		ld hl, NGN_RAM_BUFFER + 3		; Sumando
		call NGN_BCD_ADD				; Funcion de suma

		; Actualiza los datos en BCD
		ld hl, NGN_RAM_BUFFER
		ld d, [hl]
		inc hl
		ld c, [hl]
		inc hl
		ld b, [hl]

		; Vuelve a la rutina de impresion
		ret



;***********************************************************
; Fin del archivo
;***********************************************************
SYSTEM_INFO_EOF: