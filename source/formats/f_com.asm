;***********************************************************
;
;   MSX DIAGNOSTICS
;   Version 1.1.0-wip02
;	ASM Z80 MSX
;	Directivas de compilacion para .COM de MSX-DOS
;
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;
;	Compilar con asMSX 0.19 o superior
;	https://github.com/Fubukimaru/asMSX
;
;***********************************************************



;***********************************************************
; Directivas para el compilador
;***********************************************************

OUTPUT_FORMAT = 3							; Define el formato de salida

; ----------------------------------------------------------
; Directivas del formato
; ----------------------------------------------------------

.ORG $0100				; Selecciona el punto inicial por defecto en MSX-DOS [$0100]
.MSXDOS					; Se creara el binario en formato .COM para MSX-DOS


; ----------------------------------------------------------
; Definicion de variables
; ----------------------------------------------------------

; Almacena las variables
.INCLUDE "ngn/ngn_vars.asm"
.INCLUDE "prog/vars.asm"


;***********************************************************
; Fin del archivo
;***********************************************************
F_COM_EOF: