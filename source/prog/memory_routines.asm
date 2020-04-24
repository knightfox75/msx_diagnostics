;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.6
;	ASM Z80 MSX
;	Rutinas del VDP
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
;  Detecta el layout de slots y RAM instalada
; ----------------------------------------------------------

FUNCTION_MEMORY_GET_CONFIG:

	call FUNCTION_MEMORY_GET_SLOT_LAYOUT		; Configuracion de SLOTS
	call FUNCTION_MEMORY_GET_MEMORY_LAYOUT		; Configuracion de memoria
	ret




; ----------------------------------------------------------
;  Detecta el layout de slots
; ----------------------------------------------------------

FUNCTION_MEMORY_GET_SLOT_LAYOUT:

	; B = Contador del bucle
	; C = Contador del numero de SLOT

	; Recorre los slots y marca si estan expandidos
	ld bc, $0400							; B = 4 slots  /  C = Empieza en el slot 0
	@@SLOT_CHECK_LOOP:

		ld d, 0								; Verificacion de slot expandido
		ld e, c								; Sumale el nº de slot	(DE)
		ld hl, $FCC1						; A la direccion de informacion
		add hl, de							; de slots expandidos

		ld a, [hl]							; Lectura del estado del slot

		ld hl, SLOT_EXPANDED				; Variable para almacenar el resultado
		add hl, de							; Sumale el nº de slot (continua guardado en DE)		

		bit 7, a							; Esta expandido?
		jr z, @@SLOT_CHECK_NOT_EXPANDED		; Si no esta expandido, saltate esta parte

		; Marca que es un slot expandido
		ld [hl], $0B						; Guarda que es expandido (11)
		jr @@SLOT_CHECK_LOOP_END			; Salta al final del bucle

		; Slot no expandido
		@@SLOT_CHECK_NOT_EXPANDED:
		ld [hl], $00						; Guarda que NO es expandido (0)

		@@SLOT_CHECK_LOOP_END:
		inc c								; Siguiente slot
		djnz @@SLOT_CHECK_LOOP				; Fin del bucle principal (SLOTS)

	; Final de la funcion
    ret



; ----------------------------------------------------------
;  Detecta el layout de memoria
; ----------------------------------------------------------

FUNCTION_MEMORY_GET_MEMORY_LAYOUT:

	; Pon a 0 el contador de RAM
	ld hl, RAM_DETECTED		; Variable BCD
	ld b, 3					; 3 bytes (6 digitos)
	@@RESET_RAM_COUNTER:
		xor a
		ld [hl], a
		inc hl
		djnz @@RESET_RAM_COUNTER

	; Pon a 0 los indicadores de bancos
	ld hl, RAM_SLOT_0
	ld b, 16			; 4 slots x 4 sub-slots
	@@RESET_RAM_BANKS_COUNTER:
		xor a
		ld [hl], a
		inc hl
		djnz @@RESET_RAM_BANKS_COUNTER

	; Recorre los slots y marca si estan expandidos
	ld bc, $0400							; B = 4 slots  /  C = Empieza en el slot 0
	@@SLOT_CHECK_LOOP:

		; Preserva los contadores del bucle
		push bc

		ld a, c			; Registra el ID de slot
		and $03			; Bitmask del nº de slot (xxxxxx11)
		ld [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)], a

		; El slot esta expandido?
		ld hl, SLOT_EXPANDED		; Lee el flag de expansion (!0 = Expandido)
		ld d, 0						; Del nº de slot
		ld e, c
		add hl, de					; Sumale el offset del nº de slot
		ld a, [hl]
		or a
		jp z, @@SLOT_IS_NOT_EXPANDED

		; Slot expandido
		ld a, [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)]
		set 7, a
		ld [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)], a

		; Bucle de SUB-SLOTS
		ld bc, $0400						; B = 4 slots  /  C = Empieza en el sub-slot 0
		@@SUBSLOT_CHECK_LOOP:

			; Preserva los contadores del bucle
			push bc

			ld a, [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)]	; Lee la informacion de SLOT y FLAG (1xxxxx11)
			and $83		; BITMASK (1xxxxx11)
			sla c		; Bitshift << 2
			sla c		; Para colocar el nº de sub-slot en la posicion correcta (xxxx11xx)
			or c		; Añade la informacion al ID de slot
			ld [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)], a	; Y guarda el ID completo

			call FUNCION_MEMORY_GET_SLOT_RAM	; Busca toda la RAM en ese SUB-SLOT

			pop bc								; Restaura los contadores del bucle
			inc c								; Siguiente slot
			djnz @@SUBSLOT_CHECK_LOOP			; Fin del bucle secundario (SUB-SLOTS)

		jr @@SLOT_CHECK_LOOP_END				; Salta al final del bucle principal


		; El slot no esta expandido
		@@SLOT_IS_NOT_EXPANDED:
		call FUNCION_MEMORY_GET_SLOT_RAM		; Busca toda la RAM en ese SLOT

		@@SLOT_CHECK_LOOP_END:
		pop bc								; Restaura los contadores del bucle
		inc c								; Siguiente slot
		djnz @@SLOT_CHECK_LOOP				; Fin del bucle principal (SLOTS)

	; Fin de la funcion
	ret



; ----------------------------------------------------------
; Funcion para detectar toda la RAM posible
; ----------------------------------------------------------

FUNCION_MEMORY_GET_SLOT_RAM:

	; Paginas 0, 1 y 2 sin mapper
	call FUNCION_MEMORY_GET_RAM_PAGES012_NO_MAPPER
	; Pagina 3 sin mapper
	call FUNCION_MEMORY_GET_RAM_PAGE3_NO_MAPPER

	; Vuelve
	ret



; ----------------------------------------------------------
; Funcion para detectar la RAM en las
; paginas 0, 1 y 2 SIN MAPPER
; ----------------------------------------------------------

FUNCION_MEMORY_GET_RAM_PAGES012_NO_MAPPER:

	ld hl, $0000		; Direccion inicial de la pagina
	ld [(NGN_RAM_BUFFER + MEMORY_PAGE_ADDR)], hl
	ld b, $0C			; Paginas del 0 al 3 en pasos de 4kb (12 X 4)

	@@CHECK_PAGES_LOOP:

		push bc			; Preserva los contadores del bucle

		di				; Deshabilita las interrupciones

		; Paso 1, lee 1 byte
		ld a, [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)]		; ID de slot
		ld hl, [(NGN_RAM_BUFFER + MEMORY_PAGE_ADDR)]	; Direccion de la pagina 
		call $000C		; Lee un byte del slot con la ID en A de la direccion HL (RDSLT)
		ld b, a			; Respaldo del byte leido
		cpl				; Invierte los bits

		; Paso 2, escribelo invertido
		ld e, a			; Byte a escribir
		ld c, a
		ld a, [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)]		; ID de slot
		ld hl, [(NGN_RAM_BUFFER + MEMORY_PAGE_ADDR)]	; Direccion de la pagina
		push bc
		call $0014 		; Escribe un byte (E) en el slot con la ID en A en la direccion HL (WRSLT)

		; Paso 3, vuelvelo a leer y compara si es el mismo que has escrito
		ld a, [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)]		; ID de slot
		ld hl, [(NGN_RAM_BUFFER + MEMORY_PAGE_ADDR)]	; Direccion de la pagina
		call $000C		; Lee un byte del slot con la ID en A de la direccion HL (RDSLT)
		pop bc
		cp c						; Son iguales ?
		jr nz, @@NOT_RAM			; No lo son, es ROM

		; Paso 4, restaua el byte original en su sitio
		ld e, b			; Byte a escribir (restaura el original)
		ld a, [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)]		; ID de slot
		ld hl, [(NGN_RAM_BUFFER + MEMORY_PAGE_ADDR)]	; Direccion de la pagina
		call $0014 		; Escribe un byte (E) en el slot con la ID en A en la direccion HL (WRSLT)

		; Paso 5, Suma 4kb de esta pagina
		call FUNCTION_MEMORY_COUNTER_ADD_4KB

		@@NOT_RAM:

		ei				; Habilita las interrupciones

		pop bc			; Restaura el contador del bucle

		ld hl, [(NGN_RAM_BUFFER + MEMORY_PAGE_ADDR)]
		ld de, $1000		; Siguiente pagina
		add hl, de
		ld [(NGN_RAM_BUFFER + MEMORY_PAGE_ADDR)], hl
		
		djnz @@CHECK_PAGES_LOOP

	; Fin de la funcion
	ret



; ----------------------------------------------------------
; Funcion para detectar la RAM en la pagina 3
; en todos los slots/sub-slots, sin mapper
; ----------------------------------------------------------

FUNCION_MEMORY_GET_RAM_PAGE3_NO_MAPPER:

	; Informa de la direccion inicial de memoria del test
	ld hl, $C000		; Direccion inicial de la pagina
	ld [(NGN_RAM_BUFFER + MEMORY_PAGE_ADDR)], hl

	ld b, 4		; 4 segmentos de 4kb
	@@CHECK_CHUNKS_LOOP:

		; Preserva los registros del contador
		push bc
		push hl

		; Copia de seguridad en BC de la configuracion de slots
		di				; Desconecta las interrupciones
		in a, [$A8]		; Configuracion de slots
		ld b, a			; Y guardalo en B
		ld a, [$FFFF]	; Configuracion de subslots
		cpl				; Complementalo
		ld c, a			; Y guardalo en C
		exx				; Manda el set de registros a la sombra, trabaja con los alternativos

		; Seleccion de la direccion de memoria a analizar
		ld hl, [(NGN_RAM_BUFFER + MEMORY_PAGE_ADDR)]

		; Seleccion de slots
		ld a, [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)]
		rrca
		rrca
		and $C0
		ld b, a			; Configuracion deseada de slot en B

		; Esta expandido?
		ld a, [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)]
		bit 7, a
		jr z, @@NOT_EXPANDED

		; Esta expandido
		sla	a				; Coloca los bits de sub-slot en los bits 6 y 7 (<< 4)
		sla a
		sla a
		sla a
		and $C0				; Bitmask de esos bits
		ld c, a				; Guardalo en C
		in a, [$A8]			; Lee la configuracion de slots actual
		and $3F				; Guarda la configuracion de las paginas 0 a 2
		or b				; Añade la configuracion de la pagina 3 de slots
		out [$A8], a		; Selecciona esa configuracion de slots
		ld a, [$FFFF]		; Lee la configuracion de sub-slots
		cpl					; Complementala
		and $3F				; Guarda la configuracion de las pagina 0 a 2
		or c				; Añade la configuracion de la pagina 3 de sub-slots
		ld [$FFFF], a		; Aplica la configuracion de sub-slots
		jr @@TEST_IF_RAM

		; No esta expandido
		@@NOT_EXPANDED:
		in a, [$A8]			; Lee la configuracion de slots actual
		and $3F				; Guarda la configuracion de las paginas 0 a 2
		or b				; Añade la configuracion de la pagina 3 de slots
		out [$A8], a		; Selecciona esa configuracion de slots

		; Verifica si el primer byte de la pagina es RAM
		@@TEST_IF_RAM:
		ld a, [hl]			; Lee un byte
		ld b, a				; Guardalo el valor leido en B
		cpl					; Saca el complementario (invierte todos los bits)
		ld c, a				; Guarda el complementario en C
		ld [hl], a			; Vuelve a escribirlo
		ld a, [hl]			; Y leelo nuevamente
		cp c				; Comparalo con el valor que acabas de escribir
		jr nz, @@NOT_RAM	; Si no coincide, no es RAM
		ld a, b				; Y restaura el valor original del byte
		ld [hl], a
		ld a, $FF			; Indica que es RAM
		jr @@RESTORE_SLOTS_CONFIG

		@@NOT_RAM:
		ld a, $00			; Indica que no es RAM

		@@RESTORE_SLOTS_CONFIG:
		exx					; Recupera el set de registros de la sombra, trabaja con los normales
		ld e, a				; Guarda si es RAM ($FF) en E
		ld a, b				; Restaura la configuracion de slots
		out [$A8], a
		ld a, c				; Y la configuracion de subslots
		ld [$FFFF], a

		ei					; Habilita las interrupciones
		ld a, $FF			; Era RAM?
		cp e
		jr nz, @@LOOP_ENDS
		call FUNCTION_MEMORY_COUNTER_ADD_4KB		; Si era RAM, marcalo

		; Fin de la funcion
		@@LOOP_ENDS:

		pop hl			; Recupera los registros del contador
		pop bc

		ld de, $1000	; Siguiente segmento de memoria
		add hl, de
		ld [(NGN_RAM_BUFFER + MEMORY_PAGE_ADDR)], hl

		djnz @@CHECK_CHUNKS_LOOP		; Fin del bucle

	; Sal de la funcion
	ret




; ----------------------------------------------------------
; Funcion para sumas 4kb al contador de RAM
; ----------------------------------------------------------

FUNCTION_MEMORY_COUNTER_ADD_4KB:

	; Sumando
	ld hl, NGN_RAM_BUFFER
	ld [hl], $04
	inc hl
	ld [hl], $00
	inc hl
	ld [hl], $00
	; Numero base
	ld de, RAM_DETECTED
	ld hl, NGN_RAM_BUFFER
	; Realiza la suma
	call NGN_BCD_ADD
	; Marca el banco de memoria
	call FUNCTION_MEMORY_MARK_RAM_BANK
	; Vuelve
	ret


; ----------------------------------------------------------
; Funcion para marcar bancos de RAM en los slots
; ----------------------------------------------------------

FUNCTION_MEMORY_MARK_RAM_BANK:

	; Lee la direccion actual
	ld hl, [(NGN_RAM_BUFFER + MEMORY_PAGE_ADDR)]
	; Marca el BIT de la pagina actual en C
	; Calcula el numero de pagina
	ld a, h
	ld b, 6
	@@GET_PAGE_NUMBER:
		srl a		; >> 1
		djnz @@GET_PAGE_NUMBER
	ld b, a				; Guarda el resultado en B (numero de pagina)
	ld c, 1				; Marca de la pagina 0 (bit 0) por defecto en C
	or a
	jr z, @@BITS_SET	; Si es la pagina 0, salta esta parte

	@@SET_BITS:			; Desplaza tantos bits como numero de paginas
		sla c			; Siguiente bit << 1
		djnz @@SET_BITS

	@@BITS_SET:				; C = RESULTADO
	; Busca la variable que guarda el slot actual
	ld hl, RAM_SLOT_0
	; Calcula el offset segun el slot
	ld a, [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)]
	and $03		; bitmask del slot
	ld b, a		; Prepara el desplazamiento
	or a
	jr z, @@NO_SLOT_OFFSET
	ld de, $0004
	@@CALCULATE_SLOT_OFFSET:
		add hl, de
		djnz @@CALCULATE_SLOT_OFFSET
	@@NO_SLOT_OFFSET:
	; Calcula el offset segun el sub-slot
	ld a, [(NGN_RAM_BUFFER + MEMORY_SLOT_ID)]
	srl a		; Desplazamiento del sub-slot
	srl a
	and $03		; Bitmask del subslot
	ld b, a		; Prepara el desplazamiento
	or a
	jr z, @@NO_SUBSLOT_OFFSET
	@@CALCULATE_SUBSLOT_OFFSET:
		inc hl
		djnz @@CALCULATE_SUBSLOT_OFFSET
	@@NO_SUBSLOT_OFFSET:

	ld a, [hl]		; Carga el registro de paginas del slot/sub-slot
	or c			; Añadelas
	and $0F			; Bitmask de los 4 primeros bits
	ld [hl], a		; Actualiza el registro

	; Sal de la funcion
	ret



	

;***********************************************************
; Fin del archivo
;***********************************************************
MEMORY_ROUTINES_EOF: