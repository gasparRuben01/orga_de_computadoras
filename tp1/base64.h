/* traduce codigo en base 256 a 64 */
int base64_encode(int infd, int outfd);

/*trauduce co³digo en base 64 a 256 */
int base64_decode(int infd, int outfd);

/*codigos de error de las funciones */
extern char* errmsg[2];
