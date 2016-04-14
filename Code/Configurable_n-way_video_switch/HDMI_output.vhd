----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:10:20 02/26/2016 
-- Design Name: 
-- Module Name:    HDMI_output - Structural 
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
Library UNISIM;
use UNISIM.vcomponents.all;

entity HDMI_OUT is
    Port ( -- Clocking
			  Pixel_clock : in std_logic := '0';
			  clk_x1			: in std_logic := '0';
			  clk_x2			: in std_logic := '0';
			  clk_x10		: in std_logic := '0';
			  serdes_strobe : in std_logic := '0';
           -- Pixel data
           red_p     : in  STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
           green_p   : in  STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
           blue_p    : in  STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
           active_video     : in  STD_LOGIC := '0';
           hsync     : in  STD_LOGIC := '0';
           vsync     : in  STD_LOGIC := '0';
           -- TMDS outputs
            tmds_out_p : out  STD_LOGIC_VECTOR(3 downto 0) := (others => '1');
            tmds_out_n : out  STD_LOGIC_VECTOR(3 downto 0) := (others => '0'));
end HDMI_OUT;

architecture Structural of HDMI_OUT is

	
	COMPONENT TMDS_encoder is
    Port ( Pixel_clock : in  STD_LOGIC;
           Data_n8 : in  STD_LOGIC_VECTOR (7 downto 0);
           Control : in  STD_LOGIC_VECTOR (1 downto 0);
           Video_active : in  STD_LOGIC;
           Data_n10 : out  STD_LOGIC_VECTOR (9 downto 0));
	END COMPONENT;

   COMPONENT Gearbox_10_to_5 is
    Port ( Pixel_clock_x1 : in  STD_LOGIC;
           Pixel_clock_x2 : in  STD_LOGIC;
           Input_n10 : in  STD_LOGIC_VECTOR (9 downto 0);
           Output_n5 : out  STD_LOGIC_VECTOR (4 downto 0));
	END COMPONENT;

	
	COMPONENT Serializer_5_to_1 
    Port ( Pixel_clock_x2 : in  STD_LOGIC;
           Pixel_clock_x10 : in  STD_LOGIC;
           Serdes_strobe : in  STD_LOGIC;
           Input_n5 : in  STD_LOGIC_VECTOR (4 downto 0);
           Output_n1 : out  STD_LOGIC);
	END COMPONENT;


	signal not_clk_pixel		: std_logic;

 
   signal encoded_red, encoded_green, encoded_blue : std_logic_vector(9 downto 0) := (others => '0');
   signal ser_in_red,  ser_in_green,  ser_in_blue, ser_in_clock   : std_logic_vector(4 downto 0) := (others => '0');
   
   constant c_red       : std_logic_vector(1 downto 0) := (others => '0');
   constant c_green     : std_logic_vector(1 downto 0) := (others => '0');
   signal   c_blue      : std_logic_vector(1 downto 0) := (others => '0');

   signal red_s     : STD_LOGIC := '0';
   signal green_s   : STD_LOGIC := '0';
   signal blue_s    : STD_LOGIC := '0';
   signal clock_s   : STD_LOGIC := '0';

begin   
   -- Send the pixels to the encoder
   c_blue <= vsync & hsync; 
 
	red_encoder : TMDS_encoder 
    Port map( 
				Pixel_clock 		=> Pixel_clock,
          Data_n8 				=> red_p,
           Control				=> c_red,
           Video_active 		=> active_video,
           Data_n10 				=> encoded_red
	);
	
	green_encoder : TMDS_encoder 
    Port map( 
				Pixel_clock 		=> Pixel_clock,
          Data_n8 				=> green_p,
           Control				=> c_green,
           Video_active 		=> active_video,
           Data_n10 				=> encoded_green
	);
	
	blue_encoder : TMDS_encoder 
    Port map( 
				Pixel_clock 		=> Pixel_clock,
          Data_n8 				=> blue_p,
           Control				=> c_blue,
           Video_active 		=> active_video,
           Data_n10 				=> encoded_blue
	);


	
	
   red_gearbox : Gearbox_10_to_5 
    Port map ( 
				Pixel_clock_x1 	=> clk_x1,
           Pixel_clock_x2		=> clk_x2,
           Input_n10 			=> encoded_red,
           Output_n5 			=> ser_in_red
	);
	
	green_gearbox : Gearbox_10_to_5 
    Port map ( 
				Pixel_clock_x1 	=> clk_x1,
           Pixel_clock_x2		=> clk_x2,
           Input_n10 			=> encoded_green,
           Output_n5 			=> ser_in_green
	);
	
	blue_gearbox : Gearbox_10_to_5 
    Port map ( 
				Pixel_clock_x1 	=> clk_x1,
           Pixel_clock_x2		=> clk_x2,
           Input_n10 			=> encoded_blue,
           Output_n5 			=> ser_in_blue
	);
	

	red_ser : Serializer_5_to_1 
    Port map ( 
				Pixel_clock_x2 		=> clk_x2,
           Pixel_clock_x10 		=> clk_x10,
           Serdes_strobe 			=> serdes_strobe,
           Input_n5 					=> ser_in_red,
           Output_n1 				=> red_s);
			  
	green_ser : Serializer_5_to_1 
    Port map ( 
				Pixel_clock_x2 		=> clk_x2,
           Pixel_clock_x10 		=> clk_x10,
           Serdes_strobe 			=> serdes_strobe,
           Input_n5 					=> ser_in_green,
           Output_n1 				=> green_s);
			  
	blue_ser : Serializer_5_to_1 
    Port map ( 
				Pixel_clock_x2 		=> clk_x2,
           Pixel_clock_x10 		=> clk_x10,
           Serdes_strobe 			=> serdes_strobe,
           Input_n5 					=> ser_in_blue,
           Output_n1 				=> blue_s);
			  
	not_clk_pixel <= not clk_x1;

	clock_output : ODDR2
	generic map(
			DDR_ALIGNMENT 	=> "NONE",
			INIT 				=> '0',
			SRTYPE 			=> "SYNC")
	port map(
			Q 					=> clock_s,
			C0 				=> clk_x1,
			C1					=> not_clk_pixel,
			D0					=> '1',
			D1					=> '0',
			CE					=> '1',
			R					=> '0',
			S					=> '0'
	);


   
    -- The output buffers/drivers
OBUFDS_red   : OBUFDS port map ( O  => tmds_out_p(2), OB => tmds_out_n(2), I => red_s);
OBUFDS_green : OBUFDS port map ( O  => tmds_out_p(1), OB => tmds_out_n(1), I => green_s);
OBUFDS_blue  : OBUFDS port map ( O  => tmds_out_p(0), OB => tmds_out_n(0), I => blue_s);
OBUFDS_clock : OBUFDS port map ( O  => tmds_out_p(3), OB => tmds_out_n(3), I => clock_s);


end Structural;

