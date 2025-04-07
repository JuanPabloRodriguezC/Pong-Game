li a0 LED_MATRIX_0_BASE
li a1 LED_MATRIX_0_WIDTH
li a2 LED_MATRIX_0_HEIGHT
li a3 D_PAD_0_BASE
li a4 0xffffff
li a5 0x000005

colorea_paleta:
    add t0, zero, a1
    li t1, 4
    mul t2, t0, t1
    
    add t3, a0, t2
    sw a4, 0(t3)
    addi t4, t4, 1
    
colorea_paleta_loop:
    add t3, t3, t2
    sw a4, 0(t3)
    addi t4, t4, 1
    bne t4, a5, colorea_paleta_loop