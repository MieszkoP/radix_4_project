#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "NumberPrint.h"
#include "TestFlag.h"

s8 readDecVal() {
    char8 buf[5]; // Enough to store up to minus sign + 3 digits + null terminator
    int i = 0;
    char8 c;


    // Read characters until Enter is pressed or max 3 digits are read
    while (i < 4) {
        c = inbyte();     // Read character
        if (c== 'T')
        {
        	SetTestFlag();
        	return 0;
        }
        if (c == '-'){
        	outbyte(c);
        	buf[i++] = c;
        }
        if (c == '\r' || c == '\n')  // Enter key
            break;
        if (c >= '0' && c <= '9') {  // Valid digit
            outbyte(c);             // Echo it back
            buf[i++] = c;
        }
    }

    buf[i] = '\0';  // Null-terminate the string

    // Convert string to integer
    s8 ret = 0;
    s8 d = 1;
    for (int j = 0; j < i; j++) {
    	if(buf[j]=='-')
    		d = -1;
    	else
        ret = ret * 10 + (buf[j] - '0');
    }

    return d*ret;
}


/*
void printDecVal(u32 value) {
    char buffer[11]; // Max digits in 32-bit unsigned int + null terminatorb
    int i = 0;

    // Handle zero explicitly
    if (value == 0) {
        outbyte('0');
        return;
    }

    // Convert number to string in reverse
    while (value > 0 && i < 10) {
        buffer[i++] = (value % 10) + '0';
        value /= 10;
    }

    // Print the digits in correct order
    while (i-- > 0) {
        outbyte(buffer[i]);
    }
}
*/
