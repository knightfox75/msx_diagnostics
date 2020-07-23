;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.2.0
;	ASM Z80 MSX
;	Informes de la memoria instalada
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; FUNCTION_MEMORY_REPORTS_PRINT_RAM_REPORT
; Muestra el resumen de la configuracion de la memoria
; RAM instalada
; ----------------------------------------------------------
FUNCTION_MEMORY_REPORTS_PRINT_RAM_REPORT:

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
    ld a, $FF                                   ; Muestra TODA la informacion
    ld [(NGN_RAM_BUFFER + RAM_TEST_SHOW_ALL_INFO)], a
    ld hl, $0906                                ; Posicion inicial
    call FUNCTION_MEMORY_REPORTS_PRINT_RAM_LAYOUT
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
; FUNCTION_MEMORY_REPORTS_PRINT_RAM_LAYOUT
; Muestra y registra la informacion de la memoria RAM
; HL = Posicion inicial
; (NGN_RAM_BUFFER + RAM_TEST_SHOW_ALL_INFO)
; $FF = Todos los slots     $00 = Solo los disponibles
; ----------------------------------------------------------
FUNCTION_MEMORY_REPORTS_PRINT_RAM_LAYOUT:

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




;***********************************************************
; Fin del archivo
;***********************************************************
MEMORY_REPORTS_EOF: