# Variables guardadas
li s0 LED_MATRIX_0_BASE
li s1 LED_MATRIX_0_WIDTH
li s2 LED_MATRIX_0_HEIGHT
li s3 D_PAD_0_BASE
li s6 0                             # x-pala izquierda
li s7 0                             # y-pala izquierda
addi s8, s1, -1                     # x-pala derecha
li s9, 0                            # y-pala derecha
li s10 1                            # dx
li s11 -1                            # dy
li a7 5

loop_juego:
    jal variables_iniciales
    jal dibuja_bola
    jal dibuja_pala

variables_iniciales:
    #posicion inicial bola
    srli s4, s1, 1  # x
    srli s5, s2, 1  # y

    # constantes
    li t4, 4            # byte
    mul t2, s1, t4      # bytes por fila
    li a3, 0            # puntaje izquierda
    li a4, 0            # puntaje derecha
    li a5, 0xc2fc03     # color blanco
    li a6, 0x000000     # color negro

    ret

actualiza_pala:
    # verifica si boton de arriba se presiona
    lw t1, 0(s3)
    andi t1, t1, 1
    beqz t1, boton_abajo
    
    # boton de arriba presionado
    beqz s7, boton_abajo    # verifica limite superior

    add a0, zero, s6
    add a1, a7, s7
    addi a1, a1, -1
    jal selecciona_pixel

    sw a6, 0(t0)        # color

    addi s7, s7, -1

boton_abajo:
    # verifica boton de abajo presionado
    lw t1, 4(s3)
    andi t1, t1, 1
    beqz t1, boton_izquierda
    
    # boton de abajo presionado
    sub t3, s2, a7
    bge s7, t3, dibuja_pala   # verifica limite inferior

    add a0, zero, s6
    add a1, zero, s7
    jal selecciona_pixel
    
    sw a6, 0(t0)        # color

    addi s7, s7, 1

boton_izquierda:
    # verifica boton de arriba presionado
    lw t1, 8(s3)
    andi t1, t1, 1
    beqz t1, boton_derecha
    
    # boton de arriba presionado
    beqz s1, boton_derecha   # verifica limite inferior

    add a0, zero, s8
    add a1, a7, s9
    addi a1, a1, -1
    jal selecciona_pixel

    sw a6, 0(t0)        # color

    addi s9, s9, -1

boton_derecha:
    # verifica boton de abajo presionado
    lw t1, 0xc(s3)
    andi t1, t1, 1
    beqz t1, dibuja_pala
    
    # boton de abajo presionado
    sub t3, s2, a7
    bge s9, t3, dibuja_pala   # verifica limite inferior

    add a0, zero, s8
    add a1, zero, s9
    jal selecciona_pixel

    sw a6, 0(t0)        # color

    addi s9, s9, 1


dibuja_pala:
    li t3, 1            # contador

    add a0, zero, s8
    add a1, zero, s9
    jal selecciona_pixel
    add t5, zero, t0

    add a0, zero, s6
    add a1, zero, s7
    jal selecciona_pixel

    sw a5, 0(t5)
    sw a5, 0(t0)        # color
    
dibuja_pala_loop:
    add t0, t0, t2      # direccion pixel siguiente fila 
    add t5, t5, t2
    addi t3, t3, 1      # incrementa counter
    sw a5, 0(t0)        # color 
    sw a5, 0(t5)        # color 
    bne t3, a7, dibuja_pala_loop
    beq t3, a7, borra_bola

borra_bola:
    add a0, zero, s4
    add a1, zero, s5
    jal selecciona_pixel
    sw a6, 0(t0)
    jal actualiza_bola
    
actualiza_bola:
    add s4, s4, s10
    add s5, s5, s11

dibuja_bola:
    add a0, zero, s4
    add a1, zero, s5
    jal selecciona_pixel
    sw a5, 0(t0)
    jal verifica_colision_vertical

selecciona_pixel:
    mul t0, t4, a0
    mul t1, t2, a1
    add t0, t0, t1
    add t0, t0, s0
    ret

verifica_colision_vertical:
    beqz s5, rebota_y

    addi t0, s2, -1
    bge s5, t0, rebota_y

verifica_colision_horizontal:
    addi t0, s8, -1
    beq s4, t0, choque_pala_derecha

    addi t0, s8, -1
    beq s4, t0, choque_pala_derecha

    addi t0, s6, 1
    beq s4, t0, choque_pala_izquierda

    jal actualiza_pala

choque_pala_izquierda:
    add t0, s7, a7
    
    bge s5, t0, punto_der       # abajo de la pala
    blt s5, s7, punto_der       # arriba de la pala
    jal rebota_x      # en la pala

    jal actualiza_pala

choque_pala_derecha:
    add t0, s9, a7

    bge s5, t0, punto_izq       # abajo de la pala
    blt s5, s9, punto_izq       # arriba de la pala
    jal rebota_x      # en la pala

    jal actualiza_pala


punto_izq:
    addi a3, a3, 1

    jal actualiza_pala

punto_der:
    addi a4, a4, 1
    jal actualiza_pala

rebota_x:
    addi t0, zero, -1
    mul s10, s10, t0
    ret 

rebota_y:
    addi t0, zero, -1
    mul s11, s11, t0
    jal verifica_colision_horizontal 