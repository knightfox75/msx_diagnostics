;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.2.0
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
	db	"'", "`", ",", ".", "/", $C1, "A", "B"		; ROW 2
	db	"C", "D", "E", "F", "G", "H", "I", "J"		; ROW 3
	db	"K", "L", "M", "N", "O", "P", "Q", "R"		; ROW 4
	db	"S", "T", "U", "V", "W", "X", "Y", "Z"		; ROW 5


KEY_NAMES_FRANCE:

	db	"8", "9", ")", "-", "<", "^", "$", "M"		; ROW 1	*
	db	"%", "#", $3B, ":", "=", $C1, "Q", "B"		; ROW 2	*
	db	"C", "D", "E", "F", "G", "H", "I", "J"		; ROW 3
	db	"K", "L", ",", "N", "O", "P", "A", "R"		; ROW 4	*
	db	"S", "T", "U", "V", "Z", "X", "Y", "W"		; ROW 5	*


KEY_NAMES_BOTTOM_ROWS:

	db	$C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1		; ROW 6
	db	$C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1		; ROW 7
	db	$C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1		; ROW 8
	db	"*", "+", "/", "0", "1", "2", "3", "4"		; ROW 9
	db	"5", "6", "7", "8", "9", "-", ",", "."		; ROW 10



;***********************************************************
; Fin del archivo
;***********************************************************
KEY_NAMES_EOF: