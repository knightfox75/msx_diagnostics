;***********************************************************
;
;   MSX DIAGNOSTICS
;   Version 1.1.5
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
; Definicion de variables en los ultimos 4KB [$E380]
; Ultima direccion valida $F380 - $1000
; ----------------------------------------------------------

; Almacena las variables los ultimos 4KB
.ORG $E380
.INCLUDE "ngn/ngn_vars.asm"         ; 2285 bytes
.INCLUDE "prog/vars.asm"            ; 110 bytes


; ----------------------------------------------------------
; Directivas del formato
; ----------------------------------------------------------

.PAGE 2				; Selecciona la pagina 2 [$8000] (Codigo del programa)
.BASIC				; Se creara el binario
.CAS                ; Se creara la imagen de cinta
.WAV                ; Se creara el archivo de audio

; Indicale al compilador donde empieza el programa
.START PROGRAM_START_ADDRESS



;***********************************************************
; Fin del archivo
;***********************************************************
F_CAS_EOF: