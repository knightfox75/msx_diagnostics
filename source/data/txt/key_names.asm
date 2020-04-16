;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.1-WIP01
;	ASM Z80 MSX
;	Nombres de las teclas
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************

KEY_NAMES_TOP_ROW:
	
	db	"0", "1", "2", "3", "4", "5", "6", "7"		; ROW 0


KEY_NAMES_INTERNATIONAL:

	db	"8", "9", "-", "=", $5C, "[", "]", $3B		; ROW 1
	db	"'", "`", ",", ".", "/", $F0, "A", "B"		; ROW 2
	db	"C", "D", "E", "F", "G", "H", "I", "J"		; ROW 3
	db	"K", "L", "M", "N", "O", "P", "Q", "R"		; ROW 4
	db	"S", "T", "U", "V", "W", "X", "Y", "Z"		; ROW 5


KEY_NAMES_FRANCE:

	db	"8", "9", ")", "-", "<", "^", "$", "M"		; ROW 1	*
	db	"%", "#", $3B, ":", "=", $F0, "Q", "B"		; ROW 2	*
	db	"C", "D", "E", "F", "G", "H", "I", "J"		; ROW 3
	db	"K", "L", ",", "N", "O", "P", "A", "R"		; ROW 4	*
	db	"S", "T", "U", "V", "Z", "X", "Y", "W"		; ROW 5	*


KEY_NAMES_BOTTOM_ROWS:

	db	$F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0		; ROW 6
	db	$F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0		; ROW 7
	db	$F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0		; ROW 8
	db	"*", "+", "/", "0", "1", "2", "3", "4"		; ROW 9
	db	"5", "6", "7", "8", "9", "-", ",", "."		; ROW 10



;***********************************************************
; Fin del archivo
;***********************************************************
KEY_NAMES_EOF: