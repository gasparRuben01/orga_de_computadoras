	.file	1 "tp0.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	from256to64
	.ent	from256to64
from256to64:
	.frame	$fp,24,$ra		# vars= 8, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,24
	.cprestore 0
	sw	$fp,20($sp)
	sw	$gp,16($sp)
	move	$fp,$sp
	move	$v0,$a0
	sb	$v0,8($fp)
	lbu	$v0,8($fp)
	sltu	$v0,$v0,26
	beq	$v0,$zero,$L18
	lbu	$v0,8($fp)
	addu	$v0,$v0,65
	andi	$v0,$v0,0x00ff
	sw	$v0,12($fp)
	b	$L17
$L18:
	lbu	$v0,8($fp)
	sltu	$v0,$v0,52
	beq	$v0,$zero,$L19
	lbu	$v0,8($fp)
	addu	$v0,$v0,71
	andi	$v0,$v0,0x00ff
	sw	$v0,12($fp)
	b	$L17
$L19:
	lbu	$v0,8($fp)
	sltu	$v0,$v0,62
	beq	$v0,$zero,$L20
	lbu	$v0,8($fp)
	addu	$v0,$v0,-4
	andi	$v0,$v0,0x00ff
	sw	$v0,12($fp)
	b	$L17
$L20:
	lbu	$v1,8($fp)
	li	$v0,62			# 0x3e
	bne	$v1,$v0,$L21
	li	$v0,43			# 0x2b
	sw	$v0,12($fp)
	b	$L17
$L21:
	lbu	$v1,8($fp)
	li	$v0,63			# 0x3f
	bne	$v1,$v0,$L22
	li	$v0,47			# 0x2f
	sw	$v0,12($fp)
	b	$L17
$L22:
	li	$v0,61			# 0x3d
	sw	$v0,12($fp)
$L17:
	lw	$v0,12($fp)
	move	$sp,$fp
	lw	$fp,20($sp)
	addu	$sp,$sp,24
	j	$ra
	.end	from256to64
	.size	from256to64, .-from256to64
	.align	2
	.globl	from64to256
	.ent	from64to256
from64to256:
	.frame	$fp,24,$ra		# vars= 8, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,24
	.cprestore 0
	sw	$fp,20($sp)
	sw	$gp,16($sp)
	move	$fp,$sp
	move	$v0,$a0
	sb	$v0,8($fp)
	lbu	$v0,8($fp)
	sltu	$v0,$v0,65
	bne	$v0,$zero,$L24
	lbu	$v0,8($fp)
	sltu	$v0,$v0,91
	beq	$v0,$zero,$L24
	lbu	$v0,8($fp)
	addu	$v0,$v0,-65
	andi	$v0,$v0,0x00ff
	sw	$v0,12($fp)
	b	$L23
$L24:
	lbu	$v0,8($fp)
	sltu	$v0,$v0,97
	bne	$v0,$zero,$L25
	lbu	$v0,8($fp)
	sltu	$v0,$v0,123
	beq	$v0,$zero,$L25
	lbu	$v0,8($fp)
	addu	$v0,$v0,-71
	andi	$v0,$v0,0x00ff
	sw	$v0,12($fp)
	b	$L23
$L25:
	lbu	$v0,8($fp)
	sltu	$v0,$v0,48
	bne	$v0,$zero,$L26
	lbu	$v0,8($fp)
	sltu	$v0,$v0,58
	beq	$v0,$zero,$L26
	lbu	$v0,8($fp)
	addu	$v0,$v0,4
	andi	$v0,$v0,0x00ff
	sw	$v0,12($fp)
	b	$L23
$L26:
	lbu	$v1,8($fp)
	li	$v0,43			# 0x2b
	bne	$v1,$v0,$L27
	li	$v0,62			# 0x3e
	sw	$v0,12($fp)
	b	$L23
$L27:
	lbu	$v1,8($fp)
	li	$v0,47			# 0x2f
	bne	$v1,$v0,$L28
	li	$v0,63			# 0x3f
	sw	$v0,12($fp)
	b	$L23
$L28:
	lbu	$v1,8($fp)
	li	$v0,61			# 0x3d
	bne	$v1,$v0,$L29
	li	$v0,63			# 0x3f
	sw	$v0,12($fp)
	b	$L23
$L29:
	li	$v0,255			# 0xff
	sw	$v0,12($fp)
$L23:
	lw	$v0,12($fp)
	move	$sp,$fp
	lw	$fp,20($sp)
	addu	$sp,$sp,24
	j	$ra
	.end	from64to256
	.size	from64to256, .-from64to256
	.globl	msg_err
	.globl	msg_err
	.section	.bss
	.align	2
	.type	msg_err, @object
	.size	msg_err, 4
msg_err:
	.space	4
	.text
	.align	2
	.globl	encode
	.ent	encode
encode:
	.frame	$fp,64,$ra		# vars= 24, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,64
	.cprestore 16
	sw	$ra,56($sp)
	sw	$fp,52($sp)
	sw	$gp,48($sp)
	move	$fp,$sp
	sw	$a0,64($fp)
	sw	$a1,68($fp)
	sw	$zero,24($fp)
	sb	$zero,28($fp)
	sb	$zero,29($fp)
	sb	$zero,30($fp)
	sb	$zero,31($fp)
	sw	$zero,32($fp)
	sw	$zero,36($fp)
	sw	$zero,40($fp)
	sw	$zero,44($fp)
	lw	$a0,64($fp)
	la	$t9,fgetc
	jal	$ra,$t9
	sb	$v0,28($fp)
$L31:
	lw	$v0,64($fp)
	lhu	$v0,12($v0)
	srl	$v0,$v0,5
	andi	$v0,$v0,0x1
	beq	$v0,$zero,$L33
	b	$L32
$L33:
	lbu	$v0,28($fp)
	sb	$v0,30($fp)
	lw	$v0,32($fp)
	addu	$v0,$v0,2
	sw	$v0,40($fp)
	lbu	$v1,30($fp)
	lw	$v0,40($fp)
	sra	$v0,$v1,$v0
	sb	$v0,30($fp)
	lbu	$v1,29($fp)
	lbu	$v0,31($fp)
	or	$v0,$v1,$v0
	sb	$v0,29($fp)
	lbu	$v0,29($fp)
	srl	$v0,$v0,2
	sb	$v0,29($fp)
	lbu	$v1,29($fp)
	lbu	$v0,30($fp)
	or	$v0,$v1,$v0
	sb	$v0,29($fp)
	lbu	$v0,29($fp)
	move	$a0,$v0
	la	$t9,from256to64
	jal	$ra,$t9
	move	$a0,$v0
	lw	$a1,68($fp)
	la	$t9,fputc
	jal	$ra,$t9
	sb	$zero,29($fp)
	lw	$v0,40($fp)
	sw	$v0,32($fp)
	lbu	$v0,28($fp)
	sb	$v0,31($fp)
	li	$v1,8			# 0x8
	lw	$v0,40($fp)
	subu	$v0,$v1,$v0
	sw	$v0,36($fp)
	lbu	$v1,31($fp)
	lw	$v0,36($fp)
	sll	$v0,$v1,$v0
	sb	$v0,31($fp)
	lw	$v1,32($fp)
	li	$v0,8			# 0x8
	bne	$v1,$v0,$L34
	lbu	$v0,31($fp)
	sb	$v0,28($fp)
	sw	$zero,32($fp)
	sb	$zero,31($fp)
	b	$L31
$L34:
	lw	$a0,64($fp)
	la	$t9,fgetc
	jal	$ra,$t9
	sb	$v0,28($fp)
	b	$L31
$L32:
	lw	$v0,32($fp)
	beq	$v0,$zero,$L36
	lbu	$v0,31($fp)
	srl	$v0,$v0,2
	sb	$v0,31($fp)
	lbu	$v0,31($fp)
	move	$a0,$v0
	la	$t9,from256to64
	jal	$ra,$t9
	move	$a0,$v0
	lw	$a1,68($fp)
	la	$t9,fputc
	jal	$ra,$t9
$L36:
	lw	$a0,32($fp)
	li	$v0,1431633920			# 0x55550000
	ori	$v0,$v0,0x5556
	mult	$a0,$v0
	mfhi	$v1
	sra	$v0,$a0,31
	subu	$v1,$v1,$v0
	move	$v0,$v1
	sll	$v0,$v0,1
	addu	$v0,$v0,$v1
	subu	$v0,$a0,$v0
	sw	$v0,24($fp)
	sw	$zero,44($fp)
$L37:
	lw	$v0,44($fp)
	lw	$v1,24($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L40
	b	$L38
$L40:
	li	$a0,61			# 0x3d
	lw	$a1,68($fp)
	la	$t9,fputc
	jal	$ra,$t9
	lw	$v0,44($fp)
	addu	$v0,$v0,1
	sw	$v0,44($fp)
	b	$L37
$L38:
	move	$v0,$zero
	move	$sp,$fp
	lw	$ra,56($sp)
	lw	$fp,52($sp)
	addu	$sp,$sp,64
	j	$ra
	.end	encode
	.size	encode, .-encode
	.rdata
	.align	2
$LC0:
	.ascii	"Se encontro un caracter incorrecto en el archivo input\000"
	.text
	.align	2
	.globl	decode
	.ent	decode
decode:
	.frame	$fp,72,$ra		# vars= 32, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,72
	.cprestore 16
	sw	$ra,64($sp)
	sw	$fp,60($sp)
	sw	$gp,56($sp)
	move	$fp,$sp
	sw	$a0,72($fp)
	sw	$a1,76($fp)
	sb	$zero,24($fp)
	sw	$zero,28($fp)
	sb	$zero,32($fp)
	sw	$zero,36($fp)
	sw	$zero,40($fp)
	sb	$zero,44($fp)
	lw	$a0,72($fp)
	la	$t9,fgetc
	jal	$ra,$t9
	sb	$v0,32($fp)
$L42:
	lb	$v1,32($fp)
	li	$v0,61			# 0x3d
	beq	$v1,$v0,$L43
	lw	$v0,72($fp)
	lhu	$v0,12($v0)
	srl	$v0,$v0,5
	andi	$v0,$v0,0x1
	bne	$v0,$zero,$L43
	lbu	$v0,32($fp)
	move	$a0,$v0
	la	$t9,from64to256
	jal	$ra,$t9
	sb	$v0,32($fp)
	lbu	$v1,32($fp)
	li	$v0,255			# 0xff
	bne	$v1,$v0,$L46
	la	$v0,$LC0
	sw	$v0,msg_err
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,48($fp)
	b	$L41
$L46:
	lbu	$v0,32($fp)
	sll	$v0,$v0,2
	sb	$v0,32($fp)
	lw	$v0,28($fp)
	sw	$v0,36($fp)
	lbu	$v1,32($fp)
	lw	$v0,28($fp)
	sra	$v0,$v1,$v0
	sb	$v0,44($fp)
	lbu	$v1,24($fp)
	lbu	$v0,44($fp)
	or	$v0,$v1,$v0
	sb	$v0,24($fp)
	li	$v1,8			# 0x8
	lw	$v0,28($fp)
	subu	$v1,$v1,$v0
	sw	$v1,52($fp)
	lw	$v1,52($fp)
	slt	$v0,$v1,7
	bne	$v0,$zero,$L47
	li	$v0,6			# 0x6
	sw	$v0,52($fp)
$L47:
	lw	$v0,28($fp)
	lw	$v1,52($fp)
	addu	$v0,$v0,$v1
	sw	$v0,28($fp)
	lw	$v1,28($fp)
	li	$v0,8			# 0x8
	bne	$v1,$v0,$L48
	lbu	$v0,24($fp)
	move	$a0,$v0
	lw	$a1,76($fp)
	la	$t9,fputc
	jal	$ra,$t9
	li	$v1,8			# 0x8
	lw	$v0,36($fp)
	subu	$v0,$v1,$v0
	sw	$v0,40($fp)
	lbu	$v1,32($fp)
	lw	$v0,40($fp)
	sll	$v0,$v1,$v0
	sb	$v0,24($fp)
	li	$v1,6			# 0x6
	lw	$v0,40($fp)
	subu	$v0,$v1,$v0
	sw	$v0,28($fp)
$L48:
	lw	$a0,72($fp)
	la	$t9,fgetc
	jal	$ra,$t9
	sb	$v0,32($fp)
	b	$L42
$L43:
	sw	$zero,48($fp)
$L41:
	lw	$v0,48($fp)
	move	$sp,$fp
	lw	$ra,64($sp)
	lw	$fp,60($sp)
	addu	$sp,$sp,72
	j	$ra
	.end	decode
	.size	decode, .-decode
	.globl	input
	.globl	input
	.section	.bss
	.align	2
	.type	input, @object
	.size	input, 4
input:
	.space	4
	.globl	output
	.globl	output
	.align	2
	.type	output, @object
	.size	output, 4
output:
	.space	4
	.text
	.align	2
	.globl	freeFiles
	.ent	freeFiles
freeFiles:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	lw	$v1,input
	la	$v0,__sF
	beq	$v1,$v0,$L50
	lw	$v0,input
	beq	$v0,$zero,$L50
	lw	$a0,input
	la	$t9,fclose
	jal	$ra,$t9
	sw	$zero,input
$L50:
	lw	$v1,output
	la	$v0,__sF+88
	beq	$v1,$v0,$L49
	lw	$v0,output
	beq	$v0,$zero,$L49
	lw	$a0,output
	la	$t9,fclose
	jal	$ra,$t9
	sw	$zero,output
$L49:
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	freeFiles
	.size	freeFiles, .-freeFiles
	.rdata
	.align	2
$LC1:
	.ascii	"version\000"
	.align	2
$LC2:
	.ascii	"help\000"
	.align	2
$LC3:
	.ascii	"input\000"
	.align	2
$LC4:
	.ascii	"output\000"
	.align	2
$LC5:
	.ascii	"action\000"
	.data
	.align	2
$LC6:
	.word	$LC1
	.word	0
	.word	0
	.word	86
	.word	$LC2
	.word	0
	.word	0
	.word	104
	.word	$LC3
	.word	1
	.word	0
	.word	105
	.word	$LC4
	.word	1
	.word	0
	.word	111
	.word	$LC5
	.word	1
	.word	0
	.word	97
	.word	0
	.word	0
	.word	0
	.space	4
	.globl	memcpy
	.rdata
	.align	2
$LC7:
	.ascii	"Vhi:o:a:\000"
	.align	2
$LC8:
	.ascii	"Usage:\n"
	.ascii	"tp0 -h\n"
	.ascii	"tp0 -V\n"
	.ascii	"tp0 [options] \n"
	.ascii	"Options:\n"
	.ascii	"-V, --version Print version and quit.\n"
	.ascii	"-h, --help Print this information.\n"
	.ascii	"-i, --input Location of the input file.\n"
	.ascii	"-o, --output Location of the output file.\n"
	.ascii	"-a, --action Programa action: ecnode (default) or decode"
	.ascii	".\n"
	.ascii	"Examples:\n"
	.ascii	"tp0 -a encode -i ~/imput -o ~/output\n"
	.ascii	"tp0 -a decode\n\000"
	.align	2
$LC9:
	.ascii	"version 1\n\000"
	.align	2
$LC10:
	.ascii	"rb\000"
	.align	2
$LC11:
	.ascii	"no se pudo abrir input\000"
	.align	2
$LC12:
	.ascii	"wb\000"
	.align	2
$LC13:
	.ascii	"no se pudo abrir output\000"
	.align	2
$LC14:
	.ascii	"decode\000"
	.align	2
$LC15:
	.ascii	"encode\000"
	.align	2
$LC16:
	.ascii	"no valid action %s\000"
	.align	2
$LC17:
	.ascii	"%s\000"
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,168,$ra		# vars= 120, regs= 4/0, args= 24, extra= 8
	.mask	0xd0010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,168
	.cprestore 24
	sw	$ra,164($sp)
	sw	$fp,160($sp)
	sw	$gp,156($sp)
	sw	$s0,152($sp)
	move	$fp,$sp
	sw	$a0,168($fp)
	sw	$a1,172($fp)
	la	$v0,__sF
	sw	$v0,input
	la	$v0,__sF+88
	sw	$v0,output
	la	$v0,encode
	sw	$v0,32($fp)
	addu	$v0,$fp,40
	la	$v1,$LC6
	move	$a0,$v0
	move	$a1,$v1
	li	$a2,96			# 0x60
	la	$t9,memcpy
	jal	$ra,$t9
	li	$v0,-1			# 0xffffffffffffffff
	sb	$v0,136($fp)
$L53:
	addu	$v0,$fp,40
	sw	$zero,16($sp)
	lw	$a0,168($fp)
	lw	$a1,172($fp)
	la	$a2,$LC7
	move	$a3,$v0
	la	$t9,getopt_long
	jal	$ra,$t9
	sb	$v0,136($fp)
	lbu	$v0,136($fp)
	sll	$v0,$v0,24
	sra	$v1,$v0,24
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L55
	b	$L54
$L55:
	lb	$v0,136($fp)
	addu	$v0,$v0,-86
	sw	$v0,144($fp)
	lw	$v1,144($fp)
	sltu	$v0,$v1,26
	beq	$v0,$zero,$L68
	lw	$v0,144($fp)
	sll	$v1,$v0,2
	la	$v0,$L69
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	.cpadd	$v0
	j	$v0
	.rdata
	.align	2
$L69:
	.gpword	$L58
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L63
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L57
	.gpword	$L59
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L68
	.gpword	$L61
	.text
$L57:
	la	$a0,$LC8
	la	$t9,printf
	jal	$ra,$t9
	la	$t9,freeFiles
	jal	$ra,$t9
	sw	$zero,140($fp)
	b	$L52
$L58:
	la	$a0,$LC9
	la	$t9,printf
	jal	$ra,$t9
	la	$t9,freeFiles
	jal	$ra,$t9
	sw	$zero,140($fp)
	b	$L52
$L59:
	lw	$a0,optarg
	la	$a1,$LC10
	la	$t9,fopen
	jal	$ra,$t9
	sw	$v0,input
	lw	$v0,input
	bne	$v0,$zero,$L53
	la	$a0,$LC11
	la	$t9,perror
	jal	$ra,$t9
	la	$t9,freeFiles
	jal	$ra,$t9
	la	$t9,__errno
	jal	$ra,$t9
	lw	$v0,0($v0)
	sw	$v0,140($fp)
	b	$L52
$L61:
	lw	$a0,optarg
	la	$a1,$LC12
	la	$t9,fopen
	jal	$ra,$t9
	sw	$v0,output
	lw	$v0,output
	bne	$v0,$zero,$L53
	la	$a0,$LC13
	la	$t9,perror
	jal	$ra,$t9
	la	$t9,freeFiles
	jal	$ra,$t9
	la	$t9,__errno
	jal	$ra,$t9
	lw	$v0,0($v0)
	sw	$v0,140($fp)
	b	$L52
$L63:
	lw	$a0,optarg
	la	$a1,$LC14
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L64
	la	$v0,decode
	sw	$v0,32($fp)
	b	$L53
$L64:
	lw	$a0,optarg
	la	$a1,$LC15
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L66
	la	$v0,encode
	sw	$v0,32($fp)
	b	$L53
$L66:
	la	$a0,__sF+176
	la	$a1,$LC16
	lw	$a2,optarg
	la	$t9,fprintf
	jal	$ra,$t9
	la	$t9,freeFiles
	jal	$ra,$t9
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,140($fp)
	b	$L52
$L68:
	la	$t9,freeFiles
	jal	$ra,$t9
	li	$v1,-1			# 0xffffffffffffffff
	sw	$v1,140($fp)
	b	$L52
$L54:
	lw	$v0,32($fp)
	lw	$a0,input
	lw	$a1,output
	move	$t9,$v0
	jal	$ra,$t9
	move	$s0,$v0
	la	$t9,__errno
	jal	$ra,$t9
	sw	$s0,0($v0)
	la	$t9,freeFiles
	jal	$ra,$t9
	la	$t9,__errno
	jal	$ra,$t9
	lw	$v0,0($v0)
	bgez	$v0,$L70
	la	$a0,__sF+176
	la	$a1,$LC17
	lw	$a2,msg_err
	la	$t9,fprintf
	jal	$ra,$t9
$L70:
	la	$t9,__errno
	jal	$ra,$t9
	lw	$v0,0($v0)
	sw	$v0,140($fp)
$L52:
	lw	$v0,140($fp)
	move	$sp,$fp
	lw	$ra,164($sp)
	lw	$fp,160($sp)
	lw	$s0,152($sp)
	addu	$sp,$sp,168
	j	$ra
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
