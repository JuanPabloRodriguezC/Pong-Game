li a0 LED_MATRIX_0_BASE
li a1 LED_MATRIX_0_WIDTH
li a2 LED_MATRIX_0_HEIGHT
li a3 D_PAD_0_BASE
li a4 0xffffff
li a5 5
li a6 0
li s0 1
li s1 0

loop_juego:
    jal dibuja_pala

actualiza_pala:
    # verifica si boton de arriba se presiona
    lw t1, 0(a3)
    andi t1, t1, 1
    beqz t1, check_down_button
    
    # boton de arriba presionado
    addi t2, s0, 0
    beqz t2, boton_abajo    # verifica limite superior

    add t0, zero, a0    # direccion base
    li t2, 4            # byte
    mul t3, a1, t2      # bytes por fila
    
    addi t1, s0, 4
    mul t4, t1, t3      # offset actual
    add t0, t0, t4      # agrega offset

    sw a6, 0(t0)        # color

    addi s0, s0, -1

boton_abajo:
    # verifica boton de abajo presionado
    lw t1, 4(a3)
    andi t1, t1, 1
    beqz t1, dibuja_pala
    
    # boton de abajo presionado
    addi t2, s0, 0
    sub t3, a2, a5
    bge t2, t3, dibuja_pala   # verifica limite inferior

    add t0, zero, a0    # direccion base
    li t2, 4            # byte
    mul t3, a1, t2      # bytes por fila
    
    mul t4, s0, t3      # offset actual
    add t0, t0, t4      # agrega offset

    sw a6, 0(t0)        # color

    addi s0, s0, 1

    
    
dibuja_pala:
    add t0, zero, a0    # direccion base
    li t1, 1            # contador
    li t2, 4            # byte
    mul t3, a1, t2      # bytes por fila
    
    mul t4, s0, t3      # offset actual
    add t0, t0, t4      # agrega offset

    sw a4, 0(t0)        # color
    
dibuja_pala_loop:
    add t0, t0, t3      # direccion pixel siguiente fila 
    addi t1, t1, 1      # incrementa counter
    sw a4, 0(t0)        # color 
    bne t1, a5, dibuja_pala_loop
    beq t1, a5, actualiza_pala

