;***********************************************************
;
;	MSX DIAGNOSTICS
;	Version 1.1.9
;	ASM Z80 MSX
;	Rutinas del VDP
;	(cc) 2018-2020 Cesar Rincon "NightFox"
;	https://nightfoxandco.com
;
;***********************************************************



; ----------------------------------------------------------
; Identifica el VDP instalado		[VDP_TYPE_ID]
;	
;	0 - TMS9918A/28A/29A
;	1 - V9938
;	2 - V9958
;	255 - Otros
;
; Y la frecuencia de refresco		[VDP_HZ]
;
;	1 - 50hz
;	0 - 60hz
;
; ----------------------------------------------------------

FUNCTION_VDP_INDENTIFY_VDP_TYPE:

	; Verifica si la VDP es un TMS9918A/28A/29A

	xor a
	ld [$F3F6], a			; [SCNCNT] Fuerza saltarse la lectura del teclado
	ld [$FCA2], a			; [INTCNT] Fuerza saltarse la lectura de ON INTERVAL

	ld a, [$0006]			; Puerto de lectura
	inc a
	ld c, a	
	in a, [c]				; Lee el valor del Registro S0 del VDP
	
	di								; Deshabilita las interrupciones
	@@WAIT_INTERRUPT:
		in a, [c]					; Lee el valor del Registro S0 del VDP
		and a 						; Bitmask para el flag F (Vsync)
		jp p, @@WAIT_INTERRUPT		; Si no hay flag de Vsync, repite

	ld a, [$0007]		; Puerto de escritura
	inc a
	ld c, a
	ld a, 2				; Selecciona el registro S2 del VDP V9938 (si es posible)
	out [c], a
	ld a, $8F      		; Selecciona el registro R7/R15 en la VDP (1000 1111)
	out [c], a			; Si se ha podido seleccionar S1, sera R15, si no R7

	ld a, [$0006]		; Puerto de lectura
	inc a
	ld c, a	
	in a, [c]			; Lee el registro S0/S2
	
	ei					; Vuelve a habilitar las interrupciones

	and $40				; Mascara con el bit 6
						; Si es cero, flag del 5º sprite del registro S0 (TMS9918A)
						; Si es uno, flag del sync vertical del registro S2 (V99xx)

	jr nz, @@V99XX
	xor a				; TMS9918A/29A
	ld [VDP_TYPE_ID], a
	jp @@GET_VDP_HZ


	; Verifica si la VDP es un V99XX

	@@V99XX:

	ld a, [$0007]		; Puerto de escritura
	inc a
	ld c, a
	ld a, 1				; Selecciona el registro S1
	di					; Deshabilita la interrupciones
	out [c], a			; Aplica la seleccion de registro 

	ld a, $8F      		; Selecciona el registro R15 en la VDP (1000 1111)
	out [c], a			; Aplica la seleccion de S1 como registro de estado

	ld a, [$0006]		; Puerto de lectura
	inc a
	ld c, a	
	in a, [c]			; El el contenido de S1
	ei					; Habilita las interrupciones

	and $3E				; Bitmask para obtener el ID del VDP (0011 1110)
						; 0 = V9938
						; 2 = TMS99XX
						; 4 = V9958

	; 0 = V9938
	or a
	jr nz, @@V9958
	ld a, 1
	ld [VDP_TYPE_ID], a
	jp @@GET_VDP_HZ

	; 4 = V9958
	@@V9958:
	cp 4
	jr nz, @@UNKNOW
	ld a, 2
	ld [VDP_TYPE_ID], a
	jp @@GET_VDP_HZ

	; Desconocida
	@@UNKNOW:
	ld a, $FF
	ld [VDP_TYPE_ID], a


	; Frecuencia del VDP
	@@GET_VDP_HZ:

	; Asegurate que el registro  de estado S0 esta seleccionado en modelos MSX2 y superiores
	ld a, [$0007]		; Puerto de escritura
	inc a
	ld c, a
	xor a				; Selecciona el registro S0
	di					; Deshabilita la interrupciones
	out [c], a			; Aplica la seleccion de registro 

	ld a, $8F      		; Selecciona el registro R15 en la VDP (1000 1111)
	out [c], a			; Aplica la seleccion de S1 como registro de estado

	; Espera a la interrupcion de la VDP, antes de calcular los HZ
	ei
	halt

	; Rutina de conteo de ciclos para el calculo de los HZ
	ld hl, $0000			; Contador a 0

	xor a
	ld [$F3F6], a			; [SCNCNT] Fuerza saltarse la lectura del teclado
	ld [$FCA2], a			; [INTCNT] Fuerza saltarse la lectura de ON INTERVAL

	ld a, [$0006]			; Puerto de lectura
	inc a
	ld c, a	
	in a, [c]				; Lee el valor del Registro S0 del VDP (resetea la interrupcion)
	di						; Deshabilita las interrupciones
	@@WAIT_VBL:
		inc hl				; Conteo de ciclos
		in a, [c]			; Lee el valor del Registro S0 del VDP
		and a 				; Bitmask para el flag F (Vsync)
		jp p, @@WAIT_VBL	; Si no hay flag de Vsync, repite
	ei						; Habilita las interrupciones

	; Guarda el resultado del contador
	ld d, h
	ld e, l

	; Son 60hz?
	ld hl, $06EE		; Numero de ciclos superior a 60hz, pero inferior a 50hz
	sbc hl, de			; (en medio de los dos, 1774 ciclos del bucle)
	jr c, @@HZ50
	xor a
	ld [VDP_HZ], a		; 60hz
	jr @@EXIT

	@@HZ50:
	ld a, 1
	ld [VDP_HZ], a		; 50hz

	@@EXIT:
	ret





;***********************************************************
; Fin del archivo
;***********************************************************
VDP_ROUTINES_EOF: