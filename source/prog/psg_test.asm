;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.0-wip02
;	ASM Z80 MSX
;	Test PSG
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Menu del Test del PSG
; ----------------------------------------------------------

FUNCTION_PSG_TEST_MENU:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Texto del menu
	call FUNCTION_MAIN_MENU_HEADER_PRINT		; Cabecera
	ld hl, TEXT_PSG_MENU_TITLE					; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_PSG_MENU_INSTRUCTIONS			; Instrucciones de uso
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

		; Si se pulsa la tecla  "ACEPTAR"
		ld a, [SYSKEY_ACCEPT]
		and $02							; Detecta "KEY DOWN"
		jp nz, FUNCTION_PSG_TEST_RUN	; Ejecuta el test

		; Si se pulsa la tecla  "CANCELAR"
		ld a, [SYSKEY_CANCEL]
		and $02							; Detecta "KEY DOWN"
		ret nz							; Vuelve al menu principal

		; Espera a la interrupcion del VDP (VSYNC)
		halt	; Espera a la interrupcion del VDP

		; Repite el bucle
		jr @@LOOP



; ----------------------------------------------------------
; Ejecuta el test
; ----------------------------------------------------------

FUNCTION_PSG_TEST_RUN:

	; Reinicia e PSG
	call NGN_PSG_INIT

	; Valores por iniciales de este test
	ld a, 0									; Por defecto, las opciones estan a 0
	ld [SNDCHN1_FRQ], a 					; Frecuencia del canal A
	ld [SNDCHN2_FRQ], a 					; Frecuencia del canal B
	ld [SNDCHN3_FRQ], a 					; Frecuencia del canal C
	ld a, 15								; Por defecto, el volumen de los tres canales esta al maximo
	ld [SNDCHN1_VOL], a						; Volumen del canal A
	ld [SNDCHN2_VOL], a						; Volumen del canal B
	ld [SNDCHN3_VOL], a						; Volumen del canal C
	ld a, 0									; Por defecto el canal de ruido no esta asignado
	ld [SNDNOISE_CHAN], a					; Volumen del canal de ruido
	ld a, 8									; Y tiene la frecuencia media
	ld [SNDNOISE_FRQ], a 					; Frecuencia del canal de ruido

	; Frecuencia del ruido inicial
	di
	ld a, 6									; Seleccion del canal de ruido
	out ($A0), a
	ld a, [SNDNOISE_FRQ]					; Frecuencia
	sla a									; Multiplica x2 el valor
	ld b, a									; y guardalo en B
	ld a, $1F								; Frecuencia mas baja (mas valor, menos frecuencia)
	sub b									; Restale a la frecuencia minima el valor calculado
	out ($A1), a
	ei

	; Valores iniciales del menu
	ld a, (PSGTEST_FIRST_OPTION + 1)
	ld [PSG_TEST_OPTION_SELECTED], a

	; Posicion inicial del cursor
	ld a, 3								; Posicion X
	ld [PSG_TEST_CURSOR_X], a			; Guarda las posiciones X
	ld [PSG_TEST_CURSOR_OLD_X], a 
	ld a, [PSG_TEST_OPTION_SELECTED]	; Lee la opcion del menu
	sla a								; Multiplicala x2
	add PSGTEST_ITEM_START				; Asignale el offset de la Y
	ld [PSG_TEST_CURSOR_Y], a			; Guarda las posiciones Y
	ld [PSG_TEST_CURSOR_OLD_Y], a

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Texto de la GUI
	ld hl, TEXT_PSG_GUI			; Apunta al texto a mostrar
	call NGN_TEXT_PRINT			; E imprimelo en pantalla

	; Cursor
	call @@PRINT_CURSOR

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044

	; Bucle de ejecucion
	@@LOOP:

		; Lectura del HID
		call FUNCTION_SYSTEM_HID_READ


		; Si se pulsa la tecla  "CANCELAR"
		ld a, [SYSKEY_CANCEL]
		and $02								; Detecta "KEY DOWN"
		jp nz, @@LOOP_EXIT					; Sal del bucle de ejecucion


		; Si se pulsa "ARRIBA"
		ld a, [SYSKEY_UP]
		and $02								; Detecta "KEY DOWN"
		jr z, @@OPTION_DOWN					; Si no se pulsa, siguiente bloque
		
		ld a, [PSG_TEST_OPTION_SELECTED]	; Carga la opcion actual
		dec a								; Resta una opcion
		cp PSGTEST_FIRST_OPTION				; Si no era la primera opcion
		jr nz, @@OPTION_UPDATE				; actualizala

		ld a, (PSGTEST_FIRST_OPTION + 1)	; Si lo era, fijala
		jr @@OPTION_UPDATE					; y actualizala


		; Si se pulsa "ABAJO
		@@OPTION_DOWN:
		ld a, [SYSKEY_DOWN]
		and $02								; Detecta "KEY DOWN"
		jr z, @@MOVE_LEFT_RIGHT				; Si no se pulsa, siguiente bloque

		ld a, [PSG_TEST_OPTION_SELECTED]	; Carga la opcion actual
		inc a								; Suma una opcion
		cp PSGTEST_LAST_OPTION				; Si no era la ultima opcion
		jp nz, @@OPTION_UPDATE				; actualizala

		ld a, (PSGTEST_LAST_OPTION - 1)		; Si lo era, fijala
		

		; Actualiza la opcion y el cursor si es necesario
		@@OPTION_UPDATE:
		ld [PSG_TEST_OPTION_SELECTED], a	; Guarda los datos del cursor
		call @@PRINT_CURSOR					; Imprime su posicion actualizada



		; Reset de comandos (IZQ/DER) (0 ninguno, 1 derecha, 2 izquierda)
		@@MOVE_LEFT_RIGHT:
		ld a, 0
		ld b, a

		; Si se pulsa "DERECHA"
		ld a, [SYSKEY_RIGHT]
		and $02								; Detecta "KEY DOWN"
		jr z, @@KEYPRES_LEFT				; Si no se pulsa, siguiente bloque
		ld a, 1
		ld b, a
		jr @@EXECUTE_OPTION

		; Si se pulsa "IZQUIERDA"
		@@KEYPRES_LEFT:
		ld a, [SYSKEY_LEFT]
		and $02								; Detecta "KEY DOWN"
		jr z, @@LOOP_END					; Si no se pulsa, siguiente bloque
		ld a, 2
		ld b, a

		; Opcion actual
		@@EXECUTE_OPTION:
		ld a, [PSG_TEST_OPTION_SELECTED]	; Lee la opcion seleccionada		
		; Opcion 1
		cp 1
		jp z, @@PSGTEST_FREQ1		; Frecuencia del canal A
		; Opcion 2
		cp 2
		jp z, @@PSGTEST_FREQ2		; Frecuencia del canal B
		; Opcion 3
		cp 3
		jp z, @@PSGTEST_FREQ3		; Frecuencia del canal C
		; Opcion 4
		cp 4
		jp z, @@PSGTEST_VOL1		; Volumen del canal A
		; Opcion 5
		cp 5
		jp z, @@PSGTEST_VOL2		; Volumen del canal B
		; Opcion 6
		cp 6
		jp z, @@PSGTEST_VOL3		; Volumen del canal C
		; Opcion 7
		cp 7
		jp z, @@PSGTEST_NOISE_ASSIGN		; Asigna el generador de ruido a un canal
		; Opcion 8
		cp 8
		jp z, @@PSGTEST_NOISE_FREQUENCY		; Cambia la frecuencia del generador de ruido



		; ----------------------------------------------------------
		;  Fin de la funcion
		; ----------------------------------------------------------

		; Espera a la interrupcion del VDP (VSYNC)
		@@LOOP_END:
		halt	; Espera a la interrupcion del VDP

		; Repite el bucle
		jp @@LOOP

		; Sal de esta funcion
		@@LOOP_EXIT:
		call NGN_PSG_INIT		; Reinicia el PSG
		ret						; Sal de la funcion



	; ----------------------------------------------------------
	;  Actualiza la posicion del cursor en la pantalla
	; ----------------------------------------------------------	
	@@PRINT_CURSOR:

		; Borra el cursor de su posicion actual
		ld a, [PSG_TEST_CURSOR_OLD_X]		; Posicion X
		ld h, a
		ld a, [PSG_TEST_CURSOR_OLD_Y]		; Posicion Y
		ld l, a
		call NGN_TEXT_POSITION				; Coloca el cursor
		ld hl, TEXT_MAIN_MENU_ITEM_OFF		; Lee el espacio en blanco
		call NGN_TEXT_PRINT					; Y escribelo

		; Imprime el cursor en su nueva posicion
		ld a, [PSG_TEST_CURSOR_X]			; Posicion X
		ld h, a
		ld a, [PSG_TEST_OPTION_SELECTED]	; Lee la opcion del menu
		ld b, a								; Guarda el valor leido en B
		sla a								; Multiplicala x2
		add PSGTEST_ITEM_START				; Asignale el offset de la Y
		ld c, a								; Guarda el valor actual en C
		ld a, b 							; Recupera el valor inicial desde B
		sub 7								; Si es una de las opciones de la parte superior
		jp c, @@TOP_MENU					; No hagas nada
		ld a, c								; Recupera la posicion del cursor desde C
		add 2								; Sumale 2
		ld c, a								; Actualiza la posicion en C
		@@TOP_MENU:
		ld a, c								; Recupera la posicion Y del cursor en Y
		ld l, a								; Posicion Y
		ld [PSG_TEST_CURSOR_Y], a
		call NGN_TEXT_POSITION				; Coloca el cursor
		ld hl, TEXT_MAIN_MENU_ITEM_ON		; Lee el caracter del cursor
		call NGN_TEXT_PRINT					; Y escribelo

		; Guarda las coordenadas de borrado
		ld a, [PSG_TEST_CURSOR_X]
		ld [PSG_TEST_CURSOR_OLD_X], a
		ld a, [PSG_TEST_CURSOR_Y]
		ld [PSG_TEST_CURSOR_OLD_Y], a		
		
		; Vuelve
		ret



