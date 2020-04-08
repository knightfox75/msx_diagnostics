;************************************************************
;*    Imagen convertida para MSX - SCREEN 2
;*    Archivo de origen: bg_joytest.bmp
;*    Tamaño: 256x192 pixeles
;*    Compresion RLE habilitada
;*    Total de datos: 560 bytes
;************************************************************


BG_JOYTEST_IMAGE:

; Datos CHR
; Banco 0: 018 bloques de CHR
;          Tamaño descomprimido: 144 bytes [$0090 bytes]
;          Tamaño RLE: 100 bytes [$0064 bytes]
; Banco 1: 017 bloques de CHR
;          Tamaño descomprimido: 136 bytes [$0088 bytes]
;          Tamaño RLE: 115 bytes [$0073 bytes]
; Banco 2: 005 bloques de CHR
;          Tamaño descomprimido: 40 bytes [$0028 bytes]
;          Tamaño RLE: 30 bytes [$001e bytes]

BG_JOYTEST_CHR_0:
; Tamaño descomprimido:
db $00, $90
; Tamaño comprimido (RLE):
db $00, $64
; Datos:
db $c9, $00, $01, $00, $18, $c3, $1c, $18
db $00, $07, $0f, $63, $c4, $47, $00, $3c
db $0c, $73, $c4, $3b, $00, $07, $03, $c3
db $71, $61, $03, $c3, $00, $c5, $0e, $00
db $c2, $1f, $c6, $00, $1c, $7c, $03, $63
db $c3, $1c, $c2, $00, $c2, $01, $c5, $00
db $03, $01, $70, $c3, $07, $0e, $00, $01
db $c4, $1f, $c2, $00, $c3, $38, $1c, $1f
db $07, $c2, $00, $c3, $3b, $73, $1c, $3c
db $c2, $00, $07, $c2, $63, $c2, $71, $78
db $c2, $00, $c6, $0e, $c2, $00, $c4, $1c
db $c8, $00, $c2, $01, $c2, $00, $1c, $38
db $70, $1f, $c4, $00

BG_JOYTEST_CHR_1:
; Tamaño descomprimido:
db $00, $88
; Tamaño comprimido (RLE):
db $00, $73
; Datos:
db $c9, $00, $c2, $01, $c2, $02, $c2, $04
db $08, $00, $c2, $7f, $c2, $40, $c2, $20
db $10, $08, $c2, $10, $c2, $20, $c2, $40
db $00, $10, $c2, $08, $c2, $04, $c2, $02
db $c5, $00, $01, $06, $18, $60, $01, $07
db $19, $61, $7e, $c3, $01, $7f, $1f, $67
db $79, $7e, $c3, $7f, $c4, $00, $7f, $60
db $18, $06, $60, $18, $06, $01, $c4, $00
db $c3, $01, $7e, $61, $19, $07, $01, $c3
db $7f, $7e, $79, $67, $1f, $7f, $06, $18
db $60, $7f, $c5, $00, $c2, $40, $c2, $20
db $c2, $10, $08, $00, $c2, $02, $c2, $04
db $c2, $08, $10, $08, $c2, $04, $c2, $02
db $c2, $01, $00, $10, $c2, $20, $c2, $40
db $c2, $7f, $00

BG_JOYTEST_CHR_2:
; Tamaño descomprimido:
db $00, $28
; Tamaño comprimido (RLE):
db $00, $1e
; Datos:
db $c8, $00, $07, $18, $20, $c2, $40, $c3
db $7f, $1f, $18, $04, $c2, $02, $c3, $01
db $c3, $7f, $c2, $40, $20, $18, $07, $c3
db $01, $c2, $02, $04, $18, $1f


; Datos CLR
; Banco 0: 018 bloques de CLR
;          Tamaño descomprimido: 144 bytes [$0090 bytes]
;          Tamaño RLE: 87 bytes [$0057 bytes]
; Banco 1: 017 bloques de CLR
;          Tamaño descomprimido: 136 bytes [$0088 bytes]
;          Tamaño RLE: 57 bytes [$0039 bytes]
; Banco 2: 005 bloques de CLR
;          Tamaño descomprimido: 40 bytes [$0028 bytes]
;          Tamaño RLE: 13 bytes [$000d bytes]

BG_JOYTEST_CLR_0:
; Tamaño descomprimido:
db $00, $90
; Tamaño comprimido (RLE):
db $00, $57
; Datos:
db $c9, $11, $1f, $c1, $ff, $c5, $1f, $11
db $c2, $f1, $c5, $1f, $11, $c2, $1f, $c5
db $f1, $11, $c7, $1f, $11, $c2, $ff, $c5
db $f1, $11, $c2, $1f, $c6, $11, $c2, $f1
db $c2, $1f, $c3, $f1, $c2, $11, $c2, $f1
db $c5, $11, $c3, $1f, $c4, $f1, $c1, $ff
db $c5, $1f, $c2, $11, $c6, $f1, $c2, $11
db $c4, $f1, $c2, $1f, $c2, $11, $c6, $1f
db $c2, $11, $c6, $f1, $c2, $11, $c4, $f1
db $c2, $ff, $c6, $11, $c2, $f1, $c2, $11
db $c3, $f1, $1f, $c2, $ff, $c2, $11

BG_JOYTEST_CLR_1:
; Tamaño descomprimido:
db $00, $88
; Tamaño comprimido (RLE):
db $00, $39
; Datos:
db $c9, $11, $c7, $f1, $11, $c2, $1f, $cc
db $f1, $c1, $ff, $c7, $f1, $c1, $ff, $c4
db $11, $c8, $f1, $1f, $c3, $f1, $c8, $1f
db $c4, $11, $1f, $c7, $f1, $c4, $11, $c3
db $f1, $1f, $c4, $f1, $c8, $1f, $c3, $f1
db $1f, $c4, $11, $c1, $ff, $c7, $f1, $c1
db $ff, $ce, $f1, $11, $c5, $f1, $c2, $1f
db $11

BG_JOYTEST_CLR_2:
; Tamaño descomprimido:
db $00, $28
; Tamaño comprimido (RLE):
db $00, $0d
; Datos:
db $c8, $11, $c5, $f1, $c4, $1f, $c7, $f1
db $c3, $1f, $cc, $f1, $1f


; Datos NAME
; Banco 0: 256 bloques de NAME
;          Tamaño descomprimido: 256 bytes [$0100 bytes]
;          Tamaño RLE: 48 bytes [$0030 bytes]
; Banco 1: 256 bloques de NAME
;          Tamaño descomprimido: 256 bytes [$0100 bytes]
;          Tamaño RLE: 66 bytes [$0042 bytes]
; Banco 2: 256 bloques de NAME
;          Tamaño descomprimido: 256 bytes [$0100 bytes]
;          Tamaño RLE: 40 bytes [$0028 bytes]

BG_JOYTEST_NAM_0:
; Tamaño descomprimido:
db $01, $00
; Tamaño comprimido (RLE):
db $00, $30
; Datos:
db $ff, $00, $ff, $00, $c7, $00, $01, $02
db $03, $04, $05, $06, $00, $07, $c6, $00
db $01, $02, $03, $04, $05, $06, $08, $09
db $ca, $00, $0a, $0b, $0c, $0d, $0e, $c2
db $00, $0f, $c6, $00, $0a, $0b, $0c, $0d
db $0e, $00, $10, $11, $ff, $00, $c6, $00

BG_JOYTEST_NAM_1:
; Tamaño descomprimido:
db $01, $00
; Tamaño comprimido (RLE):
db $00, $42
; Datos:
db $c8, $00, $01, $02, $cc, $00, $01, $02
db $d0, $00, $03, $04, $cc, $00, $03, $04
db $ed, $00, $05, $06, $c4, $00, $07, $08
db $c6, $00, $05, $06, $c4, $00, $07, $08
db $ca, $00, $09, $0a, $c4, $00, $0b, $0c
db $c6, $00, $09, $0a, $c4, $00, $0b, $0c
db $ed, $00, $0d, $0e, $cc, $00, $0d, $0e
db $d0, $00, $0f, $10, $cc, $00, $0f, $10
db $c8, $00

BG_JOYTEST_NAM_2:
; Tamaño descomprimido:
db $01, $00
; Tamaño comprimido (RLE):
db $00, $28
; Datos:
db $ff, $00, $c7, $00, $01, $02, $c2, $00
db $01, $02, $c8, $00, $01, $02, $c2, $00
db $01, $02, $cc, $00, $03, $04, $c2, $00
db $03, $04, $c8, $00, $03, $04, $c2, $00
db $03, $04, $ff, $00, $ff, $00, $c8, $00
