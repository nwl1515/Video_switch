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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BRAM_interface is
    Port ( p0_in_clk : in  STD_LOGIC;
           p0_out_clk : in  STD_LOGIC;
           p0_in_data : in  STD_LOGIC_VECTOR (23 downto 0);
           p0_out_data : out  STD_LOGIC_VECTOR (23 downto 0);
           p0_in_h_count : in  STD_LOGIC;
           p0_in_v_count : in  STD_LOGIC;
           p0 : in  STD_LOGIC);
end BRAM_interface;

architecture Structural of BRAM_interface is

begin


end Structural;

