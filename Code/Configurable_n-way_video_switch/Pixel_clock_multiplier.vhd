----------------------------------------------------------------------------------
-- Company: SDU
-- Engineer: Nikolaj Leth
-- 
-- Create Date:    17:39:03 02/14/2016 
-- Design Name:    Configurable n-way video switch
-- Module Name:    Pixel Clock Multiplier
-- Project Name:   Configurable n-way video switch - Bachelor project
-- Target Devices: Spartan 6 (Diligent Atlys)
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
use UNISIM.VComponents.all;


entity Pixel_clock_multiplier is
	PORT(
		pclk_in			: in STD_LOGIC := '0';
		pclk_o_x1		: out STD_LOGIC := '0';
		pclk_o_x2		: out STD_LOGIC := '0';
		pclk_o_x10_b0	: out STD_LOGIC := '0';
		pclk_o_x10_b2  : out STD_LOGIC := '0';
		pll_locked		: out STD_LOGIC := '0';
		serdes_strobe_b0	: out STD_LOGIC := '0';
		serdes_strobe_b2 : out STD_LOGIC := '0'
	);
end Pixel_clock_multiplier;

architecture Behavioral of Pixel_clock_multiplier is

	signal pclk_x1		: std_logic := '0';
	signal pclk_x2		: std_logic := '0';
	signal pclk_x10	: std_logic := '0';
	signal pclk_x2_b	: std_logic := '0';
	signal pll_locked_i : std_logic := '0';
	signal clk_feedback : std_logic := '0';
	

	begin

	pclk_o_x2 <= pclk_x2_b;
	pll_locked <= pll_locked_i;
-----------------------------------------
-- PLL BASE
-- Input: pclk
-- Output: pclk_x1, pclk_x2, pclk_x10 unbuffered, pll_locked
-----------------------------------------	
		pclk_multipler : PLL_BASE
		generic map(
			CLKFBOUT_MULT		=> 10,
			CLKOUT0_DIVIDE		=> 1,
			CLKOUT1_DIVIDE		=> 5,
			CLKOUT2_DIVIDE		=> 10,
			CLK_FEEDBACK		=> "CLKFBOUT",
			CLKIN_PERIOD		=> 10.0,
			DIVCLK_DIVIDE		=> 1
		)
		PORT map(
			CLKFBOUT				=> clk_feedback,
			CLKOUT0				=> pclk_x10,
			CLKOUT1				=> pclk_x2,
			CLKOUT2				=> pclk_x1,
			CLKOUT3				=> open,
			CLKOUT4				=> open,
			CLKOUT5				=> open,
			LOCKED				=> pll_locked_i,
			CLKFBIN				=> clk_feedback,
			CLKIN					=> pclk_in,
			RST					=> '0'
		);

-------------------------------------------
-- Buffer all signals from PLL Base
-------------------------------------------
		buffer_pclk_x1 : BUFG
		PORT map(
			I 						=> pclk_x1,
			O						=> pclk_o_x1
		);
		
		buffer_pclk_x2 : BUFG
		PORT map(
			I						=> pclk_x2,
			O						=> pclk_x2_b
		);
		
		buffer_pclk_x10_PLL_buff_b0: BUFPLL
		generic map(
			DIVIDE				=> 5
		)
		PORT map(
			PLLIN					=> pclk_x10,
			GCLK					=> pclk_x2_b,
			LOCKED				=> pll_locked_i,
			IOCLK					=> pclk_o_x10_b0,
			SERDESSTROBE		=> serdes_strobe_b0,
			LOCK					=> open
		);
		
		buffer_pclk_x10_PLL_buff_b2: BUFPLL
		generic map(
			DIVIDE				=> 5
		)
		PORT map(
			PLLIN					=> pclk_x10,
			GCLK					=> pclk_x2_b,
			LOCKED				=> pll_locked_i,
			IOCLK					=> pclk_o_x10_b2,
			SERDESSTROBE		=> serdes_strobe_b2,
			LOCK					=> open
		);
			

end Behavioral;

