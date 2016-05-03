----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:58 03/22/2016 
-- Design Name: 
-- Module Name:    Output_Controller - Structural 
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

entity Output_Controller is
    Port ( 
		clk_in 				: in  STD_LOGIC := '0'; --- OBS x1 pixel clock
		global_h_count		: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		global_v_count		: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		global_h_sync		: in STD_LOGIC := '0';
		global_v_sync		: in STD_LOGIC := '0';
		global_output_h	: out STD_LOGIC := '0';
		global_output_v	: out STD_LOGIC := '0';
		global_active_v	: in STD_LOGIC := '0';
		global_output_av	: out STD_LOGIC := '0';
		BRAM_clock_out_e	: out STD_LOGIC := '0';
		P0_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P0_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P0_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P0_set_3 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P0_set_4 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P0_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P0_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P0_video_out		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P0_I_selector		: out STD_LOGIC := '0';
		P0_S_selector		: inout STD_LOGIC := '0';
		P0_enable			: out STD_LOGIC := '0';
		P0_inload_done		: in STD_LOGIC := '0';
		P0_unload_done 	: inout STD_LOGIC := '0';
		P0_change_s			: out STD_LOGIC := '0';
		P1_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P1_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P1_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P1_set_3 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P1_set_4 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P1_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P1_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P1_video_out		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P1_I_selector		: out STD_LOGIC := '0';
		P1_S_selector		: inout STD_LOGIC := '0';
		P1_enable			: out STD_LOGIC := '0';
		P1_inload_done		: in STD_LOGIC := '0';
		P1_unload_done 	: inout STD_LOGIC := '0';
		P1_change_s			: out STD_LOGIC := '0';
		P2_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P2_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P2_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P2_set_3 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P2_set_4 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P2_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P2_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P2_video_out		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P2_I_selector		: out STD_LOGIC := '0';
		P2_S_selector		: inout STD_LOGIC := '0';
		P2_enable			: out STD_LOGIC := '0';
		P2_inload_done		: in STD_LOGIC := '0';
		P2_unload_done 	: inout STD_LOGIC := '0';
		P2_change_s			: out STD_LOGIC := '0';
		P3_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P3_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P3_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P3_set_3 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P3_set_4 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P3_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P3_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P3_video_out		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P3_I_selector		: out STD_LOGIC := '0';
		P3_S_selector		: inout STD_LOGIC := '0';
		P3_enable			: out STD_LOGIC := '0';
		P3_inload_done		: in STD_LOGIC := '0';
		P3_unload_done 	: inout STD_LOGIC := '0';
		P3_change_s			: out STD_LOGIC := '0';
		P4_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P4_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P4_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P4_set_3 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P4_set_4 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P4_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P4_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P4_video_out		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P4_I_selector		: out STD_LOGIC := '0';
		P4_S_selector		: inout STD_LOGIC := '0';
		P4_enable			: out STD_LOGIC := '0';
		P4_inload_done		: in STD_LOGIC := '0';
		P4_unload_done 	: inout STD_LOGIC := '0';
		P4_change_s			: out STD_LOGIC := '0';
		P5_conf				: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
		P5_set_1 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P5_set_2 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P5_set_3 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P5_set_4 			: in STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		P5_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P5_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P5_video_out		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P5_I_selector		: out STD_LOGIC := '0';
		P5_S_selector		: inout STD_LOGIC := '0';
		P5_enable			: out STD_LOGIC := '0';
		P5_inload_done		: in STD_LOGIC := '0';
		P5_unload_done 	: inout STD_LOGIC := '0';
		P5_change_s			: out STD_LOGIC := '0'
		);
		
		-- Px_conf settings:
		-- 0000 -> output = input 0
		-- 0001 -> output = input 1
		-- 0010 -> output = upscale input 0
			-- set 1 = x start cord
			-- set 2 = y start cord
		-- 0011 -> output = upscale input 1
			-- set 1 = x start cord
			-- set 2 = y start cord
		-- 0100 -> output = vertical split (0 L, 1 R)
			-- set 1 = split line
		-- 0101 -> output = vertical spplit(1 L, 0 R)
			-- set 1 = split line
		-- 0110 -> output = horizonal split (0 U, 1 D)
			-- set 1 = split line
		-- 0111 -> output = horizontal split (1 U, 0 D)
			-- set 1 = split line
		-- 1000 -> output = 0 background, 1 foreground
			-- set 1 = x cord foreground
			-- set 2 = y cord foreground
			-- set 3 = x size foreground
			-- set 4 = y size foreground
		-- 1001 -> output = 1 background, 0 foreground
			-- set 1 = x cord foreground
			-- set 2 = y cord foreground
			-- set 3 = x size foreground
			-- set 4 = y size foreground
		-- 1010 -> output = 1 background, 0 foreground upscaled
			-- set 1 = x cord foreground
			-- set 2 = y cord foreground
		-- 1011 -> output = 0 background, 1 foreground upscaled
			-- set 1 = x cord foreground
			-- set 2 = y cord foreground
		-- 1100 -> output = 0 background, 0 foreground upscaled
			-- set 1 = x cord foreground
			-- set 2 = y cord foreground
		-- 1101 -> output = 1 foreground, 1 foreground upscaled
			-- set 1 = x cord fogreground
			-- set 2 = y cord foreground
			
		-- 1111 -> off
		
		
		
		
		
