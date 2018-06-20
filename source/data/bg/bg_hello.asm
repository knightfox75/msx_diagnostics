;************************************************************
;*    Imagen convertida para MSX - SCREEN 2
;*    Archivo de origen: bg_hello.bmp
;*    Tamaño: 256x192 pixeles
;*    Compresion RLE habilitada
;*    Total de datos: 1003 bytes
;************************************************************


BG_HELLO_IMAGE:

; Datos CHR
; Banco 0: 038 bloques de CHR
;          Tamaño descomprimido: 304 bytes [$0130 bytes]
;          Tamaño RLE: 90 bytes [$005a bytes]
; Banco 1: 021 bloques de CHR
;          Tamaño descomprimido: 168 bytes [$00a8 bytes]
;          Tamaño RLE: 60 bytes [$003c bytes]
; Banco 2: 057 bloques de CHR
;          Tamaño descomprimido: 456 bytes [$01c8 bytes]
;          Tamaño RLE: 126 bytes [$007e bytes]

BG_HELLO_CHR_0:
; Tamaño descomprimido:
db $01, $30
; Tamaño comprimido (RLE):
db $00, $5a
; Datos:
db $d3, $00, $c5, $07, $d3, $00, $c5, $1f
db $c6, $00, $c2, $1f, $c6, $07, $ca, $00
db $c6, $1f, $c8, $00, $c2, $07, $c8, $1f
db $d0, $07, $c8, $1f, $d0, $07, $c8, $1f
db $c8, $00, $c6, $1f, $c8, $00, $c2, $07
db $cb, $1f, $c8, $00, $c5, $07, $ce, $00
db $c2, $1f, $c6, $07, $c2, $00, $c6, $1f
db $c8, $00, $c8, $07, $c2, $00, $c3, $07
db $c5, $00, $c8, $1f, $c3, $07, $c5, $00
db $c3, $1f, $c5, $00, $c3, $07, $c5, $00
db $c3, $1f, $c5, $00, $c8, $07, $c3, $1f
db $c5, $00

BG_HELLO_CHR_1:
; Tamaño descomprimido:
db $00, $a8
; Tamaño comprimido (RLE):
db $00, $3c
; Datos:
db $c8, $00, $c6, $1f, $c8, $00, $c2, $07
db $ce, $00, $c2, $1f, $c6, $07, $c2, $00
db $c8, $07, $c8, $00, $c8, $1f, $cd, $00
db $c3, $07, $c8, $1f, $c5, $07, $c3, $03
db $c8, $07, $c3, $00, $c5, $1f, $c3, $03
db $c5, $00, $c8, $07, $c6, $1f, $c2, $00
db $c3, $1f, $c5, $00, $c3, $07, $c5, $00
db $c6, $07, $c2, $00

BG_HELLO_CHR_2:
; Tamaño descomprimido:
db $01, $c8
; Tamaño comprimido (RLE):
db $00, $7e
; Datos:
db $cb, $00, $c5, $07, $cb, $00, $c5, $1f
db $c3, $00, $c5, $07, $c3, $00, $c5, $1f
db $c8, $07, $c6, $00, $c2, $1f, $c6, $00
db $c2, $07, $d0, $1f, $c6, $00, $c2, $07
db $c6, $00, $c2, $1f, $c8, $07, $c8, $1f
db $c8, $07, $c8, $1f, $ce, $00, $c2, $1f
db $d0, $07, $c6, $00, $c2, $1f, $c6, $00
db $c2, $07, $d0, $1f, $c8, $07, $c8, $1f
db $d0, $07, $c3, $1f, $c8, $00, $c5, $07
db $d0, $1f, $c8, $07, $e0, $00, $c8, $07
db $c8, $00, $ce, $1f, $ca, $00, $c8, $07
db $c6, $1f, $c2, $00, $c6, $07, $c2, $00
db $c8, $1f, $c8, $00, $c6, $07, $c2, $00
db $c8, $07, $c8, $00, $c8, $1f, $c3, $07
db $cd, $00, $c3, $1f, $c5, $00, $c3, $07
db $c5, $00, $c3, $1f, $c5, $00


; Datos CLR
; Banco 0: 038 bloques de CLR
;          Tamaño descomprimido: 304 bytes [$0130 bytes]
;          Tamaño RLE: 122 bytes [$007a bytes]
; Banco 1: 021 bloques de CLR
;          Tamaño descomprimido: 168 bytes [$00a8 bytes]
;          Tamaño RLE: 72 bytes [$0048 bytes]
; Banco 2: 057 bloques de CLR
;          Tamaño descomprimido: 456 bytes [$01c8 bytes]
;          Tamaño RLE: 182 bytes [$00b6 bytes]

BG_HELLO_CLR_0:
; Tamaño descomprimido:
db $01, $30
; Tamaño comprimido (RLE):
db $00, $7a
; Datos:
db $ce, $ee, $c2, $11, $c3, $ee, $c5, $1e
db $c3, $ee, $c8, $11, $c5, $ff, $c3, $ee
db $c5, $e1, $c6, $ee, $c2, $1e, $c6, $f1
db $ca, $ff, $c6, $1f, $c2, $ff, $c6, $ee
db $c2, $e1, $c8, $1e, $c8, $e1, $c8, $1e
db $c8, $f1, $c8, $1f, $c8, $f1, $c8, $1f
db $c6, $11, $c2, $ff, $c6, $f1, $c2, $ff
db $c6, $11, $c2, $1f, $c8, $e1, $c3, $f1
db $c5, $11, $c3, $ff, $c5, $f1, $c6, $ff
db $c2, $11, $c6, $ff, $c8, $f1, $c2, $11
db $c6, $f1, $c2, $11, $c6, $ff, $c2, $f1
db $c6, $1f, $c2, $11, $c3, $1e, $c5, $ee
db $c3, $f1, $c5, $1e, $c3, $1f, $c5, $ff
db $c3, $f1, $c5, $ff, $c3, $f1, $c5, $ff
db $c3, $1f, $c5, $ff, $c3, $1f, $c8, $e1
db $c5, $ee

BG_HELLO_CLR_1:
; Tamaño descomprimido:
db $00, $a8
; Tamaño comprimido (RLE):
db $00, $48
; Datos:
db $c8, $ee, $c6, $1e, $c2, $ee, $c6, $ff
db $c2, $f1, $ce, $ff, $c2, $1f, $c6, $e1
db $c2, $ee, $c3, $f1, $c5, $1e, $c3, $ff
db $c5, $11, $c3, $1f, $c5, $e1, $c5, $11
db $c3, $ee, $c5, $11, $c3, $1e, $c8, $f1
db $c5, $1f, $c3, $e1, $c8, $1e, $c3, $ff
db $c5, $1f, $c3, $e1, $c5, $ee, $c6, $1f
db $c8, $e1, $c2, $ee, $c3, $f1, $c5, $11
db $c3, $e1, $c5, $ee, $c6, $1e, $c2, $ee

BG_HELLO_CLR_2:
; Tamaño descomprimido:
db $01, $c8
; Tamaño comprimido (RLE):
db $00, $b6
; Datos:
db $cb, $ee, $c5, $1e, $c3, $ee, $c5, $11
db $c3, $ee, $c5, $e1, $c3, $ee, $c5, $e1
db $c3, $ee, $c5, $1e, $c8, $61, $c6, $66
db $c2, $f6, $c6, $66, $c2, $6f, $c8, $16
db $c8, $1e, $c6, $cc, $c2, $fc, $c6, $cc
db $c2, $1f, $c8, $1c, $c8, $e1, $c8, $1e
db $c8, $51, $c6, $55, $c2, $ff, $c6, $55
db $c2, $5f, $c8, $e1, $c8, $a1, $c6, $aa
db $c2, $1a, $c6, $aa, $c2, $af, $c8, $1a
db $c8, $f6, $c3, $6f, $c5, $61, $c3, $f6
db $c5, $16, $c8, $6f, $c8, $fc, $c3, $1f
db $c8, $ff, $c5, $f1, $c8, $5f, $c3, $1a
db $c5, $fa, $c8, $af, $c8, $66, $c8, $cc
db $c8, $55, $c8, $aa, $c6, $61, $c2, $1e
db $c6, $66, $c2, $11, $c6, $16, $c2, $e1
db $c6, $1e, $c2, $ee, $c6, $cc, $c2, $11
db $c6, $1c, $c8, $e1, $c2, $ee, $c6, $1e
db $c2, $ee, $c6, $51, $c2, $1e, $c6, $55
db $c2, $11, $c6, $e1, $c2, $ee, $c6, $a1
db $c2, $1e, $c6, $aa, $c2, $11, $c6, $1a
db $c2, $e1, $c3, $1e, $c5, $ee, $c3, $11
db $c5, $ee, $c3, $e1, $c5, $ee, $c3, $e1
db $c5, $ee, $c3, $1e, $c5, $ee


; Datos NAME
; Banco 0: 256 bloques de NAME
;          Tamaño descomprimido: 256 bytes [$0100 bytes]
;          Tamaño RLE: 124 bytes [$007c bytes]
; Banco 1: 256 bloques de NAME
;          Tamaño descomprimido: 256 bytes [$0100 bytes]
;          Tamaño RLE: 51 bytes [$0033 bytes]
; Banco 2: 256 bloques de NAME
;          Tamaño descomprimido: 256 bytes [$0100 bytes]
;          Tamaño RLE: 172 bytes [$00ac bytes]

BG_HELLO_NAM_0:
; Tamaño descomprimido:
db $01, $00
; Tamaño comprimido (RLE):
db $00, $7c
; Datos:
db $ca, $00, $ce, $01, $d0, $00, $02, $03
db $ce, $04, $03, $05, $cd, $00, $06, $07
db $d0, $08, $09, $0a, $cc, $00, $0b, $d2
db $08, $0c, $cb, $00, $0d, $0e, $c2, $08
db $0f, $0e, $10, $11, $12, $13, $10, $08
db $0f, $0e, $08, $11, $14, $0e, $c2, $08
db $0f, $15, $ca, $00, $0d, $0e, $c2, $08
db $0f, $16, $10, $11, $17, $08, $10, $08
db $0f, $0e, $08, $11, $0f, $0e, $c2, $08
db $0f, $15, $ca, $00, $0d, $0e, $c2, $08
db $0f, $0e, $10, $11, $18, $19, $1a, $18
db $0f, $1b, $1c, $11, $1d, $0e, $c2, $08
db $0f, $15, $ca, $00, $1e, $1f, $c2, $08
db $20, $21, $22, $23, $04, $21, $c2, $04
db $20, $04, $22, $23, $04, $21, $c2, $08
db $24, $25, $c4, $00

BG_HELLO_NAM_1:
; Tamaño descomprimido:
db $01, $00
; Tamaño comprimido (RLE):
db $00, $33
; Datos:
db $c7, $00, $01, $02, $d0, $03, $04, $05
db $cd, $00, $06, $07, $ce, $03, $07, $08
db $d0, $00, $c4, $09, $0a, $0b, $c2, $03
db $0c, $c5, $09, $d6, $00, $0d, $0b, $03
db $0e, $0f, $db, $00, $0d, $0b, $10, $11
db $dc, $00, $0d, $12, $13, $dd, $00, $14
db $11, $f0, $00

BG_HELLO_NAM_2:
; Tamaño descomprimido:
db $01, $00
; Tamaño comprimido (RLE):
db $00, $ac
; Datos:
db $e2, $00, $01, $c4, $02, $03, $c2, $00
db $c4, $02, $04, $c2, $00, $05, $c4, $02
db $c2, $00, $01, $c4, $02, $03, $c4, $00
db $06, $07, $08, $07, $08, $09, $00, $0a
db $0b, $0c, $0b, $0c, $0d, $0e, $0f, $10
db $11, $12, $11, $12, $13, $00, $14, $15
db $16, $15, $16, $17, $c4, $00, $06, $18
db $19, $1a, $1b, $09, $00, $0a, $1c, $1d
db $1c, $1d, $0d, $0e, $0f, $10, $1e, $1f
db $1e, $1f, $13, $00, $14, $20, $21, $20
db $21, $17, $c4, $00, $06, $c4, $22, $09
db $00, $0a, $c4, $23, $0d, $0e, $0f, $10
db $c4, $24, $13, $00, $14, $c4, $25, $17
db $c4, $00, $06, $c4, $22, $09, $00, $0a
db $c4, $23, $0d, $0e, $0f, $10, $c4, $24
db $13, $00, $14, $c4, $25, $17, $c4, $00
db $26, $c4, $27, $28, $00, $29, $c4, $2a
db $2b, $2c, $2d, $2e, $c4, $2f, $30, $00
db $31, $c4, $32, $33, $c4, $00, $34, $c4
db $35, $36, $c2, $00, $c4, $35, $37, $c2
db $00, $38, $c4, $35, $c2, $00, $34, $c4
db $35, $36, $c2, $00
