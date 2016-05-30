----------------------------------------------------------------------------------
-- Company: SDU
-- Engineer: Nikolaj Leth
-- 
-- Create Date:    16:49:47 02/14/2016 
-- Design Name: 	 Configurable n-way video splitter
-- Module Name:    Video_splitter - Structural 
-- Project Name:   Configurable n-way video splitter
-- Target Devices: Spartan 6 (Digilent Atlys)
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library UNISIM;
use UNISIM.VComponents.all;


entity Video_Switch is
	Port(
			-- Global clock
			GCLK						: in STD_LOGIC := '0';
			
			reset_btn				: in STD_LOGIC := '0';
			
			-- LEDS
			leds						: out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
			
			-- Inputs TMDS
			hdmi_port_0_in_p		: in STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_0_in_n		: in STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_1_in_p		: in STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_1_in_n		: in STD_LOGIC_VECTOR(3 downto 0);
			
			-- Inputs DDC

			hdmi_port_1_sclk		: in STD_LOGIC;
			hdmi_port_1_sdat		: inout STD_LOGIC;
			
			-- Outputs TMDS
			hdmi_port_0_out_p		: out STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_0_out_n		: out STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_1_out_p		: out STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_1_out_n		: out STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_2_out_p		: out STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_2_out_n		: out STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_3_out_p		: out STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_3_out_n		: out STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_4_out_p		: out STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_4_out_n		: out STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_5_out_p		: out STD_LOGIC_VECTOR(3 downto 0);
			hdmi_port_5_out_n		: out STD_LOGIC_VECTOR(3 downto 0);
			
			
			-- Memory
			mcb3_dram_a                             : out std_logic_vector(12 downto 0);
			mcb3_dram_ba                            : out std_logic_vector(2 downto 0);
			mcb3_dram_cas_n                         : out std_logic;
			mcb3_dram_ck                            : out std_logic;
			mcb3_dram_ck_n                          : out std_logic;
			mcb3_dram_cke                           : out std_logic;
			mcb3_dram_dm                            : out std_logic;
			mcb3_dram_dq                            : inout  std_logic_vector(15 downto 0);
			mcb3_dram_dqs                           : inout  std_logic;
			mcb3_dram_dqs_n                         : inout  std_logic;
			mcb3_dram_odt                           : out std_logic;
			mcb3_dram_ras_n                         : out std_logic;
			mcb3_dram_udm                           : out std_logic;
			mcb3_dram_udqs                          : inout  std_logic;
			mcb3_dram_udqs_n                        : inout  std_logic;
			mcb3_dram_we_n                          : out std_logic;
			mcb3_rzq                                : inout  std_logic;
			mcb3_zio                                : inout  std_logic;
			
			-- UART
			uart_tx											 : out std_logic;
			uart_rx											 : in std_logic			
			);
			
	
			
			
			
			
end Video_Switch;

architecture Structural of Video_Switch is

	signal global_pixel_clock					: std_logic := '0';
	signal global_pixel_clock_I0				: std_logic := '0';
	signal global_pixel_clock_x1				: std_logic := '0';
	signal global_pixel_clock_x2				: std_logic := '0';
	signal global_pixel_clock_x10_b0			: std_logic := '0';
	signal global_pixel_clock_x10_b2			: std_logic := '0';
	signal global_output_h_sync 				: std_logic := '0';
	signal global_output_h_sync_controller : std_logic := '0';
	signal global_output_v_sync 				: std_logic := '0';
	signal global_output_v_sync_controller : std_logic := '0';
	signal global_output_active_video 		: std_logic := '0';
	signal global_output_active_video_controller : std_logic := '0';
	signal global_pll_locked					: std_logic := '0';
	signal global_serdes_strobe_b0			: std_logic := '0';
	signal global_serdes_strobe_b2			: std_logic := '0';
	signal global_h_count_pixel_out			: std_logic_vector(11 downto 0) := (others => '0');
	signal global_v_count_pixel_out			: std_logic_vector(11 downto 0) := (others => '0');
	
	signal ready_I1								: std_logic := '0';
	signal ready_I0								: std_logic := '0';
	
	signal colors_I1								: std_logic_vector(23 downto 0);
	signal colors_I0								: std_logic_vector(23 downto 0);
	
	signal v_count_I1								: std_logic_vector(11 downto 0) := (others => '0');
	signal v_count_I0								: std_logic_vector(11 downto 0) := (others => '0');
	
	signal active_video_I1						: std_logic := '0';
	signal active_video_I0						: std_logic := '0';
	
	signal new_frame_I0							: std_logic := '0';
	signal new_frame_I1							: std_logic := '0';
	
	signal BRAM_clock_out_enable				: std_logic := '0';
	signal P0_BRAM_enable						: std_logic := '0';
	signal P0_BRAM_h_count						: std_logic_vector(10 downto 0) := (others => '0');
	signal P0_BRAM_data_out						: std_logic_vector(23 downto 0) := (others => '0');
	signal P0_data_out							: std_logic_vector(23 downto 0) := (others => '0');
	signal P0_BRAM_I_selector					: std_logic := '0';
	signal P0_BRAM_S_selector					: std_logic := '0';
	signal P1_BRAM_enable						: std_logic := '0';
	signal P1_BRAM_h_count						: std_logic_vector(10 downto 0) := (others => '0');
	signal P1_BRAM_data_out						: std_logic_vector(23 downto 0) := (others => '0');
	signal P1_data_out							: std_logic_vector(23 downto 0) := (others => '0');
	signal P1_BRAM_I_selector					: std_logic := '0';
	signal P1_BRAM_S_selector					: std_logic := '0';
	signal P2_BRAM_enable						: std_logic := '0';
	signal P2_BRAM_h_count						: std_logic_vector(10 downto 0) := (others => '0');
	signal P2_BRAM_data_out						: std_logic_vector(23 downto 0) := (others => '0');
	signal P2_data_out							: std_logic_vector(23 downto 0) := (others => '0');
	signal P2_BRAM_I_selector					: std_logic := '0';
	signal P2_BRAM_S_selector					: std_logic := '0';
	signal P3_BRAM_enable						: std_logic := '0';
	signal P3_BRAM_h_count						: std_logic_vector(10 downto 0) := (others => '0');
	signal P3_BRAM_data_out						: std_logic_vector(23 downto 0) := (others => '0');
	signal P3_data_out							: std_logic_vector(23 downto 0) := (others => '0');
	signal P3_BRAM_I_selector					: std_logic := '0';
	signal P3_BRAM_S_selector					: std_logic := '0';
	signal P4_BRAM_enable						: std_logic := '0';
	signal P4_BRAM_h_count						: std_logic_vector(10 downto 0) := (others => '0');
	signal P4_BRAM_data_out						: std_logic_vector(23 downto 0) := (others => '0');
	signal P4_data_out							: std_logic_vector(23 downto 0) := (others => '0');
	signal P4_BRAM_I_selector					: std_logic := '0';
	signal P4_BRAM_S_selector					: std_logic := '0';
	signal P5_BRAM_enable						: std_logic := '0';
	signal P5_BRAM_h_count						: std_logic_vector(10 downto 0) := (others => '0');
	signal P5_BRAM_data_out						: std_logic_vector(23 downto 0) := (others => '0');
	signal P5_data_out							: std_logic_vector(23 downto 0) := (others => '0');
	signal P5_BRAM_I_selector					: std_logic := '0';
	signal P5_BRAM_S_selector					: std_logic := '0';
	
	 signal color_in								: std_logic_vector(23 downto 0) := (others => '0');
	 signal color_in_2							: std_logic_vector(23 downto 0) := (others => '0');
	 
	signal reset									: std_logic := '0';
	
	signal color_red, color_blue, color_green 				: std_logic_vector(7 downto 0) := (others => '0');
	signal g_color_red, g_color_green, g_color_blue 		: std_logic_vector(7 downto 0) := (others => '0');
	
	signal GCLK_i									: std_logic := '0';
	
	signal DDR_p2_cmd_en							: STD_LOGIC := '0';
	signal DDR_p2_cmd_byte_addr				: STD_LOGIC_VECTOR(29 downto 0) := (others => '0');
	signal DDR_p2_cmd_full						: STD_LOGIC := '0';
	signal DDR_p2_cmd_empty						: STD_LOGIC := '1';
	signal DDR_p2_wr_en							: STD_LOGIC := '0';
	signal DDR_p2_wr_data						: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal DDR_p2_wr_full						: STD_LOGIC := '0';
	signal DDR_p2_wr_empty						: STD_LOGIC := '1';
	
	
	signal DDR_p3_cmd_en							: STD_LOGIC := '0';
	signal DDR_p3_cmd_byte_addr				: STD_LOGIC_VECTOR(29 downto 0) := (others => '0');
	signal DDR_p3_cmd_full						: STD_LOGIC := '0';
	signal DDR_p3_cmd_empty						: STD_LOGIC := '1';
	signal DDR_p3_wr_en							: STD_LOGIC := '0';
	signal DDR_p3_wr_data						: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal DDR_p3_wr_full						: STD_LOGIC := '0';
	signal DDR_p3_wr_empty						: STD_LOGIC := '1';
	
	
	signal p0_h_count_out_I0					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p0_BRAM_out_I0						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal p1_h_count_out_I0					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p1_BRAM_out_I0						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal p2_h_count_out_I0					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p2_BRAM_out_I0						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal p3_h_count_out_I0					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p3_BRAM_out_I0						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal p4_h_count_out_I0					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p4_BRAM_out_I0						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal p5_h_count_out_I0					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p5_BRAM_out_I0						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal DDR_p4_cmd_en							: STD_LOGIC := '0';
	signal DDR_p4_cmd_bl							: STD_LOGIC_VECTOR(5 downto 0) := "011111";
	signal DDR_p4_cmd_byte_addr				: STD_LOGIC_VECTOR(29 downto 0) := (others => '0');
	signal DDR_p4_cmd_empty						: STD_LOGIC := '1';
	signal DDR_p4_cmd_full						: STD_LOGIC := '0';
	signal DDR_p4_rd_en							: STD_LOGIC := '0';
	signal DDR_p4_rd_data						: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal DDR_p4_rd_empty						: STD_LOGIC := '1';
	signal DDR_p4_rd_full						: STD_LOGIC := '0';
	
	
	
	signal p0_h_count_out_I1					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p0_BRAM_out_I1						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal p0_data_sel_out						: STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal p1_h_count_out_I1					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p1_BRAM_out_I1						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal p1_data_sel_out						: STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal p2_h_count_out_I1					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p2_BRAM_out_I1						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal p2_data_sel_out						: STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal p3_h_count_out_I1					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p3_BRAM_out_I1						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal p3_data_sel_out						: STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal p4_h_count_out_I1					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p4_BRAM_out_I1						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal p4_data_sel_out						: STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal p5_h_count_out_I1					: STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
	signal p5_BRAM_out_I1						: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal p5_data_sel_out						: STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal DDR_p5_cmd_en							: STD_LOGIC := '0';
	signal DDR_p5_cmd_bl							: STD_LOGIC_VECTOR(5 downto 0) := "011111";
	signal DDR_p5_cmd_byte_addr				: STD_LOGIC_VECTOR(29 downto 0) := (others => '0');
	signal DDR_p5_cmd_empty						: STD_LOGIC := '1';
	signal DDR_p5_cmd_full						: STD_LOGIC := '0';
	signal DDR_p5_rd_en							: STD_LOGIC := '0';
	signal DDR_p5_rd_data						: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal DDR_p5_rd_empty						: STD_LOGIC := '1';
	signal DDR_p5_rd_full						: STD_LOGIC := '0';
	signal change_S								: STD_LOGIC := '0';
	
	signal test_leds								: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	
	
	signal P0_conf									: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	signal P0_set_1								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P0_set_2								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P0_set_3								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P0_set_4								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P1_conf									: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	signal P1_set_1								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P1_set_2								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P1_set_3								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P1_set_4								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P2_conf									: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	signal P2_set_1								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P2_set_2								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P2_set_3								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P2_set_4								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P3_conf									: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	signal P3_set_1								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P3_set_2								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P3_set_3								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P3_set_4								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P4_conf									: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	signal P4_set_1								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P4_set_2								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P4_set_3								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P4_set_4								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P5_conf									: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	signal P5_set_1								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P5_set_2								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P5_set_3								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal P5_set_4								: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	
	signal GPI_1									: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal GPI_2									: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	signal GPI_3									: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	
	signal leds_big								: std_logic_vector(31 downto 0) := (others => '0');
	
	-----------
	-- Memory signals
	-----------
	 constant C3_P0_MASK_SIZE           : integer := 4;
    constant C3_P0_DATA_PORT_SIZE      : integer := 32;
    constant C3_P1_MASK_SIZE           : integer := 4;
    constant C3_P1_DATA_PORT_SIZE      : integer := 32;
    constant C3_MEMCLK_PERIOD          : integer := 2500;  -- note input clk is only 100 MHz, multiplier is edited to converto to 400 MHz
    constant C3_RST_ACT_LOW            : integer := 0;
    constant C3_INPUT_CLK_TYPE         : string := "SINGLE_ENDED";
    constant C3_CALIB_SOFT_IP          : string := "TRUE";
    constant C3_SIMULATION             : string := "FALSE";
    constant DEBUG_EN                  : integer := 0;
    constant C3_MEM_ADDR_ORDER         : string := "ROW_BANK_COLUMN";
    constant C3_NUM_DQ_PINS            : integer := 16;
    constant C3_MEM_ADDR_WIDTH         : integer := 13;
    constant C3_MEM_BANKADDR_WIDTH     : integer := 3;
	 
	 signal 	 ddr_calibration				: STD_LOGIC := '0';
	 signal 	 slow_count						: STD_LOGIC_VECTOR(25 downto 0) := (others => '0');
	 signal 	 slow_clock						: STD_LOGIC := '0';
	 signal 	 read_write_clock				: STD_LOGIC := '0';
	 signal	 diode_count					: STD_LOGIC_VECTOR (7 downto 0) := "01010101";
	 signal 	 leds_out						: STD_LOGIC_VECTOR (7 downto 0) := "10101010";
	 signal 	 out_data						: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	 signal	 in_data							: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	 
	COMPONENT mcs_0
  PORT (
    Clk : IN STD_LOGIC;
    Reset : IN STD_LOGIC;
    UART_Rx : IN STD_LOGIC;
    UART_Tx : OUT STD_LOGIC;
    GPO1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    GPO2 : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    GPO3 : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
END COMPONENT;

	COMPONENT Conf_Manager
    Port ( 
		Gclk 			: in  STD_LOGIC;
		GPI_1_in		: in 	STD_LOGIC_VECTOR(31 downto 0);
		GPI_2_in		: in 	STD_LOGIC_VECTOR(23 downto 0);
		GPI_3_in		: in	STD_LOGIC_VECTOR(23 downto 0);
		P0_conf		: out STD_LOGIC_VECTOR(3 downto 0);
		P0_set_1		: out STD_LOGIC_VECTOR(11 downto 0);
		P0_set_2		: out STD_LOGIC_VECTOR(11 downto 0);
		P0_set_3		: out STD_LOGIC_VECTOR(11 downto 0);
		P0_set_4		: out STD_LOGIC_VECTOR(11 downto 0);
		P1_conf		: out STD_LOGIC_VECTOR(3 downto 0);
		P1_set_1		: out STD_LOGIC_VECTOR(11 downto 0);
		P1_set_2		: out STD_LOGIC_VECTOR(11 downto 0);
		P1_set_3		: out STD_LOGIC_VECTOR(11 downto 0);
		P1_set_4		: out STD_LOGIC_VECTOR(11 downto 0);
		P2_conf		: out STD_LOGIC_VECTOR(3 downto 0);
		P2_set_1		: out STD_LOGIC_VECTOR(11 downto 0);
		P2_set_2		: out STD_LOGIC_VECTOR(11 downto 0);
		P2_set_3		: out STD_LOGIC_VECTOR(11 downto 0);
		P2_set_4		: out STD_LOGIC_VECTOR(11 downto 0);
		P3_conf		: out STD_LOGIC_VECTOR(3 downto 0);
		P3_set_1		: out STD_LOGIC_VECTOR(11 downto 0);
		P3_set_2		: out STD_LOGIC_VECTOR(11 downto 0);
		P3_set_3		: out STD_LOGIC_VECTOR(11 downto 0);
		P3_set_4		: out STD_LOGIC_VECTOR(11 downto 0);
		P4_conf		: out STD_LOGIC_VECTOR(3 downto 0);
		P4_set_1		: out STD_LOGIC_VECTOR(11 downto 0);
		P4_set_2		: out STD_LOGIC_VECTOR(11 downto 0);
		P4_set_3		: out STD_LOGIC_VECTOR(11 downto 0);
		P4_set_4		: out STD_LOGIC_VECTOR(11 downto 0);
		P5_conf		: out STD_LOGIC_VECTOR(3 downto 0);
		P5_set_1		: out STD_LOGIC_VECTOR(11 downto 0);
		P5_set_2		: out STD_LOGIC_VECTOR(11 downto 0);
		P5_set_3		: out STD_LOGIC_VECTOR(11 downto 0);
		P5_set_4		: out STD_LOGIC_VECTOR(11 downto 0)		
		);
END COMPONENT;
	 
	COMPONENT Input_to_DDR_controller
    Port ( 
				pixel_clock_I0 									: in  STD_LOGIC;
				pixel_clock_I1										: in 	STD_LOGIC;
				h_count_I0											: in 	STD_LOGIC_VECTOR(10 downto 0);
				h_count_I1											: in 	STD_LOGIC_VECTOR(10 downto 0);
				v_count_I0											: in 	STD_LOGIC_VECTOR(10 downto 0);
				v_count_I1											: in 	STD_LOGIC_VECTOR(10 downto 0);
				active_video_I0									: in 	STD_LOGIC;
				active_video_I1									: in	STD_LOGIC;
				video_in_I0											: in 	STD_LOGIC_VECTOR(23 downto 0);
				video_in_I1											: in 	STD_LOGIC_VECTOR(23 downto 0);
				reset													: in  STD_LOGIC;
				ready_I0												: in 	STD_LOGIC;
				ready_I1												: in 	STD_LOGIC;
				new_frame_I0										: in 	STD_LOGIC;
				new_frame_I1										: in 	STD_LOGIC;
				DDR_p2_cmd_en                            : out std_logic;
				DDR_p2_cmd_byte_addr                     : out std_logic_vector(29 downto 0);
				DDR_p2_cmd_full                          : in std_logic;
				DDR_p2_cmd_empty									: in STD_LOGIC;
				DDR_p2_wr_en                             : out std_logic;
				DDR_p2_wr_data                           : out std_logic_vector(31 downto 0);
				DDR_p2_wr_full                           : in std_logic;
				DDR_p2_wr_empty                          : in std_logic;				
				DDR_p3_cmd_en                            : out std_logic;
				DDR_p3_cmd_byte_addr                     : out std_logic_vector(29 downto 0);
				DDR_p3_cmd_full                          : in std_logic;	
				DDR_p3_cmd_empty									: in std_logic;
				DDR_p3_wr_en                             : out std_logic;
				DDR_p3_wr_data                           : out std_logic_vector(31 downto 0);
				DDR_p3_wr_full                           : in std_logic;
				DDR_p3_wr_empty                          : in std_logic
			);
	END COMPONENT;
	
	
	COMPONENT DDR_to_BRAM_controller is
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
	END COMPONENT;

	COMPONENT BRAM_interface
    Port (
		BRAM_enable 		: in STD_LOGIC;
		clk_out				: in STD_LOGIC;
		clk_in				: in STD_LOGIC;
		clk_out_enable    : in STD_LOGIC;
		P0_enable			: in STD_LOGIC;
		P0_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0);
		P0_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0);
		P0_data_out			: out STD_LOGIC_VECTOR(23 downto 0);
		P0_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0);
		P0_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0);
		P0_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0);
		P0_data_select_in : in STD_LOGIC_VECTOR(1 downto 0);
		P0_I_select_out	: in STD_LOGIC;
		P0_S_select			: in STD_LOGIC;
		P1_enable			: in STD_LOGIC;
		P1_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0);
		P1_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0);
		P1_data_out			: out STD_LOGIC_VECTOR(23 downto 0);
		P1_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0);
		P1_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0);
		P1_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0);
		P1_data_select_in : in STD_LOGIC_VECTOR(1 downto 0);
		P1_I_select_out	: in STD_LOGIC;
		P1_S_select			: in STD_LOGIC;
		P2_enable			: in STD_LOGIC;
		P2_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0);
		P2_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0);
		P2_data_out			: out STD_LOGIC_VECTOR(23 downto 0);
		P2_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0);
		P2_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0);
		P2_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0);
		P2_data_select_in : in STD_LOGIC_VECTOR(1 downto 0);
		P2_I_select_out	: in STD_LOGIC;
		P2_S_select			: in STD_LOGIC;
		P3_enable			: in STD_LOGIC;
		P3_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0);
		P3_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0);
		P3_data_out			: out STD_LOGIC_VECTOR(23 downto 0);
		P3_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0);
		P3_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0);
		P3_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0);
		P3_data_select_in : in STD_LOGIC_VECTOR(1 downto 0);
		P3_I_select_out	: in STD_LOGIC;
		P3_S_select			: in STD_LOGIC;
		P4_enable			: in STD_LOGIC;
		P4_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0);
		P4_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0);
		P4_data_out			: out STD_LOGIC_VECTOR(23 downto 0);
		P4_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0);
		P4_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0);
		P4_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0);
		P4_data_select_in : in STD_LOGIC_VECTOR(1 downto 0);
		P4_I_select_out	: in STD_LOGIC;
		P4_S_select			: in STD_LOGIC;
		P5_enable			: in STD_LOGIC;
		P5_data_in_I0		: in STD_LOGIC_VECTOR(23 downto 0);
		P5_data_in_I1		: in STD_LOGIC_VECTOR(23 downto 0);
		P5_data_out			: out STD_LOGIC_VECTOR(23 downto 0);
		P5_h_count_in_I0	: in STD_LOGIC_VECTOR(10 downto 0);
		P5_h_count_in_I1	: in STD_LOGIC_VECTOR(10 downto 0);
		P5_h_count_out		: in STD_LOGIC_VECTOR(10 downto 0);
		P5_data_select_in : in STD_LOGIC_VECTOR(1 downto 0);
		P5_I_select_out	: in STD_LOGIC;
		P5_S_select			: in STD_LOGIC
	 );
	END COMPONENT;

	COMPONENT Output_Controller
    Port ( 
		clk_in 				: in  STD_LOGIC := '0'; --- OBS x1 pixel clock
		global_h_count		: in STD_LOGIC_VECTOR(11 downto 0);
		global_v_count		: in STD_LOGIC_VECTOR(11 downto 0);
		global_h_sync		: in STD_LOGIC;
		global_v_sync		: in STD_LOGIC;
		global_output_h	: out STD_LOGIC;
		global_output_v	: out STD_LOGIC;
		global_active_v	: in STD_LOGIC;
		global_output_av	: out STD_LOGIC;
		BRAM_clock_out_e	: out STD_LOGIC;
		P0_conf				: in STD_LOGIC_VECTOR(3 downto 0);
		P0_set_1 			: in STD_LOGIC_VECTOR(11 downto 0);
		P0_set_2 			: in STD_LOGIC_VECTOR(11 downto 0);
		P0_set_3 			: in STD_LOGIC_VECTOR(11 downto 0);
		P0_set_4 			: in STD_LOGIC_VECTOR(11 downto 0);
		P0_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0);
		P0_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0);
		P0_video_out		: out STD_LOGIC_VECTOR(23 downto 0);
		P0_I_selector		: out STD_LOGIC;
		P0_S_selector		: inout STD_LOGIC;
		P0_enable			: out STD_LOGIC;
		P0_inload_done		: in STD_LOGIC;
		P0_unload_done 	: inout STD_LOGIC;
		P0_change_s			: out STD_LOGIC;
		P1_conf				: in STD_LOGIC_VECTOR(3 downto 0);
		P1_set_1 			: in STD_LOGIC_VECTOR(11 downto 0);
		P1_set_2 			: in STD_LOGIC_VECTOR(11 downto 0);
		P1_set_3 			: in STD_LOGIC_VECTOR(11 downto 0);
		P1_set_4 			: in STD_LOGIC_VECTOR(11 downto 0);
		P1_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0);
		P1_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0);
		P1_video_out		: out STD_LOGIC_VECTOR(23 downto 0);
		P1_I_selector		: out STD_LOGIC;
		P1_S_selector		: inout STD_LOGIC;
		P1_enable			: out STD_LOGIC;
		P1_inload_done		: in STD_LOGIC;
		P1_unload_done 	: inout STD_LOGIC;
		P1_change_s			: out STD_LOGIC;
		P2_conf				: in STD_LOGIC_VECTOR(3 downto 0);
		P2_set_1 			: in STD_LOGIC_VECTOR(11 downto 0);
		P2_set_2 			: in STD_LOGIC_VECTOR(11 downto 0);
		P2_set_3 			: in STD_LOGIC_VECTOR(11 downto 0);
		P2_set_4 			: in STD_LOGIC_VECTOR(11 downto 0);
		P2_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0);
		P2_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0);
		P2_video_out		: out STD_LOGIC_VECTOR(23 downto 0);
		P2_I_selector		: out STD_LOGIC;
		P2_S_selector		: inout STD_LOGIC;
		P2_enable			: out STD_LOGIC;
		P2_inload_done		: in STD_LOGIC;
		P2_unload_done 	: inout STD_LOGIC;
		P2_change_s			: out STD_LOGIC;
		P3_conf				: in STD_LOGIC_VECTOR(3 downto 0);
		P3_set_1 			: in STD_LOGIC_VECTOR(11 downto 0);
		P3_set_2 			: in STD_LOGIC_VECTOR(11 downto 0);
		P3_set_3 			: in STD_LOGIC_VECTOR(11 downto 0);
		P3_set_4 			: in STD_LOGIC_VECTOR(11 downto 0);
		P3_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0);
		P3_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0);
		P3_video_out		: out STD_LOGIC_VECTOR(23 downto 0);
		P3_I_selector		: out STD_LOGIC;
		P3_S_selector		: inout STD_LOGIC;
		P3_enable			: out STD_LOGIC;
		P3_inload_done		: in STD_LOGIC;
		P3_unload_done 	: inout STD_LOGIC;
		P3_change_s			: out STD_LOGIC;
		P4_conf				: in STD_LOGIC_VECTOR(3 downto 0);
		P4_set_1 			: in STD_LOGIC_VECTOR(11 downto 0);
		P4_set_2 			: in STD_LOGIC_VECTOR(11 downto 0);
		P4_set_3 			: in STD_LOGIC_VECTOR(11 downto 0);
		P4_set_4 			: in STD_LOGIC_VECTOR(11 downto 0);
		P4_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0);
		P4_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0);
		P4_video_out		: out STD_LOGIC_VECTOR(23 downto 0);
		P4_I_selector		: out STD_LOGIC;
		P4_S_selector		: inout STD_LOGIC;
		P4_enable			: out STD_LOGIC;
		P4_inload_done		: in STD_LOGIC;
		P4_unload_done 	: inout STD_LOGIC;
		P4_change_s			: out STD_LOGIC;
		P5_conf				: in STD_LOGIC_VECTOR(3 downto 0);
		P5_set_1 			: in STD_LOGIC_VECTOR(11 downto 0);
		P5_set_2 			: in STD_LOGIC_VECTOR(11 downto 0);
		P5_set_3 			: in STD_LOGIC_VECTOR(11 downto 0);
		P5_set_4 			: in STD_LOGIC_VECTOR(11 downto 0);
		P5_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0);
		P5_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0);
		P5_video_out		: out STD_LOGIC_VECTOR(23 downto 0);
		P5_I_selector		: out STD_LOGIC;
		P5_S_selector		: inout STD_LOGIC;
		P5_enable			: out STD_LOGIC;
		P5_inload_done		: in STD_LOGIC;
		P5_unload_done 	: inout STD_LOGIC;
		P5_change_s			: out STD_LOGIC
		);
		END COMPONENT;	

	COMPONENT HDMI_IN
	PORT(
			hdmi_in_p		: in STD_LOGIC_VECTOR(3 downto 0);
			hdmi_in_n		: in STD_LOGIC_VECTOR(3 downto 0);
			ddc_sclk			: in STD_LOGIC;
			ddc_sdat			: inout STD_LOGIC;
			gclk				: in STD_LOGIC;
			red_c				: out STD_LOGIC_VECTOR(7 downto 0);
			green_c			: out STD_LOGIC_VECTOR(7 downto 0);
			blue_c			: out STD_LOGIC_VECTOR(7 downto 0);
			v_count			: out STD_LOGIC_VECTOR(11 downto 0);
			active_video	: out STD_LOGIC;
			new_frame		: out STD_LOGIC;
			ready				: out STD_LOGIC;
			pclk				: inout STD_LOGIC;
			pclk_x2			: out STD_LOGIC;
			pclk_x10			: out STD_LOGIC;
			serdes_strobe  : out STD_LOGIC;
			leds				: out STD_LOGIC_VECTOR(7 downto 0)
			);
	END COMPONENT;
	
	COMPONENT HDMI_OUT
	PORT(
		Pixel_clock : in std_logic;
		clk_x1			: in std_logic;
		clk_x2			: in std_logic;
		clk_x10		: in std_logic;
		serdes_strobe : in std_logic;
		red_p      : IN std_logic_vector(7 downto 0);
		green_p    : IN std_logic_vector(7 downto 0);
		blue_p     : IN std_logic_vector(7 downto 0);
		active_video      : IN std_logic;
		hsync      : IN std_logic;
		vsync      : IN std_logic;          
		tmds_out_p : OUT std_logic_vector(3 downto 0);
		tmds_out_n : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	

	
	COMPONENT Resolution_output_timing
	generic (
				offset_h			: integer;
				offset_v			: integer
				);
    Port ( 
		     pixel_clock     : in std_logic;
			  red_p				: out std_logic_Vector(7 downto 0);
			  green_p			: out std_logic_Vector(7 downto 0);
			  blue_p 			: out std_logic_vector(7 downto 0);
           active_video   : inout STD_LOGIC;
           hsync   : out STD_LOGIC;
           vsync   : out STD_LOGIC;
			  h_count_out : out STD_LOGIC_VECTOR(11 downto 0);
			  v_count_out : out STD_LOGIC_VECTOR(11 downto 0);
			  Pll_locked : in  std_logic);
	END COMPONENT;
	

	
	COMPONENT Pixel_clock_multiplier is
	PORT(
		pclk_in			: in STD_LOGIC;
		pclk_o_x1		: out STD_LOGIC;
		pclk_o_x2		: out STD_LOGIC;
		pclk_o_x10_b0		: out STD_LOGIC;
		pclk_o_x10_b2  : out STD_LOGIC;
		pll_locked		: out STD_LOGIC;
		serdes_strobe_b0	: out STD_LOGIC;
		serdes_strobe_b2 : out STD_LOGIC);
	END COMPONENT;
	
	
	
	component DDR_Memory_Interface
 generic(
    C3_P0_MASK_SIZE           : integer;
    C3_P0_DATA_PORT_SIZE      : integer;
    C3_P1_MASK_SIZE           : integer;
    C3_P1_DATA_PORT_SIZE      : integer;
    C3_MEMCLK_PERIOD          : integer;   -- note input clk is only 100 MHz, multiplier is edited to converto to 400 MHz
    C3_RST_ACT_LOW            : integer;
    C3_INPUT_CLK_TYPE         : string;
    C3_CALIB_SOFT_IP          : string;
    C3_SIMULATION             : string;
    DEBUG_EN                  : integer;
    C3_MEM_ADDR_ORDER         : string;
    C3_NUM_DQ_PINS            : integer;
    C3_MEM_ADDR_WIDTH         : integer;
    C3_MEM_BANKADDR_WIDTH     : integer
);
    port (
   mcb3_dram_dq                            : inout  std_logic_vector(C3_NUM_DQ_PINS-1 downto 0);
   mcb3_dram_a                             : out std_logic_vector(C3_MEM_ADDR_WIDTH-1 downto 0);
   mcb3_dram_ba                            : out std_logic_vector(C3_MEM_BANKADDR_WIDTH-1 downto 0);
   mcb3_dram_ras_n                         : out std_logic;
   mcb3_dram_cas_n                         : out std_logic;
   mcb3_dram_we_n                          : out std_logic;
   mcb3_dram_odt                           : out std_logic;
   mcb3_dram_cke                           : out std_logic;
   mcb3_dram_dm                            : out std_logic;
   mcb3_dram_udqs                          : inout  std_logic;
   mcb3_dram_udqs_n                        : inout  std_logic;
   mcb3_rzq                                : inout  std_logic;
   mcb3_zio                                : inout  std_logic;
   mcb3_dram_udm                           : out std_logic;
   c3_sys_clk                              : in  std_logic;
   c3_sys_rst_i                            : in  std_logic;
   c3_calib_done                           : out std_logic;
   c3_clk0                                 : out std_logic;
   c3_rst0                                 : out std_logic;
   mcb3_dram_dqs                           : inout  std_logic;
   mcb3_dram_dqs_n                         : inout  std_logic;
   mcb3_dram_ck                            : out std_logic;
   mcb3_dram_ck_n                          : out std_logic;
   c3_p2_cmd_clk                           : in std_logic;
   c3_p2_cmd_en                            : in std_logic;
   c3_p2_cmd_instr                         : in std_logic_vector(2 downto 0);
   c3_p2_cmd_bl                            : in std_logic_vector(5 downto 0);
   c3_p2_cmd_byte_addr                     : in std_logic_vector(29 downto 0);
   c3_p2_cmd_empty                         : out std_logic;
   c3_p2_cmd_full                          : out std_logic;
   c3_p2_wr_clk                            : in std_logic;
   c3_p2_wr_en                             : in std_logic;
   c3_p2_wr_mask                           : in std_logic_vector(3 downto 0);
   c3_p2_wr_data                           : in std_logic_vector(31 downto 0);
   c3_p2_wr_full                           : out std_logic;
   c3_p2_wr_empty                          : out std_logic;
   c3_p2_wr_count                          : out std_logic_vector(6 downto 0);
   c3_p2_wr_underrun                       : out std_logic;
   c3_p2_wr_error                          : out std_logic;
   c3_p3_cmd_clk                           : in std_logic;
   c3_p3_cmd_en                            : in std_logic;
   c3_p3_cmd_instr                         : in std_logic_vector(2 downto 0);
   c3_p3_cmd_bl                            : in std_logic_vector(5 downto 0);
   c3_p3_cmd_byte_addr                     : in std_logic_vector(29 downto 0);
   c3_p3_cmd_empty                         : out std_logic;
   c3_p3_cmd_full                          : out std_logic;
   c3_p3_wr_clk                            : in std_logic;
   c3_p3_wr_en                             : in std_logic;
   c3_p3_wr_mask                           : in std_logic_vector(3 downto 0);
   c3_p3_wr_data                           : in std_logic_vector(31 downto 0);
   c3_p3_wr_full                           : out std_logic;
   c3_p3_wr_empty                          : out std_logic;
   c3_p3_wr_count                          : out std_logic_vector(6 downto 0);
   c3_p3_wr_underrun                       : out std_logic;
   c3_p3_wr_error                          : out std_logic;
   c3_p4_cmd_clk                           : in std_logic;
   c3_p4_cmd_en                            : in std_logic;
   c3_p4_cmd_instr                         : in std_logic_vector(2 downto 0);
   c3_p4_cmd_bl                            : in std_logic_vector(5 downto 0);
   c3_p4_cmd_byte_addr                     : in std_logic_vector(29 downto 0);
   c3_p4_cmd_empty                         : out std_logic;
   c3_p4_cmd_full                          : out std_logic;
   c3_p4_rd_clk                            : in std_logic;
   c3_p4_rd_en                             : in std_logic;
   c3_p4_rd_data                           : out std_logic_vector(31 downto 0);
   c3_p4_rd_full                           : out std_logic;
   c3_p4_rd_empty                          : out std_logic;
   c3_p4_rd_count                          : out std_logic_vector(6 downto 0);
   c3_p4_rd_overflow                       : out std_logic;
   c3_p4_rd_error                          : out std_logic;
   c3_p5_cmd_clk                           : in std_logic;
   c3_p5_cmd_en                            : in std_logic;
   c3_p5_cmd_instr                         : in std_logic_vector(2 downto 0);
   c3_p5_cmd_bl                            : in std_logic_vector(5 downto 0);
   c3_p5_cmd_byte_addr                     : in std_logic_vector(29 downto 0);
   c3_p5_cmd_empty                         : out std_logic;
   c3_p5_cmd_full                          : out std_logic;
   c3_p5_rd_clk                            : in std_logic;
   c3_p5_rd_en                             : in std_logic;
   c3_p5_rd_data                           : out std_logic_vector(31 downto 0);
   c3_p5_rd_full                           : out std_logic;
   c3_p5_rd_empty                          : out std_logic;
   c3_p5_rd_count                          : out std_logic_vector(6 downto 0);
   c3_p5_rd_overflow                       : out std_logic;
   c3_p5_rd_error                          : out std_logic
);
end component;
	
	
	

begin


clk_buf   : IBUFG port map ( O  => GCLK_i, I => GCLK);

reset <= not global_pll_locked;




------------------------------
-- HDMI input 1
-- Input: 	TMDS channels, ddc, gclk
-- Output: 	RGB channels, pixel clock
------------------------------
	hdmi_input_1 : HDMI_IN
	PORT map(
			hdmi_in_p		=> hdmi_port_1_in_p,
			hdmi_in_n		=> hdmi_port_1_in_n,
			ddc_sclk			=> hdmi_port_1_sclk,
			ddc_sdat			=> hdmi_port_1_sdat,
			gclk				=> GCLK_i,
			red_c				=> colors_I1(23 downto 16),
			green_c			=> colors_I1(15 downto 8),
			blue_c			=> colors_I1(7 downto 0),
			v_count			=> v_count_I1,
			active_video	=> active_video_I1,
			new_frame		=> new_frame_I1,
			ready				=> ready_I1,		
			pclk				=> global_pixel_clock,
			pclk_x2			=> open,
			pclk_x10			=> open,
			serdes_strobe  => open,
			leds				=> open

	);
	
--------------------------------
-- HDMI input 0
-- Input: 	TMDS channels, gclk
-- Output: 	RGB channels,
------------------------------
	hdmi_input_0 : HDMI_IN
	PORT map(
			hdmi_in_p		=> hdmi_port_0_in_p,
			hdmi_in_n		=> hdmi_port_0_in_n,
			ddc_sclk			=> '0',
			ddc_sdat			=> Open,
			gclk				=> GCLK_i,
			red_c				=> colors_I0(23 downto 16),
			green_c			=> colors_I0(15 downto 8),
			blue_c			=> colors_I0(7 downto 0),
			v_count			=> v_count_I0,
			active_video	=> active_video_I0,	
			new_frame		=> new_frame_I0,
			ready				=> ready_I0,
			pclk				=> global_pixel_clock_I0,
			pclk_x2			=> open,
			pclk_x10			=> open,
			serdes_strobe 	=> open,
			leds				=> open
			);
			
	
	
------------------------------
-- HDMI output 0
-- Input: 	RGB, clocks, sync
-- Output: 	TMDS signals
------------------------------
hdmi_output_0 : HDMI_OUT
		PORT MAP(
			Pixel_clock 		=> global_pixel_clock,
			clk_x1				=> global_pixel_clock_x1,
			clk_x2				=> global_pixel_clock_x2,
			clk_x10				=> global_pixel_clock_x10_b0,
			serdes_strobe		=> global_Serdes_strobe_b0,
			red_p      			=> P0_data_out(23 downto 16),
			green_p    			=> P0_data_out(15 downto 8),
			blue_p     			=> P0_data_out(7 downto 0),
			active_video      => global_output_active_video_controller,
			hsync      			=> global_output_h_sync_controller,
			vsync      			=> global_output_v_sync_controller,
			tmds_out_p 			=> hdmi_port_0_out_p,
			tmds_out_n 			=> hdmi_port_0_out_n
		);
		
		
hdmi_output_1 : HDMI_OUT
		PORT MAP(
			Pixel_clock 		=> global_pixel_clock,
			clk_x1				=> global_pixel_clock_x1,
			clk_x2				=> global_pixel_clock_x2,
			clk_x10				=> global_pixel_clock_x10_b2,
			serdes_strobe 		=> global_serdes_strobe_b2,
			red_p      			=> P1_data_out(23 downto 16),
			green_p    			=> P1_data_out(15 downto 8),
			blue_p     			=> P1_data_out(7 downto 0),
			active_video      => global_output_active_video_controller,
			hsync      			=> global_output_h_sync_controller,
			vsync      			=> global_output_v_sync_controller,
			tmds_out_p 			=> hdmi_port_1_out_p,
			tmds_out_n 			=> hdmi_port_1_out_n
		);
		
hdmi_output_2 : HDMI_OUT
		PORT MAP(
			Pixel_clock 		=> global_pixel_clock,
			clk_x1				=> global_pixel_clock_x1,
			clk_x2				=> global_pixel_clock_x2,
			clk_x10				=> global_pixel_clock_x10_b2,
			serdes_strobe 		=> global_serdes_strobe_b2,
			red_p      			=> P2_data_out(23 downto 16),
			green_p    			=> P2_data_out(15 downto 8),
			blue_p     			=> P2_data_out(7 downto 0),
			active_video      => global_output_active_video_controller,
			hsync      			=> global_output_h_sync_controller,
			vsync      			=> global_output_v_sync_controller,
			tmds_out_p 			=> hdmi_port_2_out_p,
			tmds_out_n 			=> hdmi_port_2_out_n
		);
		
hdmi_output_3 : HDMI_OUT
		PORT MAP(
			Pixel_clock 		=> global_pixel_clock,
			clk_x1				=> global_pixel_clock_x1,
			clk_x2				=> global_pixel_clock_x2,
			clk_x10				=> global_pixel_clock_x10_b2,
			serdes_strobe 		=> global_serdes_strobe_b2,
			red_p      			=> P3_data_out(23 downto 16),
			green_p    			=> P3_data_out(15 downto 8),
			blue_p     			=> P3_data_out(7 downto 0),
			active_video      => global_output_active_video_controller,
			hsync      			=> global_output_h_sync_controller,
			vsync      			=> global_output_v_sync_controller,
			tmds_out_p 			=> hdmi_port_3_out_p,
			tmds_out_n 			=> hdmi_port_3_out_n
		);
		
hdmi_output_4 : HDMI_OUT
		PORT MAP(
			Pixel_clock 		=> global_pixel_clock,
			clk_x1				=> global_pixel_clock_x1,
			clk_x2				=> global_pixel_clock_x2,
			clk_x10				=> global_pixel_clock_x10_b2,
			serdes_strobe 		=> global_serdes_strobe_b2,
			red_p      			=> P4_data_out(23 downto 16),
			green_p    			=> P4_data_out(15 downto 8),
			blue_p     			=> P4_data_out(7 downto 0),
			active_video      => global_output_active_video_controller,
			hsync      			=> global_output_h_sync_controller,
			vsync      			=> global_output_v_sync_controller,
			tmds_out_p 			=> hdmi_port_4_out_p,
			tmds_out_n 			=> hdmi_port_4_out_n
		);
		
hdmi_output_5 : HDMI_OUT
		PORT MAP(
			Pixel_clock 		=> global_pixel_clock,
			clk_x1				=> global_pixel_clock_x1,
			clk_x2				=> global_pixel_clock_x2,
			clk_x10				=> global_pixel_clock_x10_b2,
			serdes_strobe 		=> global_serdes_strobe_b2,
			red_p      			=> P5_data_out(23 downto 16),
			green_p    			=> P5_data_out(15 downto 8),
			blue_p     			=> P5_data_out(7 downto 0),
			active_video      => global_output_active_video_controller,
			hsync      			=> global_output_h_sync_controller,
			vsync      			=> global_output_v_sync_controller,
			tmds_out_p 			=> hdmi_port_5_out_p,
			tmds_out_n 			=> hdmi_port_5_out_n
		);
		
	


------------------------------
-- Global output Timing
-- Input: 	Pixel Clock
-- Output: 	Sync signals, position signals
------------------------------	


	
	global_output_timing : Resolution_output_timing 
	generic map(
				offset_h			=> 0,
				offset_v			=> 0
				)
    Port map ( 
		     pixel_clock    	=> global_pixel_clock,
           red_p   			=> open,
           green_p 			=> open,
           blue_p  			=> open,
           active_video 	=> global_output_active_video,
           hsync   			=> global_output_h_sync,
           vsync   			=> global_output_v_sync,
			  h_count_out 		=> global_h_count_pixel_out,
			  v_count_out 		=> global_v_count_pixel_out,
			  Pll_locked 		=> global_pll_locked
	);
	
	
	global_clock_multiplier : Pixel_clock_multiplier
	PORT map(
		pclk_in				=> global_pixel_clock,
		pclk_o_x1			=> global_pixel_clock_x1,
		pclk_o_x2			=> global_pixel_clock_x2,
		pclk_o_x10_b0		=> global_pixel_clock_x10_b0,
		pclk_o_x10_b2		=> global_pixel_clock_x10_b2,
		pll_locked			=> global_pll_locked,
		serdes_strobe_b0	=> global_serdes_strobe_b0,
		serdes_strobe_b2	=> global_serdes_Strobe_b2
	);
	
	
-------------------------------
-- DDR Memory Controller
-------------------------------
    u_DDR_Memory_Interface : DDR_Memory_Interface
    generic map (
    C3_P0_MASK_SIZE => C3_P0_MASK_SIZE,
    C3_P0_DATA_PORT_SIZE => C3_P0_DATA_PORT_SIZE,
    C3_P1_MASK_SIZE => C3_P1_MASK_SIZE,
    C3_P1_DATA_PORT_SIZE => C3_P1_DATA_PORT_SIZE,
    C3_MEMCLK_PERIOD => C3_MEMCLK_PERIOD,
    C3_RST_ACT_LOW => C3_RST_ACT_LOW,
    C3_INPUT_CLK_TYPE => C3_INPUT_CLK_TYPE,
    C3_CALIB_SOFT_IP => C3_CALIB_SOFT_IP,
    C3_SIMULATION => C3_SIMULATION,
    DEBUG_EN => DEBUG_EN,
    C3_MEM_ADDR_ORDER => C3_MEM_ADDR_ORDER,
    C3_NUM_DQ_PINS => C3_NUM_DQ_PINS,
    C3_MEM_ADDR_WIDTH => C3_MEM_ADDR_WIDTH,
    C3_MEM_BANKADDR_WIDTH => C3_MEM_BANKADDR_WIDTH
)
    port map (
		-- Global control pins
		c3_sys_clk  =>         GCLK_i,
		c3_sys_rst_i    =>       '0',                        

		-- Hardware control pins
		mcb3_dram_dq       =>    mcb3_dram_dq,  
		mcb3_dram_a        =>    mcb3_dram_a,  
		mcb3_dram_ba       =>    mcb3_dram_ba,
		mcb3_dram_ras_n    =>    mcb3_dram_ras_n,                        
		mcb3_dram_cas_n    =>    mcb3_dram_cas_n,                        
		mcb3_dram_we_n     =>    mcb3_dram_we_n,                          
		mcb3_dram_odt    	 =>    mcb3_dram_odt,
		mcb3_dram_cke      =>    mcb3_dram_cke,                          
		mcb3_dram_ck       =>    mcb3_dram_ck,                          
		mcb3_dram_ck_n     =>    mcb3_dram_ck_n,       
		mcb3_dram_dqs      =>    mcb3_dram_dqs,                          
		mcb3_dram_dqs_n  	 =>    mcb3_dram_dqs_n,
		mcb3_dram_udqs  	 =>    mcb3_dram_udqs,    -- for X16 parts           
		mcb3_dram_udqs_n   =>    mcb3_dram_udqs_n,  -- for X16 parts
		mcb3_dram_udm  	 =>    mcb3_dram_udm,     -- for X16 parts
		mcb3_dram_dm  		 =>    mcb3_dram_dm,
		mcb3_rzq        	 =>    mcb3_rzq,
		mcb3_zio        	 =>    mcb3_zio,
		
		-- Control Output Pins
		c3_clk0				 =>	        	Open,
		c3_rst0				 =>        		Open,
		c3_calib_done      =>    			ddr_calibration,
		
     
		-- Output port 2 control signals
		c3_p2_cmd_clk                           =>  global_pixel_clock_I0,
		c3_p2_cmd_en                            =>  DDR_p2_cmd_en,
		c3_p2_cmd_instr                         =>  "010",
		c3_p2_cmd_bl                            =>  "011111",
		c3_p2_cmd_byte_addr                     =>  DDR_p2_cmd_byte_addr,
		c3_p2_cmd_empty                         =>  DDR_p2_cmd_empty,
		c3_p2_cmd_full                          =>  DDR_p2_cmd_full,
		c3_p2_wr_clk                            =>  global_pixel_clock_I0,
		c3_p2_wr_en                             =>  DDR_p2_wr_en,
		c3_p2_wr_mask                           =>  "0000",
		c3_p2_wr_data                           =>  DDR_p2_wr_data,
		c3_p2_wr_full                           =>  DDR_p2_wr_full,
		c3_p2_wr_empty                          =>  DDR_p2_wr_empty,
		c3_p2_wr_count                          =>  Open,		-- Not used
		c3_p2_wr_underrun                       =>  open,		-- Not used
		c3_p2_wr_error                          =>  open,		-- Not used
		
		-- Output port 3 control signals
		c3_p3_cmd_clk                           =>  global_pixel_clock,
		c3_p3_cmd_en                            =>  DDR_p3_cmd_en,
		c3_p3_cmd_instr                         =>  "010",
		c3_p3_cmd_bl                            =>  "011111",		-- 15 means 16
		c3_p3_cmd_byte_addr                     =>  DDR_p3_cmd_byte_addr,
		c3_p3_cmd_empty                         =>  DDR_p3_cmd_empty,
		c3_p3_cmd_full                          =>  DDR_p3_cmd_full,
		c3_p3_wr_clk                            =>  global_pixel_clock,
		c3_p3_wr_en                             =>  DDR_p3_wr_en,
		c3_p3_wr_mask                           =>  "0000",	-- Not used
		c3_p3_wr_data                           =>  DDR_p3_wr_data,
		c3_p3_wr_full                           =>  DDR_p3_wr_full,
		c3_p3_wr_empty                          =>  DDR_p3_wr_empty,
		c3_p3_wr_count                          =>  Open,		-- not used
		c3_p3_wr_underrun                       =>  open,		-- Not used
		c3_p3_wr_error                          =>  open,		-- Not used
		
		-- Input port 4
		c3_p4_cmd_clk									 => global_pixel_clock,
		c3_p4_cmd_en                            =>  DDR_p4_cmd_en,
		c3_p4_cmd_instr                         =>  "011",
		c3_p4_cmd_bl                            =>  DDR_p4_cmd_bl,
		c3_p4_cmd_byte_addr                     =>  DDR_p4_cmd_byte_addr,
		c3_p4_cmd_empty                         =>  DDR_p4_cmd_empty,
		c3_p4_cmd_full                          =>  DDR_p4_cmd_full,
		c3_p4_rd_clk									 => global_pixel_clock,
		c3_p4_rd_en                             =>  DDR_p4_rd_en,
		c3_p4_rd_data                           =>  DDR_p4_rd_data,
		c3_p4_rd_full                           =>  DDR_p4_rd_full,
		c3_p4_rd_empty                          =>  DDR_p4_rd_empty,
		c3_p4_rd_count                          =>  Open,
		c3_p4_rd_overflow                       =>  open,
		c3_p4_rd_error                          =>  open,
		
		-- Input port 5
		c3_p5_cmd_clk									 => global_pixel_clock,
		c3_p5_cmd_en                            =>  DDR_p5_cmd_en,
		c3_p5_cmd_instr                         =>  "011",
		c3_p5_cmd_bl                            =>  DDR_p5_cmd_bl,
		c3_p5_cmd_byte_addr                     =>  DDR_p5_cmd_byte_addr,
		c3_p5_cmd_empty                         =>  DDR_p5_cmd_empty,
		c3_p5_cmd_full                          =>  DDR_p5_cmd_full,
		c3_p5_rd_clk									 => global_pixel_clock,
		c3_p5_rd_en                             =>  DDR_p5_rd_en,
		c3_p5_rd_data                           =>  DDR_p5_rd_data,
		c3_p5_rd_full                           =>  DDR_p5_rd_full,
		c3_p5_rd_empty                          =>  DDR_p5_rd_empty,
		c3_p5_rd_count                          =>  Open,
		c3_p5_rd_overflow                       =>  open,
		c3_p5_rd_error                          =>  open
);

	u_BRAM_interface : BRAM_interface
    Port map(
		BRAM_enable 		=> '1',
		clk_out				=> global_pixel_clock,
		clk_in				=> global_pixel_clock_x2,
		clk_out_enable    => BRAM_clock_out_enable,
		P0_enable			=> P0_BRAM_enable,
		P0_data_in_I0		=> p0_BRAM_out_I0,
		P0_data_in_I1		=> p0_BRAM_out_I1,
		P0_data_out			=> P0_BRAM_data_out,
		P0_h_count_in_I0	=> P0_h_count_out_I0,
		P0_h_count_in_I1	=> p0_h_count_out_I1,
		P0_h_count_out		=> P0_BRAM_h_count,
		P0_data_select_in => p0_data_sel_out,
		P0_I_select_out	=> P0_BRAM_I_selector,
		P0_S_select			=> P0_BRAM_S_selector,
		P1_enable			=> P1_BRAM_enable,
		P1_data_in_I0		=> p1_BRAM_out_I0,
		P1_data_in_I1		=> p1_BRAM_out_I1,
		P1_data_out			=> P1_BRAM_data_out,
		P1_h_count_in_I0	=> P1_h_count_out_I0,
		P1_h_count_in_I1	=> p1_h_count_out_I1,
		P1_h_count_out		=> P1_BRAM_h_count,
		P1_data_select_in => p1_data_sel_out,
		P1_I_select_out	=> P1_BRAM_I_selector,
		P1_S_select			=> P1_BRAM_S_selector,
		P2_enable			=> P2_BRAM_enable,
		P2_data_in_I0		=> p2_BRAM_out_I0,
		P2_data_in_I1		=> p2_BRAM_out_I1,
		P2_data_out			=> P2_BRAM_data_out,
		P2_h_count_in_I0	=> P2_h_count_out_I0,
		P2_h_count_in_I1	=> p2_h_count_out_I1,
		P2_h_count_out		=> P2_BRAM_h_count,
		P2_data_select_in => p2_data_sel_out,
		P2_I_select_out	=> P2_BRAM_I_selector,
		P2_S_select			=> P2_BRAM_S_selector,
		P3_enable			=> P3_BRAM_enable,
		P3_data_in_I0		=> p3_BRAM_out_I0,
		P3_data_in_I1		=> p3_BRAM_out_I1,
		P3_data_out			=> P3_BRAM_data_out,
		P3_h_count_in_I0	=> P3_h_count_out_I0,
		P3_h_count_in_I1	=> p3_h_count_out_I1,
		P3_h_count_out		=> P3_BRAM_h_count,
		P3_data_select_in => p3_data_sel_out,
		P3_I_select_out	=> P3_BRAM_I_selector,
		P3_S_select			=> P3_BRAM_S_selector,
		P4_enable			=> P4_BRAM_enable,
		P4_data_in_I0		=> p4_BRAM_out_I0,
		P4_data_in_I1		=> p4_BRAM_out_I1,
		P4_data_out			=> P4_BRAM_data_out,
		P4_h_count_in_I0	=> P4_h_count_out_I0,
		P4_h_count_in_I1	=> p4_h_count_out_I1,
		P4_h_count_out		=> P4_BRAM_h_count,
		P4_data_select_in => p4_data_sel_out,
		P4_I_select_out	=> P4_BRAM_I_selector,
		P4_S_select			=> P4_BRAM_S_selector,
		P5_enable			=> P5_BRAM_enable,
		P5_data_in_I0		=> p5_BRAM_out_I0,
		P5_data_in_I1		=> p5_BRAM_out_I1,
		P5_data_out			=> P5_BRAM_data_out,
		P5_h_count_in_I0	=> P5_h_count_out_I0,
		P5_h_count_in_I1	=> p5_h_count_out_I1,
		P5_h_count_out		=> P5_BRAM_h_count,
		P5_data_select_in => p5_data_sel_out,
		P5_I_select_out	=> P5_BRAM_I_selector,
		P5_S_select			=> P5_BRAM_S_selector
	 );
	 
color_in <= g_color_red & g_color_green & g_color_blue;
	 
	 u_output_controller : Output_Controller
    Port map ( 
		clk_in 				=> global_pixel_clock, --- OBS x1 pixel clock
		global_h_count		=> global_h_count_pixel_out,
		global_v_count		=> global_v_count_pixel_out,
		global_h_sync		=> global_output_h_sync,
		global_v_sync		=> global_output_v_sync,
		global_output_h	=> global_output_h_sync_controller,
		global_output_v	=> global_output_v_sync_controller,
		global_active_v	=> global_output_active_video,
		global_output_av	=> global_output_active_video_controller,
		BRAM_clock_out_e	=> BRAM_clock_out_enable,
		P0_conf				=> P0_conf,
		P0_set_1 			=> P0_set_1,
		P0_set_2 			=> P0_set_2,
		P0_set_3 			=> P0_set_3,
		P0_set_4 			=> P0_set_4,
		P0_h_count_out 	=> P0_BRAM_h_count,
		P0_BRAM_in			=> P0_BRAM_data_out,
		P0_video_out		=> P0_data_out,
		P0_I_selector		=> P0_BRAM_I_selector,
		P0_S_selector		=> P0_BRAM_S_selector,
		P0_enable			=> P0_BRAM_enable,
		P0_inload_done		=> '0',
		P0_unload_done		=> open,
		P0_change_s			=> change_S,
		P1_conf				=> P1_conf,
		P1_set_1 			=> P1_set_1,
		P1_set_2 			=> P1_set_2,
		P1_set_3 			=> P1_set_3,
		P1_set_4 			=> P1_set_4,
		P1_h_count_out 	=> P1_BRAM_h_count,
		P1_BRAM_in			=> P1_BRAM_data_out,
		P1_video_out		=> P1_data_out,
		P1_I_selector		=> P1_BRAM_I_selector,
		P1_S_selector		=> P1_BRAM_S_selector,
		P1_enable			=> P1_BRAM_enable,
		P1_inload_done		=> '0',
		P1_unload_done		=> open,
		P1_change_s			=> open,
		P2_conf				=> P2_conf,
		P2_set_1 			=> P2_set_1,
		P2_set_2 			=> P2_set_2,
		P2_set_3 			=> P2_set_3,
		P2_set_4 			=> P2_set_4,
		P2_h_count_out 	=> P2_BRAM_h_count,
		P2_BRAM_in			=> P2_BRAM_data_out,
		P2_video_out		=> P2_data_out,
		P2_I_selector		=> P2_BRAM_I_selector,
		P2_S_selector		=> P2_BRAM_S_selector,
		P2_enable			=> P2_BRAM_enable,
		P2_inload_done		=> '0',
		P2_unload_done		=> open,
		P3_change_s			=> open,
		P3_conf				=> P3_conf,
		P3_set_1 			=> P3_set_1,
		P3_set_2 			=> P3_set_2,
		P3_set_3 			=> P3_set_3,
		P3_set_4 			=> P3_set_4,
		P3_h_count_out 	=> P3_BRAM_h_count,
		P3_BRAM_in			=> P3_BRAM_data_out,
		P3_video_out		=> P3_data_out,
		P3_I_selector		=> P3_BRAM_I_selector,
		P3_S_selector		=> P3_BRAM_S_selector,
		P3_enable			=> P3_BRAM_enable,
		P3_inload_done		=> '0',
		P3_unload_done		=> open,
		P3_change_s			=> open,
		P4_conf				=> P4_conf,
		P4_set_1 			=> P4_set_1,
		P4_set_2 			=> P4_set_2,
		P4_set_3 			=> P4_set_3,
		P4_set_4 			=> P4_set_4,
		P4_h_count_out 	=> P4_BRAM_h_count,
		P4_BRAM_in			=> P4_BRAM_data_out,
		P4_video_out		=> P4_data_out,
		P4_I_selector		=> P4_BRAM_I_selector,
		P4_S_selector		=> P4_BRAM_S_selector,
		P4_enable			=> P4_BRAM_enable,
		P4_inload_done		=> '0',
		P4_unload_done		=> open,
		P4_change_s			=> open,
		P5_conf				=> P5_conf,
		P5_set_1 			=> P5_set_1,
		P5_set_2 			=> P5_set_2,
		P5_set_3 			=> P5_set_3,
		P5_set_4 			=> P5_set_4,
		P5_h_count_out 	=> P5_BRAM_h_count,
		P5_BRAM_in			=> P5_BRAM_data_out,
		P5_video_out		=> P5_data_out,
		P5_I_selector		=> P5_BRAM_I_selector,
		P5_S_selector		=> P5_BRAM_S_selector,
		P5_enable			=> P5_BRAM_enable,
		P5_inload_done		=> '0',
		P5_unload_done		=> open,
		P5_change_s			=> open
		);
		
	u_input_to_ddr_controller : Input_to_DDR_controller
    Port map ( 
				pixel_clock_I0										=> global_pixel_clock_I0,
				pixel_clock_I1										=> global_pixel_clock,
				h_count_I0											=> (others => '0'),
				h_count_I1											=> (others => '0'),
				v_count_I0											=> v_count_I0(10 downto 0),
				v_count_I1											=> v_count_I1(10 downto 0),
				active_video_I0									=> active_video_I0,
				active_video_I1									=> active_video_I1,
				video_in_I0											=> colors_I0,
				video_in_I1											=> colors_I1,
				reset													=> reset_btn,
				ready_I0												=> ready_I0,
				ready_I1												=> ready_I1,
				new_frame_I0										=> new_frame_I0,
				new_frame_I1										=> new_frame_I1,
				DDR_p2_cmd_en                            	=> DDR_p2_cmd_en,
				DDR_p2_cmd_byte_addr                     	=> DDR_p2_cmd_byte_addr,
				DDR_p2_cmd_full                          	=> DDR_p2_cmd_full,
				DDR_p2_cmd_empty									=> DDR_p2_cmd_empty,
				DDR_p2_wr_en                            	=> DDR_p2_wr_en,
				DDR_p2_wr_data                           	=> DDR_p2_wr_data,
				DDR_p2_wr_full                           	=> DDR_p2_wr_full,
				DDR_p2_wr_empty                        	=> DDR_p2_wr_empty,			
				DDR_p3_cmd_en                            	=> DDR_p3_cmd_en,
				DDR_p3_cmd_byte_addr                     	=> DDR_p3_cmd_byte_addr,
				DDR_p3_cmd_full                         	=> DDR_p3_cmd_full,
				DDR_p3_cmd_empty									=> DDR_p3_cmd_empty,
				DDR_p3_wr_en                             	=> DDR_p3_wr_en,
				DDR_p3_wr_data                           	=> DDR_p3_wr_data,
				DDR_p3_wr_full                           	=> DDR_p3_wr_full,
				DDR_p3_wr_empty                          	=> DDR_p3_wr_empty
			);
			
	u_ddr_to_bram_controller : DDR_to_BRAM_controller
    Port map ( 
		clk_in						=> global_pixel_clock,
		clk_in_x2					=> global_pixel_clock_x2,
		global_v_count				=> global_v_count_pixel_out,
		reset							=> reset_btn,
		P0_conf						=> P0_conf,
		P0_set_1 					=> P0_set_1,
		P0_set_2 					=> P0_set_2,
		P0_h_count_out_I0 		=> p0_h_count_out_I0,
		P0_h_count_out_I1 		=> p0_h_count_out_I1,
		P0_BRAM_out_I0				=> p0_BRAM_out_I0,
		P0_BRAM_out_I1				=> p0_BRAM_out_I1,
		P0_data_out_sel			=> p0_data_sel_out,
		P0_S_selector				=> P0_BRAM_S_selector,
		P0_inload_done				=> open,
		P1_conf						=> P1_conf,
		P1_set_1 					=> P1_set_1,
		P1_set_2 					=> P1_set_2,
		P1_h_count_out_I0 		=> p1_h_count_out_I0,
		P1_h_count_out_I1 		=> p1_h_count_out_I1,
		P1_BRAM_out_I0				=> p1_BRAM_out_I0,
		P1_BRAM_out_I1				=> p1_BRAM_out_I1,
		P1_data_out_sel			=> p1_data_sel_out,
		P1_S_selector				=> P1_BRAM_S_selector,
		P1_inload_done				=> open,	
		P2_conf						=> P2_conf,
		P2_set_1 					=> P2_set_1,
		P2_set_2 					=> P2_set_2,
		P2_h_count_out_I0 		=> p2_h_count_out_I0,
		P2_h_count_out_I1 		=> p2_h_count_out_I1,
		P2_BRAM_out_I0				=> p2_BRAM_out_I0,
		P2_BRAM_out_I1				=> p2_BRAM_out_I1,
		P2_data_out_sel			=> p2_data_sel_out,
		P2_S_selector				=> P2_BRAM_S_selector,
		P2_inload_done				=> open,	
		P3_conf						=> P3_conf,
		P3_set_1 					=> P3_set_1,
		P3_set_2 					=> P3_set_2,
		P3_h_count_out_I0 		=> p3_h_count_out_I0,
		P3_h_count_out_I1 		=> p3_h_count_out_I1,
		P3_BRAM_out_I0				=> p3_BRAM_out_I0,
		P3_BRAM_out_I1				=> p3_BRAM_out_I1,
		P3_data_out_sel			=> p3_data_sel_out,
		P3_S_selector				=> P3_BRAM_S_selector,
		P3_inload_done				=> open,	
		P4_conf						=> P4_conf,
		P4_set_1 					=> P4_set_1,
		P4_set_2 					=> P4_set_2,
		P4_h_count_out_I0 		=> p4_h_count_out_I0,
		P4_h_count_out_I1 		=> p4_h_count_out_I1,
		P4_BRAM_out_I0				=> p4_BRAM_out_I0,
		P4_BRAM_out_I1				=> p4_BRAM_out_I1,
		P4_data_out_sel			=> p4_data_sel_out,
		P4_S_selector				=> P4_BRAM_S_selector,
		P4_inload_done				=> open,	
		P5_conf						=> P5_conf,
		P5_set_1 					=> P5_set_1,
		P5_set_2 					=> P5_set_2,
		P5_h_count_out_I0 		=> p5_h_count_out_I0,
		P5_h_count_out_I1 		=> p5_h_count_out_I1,
		P5_BRAM_out_I0				=> p5_BRAM_out_I0,
		P5_BRAM_out_I1				=> p5_BRAM_out_I1,
		P5_data_out_sel			=> p5_data_sel_out,
		P5_S_selector				=> P5_BRAM_S_selector,
		P5_inload_done				=> open,			
		change_S						=> change_S,
		c3_p4_cmd_en            => DDR_p4_cmd_en,
		c3_p4_cmd_bl            => DDR_p4_cmd_bl,
		c3_p4_cmd_byte_addr     => DDR_p4_cmd_byte_addr,
		c3_p4_cmd_empty         =>	DDR_p4_cmd_empty,	
		c3_p4_rd_en             => DDR_p4_rd_en,
		c3_p4_rd_data           => DDR_p4_rd_data,
		c3_p4_rd_empty          => DDR_p4_rd_empty,
		c3_p5_cmd_en            => DDR_p5_cmd_en,
		c3_p5_cmd_bl            => DDR_p5_cmd_bl,
		c3_p5_cmd_byte_addr     => DDR_p5_cmd_byte_addr,
		c3_p5_cmd_empty         =>	DDR_p5_cmd_empty,	
		c3_p5_rd_en             => DDR_p5_rd_en,
		c3_p5_rd_data           => DDR_p5_rd_data,
		c3_p5_rd_empty          => DDR_p5_rd_empty,
		leds_out						=> test_leds
	 );
	 
	microblaze_mcs : mcs_0
  PORT MAP (
    Clk => gclk_i,
    Reset => '0',
    UART_Rx => uart_rx,
    UART_Tx => uart_tx,
    GPO1 => GPI_1,
    GPO2 => GPI_2,
    GPO3 => GPI_3
  );
  
  Configuration_manager : Conf_Manager 
    Port map ( 
		Gclk 			=> GCLK_i,
		GPI_1_in		=> GPI_1,
		GPI_2_in		=> GPI_2,
		GPI_3_in		=> GPI_3,
		P0_conf		=> P0_conf,
		P0_set_1		=> P0_set_1,
		P0_set_2		=> P0_set_2,
		P0_set_3		=> P0_set_3,
		P0_set_4		=> P0_set_4,
		P1_conf		=> P1_conf,
		P1_set_1		=> P1_set_1,
		P1_set_2		=> P1_set_2,
		P1_set_3		=> P1_set_3,
		P1_set_4		=> P1_set_4,
		P2_conf		=> P2_conf,
		P2_set_1		=> P2_set_1,
		P2_set_2		=> P2_set_2,
		P2_set_3		=> P2_set_3,
		P2_set_4		=> P2_set_4,
		P3_conf		=> P3_conf,
		P3_set_1		=> P3_set_1,
		P3_set_2		=> P3_set_2,
		P3_set_3		=> P3_set_3,
		P3_set_4		=> P3_set_4,
		P4_conf		=> P4_conf,
		P4_set_1		=> P4_set_1,
		P4_set_2		=> P4_set_2,
		P4_set_3		=> P4_set_3,
		P4_set_4		=> P4_set_4,
		P5_conf		=> P5_conf,
		P5_set_1		=> P5_set_1,
		P5_set_2		=> P5_set_2,
		P5_set_3		=> P5_set_3,
		P5_set_4		=> P5_set_4
		);

	
	leds <= GPI_1(7 downto 0);
	
	
	
				

			

	



end Structural;

