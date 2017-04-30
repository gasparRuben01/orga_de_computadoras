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
#define MAX_LINE_SIZE 76
/* mascara para byte de 6 bits mas significativos de un registro */

.globl base64_encode
.globl base64_decode
.globl errmsg 

.data
.align 2
errmsg:.word err0, err1
       .size errmsg, 8
.align 0
err0: .asciiz ""
err1: .asciiz "archivo mal formado"
err2: .asciiz "ascii no valido encontrado en el archivo"

.text
.abicalls
.align 2
.ent base64_encode
base64_encode:

	#define ENCODE_FRAME_SIZE 44 /* tamanio del frame */
	#define ENCODE_MASK 0XFC000000

	/* defino los registros que corresponden a cada variable */

	#define retorno t6 /* esta variable la uso como ra, pero para no confundirme con la original ra use otro registro, la uso para invocar el pedazo de codigo encode_nueva_linea */
	#define encode_input t0 /* entrada de archivo */
	#define encode_i t1 /* variable de corte para un bucle, representa la cantidad de bytes de 6 bits que se pueden obtener del inptu */
	#define encode_mask t2
	#define encode_output t3 /*salida del archivo */
	#define encode_padding t4 /*cantidad de bytes de relleno '='*/
	#define encode_line_size t5 /*cantidad de bytes tope que puede tener una linea de la salida */
	#define encode_bytes_leidos v0 /* SYS_write retorna la cantidad de bytes leidos en v0 */

	/* termino de definir los registros que corresponden a cada variable */

	/* defino las posiciones en el frame (relativas a $fp)  de cada variable */
	#define encode_frame_retorno 24
	#define encode_frame_input 20
	#define encode_frame_output 16
	#define encode_frame_i 12
	#define encode_frame_mask 8
	#define encode_frame_padding 4
	#define encode_frame_line_size 0
	#define encode_frame_finput 56
	#define encode_frame_foutput 52
	#define encode_frame_ra 32
	#define encode_frame_fp 36
	#define encode_frame_gp 40

	/* termino de definir las posiciones en el frame (relativas a $fp)  de cada variable */

	.frame $fp, ENCODE_FRAME_SIZE, $31
	.set noreorder
	.cpload $25
	.set reorder

	subu sp, sp, ENCODE_FRAME_SIZE 
	.cprestore encode_frame_gp
	sw $fp, encode_frame_fp(sp) 
	sw ra, encode_frame_ra(sp)
	move $fp, sp
	sw a0, encode_frame_finput($fp)
	sw a1, encode_frame_foutput($fp)
	li encode_line_size, MAX_LINE_SIZE 

	encode_loop_read:
		lw a0, encode_frame_finput($fp)
		li v0, SYS_read
		addiu a1, $fp, encode_frame_input

		/* leo de a 3 bytes para aprovechar el hecho que 3 bytes de 8 bits me dan 4 bytes de 6 bits exacto */
		li a2, 3

		/* guardo todas las variables temporales antes del syscall */
		jal encode_salvar_variables
		syscall
		/* recupero variables temporales */
		jal encode_recuperar_variables

		/* cargo encode_input byte por byte, porque en mi simulador mips es little-endian (al igual que mi maquina) */
		move encode_input, zero
		lbu a0, 0(a1)
		sll a3, a0, 24
		or encode_input, encode_input, a3
		lbu a0, 1(a1)
		sll a3, a0, 16
		or encode_input, encode_input, a3
		lbu a0, 2(a1)
		sll a3, a0, 8	
		or encode_input, encode_input, a3
		
		/* si la cantidad de bytes leidos es 0 entones termine y el archivos es multiplo de 3 por lo que no necesito encode_padding */
		beq encode_bytes_leidos, zero, encode_return

		/*si cantidad de bytes leidos es distinto a 0, entonces el encode_padding se calcula el encode_padding e i (la cantidad de bytes de 6 bits que 
		se pueden obtener del encode_input). El encode_padding se calcula en todos los ciclos pero solo se utiliza cuando se termina de leer el archivo */
		addiu encode_i, v0, 1
		subu encode_padding, a2, v0

		encode_for:
			beq encode_i, zero, encode_loop_read
			li encode_mask, ENCODE_MASK

			/*tomo primer byte de 6 bits */
			and encode_output, encode_mask, encode_input	
			srl encode_output, encode_output, 26

			/* mapeo byte de 6 bits al ascii correspondiente */
			encode_switch:
				slti a3, encode_output, UPPERCASE_LIMIT
				bne zero, a3, encode_uppercase
				slti a3, encode_output, LOWERCASE_LIMIT
				bne zero, a3, encode_lowercase
				slti a3, encode_output, DIGIT_LIMIT
				bne zero, a3, encode_digit
				addiu a3, zero, PLUS
				beq encode_output, a3, encode_plus
			encode_bar:
				li encode_output, 47
				j encode_end_switch
			encode_uppercase:
				addiu encode_output, encode_output, 65
				j encode_end_switch
			encode_lowercase:
				subu encode_output, encode_output, UPPERCASE_LIMIT
				addiu encode_output, encode_output, 97
				j encode_end_switch
			encode_digit:
				subu encode_output, encode_output, LOWERCASE_LIMIT
				addiu encode_output, encode_output, 48
				j encode_end_switch
			encode_plus:
				li encode_output, 43
			encode_end_switch:
			lw a0, encode_frame_foutput($fp)
			li v0, SYS_write
			addiu a1, $fp, encode_frame_output
			li a2, 1

			/* al hacer shift left, mato al byte de 6 bits que se encontra en la parte mas significativa del */
			/* registro y lo reemplazo con el siguiente */
			sll encode_input, encode_input, 6
			jal encode_salvar_variables
			syscall
			jal encode_recuperar_variables
			subu encode_i, encode_i, 1

			/*largo de linea */
			subu encode_line_size, 1
			la retorno, encode_for
			/* si supero la cantidad maxima de caracteres salto a encode_nueva_linea para que me imprima un salto de linea*/
			/* encode_nueva_linea usa la variable retorno para volver al punto de donde la llamaron */
			beq zero, encode_line_size, encode_nueva_linea
			j encode_for
	encode_nueva_linea:
		li encode_output, 10
		lw a0, encode_frame_foutput($fp)
		li v0, SYS_write
		addiu a1, $fp, encode_frame_output
		li a2, 1
		jal encode_salvar_variables
		syscall
		jal encode_recuperar_variables
		li encode_line_size, MAX_LINE_SIZE
		jr retorno

	encode_return:
		beq encode_padding, zero, encode_fin_padding
		li encode_output, 61
		li v0, SYS_write
		addiu a1, $fp, encode_frame_output
		li a2, 1
		lw a0, encode_frame_foutput($fp)
		jal encode_salvar_variables
		syscall
		jal encode_recuperar_variables
		subu encode_padding, encode_padding, 1
		la retorno, encode_return
		subu encode_line_size, encode_line_size, 1
		beq zero, encode_line_size, encode_nueva_linea
		j encode_return
	encode_fin_padding:
		lw ra, encode_frame_ra($fp)
		lw $fp, encode_frame_fp($fp)
		addiu sp, sp, ENCODE_FRAME_SIZE
		/* aqui termina funcion */
		move v0, zero
		jr ra
	encode_salvar_variables:
		sw encode_i, encode_frame_i($fp)
		sw encode_line_size, encode_frame_line_size($fp)
		sw encode_output, encode_frame_output($fp)
		sw encode_input, encode_frame_input($fp)
		sw encode_padding, encode_frame_padding($fp)
		sw encode_mask, encode_frame_mask($fp)	
		sw retorno, encode_frame_retorno($fp)
		jr ra
	encode_recuperar_variables:
		lw encode_i, encode_frame_i($fp)
		lw encode_line_size, encode_frame_line_size($fp)
		lw encode_output, encode_frame_output($fp)
		lw encode_input, encode_frame_input($fp)
		lw encode_padding, encode_frame_padding($fp)
		lw encode_mask, encode_frame_mask($fp)	
		lw retorno, encode_frame_retorno($fp)
		jr ra
.end base64_encode




.text
.align 2
.abicalls

.ent base64_decode
	#define DECODE_FRAME_SIZE 48
	#define DECODE_DISTANCE_IN_WORDS_TO_NEWLINE 19 /* en el archivo salida de encode se agregaron caracteres de nueva linea cada 19 palabras (76 caracteres) */ 
	#define DECODE_MASK 0xFF000000

	/* asigno registros a cada variable */
	#define decode_mask t0
	#define decode_i t1
	#define decode_distance_in_words_to_newline t2
	#define decode_input t3
	#define decode_output t4
	#define decode_shift_left t5
	#define decode_nbytes t6   /*cantidad de bytes de 8 bits en el buffer leido */
	#define decode_retorno t7  /*uso este registro en vez de ra, cuando conviene */
	/*termino de asignar registros para las variables */

	/*asigno registros en el stack a  variables */
	#define decode_frame_input 28
	#define decode_frame_i 24
	#define decode_frame_distance_in_words_to_newline 20
	#define decode_frame_mask 16
	#define decode_frame_retorno 12
	#define decode_frame_output 8
	#define decode_frame_shift_left 4
	#define decode_frame_nbytes 0

	#define decode_frame_finput 60
	#define decode_frame_foutput 56
	#define decode_frame_gp 44
	#define decode_frame_fp 40
	#define decode_frame_ra 36 
	/*termino de asignar registros en el stack a variables */

	
