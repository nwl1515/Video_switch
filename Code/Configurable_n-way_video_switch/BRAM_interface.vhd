----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:09:17 03/11/2016 
-- Design Name: 
-- Module Name:    BRAM_interface - Structural 
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

entity BRAM_interface is
    Port (
		BRAM_enable 		: STD_LOGIC;
		Clk_out				: STD_LOGIC;
		Clk_in_I0			: STD_LOGIC;
		Clk_in_I0_h			: STD_LOGIC;
		Clk_in_I1			: STD_LOGIC;
		Clk_in_I1_h			: STD_LOGIC;
		S_selector			: STD_LOGIC;
		H_count_in_I0		: STD_LOGIC_VECTOR(10 downto 0);
		H_count_in_I0_h	: STD_LOGIC_VECTOR(10 downto 0);
		H_count_in_I1		: STD_LOGIC_VECTOR(10 downto 0);
		H_count_in_I1_h	: STD_LOGIC_VECTOR(10 downto 0);
		P0_enable			: STD_LOGIC;
		P0_I_select_out	: STD_LOGIC;
		P0_Ih_select		: STD_LOGIC;
		P0_H_count_out		: STD_LOGIC_VECTOR(10 downto 0);
		P0_data_in_I0		: STD_LOGIC_VECTOR(23 downto 0);
		P0_data_in_I1		: STD_LOGIC_VECTOR(23 downto 0);
		P0_data_out			: STD_LOGIC_VECTOR(23 downto 0);
		P1_enable			: STD_LOGIC;
		P1_I_select_out	: STD_LOGIC;
		P1_Ih_select		: STD_LOGIC;
		P1_H_count_out		: STD_LOGIC_VECTOR(10 downto 0);
		P1_data_in_I0		: STD_LOGIC_VECTOR(23 downto 0);
		P1_data_in_I1		: STD_LOGIC_VECTOR(23 downto 0);
		P1_data_out			: STD_LOGIC_VECTOR(23 downto 0);
		P2_enable			: STD_LOGIC;
		P2_I_select_out	: STD_LOGIC;
		P2_Ih_select		: STD_LOGIC;
		P2_H_count_out		: STD_LOGIC_VECTOR(10 downto 0);
		P2_data_in_I0		: STD_LOGIC_VECTOR(23 downto 0);
		P2_data_in_I1		: STD_LOGIC_VECTOR(23 downto 0);
		P2_data_out			: STD_LOGIC_VECTOR(23 downto 0);
		P3_enable			: STD_LOGIC;
		P3_I_select_out	: STD_LOGIC;
		P3_Ih_select		: STD_LOGIC;
		P3_H_count_out		: STD_LOGIC_VECTOR(10 downto 0);
		P3_data_in_I0		: STD_LOGIC_VECTOR(23 downto 0);
		P3_data_in_I1		: STD_LOGIC_VECTOR(23 downto 0);
		P3_data_out			: STD_LOGIC_VECTOR(23 downto 0);
		P4_enable			: STD_LOGIC;
		P4_I_select_out	: STD_LOGIC;
		P4_Ih_select		: STD_LOGIC;
		P4_H_count_out		: STD_LOGIC_VECTOR(10 downto 0);
		P4_data_in_I0		: STD_LOGIC_VECTOR(23 downto 0);
		P4_data_in_I1		: STD_LOGIC_VECTOR(23 downto 0);
		P4_data_out			: STD_LOGIC_VECTOR(23 downto 0);
		P5_enable			: STD_LOGIC;
		P5_I_select_out	: STD_LOGIC;
		P5_Ih_select		: STD_LOGIC;
		P5_H_count_out		: STD_LOGIC_VECTOR(10 downto 0);
		P5_data_in_I0		: STD_LOGIC_VECTOR(23 downto 0);
		P5_data_in_I1		: STD_LOGIC_VECTOR(23 downto 0);
		P5_data_out			: STD_LOGIC_VECTOR(23 downto 0)
	 );
end BRAM_interface;

architecture Structural of BRAM_interface is

	COMPONENT BRAM_port
	PORT(
		Clk_out_i : IN std_logic;
		Clk_in_I0_i : IN std_logic;
		Clk_in_I1_i : IN std_logic;
		Clk_in_I0_h_i : IN std_logic;
		Clk_in_I1_h_i : IN std_logic;
		S_selector_i : IN std_logic;
		S_selector_i_n : IN std_logic;
		H_count_I0 : IN std_logic_vector(10 downto 0);
		H_count_I0_h : IN std_logic_vector(10 downto 0);
		H_count_I1 : IN std_logic_vector(10 downto 0);
		H_count_I1_h : IN std_logic_vector(10 downto 0);
		Px_enable : IN std_logic;
		Px_Ih_select : IN std_logic;
		PX_I_select_out : IN std_logic;
		Px_H_count_out : IN std_logic_vector(10 downto 0);
		Px_data_in_I0 : IN std_logic_vector(23 downto 0);
		Px_data_in_I1 : IN std_logic_vector(23 downto 0);
		Px_data_out : IN std_logic_vector(23 downto 0)       
		);
	END COMPONENT;

	-- Signals
	
	signal Clk_out_i				: std_logic := '0';
	signal Clk_in_I0_i			: std_logic := '0';
	signal Clk_in_I1_i			: std_logic := '0';
	signal Clk_in_I0_h_i			: std_logic := '0';
	signal Clk_in_I1_h_i			: std_logic := '0';
	signal S_selector_i			: std_logic := '0';
	signal S_selector_i_n		: std_logic := '0';
	
