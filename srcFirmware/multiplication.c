/***************************** Include Files *********************************/
#include "xil_io.h"
#include "xparameters.h"
#include "radix_4_ip.h"
#include <stdio.h>
#include "NumberPrint.h"
#include "multiplication.h"

/**************************** user definitions ********************************/

//RADIX_4 processor base addres redefinition
#define RADIX_4_BASE_ADDR      XPAR_RADIX_4_IP_0_S00_AXI_BASEADDR
//Cordic processor registers' offset redefinition
#define CONTROL_REG_OFFSET    RADIX_4_IP_S00_AXI_SLV_REG0_OFFSET
#define DATA_REG_OFFSET      RADIX_4_IP_S00_AXI_SLV_REG1_OFFSET
#define STATUS_REG_OFFSET     RADIX_4_IP_S00_AXI_SLV_REG2_OFFSET
#define RESULT_REG_OFFSET    RADIX_4_IP_S00_AXI_SLV_REG3_OFFSET
//Cordic processor bits masks
#define CONTROL_REG_START_MASK (u32)(0x01)
#define STATUS_REG_READY_MASK (u32)(0x01)
#define NEW_MULTIPLICATION_REG_MASK (u32)(0x01<<2)
#define TEST_REG_MASK (u32)(0x01<<1)

// Macros to extract multiplication result from the accelerator output data register
// Shift left and right to fill msb of int32_t with ones - arithmetic shift  
#define RESULT_REG_RADIX_4(param)  ((s32)param & (s32)0x0000FFFF)


/***************************** calculateCordicVal function **********************
* The function runs the cordic accelerator IP
* Argument:
* x_value - input x value as an integer.
* y_value - input y value as an integer.
* Return values:
* result - multiplication result.
*
*
*/


int calculateRadixResult(s8 x, s8 y,  s16* result)
{
    s16 radix_result;

    //Send data to data register of RADIX_4 processor
    //xil_printf("x %d:", x);
    //xil_printf("y %d:", y);
    RADIX_4_IP_mWriteReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET, RADIX_4_IP_mReadReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET)&(~CONTROL_REG_START_MASK));

    RADIX_4_IP_mWriteReg(RADIX_4_BASE_ADDR, DATA_REG_OFFSET, ((s32)x&(0x000000FF))|((s32)y&(0x000000FF))<<8);

    //radix_result = RADIX_4_IP_mReadReg(RADIX_4_BASE_ADDR, DATA_REG_OFFSET);
    //xil_printf("DATA_REG_OFFSET %u:", radix_result);

    //Start Booth Multiplication (Radix 4) processor - pulse start bit in control register
    RADIX_4_IP_mWriteReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET, RADIX_4_IP_mReadReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET)&(~NEW_MULTIPLICATION_REG_MASK));
    RADIX_4_IP_mWriteReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET, RADIX_4_IP_mReadReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET)|(CONTROL_REG_START_MASK));
    // Clear the control register (pulse the start bit)
    RADIX_4_IP_mWriteReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET, RADIX_4_IP_mReadReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET)&(~CONTROL_REG_START_MASK));


    //Wait for ready bit in status register
    while( (RADIX_4_IP_mReadReg(RADIX_4_BASE_ADDR, STATUS_REG_OFFSET) & STATUS_REG_READY_MASK) == 0){
    };

    //Get results
    radix_result = RADIX_4_IP_mReadReg(RADIX_4_BASE_ADDR, RESULT_REG_OFFSET); // You had 'result =' here, but result is a pointer,
                                                                               // and you need to assign to a local var 'radix_result' first.
    //Extract sin and cos from 32-bit register data
    *result = RESULT_REG_RADIX_4( radix_result ); // Assign the processed value to the pointer passed in

    return 1;
}

void newMultiplication(){
	RADIX_4_IP_mWriteReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET, NEW_MULTIPLICATION_REG_MASK);
	RADIX_4_IP_mWriteReg(RADIX_4_BASE_ADDR, DATA_REG_OFFSET, 0);

}
