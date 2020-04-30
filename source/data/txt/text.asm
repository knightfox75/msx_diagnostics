;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.8
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

	db $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3
	db $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3
	db $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3
	db $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3
	db $0D, $0A, $00



; Texto de cabecera de los menus
TEXT_MENU_HEADER:

	db	" MSX DIAGNOSTICS v1.1.8", $0D, $0A, $00



; Texto cancelar
TEXT_MENU_CANCEL:

	db	$0D, $0A
	db	$20, $CE, " PRESS CANCEL TO BACK TO THE", $0D, $0A
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
	db	"   9. SYSTEM INFO ", $0D, $0A
	db	"   0. NEXT >>", $0D, $0A
	db	$00



; Textos del menu principal (Pagina 2)
TEXT_MAIN_MENU_P2_TITLE:

	db	$0D, $0A
	db	" PAGE 2 OF 2", $0D, $0A
	db	$00

TEXT_MAIN_MENU_P2_ITEMS:
	db	$0D, $0A
	db	"   1. MONITOR COLOR", $0D, $0A
	db	"   2. MIXED MODE", $0D, $0A
	db	"   3. ", $C3, $0D, $0A
	db	"   4. ", $C3, $0D, $0A
	db	"   5. ", $C3, $0D, $0A
	db	"   6. ", $C3, $0D, $0A
	db	"   7. ", $C3, $0D, $0A
	db	"   8. ", $C3, $0D, $0A
	db	"   9. REBOOT", $0D, $0A
	db	"   0. BACK <<", $0D, $0A
	db	$00



; Texto de pie del menu principal
TEXT_MAIN_MENU_FOOTER:

	db	$0D, $0A
	db	$0D, $0A
	db	" ACCEPT: SPACE / BUTTON 1", $0D, $0A
	db	" CANCEL: ESC / BUTTON 2", $0D, $0A
	db	$0D, $0A
	db	" (cc) 2018-2020 BY CESAR RINCON", $0D, $0A
	db	$00



; Cursor del menu
TEXT_MAIN_MENU_ITEM_ON:		db	$C0, $00	; Cursor
TEXT_MAIN_MENU_ITEM_OFF:	db	$20, $00	; Borra el cursor



; Textos del menu SCREEN 0
TEXT_SCREEN0_MENU_TITLE:

	db	$0D, $0A
	db	" SCREEN 0 TEST", $0D, $0A
	db	$00

TEXT_SCREEN0_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	$20, $CE, " PRESS RIGHT/LEFT TO CHANGE", $0D, $0A
	db	"   THE TEXT COLOR.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " PRESS UP/DOWN TO CHANGE", $0D, $0A
	db	"   THE BACKGROUND COLOR.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " PRESS ACCEPT TO RESTORE DEFAULTS.", $0D, $0A
	db	$00



; Textos del menu SCREEN 1
TEXT_SCREEN1_MENU_TITLE:

	db	$0D, $0A
	db	" SCREEN 1 TEST", $0D, $0A
	db	$00

TEXT_SCREEN1_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	$20, $CE, " PRESS RIGHT/LEFT TO CHANGE", $0D, $0A
	db	"   THE TEXT COLOR.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " PRESS UP/DOWN TO CHANGE", $0D, $0A
	db	"   THE BACKGROUND COLOR.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " PRESS ACCEPT TO CHANGE THE", $0D, $0A
	db	"   BORDER COLOR.", $0D, $0A
	db	$00



; Textos del menu SCREEN 2
TEXT_SCREEN2_MENU_TITLE:

	db	$0D, $0A
	db	" SCREEN 2 TEST", $0D, $0A
	db	$00

TEXT_SCREEN2_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	$20, $CE, " PRESS RIGHT/LEFT TO CHANGE", $0D, $0A
	db	"   THE IMAGE.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " PRESS UP/DOWN TO CHANGE THE", $0D, $0A
	db	"   BORDER COLOR.", $0D, $0A
	db	$00



; Textos del menu SCREEN 3
TEXT_SCREEN3_MENU_TITLE:

	db	$0D, $0A
	db	" SCREEN 3 TEST", $0D, $0A
	db	$00

TEXT_SCREEN3_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	$20, $CE, " PRESS RIGHT/LEFT TO CHANGE", $0D, $0A
	db	"   THE PATTERN.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " PRESS UP/DOWN TO CHANGE THE", $0D, $0A
	db	"   BORDER COLOR.", $0D, $0A
	db	$00



; Textos del menu SPRITES
TEXT_SPRITES_MENU_TITLE:

	db	$0D, $0A
	db	" SPRITES TEST (16x16 MODE)", $0D, $0A
	db	$00

TEXT_SPRITES_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	$20, $CE, " PRESS ACCEPT TO START/STOP THE", $0D, $0A
	db	"   SPRITES MOVEMENT.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " PRESS UP TO RESET THE POSITIONS.", $0D, $0A
	db	$00



; Textos del menu KEYBOARD
TEXT_KEYBOARD_MENU_TITLE:

	db	$0D, $0A
	db	" KEYBOARD TEST", $0D, $0A
	db	$00

TEXT_KEYBOARD_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	$20, $CE, " PRESS AND RELEASE THE KEY TO TEST.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " WHEN A KEY PRESS OR RELEASE IS", $0D, $0A
	db	"   DETECTED, YOU'LL BE WARNED WITH A", $0D, $0A
	db	"   TEXT, COLOR CHANGE AND A SOUND.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " PRESS SHIFT + ESC OR BUTTON 2 TO", $0D, $0A
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
	db	$20, $CE, " TEST THE 4 DIRECTIONS AND 2 BUTTONS", $0D, $0A
	db	"   OF THE 2 JOYSTICKS.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " COLOR OF THE INDICATORS WILL CHANGE", $0D, $0A
	db	"   IF PRESS IS DETECTED.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " PRESS JOY1 UP + BUTTON 1 OR ESC", $0D, $0A
	db	"   TO BACK TO THE MAIN MENU.", $0D, $0A
	db	$00



; Textos del menu PSG
TEXT_PSG_MENU_TITLE:

	db	$0D, $0A
	db	" PSG TEST", $0D, $0A
	db	$00

TEXT_PSG_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	$20, $CE, " PRESS UP/DOWN TO CHANGE", $0D, $0A
	db	"   THE OPTION.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " PRESS LEFT/RIGHT TO CHANGE", $0D, $0A
	db	"   THE VALUE.", $0D, $0A
	db	$00



; Textos de la interfaz del test de sonido
TEXT_PSG_GUI:

	db	$C5, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C6, $0D, $0A
	db	$C4, "   PSG TEST                          ", $C4, $0D, $0A
	db	$C9, $C3, $C3, $C3, $C3, $C3, $CC, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CC, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CC, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CC, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CA, $0D, $0A
	db	$C4, " FRQ ", $C4, "  OFF  ", $C4, " 300HZ ", $C4, " 500HZ ", $C4, " 1KHZ  ", $C4, $0D, $0A
	db	$C9, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CA, $0D, $0A
	db	$C4, " ", $C0, " A ", $C4, "   ", $C1, "   ", $C4, "   ", $C2, "   ", $C4, "   ", $C2, "   ", $C4, "   ", $C2, "   ", $C4, $0D, $0A
	db	$C9, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CA, $0D, $0A
	db	$C4, "   B ", $C4, "   ", $C1, "   ", $C4, "   ", $C2, "   ", $C4, "   ", $C2, "   ", $C4, "   ", $C2, "   ", $C4, $0D, $0A
	db	$C9, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CA, $0D, $0A
	db	$C4, "   C ", $C4, "   ", $C1, "   ", $C4, "   ", $C2, "   ", $C4, "   ", $C2, "   ", $C4, "   ", $C2, "   ", $C4, $0D, $0A
	db	$C9, $C3, $C3, $C3, $C3, $C3, $CD, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CD, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CD, $C3, $CC, $C3, $C3, $C3, $C3, $C3, $CA, $0D, $0A
	db	$C4, "   VOLUME A  ", $C4, " ", $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, " ", $C4, "     ", $C4, $0D, $0A
	db	$C9, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $CA, $0D, $0A
	db	$C4, "   VOLUME B  ", $C4, " ", $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, " ", $C4, "     ", $C4, $0D, $0A
	db	$C9, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $CA, $0D, $0A
	db	$C4, "   VOLUME C  ", $C4, " ", $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, " ", $C4, "     ", $C4, $0D, $0A
	db	$C9, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $CC, $C3, $C3, $C3, $C3, $C3, $CC, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $CA, $0D, $0A
	db	$C4, "   NOISE     ", $C4, " OFF ", $C4, "  A  ", $C4, "  B  ", $C4, "  C  ", $C4, $0D, $0A
	db	$C9, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $CA, $0D, $0A
	db	$C4, "   ENABLE    ", $C4, "  ", $C1, "  ", $C4, "  ", $C2, "  ", $C4, "  ", $C2, "  ", $C4, "  ", $C2, "  ", $C4, $0D, $0A
	db	$C9, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $CD, $C3, $C3, $C3, $C3, $C3, $CD, $C3, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $C3, $CA, $0D, $0A
	db	$C4, "   FREQUENCY ", $C4, " ", $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C2, $C2, $C2, $C2, $C2, $C2, $C2, " ", $C4, "     ", $C4, $0D, $0A
	db	$C7, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CD, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $CD, $C3, $C3, $C3, $C3, $C3, $C8, $0D, $0A
	db	$00




