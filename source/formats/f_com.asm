;***********************************************************
;
;   MSX DIAGNOSTICS
;   Version 1.1.0
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
; Definicion de variables en los ultimos 4KB [$E380]
; Ultima direccion valida $F380 - $1000
; ----------------------------------------------------------

; Almacena las variables los ultimos 4KB
.ORG $E380
.INCLUDE "ngn/ngn_vars.asm"         ; 2284 bytes
.INCLUDE "prog/vars.asm"            ; 96 bytes


; ----------------------------------------------------------
; Directivas del formato
; ----------------------------------------------------------

.ORG $0100				; Selecciona el punto inicial por defecto en MSX-DOS [$0100]
.MSXDOS					; Se creara el binario en formato .COM para MSX-DOS


;***********************************************************
; Fin del archivo
;***********************************************************
F_COM_EOF: