----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:49:20 04/28/2016 
-- Design Name: 
-- Module Name:    Conf_Manager - Structural 
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

entity Conf_Manager is
    Port ( 
		Gclk 			: in  STD_LOGIC;
		GPI_1_in		: in 	STD_LOGIC_VECTOR(31 downto 0);
		GPI_2_in		: in 	STD_LOGIC_VECTOR(23 downto 0);
		GPI_3_in		: in	STD_LOGIC_VECTOR(23 downto 0);
		P0_conf		: out STD_LOGIC_VECTOR(3 downto 0);
		P0_set_1		: out STD_LOGIC_VECTOR(11 downto 0);
		P0_set_2		: out STD_LOGIC_VECTOR(11 downto 0);
		P0_set_3		: out STD_LOGIC_VECTOR(11 downto 0);
		P0_set_4		: out STD_LOGIC_VECTOR(11 downto 0)
		
		);
end Conf_Manager;

architecture Structural of Conf_Manager is

begin

manage : process(Gclk)
begin
	if rising_edge(Gclk) then
		if GPI_1_in(7) = '1' then
			case GPI_1_in(6 downto 4) is
				when "000" =>
						P0_conf <= GPI_1_in(3 downto 0);
						P0_set_1 <= GPI_2_in(23 downto 12);
						P0_set_2 <= GPI_2_in(11 downto 0);
						P0_set_3 <= GPI_3_in(23 downto 12);
						P0_set_4 <= GPI_3_in(11 downto 0);
				when others =>
						P0_conf <= "0000";
			end case;
		end if;
	end if;
end process manage;


end Structural;

