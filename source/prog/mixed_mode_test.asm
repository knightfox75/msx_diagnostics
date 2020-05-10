;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.9
;	ASM Z80 MSX
;	Test del modo mixto
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Menu del test del modo mixto
; ----------------------------------------------------------

FUNCTION_MIXED_MODE_TEST_MENU:

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Texto del menu
	call FUNCTION_MAIN_MENU_HEADER_PRINT		            ; Cabecera
	ld hl, $0104								            ; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
	ld hl, TEXT_MIXED_MODE_MENU_TITLE                    	; Titulo
	call NGN_TEXT_PRINT							            ; Imprimelo
	ld hl, TEXT_DASHED_LINE						            ; Linea
	call NGN_TEXT_PRINT							            ; Imprimelo
	ld hl, TEXT_MIXED_MODE_MENU_INSTRUCTIONS   				; Instrucciones de uso
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
		jp nz, FUNCTION_MIXED_MODE_TEST_RUN              	; Ejecuta el test

		; Si se pulsa la tecla  "CANCELAR"
		ld a, [SYSKEY_CANCEL]
		and $02								                ; Detecta "KEY DOWN"
		ret nz								                ; Vuelve al menu principal

		; Espera a la interrupcion del VDP (VSYNC)
        halt

		; Repite el bucle
		jr @@LOOP



; ----------------------------------------------------------
; Ejecuta el test del modo mixto
; ----------------------------------------------------------

FUNCTION_MIXED_MODE_TEST_RUN:

	; Fuerza recargar el modo 0 al volver al menu
	ld a, 1
	ld [FORCE_SET_SCREEN_0], a

	; Pon la VDP en MODO SCR2
	ld bc, $0F04			; Color de frente/fondo
	ld de, $0400			; Color de borde/sin uso
	call NGN_SCREEN_SET_MODE_2

	; Habilita el modo mixto (si esta disponible)
	ld bc, $9F03		; B = Data byte, C = VDP Mode Register number
	call $0047			; WRTVDP (Write to VDP Register)
	ld bc, $0004
	call $0047

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Rellena la tabla de colores de la VRAM
	ld a, $F4			; Primer plano 15, segundo plano 4
	ld bc, $1800		; Tamaño de los 3 bancos de color 2048 x 3		
	ld hl, NGN_CLRTBL	; Apunta a la tabla de colores de la VRAM de SCREEN 2
	call $0056			; FILVRM (Fill VRAM)
						; A = Data byte, BC = Length, HL = VRAM address

	; Rellena la tabla de nombres de la VRAM
	ld bc, $0331			; 3 Segmentos
	ld hl, NGN_NAMTBL		; Apunta a la tabla de nombres de la VRAM en SCREEN 2
	@@FILL_NAM_TBL:
		push bc				; Preserva los contadores
		push hl
		ld a, c				; Caracter a imprimir
		ld bc, $0100		; Tamaño de los 3 bancos de nombres (mapa) 256 x 3		
		call $0056			; FILVRM (Fill VRAM)
							; A = Data byte, BC = Length, HL = VRAM address
		pop hl				; Recupera los contadores
		pop bc
		inc c
		ld de, $0100
		add hl, de			; Siguiente segmento
		djnz @@FILL_NAM_TBL

	; Copia el charset completo desde la BIOS a la VRAM
	ld bc, $0800		; 8 bytes x 256 caracteres
	ld de, NGN_CHRTBL	; Destino de los datos, tabla de caracteres de la VRAM
	ld hl, [$0004]		; Origen de los datos, tabla de caracteres de screen 0
	call $005C			; LDIRVM (Load, Increment and Repeat to VRAM from Memory)
						; BC = Length, DE = VRAM address, HL = RAM address

	; Copia el charset completo desde la BIOS a la VRAM
	ld b, 3								; Repite 3 veces (copia lo mismo a los 3 bancos)
	ld de, NGN_NAMTBL					; Destino de los datos, tabla de nombres de la VRAM
	ld hl, TEXT_MIXED_MODE_MESSAGE		; Origen de los datos, texto

	@@COPY:

		push bc				; Preserva los registros
		push de
		push hl

		ld bc, $0020		; 32 caracteres
		call $005C			; LDIRVM (Load, Increment and Repeat to VRAM from Memory)
							; BC = Length, DE = VRAM address, HL = RAM address

		pop hl				; Recupera los registros
		pop de
		pop bc

		inc d				; Siguiente banco (+256)

		djnz @@COPY
	

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044



; ----------------------------------------------------------
; Bucle de ejecucion
; ----------------------------------------------------------

	; Bucle de ejecucion
	@@LOOP:

		; Lectura del HID
		call FUNCTION_SYSTEM_HID_READ

		; Si se pulsa la tecla  "CANCELAR"
		ld a, [SYSKEY_CANCEL]
		and $02								; Detecta "KEY DOWN"
		ret nz								; Vuelve al menu principal

		; Espera a la interrupcion del VDP (VSYNC)
		halt

		; Repite el bucle
		jp @@LOOP





;***********************************************************
; Fin del archivo
;***********************************************************
MIXED_MODE_TEST_EOF: