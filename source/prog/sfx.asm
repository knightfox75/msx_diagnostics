;***********************************************************
; MSX DIAGNOSTICS
; Version 0.1.0-a
; ASM Z80 MSX
; Funciones de efectos de sonido
; (c) 2018 Cesar Rincon "NightFox"
; http://www.nightfoxandco.com
;***********************************************************



; ----------------------------------------------------------
; SFX: Ping!
; ----------------------------------------------------------

SFX_FUNCTION_PLAY_PING:

	di		; Deshabilita las interrupciones

	; Tono en el Canal A:  111,861 Hz / 186 = 601 hz
	ld a, 0
	out ($A0), a
	ld a, 186
	out ($A1), a
	ld a, 1
	out ($A0), a
	ld a, 0
	out ($A1), a

	; Volumen a 15
	ld a, 8		; Volumen del canal A
	out ($A0), a
	ld a, 15	; Volumen a 15 (sin modulacion)
	out ($A1), a

	ei		; Habilita las interrupciones

	ret		; Vuelve



; ----------------------------------------------------------
; SFX: Pong!
; ----------------------------------------------------------

SFX_FUNCTION_PLAY_PONG:

	di		; Deshabilita las interrupciones

	; Tono en el Canal A:  111,861 Hz / 280 = 400 hz
	ld a, 0
	out ($A0), a
	ld a, $08
	out ($A1), a
	ld a, 1
	out ($A0), a
	ld a, $01
	out ($A1), a

	; Volumen a 15
	ld a, 8		; Volumen del canal A
	out ($A0), a
	ld a, 15	; Volumen a 15 (sin modulacion)
	out ($A1), a

	ei		; Habilita las interrupciones

	ret		; Vuelve



; ----------------------------------------------------------
; SFX: Actualiza el canal A
; ----------------------------------------------------------

SFX_FUNCTION_UPDATE:

	di		; Deshabilita las interrupciones
	ld a, 8		; Volumen del canal A
	out ($A0), a
	in a, ($A2)	; Volumen actual
	ei		; Habilita las interrupciones

	cp 0		; Si no hay volumen, sal
	ret z

	di		; Deshabilita las interrupciones
	dec a
	out ($A1), a	; Nuevo volumen
	ei		; Habilita las interrupciones

	cp 0
	ret nz		; Si el volumen no es 0, vuelve

	di		; Deshabilita las interrupciones
	ld a, 0		; Anula el tono
	out ($A0), a
	ld a, 0
	out ($A1), a
	ld a, 1
	out ($A0), a
	ld a, 0
	out ($A1), a
	ei		; Habilita las interrupciones

	ret		; Vuelve



; ----------------------------------------------------------
; SFX: Elimina todos los sonidos del canal A
; ----------------------------------------------------------

SFX_FUNCTION_CLOSE:

	di		; Deshabilita las interrupciones

	; Canal A
	ld a, 0		; Anula el tono
	out ($A0), a
	ld a, 0
	out ($A1), a
	ld a, 1
	out ($A0), a
	ld a, 0
	out ($A1), a

	ld a, 8		; Volumen del canal A
	out ($A0), a
	ld a, 0
	out ($A1), a	; Nuevo volumen

	ei		; Habilita las interrupciones

	ret		; Vuelve



;***********************************************************
; Fin del archivo
;***********************************************************
SFX_EOF: