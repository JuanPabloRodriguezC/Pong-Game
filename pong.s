li a0 LED_MATRIX_0_BASE
li a1 LED_MATRIX_0_WIDTH
li a2 LED_MATRIX_0_HEIGHT
li a3 D_PAD_0_BASE
li a4 0xffffff
li a5 5         # tamano pala
li a6 0x000000  # color negro
li s0 0         # x-pala izquierda
li s1 0         # y-pala izquierda
add s2, a1, 0   # x-pala derecha
li s3, 0        # y-pala derecha
li s6 1         # dx
li s7 -1        # dy

loop_juego:
    jal posiciones_iniciales
    jal dibuja_bola
    jal dibuja_pala

posiciones_iniciales:
    srli s4, a1, 1  # x
    srli s5, a2, 1  # y
    ret

actualiza_pala:
    li t4, 4            # byte
    mul t2, a1, t4      # bytes por fila

    # verifica si boton de arriba se presiona
    lw t1, 0(a3)
    andi t1, t1, 1
    beqz t1, boton_abajo
    
    # boton de arriba presionado
    beqz s0, boton_abajo    # verifica limite superior
    
    
    mul t3, s0, t2      # offset actual
    add t0, a0, t3      # agrega offset a direcion base

    sw a6, 0(t0)        # color

    addi s0, s0, -1

boton_abajo:
    # verifica boton de abajo presionado
    lw t1, 4(a3)
    andi t1, t1, 1
    beqz t1, boton_izquierda
    
    # boton de abajo presionado
    sub t3, a2, a5
    bge s0, t3, boton_izquierda   # verifica limite inferior
    
    mul t3, s0, t2      # offset actual
    add t0, a0, t3      # agrega offset

    sw a6, 0(t0)        # color

    addi s0, s0, 1

boton_izquierda:
    # verifica boton de arriba presionado
    lw t1, 8(a3)
    andi t1, t1, 1
    beqz t1, boton_derecha
    
    # boton de arriba presionado
    bqez s1, boton_derecha   # verifica limite inferior

    mul t3, s1, t2      # offset actual
    sub t3, t3, t4      # un byte atras
    add t0, a0, t3      # agrega offset

    sw a6, 0(t0)        # color

    addi s1, s1, -1

boton_derecha:
    # verifica boton de abajo presionado
    lw t1, 0xc(a3)
    andi t1, t1, 1
    beqz t1, dibuja_pala
    
    # boton de abajo presionado
    sub t3, a2, a5
    bge s1, t3, dibuja_pala   # verifica limite inferior

    mul t3, s1, t2      # offset actual pala izquierda
    sub t3, t3, t4      #
    add t0, a0, t3      # agrega offset a la base de direccion

    sw a6, 0(t0)        # color

    addi s1, s1, 1


dibuja_pala:
    li t1, 1            # contador
    li t2, 4            # byte
    mul t3, a1, t2      # bytes por fila
    
    mul t4, s0, t3      # offset actual pala izquierda
    mul t6, s1, t3      # offset actual pala derecha
    sub t6, t6, t2      
    add t0, a0, t4      # agrega offset
    add t5, a0, t6

    sw a4, 0(t0)        # color
    sw a4, 0(t5)
    
dibuja_pala_loop:
    add t0, t0, t3      # direccion pixel siguiente fila 
    add t5, t5, t3
    addi t1, t1, 1      # incrementa counter
    sw a4, 0(t0)        # color 
    sw a4, 0(t5)        # color 
    bne t1, a5, dibuja_pala_loop
    beq t1, a5, borra_bola

borra_bola:
    jal selecciona_bola
    sw a6, 0(t0)
    jal actualiza_bola
    
actualiza_bola:
    add s2, s2, s4
    add s3, s3, s5

dibuja_bola:
    jal selecciona_bola
    sw a4, 0(t0)
    jal actualiza_pala

selecciona_pixel:
    li t2, 4
    mul t0, a1, s3      # pixels before the ball's row
    mul t0, t0, t2      # bytes
    mul t1, s2, t2      # pixels of the ball's column
    add t0, t0, a0      # add base address
    add t0, t0, t1      # add column offset

    ret

