----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:59:58 03/23/2016 
-- Design Name: 
-- Module Name:    Input_to_DDR_controller - Structural 
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

entity Input_to_DDR_controller is
    Port ( 
				pixel_clock_I0 									: in  STD_LOGIC;
				pixel_clock_I1										: in 	STD_LOGIC;
				h_count_I0											: in 	STD_LOGIC_VECTOR(10 downto 0);
				h_count_I1											: in 	STD_LOGIC_VECTOR(10 downto 0);
				v_count_I0											: in 	STD_LOGIC_VECTOR(10 downto 0);
				v_count_I1											: in 	STD_LOGIC_VECTOR(10 downto 0);
				active_video_I0									: in 	STD_LOGIC;
				active_video_I1									: in	STD_LOGIC;
				video_in_I0											: in 	STD_LOGIC_VECTOR(23 downto 0);
				video_in_I1											: in 	STD_LOGIC_VECTOR(23 downto 0);
				reset													: in  STD_LOGIC;
				
				-- DDR signals
				DDR_p2_cmd_en                            : out std_logic;
				DDR_p2_cmd_byte_addr                     : out std_logic_vector(29 downto 0);
				DDR_p2_cmd_full                          : in std_logic;
				
				DDR_p2_wr_en                             : out std_logic;
				DDR_p2_wr_data                           : out std_logic_vector(31 downto 0);
				DDR_p2_wr_full                           : in std_logic;
				DDR_p2_wr_empty                          : in std_logic;
				
				DDR_p3_cmd_en                            : out std_logic;
				DDR_p3_cmd_byte_addr                     : out std_logic_vector(29 downto 0);
				DDR_p3_cmd_full                          : in std_logic;
				
				DDR_p3_wr_en                             : out std_logic;
				DDR_p3_wr_data                           : out std_logic_vector(31 downto 0);
				DDR_p3_wr_full                           : in std_logic;
				DDR_p3_wr_empty                          : in std_logic
				
				-- I0 -> p2
				-- I1 -> p3
				
			);
end Input_to_DDR_controller;

architecture Structural of Input_to_DDR_controller is
	
	signal count_num_I0			: STD_LOGIC_VECTOR(4 downto 0) := "00000";
	signal count_num_I1			: STD_LOGIC_VECTOR(4 downto 0) := "00000";
	
	signal addr_out_I0			: STD_LOGIC_VECTOR(29 downto 0) := (others => '0');
	signal addr_out_I1			: STD_LOGIC_VECTOR(29 downto 0) := (others => '0');
	
	constant error_addr			: STD_LOGIC_VECTOR(29 downto 0) := "001111111111111111111111111100";
	
	signal bank_col_I0			: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal bank_col_I1			: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	
	signal cmd_en_I0_p1			: STD_LOGIC;
	signal cmd_en_I1_p1			: STD_LOGIC;
	signal wr_en_I0_p1			: STD_LOGIC;
	signal wr_en_I1_p1			: STD_LOGIC;
		

begin

	input_1 : process(pixel_clock_I1)
	begin
		if rising_edge(pixel_clock_I1) then
			DDR_p3_cmd_en <= cmd_en_I1_p1;
			DDR_p3_wr_en <= wr_en_I1_p1;
			if reset = '1' then
				if DDR_p3_wr_empty = '0' then
					cmd_en_I1_p1 <= '1';
					DDR_p3_cmd_byte_addr <= error_addr;
					DDR_p3_wr_en <= '0';
				end if;
			else
				if active_video_I1 = '1' then
					wr_en_I1_p1 <= '1';
					DDR_p3_wr_data(23 downto 0) <= video_in_I1;
					count_num_I1 <= count_num_I1 + 1;
					bank_col_I1(12 downto 2) <= h_count_I1 - 15;
				else
					wr_en_I1_p1 <= '0';
				end if;
				
				if count_num_I1 = 15 then
					cmd_en_I1_p1 <= '1';		
					DDR_p3_cmd_byte_addr <= "001" & v_count_I1 & bank_col_I1;
					count_num_I1 <= (others => '0');
				else
					cmd_en_I1_p1 <= '0';				
				end if;
			end if;
		end if;
	end process input_1;
			
					
				
				


end Structural;

