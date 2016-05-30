----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:02:01 02/26/2016 
-- Design Name: 
-- Module Name:    Gearbox_10_to_5 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Gearbox_10_to_5 is
    Port ( Pixel_clock_x1 : in  STD_LOGIC;
           Pixel_clock_x2 : in  STD_LOGIC;
           Input_n10 : in  STD_LOGIC_VECTOR (9 downto 0);
           Output_n5 : out  STD_LOGIC_VECTOR (4 downto 0));
end Gearbox_10_to_5;

architecture Behavioral of Gearbox_10_to_5 is

	signal gear_select		: std_logic := '0';
	signal gear_second		: std_logic := '0';
	
	alias Input_high 			: std_logic_vector(4 downto 0) is Input_n10(9 downto 5);
	alias Input_low			: std_logic_vector(4 downto 0) is Input_n10(4 downto 0);
		
begin

	shift_gear : process (Pixel_clock_x1)
	begin
		if rising_edge(Pixel_clock_x1) then
			gear_select	 <= not gear_select;
		end if;
	end process shift_gear;
	
	
	
	sync : process(Pixel_clock_x2)
	begin
		if rising_edge(Pixel_clock_x2) then
			gear_second <= gear_select;
		end if;
	end process sync;
	
	
	
	output_select : process(Pixel_clock_x2)
	begin
		if rising_edge(Pixel_clock_x2) then
			if ((gear_select xor gear_second) = '1') then
				Output_n5 <= Input_high;
			else
				Output_n5 <= Input_low;
			end if;
		end if;
	end process output_select;
	
	

------------------------------------
-- Input:	 10 bit 
-- Output:	 5 bit 
------------------------------------
		


end Behavioral;