;***********************************************************
; Seleccion de acciones segun el item del menu
; El registro B guarda la pulsacion DER/IZQ
;***********************************************************

	@@PSGTEST_FREQ1:
		ld a, 1
		ld [PSG_TEST_CHANNEL], a		; Selecciona el canal
		ld a, [SNDCHN1_FRQ]				
		ld [PSG_TEST_FREQ], a			; Guarda la frecuencia
		ld a, [SNDCHN1_VOL]				
		ld [PSG_TEST_VOLUME], a			; Guarda el volumen
		call @@APPLY_FREQ
		ld a, [PSG_TEST_FREQ]			; Actualiza la frecuencia
		ld [SNDCHN1_FRQ], a
		jp @@LOOP_END 

	@@PSGTEST_FREQ2:
		ld a, 2
		ld [PSG_TEST_CHANNEL], a		; Selecciona el canal
		ld a, [SNDCHN2_FRQ]				
		ld [PSG_TEST_FREQ], a			; Guarda la frecuencia
		ld a, [SNDCHN2_VOL]				
		ld [PSG_TEST_VOLUME], a			; Guarda el volumen
		call @@APPLY_FREQ
		ld a, [PSG_TEST_FREQ]			; Actualiza la frecuencia
		ld [SNDCHN2_FRQ], a
		jp @@LOOP_END 

	@@PSGTEST_FREQ3:
		ld a, 3
		ld [PSG_TEST_CHANNEL], a		; Selecciona el canal
		ld a, [SNDCHN3_FRQ]				
		ld [PSG_TEST_FREQ], a			; Guarda la frecuencia
		ld a, [SNDCHN3_VOL]				
		ld [PSG_TEST_VOLUME], a			; Guarda el volumen
		call @@APPLY_FREQ
		ld a, [PSG_TEST_FREQ]			; Actualiza la frecuencia
		ld [SNDCHN3_FRQ], a
		jp @@LOOP_END 

	@@PSGTEST_VOL1:
		ld a, 1
		ld [PSG_TEST_CHANNEL], a		; Selecciona el canal
		ld a, [SNDCHN1_VOL]				
		ld [PSG_TEST_VOLUME], a			; Guarda el volumen
		call @@APPLY_VOL
		ld a, [PSG_TEST_VOLUME]			; Actualiza el volumen
		ld [SNDCHN1_VOL], a
		jp @@LOOP_END 

	@@PSGTEST_VOL2:
		ld a, 2
		ld [PSG_TEST_CHANNEL], a		; Selecciona el canal
		ld a, [SNDCHN2_VOL]				
		ld [PSG_TEST_VOLUME], a			; Guarda el volumen
		call @@APPLY_VOL
		ld a, [PSG_TEST_VOLUME]			; Actualiza el volumen
		ld [SNDCHN2_VOL], a
		jp @@LOOP_END 

	@@PSGTEST_VOL3:
		ld a, 3
		ld [PSG_TEST_CHANNEL], a		; Selecciona el canal
		ld a, [SNDCHN3_VOL]				
		ld [PSG_TEST_VOLUME], a			; Guarda el volumen
		call @@APPLY_VOL
		ld a, [PSG_TEST_VOLUME]			; Actualiza el volumen
		ld [SNDCHN3_VOL], a
		jp @@LOOP_END

	@@PSGTEST_NOISE_ASSIGN:
		call @@APPLY_NOISE_CHANNEL
		jp @@LOOP_END

	@@PSGTEST_NOISE_FREQUENCY:
		call @@APPLY_NOISE_FREQ
		jp @@LOOP_END



