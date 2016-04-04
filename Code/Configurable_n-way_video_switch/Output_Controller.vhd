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
		clk_in 				: in  STD_LOGIC; --- OBS x1 pixel clock
		global_h_count		: in STD_LOGIC_VECTOR(11 downto 0);
		global_v_count		: in STD_LOGIC_VECTOR(11 downto 0);
		global_h_sync		: in STD_LOGIC;
		global_v_sync		: in STD_LOGIC;
		global_output_h	: out STD_LOGIC := '0';
		global_output_v	: out STD_LOGIC := '0';
		global_active_v	: in STD_LOGIC;
		global_output_av	: out STD_LOGIC := '0';
		BRAM_clock_out_e	: out STD_LOGIC := '0';
		P0_conf				: in STD_LOGIC_VECTOR(3 downto 0);
		P0_set_1 			: in STD_LOGIC_VECTOR(11 downto 0);
		P0_set_2 			: in STD_LOGIC_VECTOR(11 downto 0);
		P0_set_3 			: in STD_LOGIC_VECTOR(11 downto 0);
		P0_set_4 			: in STD_LOGIC_VECTOR(11 downto 0);
		P0_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		P0_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0);
		P0_video_out		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		P0_I_selector		: out STD_LOGIC := '0';
		P0_S_selector		: inout STD_LOGIC := '0';
		P0_enable			: out STD_LOGIC := '0';
		P0_inload_done		: in STD_LOGIC;
		P0_unload_done 	: inout STD_LOGIC := '0';
		P0_change_s			: out STD_LOGIC
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
		clk_in 				: in  STD_LOGIC; --- OBS x1 pixel clock
		global_h_count		: in STD_LOGIC_VECTOR(11 downto 0);
		global_v_count		: in STD_LOGIC_VECTOR(11 downto 0);
		global_active_v	: in STD_LOGIC;
		Px_conf				: in STD_LOGIC_VECTOR(3 downto 0);
		Px_set_1 			: in STD_LOGIC_VECTOR(11 downto 0);
		Px_set_2 			: in STD_LOGIC_VECTOR(11 downto 0);
		Px_set_3 			: in STD_LOGIC_VECTOR(11 downto 0);
		Px_set_4 			: in STD_LOGIC_VECTOR(11 downto 0);
		Px_h_count_out 	: inout STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
		Px_BRAM_in			: in STD_LOGIC_VECTOR(23 downto 0);
		Px_video_out		: out STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
		Px_I_selector		: out STD_LOGIC := '0';
		Px_S_selector		: inout STD_LOGIC := '0';
		Px_enable			: out STD_LOGIC := '0';
		Px_inload_done		: in STD_LOGIC;
		Px_unload_done		: inout STD_LOGIC := '0';
		Px_change_s			: out STD_LOGIC
	 
	 );
	 END COMPONENT;

	signal active_video_p1, active_video_p2, active_video_p3  : STD_LOGIC := '0';
	signal h_sync_p1, h_sync_p2, h_sync_p3	 	: STD_LOGIC := '0';
	signal v_sync_p1, v_sync_p2, v_sync_p3	 	: STD_LOGIC := '0';
	

begin

 BRAM_clock_out_e <= '1' when active_video_p2 = '1' or active_video_p3 = '1' else '0';
 --BRAM_clock_out_e <= '1' when active_video_p2 = '1' else '0';
 --BRAM_clock_out_e <= '1' when global_active_v = '1' else '0';
 
 --global_output_av <= global_active_v;
 --global_output_h <= global_h_sync;
 --global_output_v <= global_v_sync;
 
 --BRAM_clock_out_e <=  global_active_v;
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
		--Px_BRAM_in			=> "111111111111111100000000",
		Px_video_out		=> P0_video_out,
		--Px_video_out		=> open,
		Px_I_selector		=> P0_I_selector,
		Px_S_selector		=> P0_S_selector,
		Px_enable			=> P0_enable,
		Px_inload_done		=> P0_inload_done,
		Px_unload_done		=> P0_unload_done,
		Px_change_s			=> p0_change_s		
	 );
	 
	 --P0_video_out <= "111111111111111100000000";

end Structural;

