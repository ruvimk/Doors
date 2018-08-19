#include <stdlib.h>; 
#include <stdio.h>; 

#include "bios2dos.c"; 

int main (int argc, char * argv[]){ 
	const char string1[512]; 
	short int sector1; 
	
	Bios * params; 
	
	Bios * test; 
	
	params->side= 2; 
	params->track= 40960; 
	params->sector= 18; 
	
	puts("Enter the sector number: "); 
	gets(string1); 
	
	sector1= atoi(string1); 
	
	
	
	return 0; 
} 