;***********************************************************
; Aplica la frecuencia al canal seleccionado
;***********************************************************
	@@APPLY_FREQ:
		
		ld a, b						; Lee la pulsacion
		cp 1						; Si se pulsa derecha
		jp nz, @@DEC_FREQ			; Si se pulsa izquierda

		ld a, [PSG_TEST_FREQ]		; Lee el ID de freq actual
		cp 3						; Si estas en la ultima frequencia, sal
		ret z

		inc a						; Increnta el ID
		ld [PSG_TEST_FREQ], a		; y guardalo
		jr @@SELECT_FREQ

		@@DEC_FREQ:
		ld a, [PSG_TEST_FREQ]		; Lee el ID de freq actual
		cp 0						; Si estas en la primera frequencia, sal
		ret z

		dec a						; Decrementa el ID
		ld [PSG_TEST_FREQ], a		; y guardalo


		@@SELECT_FREQ:
		; Segun la frecuencia	(Registros BC, B = hi-byte, C = lo-byte)
		cp 0
		jr nz, @@FREQ_300HZ
		ld bc, $0000	; OFF
		jr @@UPDATE_FREQ

		@@FREQ_300HZ:
		cp 1
		jr nz, @@FREQ_500HZ
		ld bc, $0174	; Tono en el Canal:  111,861 Hz / 372 = 300 hz ($0174)
		jr @@UPDATE_FREQ

		@@FREQ_500HZ:
		cp 2
		jr nz, @@FREQ_1KHZ
		ld bc, $00DF	; Tono en el Canal:  111,861 Hz / 223 = 501 hz ($00DF)
		jr @@UPDATE_FREQ

		@@FREQ_1KHZ:
		ld bc, $006F	; Tono en el Canal:  111,861 Hz / 111 = 1007 hz ($006F)


		@@UPDATE_FREQ:
		; Segun el canal	(Registros DE, D = hi-byte, E = lo-byte)	Frecuencia
		;					(Registros HL, H = hi-byte, L = lo-byte)	Volumen
		ld a, [PSG_TEST_CHANNEL]
		
		; Canal 1
		cp 1
		jr nz, @@CHANNEL_FREQ_2
		ld de, $0100
		ld hl, $0008
		jr @@PSG_FREQ_UPDATE

		; Canal 2
		@@CHANNEL_FREQ_2:
		cp 2
		jr nz, @@CHANNEL_FREQ_3
		ld de, $0302
		ld hl, $0009
		jr @@PSG_FREQ_UPDATE

		; Canal 3
		@@CHANNEL_FREQ_3:
		cp 3
		ret nz
		ld de, $0504
		ld hl, $000A
		jr @@PSG_FREQ_UPDATE

		; Aplica la configuracion al PSG (Melodia)
		@@PSG_FREQ_UPDATE:
		di				; Deshabilita las interrupciones
		; Frecuencia
		ld a, e			; Canal A (LO byte)
		out ($A0), a
		ld a, c			; LO byte data
		out ($A1), a
		ld a, d			; Canal A (HI byte)
		out ($A0), a
		ld a, b			; HI byte data
		out ($A1), a
		; Volumen
		ld a, l						; Seleccion del canal (lo-byte)
		out ($A0), a
		ld a, [PSG_TEST_VOLUME]		; Volumen
		out ($A1), a
		ei				; Habilita las interrupciones


		; Actualiza el cursor
		ld a, [PSG_TEST_CURSOR_Y]		; Posicion inicial Y
		ld l, a
		ld h, PSGTEST_FREQ_X_START		; Posicion inicial X
		ld a, 0
		ld b, a					; Contador
		ld a, [PSG_TEST_FREQ]	; Freq actual
		ld c, a

		@@UPDATE_FREQ_CURSOR_LOOP:
		push hl		; Guarda los registros
		push bc
		call $00C6	; Posicion el cursor. Rutina de BIOS [POSIT]
		pop bc		; Recupera los registros
		pop hl

		ld a, h		; Siguiente columna
		add a, PSGTEST_FREQ_X_GAP
		ld h, a

		ld a, b						; Lee el numero de iteracion
		cp c						; Si coincide con la opcion activa...
		jr z, @@FREQ_CURSOR_ON
		ld a, $C4					; Si no coincide, caracter OFF
		jr @@FREQ_CURSOR_PRINT

		@@FREQ_CURSOR_ON:			; Si coincide, caracter ON
		ld a, $DB

		@@FREQ_CURSOR_PRINT:
		call $00A2		; Imprime el caracter del registro A. Rutina [CHPUT] de la BIOS

		inc b			; Suma una iteracion
		ld a, 4
		cp b
		jr nz, @@UPDATE_FREQ_CURSOR_LOOP		; Si aun no se han realizado las 4 iteraciones, repite


		; Fin de la subrutina
		ret



