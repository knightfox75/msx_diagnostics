;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.0.1-a
;
;	(cc)2018 Cesar Rincon "NightFox"
;	http://www.nightfoxandco.com
;
;	Definicion de variables
;
;***********************************************************



; --------------------------------------------------------------
; Declara las variables	del sistema	[VARIABLE]	[BYTES]
; --------------------------------------------------------------

; -----------------------------------------------------------------------
;	Teclas
;	STATE	[LAST]  [UP]  [PRESS]  [HELD]		Key num: 89
;	BIT	  3      2       1       0		NGN_TOTAL_KEYS
; -----------------------------------------------------------------------
; ROW 0
NGN_KEY_0:			ds	1	; Tecla 0
NGN_KEY_1:			ds	1	; Tecla 1
NGN_KEY_2:			ds	1	; Tecla 2
NGN_KEY_3:			ds	1	; Tecla 3
NGN_KEY_4:			ds	1	; Tecla 4
NGN_KEY_5:			ds	1	; Tecla 5
NGN_KEY_6:			ds	1	; Tecla 6
NGN_KEY_7:			ds	1	; Tecla 7
; ROW 1
NGN_KEY_8:			ds	1	; Tecla 8
NGN_KEY_9:			ds	1	; Tecla 9
NGN_KEY_MINUS:			ds	1	; Tecla -
NGN_KEY_EQUAL:			ds	1	; Tecla =
NGN_KEY_BACKSLASH:		ds	1	; Tecla \
NGN_KEY_LEFT_BRACKET:		ds	1	; Tecla [
NGN_KEY_RIGHT_BRACKET:		ds	1	; Tecla ]
NGN_KEY_SEMICLON:		ds	1	; Tecla ;
; ROW 2
NGN_KEY_APOSTROPHE:		ds	1	; Tecla '
NGN_KEY_GRAVE:			ds	1	; Tecla `
NGN_KEY_COMMA:			ds	1	; Tecla ,
NGN_KEY_PERIOD:			ds	1	; Tecla .
NGN_KEY_SLASH:			ds	1	; Tecla /
NGN_KEY_DEAD:			ds	1	; Tecla DEAD KEY
NGN_KEY_A:			ds	1	; Tecla A
NGN_KEY_B:			ds	1	; Tecla B
; ROW 3
NGN_KEY_C:			ds	1	; Tecla C
NGN_KEY_D:			ds	1	; Tecla D
NGN_KEY_E:			ds	1	; Tecla E
NGN_KEY_F:			ds	1	; Tecla F
NGN_KEY_G:			ds	1	; Tecla G
NGN_KEY_H:			ds	1	; Tecla H
NGN_KEY_I:			ds	1	; Tecla I
NGN_KEY_J:			ds	1	; Tecla J
; ROW 4
NGN_KEY_K:			ds	1	; Tecla K
NGN_KEY_L:			ds	1	; Tecla L
NGN_KEY_M:			ds	1	; Tecla M
NGN_KEY_N:			ds	1	; Tecla N
NGN_KEY_O:			ds	1	; Tecla O
NGN_KEY_P:			ds	1	; Tecla P
NGN_KEY_Q:			ds	1	; Tecla Q
NGN_KEY_R:			ds	1	; Tecla R
; ROW 5
NGN_KEY_S:			ds	1	; Tecla S
NGN_KEY_T:			ds	1	; Tecla T
NGN_KEY_U:			ds	1	; Tecla U
NGN_KEY_V:			ds	1	; Tecla V
NGN_KEY_W:			ds	1	; Tecla W
NGN_KEY_X:			ds	1	; Tecla X
NGN_KEY_Y:			ds	1	; Tecla Y
NGN_KEY_Z:			ds	1	; Tecla Z
; ROW 6
NGN_KEY_SHIFT:			ds	1	; Tecla SHIFT
NGN_KEY_CTRL:			ds	1	; Tecla CTRL
NGN_KEY_GRAPH:			ds	1	; Tecla GRAPH
NGN_KEY_CAPS:			ds	1	; Tecla CAPS
NGN_KEY_CODE:			ds	1	; Tecla CODE
NGN_KEY_F1:			ds	1	; Tecla F1
NGN_KEY_F2:			ds	1	; Tecla F2
NGN_KEY_F3:			ds	1	; Tecla F3
; ROW 7
NGN_KEY_F4:			ds	1	; Tecla F4
NGN_KEY_F5:			ds	1	; Tecla F5
NGN_KEY_ESC:			ds	1	; Tecla ESC
NGN_KEY_TAB:			ds	1	; Tecla TAB
NGN_KEY_STOP:			ds	1	; Tecla STOP
NGN_KEY_BS:			ds	1	; Tecla BS
NGN_KEY_SELECT:			ds	1	; Tecla SELECT
NGN_KEY_RETURN:			ds	1	; Tecla RETURN
; ROW 8
NGN_KEY_SPACE:			ds	1	; Tecla SPACE
NGN_KEY_HOME:			ds	1	; Tecla HOME
NGN_KEY_INS:			ds	1	; Tecla INS
NGN_KEY_DEL:			ds	1	; Tecla DEL
NGN_KEY_LEFT:			ds	1	; Tecla CURSOR LEFT
NGN_KEY_UP:			ds	1	; Tecla CURSOR UP
NGN_KEY_DOWN:			ds	1	; Tecla CURSOR DOWN
NGN_KEY_RIGHT:			ds	1	; Tecla CURSOR RIGHT
; ROW 9
NGN_KEY_NUM_ASTERISK:		ds	1	; Tecla NUM *
NGN_KEY_NUM_PLUS:		ds	1	; Tecla NUM +
NGN_KEY_NUM_SLASH:		ds	1	; Tecla NUM /
NGN_KEY_NUM_0:			ds	1	; Tecla NUM 0
NGN_KEY_NUM_1:			ds	1	; Tecla NUM 1
NGN_KEY_NUM_2:			ds	1	; Tecla NUM 2
NGN_KEY_NUM_3:			ds	1	; Tecla NUM 3
NGN_KEY_NUM_4:			ds	1	; Tecla NUM 4
; ROW 10
NGN_KEY_NUM_5:			ds	1	; Tecla NUM 5
NGN_KEY_NUM_6:			ds	1	; Tecla NUM 6
NGN_KEY_NUM_7:			ds	1	; Tecla NUM 7
NGN_KEY_NUM_8:			ds	1	; Tecla NUM 8
NGN_KEY_NUM_9:			ds	1	; Tecla NUM 9
NGN_KEY_NUM_MINUS:		ds	1	; Tecla NUM -
NGN_KEY_NUM_COMMA:		ds	1	; Tecla NUM ,
NGN_KEY_NUM_PERIOD:		ds	1	; Tecla NUM .
; EXTRAS
NGN_KEY_ANY:			ds	1	; Cualquier tecla


; -----------------------------------------------------------------------
;	Joysticks
;	STATE	[TEMP]	[PRESS]	[HELD]		Key num: 12
;	BIT	  2	   1	  0		NGN_TOTAL_JOYKEYS
; -----------------------------------------------------------------------

NGN_JOY1_UP:		ds	1		; Joystick 1 Arriba
NGN_JOY1_DOWN:		ds	1		; Joystick 1 Abajo
NGN_JOY1_LEFT:		ds	1		; Joystick 1 Izquierda
NGN_JOY1_RIGHT:		ds	1		; Joystick 1 Derecha
NGN_JOY1_TG1:		ds	1		; Joystick 1 Tigger 1
NGN_JOY1_TG2:		ds	1		; Joystick 1 Tigger 2

NGN_JOY2_UP:		ds	1		; Joystick 2 Arriba
NGN_JOY2_DOWN:		ds	1		; Joystick 2 Abajo
NGN_JOY2_LEFT:		ds	1		; Joystick 2 Izquierda
NGN_JOY2_RIGHT:		ds	1		; Joystick 2 Derecha
NGN_JOY2_TG1:		ds	1		; Joystick 2 Tigger 1
NGN_JOY2_TG2:		ds	1		; Joystick 2 Tigger 2



; -----------------------------------------------------------------------
;	Gestion del sistema de sprites
;	[Y]	[X]	[GRAIFCO]	[COLOR]
;	0-255	0-255	0-63		0-15
; -----------------------------------------------------------------------

NGN_SPRITE_00:		ds	4		; Attributos del Sprite nº 00
NGN_SPRITE_01:		ds	4
NGN_SPRITE_02:		ds	4
NGN_SPRITE_03:		ds	4
NGN_SPRITE_04:		ds	4
NGN_SPRITE_05:		ds	4
NGN_SPRITE_06:		ds	4
NGN_SPRITE_07:		ds	4
NGN_SPRITE_08:		ds	4
NGN_SPRITE_09:		ds	4
NGN_SPRITE_10:		ds	4
NGN_SPRITE_11:		ds	4
NGN_SPRITE_12:		ds	4
NGN_SPRITE_13:		ds	4
NGN_SPRITE_14:		ds	4
NGN_SPRITE_15:		ds	4
NGN_SPRITE_16:		ds	4
NGN_SPRITE_17:		ds	4
NGN_SPRITE_18:		ds	4
NGN_SPRITE_19:		ds	4
NGN_SPRITE_20:		ds	4
NGN_SPRITE_21:		ds	4
NGN_SPRITE_22:		ds	4
NGN_SPRITE_23:		ds	4
NGN_SPRITE_24:		ds	4
NGN_SPRITE_25:		ds	4
NGN_SPRITE_26:		ds	4
NGN_SPRITE_27:		ds	4
NGN_SPRITE_28:		ds	4
NGN_SPRITE_29:		ds	4
NGN_SPRITE_30:		ds	4
NGN_SPRITE_31:		ds	4



; -----------------------------------------------------------------------
;	Descompresion RLE
; -----------------------------------------------------------------------

NGN_RANDOM_SEED:	ds	1



; -----------------------------------------------------------------------
;	Descompresion RLE
; -----------------------------------------------------------------------

; Gestion de la descompresion RLE
NGN_RLE_NORMAL_SIZE:		ds	2
NGN_RLE_COMPRESSED_SIZE:	ds	2
NGN_RLE_POINTER:		ds	2
; Buffer de RAM
NGN_RAM_BUFFER:			ds	2048



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_VARS_EOF: