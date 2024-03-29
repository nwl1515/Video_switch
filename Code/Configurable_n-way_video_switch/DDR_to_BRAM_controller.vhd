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
		clk_in 				: in  STD_LOGIC := '0'; -- x2_pixel_clock!
		clk_in_x2			: in STD_LOGIC := '0';
		global_v_count		: in STD_LOGIC_VECTOR(11 downto 0) := (others => '1');
		reset					: in STD_LOGIC := '0';
		P0_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P0_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P0_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P0_h_count_out_I0 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P0_h_count_out_I1 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P0_BRAM_out_I0		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P0_BRAM_out_I1		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P0_data_out_sel	: inout STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
		P0_S_selector		: in STD_LOGIC := '0';
		P0_inload_done		: inout STD_LOGIC := '0';
		P1_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P1_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P1_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P1_h_count_out_I0 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P1_h_count_out_I1 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P1_BRAM_out_I0		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P1_BRAM_out_I1		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P1_data_out_sel	: inout STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
		P1_S_selector		: in STD_LOGIC := '0';
		P1_inload_done		: inout STD_LOGIC := '0';
		P2_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P2_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P2_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P2_h_count_out_I0 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P2_h_count_out_I1 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P2_BRAM_out_I0		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P2_BRAM_out_I1		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P2_data_out_sel	: inout STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
		P2_S_selector		: in STD_LOGIC := '0';
		P2_inload_done		: inout STD_LOGIC := '0';
		P3_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P3_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P3_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P3_h_count_out_I0 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P3_h_count_out_I1 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P3_BRAM_out_I0		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P3_BRAM_out_I1		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P3_data_out_sel	: inout STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
		P3_S_selector		: in STD_LOGIC := '0';
		P3_inload_done		: inout STD_LOGIC := '0';
		P4_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P4_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P4_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P4_h_count_out_I0 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P4_h_count_out_I1 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P4_BRAM_out_I0		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P4_BRAM_out_I1		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P4_data_out_sel	: inout STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
		P4_S_selector		: in STD_LOGIC := '0';
		P4_inload_done		: inout STD_LOGIC := '0';
		P5_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P5_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P5_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P5_h_count_out_I0 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P5_h_count_out_I1 : out STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P5_BRAM_out_I0		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P5_BRAM_out_I1		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P5_data_out_sel	: inout STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
		P5_S_selector		: in STD_LOGIC := '0';
		P5_inload_done		: inout STD_LOGIC := '0';
		change_S				: in STD_LOGIC := '0';
		c3_p4_cmd_en                          	 : inout std_logic := '0';
		c3_p4_cmd_bl                            : out std_logic_vector(5 downto 0) := "011111";
		c3_p4_cmd_byte_addr                     : out std_logic_vector(29 downto 0) := (others => '0');
		c3_p4_cmd_empty                         : in std_logic := '1';		
		c3_p4_rd_en                             : inout std_logic := '0';
		c3_p4_rd_data                           : in std_logic_vector(31 downto 0) := (others => '0');
		c3_p4_rd_empty                          : in std_logic := '1';
		c3_p5_cmd_en                          	 : inout std_logic := '0';
		c3_p5_cmd_bl                            : out std_logic_vector(5 downto 0) := "011111";
		c3_p5_cmd_byte_addr                     : out std_logic_vector(29 downto 0) := (others => '0');
		c3_p5_cmd_empty                         : in std_logic := '1';
		
		c3_p5_rd_en                             : inout std_logic := '0';
		c3_p5_rd_data                           : in std_logic_vector(31 downto 0) := (others => '0');
		c3_p5_rd_empty                          : in std_logic := '1';
		leds_out											 : inout std_logic_vector(7 downto 0) := (others => '0')
			 
	 );
end DDR_to_BRAM_controller;

architecture Structural of DDR_to_BRAM_controller is

	signal internal_v_count			: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal h_count_I0				: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal h_count_I1				: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
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
	
	signal gearbox_I0				: std_logic_vector(23 downto 0) := (others => '0');
	signal gearbox_I1				: std_logic_Vector(23 downto 0) := (others => '0');
	signal gearbox_I0_s			: std_logic := '0';
	signal gearbox_I1_s			: std_logic := '0';
	
	signal scaling					: std_logic := '0';
	

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
	
	scaling <= '1' when P2_conf = "0010" or P2_conf = "0011" or 
						P3_conf = "0010" or P3_conf = "0011" or P4_conf = "0010" or
						P4_conf = "0011" or P5_conf = "0010" or P5_conf = "0011"
						else '0';
	
	-- Data from DDR to BRAM, when something in buffer
	c3_p5_rd_en <= '1' when c3_p5_rd_empty = '0' else '0';
	p0_BRAM_out_I1 <= gearbox_I1;
	p0_data_out_sel(1) <= '1' when c3_p5_rd_empty = '0' else '0';		
	p0_h_count_out_I1 <= h_count_I1;
	p1_BRAM_out_I1 <= gearbox_I1;
	p1_data_out_sel(1) <= '1' when c3_p5_rd_empty = '0' else '0';		
	p1_h_count_out_I1 <= h_count_I1;
	p2_BRAM_out_I1 <= gearbox_I1;
	p2_data_out_sel(1) <= '1' when c3_p5_rd_empty = '0' else '0';		
	p2_h_count_out_I1 <= h_count_I1;
	p3_BRAM_out_I1 <= gearbox_I1;
	p3_data_out_sel(1) <= '1' when c3_p5_rd_empty = '0' else '0';		
	p3_h_count_out_I1 <= h_count_I1;
	p4_BRAM_out_I1 <= gearbox_I1;
	p4_data_out_sel(1) <= '1' when c3_p5_rd_empty = '0' else '0';		
	p4_h_count_out_I1 <= h_count_I1;
	p5_BRAM_out_I1 <= gearbox_I1;
	p5_data_out_sel(1) <= '1' when c3_p5_rd_empty = '0' else '0';		
	p5_h_count_out_I1 <= h_count_I1;
	
	
	gearbox_proc_i1 : process(clk_in_x2)
	begin
		if rising_Edge(clk_in_x2) then
			if change_S = '1' then
				h_count_I1 <= (others => '0');
				gearbox_I1_s <= '1';
			
			elsif run_I1 = '1' then
			
				if c3_p5_rd_en = '1' then
					h_count_I1 <= h_count_I1 + 1;						
				end if;
				
				if gearbox_I1_s = '0' then
					gearbox_I1(23 downto 0) <= c3_p5_rd_data(31 downto 27) & "000" & c3_p5_rd_data(26 downto 21) & "00" & c3_p5_rd_data(20 downto 16) & "000";
					gearbox_I1_s <= not gearbox_I1_s;
				else
					gearbox_I1(23 downto 0) <= c3_p5_rd_data(15 downto 11) & "000" & c3_p5_rd_data(10 downto 5) & "00" & c3_p5_rd_data(4 downto 0) & "000";
					gearbox_I1_s <= not gearbox_I1_s;
				end if;
			end if;
		end if;
	end process gearbox_proc_i1;
	
	
	c3_p4_rd_en <= '1' when c3_p4_rd_empty = '0' else '0';
	p0_BRAM_out_I0 <= gearbox_I0;
	p0_data_out_sel(0) <= '1' when c3_p4_rd_empty = '0' else '0';	
	p0_h_count_out_I0 <= h_count_I0;
	p1_BRAM_out_I0 <= gearbox_I0;
	p1_data_out_sel(0) <= '1' when c3_p4_rd_empty = '0' else '0';	
	p1_h_count_out_I0 <= h_count_I0;
	p2_BRAM_out_I0 <= gearbox_I0;
	p2_data_out_sel(0) <= '1' when c3_p4_rd_empty = '0' else '0';	
	p2_h_count_out_I0 <= h_count_I0;
	p3_BRAM_out_I0 <= gearbox_I0;
	p3_data_out_sel(0) <= '1' when c3_p4_rd_empty = '0' else '0';	
	p3_h_count_out_I0 <= h_count_I0;
	p4_BRAM_out_I0 <= gearbox_I0;
	p4_data_out_sel(0) <= '1' when c3_p4_rd_empty = '0' else '0';	
	p4_h_count_out_I0 <= h_count_I0;
	p5_BRAM_out_I0 <= gearbox_I0;
	p5_data_out_sel(0) <= '1' when c3_p4_rd_empty = '0' else '0';	
	p5_h_count_out_I0 <= h_count_I0;
	
	
	gearbox_proc_i0 : process(clk_in_x2)
	begin
		if rising_Edge(clk_in_x2) then
			if change_S = '1' then
				h_count_I0 <= (others => '0');
				gearbox_I0_s <= '1';
			
			elsif run_I0 = '1' then
			
				if c3_p4_rd_en = '1' then
					h_count_I0 <= h_count_I0 + 1;						
				end if;
				
				if gearbox_I0_s = '0' then
					gearbox_I0(23 downto 0) <= c3_p4_rd_data(31 downto 27) & "000" & c3_p4_rd_data(26 downto 21) & "00" & c3_p4_rd_data(20 downto 16) & "000";
					gearbox_I0_s <= not gearbox_I0_s;
				else
					gearbox_I0(23 downto 0) <= c3_p4_rd_data(15 downto 11) & "000" & c3_p4_rd_data(10 downto 5) & "00" & c3_p4_rd_data(4 downto 0) & "000";
					gearbox_I0_s <= not gearbox_I0_s;
				end if;
			end if;
		end if;
	end process gearbox_proc_i0;
	
	
	

	
	called_I1 <= c3_p5_cmd_en or (not c3_p5_cmd_empty);
	
	called_I0 <= c3_p4_cmd_en or (not c3_p4_cmd_empty);
	


	c3_p5_cmd_bl <= "011111"; -- means 32
	
	c3_p4_cmd_bl <= "011111"; -- means 32
	
	I1_proc : process(clk_in,change_S)
		variable address_count : integer := 0;
		variable count_buffer : integer := 0;
		variable scaling_done	: integer := 0;
	begin			
		if rising_edge(clk_in) then
			c3_p5_cmd_en <= '0';
					
			if reset = '1' then
				run_I1 <= '0';
				address_count := 0;
				count_buffer := 0;
				if c3_p5_cmd_empty = '0' then
					c3_p5_cmd_en <= '1';
				end if;
				
			elsif change_S = '1' then
				run_I1 <= '1';
				if scaling = '1' then
					address_count := conv_integer(P4_set_1(11 downto 1));
				else
					address_count := 0;
				end if;
				count_buffer := 0;
				scaling_done := 0;
				
			else
				if run_I1 = '1' then
						
						if c3_p5_rd_en = '1' then
							count_buffer := count_buffer - 1;						
						end if;
						
						if scaling = '1' then
							if address_count < conv_integer(P4_set_1(11 downto 1))+320 and count_buffer <= 32 and Called_I1 = '0' and scaling_done = 0 then
								c3_p5_cmd_en <= '1';
								if P4_conf = "0010" then
									c3_p5_cmd_byte_addr <= "000000" & "0" & (internal_v_count(10 downto 1)+P4_set_2(9 downto 0)) & conv_std_logic_vector(address_count, 11) & "00";
								else
									c3_p5_cmd_byte_addr <= "000100" & "0" & (internal_v_count(10 downto 1)+P4_set_2(9 downto 0)) & conv_std_logic_vector(address_count, 11) & "00";
								end if;
								address_count := address_count + 32;
								count_buffer := count_buffer +32;
								if address_count >= conv_integer(P4_set_1(11 downto 1))+320 then
									scaling_done := 1;
									address_count := conv_integer(P5_set_1(11 downto 1));
								end if;
								
							elsif address_count < conv_integer(P5_set_1(11 downto 1))+320 and count_buffer <= 32 and Called_I1 = '0' and scaling_done = 1 then
								c3_p5_cmd_en <= '1';
								if P5_conf = "0010" then
									c3_p5_cmd_byte_addr <= "000000" & "0" & (internal_v_count(10 downto 1)+P5_set_2(9 downto 0)) & conv_std_logic_vector(address_count, 11) & "00";
								else
									c3_p5_cmd_byte_addr <= "000100" & "0" & (internal_v_count(10 downto 1)+P5_set_2(9 downto 0)) & conv_std_logic_vector(address_count, 11) & "00";
								end if;								
								address_count := address_count + 32;
								count_buffer := count_buffer +32;
							end if;
							
						else
							if address_count < 640 and count_buffer <= 32 and called_I1 = '0' then -- call for 16 new pixels if buffer empty or less than 8
								c3_p5_cmd_en <= '1';
								c3_p5_cmd_byte_addr <= "000100" & internal_v_count & conv_std_logic_vector(address_count, 11) & "00";
								address_count := address_count + 32;
								count_buffer := count_buffer +32;		
							end if;
						end if;
						
						
						
					if h_count_I1 >= 1279 and c3_p5_rd_empty = '1' then
						run_I1 <= '0'; -- stop!
					end if;
				end if;
			end if;
		end if;				
	end process I1_proc;
	
	
	
	I0_proc : process(clk_in,change_S)
		variable address_count : integer := 0;
		variable count_buffer : integer := 0;
		variable scaling_done : integer := 0;
	begin			
		if rising_edge(clk_in) then
			c3_p4_cmd_en <= '0';
					
			if reset = '1' then
				run_I0 <= '0';
				address_count := 0;
				count_buffer := 0;
				if c3_p4_cmd_empty = '0' then
					c3_p4_cmd_en <= '1';
				end if;
				
			elsif change_S = '1' then
				run_I0 <= '1';
				if scaling = '1' then
					address_count := conv_integer(P2_set_1(11 downto 1));
				else
					address_count := 0;
				end if;
				count_buffer := 0;
				scaling_done := 0;
				
			else
				if run_I0 = '1' then
						
						if c3_p4_rd_en = '1' then
							count_buffer := count_buffer - 1;						
						end if;
						
						
						
						if scaling = '1' then
							if address_count < conv_integer(P2_set_1(11 downto 1))+320 and count_buffer <= 32 and Called_I0 = '0' and scaling_done = 0 then
								c3_p4_cmd_en <= '1';
								if P2_conf = "0010" then
									c3_p4_cmd_byte_addr <= "000000" & "0" & (internal_v_count(10 downto 1)+P2_set_2(9 downto 0)) & conv_std_logic_vector(address_count, 11) & "00";
								else
									c3_p4_cmd_byte_addr <= "000100" & "0" & (internal_v_count(10 downto 1)+P2_set_2(9 downto 0)) & conv_std_logic_vector(address_count, 11) & "00";
								end if;
								address_count := address_count + 32;
								count_buffer := count_buffer +32;
								if address_count >= conv_integer(P2_set_1(11 downto 1))+320 then
									scaling_done := 1;
									address_count := conv_integer(P3_set_1(11 downto 1));
								end if;
								
							elsif address_count < conv_integer(P3_set_1(11 downto 1))+320 and count_buffer <= 32 and Called_I0 = '0' and scaling_done = 1 then
								c3_p4_cmd_en <= '1';
								if P3_conf = "0010" then
									c3_p4_cmd_byte_addr <= "000000" & "0" & (internal_v_count(10 downto 1)+P3_set_2(9 downto 0)) & conv_std_logic_vector(address_count, 11) & "00";
								else
									c3_p4_cmd_byte_addr <= "000100" & "0" & (internal_v_count(10 downto 1)+P3_set_2(9 downto 0)) & conv_std_logic_vector(address_count, 11) & "00";
								end if;								
								address_count := address_count + 32;
								count_buffer := count_buffer +32;
							end if;
							
						else
						
							if address_count < 640 and count_buffer <= 32 and called_I0 = '0' then -- call for 16 new pixels if buffer empty or less than 8
								c3_p4_cmd_en <= '1';
								c3_p4_cmd_byte_addr <= "000000" & internal_v_count & conv_std_logic_vector(address_count, 11) & "00";
								address_count := address_count + 32;
								count_buffer := count_buffer +32;
									
							end if;
						end if;
						
						
						
					if h_count_I0 >= 1279 and c3_p4_rd_empty = '1' then
						run_I0 <= '0'; -- stop!
					end if;
				end if;
			end if;
		end if;				
	end process I0_proc;
	
	
	
	
 
end Structural;

