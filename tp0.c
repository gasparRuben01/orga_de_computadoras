#include <stdio.h>
#include <getopt.h>
#include <errno.h>
#include <string.h>

int encode(FILE* input, FILE* output){
	return 0;
}

int decode(FILE* input, FILE* output){
	return 0;
}

int main(int argc, char** argv){
	/* tomo los archivos entrada y salida estandar por defectos*/
	FILE* input=stdin;
	FILE* output=stdout;

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
				}
				return errno;
			case 'o':
				if (!(output=fopen(optarg, "w"))){
					perror("no se pudo abrir output");
				}
				return errno;
				
			case 'a':
				if (!strcmp(optarg, "decode")){
					decode(input, output);
				}else if (!strcmp(optarg, "encode")){
					encode(input, output);
				}else{
					fprintf(stderr, "no valid action %s", optarg);
					errno=-1;
				}
				/* si los archivos no son los standars los cierro*/
				if (input!=stdin){
					fclose(input);
				}
				if (output!=stdout){
					fclose(output);
				}
				return errno;
			default:
				return -1;
		}
	}
	return 0;
}	
