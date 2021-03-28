;***********************************************************
;
;	N'gine para MSX Asm Z80
;	Version 0.3.4
;
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;	Funciones matematicas
;
;***********************************************************



; ----------------------------------------------------------
; NGN_BCD_ADD
; DE = Direccion de memoria con el numero base
; y almacena el resultado
; HL = Direccion de memoria con el sumando
; Numeros en formato BCD de 3 bytes (0 - 99999)
; Modifica AF, BC, DE, HL
; Info: https://www.chibiakumas.com/z80/advanced.php
; ----------------------------------------------------------

NGN_BCD_ADD:

	ld b, 3				; Suma BCD de 3 bytes
	or a				; Resetea el flag

	@@BCD_ADD_LOOP:
		ld a, [de]		; Lee el valor base
		adc [hl]		; Sumale el valor
		daa				; Corrige el formato a BCD
		ld [de], a		; Guarda el valor actualizado
		inc de			; Siguiente byte en ambos operadores
		inc hl
		djnz @@BCD_ADD_LOOP

	ret					; Vuelve de la funcion



; ----------------------------------------------------------
; NGN_BCD_SUB
; DE = Direccion de memoria con el numero base
; y almacena el resultado
; HL = Direccion de memoria con el substranedo (numero que restamos)
; Numeros en formato BCD de 3 bytes (0 - 99999)
; Modifica AF, BC, DE, HL
; Info: https://www.chibiakumas.com/z80/advanced.php
; ----------------------------------------------------------

NGN_BCD_SUB:

	ld b, 3				; Resta BCD de 3 bytes
	or a				; Resetea el flag

	@@BCD_SUB_LOOP:
		ld a, [de]		; Lee el valor base
		sbc [hl]		; Restale el valor
		daa				; Corrige el formato a BCD
		ld [de], a		; Guarda el valor actualizado
		inc de			; Siguiente byte en ambos operadores
		inc hl
		djnz @@BCD_SUB_LOOP

	ret					; Vuelve de la funcion



;***********************************************************
; Fin del archivo
;***********************************************************
NGN_MATH_EOF: