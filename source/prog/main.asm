;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.0-wip02
;	ASM Z80 MSX
;	Archivo principal
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Funcion principal
; ----------------------------------------------------------

FUNCTION_MAIN:

	; Inicializaciones
	call NGN_START					; Inicia la libreria NGN
	call FUNCTION_SYSTEM_START		; Inicia el programa

	; Llama a la funcion de pantalla de Bienvenida
	call FUNCTION_WELCOME

	; Llama a la funcion del menu principal (Pagina 1)
	call FUNCTION_MAIN_MENU_P1



; Fin del programa
FUNCTION_EXIT:

	; Ejecuta la rutina [DISSCR] para deshabilitar la pantalla
	call $0041

	; Borra la pantalla
	call NGN_TEXT_CLS

	; Texto de reinicio
	ld hl, $0F0B				; Posicion del cursor de texto [XXYY]
	call NGN_TEXT_POSITION		; Posiciona el cursor
	ld hl, TEXT_RESTART			; Apunta al texto a mostrar
	call NGN_TEXT_PRINT			; E imprimelo en pantalla

	; Ejecuta la rutina [ENASCR] para habilitar la pantalla
	call $0044

	; Reinicia el MSX en caso de que pase algo fuera de lo comun y se salga del programa (o se haya pulsado la tecla de salir)
	call $0000		; (CHKRAM)



;***********************************************************
; Fin del archivo
;***********************************************************
MAIN_EOF: