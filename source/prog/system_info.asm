;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.4
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
	; 		Modelo de MSX
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
	ld [SYS_INFO_MODEL], hl



	; ----------------------------------------------------------
	; 		RAM
	; ----------------------------------------------------------

	ld hl, $FFFF
	ld [SYS_INFO_RAM], hl



	; ----------------------------------------------------------
	; 		VRAM
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
	ld [SYS_INFO_VRAM], hl



	; ----------------------------------------------------------
	; 	Identifica el VDP instalado		[VDP_TYPE_ID]
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
	ld [SYS_INFO_VDP], hl


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
	ld [SYS_INFO_HZ], hl



	; ----------------------------------------------------------
	; 		Distribucion del teclado
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
	ld [SYS_INFO_KB], hl



	; ----------------------------------------------------------
	; 		Cabecera
	; ----------------------------------------------------------

	ld hl, TEXT_SYSTEM_INFO_TITLE				; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo


	; ----------------------------------------------------------
	; 		Informacion
	; ----------------------------------------------------------

	; Modelo de MSX
	ld hl, $0205
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_MSX_MODEL
	call NGN_TEXT_PRINT
	ld hl, [SYS_INFO_MODEL]
	call NGN_TEXT_PRINT

	; Distribucion de teclado
	ld hl, $1605
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_KEYBOARD
	call NGN_TEXT_PRINT
	ld hl, [SYS_INFO_KB]
	call NGN_TEXT_PRINT

	; Memoria RAM
	ld hl, $0207
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_RAM
	call NGN_TEXT_PRINT
	ld b, $00	; Valor de RAM
	ld hl, [SYS_INFO_RAM]
	ld c, h
	ld d, l
	call NGN_TEXT_PRINT_BCD
	ld hl, TEXT_SYSTEM_INFO_KB
	call NGN_TEXT_PRINT

	; Memoria VRAM
	ld hl, $1607
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_VRAM
	call NGN_TEXT_PRINT
	ld b, $00	; Valor de VRAM
	ld hl, [SYS_INFO_VRAM]
	ld c, h
	ld d, l
	call NGN_TEXT_PRINT_BCD
	ld hl, TEXT_SYSTEM_INFO_KB
	call NGN_TEXT_PRINT

	; VDP
	ld hl, $0209
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_VDP
	call NGN_TEXT_PRINT
	ld hl, [SYS_INFO_VDP]
	call NGN_TEXT_PRINT

	; VDP FREQUENCY
	ld hl, $1609
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_VDPFREQ
	call NGN_TEXT_PRINT
	ld b, $00	; Valor de Hercios
	ld hl, [SYS_INFO_HZ]
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

	; Fecha
	ld hl, $0214
	call NGN_TEXT_POSITION
	ld hl, TEXT_SYSTEM_INFO_RTC_DATE
	call NGN_TEXT_PRINT
	; Hora
	ld hl, $1614
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


	; Bucle de ejecucion
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
		ld hl, $0814
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
		ld hl, $1C14
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
		call z, @@LEFT_ZERO
		xor a						; Analiza las unidades (D)
		or d						; Si las unidades y las decenas son 0, muestra los 2 ceros
		or e					
		call z, @@LEFT_ZERO
		ret							; Vuelve

	@@LEFT_ZERO:
		ld a, b
		add a, $10 
		ld b, a
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