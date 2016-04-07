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
				pixel_clock_I0 									: in  STD_LOGIC := '0';
				pixel_clock_I1										: in 	STD_LOGIC := '0';
				h_count_I0											: in 	STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
				h_count_I1											: in 	STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
				v_count_I0											: in 	STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
				v_count_I1											: in 	STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
				active_video_I0									: in 	STD_LOGIC := '0';
				active_video_I1									: in	STD_LOGIC := '0';
				video_in_I0											: in 	STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
				video_in_I1											: in 	STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
				reset													: in  STD_LOGIC := '0';
				
				-- DDR signals
				DDR_p2_cmd_en                            : out std_logic := '0';
				DDR_p2_cmd_byte_addr                     : out std_logic_vector(29 downto 0) := "000000000000000000000000000000";
				DDR_p2_cmd_full                          : in std_logic := '0';
				DDR_p2_cmd_empty									: in std_logic := '1';
				
				DDR_p2_wr_en                             : out std_logic := '0';
				DDR_p2_wr_data                           : out std_logic_vector(31 downto 0) := (others => '0');
				DDR_p2_wr_full                           : in std_logic := '0';
				DDR_p2_wr_empty                          : in std_logic := '1';
				
				DDR_p3_cmd_en                            : out std_logic := '0';
				DDR_p3_cmd_byte_addr                     : out std_logic_vector(29 downto 0) := "000100000000000000000000000000";
				DDR_p3_cmd_full                          : in std_logic := '0';
				DDR_p3_cmd_empty									: in std_logic := '1';
				
				DDR_p3_wr_en                             : out std_logic := '0';
				DDR_p3_wr_data                           : out std_logic_vector(31 downto 0) := (others => '0');
				DDR_p3_wr_full                           : in std_logic := '0';
				DDR_p3_wr_empty                          : in std_logic := '1'
				
				-- I0 -> p2
				-- I1 -> p3
				
			);
end Input_to_DDR_controller;

architecture Structural of Input_to_DDR_controller is
	
	
	
	
	signal v_count_I1_p1			: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal v_count_I0_p1			: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	
	constant error_addr			: STD_LOGIC_VECTOR(29 downto 0) := "001111111111111111111111111100";
		

begin

	
	DDR_p3_wr_data <= "00000000" & video_in_I1;
	DDR_p3_wr_en <= '1' when active_video_I1 = '1' and reset = '0' else '0';

	input_1 : process(pixel_clock_I1)
	variable count_num_I1 		: integer range 0 to 32 := 0;
	variable address_count		: integer range 0 to 1280 := 0;
	begin
		if rising_edge(pixel_clock_I1) then
			DDR_p3_cmd_en <= '0';
			if reset = '1' then
				if DDR_p3_wr_empty = '0' then
					DDR_p3_cmd_en <= '1';
					DDR_p3_cmd_byte_addr <= error_addr;
				end if;
				count_num_I1 := 0;
				address_count := 0;
				
			else
				if active_video_I1 = '1' then
					count_num_I1 := count_num_I1 + 1;
					v_count_I1_p1 <= v_count_I1;
				elsif count_num_I1 <= 32 and not(count_num_I1 = 0) then
					count_num_I1 := 32;
				else
					count_num_I1 := 0;
					address_count := 0;
				end if;
		
				if count_num_I1 >= 32 then
					if DDR_p3_cmd_empty = '1' then
						DDR_p3_cmd_en <= '1';
						DDR_p3_cmd_byte_addr <= "000100" & v_count_I1_p1 & conv_std_logic_Vector(address_count,11) & "00";
						count_num_I1 := count_num_I1 - 32;
						address_count := address_count + 32;
					end if;
					
				end if;
			end if;
		end if;
	end process input_1;
	
	
	
	DDR_p2_wr_data <= "00000000" & video_in_I0;
	DDR_p2_wr_en <= '1' when active_video_I0 = '1' and reset = '0' else '0';
	
	input_0 : process(pixel_clock_I0)
	variable count_num_I0 		: integer range 0 to 32 := 0;
	variable address_count		: integer range 0 to 1280 := 0;
	begin
		if rising_edge(pixel_clock_I0) then
			DDR_p2_cmd_en <= '0';
			if reset = '1' then
				if DDR_p2_wr_empty = '0' then
					DDR_p2_cmd_en <= '1';
					DDR_p2_cmd_byte_addr <= error_addr;
				end if;
				count_num_I0 := 0;
				address_count := 0;
				
			else
				if active_video_I0 = '1' then
					count_num_I0 := count_num_I0 + 1;
					v_count_I0_p1 <= v_count_I0;
				elsif count_num_I0 <= 32 and not(count_num_I0 = 0) then
					count_num_I0 := 32;
				else
					count_num_I0 := 0;
					address_count := 0;
				end if;
		
				if count_num_I0 >= 32 then
					if DDR_p2_cmd_empty = '1' then
						DDR_p2_cmd_en <= '1';
						DDR_p2_cmd_byte_addr <= "000000" & v_count_I0_p1 & conv_std_logic_Vector(address_count,11) & "00";
						count_num_I0 := count_num_I0 - 32;
						address_count := address_count + 32;
					end if;
					
				end if;
			end if;
		end if;
	end process input_0;
	
					
				
				


end Structural;

