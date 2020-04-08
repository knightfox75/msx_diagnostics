;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 0.9.0-a
;	ASM Z80 MSX
;	Textos del programa
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; Textos de la pantalla de reinicio
TEXT_RESTART:

	db	"REBOOTING...", $00
	


; Texto de cabecera de los menus
TEXT_MENU_HEADER:

	db	"---------------------------------------", $0D, $0A
	db	" MSX DIAGNOSTICS 0.9.0-A", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$0D, $0A
	db	$00



; Texto cancelar
TEXT_MENU_CANCEL:

	db	$0D, $0A
	db	" * PRESS CANCEL TO BACK TO THE", $0D, $0A
	db	"   MAIN MENU.", $0D, $0A
	db	$00



; Texto de pie de los menus
TEXT_MENU_FOOTER:

	db	$0D, $0A
	db	$0D, $0A
	db	$0D, $0A
	db	" PRESS ACCEPT TO START THE TEST.", $0D, $0A
	db	$00



; Textos del menu principal
TEXT_MAIN_MENU:

	db	" TEST MENU", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$0D, $0A
	db	"   1. SCREEN 0", $0D, $0A
	db	"   2. SCREEN 1", $0D, $0A
	db	"   3. SCREEN 2", $0D, $0A
	db	"   4. SCREEN 3", $0D, $0A
	db	"   5. SPRITES", $0D, $0A
	db	"   6. KEYBOARD", $0D, $0A
	db	"   7. JOYSTICK", $0D, $0A
	db	"   8. PSG", $0D, $0A
	db	"   0. REBOOT", $0D, $0A
	db	$0D, $0A
	db	$0D, $0A
	db	" ACCEPT -> SPACE / BUTTON 1", $0D, $0A
	db	" CANCEL -> ESC / BUTTON 2", $0D, $0A
	db	$0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	" (cc) 2018-2020 BY CESAR RINCON", $0D, $0A
	db	"---------------------------------------"
	db	$00

TEXT_MAIN_MENU_ITEM_ON:		db	">", $00	; Cursor
TEXT_MAIN_MENU_ITEM_OFF:	db	$20, $00	; Borra el cursor



; Textos del menu SCREEN 0
TEXT_SCREEN0_MENU:

	db	$0D, $0A
	db	" SCREEN 0 TEST", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$0D, $0A
	db	" * PRESS RIGHT/LEFT TO CHANGE", $0D, $0A
	db	"   THE TEXT COLOR.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS UP/DOWN TO CHANGE", $0D, $0A
	db	"   THE BACKGROUND COLOR.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS ACCEPT TO RESTORE DEFAULTS.", $0D, $0A
	db	$00



; Textos del menu SCREEN 1
TEXT_SCREEN1_MENU:

	db	$0D, $0A
	db	" SCREEN 1 TEST", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$0D, $0A
	db	" * PRESS RIGHT/LEFT TO CHANGE", $0D, $0A
	db	"   THE TEXT COLOR.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS UP/DOWN TO CHANGE", $0D, $0A
	db	"   THE BACKGROUND COLOR.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS ACCEPT TO CHANGE THE", $0D, $0A
	db	"   BORDER COLOR.", $0D, $0A
	db	$00



; Textos del menu SCREEN 2
TEXT_SCREEN2_MENU:

	db	$0D, $0A
	db	" SCREEN 2 TEST", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$0D, $0A
	db	" * PRESS RIGHT/LEFT TO CHANGE", $0D, $0A
	db	"   THE IMAGE.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS UP/DOWN TO CHANGE THE", $0D, $0A
	db	"   BORDER COLOR.", $0D, $0A
	db	$00



; Textos del menu SCREEN 3
TEXT_SCREEN3_MENU:

	db	$0D, $0A
	db	" SCREEN 3 TEST", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$0D, $0A
	db	" * PRESS RIGHT/LEFT TO CHANGE", $0D, $0A
	db	"   THE PATTERN.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS UP/DOWN TO CHANGE THE", $0D, $0A
	db	"   BORDER COLOR.", $0D, $0A
	db	$00



