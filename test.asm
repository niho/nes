; Test NES program that outputs some audio.

.segment "HEADER"
    .byte "NES" ; signature
    .byte $1A   ; signature
    .byte $01   ; # of 16kb PRG-ROM banks
    .byte $00   ; # of 8kb VROM banks
    .byte $00   ; ROM control byte one
    .byte $00   ; ROM control byte two
    .byte $00   ; # of 8kb RAM banks
    .byte $00   ; reserved


.segment "VECTORS"
    .addr NMI
    .addr RESET
    .addr IRQ

.segment "CHARS"

.code

RESET:
    lda #$01
    sta $4015
    lda #$08
    sta $4002
    lda #$02
    sta $4003
    lda #$bf
    sta $4000
FOREVER:
    jmp FOREVER

NMI:
    rti

IRQ:
    rti