end Output_Controller;

architecture Structural of Output_Controller is

	COMPONENT Px_output_controller
    Port ( 
		device_set			: in STD_LOGIC_VECTOR(2 downto 0);
		clk_in 				: in  STD_LOGIC; --- OBS x1 pixel clock
		global_h_count		: in STD_LOGIC_VECTOR(11 downto 0);
		global_v_count		: in STD_LOGIC_VECTOR(11 downto 0);
		global_active_v	: in STD_LOGIC;
		Px_conf				: in STD_LOGIC_VECTOR(3 downto 0);
		Px_set_1 			: in STD_LOGIC_VECTOR(11 downto 0);
		Px_set_2 			: in STD_LOGIC_VECTOR(11 downto 0);
		Px_set_3 			: in STD_LOGIC_VECTOR(11 downto 0);
		Px_set_4 			: in STD_LOGIC_VECTOR(11 downto 0);
		Px_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0);
		Px_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0);
		Px_video_out		: out STD_LOGIC_VECTOR(23 downto 0);
		Px_I_selector		: out STD_LOGIC;
		Px_S_selector		: inout STD_LOGIC;
		Px_enable			: out STD_LOGIC;
		Px_inload_done		: in STD_LOGIC;
		Px_unload_done		: inout STD_LOGIC;
		Px_change_s			: out STD_LOGIC
	 
	 );
	 END COMPONENT;

	signal active_video_p1, active_video_p2, active_video_p3  : STD_LOGIC := '0';
	signal h_sync_p1, h_sync_p2, h_sync_p3	 	: STD_LOGIC := '0';
	signal v_sync_p1, v_sync_p2, v_sync_p3	 	: STD_LOGIC := '0';
	

begin

 BRAM_clock_out_e <= '1' when active_video_p2 = '1' or active_video_p3 = '1' else '0';
----------------------
-- Pipeline signals for synchonization
----------------------

 video_active : process(clk_in)
 begin
	if rising_edge(clk_in) then
		active_video_p1 <= global_active_v;
		active_video_p2 <= active_video_p1;
		active_video_p3 <= active_video_p2;
		global_output_av <= active_video_p3;
		
		h_sync_p1 <= global_h_sync;
		h_sync_p2 <= h_sync_p1;
		h_sync_p3 <= h_sync_p2;
		global_output_h <= h_sync_p3;
		
		v_sync_p1 <= global_v_sync;
		v_sync_p2 <= v_sync_p1;
		v_sync_p3 <= v_sync_p2;
		global_output_v <= v_sync_p3;
	end if;
 end process video_active;




	Port_0_controller : Px_output_controller
    Port map ( 
		device_set			=> "000",
		clk_in 				=> clk_in,
		global_h_count		=> global_h_count,
		global_v_count		=> global_v_count,
		global_active_v	=> global_active_v,
		Px_conf				=> P0_conf,
		Px_set_1 			=> P0_set_1,
		Px_set_2 			=> P0_set_2,
		Px_set_3 			=> P0_set_3,
		Px_set_4 			=> P0_set_4,
		Px_h_count_out 	=> P0_h_count_out,
		Px_BRAM_in			=> P0_BRAM_in,
		Px_video_out		=> P0_video_out,
		Px_I_selector		=> P0_I_selector,
		Px_S_selector		=> P0_S_selector,
		Px_enable			=> P0_enable,
		Px_inload_done		=> P0_inload_done,
		Px_unload_done		=> P0_unload_done,
		Px_change_s			=> p0_change_s		
	 );
	 
	 Port_1_controller : Px_output_controller
    Port map ( 
		device_set			=> "000",
		clk_in 				=> clk_in,
		global_h_count		=> global_h_count,
		global_v_count		=> global_v_count,
		global_active_v	=> global_active_v,
		Px_conf				=> P1_conf,
		Px_set_1 			=> P1_set_1,
		Px_set_2 			=> P1_set_2,
		Px_set_3 			=> P1_set_3,
		Px_set_4 			=> P1_set_4,
		Px_h_count_out 	=> P1_h_count_out,
		Px_BRAM_in			=> P1_BRAM_in,
		Px_video_out		=> P1_video_out,
		Px_I_selector		=> P1_I_selector,
		Px_S_selector		=> P1_S_selector,
		Px_enable			=> P1_enable,
		Px_inload_done		=> P1_inload_done,
		Px_unload_done		=> P1_unload_done,
		Px_change_s			=> p1_change_s		
	 );
	 
	 Port_2_controller : Px_output_controller
    Port map ( 
		device_set			=> "001",
		clk_in 				=> clk_in,
		global_h_count		=> global_h_count,
		global_v_count		=> global_v_count,
		global_active_v	=> global_active_v,
		Px_conf				=> P2_conf,
		Px_set_1 			=> P2_set_1,
		Px_set_2 			=> P2_set_2,
		Px_set_3 			=> P2_set_3,
		Px_set_4 			=> P2_set_4,
		Px_h_count_out 	=> P2_h_count_out,
		Px_BRAM_in			=> P2_BRAM_in,
		Px_video_out		=> P2_video_out,
		Px_I_selector		=> P2_I_selector,
		Px_S_selector		=> P2_S_selector,
		Px_enable			=> P2_enable,
		Px_inload_done		=> P2_inload_done,
		Px_unload_done		=> P2_unload_done,
		Px_change_s			=> p2_change_s		
	 );
	 
	 Port_3_controller : Px_output_controller
    Port map ( 
		device_set			=> "010",
		clk_in 				=> clk_in,
		global_h_count		=> global_h_count,
		global_v_count		=> global_v_count,
		global_active_v	=> global_active_v,
		Px_conf				=> P3_conf,
		Px_set_1 			=> P3_set_1,
		Px_set_2 			=> P3_set_2,
		Px_set_3 			=> P3_set_3,
		Px_set_4 			=> P3_set_4,
		Px_h_count_out 	=> P3_h_count_out,
		Px_BRAM_in			=> P3_BRAM_in,
		Px_video_out		=> P3_video_out,
		Px_I_selector		=> P3_I_selector,
		Px_S_selector		=> P3_S_selector,
		Px_enable			=> P3_enable,
		Px_inload_done		=> P3_inload_done,
		Px_unload_done		=> P3_unload_done,
		Px_change_s			=> p3_change_s		
	 );
	 
	 Port_4_controller : Px_output_controller
    Port map ( 
		device_set			=> "011",
		clk_in 				=> clk_in,
		global_h_count		=> global_h_count,
		global_v_count		=> global_v_count,
		global_active_v	=> global_active_v,
		Px_conf				=> P4_conf,
		Px_set_1 			=> P4_set_1,
		Px_set_2 			=> P4_set_2,
		Px_set_3 			=> P4_set_3,
		Px_set_4 			=> P4_set_4,
		Px_h_count_out 	=> P4_h_count_out,
		Px_BRAM_in			=> P4_BRAM_in,
		Px_video_out		=> P4_video_out,
		Px_I_selector		=> P4_I_selector,
		Px_S_selector		=> P4_S_selector,
		Px_enable			=> P4_enable,
		Px_inload_done		=> P4_inload_done,
		Px_unload_done		=> P4_unload_done,
		Px_change_s			=> p4_change_s		
	 );
	 
	 Port_5_controller : Px_output_controller
    Port map ( 
		device_set			=> "100",
		clk_in 				=> clk_in,
		global_h_count		=> global_h_count,
		global_v_count		=> global_v_count,
		global_active_v	=> global_active_v,
		Px_conf				=> P5_conf,
		Px_set_1 			=> P5_set_1,
		Px_set_2 			=> P5_set_2,
		Px_set_3 			=> P5_set_3,
		Px_set_4 			=> P5_set_4,
		Px_h_count_out 	=> P5_h_count_out,
		Px_BRAM_in			=> P5_BRAM_in,
		Px_video_out		=> P5_video_out,
		Px_I_selector		=> P5_I_selector,
		Px_S_selector		=> P5_S_selector,
		Px_enable			=> P5_enable,
		Px_inload_done		=> P5_inload_done,
		Px_unload_done		=> P5_unload_done,
		Px_change_s			=> p5_change_s		
	 );


end Structural;

