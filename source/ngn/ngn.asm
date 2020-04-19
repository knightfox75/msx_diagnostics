;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.3.0
;
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;	Archivo principal de includes
;
;***********************************************************



; Descompresion de datos RLE
.INCLUDE "ngn/ngn_rle.asm"

; Funciones del sistema
.INCLUDE "ngn/ngn_system.asm"

; Funciones matematicas
.INCLUDE "ngn/ngn_math.asm"

; Funciones graficas
.INCLUDE "ngn/ngn_screen.asm"

; Funciones del PSG
.INCLUDE "ngn/ngn_psg.asm"

; Funciones del teclado
.INCLUDE "ngn/ngn_keyboard.asm"

; Creacion de fondos
.INCLUDE "ngn/ngn_background.asm"

; Creacion de sprites
.INCLUDE "ngn/ngn_sprite.asm"

; Funciones de texto
.INCLUDE "ngn/ngn_text.asm"

; Inicializacion de la libreria NGN
.INCLUDE "ngn/ngn_start.asm"

; Fin de los includes de la libreria



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_EOF: