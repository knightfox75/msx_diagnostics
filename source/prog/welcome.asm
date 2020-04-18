;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.1-WIP03
;	ASM Z80 MSX
;	Archivo principal
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Funcion de pantalla de bienvenida N'gine logo
; ----------------------------------------------------------

FUNCTION_WELCOME:

	; Pon la VDP en MODO SCR2
	ld bc, $0F01		; Color de frente/fondo
	ld de, $0500		; Color de borde/sin uso
	call NGN_SCREEN_SET_MODE_2

	; Carga el fondo del Logo en la pantalla
	ld hl, BG_TITLE_IMAGE				; Direccion de la imagen
	call NGN_BACKGROUND_CREATE_RLE		; Crea el fondo y mandalo a la VRAM

	; Prepara el temporizador de salida
	ld b, $FF		; Salida en 255 frames


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
		and $02					; Detecta "KEY DOWN"
		jr nz, @@EXIT			; Sal del bucle principal si se pulsa

		; Contador de tiempo
		dec b
		jr z, @@EXIT			; Si el tiempo llega a 0, sal del bucle

		; Espera a la interrupcion del VDP (VSYNC)
		halt

		; Repite el bucle
		jr @@LOOP


	; Sal de la funcion
	@@EXIT:
		call $0041	; Deshabilita la pantalla
		ret			; Sal de la funcion



;***********************************************************
; Fin del archivo
;***********************************************************
WELCOME_EOF: