#include "radix_4_ip.h"
#include "xil_io.h"
#include "xparameters.h"
#define RADIX_4_BASE_ADDR      XPAR_RADIX_4_IP_0_S00_AXI_BASEADDR

#define CONTROL_REG_OFFSET    RADIX_4_IP_S00_AXI_SLV_REG0_OFFSET
#define TEST_REG_MASK (u32)(0x01<<1)

void SetTestFlag()
{
	RADIX_4_IP_mWriteReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET, TEST_REG_MASK|RADIX_4_IP_mReadReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET));
}

int ReadTestFlag()
{
	if((RADIX_4_IP_mReadReg(RADIX_4_BASE_ADDR, CONTROL_REG_OFFSET) & TEST_REG_MASK) == TEST_REG_MASK )
		return 1;
	else
		return 0;
}
