li a0 LED_MATRIX_0_BASE
li a1 LED_MATRIX_0_WIDTH
li a2 LED_MATRIX_0_HEIGHT
li a3 D_PAD_0_BASE
li a4 0xffffff
li a5 5         # tamano pala
li a6 0x000000  # color negro
li s0 1         # posicion pala izquierda
li s1 0         # posicion pala derecha
li s5 1         # dx
li s6 -1        # dy

loop_juego:
    jal posiciones_iniciales
    jal dibuja_pala

posiciones_iniciales:
    mul t0, a1, a2
    slli s3, t0, 1
    ret

actualiza_pala:
    # verifica si boton de arriba se presiona
    lw t1, 0(a3)
    andi t1, t1, 1
    beqz t1, boton_abajo
    
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
    beqz t1, boton_izquierda
    
    # boton de abajo presionado
    addi t2, s0, 0
    sub t3, a2, a5
    bge t2, t3, boton_izquierda   # verifica limite inferior

    add t0, zero, a0    # direccion base
    li t2, 4            # byte
    mul t3, a1, t2      # bytes por fila
    
    mul t4, s0, t3      # offset actual
    add t0, t0, t4      # agrega offset

    sw a6, 0(t0)        # color

    addi s0, s0, 1

boton_izquierda:
    # verifica boton de abajo presionado
    lw t1, 8(a3)
    andi t1, t1, 1
    beqz t1, boton_derecha
    
    # boton de abajo presionado
    addi t2, s1, 0
    sub t3, a2, a5
    bge t2, t3, boton_derecha   # verifica limite inferior

    add t0, zero, a0    # direccion base
    li t2, 4            # byte
    mul t3, a1, t2      # bytes por fila
    
    mul t4, s1, t3      # offset actual
    sub t4, t4, t2
    add t0, t0, t4      # agrega offset

    sw a6, 0(t0)        # color

    addi s1, s1, -1

boton_derecha:
    # verifica boton de abajo presionado
    lw t1, 0xc(a3)
    andi t1, t1, 1
    beqz t1, dibuja_pala
    
    # boton de abajo presionado
    addi t2, s0, 0
    sub t3, a2, a5
    bge t2, t3, dibuja_pala   # verifica limite inferior

    add t0, zero, a0    # direccion base
    li t2, 4            # byte
    mul t3, a1, t2      # bytes por fila
    
    mul t4, s1, t3      # offset actual pala izquierda
    sub t4, t4, t2      #
    add t0, t0, t4      # agrega offset

    sw a6, 0(t0)        # color

    addi s1, s1, 1


dibuja_pala:
    add t0, zero, a0    # direccion base
    add t5, zero, a0
    li t1, 1            # contador
    li t2, 4            # byte
    mul t3, a1, t2      # bytes por fila
    
    mul t4, s0, t3      # offset actual pala izquierda
    mul t6, s1, t3      # offset actual pala derecha
    sub t6, t6, t2

    add t0, t0, t4      # agrega offset
    add t5, t5, t6

    sw a4, 0(t0)        # color
    sw a4, 0(t5)
    
dibuja_pala_loop:
    add t0, t0, t3      # direccion pixel siguiente fila 
    add t5, t5, t3
    addi t1, t1, 1      # incrementa counter
    sw a4, 0(t0)        # color 
    sw a4, 0(t5)        # color 
    bne t1, a5, dibuja_pala_loop
    beq t1, a5, actualiza_pala