; Textos de la informacion del sistema

TEXT_SYSTEM_INFO_TITLE:

	db	" SYSTEM INFORMATION", $0D, $0A, $00



TEXT_SYSTEM_INFO_MSX_MODEL:

	db	"MODEL: ", $00

TEXT_SYSTEM_INFO_MSX1:

	db	"MSX", $00

TEXT_SYSTEM_INFO_MSX2:

	db	"MSX2", $00

TEXT_SYSTEM_INFO_MSX2PLUS:

	db	"MSX2+", $00

TEXT_SYSTEM_INFO_MSXTR:

	db	"TURBO-R", $00

TEXT_SYSTEM_INFO_UNKNOW:

	db	"???", $00

TEXT_SYSTEM_INFO_KB:

	db	"KB", $00

TEXT_SYSTEM_INFO_RAM:

	db	"RAM: ", $00

TEXT_SYSTEM_INFO_VRAM:

	db	"VRAM: ", $00


TEXT_SYSTEM_INFO_VDP:

	db	"VDP: ", $00

TEXT_SYSTEM_INFO_TMS9918A:

	db	"TMS9918A/28A", $00

TEXT_SYSTEM_INFO_TMS9929A:

	db	"TMS9929A", $00

TEXT_SYSTEM_INFO_V9938:

	db	"V9938", $00

TEXT_SYSTEM_INFO_V9958:

	db	"V9958", $00


TEXT_SYSTEM_INFO_VDPFREQ:

	db	"FREQ: ", $00

TEXT_SYSTEM_INFO_HZ:

	db	"HZ", $00


TEXT_SYSTEM_INFO_KEYBOARD:

	db	"KEYBOARD: ", $00

TEXT_SYSTEM_INFO_LANG_JAPAN:

	db	"JP", $00

TEXT_SYSTEM_INFO_LANG_INTERNATIONAL:

	db	"INT", $00

TEXT_SYSTEM_INFO_LANG_FRANCE:

	db	"FR", $00

TEXT_SYSTEM_INFO_LANG_UK:

	db	"GB", $00

TEXT_SYSTEM_INFO_LANG_GERMANY:

	db	"DE", $00

TEXT_SYSTEM_INFO_LANG_USSR:

	db	"USSR", $00

TEXT_SYSTEM_INFO_LANG_SPAIN:

	db	"SP", $00


TEXT_SYSTEM_INFO_DASH:

	db	" - ", $00

TEXT_SYSTEM_INFO_RTC_DATE:

	db	"DATE", $00

TEXT_SYSTEM_INFO_RTC_TIME:

	db	"TIME", $00


TEXT_SYSTEM_INFO_SLOT_GUI_TOP:

	db	$C5, $C3, $CC, $C3, $C3, $C3, $C3, $CC, $C3, $C3, $C3, $C3, $CC, $C3, $C3, $C3, $C3, $CC, $C3, $C3, $C3, $C3, $CC, $C3, $C6, $00

TEXT_SYSTEM_INFO_SLOT_GUI_DATA:

	db	$C4, $20, $C4, $20, $20, $20, $20, $C4, $20, $20, $20, $20, $C4, $20, $20, $20, $20, $C4, $20, $20, $20, $20, $C4, $20, $C4, $00

TEXT_SYSTEM_INFO_SLOT_GUI_LINE:

	db	$C9, $C3, $CB, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $CB, $C3, $C3, $C3, $C3, $CB, $C3, $CA, $00

TEXT_SYSTEM_INFO_SLOT_GUI_BOTTOM:

	db	$C7, $C3, $CD, $C3, $C3, $C3, $C3, $CD, $C3, $C3, $C3, $C3, $CD, $C3, $C3, $C3, $C3, $CD, $C3, $C3, $C3, $C3, $CD, $C3, $C8, $00



TEXT_SYSTEM_INFO_EXIT:

	db	" PRESS ACCEPT OR CANCEL TO EXIT."
	db	$00





