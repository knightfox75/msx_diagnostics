;***********************************************************
;
;   MSX DIAGNOSTICS
;   Version 1.1.9
;   ASM Z80 MSX
;   Declaracion de variables
;   (cc) 2018-2020 Cesar Rincon "NightFox"
;   https://nightfoxandco.com
;
;***********************************************************




; --------------------------------------------------------------
; Declara las variables	del sistema	[VARIABLE]	[BYTES]
; TOTAL 26 bytes
; --------------------------------------------------------------

; --------------------------------------------------------------
; Variables de control
; --------------------------------------------------------------

FORCE_SET_SCREEN_0:         ds  1       ; Fuerza poner la pantalla en modo 0


; ----------------------------------------------------------
;  Rutinas del VDP
;	
;       0 - TMS9918A/29A
;	    1 - V9938
;	    2 - V9958
;	    3 - Otros
;
; Total: 2 bytes
; ----------------------------------------------------------

VDP_TYPE_ID:                    ds  1       ; Tipo de VDP instalado
VDP_HZ:                         ds  1       ; Frecuencia de refresco del VDP


; ----------------------------------------------------------
; Rutinas de gestion de memoria
; Total: 158 bytes
; ----------------------------------------------------------

RAM_DETECTED:                   ds  3       ; RAM detectada (Formato BCD de 3 bytes [000000])

MEMORY_SLOT_EXPANDED:           ds  4       ; El slot esta expandido? (bool 0 / !0) 1 byte x 4 slots

                                            ;                   -----------------------------------
                                            ;         SUB-SLOT      0        1        2        3
                                            ;                   -----------------------------------
RAM_SLOT_0:                     ds  4       ; RAM en el SLOT 0  0xxx0000 0xxx0000 0xxx0000 0xxx0000
RAM_SLOT_1:                     ds  4       ; RAM en el SLOT 1  0xxx0000 0xxx0000 0xxx0000 0xxx0000
RAM_SLOT_2:                     ds  4       ; RAM en el SLOT 2  0xxx0000 0xxx0000 0xxx0000 0xxx0000
RAM_SLOT_3:                     ds  4       ; RAM en el SLOT 3  0xxx0000 0xxx0000 0xxx0000 0xxx0000
                                            ;                   -----------------------------------
                                            ;           PAGINA  M   3210 M   3210 M   3210 M   3210
                                            ;                   -----------------------------------
RAM_BANK_SIZE:                  ds  128     ; RAM de la pagina en KB
; [                   SLOT....0....1....2....3                   ]      ; 32 bytes offset x slot
; [     SUB0     ][     SUB1     ][     SUB2     ][     SUB3     ]      ; 8 byes offset x sub-slot
; [P0][P1][P2][P3][P0][P1][P2][P3][P0][P1][P2][P3][P0][P1][P2][P3]      ; 2 bytes offset x page
; Total 128 byes
; Se guarda la catidad de memoria RAM en cada pagina.
; En el caso de la memoria mapeada, la cantidad se guarda en el espacio de la pagina 0
; y el numero de paginas de 16kb del mapper en el espacio de la pagina 1

MEMORY_CURRENT_SLOT:            ds  1       ; Numero de slot actual
MEMORY_CURRENT_SUBSLOT:         ds  1       ; Numero actual de subslot
MEMORY_CURRENT_PAGE:            ds  1       ; Numero actual de pagina
MEMORY_CURRENT_LAYOUT:          ds  1       ; Configuracion de RAM actual del slot (RAM_SLOT_N)
MEMORY_PAGE_ADDR:               ds  2       ; Direccion de memoria de la pagina

MEMORY_SLOT_ID:                 ds  1       ; ID de slot en formato (ExxxSSPP)
                                            ; bit 0-1 = Primary slot number
                                            ; bit 2-3 = Sub-slot number (optional)
                                            ; bit 4-6 = Unused
                                            ; bit 7 = 1 if Slot is Expanded

@@asMSX_BUG:

; -----------------------------------------------------------------------
; Teclas
;       STATE	[PRESS]	[HELD]		Key num: 6
;	    BIT	        1       0       SYSTEM_KEYS_NUMBER
; Total: 6 bytes
; -----------------------------------------------------------------------

SYSKEY_UP:			            ds	1	    ; Cursor / Joy1 arriba
SYSKEY_DOWN:			        ds	1	    ; Cursor / Joy1 arriba
SYSKEY_LEFT:			        ds	1	    ; Cursor / Joy1 arriba
SYSKEY_RIGHT:			        ds	1	    ; Cursor / Joy1 arriba
SYSKEY_ACCEPT:			        ds	1	    ; Espacio / Joy1 Boton 1
SYSKEY_CANCEL:			        ds	1	    ; ESC / Joy1 Boton 2



; ----------------------------------------------------------
; Menu principal
; Total: 3 bytes
; ----------------------------------------------------------

MAINMENU_ITEM_SELECTED:         ds  1		; Posicion del cursor
MAINMENU_ITEM_OLD:              ds	1		; Posicion anterior del cursor
MAINMENU_LAST_ITEM:             ds  1       ; Posicion al abandonar el menu



; --------------------------------------------------------------
; Test del teclado
; Tabla de nombres de las teclas
;
;   Keyboard Type: 0000 (0) = Japan;
;                  0001 (1) = International;
;                  0010 (2) = France;
;                  0011 (3) = United Kingdom;
;                  0100 (4) = Germany;
;                  0101 (5) = USSR;
;                  0110 (6) = Spain.
;
; Total: 3 bytes
; --------------------------------------------------------------

KEYBOARD_LAYOUT:                ds  1       ; Tipo de teclado
KEY_NAMES_TABLE:                ds  2       ; Tabla de nombres de las teclas



;***********************************************************
; Fin del archivo
;***********************************************************
VARS_EOF: