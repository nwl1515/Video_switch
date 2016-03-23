--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:31:43 03/22/2016
-- Design Name:   
-- Module Name:   /home/nikolaj/Desktop/Video_switch/Video_switch/Code/Configurable_n-way_video_switch/tb_resolution.vhd
-- Project Name:  Configurable_n-way_video_switch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Resolution_output_timing
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_resolution IS
END tb_resolution;
 
ARCHITECTURE behavior OF tb_resolution IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Resolution_output_timing
    PORT(
         pixel_clock : IN  std_logic;
         red_p : OUT  std_logic_vector(7 downto 0);
         green_p : OUT  std_logic_vector(7 downto 0);
         blue_p : OUT  std_logic_vector(7 downto 0);
         active_video : INOUT  std_logic;
         hsync : OUT  std_logic;
         vsync : OUT  std_logic;
         h_count_out : OUT  std_logic_vector(11 downto 0);
         v_count_out : OUT  std_logic_vector(11 downto 0);
         Pll_locked : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal pixel_clock : std_logic := '0';
   signal Pll_locked : std_logic := '1';

	--BiDirs
   signal active_video : std_logic;

 	--Outputs
   signal red_p : std_logic_vector(7 downto 0);
   signal green_p : std_logic_vector(7 downto 0);
   signal blue_p : std_logic_vector(7 downto 0);
   signal hsync : std_logic;
   signal vsync : std_logic;
   signal h_count_out : std_logic_vector(11 downto 0);
   signal v_count_out : std_logic_vector(11 downto 0);


 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Resolution_output_timing PORT MAP (
          pixel_clock => pixel_clock,
          red_p => red_p,
          green_p => green_p,
          blue_p => blue_p,
          active_video => active_video,
          hsync => hsync,
          vsync => vsync,
          h_count_out => h_count_out,
          v_count_out => v_count_out,
          Pll_locked => Pll_locked
        );

   pixel_clock <= not pixel_clock after 10 ns;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      	

     

      -- insert stimulus here 

      wait;
   end process;

END;
