;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.0.1-a
;
;	(cc)2018 Cesar Rincon "NightFox"
;	http://www.nightfoxandco.com
;
;	Funciones del sistema
;
;***********************************************************



; ----------------------------------------------------------
; NGN_SYSTEM_RANDOM_NUMBER
; Genera un numero aleatorio entre 0-255
; A = Devuelve el numero generado 
; Modifica A, B
; ----------------------------------------------------------

NGN_SYSTEM_RANDOM_NUMBER:

	ld a, [NGN_RANDOM_SEED]
	ld b, a
	add a, a
	add a, a
	add a, b
	add a, 7
	ld [NGN_RANDOM_SEED], a
	ret



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_SYSTEM_EOF: