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
			GCLK						: in STD_LOGIC;
			
			-- LEDS
			leds						: out STD_LOGIC_VECTOR(7 downto 0);
			
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
			mcb3_zio                                : inout  std_logic
			
			
			);
			
			
			
			
			
end Video_Switch;

architecture Structural of Video_Switch is

	signal global_pixel_clock					: std_logic;
	signal global_pixel_clock_x1_b0			: std_logic;
	signal global_pixel_clock_x2_b0			: std_logic;
	signal global_pixel_clock_x10_b0			: std_logic;
	signal global_pixel_clock_x1_b1			: std_logic;
	signal global_pixel_clock_x2_b1			: std_logic;
	signal global_pixel_clock_x10_b1			: std_logic;
	signal global_output_h_sync 				: std_logic;
	signal global_output_v_sync 				: std_logic;
	signal global_output_active_video 		: std_logic;
	signal global_pll_locked					: std_logic := '0';
	signal global_pll_locked_b0				: std_logic;
	signal global_serdes_strobe_b0			: std_logic;
	signal global_pll_locked_b1				: std_logic;
	signal global_serdes_strobe_b1			: std_logic;
	signal pixel_h_count_i					: std_logic_vector(11 downto 0);
	signal pixel_v_count_i					: std_logic_vector(10 downto 0);
	
	signal color_red, color_blue, color_green : std_logic_vector(7 downto 0) := (others => '0');
	signal g_color_red, g_color_green, g_color_blue : std_logic_vector(7 downto 0);
	signal GCLK_i								: std_logic := '0';
	
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
    constant C3_MEM_ADDR_ORDER         : string := "BANK_ROW_COLUMN";
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
			pclk				: out STD_LOGIC		
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
	
	COMPONENT vga_gen
	PORT(
		clk50           : IN std_logic;          
		pixel_clock     : in std_logic;
		red_p           : OUT std_logic_vector(7 downto 0);
		green_p         : OUT std_logic_vector(7 downto 0);
		blue_p          : OUT std_logic_vector(7 downto 0);
		blank           : OUT std_logic;
		hsync           : OUT std_logic;
		vsync           : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT Resolution_output_timing
    Port ( 
		     pixel_clock     : in std_logic;
			  red_p				: out std_logic_Vector(7 downto 0);
			  green_p			: out std_logic_Vector(7 downto 0);
			  blue_p 			: out std_logic_vector(7 downto 0);
           active_video   : out STD_LOGIC;
           hsync   : out STD_LOGIC;
           vsync   : out STD_LOGIC;
			  Pll_locked : in  std_logic);
	END COMPONENT;
	

	
	COMPONENT Pixel_clock_multiplier is
	PORT(
		pclk_in			: in STD_LOGIC;
		pclk_o_x1		: out STD_LOGIC;
		pclk_o_x2		: out STD_LOGIC;
		pclk_o_x10		: out STD_LOGIC;
		pll_locked		: out STD_LOGIC;
		serdes_strobe	: out STD_LOGIC);
	END COMPONENT;
	
	component DDR_Memory_Interface
 generic(
    C3_P0_MASK_SIZE           : integer := 4;
    C3_P0_DATA_PORT_SIZE      : integer := 32;
    C3_P1_MASK_SIZE           : integer := 4;
    C3_P1_DATA_PORT_SIZE      : integer := 32;
    C3_MEMCLK_PERIOD          : integer := 2500;   -- note input clk is only 100 MHz, multiplier is edited to converto to 400 MHz
    C3_RST_ACT_LOW            : integer := 0;
    C3_INPUT_CLK_TYPE         : string := "SINGLE_ENDED";
    C3_CALIB_SOFT_IP          : string := "TRUE";
    C3_SIMULATION             : string := "FALSE";
    DEBUG_EN                  : integer := 0;
    C3_MEM_ADDR_ORDER         : string := "BANK_ROW_COLUMN";
    C3_NUM_DQ_PINS            : integer := 16;
    C3_MEM_ADDR_WIDTH         : integer := 13;
    C3_MEM_BANKADDR_WIDTH     : integer := 3
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
	c3_p0_cmd_clk                           : in std_logic;
   c3_p0_cmd_en                            : in std_logic;
   c3_p0_cmd_instr                         : in std_logic_vector(2 downto 0);
   c3_p0_cmd_bl                            : in std_logic_vector(5 downto 0);
   c3_p0_cmd_byte_addr                     : in std_logic_vector(29 downto 0);
   c3_p0_cmd_empty                         : out std_logic;
   c3_p0_cmd_full                          : out std_logic;
   c3_p0_wr_clk                            : in std_logic;
   c3_p0_wr_en                             : in std_logic;
   c3_p0_wr_mask                           : in std_logic_vector(C3_P0_MASK_SIZE - 1 downto 0);
   c3_p0_wr_data                           : in std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
   c3_p0_wr_full                           : out std_logic;
   c3_p0_wr_empty                          : out std_logic;
   c3_p0_wr_count                          : out std_logic_vector(6 downto 0);
   c3_p0_wr_underrun                       : out std_logic;
   c3_p0_wr_error                          : out std_logic;
   c3_p0_rd_clk                            : in std_logic;
   c3_p0_rd_en                             : in std_logic;
   c3_p0_rd_data                           : out std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
   c3_p0_rd_full                           : out std_logic;
   c3_p0_rd_empty                          : out std_logic;
   c3_p0_rd_count                          : out std_logic_vector(6 downto 0);
   c3_p0_rd_overflow                       : out std_logic;
   c3_p0_rd_error                          : out std_logic;
   c3_p1_cmd_clk                           : in std_logic;
   c3_p1_cmd_en                            : in std_logic;
   c3_p1_cmd_instr                         : in std_logic_vector(2 downto 0);
   c3_p1_cmd_bl                            : in std_logic_vector(5 downto 0);
   c3_p1_cmd_byte_addr                     : in std_logic_vector(29 downto 0);
   c3_p1_cmd_empty                         : out std_logic;
   c3_p1_cmd_full                          : out std_logic;
   c3_p1_wr_clk                            : in std_logic;
   c3_p1_wr_en                             : in std_logic;
   c3_p1_wr_mask                           : in std_logic_vector(C3_P1_MASK_SIZE - 1 downto 0);
   c3_p1_wr_data                           : in std_logic_vector(C3_P1_DATA_PORT_SIZE - 1 downto 0);
   c3_p1_wr_full                           : out std_logic;
   c3_p1_wr_empty                          : out std_logic;
   c3_p1_wr_count                          : out std_logic_vector(6 downto 0);
   c3_p1_wr_underrun                       : out std_logic;
   c3_p1_wr_error                          : out std_logic;
   c3_p1_rd_clk                            : in std_logic;
   c3_p1_rd_en                             : in std_logic;
   c3_p1_rd_data                           : out std_logic_vector(C3_P1_DATA_PORT_SIZE - 1 downto 0);
   c3_p1_rd_full                           : out std_logic;
   c3_p1_rd_empty                          : out std_logic;
   c3_p1_rd_count                          : out std_logic_vector(6 downto 0);
   c3_p1_rd_overflow                       : out std_logic;
   c3_p1_rd_error                          : out std_logic;
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

--leds(0) <= ddr_calibration;
leds(7 downto 0) <= leds_out(7 downto 0);

clk_buf   : IBUFG port map ( O  => GCLK_i, I => GCLK);

read_write_clock <= slow_clock when ddr_calibration = '1' else '0';
out_data(7 downto 0) <= diode_count(7 downto 0);
leds_out(7 downto 0) <= in_data(7 downto 0);


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
			red_c				=> open,
			green_c			=> open,
			blue_c			=> open,
			pclk				=> global_pixel_clock
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
			ddc_sclk			=> 'Z',
			ddc_sdat			=> Open,
			gclk				=> GCLK_i,
			red_c				=> open,
			green_c			=> open,
			blue_c			=> open,
			pclk				=> Open
	);
	
------------------------------
-- HDMI output 0
-- Input: 	RGB, clocks, sync
-- Output: 	TMDS signals
------------------------------
hdmi_output_0 : HDMI_OUT
		PORT MAP(
			Pixel_clock => global_pixel_clock,
			clk_x1			=> global_pixel_clock_x1_b0,
			clk_x2			=> global_pixel_clock_x2_b0,
			clk_x10			=> global_pixel_clock_x10_b0,
			serdes_strobe 	=> global_serdes_strobe_b0,
			red_p      => g_color_red,
			green_p    => g_color_green,
			blue_p     => g_color_blue,
			active_video      => global_output_active_video,
			hsync      => global_output_h_sync,
			vsync      => global_output_v_sync,
			tmds_out_p => hdmi_port_0_out_p,
			tmds_out_n => hdmi_port_0_out_n
		);
		
hdmi_output_1 : HDMI_OUT
		PORT MAP(
			Pixel_clock => global_pixel_clock,
			clk_x1			=> global_pixel_clock_x1_b1,
			clk_x2			=> global_pixel_clock_x2_b1,
			clk_x10			=> global_pixel_clock_x10_b1,
			serdes_strobe 	=> global_serdes_strobe_b1,
			red_p      => g_color_red,
			green_p    => g_color_green,
			blue_p     => g_color_blue,
			active_video      => global_output_active_video,
			hsync      => global_output_h_sync,
			vsync      => global_output_v_sync,
			tmds_out_p => hdmi_port_1_out_p,
			tmds_out_n => hdmi_port_1_out_n
		);
		
hdmi_output_2 : HDMI_OUT
		PORT MAP(
			Pixel_clock => global_pixel_clock,
			clk_x1			=> global_pixel_clock_x1_b1,
			clk_x2			=> global_pixel_clock_x2_b1,
			clk_x10			=> global_pixel_clock_x10_b1,
			serdes_strobe 	=> global_serdes_strobe_b1,
			red_p      => g_color_red,
			green_p    => g_color_green,
			blue_p     => g_color_blue,
			active_video      => global_output_active_video,
			hsync      => global_output_h_sync,
			vsync      => global_output_v_sync,
			tmds_out_p => hdmi_port_2_out_p,
			tmds_out_n => hdmi_port_2_out_n
		);
		
hdmi_output_3 : HDMI_OUT
		PORT MAP(
			Pixel_clock => global_pixel_clock,
			clk_x1			=> global_pixel_clock_x1_b1,
			clk_x2			=> global_pixel_clock_x2_b1,
			clk_x10			=> global_pixel_clock_x10_b1,
			serdes_strobe 	=> global_serdes_strobe_b1,
			red_p      => g_color_red,
			green_p    => g_color_green,
			blue_p     => g_color_blue,
			active_video      => global_output_active_video,
			hsync      => global_output_h_sync,
			vsync      => global_output_v_sync,
			tmds_out_p => hdmi_port_3_out_p,
			tmds_out_n => hdmi_port_3_out_n
		);
		
hdmi_output_4 : HDMI_OUT
		PORT MAP(
			Pixel_clock => global_pixel_clock,
			clk_x1			=> global_pixel_clock_x1_b1,
			clk_x2			=> global_pixel_clock_x2_b1,
			clk_x10			=> global_pixel_clock_x10_b1,
			serdes_strobe 	=> global_serdes_strobe_b1,
			red_p      => g_color_red,
			green_p    => g_color_green,
			blue_p     => g_color_blue,
			active_video      => global_output_active_video,
			hsync      => global_output_h_sync,
			vsync      => global_output_v_sync,
			tmds_out_p => hdmi_port_4_out_p,
			tmds_out_n => hdmi_port_4_out_n
		);
		
hdmi_output_5 : HDMI_OUT
		PORT MAP(
			Pixel_clock => global_pixel_clock,
			clk_x1			=> global_pixel_clock_x1_b1,
			clk_x2			=> global_pixel_clock_x2_b1,
			clk_x10			=> global_pixel_clock_x10_b1,
			serdes_strobe 	=> global_serdes_strobe_b1,
			red_p      => g_color_red,
			green_p    => g_color_green,
			blue_p     => g_color_blue,
			active_video      => global_output_active_video,
			hsync      => global_output_h_sync,
			vsync      => global_output_v_sync,
			tmds_out_p => hdmi_port_5_out_p,
			tmds_out_n => hdmi_port_5_out_n
		);


------------------------------
-- Global output Timing
-- Input: 	Pixel Clock
-- Output: 	Sync signals, position signals
------------------------------	


	
	global_output_timing : Resolution_output_timing 
    Port map ( 
		     pixel_clock    	=> global_pixel_clock,
           red_p   			=> g_color_red,
           green_p 			=> g_color_green,
           blue_p  			=> g_color_blue,
           active_video 	=> global_output_active_video,
           hsync   			=> global_output_h_sync,
           vsync   			=> global_output_v_sync,
			  Pll_locked 		=> global_pll_locked
	);

global_pll_locked <= global_pll_locked_b0 and global_pll_locked_b1; 
------------------------------
-- Global output clock multiplier
-- Input: 	Pixel Clock
-- Output: 	Multiplied clocks, x1, x2 and x10
------------------------------	
	global_clock_multiplier_b0 : Pixel_clock_multiplier
	PORT map(
		pclk_in				=> global_pixel_clock,
		pclk_o_x1			=> global_pixel_clock_x1_b0,
		pclk_o_x2			=> global_pixel_clock_x2_b0,
		pclk_o_x10			=> global_pixel_clock_x10_b0,
		pll_locked			=> global_pll_locked_b0,
		serdes_strobe		=> global_serdes_strobe_b0
	);
	
	global_clock_multiplier_b1 : Pixel_clock_multiplier
	PORT map(
		pclk_in				=> global_pixel_clock,
		pclk_o_x1			=> global_pixel_clock_x1_b1,
		pclk_o_x2			=> global_pixel_clock_x2_b1,
		pclk_o_x10			=> global_pixel_clock_x10_b1,
		pll_locked			=> global_pll_locked_b1,
		serdes_strobe		=> global_serdes_strobe_b1
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
		
		-- BIPORT 0 control signals
		c3_p0_cmd_clk                    		 => '0',
		c3_p0_cmd_en                            => '0',
		c3_p0_cmd_instr                         => "000",
		c3_p0_cmd_bl                            => "000000",
		c3_p0_cmd_byte_addr                     => (others => '0'),
		c3_p0_cmd_empty                         => open,
		c3_p0_cmd_full                          => open,
		c3_p0_wr_clk                            => '0',
		c3_p0_wr_en                             => '0',
		c3_p0_wr_mask                           => (others => '0'),
		c3_p0_wr_data                           => (others => '0'),
		c3_p0_wr_full                           => open,
		c3_p0_wr_empty                          => open,
		c3_p0_wr_count                          => open,
		c3_p0_wr_underrun                       => open,
		c3_p0_wr_error                          => open,
		c3_p0_rd_clk                            => '0',
		c3_p0_rd_en                             => '0',
		c3_p0_rd_data                           => open,
		c3_p0_rd_full                           => open, 
		c3_p0_rd_empty                          => open,
		c3_p0_rd_count                          => open,
		c3_p0_rd_overflow                       => open,
		c3_p0_rd_error                          => open,
		
		-- BIPORT 1 control signals
		c3_p1_cmd_clk                           => '0',
		c3_p1_cmd_en                            => '0',
		c3_p1_cmd_instr                         => "000",
		c3_p1_cmd_bl                            => "000000",
		c3_p1_cmd_byte_addr                     => (others => '0'),
		c3_p1_cmd_empty                         => open,
		c3_p1_cmd_full                          => open, 
		c3_p1_wr_clk                            => '0',
		c3_p1_wr_en                             => '0',
		c3_p1_wr_mask                           => (others => '0'),
		c3_p1_wr_data                           => (others => '0'),
		c3_p1_wr_full                           => open,
		c3_p1_wr_empty                          => open,
		c3_p1_wr_count                          => open,
		c3_p1_wr_underrun                       => open, 
		c3_p1_wr_error                          => open,
		c3_p1_rd_clk                            => '0',
		c3_p1_rd_en                             => '0',
		c3_p1_rd_data                           => open,
		c3_p1_rd_full                           => open, 
		c3_p1_rd_empty                          => open, 
		c3_p1_rd_count                          => open, 
		c3_p1_rd_overflow                       => open,
		c3_p1_rd_error                          => open,
     
		-- Output port 2 control signals
		c3_p2_cmd_clk                           =>  read_write_clock,
		c3_p2_cmd_en                            =>  '1',
		c3_p2_cmd_instr                         =>  "000",
		c3_p2_cmd_bl                            =>  "000000",
		c3_p2_cmd_byte_addr                     =>  (others => '0'),
		c3_p2_cmd_empty                         =>  Open,
		c3_p2_cmd_full                          =>  Open,
		c3_p2_wr_clk                            =>  read_write_clock,
		c3_p2_wr_en                             =>  '1',
		c3_p2_wr_mask                           =>  "0000",
		c3_p2_wr_data                           =>  out_data,
		c3_p2_wr_full                           =>  Open,
		c3_p2_wr_empty                          =>  Open,
		c3_p2_wr_count                          =>  Open,
		c3_p2_wr_underrun                       =>  Open,
		c3_p2_wr_error                          =>  Open,
		
		-- Output port 3 control signals
		c3_p3_cmd_clk                           =>  '0',
		c3_p3_cmd_en                            =>  '0',
		c3_p3_cmd_instr                         =>  (Others => '0'),
		c3_p3_cmd_bl                            =>  (Others => '0'),
		c3_p3_cmd_byte_addr                     =>  (Others => '0'),
		c3_p3_cmd_empty                         =>  Open,
		c3_p3_cmd_full                          =>  Open,
		c3_p3_wr_clk                            =>  '0',
		c3_p3_wr_en                             =>  '0',
		c3_p3_wr_mask                           =>  "0000",
		c3_p3_wr_data                           =>  (Others => '0'),
		c3_p3_wr_full                           =>  Open,
		c3_p3_wr_empty                          =>  Open,
		c3_p3_wr_count                          =>  Open,
		c3_p3_wr_underrun                       =>  Open,
		c3_p3_wr_error                          =>  Open,
		
		-- Input port 4
		c3_p4_cmd_clk                           =>  read_write_clock,
		c3_p4_cmd_en                            =>  '1',
		c3_p4_cmd_instr                         =>  "001",
		c3_p4_cmd_bl                            =>  "000000",
		c3_p4_cmd_byte_addr                     =>  (others=> '0'),
		c3_p4_cmd_empty                         =>  Open,
		c3_p4_cmd_full                          =>  Open,
		c3_p4_rd_clk                            =>  read_write_clock,
		c3_p4_rd_en                             =>  '1',
		c3_p4_rd_data                           =>  in_data,
		c3_p4_rd_full                           =>  Open,
		c3_p4_rd_empty                          =>  Open,
		c3_p4_rd_count                          =>  Open,
		c3_p4_rd_overflow                       =>  Open,
		c3_p4_rd_error                          =>  Open,
		
		-- Input port 5
		c3_p5_cmd_clk                           =>  '0',
		c3_p5_cmd_en                            =>  '0',
		c3_p5_cmd_instr                         =>  (Others => '0'),
		c3_p5_cmd_bl                            =>  (Others => '0'),
		c3_p5_cmd_byte_addr                     =>  (Others => '0'),
		c3_p5_cmd_empty                         =>  Open,
		c3_p5_cmd_full                          =>  Open,
		c3_p5_rd_clk                            =>  '0',
		c3_p5_rd_en                             =>  '0',
		c3_p5_rd_data                           =>  Open,
		c3_p5_rd_full                           =>  Open,
		c3_p5_rd_empty                          =>  Open,
		c3_p5_rd_count                          =>  Open,
		c3_p5_rd_overflow                       =>  Open,
		c3_p5_rd_error                          =>  Open
);
		
	slow_clock_proc : PROCESS(GCLK_i)
	BEGIN
		if rising_edge(GCLK_i) then
			if slow_count < 5000000 then
				slow_count <= slow_count +1;
			else
				slow_count <= (others => '0');
				slow_clock <= not slow_clock;
			end if;
		end if;
	end process slow_clock_proc;
	
	
	mem_test : PROCESS(slow_clock)
	BEGIN
		if rising_edge(slow_clock) then
			if (ddr_calibration = '1') then
				diode_count <= diode_count +1;
			end if;
		end if;
	end process mem_test;
				

			

	



end Structural;

