Se crearon 3 archivos de pruebas, de tamanios 10, 100 y 1000.
Estos archivos se generaron con urandom y se guardaron en el directorio in.bin.
Luego se encodearon y sus respectivas salidas se guardaron en el directorio out.base64
Después se decodearon y sus respectivas salidas se gurdaron el el directorio out.bin
La prueba consistio en ver si el archivo original es igual a su decodeado.
El fromato de los archivos es así
original: in_n_bytes.bin
encodeado: out_n_bytes.base64
decodeado: out_n_bytes.bin
Donde n es la cantidad de bytes en el archivos

También se generarón los archivos err1, err2 y err3. Estos archivos provocan un mensaje de error intencionalmente
cuando se decodean

err1: caracter invalido; mensaje de error: "ascii no valido encontrado en el archivo"
err2: omite nueva linea despues de 76 caracteres; mensaje de error: "archivo mal formado"
err3: no es multiplo de 4 bytes; mensaje de error: "archivo mal formado"

