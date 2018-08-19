#include <stdio.h> 

int str2i(char * string); 
int atoi(char * the_string); 

int main(int argc, char * argv[]){ 
	if (argc < 2) return 0; 
	printf("%d", atoi(argv[1])); 
} 

#include "str2i.c" 