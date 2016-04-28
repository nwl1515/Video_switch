#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xiomodule.h"

void print(char *str);

void wait()
{
	volatile u8 r;
	for(r = 0; r< 10; r++)
		asm("nop");
}

int main()
{
    init_platform();
    u32 data;
    u32 data_gpo_1;
    u32 data_gpo_2;
    u32 data_gpo_3;
    u8 i;
    u8 rx_buf;
    XIOModule gpo;
    XIOModule iomodule;

    print("Init GPO\n\r");
    data = XIOModule_Initialize(&gpo, XPAR_IOMODULE_0_DEVICE_ID);
    data = XIOModule_Start(&gpo);
    print("GPO init done\n\r");

    print("Init UART recv\n\r");
    data = XIOModule_CfgInitialize(&iomodule, NULL, 1);
    print("UART init done\n\r");


    print("Send configuration in the following format:\n\r");
    print("String 1: Screen select [3 bytes bin)\n\r");
    print("String 2: Configuration [4 bytes bin)\n\r");
    print("String 3: Set_1 [12 bytes bin]\n\r");
    print("String 4: Set_2 [12 bytes bin]\n\r");
    print("String 5: Set_3 [12 bytes bin]\n\r");
    print("String 6: Set_4 [12 bytes bin]\n\r");

    while(1)
    {
		data_gpo_1 = 0;
		print("\n\rReceiving Sel:\n\r");
		for(i = 0; i<3; i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1)
				data_gpo_1 |= 1 << (6-i);
		}

		print("\n\rReceiving Conf:\n\r");
		for(i = 0; i<4;i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1 )
				data_gpo_1 |= 1 << (3-i);
		}

		XIOModule_DiscreteWrite(&gpo, 1, data_gpo_1);

		data_gpo_2 = 0;
		print("\n\rReceiving Set_1:\n\r");
		for(i = 0; i<12; i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1)
				data_gpo_2 |= 1 << (23-i);
		}
		print("\n\rReceiving Set_2:\n\r");
		for(i = 0; i<12; i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1)
				data_gpo_2 |= 1 << (11-i);
		}

		XIOModule_DiscreteWrite(&gpo, 2, data_gpo_2);

		data_gpo_3 = 0;
		print("\n\rReceiving Set_3:\n\r");
		for(i = 0; i<12; i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1)
				data_gpo_3 |= 1 << (23-i);
		}
		print("\n\rReceiving Set_4:\n\r");
		for(i = 0; i<12; i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1)
				data_gpo_3 |= 1 << (11-i);
		}

		XIOModule_DiscreteWrite(&gpo, 3, data_gpo_3);

		wait();

		data_gpo_1 |= 1 << 7;
		XIOModule_DiscreteWrite(&gpo, 1, data_gpo_1);

		wait();

		data_gpo_1 = 0;
		XIOModule_DiscreteWrite(&gpo, 1, data_gpo_1);



		print("\n\rData set\n\r");


    }










    cleanup_platform();
    return 0;
}
