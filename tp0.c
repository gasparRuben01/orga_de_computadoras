#include <stdio.h>
#include <getopt.h>
#include <errno.h>
#include <string.h>

#define BITS_PER_BYTE 6
/* macros con los ultimos valores de mapeos entre
los 64 valores y sus correspondientes grupos de caracteres ascii */
#define INDX_LAST_UPPER_LETTER 25
#define INDX_LAST_LOWER_LETTER 51
#define INDX_LAST_DIGIT 61
#define MAP_PLUS_SIMBOL 62
#define MAP_BAR 63
#define PADDING_CHAR '='

#define MIN(a,b) (((a)<(b)) ? (a) : (b))

/* transforma el caracter c al caracter ascii de base 64 correspondiente */
unsigned char from256to64(unsigned char c){
	if (c<=INDX_LAST_UPPER_LETTER){
		return c+'A';
	}
	if (c<=INDX_LAST_LOWER_LETTER){
		return (c-INDX_LAST_UPPER_LETTER-1)+'a';	
	}	
	if (c<=INDX_LAST_DIGIT){
		return (c-INDX_LAST_LOWER_LETTER-1)+'0';
	}
	if (c==MAP_PLUS_SIMBOL){
		return '+';
	}
	if (c==MAP_BAR){
		return '/';
	}
	return PADDING_CHAR;
}

unsigned char from64to256(unsigned char c){
	if (c>='A' && c<='Z'){
		return c-'A';
	}
	if (c>='a' && c<='z'){
		return INDX_LAST_LOWER_LETTER-('z'-c);
	}
	if (c>='0' && c<='9'){
		return INDX_LAST_DIGIT-('9'-c);
	}
	if (c=='+'){
		return MAP_PLUS_SIMBOL;
	}
	if (c=='/'){
		return MAP_BAR;
	}
	if (c==PADDING_CHAR){
		return 0x3F;
	}
	/*en case de haber un caracter malo, retorno el codigo de error 0xFFFF */
	return 0xFF;
}

/* en la variable msg_err se guarda el error producido en las funciones encode o decode */
char* msg_err=NULL;

int encode(FILE* input, FILE* output){
	/* padding contiene la cantidad de carecteres de relleno de la salida */
	int padding=0;
	/* c_in: char tomado del archivo input */
	unsigned char c_in=0;
	/*c_out: char que se imprime en output */
	unsigned char c_out=0;
	unsigned char mask=0;
	/* los bits de c_in descartados se guardan en el char discarded para ser utilizados en la formacion del
	proximo byte de salida , estos bits se acumulan en la parte mas significativa del char, o sea 
	de izquierda a derecha*/
	unsigned char discarded=0;
	/* el numero de bits acumulados en discarded se guardan en la variable acumulated*/
	int acumulated=0;
	int shift_right=0;
	int shift_left=0;
	int i=0;
	
	c_in=fgetc(input);
	while (!feof(input)){
		mask=c_in;
		/* tomo los bits que necesita c_out para formar un byte */
		shift_left=8-BITS_PER_BYTE+acumulated;
		mask=mask >> shift_left;
		/* primero agrego los bytes desechados en la anterior lectura */
		c_out=c_out | discarded;
		c_out=c_out >> 2;
		c_out=c_out | mask; 
		/* convierto c_out a ascii antes de imprimirlo */
		fputc(from256to64(c_out), output);
		c_out=0;
		/* los bits desechados en el shift se aucmulan en c_out */
		acumulated=shift_left;
		discarded=c_in;
		shift_right=8-shift_left;
		discarded=discarded << shift_right;
		if (acumulated==8){
			/*si acumulated es igual a 8, puedo hacer de cuenta que lei un nevo caracter del arhchivo
			por lo que igualo c_in a discarded y no leo un nuevo caracter */
			c_in=discarded;
			acumulated=0;
			discarded=0;
		}else{
			c_in=fgetc(input);
		}
	}

	if (acumulated){
		discarded= discarded >> 2;
		fputc(from256to64(discarded), output);
	}
	padding=acumulated%3;
	for (i=0; i<padding; i++){
		fputc(PADDING_CHAR, output);
	}
	return 0;
}

int decode(FILE* input, FILE* output){
	/* char a ser impreso en la salida */	
	unsigned char c_out=0;
	/* c_out_pivot apunta al ultimo bit (de izquierda a derecha) valido en c_out_load */
	int c_out_pivot=0;
	unsigned char c_in=0;	
	int shift_left=0;
	int shift_right=0;
	unsigned char mask=0;

	c_in=fgetc(input);
	while (((char) c_in)!=PADDING_CHAR && !feof(input)){
		c_in=from64to256(c_in);		
		if (c_in==0xFF){
			msg_err="Se encontro un caracter incorrecto en el archivo input";
			return -1;
		}
		c_in=c_in<<2;
		shift_left=c_out_pivot;
		mask=c_in >> c_out_pivot;
		c_out=c_out|mask;
		c_out_pivot+=MIN(8-c_out_pivot, 6);
		if (c_out_pivot==8){
			fputc(c_out, output);
			shift_right=8-shift_left;
			c_out=c_in << shift_right;
			c_out_pivot=6-shift_right;
		}		
		c_in=fgetc(input);
		
	}
	return 0;
}

FILE* input=NULL;
FILE* output=NULL;

/* cierra los archivos input y output, verificando antes si se tratan de los arhivos estandars o sin NULL,
debe invocarse antes de un return */
void freeFiles(){
	if (input!=stdin && input!=NULL){
		fclose(input);
		input=NULL;
	}
	if (output!=stdout && output!=NULL){
		fclose(output);
		output=NULL;
	}
}

int main(int argc, char** argv){
	/*tomo por defecto los archivos estandar*/
	input=stdin;
	output=stdout;
	/* action apunta a la funcion a correr */
	int (*action)(FILE*,FILE*)=encode;
	/* inicialiso las opciones largas*/
	struct option long_options[]={
                {"version", no_argument, NULL, 'V'},
                {"help", no_argument, NULL, 'h'},
                {"input", required_argument, NULL, 'i'},
                {"output", required_argument, NULL, 'o'},
                {"action", required_argument, NULL, 'a'},
                {0,0,0}
        };

	char option=-1;
	while ((option=getopt_long(argc, argv, "Vhi:o:a:", long_options, NULL))!=-1){
		switch(option){
			case 'h':
				printf("Usage:\n"
						"tp0 -h\n"
						"tp0 -V\n"
						"tp0 [options] \n"
					"Options:\n"
						"-V, --version Print version and quit.\n"
						"-h, --help Print this information.\n"
						"-i, --input Location of the input file.\n"
						"-o, --output Location of the output file.\n"
						"-a, --action Programa action: ecnode (default) or decode.\n"
					"Examples:\n"
						"tp0 -a encode -i ~/imput -o ~/output\n"
						"tp0 -a decode\n");
				/* el usario podria invocar tp0 -i input -h, por eso libero los archivos, aunque no tendria que pasar*/
				freeFiles();
				return 0;
			case 'V':
				printf("version 1\n");
				freeFiles();
				return 0;
			case 'i':
				if (!(input=fopen(optarg, "rb"))){
					perror("no se pudo abrir input");
					freeFiles();
					return errno;
				}
				break;
			case 'o':
				if (!(output=fopen(optarg, "wb"))){
					perror("no se pudo abrir output");
					freeFiles();
					return errno;
				}
				break;	
			case 'a':
				if (!strcmp(optarg, "decode")){
					action=decode;
				}else if (!strcmp(optarg, "encode")){
					action=encode;
				}else{
					fprintf(stderr, "no valid action %s", optarg);
					freeFiles();
					return -1;
				}
				break;
			default:
				freeFiles();
				return -1;
		}
	}
	errno=action(input, output);
	freeFiles();
	if (errno<0){
		fprintf(stderr, "%s", msg_err);
	}
	/* retorno el valor que retorno action, no necesariamente  un error*/
	return errno; 
}	
