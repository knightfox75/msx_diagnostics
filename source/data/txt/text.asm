;***********************************************************
; MSX DIAGNOSTICS
; Version 0.1.0-a
; ASM Z80 MSX
; Textos del programa
; (c) 2018 Cesar Rincon "NightFox"
; http://www.nightfoxandco.com
;***********************************************************



; Textos de la pantalla de reinicio
TEXT_RESTART:

	db	"REBOOTING...", $00
	


; Texto de cabecera de los menus
TEXT_MENU_HEADER:

	db	"---------------------------------------", $0D, $0A
	db	" MSX DIAGNOSTICS 0.1.0-A", $0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	$0D, $0A
	db	$00



; Texto de pie de los menus
TEXT_MENU_FOOTER:

	db	$0D, $0A
	db	" * PRESS CANCEL TO BACK TO THE", $0D, $0A
	db	"   MAIN MENU.", $0D, $0A
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
	db	"   2. SCREEN 2", $0D, $0A
	db	"   3. SPRITES", $0D, $0A
	db	"   4. KEYBOARD", $0D, $0A
	db	"   5. JOYSTICK", $0D, $0A
	db	"   6. SOUND", $0D, $0A
	db	"   0. REBOOT", $0D, $0A
	db	$0D, $0A
	db	$0D, $0A
	db	$0D, $0A
	db	$0D, $0A
	db	" ACCEPT -> SPACE / BUTTON 1", $0D, $0A
	db	" CANCEL -> ESC / BUTTON 2", $0D, $0A
	db	$0D, $0A
	db	"---------------------------------------", $0D, $0A
	db	" (cc)2018 BY CESAR RINCON", $0D, $0A
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
