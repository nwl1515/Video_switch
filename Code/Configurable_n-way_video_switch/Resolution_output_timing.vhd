----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Generates a test 1280x720 signal 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Resolution_output_timing is
	generic (
				offset_h			: integer := 0;
				offset_v			: integer := 0
				);
    Port ( 
		     pixel_clock     : in std_logic;
           red_p   : out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
           green_p : out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
           blue_p  : out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
           active_video   : inout STD_LOGIC := '0';
           hsync   : out STD_LOGIC := '0';
           vsync   : out STD_LOGIC := '0';
			  h_count_out : out STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
			  v_count_out : out STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
			  Pll_locked : in  std_logic := '0');
end Resolution_output_timing;

architecture Structural of Resolution_output_timing is

   constant h_resolution : natural := 1280;
	constant	h_blanking	 : natural := 370;
   constant h_sync_start : natural := 110;
	constant h_sync_width : natural := 40;
   constant h_sync_end   : natural := h_sync_start+h_sync_width;
   constant h_max        : natural := 1650;
	
   signal   h_count      : unsigned(11 downto 0) := to_unsigned(offset_h,12);
   signal   h_offset     : unsigned(7 downto 0) := (others => '0');

   constant v_resolution : natural := 720;
	constant v_blanking   : natural := 30;
   constant v_sync_start : natural := 5;
	constant v_sync_width : natural := 5;
   constant v_sync_end   : natural := v_sync_start+v_sync_width;
   constant v_max        : natural := 750;
   signal   v_count      : unsigned(11 downto 0) := to_unsigned(offset_v,12);
   signal   v_offset     : unsigned(7 downto 0) := (others => '0');

begin



process(pixel_clock)
   begin
      if rising_edge(pixel_clock) then
		if pll_locked = '1' then
         if h_count >= h_blanking and v_count >= v_blanking then
            red_p   <= std_logic_vector(h_count(7 downto 0)+h_offset);
            green_p <= std_logic_vector(v_count(7 downto 0)+v_offset);
            blue_p  <= std_logic_vector(h_count(7 downto 0)+v_count(7 downto 0));
            active_video   <= '1';
				h_count_out <= std_logic_vector(h_count - h_blanking);
				v_count_out <= std_logic_vector(v_count - v_blanking);
         else
            red_p   <= (others => '1');
            green_p <= (others => '1');
            blue_p  <= (others => '1');
            active_video   <= '0';
				h_count_out <= (others => '0');
				v_count_out <= (others => '1');
         end if;

         if h_count >= h_sync_start and h_count < h_sync_end then
            hsync <= '1';
         else
            hsync <= '0';
         end if;
         
         if v_count >= v_sync_start and v_count < v_sync_end then
            vsync <= '1';
         else
            vsync <= '0';
         end if;
         
         if h_count = (h_max-1) then
            h_count <= (others => '0');
            if v_count = (v_max-1) then
               h_offset <= h_offset + 1;
               v_offset <= v_offset + 1;
               v_count <= (others => '0');
            else
               v_count <= v_count+1;
            end if;
         else
            h_count <= h_count+1;
         end if;
		else
			h_count <= (others => '0');
			v_count <= (others => '0');
			hsync <= '0';
			vsync <= '0';
			h_offset <= (others => '0');
			v_offset <= (others => '0');
			red_p <= (others => '0');
			green_p <= (others => '0');
			blue_p <= (others => '0');
		end if;

      end if;
   end process;

end Structural;

