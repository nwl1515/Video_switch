----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:43:05 02/27/2016 
-- Design Name: 
-- Module Name:    TMDS_encoder - Structural 
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


entity TMDS_encoder is
    Port ( Pixel_clock : in  STD_LOGIC;
           Data_n8 : in  STD_LOGIC_VECTOR (7 downto 0);
           Control : in  STD_LOGIC_VECTOR (1 downto 0);
           Video_active : in  STD_LOGIC;
           Data_n10 : out  STD_LOGIC_VECTOR (9 downto 0));
end TMDS_encoder;

architecture Structural of TMDS_encoder is

signal xored  : STD_LOGIC_VECTOR (8 downto 0);
   signal xnored : STD_LOGIC_VECTOR (8 downto 0);
   
	signal control_token			: std_logic_vector (9 downto 0);
   signal ones                : STD_LOGIC_VECTOR (3 downto 0);
   signal q_m           : STD_LOGIC_VECTOR (8 downto 0);
   signal q_m_inv       : STD_LOGIC_VECTOR (8 downto 0);
   signal q_m_disparity : STD_LOGIC_VECTOR (3 downto 0);
   signal dc_bias             : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
	
	signal data_pipeline			: std_logic_vector(7 downto 0);
	signal control_pipeline		: std_logic_vector(1 downto 0);
	signal video_active_pipeline	: std_logic;
	signal ones_pipeline			: std_logic_vector(3 downto 0);
begin
   
-------------------------------------
-- Encoding
-------------------------------------
   xored(0) <= data_pipeline(0);
   xored(1) <= data_pipeline(1) xor xored(0);
   xored(2) <= data_pipeline(2) xor xored(1);
   xored(3) <= data_pipeline(3) xor xored(2);
   xored(4) <= data_pipeline(4) xor xored(3);
   xored(5) <= data_pipeline(5) xor xored(4);
   xored(6) <= data_pipeline(6) xor xored(5);
   xored(7) <= data_pipeline(7) xor xored(6);
   xored(8) <= '1';

   xnored(0) <= data_pipeline(0);
   xnored(1) <= data_pipeline(1) xnor xnored(0);
   xnored(2) <= data_pipeline(2) xnor xnored(1);
   xnored(3) <= data_pipeline(3) xnor xnored(2);
   xnored(4) <= data_pipeline(4) xnor xnored(3);
   xnored(5) <= data_pipeline(5) xnor xnored(4);
   xnored(6) <= data_pipeline(6) xnor xnored(5);
   xnored(7) <= data_pipeline(7) xnor xnored(6);
   xnored(8) <= '0';


---------------------------------------
-- Pipeline stage 1
---------------------------------------

	stage_1 : process(Pixel_clock)
	begin
		if rising_edge(Pixel_clock) then
			data_pipeline 			<= Data_n8;
			control_pipeline 		<= Control;
			video_active_pipeline <= video_active;
			ones_pipeline <= "0000" + Data_n8(0) + Data_n8(1) + Data_n8(2) + Data_n8(3) + Data_n8(4) + 
										Data_n8(5) + Data_n8(6) + Data_n8(7);
		end if;
	end process stage_1;

---------------------------------------
-- Select encoding
---------------------------------------						 
	q_m <= xnored when (ones_pipeline > 4) or (ones_pipeline = 4 and data_pipeline(0) = '0') else xored;
	q_m_inv <= not q_m;
 
 --------------------------------------
-- Find disparity in encoding
--------------------------------------- 
   q_m_disparity  <= "1100" + q_m(0) + q_m(1) + q_m(2) + q_m(3) 
                                    + q_m(4) + q_m(5) + q_m(6) + q_m(7);
												
---------------------------------------
-- Control tokens
---------------------------------------												
	control_token <= "1101010100" when Control = "00" else
							"0010101011" when Control = "01" else
							"0101010100" when Control = "10" else
							"1010101011";
	
-----------------------------------
-- Find output
-----------------------------------
   process(Pixel_clock)
   begin
      if rising_edge(Pixel_clock) then
         if Video_active = '0' then 
            Data_n10 <= control_token;
            dc_bias <= (others => '0');
         else
            if dc_bias = "00000" or q_m_disparity = 0 then
               if q_m(8) = '1' then
                  Data_n10 <= "01" & q_m(7 downto 0);
                  dc_bias <= dc_bias + q_m_disparity;
               else
                  Data_n10 <= "10" & q_m_inv(7 downto 0);
                  dc_bias <= dc_bias - q_m_disparity;
               end if;
            elsif (dc_bias(3) = '0' and q_m_disparity(3) = '0') or 
                  (dc_bias(3) = '1' and q_m_disparity(3) = '1') then
               Data_n10 <= '1' & q_m(8) & q_m_inv(7 downto 0);
               dc_bias <= dc_bias + q_m(8) - q_m_disparity;
            else
               Data_n10 <= '0' & q_m;
               dc_bias <= dc_bias - q_m_inv(8) + q_m_disparity;
            end if;
         end if;
      end if;
   end process; 

	
end Structural;

