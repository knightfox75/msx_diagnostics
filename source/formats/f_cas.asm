;***********************************************************
;
;   MSX DIAGNOSTICS
;   Version 1.0.1.
;	ASM Z80 MSX
;	Directivas de compilacion para BINARIO de 32kb
;	Genera un archivo .CAS y .WAV
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

OUTPUT_FORMAT = 4		; Define el formato de salida

; ----------------------------------------------------------
; Directivas del formato
; ----------------------------------------------------------

.ORG $8000				; Selecciona la pagina 2 [$8000] (Codigo del programa)
.BASIC					; Se creara el binario en formato BASIC de hasta 32kb
.CAS                    ; Genera el archivo .CAS
.WAV                    ; Genera el archivo .WAV

; Indicale al compilador donde empieza el programa
.START PROGRAM_START_ADDRESS

; ----------------------------------------------------------
; Definicion de variables
; ----------------------------------------------------------

; Almacena las variables
.INCLUDE "ngn/ngn_vars.asm"
.INCLUDE "prog/vars.asm"



;***********************************************************
; Fin del archivo
;***********************************************************
F_CAS_EOF: