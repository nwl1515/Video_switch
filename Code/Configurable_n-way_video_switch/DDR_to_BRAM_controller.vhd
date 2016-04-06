----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:56:22 03/27/2016 
-- Design Name: 
-- Module Name:    DDR_to_BRAM_controller - Structural 
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

entity DDR_to_BRAM_controller is
    Port ( 
		clk_in 				: in  STD_LOGIC; -- x2_pixel_clock!
		global_v_count		: in STD_LOGIC_VECTOR(11 downto 0);
		reset					: in STD_LOGIC;
		P0_conf				: in STD_LOGIC_VECTOR(3 downto 0);
		P0_set_1 			: in STD_LOGIC_VECTOR(11 downto 0);
		P0_set_2 			: in STD_LOGIC_VECTOR(11 downto 0);
		P0_h_count_out_I0 : out STD_LOGIC_VECTOR(10 downto 0);
		P0_h_count_out_I1 : out STD_LOGIC_VECTOR(10 downto 0);
		P0_BRAM_out_I0		: out STD_LOGIC_VECTOR(23 downto 0);
		P0_BRAM_out_I1		: out STD_LOGIC_VECTOR(23 downto 0);
		P0_data_out_sel	: inout STD_LOGIC_VECTOR(1 downto 0);
		P0_S_selector		: in STD_LOGIC;
		P0_inload_done		: inout STD_LOGIC;
		change_S				: in STD_LOGIC;
		c3_p4_cmd_en                          	 : inout std_logic;
		c3_p4_cmd_bl                            : out std_logic_vector(5 downto 0);
		c3_p4_cmd_byte_addr                     : out std_logic_vector(29 downto 0);
		c3_p4_cmd_empty                         : in std_logic;		
		c3_p4_rd_en                             : inout std_logic;
		c3_p4_rd_data                           : in std_logic_vector(31 downto 0);
		c3_p4_rd_empty                          : in std_logic;
		c3_p5_cmd_en                          	 : inout std_logic;
		c3_p5_cmd_bl                            : out std_logic_vector(5 downto 0);
		c3_p5_cmd_byte_addr                     : out std_logic_vector(29 downto 0);
		c3_p5_cmd_empty                         : in std_logic;
		
		c3_p5_rd_en                             : inout std_logic;
		c3_p5_rd_data                           : in std_logic_vector(31 downto 0);
		c3_p5_rd_empty                          : in std_logic;
		leds_out											 : inout std_logic_vector(7 downto 0) := (others => '0')
			 
	 );
end DDR_to_BRAM_controller;

architecture Structural of DDR_to_BRAM_controller is

	signal internal_v_count			: STD_LOGIC_VECTOR(10 downto 0);
	signal h_count_I0				: STD_LOGIC_VECTOR(10 downto 0);
	signal h_count_I1				: STD_LOGIC_VECTOR(10 downto 0);
	signal S_selector_old_P0		: STD_LOGIC := '0';
	signal run_I1					   : STD_LOGIC := '0';
	signal run_I0						: STD_LOGIC := '0';
	signal change_I1   				: STD_LOGIC := '0';
	signal out_count_I1				: STD_LOGIC_vector(7 downto 0) := (others => '0');
	signal out_count_I0				: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal called_I1					: STD_LOGIC := '0';
	signal called_I0					: STD_LOGIC := '0';
	
	signal cmd_en_I0_p1			: STD_LOGIC := '0';
	signal cmd_en_I1_p1			: STD_LOGIC := '0';
	signal rd_en_I0_p1			: STD_LOGIC := '0';
	signal rd_en_I1_p1			: STD_LOGIC := '0';
	signal bank_col_I1			: std_logic_vector(10 downto 0) := (others => '0');
	signal bank_col_I0			: std_logic_vector(10 downto 0) := (others => '0');

begin

		
	--leds_out <= h_count_I1(10 downto 3);
	leds_out(0) <= run_I1;
	leds_out(1) <= p0_inload_done;
	leds_out(2) <= p0_S_selector;
	leds_out(3) <= p0_data_out_sel(1);
	leds_out(4) <= c3_p5_cmd_en;
	leds_out(5) <= change_S;
	leds_out(6) <= c3_p5_cmd_empty;
	leds_out(7) <= c3_p5_rd_empty;
	
	internal_v_count <= (others => '0') when global_v_count >= 719 else global_v_count(10 downto 0) + 1;
	
	
	-- Data from DDR to BRAM, when something in buffer
	p0_BRAM_out_I1 <= c3_p5_rd_data(23 downto 0);
	p0_data_out_sel(1) <= '1' when c3_p5_rd_empty = '0' else '0';
	c3_p5_rd_en <= '1' when c3_p5_rd_empty = '0' else '0';	
	p0_h_count_out_I1 <= h_count_I1;
	
	
	
	
	
	p0_BRAM_out_I0 <= c3_p4_rd_data(23 downto 0);
	p0_data_out_sel(0) <= '1' when c3_p4_rd_empty = '0' else '0';
	c3_p4_rd_en <= '1' when c3_p4_rd_empty = '0' else '0';
	p0_h_count_out_I0 <= h_count_I0;
	
	
	

	
	called_I1 <= c3_p5_cmd_en or (not c3_p5_cmd_empty);
	
	called_I0 <= c3_p4_cmd_en or (not c3_p4_cmd_empty);
	
--	I1_proc : process(clk_in, change_S)
--		variable out_count_I1 : integer :=0;
--	begin
--			
--		if rising_edge(clk_in) then
--			c3_p5_cmd_en <= cmd_en_I1_p1;
--			cmd_en_I1_p1 <= '0';
--			
--			if change_S = '1' then
--			run_I1 <= '1';
--			inload_done <= '0';
--			h_count_I1 <= (others => '0');
--			out_count_I1 := 0;
--			bank_col_I1 <= conv_std_logic_vector(64, 16);
--			--bank_col_I1 <= (others => '0');
--			end if;
--			
--			if reset = '1' then
--				c3_p5_cmd_en <= '0';
--				cmd_en_I1_p1 <= '0';
--				run_I1 <= '0';
--				h_count_I1 <= (others => '0');
--				bank_col_I1 <= conv_std_logic_vector(64,16);
--				--bank_col_I1 <= (others => '0');
--				out_count_I1 := 0;	
--				inload_done <= '0';
--			else
--				if run_I1 = '1' then
--					if c3_p5_rd_en = '1' then
--						out_count_I1 := out_count_I1 - 1;
--						h_count_I1 <= h_count_I1 + 1;					
--					end if;
--					
--					if bank_col_I1(12 downto 2) < (1279+16) then
--						if (c3_p5_rd_empty = '1' or out_count_I1 < 9) and called_I1 = '0' then -- call for 16 new pixels if buffer empty or less than 8
--							cmd_en_I1_p1 <= '1';
--							c3_p5_cmd_byte_addr <= "001" & internal_v_count & bank_col_I1;
--							out_count_I1 := out_count_I1 + 16;
--							bank_col_I1 <= bank_col_I1 + 64;
--							c3_p5_cmd_bl <= "001111"; -- means 16	
--						end if;
--					elsif bank_col_I1(12 downto 2) >= (1279+16) and c3_p5_rd_empty = '1' then
--						run_I1 <= '0'; -- stop!
--						inload_done <= '1';
--					end if;
--				end if;
--			end if;
--		end if;				
--	end process I1_proc;

	c3_p5_cmd_bl <= "011111"; -- means 32
	
	c3_p4_cmd_bl <= "011111"; -- means 32
	
	I1_proc : process(clk_in, change_S)
		variable address_count : integer := 0;
		variable count_buffer : integer := 0;
	begin			
		if rising_edge(clk_in) then
			c3_p5_cmd_en <= '0';
					
			if reset = '1' then
				run_I1 <= '0';
				h_count_I1 <= (others => '0');
				address_count := 0;
				count_buffer := 0;
				if c3_p5_cmd_empty = '0' then
					c3_p5_cmd_en <= '1';
				end if;
				
			elsif change_S = '1' then
				run_I1 <= '1';
				h_count_I1 <= (others => '0');
				address_count := 0;
				count_buffer := 0;
				
			else
				if run_I1 = '1' then
						
						if c3_p5_rd_en = '1' then
							count_buffer := count_buffer - 1;
							h_count_I1 <= h_count_I1 + 1;						
						end if;
						
						if address_count <= 1280 and count_buffer <= 32 and called_I1 = '0' then -- call for 16 new pixels if buffer empty or less than 8
							c3_p5_cmd_en <= '1';
							c3_p5_cmd_byte_addr <= "00010" & internal_v_count & "0" & conv_std_logic_vector(address_count, 11) & "00";
							address_count := address_count + 32;
							count_buffer := count_buffer +32;
								
						end if;
						
						
						
					if h_count_I1 >= 1279 and c3_p5_rd_empty = '1' then
						run_I1 <= '0'; -- stop!
					end if;
				end if;
			end if;
		end if;				
	end process I1_proc;
	
	
	
	I0_proc : process(clk_in, change_S)
		variable address_count_I0 : integer := 0;
		variable count_buffer_I0 : integer := 0;
	begin			
		if rising_edge(clk_in) then
			c3_p4_cmd_en <= '0';
					
			if reset = '1' then
				run_I0 <= '0';
				h_count_I0 <= (others => '0');
				address_count_I0 := 0;
				count_buffer_I0 := 0;
				if c3_p4_cmd_empty = '0' then
					c3_p4_cmd_en <= '1';
				end if;
				
			elsif change_S = '1' then
				run_I0 <= '0';
				h_count_I0 <= (others => '0');
				address_count_I0 := 0;
				count_buffer_I0 := 0;
				
			else
				if run_I0 = '1' then
						if address_count_I0 < 1280 and count_buffer_I0 <= 32 and called_I0 = '0' then -- call for 16 new pixels if buffer empty or less than 8
							c3_p4_cmd_en <= '1';
							c3_p4_cmd_byte_addr <= "00000" & internal_v_count & "0" & conv_std_logic_vector(address_count_I0, 11) & "00";
							address_count_I0 := address_count_I0 + 32;
							count_buffer_I0 := count_buffer_I0 +32;
								
						end if;
						
						if c3_p4_rd_en = '1' then
							count_buffer_I0 := count_buffer_I0 - 1;
							h_count_I0 <= h_count_I0 + 1;						
						end if;
						
					if h_count_I0 >= 1279 and c3_p4_rd_empty = '1' then
						run_I0 <= '0'; -- stop!
					end if;
				end if;
			end if;
		end if;				
	end process I0_proc;
	
	
	
	
 
end Structural;