; Textos del menu SPRITES
TEXT_SPRITES_MENU:

	db	$0D, $0A
	db	" SPRITES TEST (16x16 MODE)", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$0D, $0A
	db	" * PRESS ACCEPT TO START/STOP THE", $0D, $0A
	db	"   SPRITES MOVEMENT.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS UP TO RESET THE POSITIONS.", $0D, $0A
	db	$00



; Texto cancelar (test del teclado)
TEXT_KEYBOARD_CANCEL:

	db	$0D, $0A
	db	" * PRESS CTRL + ESC OR BUTTON 2 TO", $0D, $0A
	db	"   BACK TO THE MAIN MENU.", $0D, $0A
	db	$00



; Textos del menu KEYBOARD
TEXT_KEYBOARD_MENU:

	db	$0D, $0A
	db	" KEYBOARD TEST", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$0D, $0A
	db	" * PRESS AND RELEASE THE KEY TO TEST.", $0D, $0A
	db	$0D, $0A
	db	" * WHEN A KEY PRESS OR RELEASE IS", $0D, $0A
	db	"   DETECTED, YOU'LL BE WARNED WITH A", $0D, $0A
	db	"   TEXT, COLOR CHANGE AND A SOUND.", $0D, $0A
	db	$00



; Textos del test del KEYBOARD
TEXT_KEYBOARD_TEST_WAIT_RELEASE:

	db	"PLEASE, RELEASE ALL THE KEYS...", $00


TEXT_KEYBOARD_TEST_READY:

	db	"KEYBOARD TEST READY...", $0D, $0A
	db	$0D, $0A, $00


TEXT_KEYBOARD_TEST_PRESSED:

	db	" IS DOWN.", $0D, $0A, $00


TEXT_KEYBOARD_TEST_RELEASED:

	db	" IS UP.", $0D, $0A, $00



; Texto cancelar (test del joystick)
TEXT_JOYSTICK_CANCEL:

	db	$0D, $0A
	db	" * PRESS JOY1 UP + BUTTON 1 OR ESC", $0D, $0A
	db	"   TO BACK TO THE MAIN MENU.", $0D, $0A
	db	$00



; Textos del menu JOYSTICK
TEXT_JOYSTICK_MENU:

	db	$0D, $0A
	db	" JOYSTICKS TEST", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$0D, $0A
	db	" * TEST THE 4 DIRECTIONS AND 2 BUTTONS", $0D, $0A
	db	"   OF THE 2 JOYSTICKS.", $0D, $0A
	db	$0D, $0A
	db	" * COLOR OF THE INDICATORS WILL CHANGE", $0D, $0A
	db	"   IF PRESS IS DETECTED.", $0D, $0A
	db	$00



; Textos del menu PSG
TEXT_SOUND_MENU:

	db	$0D, $0A
	db	" PSG TEST", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$0D, $0A
	db	" * PRESS UP/DOWN TO CHANGE", $0D, $0A
	db	"   THE OPTION.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS LEFT/RIGHT TO CHANGE", $0D, $0A
	db	"   THE VALUE.", $0D, $0A
	db	$00



; Textos de la interfaz del test de sonido
TEXT_SOUND_GUI:

	db	"---------------------------------------", $0D, $0A
	db	"|   PSG TEST                          |", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	"| FRQ |  OFF  | 300HZ | 500HZ | 1KHZ  |", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	"| > A |   ", $DB, "   |   ", $C4, "   |   ", $C4, "   |   ", $C4, "   |", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	"|   B |   ", $DB, "   |   ", $C4, "   |   ", $C4, "   |   ", $C4, "   |", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	"|   C |   ", $DB, "   |   ", $C4, "   |   ", $C4, "   |   ", $C4, "   |", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	"|   VOLUME A  | ", $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, " |     |", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	"|   VOLUME B  | ", $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, " |     |", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	"|   VOLUME C  | ", $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, " |     |", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	"|   NOISE     | OFF |  A  |  B  |  C  |", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	"|   ENABLE    |  ", $DB, "  |  ", $C4, "  |  ", $C4, "  |  ", $C4, "  |", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	"|   FREQUENCY | ", $DB, $DB, $DB, $DB, $DB, $DB, $DB, $DB, $C4, $C4, $C4, $C4, $C4, $C4, $C4, " |     |", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$00