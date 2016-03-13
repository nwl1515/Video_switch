----------------------------------------------------------------------------------
-- Company: SDU
-- Engineer: Nikolaj Leth
-- 
-- Create Date:    17:39:03 02/14/2016 
-- Design Name:    Configurable n-way video switch
-- Module Name:    HDMI_IN - Behavioral 
-- Project Name:   Configurable n-way video switch - Bachelor project
-- Target Devices: Spartan 6 (Diligent Atlys)
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

library UNISIM;
use UNISIM.VComponents.all;

entity HDMI_IN is
	PORT(
			hdmi_in_p		: in STD_LOGIC_VECTOR(3 downto 0);
			hdmi_in_n		: in STD_LOGIC_VECTOR(3 downto 0);
			ddc_sclk			: in STD_LOGIC;
			ddc_sdat			: inout STD_LOGIC;
			gclk				: in STD_LOGIC;
			red_c				: out STD_LOGIC_VECTOR(7 downto 0);
			green_c			: out STD_LOGIC_VECTOR(7 downto 0);
			blue_c			: out STD_LOGIC_VECTOR(7 downto 0);
			pclk				: out STD_LOGIC
			
			);
end HDMI_IN;

architecture Behavioral of HDMI_IN is

	COMPONENT Pixel_clock_multiplier
	PORT(
		pclk_in			: in STD_LOGIC;
		pclk_o_x1		: out STD_LOGIC;
		pclk_o_x2		: out STD_LOGIC;
		pclk_o_x10		: out STD_LOGIC;
		pll_locked		: out STD_LOGIC;
		serdes_strobe	: out STD_LOGIC
	);
	END COMPONENT;
	
	COMPONENT edid_rom_0
		port ( clk      	: in    std_logic;
          sclk_raw 		: in    std_logic;
          sdat_raw 		: inout std_logic := 'Z';
          edid_debug 	: out std_logic_vector(2 downto 0) := (others => '0')
		);
  END COMPONENT;

	signal pclk_unbuffered 			: std_logic;
	signal pclk_buffered				: std_logic;
	signal serdes_strobe				: std_logic;
	signal pll_locked					: std_logic;
	signal pclk_x1						: std_logic;
	signal pclk_x2						: std_logic;
	signal pclk_x10					: std_logic;
	signal red_tmds					: std_logic;
	signal green_tmds					: std_logic;
	signal blue_tmds					: std_logic;

	begin
	pclk <= pclk_buffered;

------------------------------------
-- Input:	 Differential pixel clock
-- Output:	 Single-line pixel clock
------------------------------------
		p_clk_diff_input : IBUFDS
			generic map(
				DIFF_TERM 		=> FALSE,
				IBUF_LOW_PWR	=> TRUE,
				IOSTANDARD		=> "TMDS_33")
			PORT map(
				O 					=> pclk_unbuffered,
				I					=> hdmi_in_p(3),
				IB					=> hdmi_in_n(3)
			);
			
------------------------------------
-- Input:	Unbuffered pixel clock
-- Output:	Buffered pixel clock
------------------------------------
		p_clk_buffer : BUFG
			PORT map(
				I					=> pclk_unbuffered,
				O					=>	pclk_buffered
			);
			
------------------------------------
-- Input: Differential TMDS RGB
-- Output: single-ended TMDS RGB
------------------------------------
		red_tmds_diff : IBUFDS
			generic map(
				DIFF_TERM 		=> FALSE,
				IBUF_LOW_PWR	=> TRUE,
				IOSTANDARD		=> "TMDS_33")
			PORT map(
				O 					=> red_tmds,
				I					=> hdmi_in_p(0),
				IB					=> hdmi_in_n(0)
			);

		green_tmds_diff : IBUFDS
			generic map(
				DIFF_TERM 		=> FALSE,
				IBUF_LOW_PWR	=> TRUE,
				IOSTANDARD		=> "TMDS_33")
			PORT map(
				O 					=> green_tmds,
				I					=> hdmi_in_p(1),
				IB					=> hdmi_in_n(1)
			);

		blue_tmds_diff : IBUFDS
			generic map(
				DIFF_TERM 		=> FALSE,
				IBUF_LOW_PWR	=> TRUE,
				IOSTANDARD		=> "TMDS_33")
			PORT map(
				O 					=> blue_tmds,
				I					=> hdmi_in_p(2),
				IB					=> hdmi_in_n(2)
			);			
-------------------------------------
-- Component: 	pixel clock multiplier
-- Input: 		pixel clock
-- Outputs: 	Pclk_x1, pclk_x2, pclk_x3, strobe_serdes
-------------------------------------
		input_clk_multiplier : Pixel_clock_multiplier
		PORT map(
			pclk_in			=> pclk_buffered,
			pclk_o_x1		=> pclk_x1,
			pclk_o_x2		=> pclk_x2,
			pclk_o_x10		=> pclk_x10,
			pll_locked		=> pll_locked,
			serdes_strobe	=> serdes_strobe
		);
		
--------------------------------------
-- Component:	EDID rom for input 0
-- Input:		GCLK
-- In/Outputs:	sclk, sdat
--------------------------------------
		edid_rom_port_0 : edid_rom_0
		Port map(
			clk      		=> gclk,
			sclk_raw 		=> ddc_sclk,
			sdat_raw 		=> ddc_sdat,
			edid_debug 		=> open
		);
			
end Behavioral;

