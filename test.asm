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
    sei         ; ignore IRQs
    cld         ; disable decimal mode
    ldx #$40
    stx $4017   ; disable APU frame IRQ
    ldx #$ff
    txs         ; setup stack
    inx         ; now X = 0
    stx $2000   ; disable NMI
    stx $2001   ; disable rendering
    stx $4010   ; disable DMC IRQs

    ; Clear the vblank flag
    bit $2002

    ; Wait for vblank to make sure PPU stabilizes
@vblankwait1:
    bit $2002
    bpl @vblankwait1

    ; Fill RAM with $00 while waiting for vblank
@clrmem:
    sta $000,x
    sta $100,x
    sta $200,x
    sta $300,x
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    inx
    bne @clrmem

    ; Wait for vblank a second time
@vblankwait2:
    bit $2002
    bpl @vblankwait2

    ; Produce a sound using the APU
sound:
    lda #$03
    sta $4015   ; enable square wave 1 & 2
    
    lda #$08
    sta $4002   ; set low byte of square wave 1
    lda #$02
    sta $4003   ; set high byte of square wave 1
    lda #$bf
    sta $4000   ; set volume for square wave 1

    lda #$01
    sta $4006   ; set low byte of square wave 2
    lda #$02
    sta $4007   ; set high byte of square wave 2
    lda #$bf
    sta $4004   ; set volume for square wave 2

    ; Loop forever
forever:
    jmp forever

NMI:
    rti

IRQ:
    rti
