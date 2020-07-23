;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.2.0
;	ASM Z80 MSX
;	Rutinas de la gestion de memoria
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

	; Vuelve
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

		ld hl, MEMORY_SLOT_EXPANDED			; Variable para almacenar el resultado
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
		ld [hl], $00
		inc hl
		djnz @@RESET_RAM_COUNTER

	; Pon a 0 los indicadores de bancos
	ld hl, RAM_SLOT_0
	ld b, 16			; 4 slots x 4 sub-slots
	@@RESET_RAM_BANKS_COUNTER:
		ld [hl], $00
		inc hl
		djnz @@RESET_RAM_BANKS_COUNTER

	; Pon a 0 los contadores de KB por banco
	ld hl, RAM_BANK_SIZE
	ld b, 64			; 4 slots x 4 sub-slots x 4 paginas x 2 bytes por pagina
	@@RESET_RAM_BANK_SIZE:
		ld [hl], $00
		inc hl
		ld [hl], $00
		inc hl
		djnz @@RESET_RAM_BANK_SIZE
	

	; Recorre los slots y marca si estan expandidos
	ld bc, $0400							; B = 4 slots  /  C = Empieza en el slot 0
	@@SLOT_CHECK_LOOP:

		; Preserva los contadores del bucle
		push bc

		ld a, c			; Registra el ID de slot
		and $03			; Bitmask del nº de slot (xxxxxx11)
		ld [MEMORY_SLOT_ID], a

		; El slot esta expandido?
		ld hl, MEMORY_SLOT_EXPANDED		; Lee el flag de expansion (!0 = Expandido)
		ld d, 0						; Del nº de slot
		ld e, c
		add hl, de					; Sumale el offset del nº de slot
		ld a, [hl]
		or a
		jp z, @@SLOT_IS_NOT_EXPANDED

		; Slot expandido
		ld a, [MEMORY_SLOT_ID]
		set 7, a
		ld [MEMORY_SLOT_ID], a

		; Bucle de SUB-SLOTS
		ld bc, $0400						; B = 4 slots  /  C = Empieza en el sub-slot 0
		@@SUBSLOT_CHECK_LOOP:

			; Preserva los contadores del bucle
			push bc

			ld a, [MEMORY_SLOT_ID]	; Lee la informacion de SLOT y FLAG (1xxxxx11)
			and $83		; BITMASK (1xxxxx11)
			sla c		; Bitshift << 2
			sla c		; Para colocar el nº de sub-slot en la posicion correcta (xxxx11xx)
			or c		; Añade la informacion al ID de slot
			ld [MEMORY_SLOT_ID], a	; Y guarda el ID completo

			call FUNCION_MEMORY_GET_SLOT_RAM	; Busca toda la RAM en ese SUB-SLOT

			pop bc								; Restaura los contadores del bucle
			inc c								; Siguiente slot
			djnz @@SUBSLOT_CHECK_LOOP			; Fin del bucle secundario (SUB-SLOTS)

		jr @@SLOT_CHECK_LOOP_END				; Salta al final del bucle principal


		; El slot no esta expandido
		@@SLOT_IS_NOT_EXPANDED:
		call FUNCION_MEMORY_GET_SLOT_RAM		; Busca toda la RAM en ese SLOT

		@@SLOT_CHECK_LOOP_END:
		pop bc									; Restaura los contadores del bucle
		inc c									; Siguiente slot
		djnz @@SLOT_CHECK_LOOP					; Fin del bucle principal (SLOTS)

	; Fin de la funcion
	ret



; ----------------------------------------------------------
; Funcion para detectar toda la RAM posible
; ----------------------------------------------------------

FUNCION_MEMORY_GET_SLOT_RAM:

	; Reinicia el contador de RAM del slot actual
	ld hl, (NGN_RAM_BUFFER + MEMORY_IN_CURRENT_SELECTION)		; Variable
	ld b, 3			; 3 bytes
	xor a			; a cero
	@@RESET_COUNTER:
		ld [hl], a
		inc hl
		djnz @@RESET_COUNTER

	; Paginas 0, 1 y 2 sin mapper
	call FUNCION_MEMORY_GET_RAM_PAGES012_NO_MAPPER
	; Pagina 3 sin mapper
	call FUNCION_MEMORY_GET_RAM_PAGE3_NO_MAPPER

	; Si este banco tiene 64kb, posiblemente sea un mapper, procede a verificarlo
	ld a, [(NGN_RAM_BUFFER + MEMORY_IN_CURRENT_SELECTION)]
	sub a, $40		; Resta 64
	ret c			; Si no ha llegado a 64kb, no es un mapper, sal

	; Analiza si hay un mapper en este banco
	call FUNCION_MEMORY_GET_RAM_IN_MAPPER

	; Vuelve
	ret



; ----------------------------------------------------------
; Funcion para detectar la RAM en las
; paginas 0, 1 y 2 SIN MAPPER
; ----------------------------------------------------------

FUNCION_MEMORY_GET_RAM_PAGES012_NO_MAPPER:

	ld hl, $0000		; Direccion inicial de la pagina
	ld [MEMORY_PAGE_ADDR], hl
	ld b, $0C			; Paginas del 0 al 3 en pasos de 4kb (12 X 4)

	@@CHECK_PAGES_LOOP:

		push bc			; Preserva los contadores del bucle

		di				; Deshabilita las interrupciones

		; Paso 1, lee 1 byte
		ld a, [MEMORY_SLOT_ID]		; ID de slot
		ld hl, [MEMORY_PAGE_ADDR]	; Direccion de la pagina 
		call $000C		; Lee un byte del slot con la ID en A de la direccion HL (RDSLT)
		ld b, a			; Respaldo del byte leido
		cpl				; Invierte los bits

		; Paso 2, escribelo invertido
		ld e, a			; Byte a escribir
		ld c, a
		ld a, [MEMORY_SLOT_ID]		; ID de slot
		ld hl, [MEMORY_PAGE_ADDR]	; Direccion de la pagina
		push bc
		call $0014 		; Escribe un byte (E) en el slot con la ID en A en la direccion HL (WRSLT)

		; Paso 3, vuelvelo a leer y compara si es el mismo que has escrito
		ld a, [MEMORY_SLOT_ID]		; ID de slot
		ld hl, [MEMORY_PAGE_ADDR]	; Direccion de la pagina
		call $000C		; Lee un byte del slot con la ID en A de la direccion HL (RDSLT)
		pop bc
		cp c						; Son iguales ?
		jr nz, @@NOT_RAM			; No lo son, es ROM

		; Paso 4, restaua el byte original en su sitio
		ld e, b			; Byte a escribir (restaura el original)
		ld a, [MEMORY_SLOT_ID]		; ID de slot
		ld hl, [MEMORY_PAGE_ADDR]	; Direccion de la pagina
		call $0014 		; Escribe un byte (E) en el slot con la ID en A en la direccion HL (WRSLT)

		; Paso 5, Suma 4kb de esta pagina
		call FUNCTION_MEMORY_COUNTER_ADD_4KB

		@@NOT_RAM:

		ei				; Habilita las interrupciones

		pop bc			; Restaura el contador del bucle

		ld hl, [MEMORY_PAGE_ADDR]
		ld de, $1000		; Siguiente segmento de 4kb
		add hl, de
		ld [MEMORY_PAGE_ADDR], hl
		
		djnz @@CHECK_PAGES_LOOP

	; Fin de la funcion
	ret



; ----------------------------------------------------------
; Funcion para detectar la RAM
; en todos los slots/sub-slots, sin mapper
; ----------------------------------------------------------

FUNCION_MEMORY_GET_RAM_PAGE3_NO_MAPPER:

	; Informa de la direccion inicial de memoria del test
	ld hl, $C000
	ld [MEMORY_PAGE_ADDR], hl

	ld b, 4		; 4 segmentos de 4kb
	@@CHECK_CHUNKS_LOOP:

		; Preserva los registros del contador
		push bc

		; Copia de seguridad en BC de la configuracion de slots
		di				; Desconecta las interrupciones
		in a, [$A8]		; Configuracion de slots
		ld b, a			; Y guardalo en B
		ld a, [$FFFF]	; Configuracion de subslots
		cpl				; Complementalo
		ld c, a			; Y guardalo en C
		exx				; Manda el set de registros a la sombra, trabaja con los alternativos

		; Calcula el SLOT [E]
		ld c, $03										; Mascara de slot en pagina... [xxxxxx11] en [C]
		ld a, [MEMORY_SLOT_ID]		; Lee el ID de configuracion de slots
		and c											; Aplica la mascara
		ld e, a											; Guarda el slot en E
		; Calcula el SUB-SLOT [D]
		ld a, [MEMORY_SLOT_ID]		; Lee el ID de configuracion de slots
		srl a											; >> 2
		srl a											; Pon los BITS 2 y 3 en 0 y 1
		and c											; Aplica la mascara
		ld d, a											; Guarda el sub-slot en D

		; Seleccion de la direccion de memoria a analizar
		ld hl, [MEMORY_PAGE_ADDR]

		; Calcula el numero de pagina segun la direccion de memoria
		call FUNCION_MEMORY_GET_PAGE_NUMBER
		ld b, a							; Numero de pagina en B
		
		; Has de desplazar el numero de bits a otra ubicacion que no sea la pagina 0?
		or a
		jr z, @@SLOT_ID_IS_READY		; Es la pagina 0, no es necesario
		@@PLACE_SLOT_ID:
			sla c						; << 2		Mascara
			sla c
			sla d						; << 2		Sub-slot
			sla d
			sla e						; << 2		Slot
			sla e
			djnz @@PLACE_SLOT_ID

		; Prepara la mascara inversa para el OR de seleccion
		@@SLOT_ID_IS_READY:
		ld a, c				; Recupera la mascara del slot
		cpl					; Complementa este valor
		ld c, a				; Guardalo en C

		; Esta expandido?
		ld a, [MEMORY_SLOT_ID]
		bit 7, a
		jr z, @@NOT_EXPANDED

		; Esta expandido - Apunta el slot primario a la pagina 3
		rrc a				; Pon los bits 0 y 1
		rrc a				; en la posicion 6 y 7
		and $C0				; 11xxxxxx	Mascara de esos bits
		ld b, a				; Guarda el resultado en B
		in a, [$A8]			; Lee la configuracion de slots actual
		and $3F				; xx111111	Mascara de las paginas 0 a 2
		or b				; Añade la pagina 3
		ld [(NGN_RAM_BUFFER + MEMORY_PAGE3_SLOT)], a
		
		; Guarda la configuracion actual de slots en B
		in a, [$A8]
		ld b, a
		; Selecciona la configuracion de subslots
		ld a, [(NGN_RAM_BUFFER + MEMORY_PAGE3_SLOT)]
		call FUNCTION_MEMORY_CHECK_IF_RAM_EXPANDED			; Verifica si es RAM
		jr @@END_OF_RAM_CHECK


		; No esta expandido
		@@NOT_EXPANDED:
		in a, [$A8]			; Lee la configuracion de slots actual
		and c				; Guarda la configuracion de las paginas no activas
		or e				; Añade la configuracion de la pagina activa
		call FUNCTION_MEMORY_CHECK_IF_RAM_NO_EXPANDED		; Verifica si es RAM


		@@END_OF_RAM_CHECK:
		ei					; Habilita las interrupciones
		ld a, $FF			; Era RAM?
		cp e
		jr nz, @@LOOP_ENDS
		call FUNCTION_MEMORY_COUNTER_ADD_4KB		; Si era RAM, marcalo

		; Fin de la funcion
		@@LOOP_ENDS:

		pop bc			; Recupera los registros del contador

		ld hl, [MEMORY_PAGE_ADDR]
		ld de, $1000	; Siguiente segmento de 4kb
		add hl, de
		ld [MEMORY_PAGE_ADDR], hl

		;djnz @@CHECK_CHUNKS_LOOP		; Fin del bucle
		dec b
		jp nz, @@CHECK_CHUNKS_LOOP

	; Sal de la funcion
	ret



; ----------------------------------------------------------
; Funcion verificar si el segmento es RAM (NO EXPANDIDO)
; A = Configguracion de SLOTS
; HL = Direccion a analizar
; Devuelve E si es RAM ($FF)
; ----------------------------------------------------------

FUNCTION_MEMORY_CHECK_IF_RAM_NO_EXPANDED:

		out [$A8], a		; Selecciona esa configuracion de slots

		; Verifica si el primer byte de la pagina es RAM
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
		ex af, af'			; Mandalo a la copia sombreada
		jr @@RESTORE_SLOTS_CONFIG

		@@NOT_RAM:
		ld a, $00			; Indica que no es RAM
		ex af, af'			; Mandalo a la copia sombreada

		@@RESTORE_SLOTS_CONFIG:
		; Restauracion de la configuracion original
		exx					; Recupera el set de registros de la sombra, trabaja con los normales
		ex af, af'			; Recupera la copia sombreada de A
		ld e, a				; Guarda si es RAM ($FF) en E
		ld a, b				; Recupera la configuracion de slots
		out [$A8], a		; Restaura el slot original

		; Vuelve
		ret



; ----------------------------------------------------------
; Funcion verificar si el segmento es RAM (EXPANDIDO)
; A = Configuracion de SLOTS (AABBCCDD)
; HL = Direccion a analizar
; Devuelve E si es RAM ($FF)
; ----------------------------------------------------------

FUNCTION_MEMORY_CHECK_IF_RAM_EXPANDED:

		out [$A8], a		; Selecciona el slot primario en la pagina 3
		ld a, [$FFFF]		; Lee la configuracion de sub-slots
		cpl					; Complementala
		and c				; Guarda la configuracion de las pagina no seleccionadas
		or d				; Añade la configuracion de la pagina seleccionada
		ld [$FFFF], a		; Aplica la configuracion de sub-slots
		in a, [$A8]			; Lee la configuracion de slots para acceder a la pagina 3
		ld d, a				; Guardala en D
		; Restaura el slot primario
		ld a, b				; Lee la configuracion de slots original
		and c				; Guarda la configuracion de las paginas no activas
		or e				; Añade la configuracion de la pagina activa
		out [$A8], a		; Selecciona esa configuracion de slots

		; Verifica si el primer byte de la pagina es RAM
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
		ex af, af'			; Mandalo a la copia sombreada
		jr @@RESTORE_SLOTS_CONFIG

		@@NOT_RAM:
		ld a, $00			; Indica que no es RAM
		ex af, af'			; Mandalo a la copia sombreada

		@@RESTORE_SLOTS_CONFIG:
		; Apunta el slot primario a la pagina 3
		ld a, d				; Recupera la configuracion del slot primario
		out [$A0], a		; para acceder a la pagina 3
		exx					; Recupera el set de registros de la sombra, trabaja con los normales
		ex af, af'			; Recupera la copia sombreada de A
		ld e, a				; Guarda si es RAM ($FF) en E
		ld a, c				; Recupera la configuracion de subslots
		ld [$FFFF], a		; Restaurala
		ld a, b				; Recupera la configuracion de slots
		out [$A8], a		; Restaurala

		; Vuelve
		ret



; ----------------------------------------------------------
; Funcion para sumas 4kb al contador de RAM
; ----------------------------------------------------------

FUNCTION_MEMORY_COUNTER_ADD_4KB:

	; Define el numero de KB a añadir
	ld hl, NGN_RAM_BUFFER
	ld [hl], $04			; D
	inc hl
	ld [hl], $00			; C
	inc hl
	ld [hl], $00			; B

	; Define el origen y el destino para el contador general
	ld de, RAM_DETECTED
	ld hl, NGN_RAM_BUFFER
	; Realiza la suma
	call NGN_BCD_ADD

	; Define el origen y el destino para el contador local
	ld de, (NGN_RAM_BUFFER + MEMORY_IN_CURRENT_SELECTION)
	ld hl, NGN_RAM_BUFFER
	; Realiza la suma
	call NGN_BCD_ADD

	; Suma de la memoria en esta pagina
	ld de, $0004
	call FUNCTION_MEMORY_PAGE_RAM_SIZE

	; Marca el banco de memoria
	call FUNCTION_MEMORY_MARK_RAM_BANK

	; Vuelve
	ret



; ----------------------------------------------------------
; Funcion para marcar bancos de RAM en los slots
; ----------------------------------------------------------

FUNCTION_MEMORY_MARK_RAM_BANK:

	; Lee la direccion actual
	ld hl, [MEMORY_PAGE_ADDR]
	; Calcula el numero de pagina en HL
	call FUNCION_MEMORY_GET_PAGE_NUMBER

	; Marca el BIT de la pagina actual en C
	ld b, a				; Guarda el resultado en B (numero de pagina)
	ld c, 1				; Marca de la pagina 0 (bit 0) por defecto en C
	or a
	jr z, @@BITS_SET	; Si es la pagina 0, salta esta parte

	@@SET_BITS:			; Desplaza tantos bits como numero de paginas
		sla c			; Siguiente bit << 1
		djnz @@SET_BITS

	@@BITS_SET:				; C = RESULTADO

	push bc			; Preserva BC
	call FUNCION_MEMORY_GET_CURRENT_SLOT_VARIABLE		; Carga en HL la variable con la informacion del slot actual
	pop bc			; Restaura BC
	ld a, [hl]		; Carga el registro de paginas del slot/sub-slot
	or c			; Añadelas
	and $0F			; Bitmask de los 4 primeros bits
	ld [hl], a		; Actualiza el registro
	
	; Si este banco tiene 64kb, posiblemente sea un mapper, indica que esta lleno (BIT 6) si es necesario
	ld a, [(NGN_RAM_BUFFER + MEMORY_IN_CURRENT_SELECTION)]
	sub a, $40		; Resta 64
	ret c 			; Si no ha llegado a 64kb, no lo marques como lleno

	; Hay el banco esta lleno, indicalo en el BIT 6
	set 6, [hl]

	; Sal de la funcion
	ret



; ----------------------------------------------------------
; Funcion para guardar la RAM de cada pagina
; DE = Total de KB a añadir
; Modifica AF, BC, DE, HL
; ----------------------------------------------------------

FUNCTION_MEMORY_PAGE_RAM_SIZE:

	; Preserva el registro con los KB
	push de

	; Lee la direccion actual
	ld hl, [MEMORY_PAGE_ADDR]
	; Calcula el numero de pagina en HL
	call FUNCION_MEMORY_GET_PAGE_NUMBER

	; Ahora obten la variable de destino segun el slot, sub-slot y nº de pagina
	call FUNCION_MEMORY_GET_RAM_BANK_SIZE_VARIABLE

	pop de			; Recupera los KB a añadir

	push hl			; Preserva la direccion
	ld b, h			; Copiala a BC
	ld c, l

	ld a, [bc]		; Lee los 2 bytes de datos en la direccion y guardalos en HL
	ld h, a
	inc bc
	ld a, [bc]
	ld l, a

	add hl, de		; Sumalo

	ld b, h			; Guarda el resultado en BC
	ld c, l

	pop hl			; Recupera la direccion

	ld [hl], b		; Guardalo en la variable de nuevo
	inc hl
	ld [hl], c

	; Sal de la funcion
	ret



; ----------------------------------------------------------
; Funcion para detectar la RAM un mapper usando una
; de las paginas
; ----------------------------------------------------------

FUNCION_MEMORY_GET_RAM_IN_MAPPER:

	; Reinicia el contador de paginas
	ld hl, $0000
	ld [(NGN_RAM_BUFFER + MEMORY_MAPPER_TOTAL_PAGES)], hl 

	; Deshabilita las interrupciones
	di

	; Paso 1 - Copia de seguridad de los bytes a analizar de cada segmento
	ld de, (NGN_RAM_BUFFER + MEMORY_MAPPER_PAGES_BACKUP)
	ld b, $FF
	@@DO_BACKUP:
		push bc											; Preserva el registro
		push de
		ld a, b											; Carga el nº de segmento actual
		out [MEMORY_MAPPER_TEST_PORT], a				; Seleccion del segmento del mapper
		ld a, [MEMORY_SLOT_ID]		; ID de slot
		ld hl, MEMORY_MAPPER_TEST_PAGE					; Direccion de la pagina 
		call $000C										; Lee un byte del slot con la ID en A de la direccion HL (RDSLT)
		pop de											; Restaura los registros
		pop bc
		ld [de], a										; Guarda el dato leido
		ld a, b											; Sal si ya has completado completado el ciclo
		or a
		jr z, @@DO_BACKUP_EXIT
		inc de											; Siguiente posicion en el buffer de backup
		dec b											; Siguiente ciclo del bucle
		jr @@DO_BACKUP
	@@DO_BACKUP_EXIT:

	; Paso 2 - Marca el primer byte de todos los segmentos como $FF
	ld bc, $FF00
	@@DO_SETUP:
		push bc											; Preserva el registro
		ld a, c											; Carga el nº de segmento actual
		out [MEMORY_MAPPER_TEST_PORT], a				; Seleccion del segmento del mapper
		ld e, $FF										; Byte a escribir
		ld a, [MEMORY_SLOT_ID]		; ID de slot
		ld hl, MEMORY_MAPPER_TEST_PAGE					; Direccion de la pagina 
		call $0014 										; Escribe un byte (E) en el slot con la ID en A en la direccion HL (WRSLT)
		pop bc
		ld a, b											; Sal si ya has completado completado el ciclo
		or a
		jr z, @@DO_SETUP_EXIT
		inc c											; Siguiente pagina
		dec b											; Siguiente ciclo del bucle
		jr @@DO_SETUP
	@@DO_SETUP_EXIT:

	; Paso 3 - Si es un mapper, leyendo el byte, escribiendo un nuevo valor y buscando una repeticion
	ld bc, $FF00
	@@DO_CHECK:
		push bc											; Preserva el registro
		ld a, c											; Carga el nº de segmento actual
		out [MEMORY_MAPPER_TEST_PORT], a				; Seleccion del segmento del mapper
		ld a, [MEMORY_SLOT_ID]		; ID de slot
		ld hl, MEMORY_MAPPER_TEST_PAGE					; Direccion de la pagina 
		call $000C										; Lee un byte del slot con la ID en A de la direccion HL (RDSLT)
		pop bc											; Recupera el registro
		sub a, c										; Si el valor leido es inferior al actual, fin del mapper (o no es un mapper)
		jr c, @@END_OF_CHECK							; Sal si es inferior
		ld hl, [(NGN_RAM_BUFFER + MEMORY_MAPPER_TOTAL_PAGES)]		; Actualiza el contador de segmentos
		inc hl
		ld [(NGN_RAM_BUFFER + MEMORY_MAPPER_TOTAL_PAGES)], hl
		push bc
		ld e, c											; Byte a escribir (nº de segmento)
		ld a, [MEMORY_SLOT_ID]		; ID de slot
		ld hl, MEMORY_MAPPER_TEST_PAGE					; Direccion de la pagina 
		call $0014 										; Escribe un byte (E) en el slot con la ID en A en la direccion HL (WRSLT)
		pop bc											; Restaura el registro
		ld a, b											; Sal si ya has completado completado el ciclo
		or a
		jr z, @@END_OF_CHECK
		inc c											; Siguiente pagina
		dec b											; Siguiente ciclo del bucle
		jr @@DO_CHECK
	@@END_OF_CHECK:

	; Paso 4 - Restaura la copia de seguridad
	ld de, (NGN_RAM_BUFFER + MEMORY_MAPPER_PAGES_BACKUP)
	ld b, $FF
	@@DO_RESTORE:
		push bc											; Preserva el registro
		push de
		ld a, b											; Carga el nº de segmento actual
		out [MEMORY_MAPPER_TEST_PORT], a				; Seleccion del segmento del mapper
		ld a, [de]										; Lee el byte a restaurar
		ld e, a											; Guardalo en E
		ld a, [MEMORY_SLOT_ID]							; ID de slot
		ld hl, MEMORY_MAPPER_TEST_PAGE					; Direccion de la pagina 
		call $0014 										; Escribe un byte (E) en el slot con la ID en A en la direccion HL (WRSLT)
		pop de											; Restaura los registros
		pop bc
		ld a, b											; Sal si ya has completado completado el ciclo
		or a
		jr z, @@DO_RESTORE_EXIT
		inc de											; Siguiente posicion en el buffer de backup
		dec b											; Siguiente ciclo del bucle
		jr @@DO_RESTORE
	@@DO_RESTORE_EXIT:

	; Habilita las interrupciones
	ei

	; Recuento de RAM
	ld hl, [(NGN_RAM_BUFFER + MEMORY_MAPPER_TOTAL_PAGES)]
	ld de, $0004
	sbc hl, de		; Si no hay 4 segmentos de 16kb, no es un mapper
	ret c			; Vuelve YA si no lo es

	call FUNCION_MEMORY_GET_CURRENT_SLOT_VARIABLE		; Carga en HL la variable con la informacion del slot actual
	set 7, [hl]

	; Borra el contador de RAM de las paginas del slot/subslot seleccionado
	xor a
	ld [MEMORY_CURRENT_PAGE], a
	call FUNCION_MEMORY_GET_RAM_BANK_SIZE_VARIABLE
	ld b, 8		; 4 paginas x 2 bytes
	@@RESET_PAGE_RAM_COUNTER:
		ld [hl], 0
		inc hl
		djnz @@RESET_PAGE_RAM_COUNTER

	; Resta 64kb al contador de memoria
	; Define el numero de KB a añadir
	ld hl, NGN_RAM_BUFFER
	ld [hl], $64		; D
	inc hl
	ld [hl], $00		; C
	inc hl
	ld [hl], $00		; B
	; Define el origen y el destino para el contador general
	ld de, RAM_DETECTED
	ld hl, NGN_RAM_BUFFER
	; Realiza la resta
	call NGN_BCD_SUB


	; Indica que las operacion se realizaran sobre la pagina 1 (nº de paginas del mapper)
	ld a, 1
	ld [MEMORY_CURRENT_PAGE], a
	; Calcula la direccion de la variable y guardala en BC
	call FUNCION_MEMORY_GET_RAM_BANK_SIZE_VARIABLE
	ld de, [(NGN_RAM_BUFFER + MEMORY_MAPPER_TOTAL_PAGES)]
	ld [hl], d
	inc hl
	ld [hl], e


	; Indica que las operacion se realizaran sobre la pagina 0 (nº de kb del mapper)
	xor a
	ld [MEMORY_CURRENT_PAGE], a
	; Calcula la direccion de la variable y guardala en BC
	call FUNCION_MEMORY_GET_RAM_BANK_SIZE_VARIABLE
	ld b, h
	ld c, l

	; Suma 16kb al contador de memoria por cada segmento encontrado
	ld hl, [(NGN_RAM_BUFFER + MEMORY_MAPPER_TOTAL_PAGES)]
	
	@@ADD_MAPPED_MEMORY:

		; Preserva los registros
		push hl
		push bc

		; Define el numero de KB a añadir
		ld hl, NGN_RAM_BUFFER
		ld [hl], $16	; D
		inc hl
		ld [hl], $00	; C
		inc hl
		ld [hl], $00	; B

		; Define el origen y el destino para el contador general
		ld de, RAM_DETECTED
		ld hl, NGN_RAM_BUFFER

		; Realiza la suma global
		call NGN_BCD_ADD

		; Realiza la suma de pagina (solo la 0)
		pop bc			; Recupera la direccion de la variable del contador de pagina
		ld h, b			; Y guardala en HL
		ld l, c
		push bc			; Vuelvela a guardar
		ld de, $0010	; Valor a sumar (16kb)
		call FUNCTION_MEMORY_PAGE_RAM_SIZE

		; Recupera los registros y repite
		pop bc
		pop hl

		; Calcula el siguiente ciclo del bucle
		dec hl
		ld a, h
		or l
		jr nz, @@ADD_MAPPED_MEMORY

	; Fin de la rutina
	ret



; ----------------------------------------------------------
; Funcion para buscar la variable que guarda la 
; informacion del slot seleccionado
; Devuelve la variable en HL
; Modifica AF, BC, DE, HL
; ----------------------------------------------------------

FUNCION_MEMORY_GET_CURRENT_SLOT_VARIABLE:

	; Busca la variable que guarda el slot actual
	ld hl, RAM_SLOT_0
	; Calcula el offset segun el slot
	ld a, [MEMORY_SLOT_ID]
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
	ld a, [MEMORY_SLOT_ID]
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

	; Fin de la rutina
	ret



; ----------------------------------------------------------
; Funcion para buscar la variable que guarda la 
; informacion de la memoria en un banco concreto
; SLOT/SUBSLOT/PAGINA
; Devuelve la variable en HL
; Modifica AF, BC, DE, HL
; ----------------------------------------------------------

FUNCION_MEMORY_GET_RAM_BANK_SIZE_VARIABLE:

	; Identifica el slot
	ld a, [MEMORY_SLOT_ID]
	and $03			; Bitmask para el slot
	ld d, a			; Guardalo en D

	; Identifica el sub-slot
	ld a, [MEMORY_SLOT_ID]
	srl a			; Bitshift >> 2
	srl a
	and $03			; Bitmask para el sub-slot
	ld c, a			; Guardalo en C

	ld e, $00		; Offset a 0

	; Offset por slot
	xor a
	or d
	jr z, @@NO_SLOT_OFFSET
	ld b, d
	ld a, e
	@@SLOT_OFFSET_LOOP:				; Calcula el offset por SLOT
		add a, 32
		djnz @@SLOT_OFFSET_LOOP
		ld e, a						; Actualiza el offset

	; Offset por sub-slot
	@@NO_SLOT_OFFSET:
	xor a
	or c			; El SUB-SLOT es mayor de 0?
	jr z, @@NO_SUBSLOT_OFFSET
	ld b, c			; Numero de sub-slots
	ld a, e			; Carga el offset actual
	@@SUBSLOT_OFFSET_LOOP:			; Calcula el offset por sub-slot
		add a, 8
		djnz @@SUBSLOT_OFFSET_LOOP
		ld e, a						; Actualiza el offset

	; Offset por pagina
	@@NO_SUBSLOT_OFFSET:
	ld a, [MEMORY_CURRENT_PAGE]	; Carga la pagina actual
	or a
	jr z, @@NOT_PAGE_OFFSET
	ld b, a			; Numero de paginas
	ld a, e			; Carga el offset actual
	@@PAGE_OFFSET_LOOP:				; Calcula el offset por pagina
		add a, 2
		djnz @@PAGE_OFFSET_LOOP
		ld e, a						; Actualiza el offset

	; Calcula la direccion de la variable con su offset
	@@NOT_PAGE_OFFSET:
	ld d, $00
	ld hl, RAM_BANK_SIZE
	add hl, de

	; Fin de la funcion, devuelve la direccion en HL
	ret



; ----------------------------------------------------------
; Funcion para calcular el nº de pagina segun una 
; direccion dada
; HL = Direccion [$0000 - $FFFF]
; Devuelve el nº de pagina en A [0 - 3]
; y guardalo en la variable correspondiente
; Modifica AF, B
; ----------------------------------------------------------

FUNCION_MEMORY_GET_PAGE_NUMBER:

	; Calcula el numero de pagina
	ld a, h
	ld b, 6
	@@GET_PAGE_NUMBER:
		srl a		; >> 1
		djnz @@GET_PAGE_NUMBER
	ld [MEMORY_CURRENT_PAGE], a		; Variable para almacenar el numero de pagina

	; Fin de la funcion, devuelve el nº de pagina en A
	ret



;***********************************************************
; Fin del archivo
;***********************************************************
MEMORY_ROUTINES_EOF: