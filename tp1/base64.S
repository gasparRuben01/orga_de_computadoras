#include <mips/regdef.h>
#include <sys/syscall.h>

/* valor numerico del ascii en base 64 Z + 1 */
#define UPPERCASE_LIMIT 26
/* valor numerico del ascii en base 64 z + 1 */
#define  LOWERCASE_LIMIT 52
/* valor numerico del ascii en base 64 9 + 1 */
#define DIGIT_LIMIT 62
/* valores numericos de los ascii correspondientes en base64 */
#define PLUS 62
#define BAR 63
#define PADDING '='
/* tamanio maximo de una linea de salida */
#define MAX_LINE_SIZE 75

.globl base64_encode
.globl base64_decode
.globl errmsg 

.data
.align 2
errmsg:.word err0, err1
       .size errmsg, 8
.align 0
err0: .asciiz ""
err1: .asciiz "err1"


.text
.abicalls
.align 2
.ent base64_encode
base64_encode:

	#define FRAME_SIZE 44 /* tamanio del frame */

	/* defino los registros que corresponden a cada variable */

	#define retorno t6 /* esta variable la uso como ra, pero para no confundirme con la original ra use otro registro, la uso para invocar el pedazo de codigo nueva_linea */
	#define input t0 /* entrada de archivo */
	#define i t1 /* variable de corte para un bucle, representa la cantidad de bytes de 6 bits que se pueden obtener del inptu */
	#define mask t2
	#define output t3 /*salida del archivo */
	#define padding t4 /*cantidad de bytes de relleno '='*/
	#define line_size t5 /*cantidad de bytes tope que puede tener una linea de la salida */
	#define bytes_leidos v0 /* SYS_write retorna la cantidad de bytes leidos en v0 */

	/* termino de definir los registros que corresponden a cada variable */

	/* defino las posiciones en el frame (relativas a $fp)  de cada variable */
	#define frame_retorno 24
	#define frame_input 20
	#define frame_output 16
	#define frame_i 12
	#define frame_mask 8
	#define frame_padding 4
	#define frame_line_size 0
	#define frame_finput 56
	#define frame_foutput 52
	#define frame_ra 32
	#define frame_fp 36
	#define frame_gp 40

	/* termino de definir las posiciones en el frame (relativas a $fp)  de cada variable */

	.frame $fp, FRAME_SIZE, $31
	.set noreorder
	.cpload $25
	.set reorder

	subu sp, sp, FRAME_SIZE 
	.cprestore frame_gp
	sw $fp, frame_fp(sp) 
	sw ra, frame_ra(sp)
	move $fp, sp
	sw a0, frame_finput($fp)
	sw a1, frame_foutput($fp)
	li line_size, MAX_LINE_SIZE 

	loop_read:
		lw a0, frame_finput($fp)
		li v0, SYS_read
		addiu a1, $fp, frame_input

		/* leo de a 3 bytes para aprovechar el hecho que 3 bytes de 8 bits me dan 4 bytes de 6 bits exacto */
		li a2, 3
		move input, zero

		/* guardo todas las variables temporales antes del syscall */
		jal salvar_variables
		syscall
		/* recupero variables temporales */
		jal recuperar_variables

		/* cargo input byte por byte, porque en mi simulador mips es little-endian (al igual que mi maquina) */
		lb a0, 0(a1)
		sll a3, a0, 24
		or input, input, a3
		lb a0, 1(a1)
		sll a3, a0, 16
		or input, input, a3
		lb a0, 2(a1)
		sll a3, a0, 8	
		or input, input, a3
		
		/* si la cantidad de bytes leidos es 0 entones termine y el archivos es multiplo de 3 por lo que no necesito padding */
		beq bytes_leidos, zero, return

		/*si cantidad de bytes leidos es distinto a 0, entonces el padding se calcula el padding e i (la cantidad de bytes de 6 bits que 
		se pueden obtener del input). El padding se calcula en todos los ciclos pero solo se utiliza cuando se termina de leer el archivo */
		addiu i, v0, 1
		subu padding, a2, v0

		for:
			beq i, zero, loop_read
			li mask, 0xFC000000	

			/*tomo primer byte de 6 bits */
			and output, mask, input	
			srl output, output, 26

			/* mapeo byte de 6 bits al ascii correspondiente */
			switch:
				slti a3, output, UPPERCASE_LIMIT
				bne zero, a3, uppercase
				slti a3, output, LOWERCASE_LIMIT
				bne zero, a3, lowercase
				slti a3, output, DIGIT_LIMIT
				bne zero, a3, digit
				addiu a3, zero, PLUS
				beq output, a3, plus
			bar:
				li output, 47
				j end_switch
			uppercase:
				addiu output, output, 65
				j end_switch
			lowercase:
				subu output, output, UPPERCASE_LIMIT
				addiu output, output, 97
				j end_switch
			digit:
				subu output, output, LOWERCASE_LIMIT
				addiu output, output, 48
				j end_switch
			plus:
				li output, 43
			end_switch:
			lw a0, frame_foutput($fp)
			li v0, SYS_write
			addiu a1, $fp, frame_output
			li a2, 1
			jal salvar_variables
			syscall
			jal recuperar_variables
			subu i, i, 1

			/* al hacer shift left, mato al byte de 6 bits que se encontra en la parte mas significativa del */
			/* registro y lo reemplazo con el siguiente */
			sll input, input, 6

			/*largo de linea */
			subu line_size, 1
			la retorno, for
			/* si supero la cantidad maxima de caracteres salto a nueva_linea para que me imprima un salto de linea*/
			/* nueva_linea usa la variable retorno para volver al punto de donde la llamaron */
			beq zero, line_size, nueva_linea
			j for
	nueva_linea:
		li output, 10
		lw a0, frame_foutput($fp)
		li v0, SYS_write
		addiu a1, $fp, frame_output
		li a2, 1
		jal salvar_variables
		syscall
		jal recuperar_variables
		li line_size, 75
		jr retorno

	return:
		beq padding, zero, fin_padding
		li output, 61
		li v0, SYS_write
		addiu a1, $fp, frame_output
		li a2, 1
		lw a0, frame_foutput($fp)
		jal salvar_variables
		syscall
		jal recuperar_variables
		subu padding, padding, 1
		la retorno, return
		subu line_size, line_size, 1
		beq zero, line_size, nueva_linea
		j return
	fin_padding:
		lw ra, frame_ra($fp)
		lw $fp, frame_fp($fp)
		addiu sp, sp, FRAME_SIZE
		/* aqui termina funcion */
		move v0, zero
		jr ra
	salvar_variables:
		sw i, frame_i($fp)
		sw line_size, frame_line_size($fp)
		sw output, frame_output($fp)
		sw input, frame_input($fp)
		sw padding, frame_padding($fp)
		sw mask, frame_mask($fp)	
		sw retorno, frame_retorno($fp)
		jr ra
	recuperar_variables:
		lw i, frame_i($fp)
		lw line_size, frame_line_size($fp)
		lw output, frame_output($fp)
		lw input, frame_input($fp)
		lw padding, frame_padding($fp)
		lw mask, frame_mask($fp)	
		lw retorno, frame_retorno($fp)
		jr ra
.end base64_encode

.ent base64_decode
base64_decode:
	jr ra
.end base64_decode	
