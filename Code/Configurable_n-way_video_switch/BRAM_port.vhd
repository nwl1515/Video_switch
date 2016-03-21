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
		Clk_out_i 			: STD_LOGIC;
		Clk_in_I0_i 		: STD_LOGIC;
		Clk_in_I1_i			: STD_LOGIC;
		Clk_in_I0_h_i		: STD_LOGIC;
		Clk_in_I1_h_i 		: STD_LOGIC;	
		S_selector_i		: STD_LOGIC;
		S_selector_i_n		: STD_LOGIC;
		H_count_I0			: STD_LOGIC_vector(10 downto 0);
		H_count_I0_h		: STD_LOGIC_vector(10 downto 0);
		H_count_I1			: STD_LOGIC_vector(10 downto 0);
		H_count_I1_h		: STD_LOGIC_vector(10 downto 0);
		Px_enable			: STD_LOGIC;
		Px_Ih_select		: STD_LOGIC;
		PX_I_select_out	: STD_LOGIC;
		Px_H_count_out		: STD_LOGIC_VECTOR(10 downto 0);
		Px_data_in_I0		: STD_LOGIC_VECTOR(23 downto 0);
		Px_data_in_I1		: STD_LOGIC_VECTOR(23 downto 0);
		Px_data_out			: STD_LOGIC_VECTOR(23 downto 0)
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
	
	signal Px_clk_in_I0_i			: std_logic := '0';
	signal Px_clk_in_I1_i			: std_logic := '0';
	
	signal Px_selector_I0_S0_read	: std_logic := '0';
	signal Px_selector_I1_S0_read	: std_logic := '0';
	signal Px_selector_I0_S1_read	: std_logic := '0';
	signal Px_selector_I1_S1_read	: std_logic := '0';
	
	signal Px_selector_S0_write	: std_logic := '0';
	signal Px_selector_S1_write	: std_logic := '0';
	
	signal Px_H_count_I0_i			: std_logic_vector(10 downto 0) := (others => '0');
	signal Px_H_count_I1_i			: std_logic_vector(10 downto 0) := (others => '0');
	
	signal Px_data_I0_S0_i			: std_logic_vector(23 downto 0) := (others => '0');
	signal Px_data_I1_S0_i			: std_logic_vector(23 downto 0) := (others => '0');
	signal Px_data_I0_S1_i			: std_logic_vector(23 downto 0) := (others => '0');
	signal Px_data_I1_S1_i			: std_logic_vector(23 downto 0) := (others => '0');
	
	
	
	
	

begin

	Px_clk_in_I0_i	<= Clk_in_I0_i when Px_Ih_select = '0' else Clk_in_I0_h_i;
	Px_clk_in_I1_i <= Clk_in_I1_i when Px_Ih_select = '0' else Clk_in_I1_h_i;
	
	Px_selector_S0_write	<= S_selector_i when Px_enable = '1' else '0';
	Px_selector_S1_write	<= S_selector_i_n when Px_enable = '1' else '0';
	
	Px_selector_I0_S0_read	<= '1' when Px_enable = '1' and Px_I_select_out = '0' and S_selector_i = '0' else '0'; 
	Px_selector_I1_S0_read	<= '1' when Px_enable = '1' and Px_I_select_out = '1' and S_selector_i = '0' else '0';
	Px_selector_I0_S1_read	<= '1' when Px_enable = '1' and Px_I_select_out = '0' and S_selector_i = '1' else '0'; 
	Px_selector_I1_S1_read	<= '1' when Px_enable = '1' and Px_I_select_out = '1' and S_Selector_i = '1' else '0';
	
	Px_H_count_I0_i		<= H_count_I0_h when Px_Ih_select = '1' else H_count_I0;  
	Px_H_count_I1_i		<= H_count_I1_h when Px_Ih_select = '1' else H_count_I1;
	
	Px_data_out	<= Px_data_I0_S0 when Px_selector_I0_S0_read = '1' else
						Px_data_I1_S0 when Px_selector_I1_S0_read = '1' else
						Px_data_I0_S1 when Px_selector_I0_S1_read = '1' else
						Px_data_I1_S1 when Px_selector_I1_S1_read = '1' else
						(others => '0');
						
	
	
	Px_I0_S0 : BRAM_5x9kb
  PORT MAP (
    clka => ,
    ena => ,
    wea => ,
    addra => ,
    dina => ,
    clkb => Clk_out_i,
    enb => ,
    addrb => Px_H_count_I0_i,
    doutb => Px_data_I0_S0
  );
  
  Px_I1_S0 : BRAM_5x9kb
  PORT MAP (
    clka => clka,
    ena => ena,
    wea => wea,
    addra => addra,
    dina => dina,
    clkb => Clk_out_i,
    enb => enb,
    addrb => Px_H_count_I1_i,
    doutb => Px_data_I1_S0
  );
  
  Px_I0_S1 : BRAM_5x9kb
  PORT MAP (
    clka => clka,
    ena => ena,
    wea => wea,
    addra => addra,
    dina => dina,
    clkb => Clk_out_i,
    enb => enb,
    addrb => Px_H_count_I0_i,
    doutb => Px_data_I0_S1
  );
  
  Px_I1_S1 : BRAM_5x9kb
  PORT MAP (
    clka => clka,
    ena => ena,
    wea => wea,
    addra => addra,
    dina => dina,
    clkb => Clk_out_i,
    enb => enb,
    addrb => Px_H_count_I1_i,
    doutb => Px_data_I1_S1
  );
	
	


end Structural;

