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
	return '=';
}

int encode(FILE* input, FILE* output){
	/* padding contiene la cantidad de carecteres de relleno de la salida */
	int padding=0;
	/* char tomado del archivo input */
	unsigned char c_in=0;
	/*char que se imprime en output */
	unsigned char c_out=0;
	unsigned char mask=0;
	/* los bits de c descartados se guardan en el char discarded para ser utilizados en la formacion del
	proximo byte de salida , estos bits se acumulan en la parte mas significativa del char, o sea 
	de izquierda a derecha*/
	unsigned char discarded=0;
	/* el numero de bits acumulados en discarded se guardan en la variable acumulated*/
	int acumulated=0;
	int shift_right=0;
	int shift_left=0;
	int i=0;

	while (((char) (c_in=fgetc(input))) != EOF){
	LOOP_ENCODE:	mask=c_in;
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
				/*si acumulated es igual a 8, puedo hacer de cuenta que lei un nevo caracter del arhcivo
				por lo que igual c a discarded y salto al principio del bucle con un goto sin tener que pasar
				por la condicion del while y por lo tanto sin leer realmente un nevo char*/
				c_in=discarded;
				acumulated=0;
				discarded=0;
				goto LOOP_ENCODE;
			}
	}
	if (acumulated){
		discarded= discarded >> 2;
		fputc(from256to64(discarded), output);
	}
	padding=acumulated%3;
	for (i=0; i<padding; i++){
		fputc('=',output);
	}
	return 0;
}

int decode(FILE* input, FILE* output){
	printf("falta implementar decode");
	return 0;
}

int main(int argc, char** argv){
	/* tomo los archivos entrada y salida estandar por defectos*/
	FILE* input=stdin;
	FILE* output=stdout;
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
				break;
			case 'V':
				printf("version 1\n");
				break;
			case 'i':
				if (!(input=fopen(optarg, "r"))){
					perror("no se pudo abrir input");
					return errno;
				}
				break;
			case 'o':
				if (!(output=fopen(optarg, "w"))){
					perror("no se pudo abrir output");
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
					return -1;
				}
				break;
			default:
				return -1;
		}
	}
	errno=action(input, output);
	/*si input distinto a entrada estandar lo libero */
	if (input!=stdin){
		fclose(input);
	}
	/*si output distinto a salidad estadnar lo libero */
	if (output!=stdout){
		fclose(output);
	}
	/* retorno el valor que retorno action, no necesariamente  un error*/
	return errno; 
}	
