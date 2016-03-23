----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:14:59 03/14/2016 
-- Design Name: 
-- Module Name:    BRAM_port - Structural 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BRAM_port is
    Port ( 
		Clk_out_i 			: in STD_LOGIC;
		Clk_in_i 			: in STD_LOGIC;
		Px_enable			: in STD_LOGIC;
		Px_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0);
		Px_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0);
		Px_data_out			: out STD_LOGIC_VECTOR(23 downto 0);
		Px_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0);
		Px_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0);
		Px_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0);
		Px_data_select_in : in STD_LOGIC_VECTOR(1 downto 0);
		Px_I_select_out	: in STD_LOGIC;
		Px_S_select			: in STD_LOGIC
		);
				
end BRAM_port;

architecture Structural of BRAM_port is

	COMPONENT BRAM_5x9kb
	  PORT (
		 clka : IN STD_LOGIC;
		 ena : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 clkb : IN STD_LOGIC;
		 enb : IN STD_LOGIC;
		 addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		 doutb : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	  );
	END COMPONENT;
	
	
	
	signal Px_data_out_I0_S0				: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal Px_data_out_I1_S0				: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal Px_data_out_I0_S1				: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal Px_data_out_I1_S1				: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	
	signal Px_S0_read							: STD_LOGIC;
	signal Px_S1_read							: STD_LOGIC;

	
	signal Px_I0_S0_write			: STD_LOGIC;
	signal Px_I1_S0_write			: STD_LOGIC;
	signal Px_I0_S1_write			: STD_LOGIC;
	signal Px_I1_S1_write			: STD_LOGIC;
	
	

begin

	Px_data_out		<= Px_data_out_I0_S0 when Px_I_select_out = '0' and Px_S_select = '0' else
							Px_data_out_I1_S0 when Px_I_select_out = '1' and Px_S_select = '0' else
							Px_data_out_I0_S0 when Px_I_select_out = '0' and Px_S_Select = '1' else
							Px_data_out_I1_S1 when Px_I_select_out = '1' and Px_S_select = '1';
							
	Px_S0_read 		<= '1' when Px_S_select = '0' and Px_enable = '1' else '0';
	Px_S1_read		<= '1' when Px_S_select = '1' and Px_enable = '1' else '0';
	
	-- Px_data_select_in
	-- 00 -> no data
	-- 01 -> data for I0
	-- 10 -> data for I1
	-- 11 -> data for both I0 and I1
	
	Px_I0_S0_write <= '1' when Px_S_select = '1' and Px_data_select_in(0) = '1' and Px_enable = '1' else '0';
	Px_I1_S0_write <= '1' when Px_S_select = '1' and Px_data_select_in(1) = '1' and Px_enable = '1' else '0';
	Px_I0_S1_write <= '1' when Px_S_select = '0' and Px_data_select_in(0) = '1' and Px_enable = '1' else '0';
	Px_I1_S1_write <= '1' when Px_S_select = '0' and Px_data_select_in(1) = '1' and Px_enable = '1' else '0';
						
	
	
	Px_I0_S0 : BRAM_5x9kb
  PORT MAP (
    clka => clk_in_i,
    ena => Px_I0_S0_write,
    wea => "1",
    addra => Px_h_count_in_I0,
    dina => Px_data_in_I0,
    clkb => Clk_out_i,
    enb => Px_S0_read,
    addrb => Px_h_count_out,
    doutb => Px_data_out_I0_S0
  );
  
  Px_I1_S0 : BRAM_5x9kb
  PORT MAP (
    clka => clk_in_i,
    ena => Px_I1_S0_write,
    wea => "1",
    addra => Px_h_count_in_I1,
    dina => Px_data_in_I1,
    clkb => Clk_out_i,
    enb => Px_S0_read,
    addrb => Px_h_count_out,
    doutb => Px_data_out_I1_S0  
	);
  
  Px_I0_S1 : BRAM_5x9kb
  PORT MAP (
    clka => clk_in_i,
    ena => Px_I0_S1_write,
    wea => "1",
    addra => Px_h_count_in_I0,
    dina => Px_data_in_I0,
    clkb => Clk_out_i,
    enb => Px_S1_read,
    addrb => Px_h_count_out,
    doutb => Px_data_out_I0_S1
  );
  
  Px_I1_S1 : BRAM_5x9kb
  PORT MAP (
    clka => clk_in_i,
    ena => Px_I1_S1_write,
    wea => "1",
    addra => Px_h_count_in_I1,
    dina => Px_data_in_I1,
    clkb => Clk_out_i,
    enb => Px_S1_read,
    addrb => Px_h_count_out,
    doutb => Px_data_out_I1_S1
  );
	
	


end Structural;

