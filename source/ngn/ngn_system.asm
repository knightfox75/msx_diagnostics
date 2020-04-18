;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.2.1-WIP01
;
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;	Funciones del sistema
;
;***********************************************************



; ----------------------------------------------------------
; NGN_SYSTEM_FD9A_PATCH_ON
; NGN_SYSTEM_FD9A_PATCH_OFF
; Parchea las interrupciones para que HALT solo
; sincronice con las interrupciones del VDP
; http://karoshi.auic.es/index.php?topic=212.0
; Gracias a F.L. Ostenero por la rutina
; Modifica A, BC, DE, HL
; ----------------------------------------------------------

NGN_SYSTEM_FD9A_PATCH_ON:					; Activa el parche de interrupciones

	ld hl, NGN_SYSTEM_FD9A_INTERRUPT		; Direccion de memoria que contiene el codigo del patch
	ld [$FD9B], hl                    	 	; La cargamos en $FD9B
	ld a,$C3                           		; Registro A -> JP xxxx
	ld [$FD9A], a                      		; Lo cargamos en $FD9A
	ret                                     ; Vuelve


NGN_SYSTEM_FD9A_PATCH_OFF:					; Desactiva el parche de interrupciones

	ld a, $C9                          		; REGISTRO A -> RET
	ld [$FD9A],a                       		; Cargamos un RET en $FD9A
	ret                                     ; Vuelve


NGN_SYSTEM_FD9A_INTERRUPT:

	call $013E                           	; Leemos el byte de interrupcion del VDP [RDVDP]
	bit 7, a                             	; Si la interrupcion fue provocada por el VDP
	ret nz                              	; Volvemos
	ei                                      ; Si no, reactivamos interrupciones
	halt                                    ; Esperamos a la siguiente
	ret                                     ; Y volvemos


; ----------------------------------------------------------
; NGN_SYSTEM_RANDOM_NUMBER
; Genera un numero aleatorio entre 0-255
; A = Devuelve el numero generado 
; Modifica A, B y C
; ----------------------------------------------------------

NGN_SYSTEM_RANDOM_NUMBER:

	ld a, [NGN_RANDOM_SEED]
	ld b, a

	@@REPEAT:

		add 1
		rlca
		add 11
		rlca
		add 31
		rlca
		add 41

		cp b
		jr nz, @@EXIT
		inc a

	jr @@REPEAT

	@@EXIT:
	ld [NGN_RANDOM_SEED], a

	ret



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_SYSTEM_EOF: