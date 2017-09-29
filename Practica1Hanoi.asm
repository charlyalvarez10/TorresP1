
#	Practica 1
#	Arquitectura de Computadoras
#	Juan Carlos Álvarez Gutiérrez
#	Expediente: is697676


.text
		addi $s0, $s0, 8	# Numero de discos para jugar
		add $s4, $s4, $s0	# Numero que se compara al valor de s0 para saber el valor de N dentro de la funcion
		ori $s1, 0x10010000	# Inicializacion de la Torre A
		
Inicio:		beq $s4, 0, siguiente	# Inicializacion de la primera torre con todos los discos
		sw $s4, 0($s1)		# Guarda el valor en la Torre A empezando por N
		add $s1, $s1, 4		# Se salta a la siguiente direccion
		sub $s4, $s4, 1		# Se resta uno de los valores de los discos
		j Inicio		# Brinca de nuevo a la etiqueta Inicio
		
siguiente:	add $s2, $s2, $s1	# Se iguala la direccion de la Torre B con el fin de la Torre A
		add $s3, $s3, $s2	# Se iguala la direccion de la Torre C con el inicio de la Torre C
		
TorreC:		addi $s3, $s3, 4	# Se recorre el apuntador de la Torre C
		addi $s4, $s4, 1	# Se aumenta en 1 el contador para saber las veces que se va a recorrer el apuntador de la Torre C
		bne $s4, $s0, TorreC	# Verificamos si el apuntador de la Torre C ya recorrio N veces
		
		andi $s4, $s4, 0	# El contador lo igualamos a 0
		add $t0, $t0, $s3	# Igualamos la direccion de la Pila de direcciones de retorno con la direccion de inicio de la Torre C
				
Stack:		addi $t0, $t0, 4	# Recorremos el apuntador de la Pila de direcciones de retorno
		addi $s4, $s4, 1	# Aumentamos el contador en 1 hasta llegar a N
		bne $s4, $s0, Stack	# Comprobamos si el apuntador de la Pila de direcciones de retorno recorrio N veces
		
		jal Cambio		# Se llama mandar la funcion de Cambio
		j Fin			# Brinco al fin del programa
		
		
Cambio:		sw $ra, 0($t0)		# Se almacena la direccion de retorno
		add $t0, $t0, 4		# Avanza a la siguiente direccion de la Pila de direcciones de retorno
		
		bne $s4, 1, Else	# Compara si s4 es igual a 1, si lo es entonces hace el cambio de disco
		sub $s1, $s1, 4		# Cuando la Columna entrega un disco entonces disminuye una posicion para obtener su ultimo valor
		lw $s6, 0($s1)		# Se guarda el valor de la Torre de s1 en s6 para intercambiar su valor
		lw $s7, 0($s3)		# Se guarda el valor de la Torre de s3 en s7 para intercambiar su valor
		sw $s7, 0($s1)		# Se almacena el valor de s7 en la Torre de s1
		sw $s6, 0($s3)		# Se almacena el valor de s6 en la Torre de s3
		add $s3, $s3, 4		# Cuando una Torre recibe un valor entonces aumenta una posicion en caso de recibir otro
		
		sub $t0, $t0, 4		# Se decrementa una posicion en la pila para obtener la ultima direccion de retorno
		lw $ra, 0($t0)		# Se obtiene la ultima direccion de retorno
		sw $zero, 0($t0)	# Ponemos en 0 la direccion que ya leimos
		jr $ra			# se sale de la funcion
		
Else:		sub $s4, $s4, 1		# Se resta uno a nuestro contador de discos s4
		add $s2, $s2, $s3	# Se hace el cambio de etiquetas antes de entrar a la funcion
		sub $s3, $s2, $s3	# El cambio se hace por medio de sumas y restas
		sub $s2, $s2, $s3
		jal Cambio		# Se manda llamar la funcion de cambio de forma recursiva
		
		add $s4, $s4, 1		# Al salir de la funcion se regresa al valor anterior antes de entrar a la funcion
		add $s2, $s2, $s3	# Se regresa al antiguo valor de etiquetas para las columnas antes de entrar a la funcion
		sub $s3, $s2, $s3	# Utilizamos el mismo metodo de sumas y restas
		sub $s2, $s2, $s3
					
					# Realizamos un cambio de discos obteniendo el disco n-1
		sub $s1, $s1, 4		# Cuando la Torre entrega un disco entonces disminuye una posicion para obtener su ultimo valor
		lw $s6, 0($s1)		# Se guarda el valor de la Torre de s1 en s6 para intercambiar su valor
		lw $s7, 0($s3)		# Se guarda el valor de la Torre de s3 en s7 para intercambiar su valor
		sw $s7, 0($s1)		# Se almacena el valor de s7 en la Torre de s1
		sw $s6, 0($s3)		# Se almacena el valor de s6 en la Torre de s3
		add $s3, $s3, 4		# Cuando una Torre recibe un valor entonces aumenta una posicion en caso de recibir otro
		
		sub $s4, $s4, 1		# Se resta uno a nuestro contador de discos s4
		add $s1, $s1, $s2	# Se hace el cambio de etiquetas antes de entrar a la funcion
		sub $s2, $s1, $s2	# El cambio se hace por medio de sumas y restas
		sub $s1, $s1, $s2
		jal Cambio		# Se manda llamar la misma funcion de forma recursiva
		
		add $s4, $s4, 1		# Al salir de la funcion se regresa al valor anterior antes de entrar
		add $s1, $s1, $s2	# Se regresa al antiguo valor de etiquetas para las Torres antes de entrar a la funcion
		sub $s2, $s1, $s2	# Utilizamos el mismo metodo de sumas y restas
		sub $s1, $s1, $s2
		
		sub $t0, $t0, 4		# Se decrementa una posicion en la pila para obtener la ultima direccion de retorno
		lw $ra, 0($t0)		# Se obtiene la ultima direccion de retorno
		sw $zero, 0($t0)	# Se pone 0 la direccion que ya se leyó
		jr $ra			# Sale de la función
				
Fin:
