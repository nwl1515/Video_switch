#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xiomodule.h"

void print(char *str);

char inbyte(void);

// Small wait function, to be sure registers are set.
void wait()
{
	volatile u8 r;
	for(r = 0; r< 10; r++)
		asm("nop");
}

int main()
{
	// Init the UART
    init_platform();

    u32 data_gpo_1;
    u32 data_gpo_2;
    u32 data_gpo_3;
    u8 i;
    u8 rx_buf;
    XIOModule gpo;
    XIOModule iomodule;

    // Init GPO
    print("Init GPO\n\r");
    XIOModule_Initialize(&gpo, XPAR_IOMODULE_0_DEVICE_ID);
    XIOModule_Start(&gpo);
    print("GPO init done\n\r");

    // INIT UART recv
    print("Init UART recv\n\r");
    XIOModule_CfgInitialize(&iomodule, NULL, 1);
    print("UART init done\n\r");

    // Informational text
    print("Send configuration in the following format:\n\r");
    print("String 1: Screen select [3 bytes bin)\n\r");
    print("String 2: Configuration [4 bytes bin)\n\r");
    print("String 3: Set_1 [12 bytes bin]\n\r");
    print("String 4: Set_2 [12 bytes bin]\n\r");
    print("String 5: Set_3 [12 bytes bin]\n\r");
    print("String 6: Set_4 [12 bytes bin]\n\r");

    while(1)
    {
    	// Receive the screen selection
		data_gpo_1 = 0;
		print("\n\rReceiving Sel:\n\r");
		for(i = 0; i<3; i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1)
				data_gpo_1 |= 1 << (6-i);
		}

		// Receive the configuration for the selected screen
		print("\n\rReceiving Conf:\n\r");
		for(i = 0; i<4;i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1 )
				data_gpo_1 |= 1 << (3-i);
		}

		// Output the selection and configuration on GPO_1
		XIOModule_DiscreteWrite(&gpo, 1, data_gpo_1);

		// Receive the Set_1
		data_gpo_2 = 0;
		print("\n\rReceiving Set_1:\n\r");
		for(i = 0; i<12; i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1)
				data_gpo_2 |= 1 << (23-i);
		}

		// Receive the Set_2
		print("\n\rReceiving Set_2:\n\r");
		for(i = 0; i<12; i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1)
				data_gpo_2 |= 1 << (11-i);
		}

		// Output Set_1 and Set_2 in GPO_2
		XIOModule_DiscreteWrite(&gpo, 2, data_gpo_2);


		// Receive the Set_3
		data_gpo_3 = 0;
		print("\n\rReceiving Set_3:\n\r");
		for(i = 0; i<12; i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1)
				data_gpo_3 |= 1 << (23-i);
		}

		// Receive the Set_4
		print("\n\rReceiving Set_4:\n\r");
		for(i = 0; i<12; i++)
		{
			rx_buf = inbyte();
			if( (rx_buf - '0') == 1)
				data_gpo_3 |= 1 << (11-i);
		}

		// Output Set_3 and Set_4 in GPO_3
		XIOModule_DiscreteWrite(&gpo, 3, data_gpo_3);

		// Wait to be sure all registers are set.
		wait();

		// Output the "enable" signal
		// to indicate the configuration is ready.
		data_gpo_1 |= 1 << 7;
		XIOModule_DiscreteWrite(&gpo, 1, data_gpo_1);

		// Wait a short time.
		wait();

		// Set the "enable" signal low again
		// while a new configuration is received.
		data_gpo_1 = 0;
		XIOModule_DiscreteWrite(&gpo, 1, data_gpo_1);



		print("\n\rData set\n\r");


    }

    // Clean up
    cleanup_platform();
    return 0;
}
