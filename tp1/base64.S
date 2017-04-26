#include<mips/regdef.h>
#include<sys/syscall.h>

.globl base64_encode
.globl errmsg

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
	.frame $fp, 72, $31
	.set noreorder 
	.cpload $25
	.set reorder

	/*defino las variables segun su posicion relativa a fp */
	#define count_line 52
	#define padding 48
	#define c_in 44
	#define c_out 40
	#define mask 36
	#define discarded 32
	#define acumulated 28
	#define shift_rigth 24
	#define shift_left 20
	#define i 16
	/*termino de definir variables */

	subu sp, sp, 72
	.cprestore 68
	sw $fp, 64(sp)
	sw ra, 60(sp)
	move $fp, sp

	/* inicializo variables locales */
	sw zero, count_line($fp)
	sw zero, padding($fp)
	sw zero, c_in($fp)
	sw zero, c_out($fp)
	sw zero, mask($fp)
	sw zero, discarded($fp)
	sw zero, acumulated($fp)
	sw zero, shift_rigth($fp)
	sw zero, shift_left($fp)
	sw zero, i($fp)
	/*termino de inicializar varaiables locales */

	lw a0, 84(sp)
	la  a1, out
	li a2, 1
	li v0, SYS_write
	syscall	
	li v0, 0
	lw ra, 4($fp)
	lw $fp, 8($fp)	
	addiu sp, sp, 16
	jr ra
.end base64_encode

.ent base64_decode
base64_decode:
	li v0, 0
	jr ra
.end base64_decode