; Textos del menu MONITOR COLOR
TEXT_MONITOR_COLOR_MENU_TITLE:

	db	$0D, $0A
	db	" MONITOR COLOR TEST", $0D, $0A
	db	$00

TEXT_MONITOR_COLOR_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	$20, $CE, " PRESS LEFT/RIGHT TO CHANGE", $0D, $0A
	db	"   THE COLOR.", $0D, $0A
	db	$0D, $0A
	db	$20, $CE, " PRESS UP/DOWN TO CHANGE", $0D, $0A
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





; Textos del test de modo mixto
TEXT_MIXED_MODE_MENU_TITLE:

	db	$0D, $0A
	db	" MIXED MODE TEST", $0D, $0A
	db	$00

TEXT_MIXED_MODE_MENU_INSTRUCTIONS:
	db	$0D, $0A
	db	$20, $CE, " YOU MUST SEE 3 TEXT BLOCKS IF", $0D, $0A
	db	"   YOUR VDP SUPPORTS MIXED MODE.", $0D, $0A
	db	$00

TEXT_MIXED_MODE_MESSAGE:
	db	"  YOU MUST SEE ME THREE TIMES   "





; ----------------------------------------------------------
; Tabla de caracteres personalizados
; ----------------------------------------------------------

CUSTOM_CHARACTERS_SET:
; Cursor 					$C0
	db	11000000b
	db	11100000b
	db	11110000b
	db	11111000b
	db	11110000b
	db	11100000b
	db	11000000b
	db	00000000b

; Big Square 				$C1
	db	11111100b
	db	11111100b
	db	11111100b
	db	11111100b
	db	11111100b
	db	11111100b
	db	11111100b
	db	00000000b

; Small Square 				$C2
	db	00000000b
	db	00000000b
	db	01111000b
	db	01111000b
	db	01111000b
	db	00000000b
	db	00000000b
	db	00000000b

; Horizontal Line 			$C3
	db	00000000b
	db	00000000b
	db	00000000b
	db	11111111b
	db	00000000b
	db	00000000b
	db	00000000b
	db	00000000b

; Vertical Line				$C4
	db	00010000b
	db	00010000b
	db	00010000b
	db	00010000b
	db	00010000b
	db	00010000b
	db	00010000b
	db	00010000b

; Top-left corner			$C5
	db	00000000b
	db	00000000b
	db	00000000b
	db	00011100b
	db	00010000b
	db	00010000b
	db	00010000b
	db	00010000b

; Top-right corner			$C6
	db	00000000b
	db	00000000b
	db	00000000b
	db	11110000b
	db	00010000b
	db	00010000b
	db	00010000b
	db	00010000b

; Bottom-left corner		$C7
	db	00010000b
	db	00010000b
	db	00010000b
	db	00011100b
	db	00000000b
	db	00000000b
	db	00000000b
	db	00000000b

; Bottom-right corner		$C8
	db	00010000b
	db	00010000b
	db	00010000b
	db	11110000b
	db	00000000b
	db	00000000b
	db	00000000b
	db	00000000b

; Left top					$C9
	db	00010000b
	db	00010000b
	db	00010000b
	db	00011100b
	db	00010000b
	db	00010000b
	db	00010000b
	db	00010000b

; Right top					$CA
	db	00010000b
	db	00010000b
	db	00010000b
	db	11110000b
	db	00010000b
	db	00010000b
	db	00010000b
	db	00010000b

; Cross						$CB
	db	00010000b
	db	00010000b
	db	00010000b
	db	11111100b
	db	00010000b
	db	00010000b
	db	00010000b
	db	00010000b

; Cross top					$CC
	db	00000000b
	db	00000000b
	db	00000000b
	db	11111100b
	db	00010000b
	db	00010000b
	db	00010000b
	db	00010000b

; Cross bottom				$CD
	db	00010000b
	db	00010000b
	db	00010000b
	db	11111100b
	db	00000000b
	db	00000000b
	db	00000000b
	db	00000000b

; Big dot					$CE
	db	00000000b
	db	00010000b
	db	00111000b
	db	01111100b
	db	00111000b
	db	00010000b
	db	00000000b
	db	00000000b

; Warning					$CF
	db	00110000b
	db	01111000b
	db	01111000b
	db	00110000b
	db	00000000b
	db	00110000b
	db	00110000b
	db	00000000b



;***********************************************************
; Fin del archivo
;***********************************************************
TEXT_EOF: