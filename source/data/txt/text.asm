;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.0
;	ASM Z80 MSX
;	Textos del programa
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; Textos de la pantalla de reinicio
TEXT_RESTART:

	db	"REBOOTING...", $00

; Barra horizontal
TEXT_DASHED_LINE:

	db	"---------------------------------------", $0D, $0A, $00



; Texto de cabecera de los menus
TEXT_MENU_HEADER:

	db	" MSX DIAGNOSTICS v1.1.0", $0D, $0A, $00



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



; Textos del menu principal (Pagina 1)
TEXT_MAIN_MENU_P1_TITLE:

	db	$0D, $0A
	db	" PAGE 1 OF 2", $0D, $0A
	db	$00

TEXT_MAIN_MENU_P1_ITEMS:
	db	$0D, $0A
	db	"   1. SCREEN 0", $0D, $0A
	db	"   2. SCREEN 1", $0D, $0A
	db	"   3. SCREEN 2", $0D, $0A
	db	"   4. SCREEN 3", $0D, $0A
	db	"   5. SPRITES", $0D, $0A
	db	"   6. KEYBOARD", $0D, $0A
	db	"   7. JOYSTICK", $0D, $0A
	db	"   8. PSG", $0D, $0A
	db	"   9. SYSTEM INFO *", $0D, $0A
	db	"   0. NEXT PAGE >>", $0D, $0A
	db	$00



; Textos del menu principal (Pagina 2)
TEXT_MAIN_MENU_P2_TITLE:

	db	$0D, $0A
	db	" PAGE 2 OF 2", $0D, $0A
	db	$00

TEXT_MAIN_MENU_P2_ITEMS:
	db	$0D, $0A
	db	"   1. MONITOR COLOR", $0D, $0A
	db	"   2. ---", $0D, $0A
	db	"   3. ---", $0D, $0A
	db	"   4. ---", $0D, $0A
	db	"   5. ---", $0D, $0A
	db	"   6. ---", $0D, $0A
	db	"   7. ---", $0D, $0A
	db	"   8. ---", $0D, $0A
	db	"   9. REBOOT", $0D, $0A
	db	"   0. << PREVIOUS PAGE", $0D, $0A
	db	$00



; Texto de pie del menu principal
TEXT_MAIN_MENU_FOOTER:

	db	$0D, $0A
	db	$0D, $0A
	db	" ACCEPT -> SPACE / BUTTON 1", $0D, $0A
	db	" CANCEL -> ESC / BUTTON 2", $0D, $0A
	db	$0D, $0A
	db	" (cc) 2018-2020 BY CESAR RINCON", $0D, $0A
	db	$00



; Cursor del menu
TEXT_MAIN_MENU_ITEM_ON:		db	">", $00	; Cursor
TEXT_MAIN_MENU_ITEM_OFF:	db	$20, $00	; Borra el cursor



; Textos del menu SCREEN 0
TEXT_SCREEN0_MENU_TITLE:

	db	$0D, $0A
	db	" SCREEN 0 TEST", $0D, $0A
	db	$00

TEXT_SCREEN0_MENU_INSTRUCTIONS:
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
TEXT_SCREEN1_MENU_TITLE:

	db	$0D, $0A
	db	" SCREEN 1 TEST", $0D, $0A
	db	$00

TEXT_SCREEN1_MENU_INSTRUCTIONS:
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
TEXT_SCREEN2_MENU_TITLE:

	db	$0D, $0A
	db	" SCREEN 2 TEST", $0D, $0A
	db	$00

TEXT_SCREEN2_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	" * PRESS RIGHT/LEFT TO CHANGE", $0D, $0A
	db	"   THE IMAGE.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS UP/DOWN TO CHANGE THE", $0D, $0A
	db	"   BORDER COLOR.", $0D, $0A
	db	$00



; Textos del menu SCREEN 3
TEXT_SCREEN3_MENU_TITLE:

	db	$0D, $0A
	db	" SCREEN 3 TEST", $0D, $0A
	db	$00

TEXT_SCREEN3_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	" * PRESS RIGHT/LEFT TO CHANGE", $0D, $0A
	db	"   THE PATTERN.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS UP/DOWN TO CHANGE THE", $0D, $0A
	db	"   BORDER COLOR.", $0D, $0A
	db	$00



; Textos del menu SPRITES
TEXT_SPRITES_MENU_TITLE:

	db	$0D, $0A
	db	" SPRITES TEST (16x16 MODE)", $0D, $0A
	db	$00

TEXT_SPRITES_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	" * PRESS ACCEPT TO START/STOP THE", $0D, $0A
	db	"   SPRITES MOVEMENT.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS UP TO RESET THE POSITIONS.", $0D, $0A
	db	$00



; Textos del menu KEYBOARD
TEXT_KEYBOARD_MENU_TITLE:

	db	$0D, $0A
	db	" KEYBOARD TEST", $0D, $0A
	db	$00

TEXT_KEYBOARD_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	" * PRESS AND RELEASE THE KEY TO TEST.", $0D, $0A
	db	$0D, $0A
	db	" * WHEN A KEY PRESS OR RELEASE IS", $0D, $0A
	db	"   DETECTED, YOU'LL BE WARNED WITH A", $0D, $0A
	db	"   TEXT, COLOR CHANGE AND A SOUND.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS SHIFT + ESC OR BUTTON 2 TO", $0D, $0A
	db	"   BACK TO THE MAIN MENU.", $0D, $0A
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



; Textos del menu JOYSTICK
TEXT_JOYSTICK_MENU_TITLE:

	db	$0D, $0A
	db	" JOYSTICKS TEST", $0D, $0A
	db	$00

TEXT_JOYSTICK_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	" * TEST THE 4 DIRECTIONS AND 2 BUTTONS", $0D, $0A
	db	"   OF THE 2 JOYSTICKS.", $0D, $0A
	db	$0D, $0A
	db	" * COLOR OF THE INDICATORS WILL CHANGE", $0D, $0A
	db	"   IF PRESS IS DETECTED.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS JOY1 UP + BUTTON 1 OR ESC", $0D, $0A
	db	"   TO BACK TO THE MAIN MENU.", $0D, $0A
	db	$00



; Textos del menu PSG
TEXT_PSG_MENU_TITLE:

	db	$0D, $0A
	db	" PSG TEST", $0D, $0A
	db	$00

TEXT_PSG_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	" * PRESS UP/DOWN TO CHANGE", $0D, $0A
	db	"   THE OPTION.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS LEFT/RIGHT TO CHANGE", $0D, $0A
	db	"   THE VALUE.", $0D, $0A
	db	$00



; Textos de la interfaz del test de sonido
TEXT_PSG_GUI:

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




; Textos de la informacion del sistema

TEXT_SYSTEM_INFO_TITLE:

	db	" SYSTEM INFORMATION", $0D, $0A, $00



TEXT_SYSTEM_INFO_MSX_MODEL:

	db	$0D, $0A, $0D, $0A, "  MODEL: ", $00

TEXT_SYSTEM_INFO_MSX1:

	db	"MSX", $00

TEXT_SYSTEM_INFO_MSX2:

	db	"MSX2", $00

TEXT_SYSTEM_INFO_MSX2PLUS:

	db	"MSX2+", $00

TEXT_SYSTEM_INFO_MSXTR:

	db	"TURBO-R", $00

TEXT_SYSTEM_INFO_UNKNOW:

	db	"UNKNOW", $00



TEXT_SYSTEM_INFO_N_16:

	db "16", $00

TEXT_SYSTEM_INFO_N_32:

	db "32", $00

TEXT_SYSTEM_INFO_N_64:

	db "64", $00

TEXT_SYSTEM_INFO_N_128:

	db "128", $00

TEXT_SYSTEM_INFO_N_256:

	db "256", $00

TEXT_SYSTEM_INFO_N_512:

	db "512", $00

TEXT_SYSTEM_INFO_KB:

	db "KB", $00

TEXT_SYSTEM_INFO_VRAM:

	db	$0D, $0A, $0D, $0A, "  VRAM: ", $00

TEXT_SYSTEM_INFO_RAM:

	db	$0D, $0A, $0D, $0A, "  RAM: ", $00



TEXT_SYSTEM_INFO_KEYBOARD:

	db	$0D, $0A, $0D, $0A, "  KEYBOARD LAYOUT: ", $00

TEXT_SYSTEM_INFO_KB_JAPAN:

	db	"JP", $00

TEXT_SYSTEM_INFO_KB_INTERNATIONAL:

	db	"INT", $00

TEXT_SYSTEM_INFO_KB_FRANCE:

	db	"FR", $00

TEXT_SYSTEM_INFO_KB_UK:

	db	"GB", $00

TEXT_SYSTEM_INFO_KB_GERMANY:

	db	"DE", $00

TEXT_SYSTEM_INFO_KB_USSR:

	db	"USSR", $00

TEXT_SYSTEM_INFO_KB_SPAIN:

	db	"SP", $00

TEXT_SYSTEM_INFO_EXIT:

	db	$0D, $0A, $0D, $0A, $0D, $0A, $0D, $0A
	db	"    THIS OPTION STILL IN", $0D, $0A
	db	"    WORK IN PROGRESS STATUS."
	db	$0D, $0A, $0D, $0A, $0D, $0A, $0D, $0A, $0D, $0A
	db	" PRESS ACCEPT OR CANCEL TO EXIT."
	db	$00




; Textos del menu MONITOR COLOR
TEXT_MONITOR_COLOR_MENU_TITLE:

	db	$0D, $0A
	db	" MONITOR COLOR TEST", $0D, $0A
	db	$00

TEXT_MONITOR_COLOR_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	" * PRESS LEFT/RIGHT TO CHANGE", $0D, $0A
	db	"   THE COLOR.", $0D, $0A
	db	$0D, $0A
	db	" * PRESS UP/DOWN TO CHANGE", $0D, $0A
	db	"   THE SPEED (IF AVAILABLE).", $0D, $0A
	db	$00


; Textos de la interfaz del MONITOR COLOR
TEXT_MONITOR_COLOR_TEST:
	db " TEST", $00

TEXT_MONITOR_COLOR_WHITE:
	db "WHITE", $00

TEXT_MONITOR_COLOR_BLACK:
	db "BLACK", $00

TEXT_MONITOR_COLOR_RED:
	db "RED", $00

TEXT_MONITOR_COLOR_GREEN:
	db "GREEN", $00

TEXT_MONITOR_COLOR_BLUE:
	db "BLUE ", $00

TEXT_MONITOR_COLOR_LOOP:
	db "LOOPING", $00



;***********************************************************
; Fin del archivo
;***********************************************************
TEXT_EOF: