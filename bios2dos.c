struct Bios { 
	short int side; 
	short int track; 
	short int sector; 
}; 

int bios2dos (short int dos, Bios * params, Bios * result); 

int bios2dos (short int dos, Bios * params, Bios * result){ 
	short int list[4]; 
	long int product; 
	short int number; 
	short int temp; 
	short int dos1; 
	register short int * b; 
	
	short int * c; 
	short int num[4]; 
	
	dos1= dos; 
	
	list[0]= params->side; 
	list[1]= params->track; 
	list[2]= params->sector; 
	list[3]= 0; 
	
	product= params->side * params->track * params-> sector; 
	
	c= &num[0]; 
	
	b= &list[0]; 
	while (&list[3] > b){ 
		number= (*b) * dos1 / product; 
		
		if (b < &list[2]){ 
			if (!(*b) * dos1 % product) number--; 
		} else { 
			if ( (*b) * dos1 % product) number++; 
		} 
		
		temp= number; 
		
		number= number / (*b); 
		
		dos1 += 0 - (temp * number); 
		
		*c= temp; 
		
		c += 2; 
		
		b += 2; 
	} 
	
	result->side= num[0]; 
	result->track= num[1]; 
	result->sector= num[2]; 
	
	return 0; 
} 