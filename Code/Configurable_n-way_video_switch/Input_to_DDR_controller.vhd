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
				DDR_p2_cmd_empty									: in std_logic;
				
				DDR_p2_wr_en                             : out std_logic;
				DDR_p2_wr_data                           : out std_logic_vector(31 downto 0);
				DDR_p2_wr_full                           : in std_logic;
				DDR_p2_wr_empty                          : in std_logic;
				
				DDR_p3_cmd_en                            : out std_logic;
				DDR_p3_cmd_byte_addr                     : out std_logic_vector(29 downto 0);
				DDR_p3_cmd_full                          : in std_logic;
				DDR_p3_cmd_empty									: in std_logic;
				
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
	--signal count_num_I1			: STD_LOGIC_VECTOR(4 downto 0) := "00000";
	
	signal addr_out_I0			: STD_LOGIC_VECTOR(29 downto 0) := (others => '0');
	signal addr_out_I1			: STD_LOGIC_VECTOR(29 downto 0) := (others => '0');
	
	constant error_addr			: STD_LOGIC_VECTOR(29 downto 0) := "001111111111111111111111111100";
	
	signal bank_col_I0			: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	--signal bank_col_I1			: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	
	signal cmd_en_I0_p1			: STD_LOGIC;
	signal cmd_en_I1_p1			: STD_LOGIC;
	signal wr_en_I0_p1			: STD_LOGIC;
	signal wr_en_I1_p1			: STD_LOGIC;
		

begin

--	input_1 : process(pixel_clock_I1)
--	variable count_num_I1 		: integer := 0;
--	variable bank_col_I1			: integer := 0;
--	begin
--		if rising_edge(pixel_clock_I1) then
--			DDR_p3_cmd_en <= cmd_en_I1_p1;
--			DDR_p3_wr_en <= wr_en_I1_p1;
--			cmd_en_I1_p1 <= '0';
--			wr_en_I1_p1 <= '0';
--			if reset = '1' then
--				if DDR_p3_wr_empty = '0' then
--					cmd_en_I1_p1 <= '1';
--					DDR_p3_cmd_byte_addr <= error_addr;
--				end if;
--			else
--				if active_video_I1 = '1' then
--					wr_en_I1_p1 <= '1';
--					DDR_p3_wr_data(23 downto 0) <= video_in_I1;
--					count_num_I1 := count_num_I1 + 1;
--					bank_col_I1 := conv_integer(h_count_I1 - 16);
--					--bank_col_I1(12 downto 2) <= h_count_I1 +1 ;		-- offset
--				end if;
--				
--				if count_num_I1 = 16 then
--					cmd_en_I1_p1 <= '1';		
--					DDR_p3_cmd_byte_addr <= "001" & v_count_I1 & conv_std_logic_vector(bank_col_I1,14) & "00";
--					count_num_I1 := 0;
--				elsif active_video_I1 = '0' and DDR_p3_cmd_empty = '1' and DDR_p3_wr_empty = '0' then
--					cmd_en_I1_p1 <= '1';
--					--DDR_p3_cmd_byte_addr <= error_addr;
--					DDR_p3_cmd_byte_addr <= "001" & v_count_I1 & conv_std_logic_vector(bank_col_I1-1,14) & "00";
--					count_num_I1 := 0;		
--				end if;
--			end if;
--		end if;
--	end process input_1;

	
	DDR_p3_wr_data(23 downto 0) <= video_in_I1;
	DDR_p3_wr_en <= '1' when active_video_I1 = '1' else '0';

	input_1 : process(pixel_clock_I1)
	variable count_num_I1 		: integer := 0;
	variable address_count		: integer := 0;
	begin
		if rising_edge(pixel_clock_I1) then
			DDR_p3_cmd_en <= '0';
			if reset = '1' then
				if DDR_p3_wr_empty = '0' then
					DDR_p3_cmd_en <= '1';
					DDR_p3_Cmd_byte_addr <= error_addr;
				end if;
				count_num_I1 := 0;
				address_count := 0;
				
			else
				if active_video_I1 = '1' then
					count_num_I1 := count_num_I1 + 1;
				elsif count_num_I1 < 32 and not(count_num_I1 = 0) then
					count_num_I1 := 32;
				else
					count_num_I1 := 0;
					address_count := 0;
				end if;
		
				if count_num_I1 = 32 then
					DDR_p3_cmd_en <= '1';
					DDR_p3_cmd_byte_addr <= "0001" & v_count_I1 & "00" & conv_std_logic_Vector(address_count,11) & "00";
					count_num_I1 := 0;
					address_count := address_count + 32;		
				end if;
			end if;
		end if;
	end process input_1;
	
	DDR_p2_cmd_byte_addr <= "0000" & v_count_I0 & "00" &(h_count_I0-32) & "00" when reset = '0' else error_addr;
	DDR_p2_wr_data(23 downto 0) <= video_in_I0;
	DDR_p2_wr_en <= '1' when active_video_I0 = '1' else '0';

	input_0 : process(pixel_clock_I0)
	variable count_num_I0 		: integer := 0;
	begin
		if rising_edge(pixel_clock_I0) then
			DDR_p2_cmd_en <= '0';
			if reset = '1' then
				if DDR_p2_wr_empty = '0' then
					DDR_p2_cmd_en <= '1';
				end if;
			else
				if active_video_I0 = '1' then
					count_num_I0 := count_num_I0 + 1;
				end if;
				
				if count_num_I0 = 31 then
					DDR_p2_cmd_en <= '1';		
					count_num_I0 := 0;
				elsif active_video_I0 = '0' and DDR_p2_cmd_empty = '1' and DDR_p2_wr_empty = '0' then
					DDR_p2_cmd_en <= '1';
					count_num_I0 := 0;		
				end if;
			end if;
		end if;
	end process input_0;
	
					
				
				


end Structural;