base64_decode:
	.frame $fp, DECODE_FRAME_SIZE, $31
	.set noreorder
	.cpload $25
	.set reorder

	subu sp, sp, DECODE_FRAME_SIZE
	.cprestore decode_frame_gp
	sw $fp, decode_frame_fp(sp)
	sw ra, decode_frame_ra(sp)
	move $fp, sp
	li decode_distance_in_words_to_newline, DECODE_DISTANCE_IN_WORDS_TO_NEWLINE 
	sw a0, decode_frame_finput($fp)
	sw a1, decode_frame_foutput($fp)
	
	decode_loop_read:
		lw a0, decode_frame_finput($fp)
		addiu a1, $fp, decode_frame_input 
		li a2, 4
		li v0, SYS_read
		jal decode_salvar_variables
		syscall
		jal decode_recuperar_variables
		beq zero, v0, decode_return
		slti a2, v0, 4
		/* el archivo no es multiplo de 4, error */
		bne a2, zero, decode_err1
		subu decode_distance_in_words_to_newline, decode_distance_in_words_to_newline, 1	
		la decode_retorno, decode
		beq zero, decode_distance_in_words_to_newline, decode_desechar_nueva_linea

		decode:
			/*cargo byte a byte a input */
			move decode_input, zero
			move a1, zero
			addiu a0, $fp, decode_frame_input  /* a0 sostiene la dirección el byte a leer */
			li decode_i, 4 /*leo cuatro chars */
			li decode_shift_left, 26
			li decode_nbytes, 3 

			decode_for1:
				beq zero, decode_i, decode_end_for1
					lbu a1, 0(a0)

					/* mapeo el ascii leido a un byte de 6 bits */
					decode_switch:
						li a2, 43 /* '+':43 */
						beq a2, a1, decode_plus
						li a2, 47 /* '/':47 */
						beq a2, a1, decode_bar
						li a2, 61 /* '=':61 */
						beq a2, a1, decode_equal

						/*si vale menos de 47 y no es uno de los ascii anteriores entonces es un byte invalido */
						slti a2, a1, 47
						bne a2, zero, decode_err2

						slti a2, a1, 58 /* '9':57 */
						bne a2, zero, decode_digit
						
						/* si no es numero y vale menos que 65 (A en ascii) entonces en un byte invalido */
						slti a2, a1, 65
						bne a2, zero, decode_err2

						slti a2, a1, 91 /* 'Z':90 */
						bne a2, zero, decode_upper_letter

						/* si vale menos de 97(a en ascii ) y no es una letra mayuscula, entonces en un byte invalido*/
						slti a2, a1, 97
						bne a2, zero, decode_err2

						slti a2, a1, 123 /* 'z':122 */
						bne a2, zero, decode_lower_letter

						/* si el caracter no es uno de los anteriores entonces hay un error */
						j decode_err2

						decode_plus:
							li a1, 62 /* '+':62 en base64 */
							j decode_end_switch
						decode_bar:
							li a1, 63 /* '/':63 en base64 */
							j decode_end_switch
						decode_equal:
							subu decode_nbytes, decode_nbytes, 1 /* como es un byte de relleno, lo resto de los bytes leidos del buffer */
							j decode_end_switch
						decode_digit:
							subu a1, a1, 48 /* '0':48 */
							addiu a1, a1, 52 /* '0':52 en base64 */
							j decode_end_switch
						decode_upper_letter:
							subu a1, a1, 65	/* 'A':65 */
							j decode_end_switch
						decode_lower_letter:
							subu a1, a1, 97 /* 'a':97 */
							addiu a1, a1, 26 /* 'a':26 en base64 */
							j decode_end_switch
					decode_end_switch:

					sllv a1, a1, decode_shift_left
					or decode_input, decode_input, a1
					move a1, zero
					subu decode_shift_left, decode_shift_left, 6	
					subu decode_i, decode_i, 1
					addiu a0, a0, 1
					j decode_for1
				decode_end_for1:

				decode_for2:
					beq zero, decode_nbytes, decode_end_for2
					li decode_mask, DECODE_MASK
					and decode_output, decode_mask, decode_input
					srl decode_output, 24
					lw a0, decode_frame_foutput($fp)
					la a1, decode_frame_output($fp)
					li a2, 1
					li v0, SYS_write
					jal decode_salvar_variables
					syscall
					jal decode_recuperar_variables
					sll decode_input, decode_input, 8
					subu decode_nbytes, decode_nbytes, 1
					j decode_for2
				decode_end_for2:
					j decode_loop_read

	decode_salvar_variables:
		sw decode_input, decode_frame_input($fp)
		sw decode_i, decode_frame_i($fp)
		sw decode_distance_in_words_to_newline, decode_frame_distance_in_words_to_newline($fp)
		sw decode_mask, decode_frame_mask($fp)
		sw decode_retorno, decode_frame_retorno($fp)
		sw decode_output, decode_frame_output($fp)
		sw decode_shift_left, decode_frame_shift_left($fp)
		sw decode_nbytes, decode_frame_nbytes($fp)
		j ra

	decode_recuperar_variables:
		lw decode_input, decode_frame_input($fp)
		lw decode_i, decode_frame_i($fp)
		lw decode_distance_in_words_to_newline, decode_frame_distance_in_words_to_newline($fp)
		lw decode_mask, decode_frame_mask($fp)
		lw decode_retorno, decode_frame_retorno($fp)
		lw decode_output, decode_frame_output($fp)
		lw decode_shift_left, decode_frame_shift_left($fp)
		lw decode_nbytes, decode_frame_nbytes($fp)
		j ra

	decode_err1:
		li v0, 1
		j decode_return

	decode_err2:
		li v1, 2
		j decode_return

	decode_desechar_nueva_linea:
		lw a0, decode_frame_finput($fp)
		addiu a1, $fp, decode_frame_output /* lo guardo en la salida, este valor se va a perder igualmente */
		move decode_output, zero
		li a2, 1
		li v0, SYS_read
		jal decode_salvar_variables
		syscall
		jal decode_recuperar_variables
		li a2, 10 /* CR=10 en ascii */
		bne a2, decode_output, decode_err1 /*si no hay un caracter de nueva linea cada 76 caracteres entonces hay un error */
		li decode_distance_in_words_to_newline, DECODE_DISTANCE_IN_WORDS_TO_NEWLINE
		jr decode_retorno

	decode_return:
		lw ra, decode_frame_ra($fp)
		lw $fp, decode_frame_fp($fp)
		addiu sp, sp, DECODE_FRAME_SIZE
		j ra

.end base64_decode
