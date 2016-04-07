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
		BRAM_enable 		: in STD_LOGIC := '0';
		clk_out				: in STD_LOGIC := '0';
		clk_in				: in STD_LOGIC := '0'; -- obs x2_pixel_clock
		clk_out_enable    : in STD_LOGIC := '0';
		P0_enable			: in STD_LOGIC := '0';
		P0_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P0_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P0_data_out			: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P0_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P0_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P0_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P0_data_select_in : in STD_LOGIC_VECTOR(1 downto 0) := "00";
		P0_I_select_out	: in STD_LOGIC := '0';
		P0_S_select			: in STD_LOGIC := '0';
		P1_enable			: in STD_LOGIC := '0';
		P1_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P1_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P1_data_out			: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P1_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P1_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P1_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P1_data_select_in : in STD_LOGIC_VECTOR(1 downto 0) := "00";
		P1_I_select_out	: in STD_LOGIC := '0';
		P1_S_select			: in STD_LOGIC := '0';
		P2_enable			: in STD_LOGIC := '0';
		P2_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P2_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P2_data_out			: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P2_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P2_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P2_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P2_data_select_in : in STD_LOGIC_VECTOR(1 downto 0) := "00";
		P2_I_select_out	: in STD_LOGIC := '0';
		P2_S_select			: in STD_LOGIC := '0';
		P3_enable			: in STD_LOGIC := '0';
		P3_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P3_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P3_data_out			: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P3_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P3_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P3_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P3_data_select_in : in STD_LOGIC_VECTOR(1 downto 0) := "00";
		P3_I_select_out	: in STD_LOGIC := '0';
		P3_S_select			: in STD_LOGIC := '0';
		P4_enable			: in STD_LOGIC := '0';
		P4_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P4_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P4_data_out			: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P4_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P4_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P4_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P4_data_select_in : in STD_LOGIC_VECTOR(1 downto 0) := "00";
		P4_I_select_out	: in STD_LOGIC := '0';
		P4_S_select			: in STD_LOGIC := '0';
		P5_enable			: in STD_LOGIC := '0';
		P5_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P5_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P5_data_out			: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P5_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P5_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P5_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P5_data_select_in : in STD_LOGIC_VECTOR(1 downto 0) := "00";
		P5_I_select_out	: in STD_LOGIC := '0';
		P5_S_select			: in STD_LOGIC := '0'
	 );
end BRAM_interface;

architecture Structural of BRAM_interface is

	COMPONENT BRAM_port
	Port ( 
		clk_out_i 			: in STD_LOGIC;
		clk_in_i 			: in STD_LOGIC;
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
	END COMPONENT;

	-- Signals
	
	signal Clk_out_i				: std_logic := '0';
	signal Clk_in_i				: std_logic := '0';

	
begin
	
	-- LOGIC
	
	clk_out_i 		<= clk_out when BRAM_enable = '1' and clk_out_enable = '1' else '0';
	clk_in_i 		<= clk_in when BRAM_enable = '1' else '0';

	Port0 : BRAM_port 
	PORT MAP(
		clk_out_i			=> clk_out_i,
		clk_in_i 			=> clk_in_i,
		Px_enable			=> P0_enable,
		Px_data_in_I0		=> P0_data_in_I0,
		Px_data_in_I1		=> P0_data_in_I1,
		Px_data_out			=> P0_data_out,
		Px_h_count_in_I0	=> P0_h_count_in_I0,
		Px_h_count_in_I1	=> P0_h_count_in_I1,
		Px_h_count_out		=> P0_h_count_out,
		Px_data_select_in => P0_data_select_in,
		Px_I_select_out	=> P0_I_select_out,
		Px_S_select			=> P0_S_select 
	);
	
	Port1 : BRAM_port 
	PORT MAP(
		clk_out_i			=> clk_out_i,
		clk_in_i 			=> clk_in_i,
		Px_enable			=> P1_enable,
		Px_data_in_I0		=> P1_data_in_I0,
		Px_data_in_I1		=> P1_data_in_I1,
		Px_data_out			=> P1_data_out,
		Px_h_count_in_I0	=> P1_h_count_in_I0,
		Px_h_count_in_I1	=> P1_h_count_in_I1,
		Px_h_count_out		=> P1_h_count_out,
		Px_data_select_in => P1_data_select_in,
		Px_I_select_out	=> P1_I_select_out,
		Px_S_select			=> P1_S_select 
	);
	
	Port2 : BRAM_port 
	PORT MAP(
		clk_out_i			=> clk_out_i,
		clk_in_i 			=> clk_in_i,
		Px_enable			=> P2_enable,
		Px_data_in_I0		=> P2_data_in_I0,
		Px_data_in_I1		=> P2_data_in_I1,
		Px_data_out			=> P2_data_out,
		Px_h_count_in_I0	=> P2_h_count_in_I0,
		Px_h_count_in_I1	=> P2_h_count_in_I1,
		Px_h_count_out		=> P2_h_count_out,
		Px_data_select_in => P2_data_select_in,
		Px_I_select_out	=> P2_I_select_out,
		Px_S_select			=> P2_S_select 
	);
	
	Port3 : BRAM_port 
	PORT MAP(
		clk_out_i			=> clk_out_i,
		clk_in_i 			=> clk_in_i,
		Px_enable			=> P3_enable,
		Px_data_in_I0		=> P3_data_in_I0,
		Px_data_in_I1		=> P3_data_in_I1,
		Px_data_out			=> P3_data_out,
		Px_h_count_in_I0	=> P3_h_count_in_I0,
		Px_h_count_in_I1	=> P3_h_count_in_I1,
		Px_h_count_out		=> P3_h_count_out,
		Px_data_select_in => P3_data_select_in,
		Px_I_select_out	=> P3_I_select_out,
		Px_S_select			=> P3_S_select 
	);
	
	Port4 : BRAM_port 
	PORT MAP(
		clk_out_i			=> clk_out_i,
		clk_in_i 			=> clk_in_i,
		Px_enable			=> P4_enable,
		Px_data_in_I0		=> P4_data_in_I0,
		Px_data_in_I1		=> P4_data_in_I1,
		Px_data_out			=> P4_data_out,
		Px_h_count_in_I0	=> P4_h_count_in_I0,
		Px_h_count_in_I1	=> P4_h_count_in_I1,
		Px_h_count_out		=> P4_h_count_out,
		Px_data_select_in => P4_data_select_in,
		Px_I_select_out	=> P4_I_select_out,
		Px_S_select			=> P4_S_select 
	);
	
	Port5 : BRAM_port 
	PORT MAP(
		clk_out_i			=> clk_out_i,
		clk_in_i 			=> clk_in_i,
		Px_enable			=> P5_enable,
		Px_data_in_I0		=> P5_data_in_I0,
		Px_data_in_I1		=> P5_data_in_I1,
		Px_data_out			=> P5_data_out,
		Px_h_count_in_I0	=> P5_h_count_in_I0,
		Px_h_count_in_I1	=> P5_h_count_in_I1,
		Px_h_count_out		=> P5_h_count_out,
		Px_data_select_in => P5_data_select_in,
		Px_I_select_out	=> P5_I_select_out,
		Px_S_select			=> P5_S_select 
	);
	


	
	
	

end Structural;