;***********************************************************
; Cambia el volumen al canal seleccionado
;***********************************************************
	@@APPLY_VOL:

		ld a, b						; Lee la pulsacion
		cp 1						; Si se pulsa derecha
		jp nz, @@DEC_VOL			; Si se pulsa izquierda

		ld a, [PSG_TEST_VOLUME]		; Lee el volumen
		cp 15						; Si estas al maximo, sal
		ret z

		inc a						; Increnta el volumen
		ld [PSG_TEST_VOLUME], a		; y guardalo
		jr @@UPDATE_VOL

		@@DEC_VOL:
		ld a, [PSG_TEST_VOLUME]		; Lee el volumen
		cp 0						; Si estas minimo, sal
		ret z

		dec a						; Baja el volumen
		ld [PSG_TEST_VOLUME], a		; y guardalo


		@@UPDATE_VOL:
		; Segun el canal	(Registros DE, D = hi-byte, E = lo-byte)	Volumen
		ld a, [PSG_TEST_CHANNEL]
		
		; Canal 1
		cp 1
		jr nz, @@CHANNEL_VOL_2
		ld de, $0008
		jr @@PSG_VOL_UPDATE

		; Canal 2
		@@CHANNEL_VOL_2:
		cp 2
		jr nz, @@CHANNEL_VOL_3
		ld de, $0009
		jr @@PSG_VOL_UPDATE

		; Canal 3
		@@CHANNEL_VOL_3:
		cp 3
		ret nz
		ld de, $000A

		; Actualiza el volumen
		@@PSG_VOL_UPDATE:
		di							; Deshabilita las interrupciones
		; Volumen
		ld a, e						; Seleccion del canal (lo-byte)
		out ($A0), a
		ld a, [PSG_TEST_VOLUME]		; Volumen
		out ($A1), a
		ei							; Habilita las interrupciones


		; Actualiza el cursor
		ld a, [PSG_TEST_CURSOR_Y]		; Posicion inicial Y
		ld l, a
		ld h, PSGTEST_VOL_X_START		; Posicion inicial X
		ld a, 1
		ld b, a					; Contador
		ld a, [PSG_TEST_VOLUME]	; Freq actual
		ld c, a

		@@UPDATE_VOL_CURSOR_LOOP:
		push hl		; Guarda los registros
		push bc
		call $00C6	; Posicion el cursor. Rutina de BIOS [POSIT]
		pop bc		; Recupera los registros
		pop hl

		ld a, h		; Siguiente columna
		inc a
		ld h, a

		ld a, c						; Recupera el volumen actual
		sub b						; Restale el numero de iteracion
		jr nc, @@VOL_CURSOR_ON
		ld a, $C4					; Si la iteracion es mayor, caracter OFF
		jr @@VOL_CURSOR_PRINT

		@@VOL_CURSOR_ON:			; Si es igualo menor, caracter ON
		ld a, $DB

		@@VOL_CURSOR_PRINT:
		call $00A2		; Imprime el caracter del registro A. Rutina [CHPUT] de la BIOS

		inc b			; Suma una iteracion
		ld a, 16
		cp b
		jr nz, @@UPDATE_VOL_CURSOR_LOOP		; Si aun no se han realizado las 16 iteraciones, repite


		; Fin de la subrutina
		ret



