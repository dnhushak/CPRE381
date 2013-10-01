

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

char * int2bin(int i, int numbits)
{
    size_t bits = numbits;

    char * str = malloc(bits + 1);
    if(!str) return NULL;
    str[bits] = 0;

    // type punning because signed shift is implementation-defined
    unsigned u = *(unsigned *)&i;
    for(; bits--; u >>= 1)
    	str[bits] = u & 1 ? '1' : '0';

    return str;
}

int main(){
	int i;
	for (i = 0; i<32; i++){
		printf("i_X(%d) when i_C = \"%s\" ELSE\n", i, int2bin(i,5));

	}


}

