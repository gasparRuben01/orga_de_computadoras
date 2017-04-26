Archivos de Entrada
	Se encuentran en el directorio in.bin, sus nombres siguen el siguiente patron in_[n].bin, donde n es el tamanio del archivo en bytes
Salida de Encode
	Los archivos salida de encode se guardaron en out.b64, sus nombres cumplen el patron out_[n].b64. En este caso n denota que es la salida del archivo in_[n].bin
Salida de Decode
	Las salidas de decode se guardan en out.bin, sus nombres cumplen el patron out_[n].bin. La n señala que es la salida del archivo out_[n].b64

Resultados de las pruebas
	Se comparan los archivos in_[n].bin con sus correspondientes out_[n].bin, si son iguales se imprime "ok: n" en el archivo resultados.txt en caso de ser diferentes se imprime "ERROR: n". 
	Todas las pruebas dieron correctas.
