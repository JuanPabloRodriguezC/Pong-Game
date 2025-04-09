# Variables importadas
li s0 LED_MATRIX_0_BASE
li s1 LED_MATRIX_0_WIDTH
li s2 LED_MATRIX_0_HEIGHT
li s3 D_PAD_0_BASE
jal ra, variables_iniciales

variables_iniciales:
    li a3, 0                            # puntaje izquierda
    li a4, 0                            # puntaje derecha
    li a5, 0xc2fc03                     # color blanco
    li a6, 0x000000                     # color negro
    srli s4, s1, 1                      # x
    srli s5, s2, 1                      # y
    li s6 0                             # x-pala izquierda
    li s7 0                             # y-pala izquierda
    addi s8, s1, -1                     # x-pala derecha
    li s9, 0                            # y-pala derecha
    li s10 1                            # dx
    li s11 -1                           # dy
    li a7 5                             # largo de la pala
    li t4, 4                            # byte
    mul t2, s1, t4                      # bytes por fila

loop_juego:
    jal ra, actualiza_pala
    jal ra, actualiza_bola
    jal ra, verifica_colisiones
    j loop_juego

actualiza_pala:
    addi sp, sp, -4
    sw ra, 0(sp)

    # verifica si boton de arriba se presiona
    lw t1, 0(s3)
    andi t1, t1, 1
    beqz t1, boton_abajo
    
    # boton de arriba presionado
    beqz s7, boton_abajo    # verifica limite superior

    # borra pixel
    add a0, zero, s6
    add a1, a7, s7
    addi a1, a1, -1
    jal selecciona_pixel

    # dibuja pixel en nueva posicion
    sw a6, 0(t0)        # color

    addi s7, s7, -1

boton_abajo:
    lw t1, 4(s3)
    andi t1, t1, 1
    beqz t1, boton_izquierda
    
    sub t3, s2, a7
    bge s7, t3, boton_izquierda   

    add a0, zero, s6
    add a1, zero, s7
    jal selecciona_pixel
    
    sw a6, 0(t0)        

    addi s7, s7, 1

boton_izquierda:
    lw t1, 8(s3)
    andi t1, t1, 1
    beqz t1, boton_derecha
    
    beqz s1, boton_derecha   

    add a0, zero, s8
    add a1, a7, s9
    addi a1, a1, -1
    jal selecciona_pixel

    sw a6, 0(t0)        

    addi s9, s9, -1

boton_derecha:
    lw t1, 0xc(s3)
    andi t1, t1, 1
    beqz t1, dibuja_pala
    
    sub t3, s2, a7
    bge s9, t3, dibuja_pala

    add a0, zero, s8
    add a1, zero, s9
    jal selecciona_pixel

    sw a6, 0(t0)

    addi s9, s9, 1

dibuja_pala:
    li t3, 1            # contador

    add a0, zero, s8
    add a1, zero, s9
    jal ra, selecciona_pixel
    add t5, zero, t0

    add a0, zero, s6
    add a1, zero, s7
    jal ra, selecciona_pixel

    sw a5, 0(t5)
    sw a5, 0(t0)
    
dibuja_pala_loop:
    add t0, t0, t2              # direccion siguiente pixel pala izquierda
    add t5, t5, t2              # direccion siguiente pixel pala derecha
    addi t3, t3, 1              # incrementa counter
    sw a5, 0(t0)         
    sw a5, 0(t5)
    bne t3, a7, dibuja_pala_loop
    
    lw ra, 0(sp)
    addi sp, sp, 4

    ret
    
actualiza_bola:
    addi sp, sp, -4
    sw ra, 0(sp)

    # borra pixel anterior
    add a0, zero, s4
    add a1, zero, s5
    jal selecciona_pixel
    sw a6, 0(t0)

    # actualiza nueva posicion
    add s4, s4, s10
    add s5, s5, s11

dibuja_bola:
    add a0, zero, s4
    add a1, zero, s5
    jal selecciona_pixel
    sw a5, 0(t0)

    lw ra, 0(sp)
    addi sp, sp, 4

    ret

verifica_colisiones:
    addi sp, sp, -4
    sw ra, 0(sp)

    beqz s5, rebota_y

    addi t0, s2, -1
    bge s5, t0, rebota_y


verifica_colision_horizontal:
    addi t0, s8, -1
    beq s4, t0, choque_pala_derecha

    addi t0, s6, 1
    beq s4, t0, choque_pala_izquierda

    lw ra, 0(sp)
    addi sp, sp, 4

    ret

choque_pala_izquierda:
    add t0, s7, a7
    
    bge s5, t0, punto_der       # abajo de la pala
    blt s5, s7, punto_der       # arriba de la pala
    jal ra, rebota_x      # en la pala

    lw ra, 0(sp)
    addi sp, sp, 4

    ret

choque_pala_derecha:
    add t0, s9, a7

    bge s5, t0, punto_izq       # abajo de la pala
    blt s5, s9, punto_izq       # arriba de la pala
    jal ra, rebota_x      # en la pala

    lw ra, 0(sp)
    addi sp, sp, 4

    ret

selecciona_pixel:
    mul t0, t4, a0
    mul t1, t2, a1
    add t0, t0, t1
    add t0, t0, s0
    ret

punto_izq:
    addi a3, a3, 1
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

punto_der:
    addi a4, a4, 1
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

rebota_x:
    addi t0, zero, -1
    mul s10, s10, t0
    ret 

rebota_y:
    addi t0, zero, -1
    mul s11, s11, t0
    jal ra, verifica_colision_horizontal