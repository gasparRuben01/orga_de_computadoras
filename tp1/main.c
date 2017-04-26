#include <stdio.h>
#include <getopt.h>
#include <errno.h>
#include <string.h>
#include "base64.h"

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
	int (*action)(int,int)=base64_encode;
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
					action=base64_decode;
				}else if (!strcmp(optarg, "encode")){
					action=base64_encode;
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
	errno=action(fileno(input), fileno(output));
	freeFiles();
	if (errno<0){
		fprintf(stderr, "%s", errmsg[errno]);
	}
	/* retorno el valor que retorno action, no necesariamente  un error*/
	return errno; 
}	
