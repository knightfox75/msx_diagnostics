;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.1-WIP01
;	ASM Z80 MSX
;	Test de color del monitor
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************


; ----------------------------------------------------------
; Menu del Test MONITOR COLOR
; ----------------------------------------------------------

FUNCTION_MONITOR_COLOR_TEST_MENU:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Texto del menu
	call FUNCTION_MAIN_MENU_HEADER_PRINT		            ; Cabecera
	ld hl, TEXT_MONITOR_COLOR_MENU_TITLE                    ; Titulo
	call NGN_TEXT_PRINT							            ; Imprimelo
	ld hl, TEXT_DASHED_LINE						            ; Linea
	call NGN_TEXT_PRINT							            ; Imprimelo
	ld hl, TEXT_MONITOR_COLOR_MENU_INSTRUCTIONS             ; Instrucciones de uso
	call NGN_TEXT_PRINT							            ; Imprimelo
	ld hl, TEXT_MENU_CANCEL						            ; Como cancelar
	call NGN_TEXT_PRINT							            ; Imprimelo
	ld hl, TEXT_MENU_FOOTER						            ; Pie del menu
	call NGN_TEXT_PRINT							            ; Imprimelo

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044

	; Bucle de ejecucion
	@@LOOP:

		; Lectura del HID
		call FUNCTION_SYSTEM_HID_READ

		; Si se pulsa la tecla  "ACEPTAR"
		ld a, [SYSKEY_ACCEPT]
		and $02								                ; Detecta "KEY DOWN"
		jp nz, FUNCTION_MONITOR_COLOR_TEST_RUN              ; Ejecuta el test

		; Si se pulsa la tecla  "CANCELAR"
		ld a, [SYSKEY_CANCEL]
		and $02								                ; Detecta "KEY DOWN"
		ret nz								                ; Vuelve al menu principal

		; Espera a la interrupcion del VDP (VSYNC)
        call NGN_SCREEN_WAIT_VBL

		; Repite el bucle
		jr @@LOOP



; ----------------------------------------------------------
; Ejecuta el test
; ----------------------------------------------------------

FUNCTION_MONITOR_COLOR_TEST_RUN:

	; Borra la pantalla
	call NGN_TEXT_CLS

    ; Contador de frames a 0
    xor a
    ld [MONITOR_COLOR_FRAME], a
    ; Color por defecto
    ld bc, $010F
    call NGN_TEXT_COLOR
    ; Texto por defecto
    ld hl, $0F0B
    call NGN_TEXT_POSITION
    ld hl, TEXT_MONITOR_COLOR_WHITE
    call NGN_TEXT_PRINT
    ld hl, TEXT_MONITOR_COLOR_TEST
    call NGN_TEXT_PRINT

    ; Guarda el nº de test
    ; 1 = WHITE, 2 = BLACK, 3 = RED, 4 = GREEN, 5 = BLUE, 6 = CICLO DE COLOR
    ld a, 1     ; Primer test
    ld [MONITOR_COLOR_CURRENT_ITEM], a

	; Bucle de ejecucion
	@@LOOP:

		; Lectura del HID
		call FUNCTION_SYSTEM_HID_READ

		; Si se pulsa "DERECHA", siguiente tipo de test
		ld a, [SYSKEY_RIGHT]
		and $02					; Detecta "KEY DOWN"
		jp nz, @@NEXT_TEST

		; Si se pulsa "IZQUIERDA", tipo de test previo
		ld a, [SYSKEY_LEFT]
		and $02					; Detecta "KEY DOWN"
		jp nz, @@PREV_TEST

        ; Si esta seleccionado el ciclo de colores, ejecutalo
        ld a, [MONITOR_COLOR_CURRENT_ITEM]
        cp 6
        jp z, @@COLOR_LOOP

        ; Si es alguno de los otros test, cuenta atras
        ld a, [MONITOR_COLOR_FRAME]      ; Frame actual
        cp 120                                  ; Si ya has alcanzado la marca
        jr z, @@LOOP_END                        ; No hagas nada
        inc a                                   ; Si no, suma 1
        ld [MONITOR_COLOR_FRAME], a      ; Guarda el numero de frames
        cp 120                                  ; Si no se ha alcanzado la marca
        jr nz, @@LOOP_END                       ; No hagas nada
        call NGN_TEXT_CLS                       ; Si no, borra la pantalla

		; Punto de final del bucle
		@@LOOP_END:

		; Actualiza el sonido
		call SFX_FUNCTION_UPDATE

		; Si se pulsa la tecla  "CANCELAR"
		ld a, [SYSKEY_CANCEL]
		and $02					; Detecta "KEY DOWN"
		jr nz, @@EXIT			; Sal del bucle

		; Espera a la interrupcion del VDP (VSYNC)
        call NGN_SCREEN_WAIT_VBL

		; Repite el bucle
		jr @@LOOP


	; Sal al menu principal
	@@EXIT:
		
		call SFX_FUNCTION_CLOSE		; Cierra el sonido
		ret							; Vuelve al menu principal


    ; ----------------------------------------------------------
    ; Siguiente tipo de test
    ; ----------------------------------------------------------

    @@NEXT_TEST:
        ld a, [MONITOR_COLOR_CURRENT_ITEM]   ; Recupera la opcion actual
        inc a
        cp (MONITOR_COLOR_ITEM_LAST + 1)     ; Si es la ultima opcion
        jr nz, @@APPLY_TEST
        ld a, MONITOR_COLOR_ITEM_FIRST       ; Vuelve a la primera
        jr @@APPLY_TEST


    ; ----------------------------------------------------------
    ; Tipo de test previo
    ; ----------------------------------------------------------

    @@PREV_TEST:
        ld a, [MONITOR_COLOR_CURRENT_ITEM]   ; Recupera la opcion actual
        dec a
        cp (MONITOR_COLOR_ITEM_FIRST - 1)    ; Si es la primera opcion
        jr nz, @@APPLY_TEST
        ld a, MONITOR_COLOR_ITEM_LAST        ; Vuelve a la ultima
        jr @@APPLY_TEST


    ; ----------------------------------------------------------
    ; Aplica el test
    ; ----------------------------------------------------------

    @@APPLY_TEST:

        ld [MONITOR_COLOR_CURRENT_ITEM], a      ; Guarda la opcion actualizada

        push af
        call NGN_TEXT_CLS                       ; Borra la pantalla
        xor a                                   ; Contador de frames a 0
        ld [MONITOR_COLOR_FRAME], a
        pop af
        
        cp 1                         ; Test nº1 - Pantalla en blanco
        jr nz, @@TEST_2
        ld hl, $0F0B
        call NGN_TEXT_POSITION
        ld hl, TEXT_MONITOR_COLOR_WHITE
        call NGN_TEXT_PRINT
        ld bc, $010F                ; Color blanco de fondo
        jr @@TEST_SET_COLOR         ; Fija el color

        @@TEST_2:
        cp 2                        ; Test nº2 - Pantalla en negro
        jr nz, @@TEST_3
        ld hl, $0F0B
        call NGN_TEXT_POSITION
        ld hl, TEXT_MONITOR_COLOR_BLACK
        call NGN_TEXT_PRINT
        ld bc, $0F01                ; Color negro de fondo
        jr @@TEST_SET_COLOR         ; Fija el color

        @@TEST_3:
        cp 3                        ; Test nº3 - Pantalla en ROJO
        jr nz, @@TEST_4
        ld hl, $100B
        call NGN_TEXT_POSITION
        ld hl, TEXT_MONITOR_COLOR_RED
        call NGN_TEXT_PRINT
        ld bc, $0109                ; Color rojo de fondo
        jr @@TEST_SET_COLOR         ; Fija el color

        @@TEST_4:
        cp 4                        ; Test nº4 - Pantalla en VERDE
        jr nz, @@TEST_5
        ld hl, $0F0B
        call NGN_TEXT_POSITION
        ld hl, TEXT_MONITOR_COLOR_GREEN
        call NGN_TEXT_PRINT
        ld bc, $0103                ; Color verde de fondo
        jr @@TEST_SET_COLOR         ; Fija el color

        @@TEST_5:
        cp 5                        ; Test nº5 - Pantalla en AZUL
        jr nz, @@TEST_6
        ld hl, $0F0B
        call NGN_TEXT_POSITION
        ld hl, TEXT_MONITOR_COLOR_BLUE
        call NGN_TEXT_PRINT
        ld bc, $0105                ; Color azul de fondo
        jr @@TEST_SET_COLOR         ; Fija el color

        @@TEST_6:
        ld hl, $0E0B
        call NGN_TEXT_POSITION
        ld hl, TEXT_MONITOR_COLOR_LOOP
        call NGN_TEXT_PRINT
        ld hl, TEXT_MONITOR_COLOR_TEST          ; Texto del test
        call NGN_TEXT_PRINT
        ld bc, $0102                            ; Color inicial de fondo
        ld a, 2
        ld [MONITOR_COLOR_CURRENT_COLOR], a     ; Color inicial
        ld a, 8                                 ; Tiempo de espera inicial
        ld [MONITOR_COLOR_DELAY], a
        xor a                                   ; Contador de frames a 0
        ld [MONITOR_COLOR_FRAME], a
        jp @@LOOP_END                           ; Vuelve al bucle principal

        @@TEST_SET_COLOR:
        call NGN_TEXT_COLOR                     ; Actualiza el color
        ld hl, TEXT_MONITOR_COLOR_TEST          ; Texto del test
        call NGN_TEXT_PRINT
        jp @@LOOP_END                           ; Vuelve al bucle principal


    ; ----------------------------------------------------------
    ; Aplica el ciclo de colores
    ; ----------------------------------------------------------

    @@COLOR_LOOP:

		; Si se pulsa "ARRIBA", aumenta la velocidad
		ld a, [SYSKEY_UP]
		and $02					; Detecta "KEY DOWN"
		call nz, @@SPEED_UP

		; Si se pulsa "ABAJO", disminuye la velocidad
		ld a, [SYSKEY_DOWN]
		and $02					; Detecta "KEY DOWN"
		call nz, @@SPEED_DOWN


        @@NEXT_COLOR:

        ld a, [MONITOR_COLOR_DELAY]      ; Numero de frames de espera
        ld b, a
        ld a, [MONITOR_COLOR_FRAME]      ; Frame actual
        inc a                                   ; Sumale 1
        ld [MONITOR_COLOR_FRAME], a      ; Guarda el frame actual
        sub b                                   ; Verifica si aun no se ha alcanzado (si la resta es menor de 0)
        jp c, @@LOOP_END                        ; Vuelve al bucle principal

        xor a                                   ; Reinicia el contador de frames
        ld [MONITOR_COLOR_FRAME], a

        ld a, [MONITOR_COLOR_CURRENT_COLOR];     ; Lee el color actual
        ld b, 1     ; Prepara para aplicarlo al fondo
        ld c, a
        inc a       ; Prepara el siguiente color
        cp 16       ; Era el ultimo?
        jp nz, @@UPDATE_COLOR       ; Si no es el ultimo color, actualizalo
        ld a, 2                     ; Si lo era, vuelve al primer color del ciclo
        @@UPDATE_COLOR:
        ld [MONITOR_COLOR_CURRENT_COLOR], a
        call NGN_TEXT_COLOR         ; Actualiza el color
        jp @@LOOP_END               ; Vuelve al bucle principal


    @@SPEED_UP:
        ld a, [MONITOR_COLOR_DELAY]
        cp 1
        ret z       ; Si ya es 1 vuelve
        srl a       ; Dividela /2
        ld [MONITOR_COLOR_DELAY], a
        jp SFX_FUNCTION_PLAY_PING               ; Sonido y vuelve (RET al final de la llamada)

    @@SPEED_DOWN:
        ld a, [MONITOR_COLOR_DELAY]
        cp 64
        ret z       ; Si ya es 64, vuelve
        sla a       ; Multiplicala x2
        ld [MONITOR_COLOR_DELAY], a
        jp SFX_FUNCTION_PLAY_PONG               ; Sonido y vuelve (RET al final de la llamada)



;***********************************************************
; Fin del archivo
;***********************************************************
MONITOR_COLOR_TEST_EOF: