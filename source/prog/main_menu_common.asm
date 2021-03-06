;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.2.0
;	ASM Z80 MSX
;	Menu Principal (Funciones comunes)
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Imprime la cabecera del menu
; ----------------------------------------------------------
FUNCTION_MAIN_MENU_HEADER_PRINT:

	ld hl, TEXT_DASHED_LINE			; Linea
	call NGN_TEXT_PRINT				; Imprimelo
	ld hl, TEXT_MENU_HEADER			; Texto de la cabecera
	call NGN_TEXT_PRINT				; Imprimelo
	ld hl, TEXT_DASHED_LINE			; Linea
	call NGN_TEXT_PRINT				; Imprimelo
    ; Vuelve
    ret



; ----------------------------------------------------------
; Imprime el pie del menu
; ----------------------------------------------------------
FUNCTION_MAIN_MENU_FOOTER_PRINT:

	ld hl, TEXT_MAIN_MENU_FOOTER		; Instrucciones del menu
	call NGN_TEXT_PRINT					; Imprimelo

	ld hl, $0114						; Posicion inicial del cuerpo de texto
	call NGN_TEXT_POSITION
    ld hl, TEXT_DASHED_LINE			    ; Linea
	call NGN_TEXT_PRINT				    ; Imprimelo
	ld hl, TEXT_MAIN_MENU_COPYRIGHT     ; Texto del copyright
	call NGN_TEXT_PRINT				    ; Imprimelo
	ld hl, TEXT_DASHED_LINE			    ; Linea
	call NGN_TEXT_PRINT				    ; Imprimelo

    ; Vuelve
    ret



; ----------------------------------------------------------
; Actualiza la posicion del cursor
; ----------------------------------------------------------
FUNCTION_MAIN_MENU_PRINT_CURSOR:
    ; Borra el cursor de su posicion actual
    ld h, $02							; Posicion X
    ld a, [MAINMENU_ITEM_OLD]			; Lee la posicion del borrado
    add MAINMENU_ITEM_START				; Asignale el offset de la Y
    ld l, a
    call NGN_TEXT_POSITION				; Coloca el cursor
    ld hl, TEXT_MAIN_MENU_ITEM_OFF		; Lee el espacio en blanco
    call NGN_TEXT_PRINT					; Y escribelo
    ; Imprime el cursor en su nueva posicion
    ld h, $02							; Posicion X
    ld a, [MAINMENU_ITEM_SELECTED]		; Lee la posicion Y de escritura
    add MAINMENU_ITEM_START				; Asignale el offset de la Y
    ld l, a
    call NGN_TEXT_POSITION				; Coloca el cursor
    ld hl, TEXT_MAIN_MENU_ITEM_ON		; Lee el caracter del cursor
    call NGN_TEXT_PRINT					; Y escribelo
    ; Guarda la coordenada de borrado
    ld a, [MAINMENU_ITEM_SELECTED]
    ld [MAINMENU_ITEM_OLD], a
    ; Vuelve
    ret



;***********************************************************
; Fin del archivo
;***********************************************************
MAIN_MENU_COMMON_EOF: