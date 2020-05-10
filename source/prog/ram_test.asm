;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.9
;	ASM Z80 MSX
;	Test de la memoria RAM
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************





; ----------------------------------------------------------
; Muestra el resumen de la configuracion de la memoria
; RAM instalada
; ----------------------------------------------------------
FUNCTION_RAM_TEST_LAYOUT_REPORT:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; ----------------------------------------------------------
	;  Impresion de la informacion: Cabecera
	; ----------------------------------------------------------

    ; Titulo
    ld hl, TEXT_RAM_INFO_HEADER
    call NGN_TEXT_PRINT
    ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo

    ; Lista de bancos de RAM
	ld hl, $0104								; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
	ld hl, TEXT_RAM_TEST_HEADER				    ; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo

    ; ----------------------------------------------------------
    ; Obten y muestra la informacion de la memoria RAM
    ; (TODOS LOS SLOTS)
    ; ----------------------------------------------------------
    ld a, $FF                           ; Muestra TODA la informacion
    ld [(NGN_RAM_BUFFER + RAM_TEST_SHOW_ALL_INFO)], a
    ld hl, $0906                        ; Posicion inicial
    call FUNCTION_RAM_DISPLAY_INFO
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo

	; ----------------------------------------------------------
	;  Impresion de la informacion: Pie de pagina
	; ----------------------------------------------------------
    ld hl, $0118
    call NGN_TEXT_POSITION
    ld hl, TEXT_SYSTEM_INFO_EXIT
    call NGN_TEXT_PRINT

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044


    ; ----------------------------------------------------------
    ; Espera a que se pulse aceptar o cancelar para salir
    ; ----------------------------------------------------------

    @@LOOP:

        ; Lectura del HID
        call FUNCTION_SYSTEM_HID_READ

        ; Si se pulsa la tecla  "ACEPTAR"
        ld a, [SYSKEY_ACCEPT]
        and $02		                    ; Detecta "KEY DOWN"
        ret nz

        ; Si se pulsa la tecla  "CANCELAR"
        ld a, [SYSKEY_CANCEL]
        and $02		                    ; Detecta "KEY DOWN"
        ret nz

        ; Espera a la interrupcion del VDP (VSYNC)
        halt

        ; Repite el bucle
        jr @@LOOP





; ----------------------------------------------------------
; Menu del test de memoria RAM
; ----------------------------------------------------------
FUNCTION_RAM_TEST_MENU:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; ----------------------------------------------------------
	;  Impresion de la informacion: Cabecera
	; ----------------------------------------------------------

    ; Lista de bancos de RAM
	ld hl, $0101								; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
	ld hl, TEXT_RAM_TEST_HEADER				    ; Titulo
	call NGN_TEXT_PRINT							; Imprimelo
	ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo


    ; ----------------------------------------------------------
    ; Obten y muestra la informacion de la memoria RAM
    ; (solo los slots disponibles)
    ; ----------------------------------------------------------
    xor a                       ; Muestra solo la informacion presente
    ld [(NGN_RAM_BUFFER + RAM_TEST_SHOW_ALL_INFO)], a
    ld hl, $0903                ; Posicion incial
    call FUNCTION_RAM_DISPLAY_INFO


    ; ----------------------------------------------------------
	;  Impresion de la informacion: Pie de pagina
	; ----------------------------------------------------------
	ld hl, $0116								; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
    ld hl, TEXT_DASHED_LINE						; Linea
	call NGN_TEXT_PRINT							; Imprimelo
    ld hl, TEXT_RAM_TEST_HELP			        ; Instrucciones de ayuda
	call NGN_TEXT_PRINT							; Imprimelo


	ld hl, $0103								; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
    ld a, $C0
    call $00A2      ; [CHPUT]


	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044

    ; Prepara los datos del menu
    xor a
    ld [(NGN_RAM_BUFFER + RAM_TEST_FIRST_OPTION)], a        ; Primera opcion del menu
    ld [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)], a         ; Opcion actual del seleccionada
    ld [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR + 1)], a     ; Ultima opcion seleccionada
    ld a, [(NGN_RAM_BUFFER + RAM_TEST_TOTAL_OPTIONS)]
    dec a
    ld [(NGN_RAM_BUFFER + RAM_TEST_LAST_OPTION)], a         ; Ultima opcion del menu



    ; ----------------------------------------------------------
	;  Menu de seleccion
	; ----------------------------------------------------------

	; Bucle de ejecucion
	@@LOOP:

		; Lectura del HID
		call FUNCTION_SYSTEM_HID_READ


		; Si se pulsa la tecla  "CANCELAR"
		ld a, [SYSKEY_CANCEL]
		and $02		                    ; Detecta "KEY DOWN"
		ret nz							; Vuelve al menu principal


        ; Si se pulsa arriba
		ld a, [SYSKEY_UP]
		and $02			                ; Detecta "KEY DOWN"
		jr z, @@M_DOWN                  ; Si no se cumple, siguiente
		
        ld a, [(NGN_RAM_BUFFER + RAM_TEST_FIRST_OPTION)]    ; Carga la primera opcion
        ld b, a
		ld a, [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)]     ; Carga la opcion actual
		cp b                            ; Si ya estas en el limite, continua
        jr z, @@M_END
		dec a							; Resta una opcion
		ld [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)], a	    ; Guarda la seleccion
		jr @@M_UPDATE


		; Si se pulsa abajo
		@@M_DOWN:
		ld a, [SYSKEY_DOWN]
		and $02								; Detecta "KEY DOWN"
		jr z, @@M_ACCEPT                    ; Si no se cumple, siguiente

        ld a, [(NGN_RAM_BUFFER + RAM_TEST_LAST_OPTION)]     ; Carga la primera opcion
        ld b, a
		ld a, [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)]     ; Carga la opcion actual
		cp b                            ; Si ya estas en el limite, continua
        jr z, @@M_END
		inc a							; Resta una opcion
		ld [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)], a	    ; Guarda la seleccion
				

		; Actualiza el cursor si es necesario
		@@M_UPDATE:
        ld h, 1         ; Borra la el cursor actual
        ld a, [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR + 1)]
        add 3           ; Correccion de posicion
        ld l, a
        call NGN_TEXT_POSITION
        ld a, $20
        call $00A2      ; [CHPUT]
        
        ld h, 1         ; Escribe el cursor en la posicion nueva
        ld a, [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)]
        ld [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR + 1)], a
        add 3           ; Correccion de posicion
        ld l, a
        call NGN_TEXT_POSITION
        ld a, $C0
        call $00A2      ; [CHPUT]
        jr @@M_END


		; Fin de las rutinas del menu, aceptacion de la opcion
		@@M_ACCEPT:
		ld a, [SYSKEY_ACCEPT]
		and $02								; Detecta "KEY DOWN"
		jr z, @@M_END					    ; Salta si no se pulsa

        ; Opcion aceptada, guarda el slot/sub-slot a analizar
        ld hl, (NGN_RAM_BUFFER + RAM_TEST_OPTION_LIST)
        ld d, 0
        ld a, [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)]
        ld e, a
        add hl, de
        ld a, [hl]
        ld [MEMORY_SLOT_ID], a
        ; Ejecuta el test de RAM
        jp FUNCTION_RAM_TEST_RUN

 
        ; Fin del menu
        @@M_END:
		; Espera a la interrupcion del VDP (VSYNC)
        halt

		; Repite el bucle
		jr @@LOOP



; ----------------------------------------------------------
; Muestra y registra la informacion de la memoria RAM
; HL = Posicion inicial
; ----------------------------------------------------------
FUNCTION_RAM_DISPLAY_INFO:

    ; ----------------------------------------------------------
	;  Impresion de la informacion: Parrilla de datos
	; ----------------------------------------------------------

    ; Posicion inicial del cursor
    ld [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)], hl

    ; Prepara la cadena de texto
    ld hl, TEXT_RAM_TEST_SLOT_ID
    ld de, (NGN_RAM_BUFFER + RAM_TEST_TEMP_STRING)
    ld bc, $0007
    ldir

    ; Conteo de offset para la seleccion de slot/subslot
    xor a
    ld [(NGN_RAM_BUFFER + RAM_TEST_SLOT_INFO_OFFSET)], a
    ; Total de slots
    ld [(NGN_RAM_BUFFER + RAM_TEST_TOTAL_OPTIONS)], a

    ; Bucle de impresion de slots
    ld bc, $0400                    ; 4 Slots
    @@SLOTS_GUI_LOOP:

        push bc                     ; Preserva los contadores
        ld a, c                     ; Numero actual de slot
        ld [MEMORY_CURRENT_SLOT], a
        
        ; Caracter para el numero de slot
        ld hl, (NGN_RAM_BUFFER + RAM_TEST_TEMP_STRING + 2)
        ld a, c
        add $30
        ld [hl], a

        ; Bucle de los sub-slots
        ld bc, $0400                    ; 4 sub-slots
        @@SUBSLOTS_GUI_LOOP:

            push bc                     ; Preserva los sub-contadores

            ; Lee el slot y guardalo en E
            ld a, [MEMORY_CURRENT_SLOT]
            ld e, a
            ; Lee el sub-slot
            ld a, c
            ld [MEMORY_CURRENT_SUBSLOT], a  ; Guarda el sub-slot en curso
            ; Define el slot y subslot
            sla a       ; << 2 
            sla a       ; Coloca el nº de sub-slot en los bits 2 y 3
            or e        ; Numero de slot
            ld [MEMORY_SLOT_ID], a
            ; Esta expandido?
            ld hl, MEMORY_SLOT_EXPANDED         ; Variable de informacio de expansiones
            ld d, $00                           ; Prepara el offset sobre la variable
            ld a, [MEMORY_CURRENT_SLOT]         ; Segun el slot
            ld e, a                             
            add hl, de                          ; Aplica el offset
            ld a, [hl]                          ; Lee el valor
            or a                                ; Si es cero, no pongas el flag
            jr z, @@SLOT_ID_DONE
            ld a, [MEMORY_SLOT_ID]              ; Si esta expandido, marcalo
            set 7, a
            ld [MEMORY_SLOT_ID], a

            @@SLOT_ID_DONE:
            ; Resetea el flag de slot con contenido
            xor a
            ld [(NGN_RAM_BUFFER + RAM_TEST_SLOT_OK)], a

            exx             ; Preserva los registros actuales
            ld a, [(NGN_RAM_BUFFER + RAM_TEST_SLOT_INFO_OFFSET)]    ; Carga el offset actual
            ld e, a                                                 ; en DE
            ld d, 0
            ld hl, RAM_SLOT_0                                       ; Selecciona la variable de INFO de slots
            add hl, de                                              ; Aplica el offset
            ld a, [hl]                                              ; Carga la info
            ld [(NGN_RAM_BUFFER + RAM_TEST_SLOT_INFO)], a
            exx             ; Restaura los registros

            ; Este sub-slot, esta vacio?
            ; Y no se ha marcado que se fuerce mostrarlo
            ld a, [(NGN_RAM_BUFFER + RAM_TEST_SHOW_ALL_INFO)]
            ld e, a
            ld a, [(NGN_RAM_BUFFER + RAM_TEST_SLOT_INFO)]
            or a
            or e
            jp z, @@SKIP_THIS_SUBSLOT

            ; No esta vacio, indicalo
            ld a, $FF
            ld [(NGN_RAM_BUFFER + RAM_TEST_SLOT_OK)], a

            ; Caracter para el numero de sub-slot (C)
            ld hl, (NGN_RAM_BUFFER + RAM_TEST_TEMP_STRING + 4)
            ld a, c
            add $30
            ld [hl], a

            ld hl, (NGN_RAM_BUFFER + RAM_TEST_TEMP_STRING)      ; Ubicacion del texto
	        call NGN_TEXT_PRINT							        ; Imprimelo

            ; Bucle para el contador de paginas
            ld bc, $0400
            @@PAGE_GUI_LOOP:

                push bc                 ; Preserva el contador

                ld a, c                 ; Registra el numero de pagina
                ld [MEMORY_CURRENT_PAGE], a

                ; Posiciona el texto
                ld hl, [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)]
                call NGN_TEXT_POSITION

                ; Imprime la cantidad de Kb en esta pagina
                call FUNCION_MEMORY_GET_RAM_BANK_SIZE_VARIABLE      ; Variable guardada en HL
                ld b, [hl]
                inc hl
                ld c, [hl]
                ; Esta a 0?
                ld a, b
                or c
                jr z, @@NO_PRINT_ZERO
                call NGN_TEXT_PRINT_INTEGER                         ; Imprimela
                ; KB
                ld a, $4B
                call $00A2      ; [CHPUT]
                ld a, $42
                call $00A2      ; [CHPUT]
                jr @@NEXT_COLUMN

                ; No Imprimas ceros
                @@NO_PRINT_ZERO:
                push bc         ; Preserva BC durante este bucle
                ld b, 6
                @@NO_ZERO_LOOP:
                    ld a, $C3
                    call $00A2      ; [CHPUT]
                    djnz @@NO_ZERO_LOOP
                pop bc          ; Recupera BC

                ; Actualiza el contador de este bucle
                @@NEXT_COLUMN:
                pop bc                  ; Recupera el contador
                inc c                   ; Siguiente pagina

                ; Mueve el cabezal de escritura
                ld hl, [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)]
                ld de, $0800
                add hl, de
                ld [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)], hl

                ; Detecta si es memoria mapeada
                ld a, [(NGN_RAM_BUFFER + RAM_TEST_SLOT_INFO)]
                bit 7, a                                                ; Si es un MAPPER, indicalo y sal
                jr nz, @@ITS_A_MAPPER

                ; Repite
                dec b
                jp nz, @@PAGE_GUI_LOOP
                jr @@NEXT_SUBSLOT


            @@ITS_A_MAPPER:
            exx         ; Backup de todos los registros

            ld hl, [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)]
            call NGN_TEXT_POSITION
            ld hl, TEXT_RAM_TEST_MAPPED     ; "MAPPED"
	        call NGN_TEXT_PRINT				; Imprimelo

            ld hl, [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)]
            ld de, $0800
            add hl, de
            ld [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)], hl
            call NGN_TEXT_POSITION
            ld a, $49
            call $00A2      ; [CHPUT]
            ld a, $4E
            call $00A2      ; [CHPUT]
            ld a, $20
            call $00A2      ; [CHPUT]
            call FUNCION_MEMORY_GET_RAM_BANK_SIZE_VARIABLE      ; Numero de paginas del mapper
            inc hl          ; Estan guardadas
            inc hl          ; en la pagina 1
            ld b, [hl]
            inc hl
            ld c, [hl]
            call NGN_TEXT_PRINT_INTEGER

            ld hl, [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)]
            ld de, $0800
            add hl, de
            ld [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)], hl
            call NGN_TEXT_POSITION
            ld hl, TEXT_RAM_TEST_PAGES     ; " PAGES"
	        call NGN_TEXT_PRINT				; Imprimelo

            exx         ; Recupera todos los registros



            ; Siguiente offset de slot/subslot
            @@NEXT_SUBSLOT:

            ; Salto de linea
            ld a, $0D
            call $00A2      ; [CHPUT]
            ld a, $0A
            call $00A2      ; [CHPUT]
            ; Reinicia el cabezal de escritura
            ld hl, [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)]
            ld h, $09
            inc l
            ld [(NGN_RAM_BUFFER + RAM_TEST_TEMP_CURSOR)], hl

            @@SKIP_THIS_SUBSLOT:
            ; Calcula el siguiente sub-slot
            ld a, [(NGN_RAM_BUFFER + RAM_TEST_SLOT_INFO_OFFSET)]
            inc a
            ld [(NGN_RAM_BUFFER + RAM_TEST_SLOT_INFO_OFFSET)], a

            pop bc      ; Recupera los sub-contadores

            ; Si el slot no esta vacio, indicalo y ponlo en la lista
            ld a, [(NGN_RAM_BUFFER + RAM_TEST_SLOT_OK)]
            or a
            jr z, @@EMPTY_SUBSLOT       ; Esta vacio, no lo registres

            ld a, [(NGN_RAM_BUFFER + RAM_TEST_TOTAL_OPTIONS)]       ; nº de elementos de la lista actualmente
            ld d, 0
            ld e, a
            ld hl, (NGN_RAM_BUFFER + RAM_TEST_OPTION_LIST)          ; Incio de la lista
            add hl, de                                              ; Calcula el offset segun el nº de elementos
            ld a, [MEMORY_SLOT_ID]                                  ; ID de slot/sub-slot actual
            ld [hl], a                                              ; Registrala en la lista
            ld a, [(NGN_RAM_BUFFER + RAM_TEST_TOTAL_OPTIONS)]       ; Actualiza el contador de elementos de la lista
            inc a
            ld [(NGN_RAM_BUFFER + RAM_TEST_TOTAL_OPTIONS)], a


            @@EMPTY_SUBSLOT:
            inc c                       ; Siguiente sub-slot

            dec b
            jp nz, @@SUBSLOTS_GUI_LOOP

        pop bc                      ; Recupera los contadores

        inc c                       ; Siguiente slot

        dec b
        jp nz,  @@SLOTS_GUI_LOOP

        ; Sal de la funcion
        ret



; ----------------------------------------------------------
; Ejecuta test de memoria RAM
; ----------------------------------------------------------
FUNCTION_RAM_TEST_RUN:

    ; Guarda el slot seleccionado y el sub-slot
    ld a, [MEMORY_SLOT_ID]                  ; Lee la ID de slot
    and $03                                 ; Bitmask para el slot
    ld [MEMORY_CURRENT_SLOT], a             ; Guardalo
    ld a, [MEMORY_SLOT_ID]                  ; Lee la ID de slot
    srl a                                   ; >> 2
    srl a                                   ; Para el sub-slot
    and $03                                 ; Bitmask para el sub-slot
    ld [MEMORY_CURRENT_SUBSLOT], a          ; Guardalo


	; Borra la pantalla
	call NGN_TEXT_CLS

    ; Informa del slot que se va a probar
    call FUNCTION_RAM_PRINT_SLOT_INFO


    ; Busca que bancos has de analizar
    call FUNCION_MEMORY_GET_CURRENT_SLOT_VARIABLE
    ld a, [hl]                              ; Lee la informacion del slot
    ld [MEMORY_CURRENT_LAYOUT], a           ; Y guardala

    ; Pasa a buscar en que paginas se realizara el test
    xor a
    ld [(NGN_RAM_BUFFER + RAM_TEST_PAGES_TO_TEST)], a       ; Contador de paginas a 0

    ; Es un mapper?
    ld a, [MEMORY_CURRENT_LAYOUT]
    bit 7, a
    jr z, @@IS_PAGED_MEMORY
    ; Si en un mapper
    ld a, 1
    ld [(NGN_RAM_BUFFER + RAM_TEST_PAGES_TO_TEST)], a       ; Solo tendra una pagina
    ld a, $F0       ; [MAPPED?][PAGE Nº]
    ld [(NGN_RAM_BUFFER + RAM_TEST_PAGES_LIST)], a          ; Indica que es un mapper y la pagina de analisis
    jp FUNCTION_RAM_MAPPED_TEST                             ; Ejecuta el test para memoria mapeada


    @@IS_PAGED_MEMORY:

    jp FUNCTION_RAM_PAGED_TEST                              ; Ejecuta el test para memoria paginada



; ----------------------------------------------------------
; Imprime la informacion del slot
; ----------------------------------------------------------

FUNCTION_RAM_PRINT_SLOT_INFO:

    ; Informa del slot que se va a probar
    ld hl, TEXT_RAM_TEST_TESTING_SLOT
    call NGN_TEXT_PRINT
    ld b, 0
    ld a, [MEMORY_CURRENT_SLOT]
    ld c, a
    call NGN_TEXT_PRINT_INTEGER
    ld a, $2D
    call $00A2      ; [CHPUT]
    ld b, 0
    ld a, [MEMORY_CURRENT_SUBSLOT]
    ld c, a
    call NGN_TEXT_PRINT_INTEGER
    ld hl, TEXT_NEW_LINE
    call NGN_TEXT_PRINT

    ; Sal de la rutina
    ret



; ----------------------------------------------------------
; Espera a que se pulse aceptar o cancelar para
; volver al menu
; ----------------------------------------------------------

FUNCTION_RAM_GOTO_MENU:

    ; Lectura del HID
    call FUNCTION_SYSTEM_HID_READ

    ; Si se pulsa la tecla  "ACEPTAR"
    ld a, [SYSKEY_ACCEPT]
    and $02		                    ; Detecta "KEY DOWN"
    jp nz, FUNCTION_RAM_TEST_MENU	; Vuelve al menu

    ; Si se pulsa la tecla  "CANCELAR"
    @@M_CANCEL:
    ld a, [SYSKEY_CANCEL]
    and $02		                    ; Detecta "KEY DOWN"
    jp nz, FUNCTION_RAM_TEST_MENU	; Vuelve al menu

    ; Espera a la interrupcion del VDP (VSYNC)
    halt

    ; Repite el bucle
    jr FUNCTION_RAM_GOTO_MENU



; ----------------------------------------------------------
; Test de memoria mapeada
; ----------------------------------------------------------
FUNCTION_RAM_MAPPED_TEST:

    ; Prepara la informacion para el test de mapper
    xor a
    ld [MEMORY_CURRENT_PAGE], a     ; Selecciona la pagina 0
    
    ; Caracteristicas del mapper (tamaño total y paginas)
    call FUNCION_MEMORY_GET_RAM_BANK_SIZE_VARIABLE                  ; Devuelve en HL la direccion de la informacion
    ld de, (NGN_RAM_BUFFER + RAM_TEST_MAPPED_TOTAL_KB)              ; Destino de la informacion
    ld bc, $0004        ; Copia 4 bytes
    ldir

    ; Imprime el resumen
    ld hl, (NGN_RAM_BUFFER + RAM_TEST_MAPPED_TOTAL_KB)              ; Total de KB
    ld b, [hl]
    inc hl
    ld c, [hl]
    call NGN_TEXT_PRINT_INTEGER                                     ; Imprimelos
    ld hl, TEXT_SYSTEM_INFO_KB                                      ; Junto a los textos adicionales
    call NGN_TEXT_PRINT
    ld hl, TEXT_RAM_TEST_IN
    call NGN_TEXT_PRINT
    ld hl, (NGN_RAM_BUFFER + RAM_TEST_MAPPED_TOTAL_PAGES)           ; Numero total de paginas
    ld b, [hl]
    inc hl
    ld c, [hl]
    push bc     ;                                                   ; Guarda en BC el numero de paginas totales
    call NGN_TEXT_PRINT_INTEGER                                     ; Imprimelas
    ld a, $20                                                       ; Junto a los textos adicionales
    call $00A2      ; [CHPUT]
    ld hl, TEXT_RAM_TEST_PAGES
    call NGN_TEXT_PRINT
    ; Salto de linea
    ld hl, TEXT_NEW_LINE
    call NGN_TEXT_PRINT
    ; Salto de linea
    ld hl, TEXT_NEW_LINE
    call NGN_TEXT_PRINT


    ; Datos iniciales
    ld hl, $0000
    ld [(NGN_RAM_BUFFER + RAM_TEST_SLOT_ERRORS)], hl        ; Numero de errores encontrados

    ; Bucle de ejecucion
    pop bc                  ; Recupera el numero de paginas a examinar
    ld a, $00               ; Nº de pagina a examinar
    ld [(NGN_RAM_BUFFER + RAM_TEST_MAPPED_CURRENT_PAGE)], a
    @@PAGES_LOOP:

        push bc                     ; Preserva el contador del bucle

        call @@TEST_PAGE            ; Test de esa pagina

        ; Salto de linea
        ld hl, TEXT_NEW_LINE
        call NGN_TEXT_PRINT

        ; Suma 1 al contador de paginas
        ld a, [(NGN_RAM_BUFFER + RAM_TEST_MAPPED_CURRENT_PAGE)]
        inc a
        ld [(NGN_RAM_BUFFER + RAM_TEST_MAPPED_CURRENT_PAGE)], a
        ; Contador del bucle
        pop bc                      ; Recupera el contador del bucle
        dec bc
        ld a, b
        or c
        jr nz, @@PAGES_LOOP         ; Repite si aun quedan paginas

    
    ; Test completado
    call FUNCTION_RAM_PRINT_SLOT_INFO
    ld hl, [(NGN_RAM_BUFFER + RAM_TEST_SLOT_ERRORS)]
    ld b, h
    ld c, l
    call NGN_TEXT_PRINT_INTEGER
    ld hl, TEXT_RAM_TEST_ERRORS
    call NGN_TEXT_PRINT

    ld hl, TEXT_NEW_LINE
    call NGN_TEXT_PRINT  
    ld hl, TEXT_NEW_LINE
    call NGN_TEXT_PRINT
    ld hl, TEXT_SYSTEM_INFO_EXIT
    call NGN_TEXT_PRINT
    
    ; Vuelve al menu
    jp FUNCTION_RAM_GOTO_MENU



    ; ----------------------------------------------------------
    ; Examina la pagina seleccionada
    ; ----------------------------------------------------------
    @@TEST_PAGE:

    ; Imprime el numero de pagina que se examina
    ld hl, TEXT_RAM_TEST_PAGE
    call NGN_TEXT_PRINT
    ld a, [(NGN_RAM_BUFFER + RAM_TEST_MAPPED_CURRENT_PAGE)]
    ld b, 0
    ld c, a
    call NGN_TEXT_PRINT_INTEGER
    ld a, $20
    call $00A2      ; [CHPUT]

    ; Escaneo de la pagina en busca de fallos
    ld hl, $0000                                        ; Reset del contador de errores
    ld [(NGN_RAM_BUFFER + RAM_TEST_PAGE_ERRORS)], hl
    ld hl, RAM_TEST_MAPPER_ADDRESS                      ; Direccion inicial del escaneo
    ld [MEMORY_PAGE_ADDR], hl
    ld b, $80           ; 128 bloques
    @@BLOCK_LOOP:

        exx         ; Selecciona los registros sombreados
        ld e, $FF   ; Reset de error en E'
        exx         ; Selecciona los registros normales

        push bc         ; Preserva el registro del contador BLOCK

        ld b, $80       ; 128 bytes por bloque
        @@BYTES_LOOP:

            push bc         ; Preserva el registro del contador de bytes

            ; Parametros del test
            ld hl, [MEMORY_PAGE_ADDR]                               ; Direccion             HL
            ld de, [(NGN_RAM_BUFFER + RAM_TEST_PAGE_ERRORS)]        ; Errores               DE
            ld a, [(NGN_RAM_BUFFER + RAM_TEST_MAPPED_CURRENT_PAGE)]
            ld c, a                                                 ; Segmento actual       C
            ld a, [MEMORY_SLOT_ID]
            ld b, a                                                 ; SLot ID?              B

            ; FUNCTION_RAM_BYTE_TEST
            ; HL = Direccion
            ; DE = nº de errores encontrados
            ; C = nº de segmento actual
            ; B = ID de slot a analizar
            ; E' = Error encontrado
            ; Modifica AF, BC, DE, HL, AF', E'
            ;call (NGN_RAM_BUFFER + RAM_TEST_BYTE_ROUTINE_ADDR)
            ;call FUNCTION_RAM_BYTE_TEST

            ; Actualiza el registro de errores
            ld [(NGN_RAM_BUFFER + RAM_TEST_PAGE_ERRORS)], de


            ; Siguiente direccion
            inc hl
            ld [MEMORY_PAGE_ADDR], hl

            pop bc          ; Recupera el registro del contador de bytes
            dec b
            jp nz, @@BYTES_LOOP



        ; Imprime el testigo de actividad cada 128 bytes de analisis
        exx         ; Selecciona los registros sombreados
        ld a, e     ; Lee el estado de E
        exx         ; Selecciona los registros normales
        cp $FF
        jp z, @@BYTE_CORRECT

        ld a, $CF                       ; Error en el byte
        jr @@PRINT_BYTE_RESULT

        @@BYTE_CORRECT:
        ld a, $C2                       ; Byte correcto

        @@PRINT_BYTE_RESULT:            ; Imprime el resultado
        call $00A2      ; [CHPUT]

        pop bc          ; Recupera el registro del contador BLOCK
        dec b
        jp nz, @@BLOCK_LOOP


    ; ----------------------------------------------------------
    ; Resumen la pagina seleccionada
    ; ----------------------------------------------------------
    ld a, $20
    call $00A2      ; [CHPUT]

    ld hl, [(NGN_RAM_BUFFER + RAM_TEST_PAGE_ERRORS)]        ; Errores de este segmento
    ld b, h
    ld c, l

    ex de, hl       ; Guarda en DE los errores

    ld hl, [(NGN_RAM_BUFFER + RAM_TEST_SLOT_ERRORS)]        ; Sumalos al contador general de errores
    add hl, de
    ld [(NGN_RAM_BUFFER + RAM_TEST_SLOT_ERRORS)], hl        ; Y guardalos

    call NGN_TEXT_PRINT_INTEGER     ; Imprime los errores de esta pagina
    ld hl, TEXT_RAM_TEST_ERRORS
    call NGN_TEXT_PRINT

    ; Salto de linea
    ld hl, TEXT_NEW_LINE
    call NGN_TEXT_PRINT

    ; Vuelve al terminar
    ret



; ----------------------------------------------------------
; Test de memoria paginada
; ----------------------------------------------------------
FUNCTION_RAM_PAGED_TEST:

    ; Vuelve al menu
    jp FUNCTION_RAM_GOTO_MENU





; ----------------------------------------------------------
; Test del byte seleccionado
; HL = Direccion
; DE = nº de errores encontrados
; C = nº de segmento actual
; B = ID de slot a analizar
; E' = Error encontrado
; Modifica AF, BC, DE, HL, AF', E'
; ----------------------------------------------------------
FUNCTION_RAM_BYTE_TEST:

             ; Vuelve de la subrutina
            ret





;***********************************************************
; Fin del archivo
;***********************************************************
RAM_TEST_EOF: