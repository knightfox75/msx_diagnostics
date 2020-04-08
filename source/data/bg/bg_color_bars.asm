;************************************************************
;*    Imagen convertida para MSX - SCREEN 2
;*    Archivo de origen: bg_color_bars.bmp
;*    Tamaño: 256x192 pixeles
;*    Compresion RLE habilitada
;*    Total de datos: 1158 bytes
;************************************************************


BG_COLOR_BARS_IMAGE:

; Datos CHR
; Banco 0: 035 bloques de CHR
;          Tamaño descomprimido: 280 bytes [$0118 bytes]
;          Tamaño RLE: 31 bytes [$001f bytes]
; Banco 1: 018 bloques de CHR
;          Tamaño descomprimido: 144 bytes [$0090 bytes]
;          Tamaño RLE: 16 bytes [$0010 bytes]
; Banco 2: 036 bloques de CHR
;          Tamaño descomprimido: 288 bytes [$0120 bytes]
;          Tamaño RLE: 33 bytes [$0021 bytes]

BG_COLOR_BARS_CHR_0:
; Tamaño descomprimido:
db $01, $18
; Tamaño comprimido (RLE):
db $00, $1f
; Datos:
db $00, $7f, $40, $7f, $40, $7f, $40, $7f
db $ff, $00, $ff, $00, $c3, $00, $01, $c6
db $02, $40, $7f, $40, $7f, $40, $7f, $40
db $7f, $ff, $00, $f9, $00, $c8, $02

BG_COLOR_BARS_CHR_1:
; Tamaño descomprimido:
db $00, $90
; Tamaño comprimido (RLE):
db $00, $10
; Datos:
db $40, $7f, $40, $7f, $40, $7f, $40, $7f
db $ff, $00, $ff, $00, $c2, $00, $c8, $02

BG_COLOR_BARS_CHR_2:
; Tamaño descomprimido:
db $01, $20
; Tamaño comprimido (RLE):
db $00, $21
; Datos:
db $40, $7f, $40, $7f, $40, $7f, $40, $7f
db $ff, $00, $ff, $00, $c2, $00, $c8, $02
db $40, $7f, $40, $7f, $40, $c2, $7f, $ff
db $00, $ff, $00, $c3, $00, $c6, $02, $01
db $00


; Datos CLR
; Banco 0: 035 bloques de CLR
;          Tamaño descomprimido: 280 bytes [$0118 bytes]
;          Tamaño RLE: 126 bytes [$007e bytes]
; Banco 1: 018 bloques de CLR
;          Tamaño descomprimido: 144 bytes [$0090 bytes]
;          Tamaño RLE: 45 bytes [$002d bytes]
; Banco 2: 036 bloques de CLR
;          Tamaño descomprimido: 288 bytes [$0120 bytes]
;          Tamaño RLE: 135 bytes [$0087 bytes]

BG_COLOR_BARS_CLR_0:
; Tamaño descomprimido:
db $01, $18
; Tamaño comprimido (RLE):
db $00, $7e
; Datos:
db $c1, $ff, $c7, $1f, $c1, $ff, $11, $c1
db $ff, $11, $c1, $ff, $11, $c1, $ff, $11
db $c1, $ff, $c7, $11, $c1, $ff, $11, $c6
db $22, $c1, $ff, $11, $c6, $33, $c1, $ff
db $11, $c6, $44, $c1, $ff, $11, $c6, $55
db $c1, $ff, $11, $c6, $66, $c1, $ff, $11
db $c6, $77, $c1, $ff, $11, $c6, $88, $c1
db $ff, $11, $c6, $99, $c1, $ff, $11, $c6
db $aa, $c1, $ff, $11, $c6, $bb, $c1, $ff
db $11, $c6, $cc, $c1, $ff, $11, $c6, $dd
db $c1, $ff, $11, $c6, $ee, $c1, $ff, $11
db $c7, $ff, $c1, $f1, $ce, $1f, $c8, $11
db $c8, $22, $c8, $33, $c8, $44, $c8, $55
db $c8, $66, $c8, $77, $c8, $88, $c8, $99
db $c8, $aa, $c8, $bb, $c8, $cc, $c8, $dd
db $c8, $ee, $c8, $ff, $c8, $1f

BG_COLOR_BARS_CLR_1:
; Tamaño descomprimido:
db $00, $90
; Tamaño comprimido (RLE):
db $00, $2d
; Datos:
db $c8, $1f, $c1, $ff, $11, $c1, $ff, $11
db $c1, $ff, $11, $c1, $ff, $c9, $11, $c8
db $22, $c8, $33, $c8, $44, $c8, $55, $c8
db $66, $c8, $77, $c8, $88, $c8, $99, $c8
db $aa, $c8, $bb, $c8, $cc, $c8, $dd, $c8
db $ee, $c8, $ff, $c8, $1f

BG_COLOR_BARS_CLR_2:
; Tamaño descomprimido:
db $01, $20
; Tamaño comprimido (RLE):
db $00, $87
; Datos:
db $c8, $1f, $c1, $ff, $11, $c1, $ff, $11
db $c1, $ff, $11, $c1, $ff, $c9, $11, $c8
db $22, $c8, $33, $c8, $44, $c8, $55, $c8
db $66, $c8, $77, $c8, $88, $c8, $99, $c8
db $aa, $c8, $bb, $c8, $cc, $c8, $dd, $c8
db $ee, $c8, $ff, $cf, $1f, $c2, $ff, $11
db $c1, $ff, $11, $c1, $ff, $c2, $11, $c1
db $ff, $c7, $11, $c1, $ff, $c6, $22, $11
db $c1, $ff, $c6, $33, $11, $c1, $ff, $c6
db $44, $11, $c1, $ff, $c6, $55, $11, $c1
db $ff, $c6, $66, $11, $c1, $ff, $c6, $77
db $11, $c1, $ff, $c6, $88, $11, $c1, $ff
db $c6, $99, $11, $c1, $ff, $c6, $aa, $11
db $c1, $ff, $c6, $bb, $11, $c1, $ff, $c6
db $cc, $11, $c1, $ff, $c6, $dd, $11, $c1
db $ff, $c6, $ee, $11, $c7, $ff, $11, $c1
db $ff, $c6, $1f, $c1, $f1, $c1, $ff


; Datos NAME
; Banco 0: 256 bloques de NAME
;          Tamaño descomprimido: 256 bytes [$0100 bytes]
;          Tamaño RLE: 256 bytes [$0100 bytes]
; Banco 1: 256 bloques de NAME
;          Tamaño descomprimido: 256 bytes [$0100 bytes]
;          Tamaño RLE: 256 bytes [$0100 bytes]
; Banco 2: 256 bloques de NAME
;          Tamaño descomprimido: 256 bytes [$0100 bytes]
;          Tamaño RLE: 256 bytes [$0100 bytes]

BG_COLOR_BARS_NAM_0:
; Tamaño descomprimido:
db $01, $00
; Tamaño comprimido (RLE):
db $01, $00
; Datos:
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $12, $01, $c2, $13, $c2, $14, $c2, $15
db $c2, $16, $c2, $17, $c2, $18, $c2, $19
db $c2, $1a, $c2, $1b, $c2, $1c, $c2, $1d
db $c2, $1e, $c2, $1f, $c2, $20, $21, $22
db $12, $01, $c2, $13, $c2, $14, $c2, $15
db $c2, $16, $c2, $17, $c2, $18, $c2, $19
db $c2, $1a, $c2, $1b, $c2, $1c, $c2, $1d
db $c2, $1e, $c2, $1f, $c2, $20, $21, $22
db $12, $01, $c2, $13, $c2, $14, $c2, $15
db $c2, $16, $c2, $17, $c2, $18, $c2, $19
db $c2, $1a, $c2, $1b, $c2, $1c, $c2, $1d
db $c2, $1e, $c2, $1f, $c2, $20, $21, $22
db $12, $01, $c2, $13, $c2, $14, $c2, $15
db $c2, $16, $c2, $17, $c2, $18, $c2, $19
db $c2, $1a, $c2, $1b, $c2, $1c, $c2, $1d
db $c2, $1e, $c2, $1f, $c2, $20, $21, $22
db $12, $01, $c2, $13, $c2, $14, $c2, $15
db $c2, $16, $c2, $17, $c2, $18, $c2, $19
db $c2, $1a, $c2, $1b, $c2, $1c, $c2, $1d
db $c2, $1e, $c2, $1f, $c2, $20, $21, $22
db $12, $01, $c2, $13, $c2, $14, $c2, $15
db $c2, $16, $c2, $17, $c2, $18, $c2, $19
db $c2, $1a, $c2, $1b, $c2, $1c, $c2, $1d
db $c2, $1e, $c2, $1f, $c2, $20, $21, $22
db $12, $01, $c2, $13, $c2, $14, $c2, $15
db $c2, $16, $c2, $17, $c2, $18, $c2, $19
db $c2, $1a, $c2, $1b, $c2, $1c, $c2, $1d
db $c2, $1e, $c2, $1f, $c2, $20, $21, $22

BG_COLOR_BARS_NAM_1:
; Tamaño descomprimido:
db $01, $00
; Tamaño comprimido (RLE):
db $01, $00
; Datos:
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11

BG_COLOR_BARS_NAM_2:
; Tamaño descomprimido:
db $01, $00
; Tamaño comprimido (RLE):
db $01, $00
; Datos:
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $00, $01, $c2, $02, $c2, $03, $c2, $04
db $c2, $05, $c2, $06, $c2, $07, $c2, $08
db $c2, $09, $c2, $0a, $c2, $0b, $c2, $0c
db $c2, $0d, $c2, $0e, $c2, $0f, $10, $11
db $12, $13, $c2, $14, $c2, $15, $c2, $16
db $c2, $17, $c2, $18, $c2, $19, $c2, $1a
db $c2, $1b, $c2, $1c, $c2, $1d, $c2, $1e
db $c2, $1f, $c2, $20, $c2, $21, $22, $23
