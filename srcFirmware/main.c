/*
 * main.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "NumberPrint.h"
#include "multiplication.h"
#include "TestFlag.h"

int main()
{
s8 x_value, y_value;
s16 result;

    init_platform();

    while(1){
    	print("Enter First Value to multiply (T if you want to generate signature): ");
    	x_value = readDecVal();
    	print("\n\r");
    	if(ReadTestFlag())
    	{
    		print("Test Mode activated");
    		y_value = 0;
    	}
    	else
    	{
    		print("Enter Second Value to multiply: ");
    		y_value = readDecVal();
    	}
    	print("\n\r");

    	//data_in = x_value | (y_value << 8);
    	//printDecVal(data_in);
    	calculateRadixResult(x_value, y_value, &result);
    	xil_printf("Result is %d:", result);
    	print("\n\r");
    	newMultiplication();
    }

}