;***********************************************************
; Aplica el ruido al canal seleccionado
;***********************************************************
@@APPLY_NOISE_CHANNEL:

		ld a, b						; Lee la pulsacion
		cp 1						; Si se pulsa derecha
		jp nz, @@DEC_NOISE_CHAN		; Si se pulsa izquierda

		ld a, [SNDNOISE_CHAN]		; Lee el canal asignado
		cp 3						; Si ya es el ultimo, sal
		ret z

		inc a						; Selecciona el seguiente canal
		ld [SNDNOISE_CHAN], a		; y guardalo
		jr @@UPDATE_NOISE_CHAN

		@@DEC_NOISE_CHAN:
		ld a, [SNDNOISE_CHAN]		; Lee el canal asignado
		cp 0						; Si no hay ninguno, sal
		ret z

		dec a						; Selecciona el canal anterior
		ld [SNDNOISE_CHAN], a		; y guardalo


		@@UPDATE_NOISE_CHAN:
		; Segun el canal seleccionado (Guarda la mascara en DE)
		ld a, [SNDNOISE_CHAN]
		
		; Ningun canal asignado
		cp 0
		jr nz, @@SELECT_NOISE_CHAN_1
		ld de, $0038						; Canales A, B y C como melodia 			[xx111000] (Usa logica inversa)
		jr @@PSG_NOISE_CHAN_UPDATE

		; Canal 1
		@@SELECT_NOISE_CHAN_1:
		cp 1
		jr nz, @@SELECT_NOISE_CHAN_2
		ld de, $0031						; Canal A ruido, canales B y C como melodia [xx110001] (Usa logica inversa)
		jr @@PSG_NOISE_CHAN_UPDATE

		; Canal 2
		@@SELECT_NOISE_CHAN_2:
		cp 2
		jr nz, @@SELECT_NOISE_CHAN_3
		ld de, $002A						; Canal B ruido, canales A y C como melodia [xx101010] (Usa logica inversa)
		jr @@PSG_NOISE_CHAN_UPDATE

		; Canal 3
		@@SELECT_NOISE_CHAN_3:
		cp 3
		ret nz
		ld de, $001C						; Canal C ruido, canales A y B como melodia [xx011100] (Usa logica inversa)

		; Actualiza el canal de ruido
		@@PSG_NOISE_CHAN_UPDATE:
		; Deshabilita las interrupciones
		di
		; Configura el I/O del PSG mediante el registro nº7
		ld a, 7
		out ($A0), a
		; Datos a enviar al registro 7
		ld a, e		; Mascara de la configuracion de canales
		and $3F			; Proteccion al PSG, los BITs 6 y 7 a 0		[00xxxxxx]
		or $80			; Pon el BIT 7 a 1 y el BIT 6 a 0			[10xxxxxx]
		out ($A1), a	; Escribe los datos en el registro
		; Habilita las interupciones
		ei


		; Actualiza el cursor
		ld a, [PSG_TEST_CURSOR_Y]				; Posicion inicial Y
		ld l, a
		ld h, PSGTEST_NOISE_CHAN_X_START		; Posicion inicial X
		ld a, 0
		ld b, a									; Contador
		ld a, [SNDNOISE_CHAN]					; Canal actual
		ld c, a

		@@NOISE_CHAN_UPDATE_CURSOR_LOOP:
		push hl		; Guarda los registros
		push bc
		call $00C6	; Posicion el cursor. Rutina de BIOS [POSIT]
		pop bc		; Recupera los registros
		pop hl

		ld a, h		; Siguiente columna
		add a, PSGTEST_NOISE_CHAN_X_GAP
		ld h, a

		ld a, b						; Lee el numero de iteracion
		cp c						; Si coincide con la opcion activa...
		jr z, @@NOISE_CHAN_CURSOR_ON
		ld a, $C4					; Si no coincide, caracter OFF
		jr @@NOISE_CHAN_CURSOR_PRINT

		@@NOISE_CHAN_CURSOR_ON:			; Si coincide, caracter ON
		ld a, $DB

		@@NOISE_CHAN_CURSOR_PRINT:
		call $00A2		; Imprime el caracter del registro A. Rutina [CHPUT] de la BIOS

		inc b			; Suma una iteracion
		ld a, 4
		cp b
		jr nz, @@NOISE_CHAN_UPDATE_CURSOR_LOOP		; Si aun no se han realizado las 4 iteraciones, repite


		; Fin de la subrutina
		ret



;***********************************************************
; Cambia la frecuencia del canal de ruido
;***********************************************************
	@@APPLY_NOISE_FREQ:

		ld a, b						; Lee la pulsacion
		cp 1						; Si se pulsa derecha
		jp nz, @@DEC_NOISE_FREQ		; Si se pulsa izquierda

		ld a, [SNDNOISE_FRQ]		; Lee la frecuencia actual
		cp 15						; Si estas al maximo, sal
		ret z

		inc a						; Incremeta la frecuencia
		ld [SNDNOISE_FRQ], a		; y guardala
		jr @@PSG_NOISE_FREQ_UPDATE

		@@DEC_NOISE_FREQ:
		ld a, [SNDNOISE_FRQ]		; Lee la frecuencia actual
		cp 0						; Si estas minimo, sal
		ret z

		dec a						; Reduce la frecuencia
		ld [SNDNOISE_FRQ], a		; y guardala


		; Calcula la frecuencia segun el registro A
		@@PSG_NOISE_FREQ_UPDATE:
		sla a			; Multiplica x2 el valor
		ld b, a			; y guardalo en B
		ld a, $1F		; Frecuencia mas baja (mas valor, menos frecuencia)
		sub b			; Restale a la frecuencia minima el valor calculado
		ld c, a			; El resultado final, guardalo en C

		; Actualiza el PSG
		di							; Deshabilita las interrupciones
		; Frecuencia del ruido
		ld a, 6						; Seleccion del canal de ruido
		out ($A0), a
		ld a, c						; Frecuencia
		out ($A1), a
		ei							; Habilita las interrupciones


		; Actualiza el cursor
		ld a, [PSG_TEST_CURSOR_Y]				; Posicion inicial Y
		ld l, a
		ld h, PSGTEST_NOISE_FREQ_X_START		; Posicion inicial X
		ld a, 1
		ld b, a									; Contador
		ld a, [SNDNOISE_FRQ]					; Freq actual
		ld c, a

		@@UPDATE_NOISE_FREQ_CURSOR_LOOP:
		push hl		; Guarda los registros
		push bc
		call $00C6	; Posicion el cursor. Rutina de BIOS [POSIT]
		pop bc		; Recupera los registros
		pop hl

		ld a, h		; Siguiente columna
		inc a
		ld h, a

		ld a, c						; Recupera el volumen actual
		sub b						; Restale el numero de iteracion
		jr nc, @@NOISE_FREQ_CURSOR_ON
		ld a, $C4					; Si la iteracion es mayor, caracter OFF
		jr @@NOISE_FREQ_CURSOR_PRINT

		@@NOISE_FREQ_CURSOR_ON:			; Si es igualo menor, caracter ON
		ld a, $DB

		@@NOISE_FREQ_CURSOR_PRINT:
		call $00A2		; Imprime el caracter del registro A. Rutina [CHPUT] de la BIOS

		inc b			; Suma una iteracion
		ld a, 16
		cp b
		jr nz, @@UPDATE_NOISE_FREQ_CURSOR_LOOP		; Si aun no se han realizado las 16 iteraciones, repite


		; Fin de la subrutina
		ret



;***********************************************************
; Fin del archivo
;***********************************************************
PSG_TEST_EOF: