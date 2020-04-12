;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.2.1-WIP01
;
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;	Definicion de constantes
;
;***********************************************************



; ----------------------------------------------------------
; Constantes del Sistema
; ----------------------------------------------------------

; ----------------------------------------------------------
; Definiciones para la VRAM
; ----------------------------------------------------------
; Registros
NGN_VDPR0		    .EQU	$F3DF	; Valores del registro 0 del VDP
NGN_VDPR1		    .EQU	$F3E0	; Valores del registro 0 del VDP
; Fondos
NGN_CHRTBL		    .EQU	$0000	; Tabla de caracteres de los fondos (pattern)
NGN_NAMTBL		    .EQU	$1800	; Tabla de nombres de los fondos (mapa)
NGN_CLRTBL		    .EQU	$2000	; Tabla del color de los caracteres (paleta)
; Sprites
NGN_SPRATR		    .EQU	$1B00	; Tabla de los atributos de los sprites
NGN_SPRTBL		    .EQU	$3800	; Tabla de caracteres de los Sprites (pattern)
; Color
NGN_COLOR_ADDR		.EQU	$F3E9	; Direccion del Color



; ----------------------------------------------------------
; Definiciones de los dispositivos HID
; ----------------------------------------------------------

NGN_TOTAL_KEYS		.EQU	89	; Numero total de teclas
NGN_TOTAL_JOYKEYS	.EQU	12	; Numero total de teclas del joystick

NGN_KEY_STATE_HELD	.EQU	1	; Bit 0 a 1 [HELD]
NGN_KEY_STATE_PRESS	.EQU	2	; Bit 1 a 1 [PRESS]
NGN_KEY_STATE_UP	.EQU	4	; Bit 2 a 1 [UP]
NGN_KEY_STATE_LAST	.EQU	8	; Bit 3 a 1 [LAST] (Estado en el frame anterior)



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_CONSTS_EOF: