;***********************************************************
; MSX DIAGNOSTICS
; Version 0.1.0-a
; ASM Z80 MSX
; Archivo principal
; (c) 2018 Cesar Rincon "NightFox"
; http://www.nightfoxandco.com
;***********************************************************



; ----------------------------------------------------------
; Funcion de pantalla de bienvenida N'gine logo
; ----------------------------------------------------------

FUNCTION_WELCOME:

	; Pon la VDP en MODO SCR2
	ld bc, $0F01			; Color de frente/fondo
	ld de, $0100			; Color de bore/sin uso
	call NGN_SCREEN_SET_MODE_2

	; Carga el fondo del Logo en la pantalla
	ld hl, BG_NGNLOGO_IMAGE			; Direccion de la imagen
	call NGN_BACKGROUND_CREATE_RLE		; Crea el fondo y mandalo a la VRAM

	; Prepara el temporizador de salida
	ld b, 120		; Salida en 120 frames


	; Bucle de ejecucion
	@@LOOP:

		; Guarda los registros
		push bc

		; Lee el teclado
		call NGN_KEYBOARD_READ

		; Recupera los registro
		pop bc

		; Si se pulsa cualquier tecla...
		ld a, [NGN_KEY_ANY]		; Cualquier tecla
		and $02		; Detecta "KEY DOWN"
		jr nz, @@EXIT			; Sal del bucle principal si se pulsa

		; Contador de tiempo
		dec b
		jr z, @@EXIT		; Si el tiempo llega a 0, sal del bucle

		; Espera a la interrupcion del VDP (VSYNC)
		halt	; Espera a la interrupcion del VDP

		; Repite el bucle
		jr @@LOOP


	; Sal de la funcion
	@@EXIT:
		call $0041	; Deshabilita la pantalla
		ret		; Sal de la funcion



;***********************************************************
; Fin del archivo
;***********************************************************
WELCOME_EOF: