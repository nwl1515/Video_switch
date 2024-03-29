----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:30:37 03/23/2016 
-- Design Name: 
-- Module Name:    Px_output_controller - Structural 
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

entity Px_output_controller is
    Port (
		device_set			: in STD_LOGIC_vector(2 downto 0) := "000";
		clk_in 				: in  STD_LOGIC := '0'; --- OBS x1 pixel clock
		global_h_count		: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		global_v_count		: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		global_active_v	: in STD_LOGIC := '0';
		Px_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		Px_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		Px_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		Px_set_3 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		Px_set_4 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		Px_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		Px_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		Px_video_out		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		Px_I_selector		: out STD_LOGIC := '0';
		Px_S_selector		: inout STD_LOGIC := '0';
		Px_enable			: out STD_LOGIC := '0';
		Px_inload_done		: in STD_LOGIC := '0';
		Px_unload_done		: inout STD_LOGIC := '0';
		Px_change_s			: out STD_LOGIC := '0'
	 
	 );
end Px_output_controller;

architecture Structural of Px_output_controller is

	signal Px_I_selector_p1 : std_logic := '0';
	signal Px_I_selector_p2 : std_logic := '0';
	signal Px_v_count_out	: std_logic_vector(10 downto 0) := (others => '0');

begin

	Px_enable <= '1' when Px_conf < "1111" else '0';
	
	Px_video_out <= Px_BRAM_in when Px_conf = "0000" or Px_conf = "0001" or 
						Px_conf = "0100" or Px_conf = "0101" or Px_conf = "0110" or 
						Px_conf = "0111" or Px_conf = "1000" or Px_conf = "1001" or 
						(Px_conf = "0010" and device_set > 0) or 
						(Px_conf = "0011" and device_set > 0) 
						else  (others => '0');
	
	Px_h_count_out <= global_h_count(10 downto 0) when (Px_conf = "0000" or 
							Px_conf = "0001" or Px_conf = "0100" or Px_conf = "0101" or 
							Px_conf = "0110" or Px_conf = "0111" or Px_conf = "1000" or 
							Px_conf = "1001") and not(global_v_count = "111111111111") 
							
							else global_h_count(11 downto 1) 
							when ((Px_conf = "0010" or Px_conf = "0011") 
							     and (device_set = "001" or device_set = "011")) 
								  and not(global_v_count = "111111111111")
							
							else global_h_count(11 downto 1)+640 
							when ((Px_conf = "0010" or Px_conf = "0011") 
							     and (device_set = "010" or device_set = "100")) 
								  and not(global_v_count = "111111111111")
							
							else (others => '0');
							
	Px_v_count_out <= global_v_count(10 downto 0) when (Px_conf = "0000" or 
							Px_conf = "0001" or Px_conf = "0100" or Px_conf = "0101" or 
							Px_conf = "0110" or Px_conf = "0111" or Px_conf = "1000" or 
							Px_conf = "1001" or Px_conf = "0010" or Px_conf = "0011") and not(global_v_count = "111111111111") else (others => '0');
	controller : process(clk_in)
	begin
		if rising_edge(clk_in) then
			Px_I_selector <= Px_I_selector_p1;
			Px_I_selector_p1 <= Px_I_selector_p2;
			case Px_conf is
				when "0000" =>
									Px_I_selector_p2 <= '0';								
									
																	
				when "0001" =>
									Px_I_selector_p2 <= '1';
								
				

				when "0010" =>
									if device_set = "001" or device_set = "010" then
										Px_I_selector_p2 <= '0';
									else
										Px_I_selector_p2 <= '1';
									end if;
									
				when "0011" =>
									if device_set = "001" or device_set = "010" then
										Px_I_selector_p2 <= '0';
									else
										Px_I_selector_p2 <= '1';
									end if;
						
									
				when "0100" =>
									if Px_h_count_out < Px_set_1 then
										Px_I_selector_p2 <= '1';
									else
										Px_I_selector_p2 <= '0';
									end if;
						
									
				when "0101" =>
									if Px_h_count_out < Px_set_1 then
										Px_I_selector_p2 <= '0';
									else
										Px_I_selector_p2 <= '1';
									end if;
						
				
				when "0110" =>
									if Px_v_count_out < Px_set_1 then
										Px_I_selector_p2 <= '0';
									else
										Px_I_selector_p2 <= '1';
									end if;
						
									
				when "0111" =>
									if Px_v_count_out < Px_set_1 then
										Px_I_selector_p2 <= '1';
									else
										Px_I_selector_p2 <= '0';
									end if;
					
									
				when "1000" => 
									if (Px_v_count_out < Px_set_2) or (Px_v_count_out > Px_set_2+Px_set_4) then
										Px_I_selector_p2 <= '0';
									elsif (Px_h_count_out < Px_set_1) or (Px_h_count_out > Px_set_1+Px_set_3) then
										Px_I_selector_p2 <= '0';
									else
										Px_I_selector_p2 <= '1';
									end if;
								
									

				when "1001" => 
									if (Px_v_count_out < Px_set_2) or (Px_v_count_out > Px_set_2+Px_set_4) then
										Px_I_selector_p2 <= '1';
									elsif (Px_h_count_out < Px_set_1) or (Px_h_count_out > Px_set_1+Px_set_3) then
										Px_I_selector_p2 <= '1';
									else
										Px_I_selector_p2 <= '0';
									end if;
									
									
				when others =>
									
			end case;
			
			Px_change_s <= '0';
			
			if global_h_count >= 1279 and global_active_v = '1' then
				Px_unload_done <= '1';
										
			elsif Px_unload_done = '1' and not(global_v_count = "111111111111") then
				Px_S_selector <= not Px_S_selector;
				Px_unload_done <= '0';
				Px_change_s <= '1';
			end if;
		end if;
	end process controller;

end Structural;

