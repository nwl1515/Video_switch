----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:36:55 02/26/2016 
-- Design Name: 
-- Module Name:    Serializer_5_to_1 - Structural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.ALL;


entity Serializer_5_to_1 is
    Port ( Pixel_clock_x2 : in  STD_LOGIC;
           Pixel_clock_x10 : in  STD_LOGIC;
           Serdes_strobe : in  STD_LOGIC;
           Input_n5 : in  STD_LOGIC_VECTOR (4 downto 0);
           Output_n1 : out  STD_LOGIC);
end Serializer_5_to_1;

architecture Structural of Serializer_5_to_1 is

	signal cascade1			: std_logic;
	signal cascade2			: std_logic;
	signal cascade3			: std_logic;
	signal cascade4			: std_logic;

begin

------------------------------------
-- Master Output Serializer
-- Input: Slave and msb of data
-- Output: Serialized data
------------------------------------
	master_OSERDES : OSERDES2
	generic map(
			BYPASS_GCLK_FF	=> FALSE,
			DATA_RATE_OQ	=>	"SDR",
			DATA_RATE_OT	=> "SDR",
			DATA_WIDTH		=> 5,
			OUTPUT_MODE		=> "SINGLE_ENDED",
			SERDES_MODE		=> "MASTER",
			TRAIN_PATTERN	=> 0)
	port map(
			OQ					=> Output_n1,
			SHIFTOUT1		=> cascade1,
			SHIFTOUT2		=> cascade2,
			SHIFTOUT3		=> Open,
			SHIFTOUT4		=> Open,
			SHIFTIN1			=> '1',
			SHIFTIN2			=> '1',
			SHIFTIN3			=> cascade3,
			SHIFTIN4			=> cascade4,
			TQ					=> Open,
			CLK0				=> Pixel_clock_x10,
			CLK1				=> '0',
			CLKDIV			=> Pixel_clock_x2,
			D1					=> Input_n5(4),
			D2					=> '0',
			D3					=> '0',
			D4					=> '0',
			IOCE				=> Serdes_strobe,
			OCE				=> '1',
			RST				=> '0',
			T1					=> '0',
			T2					=> '0',
			T3					=> '0',
			T4					=> '0',
			TCE				=> '1',
			TRAIN				=> '0'
	);
	
	------------------------------------
-- Slave Output Serializer
-- Input: 4 lsb of data
-- Output: data to master
------------------------------------
	slave_OSERDES : OSERDES2
	generic map(
			BYPASS_GCLK_FF	=> FALSE,
			DATA_RATE_OQ	=>	"SDR",
			DATA_RATE_OT	=> "SDR",
			DATA_WIDTH		=> 5,
			OUTPUT_MODE		=> "SINGLE_ENDED",
			SERDES_MODE		=> "SLAVE",
			TRAIN_PATTERN	=> 0)
	port map(
			OQ					=> Open,
			SHIFTOUT1		=> Open,
			SHIFTOUT2		=> Open,
			SHIFTOUT3		=> cascade3,
			SHIFTOUT4		=> cascade4,
			SHIFTIN1			=> cascade1,
			SHIFTIN2			=> cascade2,
			SHIFTIN3			=> '1',
			SHIFTIN4			=> '1',
			TQ					=> Open,
			CLK0				=> Pixel_clock_x10,
			CLK1				=> '0',
			CLKDIV			=> Pixel_clock_x2,
			D1					=> Input_n5(0),
			D2					=> Input_n5(1),
			D3					=> Input_n5(2),
			D4					=> Input_n5(3),
			IOCE				=> Serdes_strobe,
			OCE				=> '1',
			RST				=> '0',
			T1					=> '0',
			T2					=> '0',
			T3					=> '0',
			T4					=> '0',
			TCE				=> '1',
			TRAIN				=> '0'
	);



end Structural;

