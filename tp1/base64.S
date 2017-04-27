#include<mips/regdef.h>
#include<sys/syscall.h>

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

.globl errmsg
.globl base64_encode

.rdata
out: .asciiz "e"
errmsg_0:.asciiz "\0"
errmsg_1:.asciiz "error1"

.align 2
errmsg:.word errmsg_0, errmsg_1
	.size errmsg, 8

.text
.abicalls
.ent base64_encode
base64_encode:
	.frame $fp, 56, $31
	.set noreorder 
	.cpload $25
	.set reorder

	/* defino los registros correspondientes a cada variable */
	#define count_line t0
	#define shift_left t1
	#define c_in t2 
	#define c_out t3 
	#define mask t4 
	#define discarded t5 
	#define acumulated t6 
	#define shift_rigth t7 

	/* a las variables que siguen se les asignaron registros ya utilizados por otras variables,
	pero como estas variables no se usan hasta que las anteriores terminen de usarse no
 	ocacionan ningun problema */

	#define padding t0 
	#define i t1
	/*termino de definir variables */

	/* defino las posiciones relativas al fp de variables */
	#define mem_count_line 36
	#define mem_shift_left 32 
	#define mem_c_in 28 
	#define mem_c_out 24 
	#define mem_mask 20 
	#define mem_discarded 16 
	#define mem_acumulated 12 
	#define mem_shift_rigth 8 

	#define SALVAR_VARIABLES sw count_line, mem_count_line($fp); sw c_in, mem_c_in($fp); sw c_out, mem_c_out($fp); sw mask, mem_mask($fp); sw discarded, mem_discarded($fp); sw acumulated, mem_acumulated($fp); sw shift_rigth, mem_shift_rigth($fp); sw shift_left, mem_shift_left($fp); sw padding, mem_padding($fp); sw i, mem_i($fp)

	#define RECUPERAR_VARIABLES lw count_line, mem_count_line($fp); lw c_in, mem_c_in($fp); lw c_out, mem_c_out($fp); lw mask, mem_mask($fp); lw discarded, mem_discarded($fp); lw acumulated, mem_acumulated($fp); lw shift_rigth, mem_shift_rigth($fp); lw shift_left, mem_shift_left($fp)


	subu sp, sp, 56
	.cprestore 52
	sw $fp, 48(sp)
	sw ra, 44(sp)
	move $fp, sp

	/* inicializo variables locales */
	li count_line, zero
	li c_in, zero
	li c_out, zero
	li mask, zero
	li discarded, zero
	li acumulated, zero
	li shift_rigth, zero
	li shift_left, zero
	/*termino de inicializar varaiables locales */

loop_read:
	lw a0, 68($fp)
	addiu a1, $fp, mem_c_in
	li a2, 1
	li v0, SYS_read
	syscall	
	beq zero, v0, fin_archivo
decodificar:
	lw c_in, mem_c_in($fp)	
	srl c_in, c_in, 24
	move mask, c_in
	addiu shift_left, acumulated, 2
	sllv mask, mask, shift_left
	or c_out, c_out, discarded
	sll c_out, c_out, 2
	or c_out, c_out, mask
switch:
	slti a3, c_out, UPPERCASE_LIMIT
	bneq a3, zero, uppercase
	slti a3, c_out, LOWERCASE_LIMIT
	bneq a3, zero, lowercase
	slti a3, c_out, DIGIT_LIMIT
	bneq a3, zero, digit
	addiu a3, zero, PLUS
	beq a3, c_out, plus
bar:
	li c_out, 47
	j end_switch
plus:
	li c_out, 43
	j end_switch
digit:
	subu c_out, c_out, LOWERCASE_LIMIT
	addiu c_out, c_out, 48
	j end_switch
lowercase:
	subu c_out, c_out, UPPERCASE_LIMIT
	addiu c_out, c_out, 97
	j end_switch
uppercase:
	addiu c_out, c_out, 65
end_switch:
	sll c_out, c_out, 24
	sw c_out, mem_c_out($fp)
	li v0, SYS_write	
	lw a0, 64($fp)
	addiu a1, $fp, mem_c_out
	li a2, 1
	SALVAR_VARIABLES
	syscall
	RECUPERAR_VARIABLES
	addiu count_line, 1
	addiu a3, zero, 75
	bne count_line, a3, misma_linea	
nueva_linea:
	li c_out, 10
	sll c_out, c_out, 24
	sw c_out, mem_c_out($fp)
	li v0, SYS_write
	SALVAR_VARIABLES
	syscall
	RECUPERAR_VARIABLES
misma_linea:
	li c_out, 0
misma_linea:
	li c_out, 0
		
.end base64_encode

.ent base64_decode
base64_decode:
	li v0, 0
	jr ra
.end base64_decode
