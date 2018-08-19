int str2i(char * string){ 
	char * a= string; 
	char * b; 
	int exp10; 
	int sum= 0; 
	
	// Skip over any leading spaces. 
	while (*a == 32 || *a == 9 || *a == 13 || *a == 10) a++; 
	
	// If the input is not a number (such as "" or "abcd") then return 0. 
	if (*a < 48 || *a !< 58) return 0; 
	
	// Get 10^(however many digits there are (for the integer part only)). 
	b= a; 
	exp10= 1; 
	while (*b >= 48 && *b < 58){ 
		exp10 *= 10; 
		b++; 
	} 
	exp10 /= 10; 
	
	// (10^0 = 1; 10^1 = 10; 10^2 = 100; 10^3 = 1000; and so on...) 
	
	// Do some work. It's kind of hard to explain, in words, what the work is. 
	b= a; 
	do { 
		// 48 (ASCII code) means '0', 49 means '1', and so on. 
		// So we convert the ASCII code from the string into a 
		// number, by subtracting 48 from it. 
		// Then we add that number times 10^(position of the 
		// digit) to the overall sum. 
		sum += (*b - 48) * exp10; 
		
		// We then update our 10^(position of ...) variable by 
		// dividing it by 10. 
		exp10 /= 10; 
		
		// So if the number was "172" then it would be something like: 
		// sum= (1 * 100) + (7 * 10) + (2 * 1) 
		
		// We then go on to the next character in the string, 
		// by incrementing our pointer. 
		b++; 
	} while (exp10); 
	// The loop ends when our 10^(...) value reaches 0. 
	// And of course that value does need to be an integer 
	// for the loop to ever end. 
	
	return sum; 
} 
int atoi(char * the_string){ 
	char * a= the_string; 
	
	// Skip over any leading spaces. 
	while (*a == 32 || *a == 9 || *a == 13 || *a == 10) a++; 
	
	// If the string is negative ...  
	// ASCII 45 means the character '-'. 
	// We don't want the program to be stuck in an 
	// endless loop and raise an exception when 
	// it reaches the end of the stack, so we 
	// want to increment the pointer to the 
	// character. 
	if (*a == 45) return 0 - atoi(a + 1); 
	
	return str2i(a); 
} 