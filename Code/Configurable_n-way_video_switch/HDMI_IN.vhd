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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity HDMI_IN is
	PORT(
			hdmi_in_p		: in STD_LOGIC_VECTOR(3 downto 0) := (others => '1');
			hdmi_in_n		: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
			ddc_sclk			: in STD_LOGIC := '0';
			ddc_sdat			: inout STD_LOGIC := 'Z';
			gclk				: in STD_LOGIC := '0';
			red_c				: out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
			green_c			: out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
			blue_c			: out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
			v_count			: out STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
			active_video	: out STD_LOGIC := '0';		
			new_frame		: out STD_LOGIC := '0';
			ready				: out STD_LOGIC := '0';
			pclk				: inout STD_LOGIC  := '1';
			pclk_x2			: out STD_LOGIC := '0';
			pclk_x10			: out STD_LOGIC := '0';
			serdes_strobe  : out STD_LOGIC := '0';
			leds				: out STD_LOGIC_VECTOR(7 downto 0)
			
			);
end HDMI_IN;

architecture Behavioral of HDMI_IN is

	signal v_count_i			: std_logic_vector(11 downto 0) := (others => '0');
	signal active_video_i 	: std_logic := '0';
	signal new_frame_i		: std_logic := '0';
	signal h_sync_i			: std_logic := '0';
	signal v_sync_i			: std_logic := '0';
	signal ready_rdy			: std_logic := '0';
	signal ready_i				: std_logic := '0';		
	signal rx_red_rdy			: std_logic := '0';
	signal rx_green_rdy		: std_logic := '0';
	signal rx_blue_rdy		: std_logic := '0';
	signal pll_locked			: std_logic := '0';
	
	signal active_video_i_p1 : std_logic := '0';
	
	type FRAME_STATE_TYPES is (INIT, INIT_DONE, LINE, LINE_END, V_COUNT_STATE, NEW_FRAME_STATE); 
	
	signal FRAME_STATE 		: FRAME_STATE_TYPES := INIT;
	COMPONENT edid_rom_0
		port ( clk      	: in    std_logic;
          sclk_raw 		: in    std_logic;
          sdat_raw 		: inout std_logic;
          edid_debug 	: out std_logic_vector(2 downto 0) := (others => '0')
		);
  END COMPONENT;
  
  COMPONENT dvi_decoder 
		port (
			tmdsclk_p		: in 		std_logic;
			tmdsclk_n		: in 		std_logic;
			blue_p			: in 		std_logic;
			green_p			: in 		std_logic;
			red_p				: in 		std_logic; 
			blue_n			: in 		std_logic;
			green_n			: in 		std_logic;   
			red_n				: in 		std_logic;
			exrst				: in 		std_logic;
			reset				: out 	std_logic;
			pclk				: out 	std_logic;
			pclkx2			: out 	std_logic;
			pclkx10			: out 	std_logic;
			pllclk0			: out 	std_logic;
			pllclk1			: out 	std_logic;
			pllclk2			: out		std_logic;
			pll_lckd			: out		std_logic;
			serdesstrobe	: out		std_logic;
			tmdsclk			: out		std_logic;
			hsync				: out 	std_logic;
			vsync				: out		std_logic;
			de					: out 	std_logic;
			blue_vld			: out 	std_logic;
			green_vld		: out		std_logic;
			red_vld			: out 	std_logic;
			blue_rdy			: out		std_logic;
			green_rdy		: out 	std_logic;
			red_rdy			: out 	std_logic;
			psalgnerr		: out		std_logic;
			sdout				: out		std_logic_vector(29 downto 0);
			red				: out		std_logic_vector(7 downto 0);
			green				: out		std_logic_vector(7 downto 0);    
			blue				: out		std_logic_vector(7 downto 0)
			);
			END COMPONENT;

	

begin

	v_count <= v_count_i when ready_i = '1' and not(FRAME_STATE = INIT) else (others => '0');
	active_video <= active_video_i_p1 when ready_rdy = '1' else '0';
	ready_rdy <= '1' when rx_red_rdy = '1' and rx_green_rdy = '1' and rx_blue_rdy = '1' else '0';
	ready <= ready_i;
	new_frame <= new_frame_i;
	
	
	
	leds(0) <= pclk;
	leds(1) <= rx_red_rdy;
	leds(2) <= rx_green_rdy;
	leds(3) <= rx_blue_rdy;
	leds(4) <= ready_rdy;
	leds(5) <= ready_i;
	leds(6) <= v_sync_i;
	leds(7) <= active_video_i;

		
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
		
		input_decoder : dvi_decoder 
		port map (
			tmdsclk_p		=> hdmi_in_p(3),
			tmdsclk_n		=> hdmi_in_n(3),
			blue_p			=> hdmi_in_p(0),
			green_p			=> hdmi_in_p(1),
			red_p				=> hdmi_in_p(2), 
			blue_n			=> hdmi_in_n(0),
			green_n			=> hdmi_in_n(1),  
			red_n				=> hdmi_in_n(2),
			exrst				=> '0',
			reset				=> open,
			pclk				=> pclk,
			pclkx2			=> pclk_x2,
			pclkx10			=> pclk_x10,
			pllclk0			=> open,
			pllclk1			=> open,
			pllclk2			=> open,
			pll_lckd			=> pll_locked,
			serdesstrobe	=> serdes_strobe,
			tmdsclk			=> open,
			hsync				=> h_sync_i,
			vsync				=> v_sync_i,
			de					=> active_video_i,
			blue_vld			=> open,
			green_vld		=> open,
			red_vld			=> open,
			blue_rdy			=> rx_blue_rdy,
			green_rdy		=> rx_green_rdy,
			red_rdy			=> rx_red_rdy,
			psalgnerr		=> open,
			sdout				=> open,
			red				=> red_c,
			green				=> green_c,   
			blue				=> blue_c
			);
			
			
		pipeline : PROCESS(pclk)
		begin
			if rising_edge(pclk) then
				active_video_i_p1 <= active_video_i;
			end if;
		end process pipeline;
	
		v_counter : PROCESS(pclk)
		begin
			if rising_edge(pclk) then
				if pll_locked = '0' then
					FRAME_STATE <= INIT;
				else
					case FRAME_STATE is
					when INIT =>
						if ready_rdy = '1' and v_sync_i = '1' and active_video_i = '0' then
							FRAME_STATE <= INIT_DONE;
						end if;
						
					when INIT_DONE =>
						ready_i <= '1';
						if active_video_i = '1' then
							FRAME_STATE <= LINE;
						end if;
						
					when LINE =>
						new_frame_i <= '0';
						if active_video_i = '0' then
							FRAME_STATE <= LINE_END;
						end if;
						
					when LINE_END =>
						if h_sync_i = '1' then
							FRAME_STATE <= V_COUNT_STATE;
							v_count_i <= v_count_i + 1;					
						end if;
						
					when V_COUNT_STATE =>
						if active_video_i = '1' then
							FRAME_STATE <= LINE;
						elsif v_sync_i = '1' then
							FRAME_STATE <= NEW_FRAME_STATE;
						end if;
					
					when NEW_FRAME_STATE =>
						v_count_i <= (others => '0');
						
						if active_video_i = '1' then
							FRAME_STATE <= LINE;
							new_frame_i <= '1';
						end if;
					
					when others =>
						FRAME_STATE <= INIT;
					end case;
				
				end if;
			end if;
		end process v_counter;
			
end Behavioral;