begin
	
	-- LOGIC
	
	Clk_out_i 		<= Clk_out when BRAM_enable = '1' else '0';
	Clk_in_I0_i 	<= Clk_in_I0 when BRAM_enable = '1' else '0';
	Clk_in_I1_i		<= Clk_in_I1 when BRAM_enable = '1' else '0';
	Clk_in_I0_h_i	<= Clk_in_I0_h when BRAM_enable = '1' else '0';
	Clk_in_I1_h_i 	<= Clk_in_I1_h when BRAM_enable = '1' else '0';
	
	S_selector_i	<= S_selector when BRAM_enable = '1' else '0';
	S_selector_i_n <= not S_selector when BRAM_enable = '1' else '0';
	
	Port0 : BRAM_port PORT MAP(
		Clk_out_i 			=> Clk_out_i,
		Clk_in_I0_i 		=> Clk_in_I0_i,
		Clk_in_I1_i 		=> Clk_in_I1_i,
		Clk_in_I0_h_i 		=> Clk_in_I0_h_i,
		Clk_in_I1_h_i 		=> Clk_in_I1_h_i,
		S_selector_i 		=> S_selector_i,
		S_selector_i_n 	=> S_selector_i_n,
		H_count_I0 			=> H_count_I0,
		H_count_I0_h 		=> H_count_I0_h,
		H_count_I1 			=> H_count_I1,
		H_count_I1_h 		=> H_count_I1_h,
		Px_enable 			=> P0_enable,
		Px_Ih_select 		=> P0_Ih_select,
		PX_I_select_out 	=> P0_I_select_out,
		Px_H_count_out 	=> P0_H_count_out,
		Px_data_in_I0 		=> P0_data_in_I0,
		Px_data_in_I1 		=> P0_data_in_I1,
		Px_data_out 		=> P0_data_out
	);
	
		Port1 : BRAM_port PORT MAP(
		Clk_out_i 			=> Clk_out_i,
		Clk_in_I0_i 		=> Clk_in_I0_i,
		Clk_in_I1_i 		=> Clk_in_I1_i,
		Clk_in_I0_h_i 		=> Clk_in_I0_h_i,
		Clk_in_I1_h_i 		=> Clk_in_I1_h_i,
		S_selector_i 		=> S_selector_i,
		S_selector_i_n 	=> S_selector_i_n,
		H_count_I0 			=> H_count_I0,
		H_count_I0_h 		=> H_count_I0_h,
		H_count_I1 			=> H_count_I1,
		H_count_I1_h 		=> H_count_I1_h,
		Px_enable 			=> P1_enable,
		Px_Ih_select 		=> P1_Ih_select,
		PX_I_select_out 	=> P1_I_select_out,
		Px_H_count_out 	=> P1_H_count_out,
		Px_data_in_I0 		=> P1_data_in_I0,
		Px_data_in_I1 		=> P1_data_in_I1,
		Px_data_out 		=> P1_data_out
	);

	Port2 : BRAM_port PORT MAP(
		Clk_out_i 			=> Clk_out_i,
		Clk_in_I0_i 		=> Clk_in_I0_i,
		Clk_in_I1_i 		=> Clk_in_I1_i,
		Clk_in_I0_h_i 		=> Clk_in_I0_h_i,
		Clk_in_I1_h_i 		=> Clk_in_I1_h_i,
		S_selector_i 		=> S_selector_i,
		S_selector_i_n 	=> S_selector_i_n,
		H_count_I0 			=> H_count_I0,
		H_count_I0_h 		=> H_count_I0_h,
		H_count_I1 			=> H_count_I1,
		H_count_I1_h 		=> H_count_I1_h,
		Px_enable 			=> P2_enable,
		Px_Ih_select 		=> P2_Ih_select,
		PX_I_select_out 	=> P2_I_select_out,
		Px_H_count_out 	=> P2_H_count_out,
		Px_data_in_I0 		=> P2_data_in_I0,
		Px_data_in_I1 		=> P2_data_in_I1,
		Px_data_out 		=> P2_data_out
	);

	Port3 : BRAM_port PORT MAP(
		Clk_out_i 			=> Clk_out_i,
		Clk_in_I0_i 		=> Clk_in_I0_i,
		Clk_in_I1_i 		=> Clk_in_I1_i,
		Clk_in_I0_h_i 		=> Clk_in_I0_h_i,
		Clk_in_I1_h_i 		=> Clk_in_I1_h_i,
		S_selector_i 		=> S_selector_i,
		S_selector_i_n 	=> S_selector_i_n,
		H_count_I0 			=> H_count_I0,
		H_count_I0_h 		=> H_count_I0_h,
		H_count_I1 			=> H_count_I1,
		H_count_I1_h 		=> H_count_I1_h,
		Px_enable 			=> P0_enable,
		Px_Ih_select 		=> P3_Ih_select,
		PX_I_select_out 	=> P3_I_select_out,
		Px_H_count_out 	=> P3_H_count_out,
		Px_data_in_I0 		=> P3_data_in_I0,
		Px_data_in_I1 		=> P3_data_in_I1,
		Px_data_out 		=> P3_data_out
	);

	Port4 : BRAM_port PORT MAP(
		Clk_out_i 			=> Clk_out_i,
		Clk_in_I0_i 		=> Clk_in_I0_i,
		Clk_in_I1_i 		=> Clk_in_I1_i,
		Clk_in_I0_h_i 		=> Clk_in_I0_h_i,
		Clk_in_I1_h_i 		=> Clk_in_I1_h_i,
		S_selector_i 		=> S_selector_i,
		S_selector_i_n 	=> S_selector_i_n,
		H_count_I0 			=> H_count_I0,
		H_count_I0_h 		=> H_count_I0_h,
		H_count_I1 			=> H_count_I1,
		H_count_I1_h 		=> H_count_I1_h,
		Px_enable 			=> P4_enable,
		Px_Ih_select 		=> P4_Ih_select,
		PX_I_select_out 	=> P4_I_select_out,
		Px_H_count_out 	=> P4_H_count_out,
		Px_data_in_I0 		=> P4_data_in_I0,
		Px_data_in_I1 		=> P4_data_in_I1,
		Px_data_out 		=> P4_data_out
	);

	Port5 : BRAM_port PORT MAP(
		Clk_out_i 			=> Clk_out_i,
		Clk_in_I0_i 		=> Clk_in_I0_i,
		Clk_in_I1_i 		=> Clk_in_I1_i,
		Clk_in_I0_h_i 		=> Clk_in_I0_h_i,
		Clk_in_I1_h_i 		=> Clk_in_I1_h_i,
		S_selector_i 		=> S_selector_i,
		S_selector_i_n 	=> S_selector_i_n,
		H_count_I0 			=> H_count_I0,
		H_count_I0_h 		=> H_count_I0_h,
		H_count_I1 			=> H_count_I1,
		H_count_I1_h 		=> H_count_I1_h,
		Px_enable 			=> P5_enable,
		Px_Ih_select 		=> P5_Ih_select,
		PX_I_select_out 	=> P5_I_select_out,
		Px_H_count_out 	=> P5_H_count_out,
		Px_data_in_I0 		=> P5_data_in_I0,
		Px_data_in_I1 		=> P5_data_in_I1,
		Px_data_out 		=> P5_data_out
	);

	
	
	

end Structural;

