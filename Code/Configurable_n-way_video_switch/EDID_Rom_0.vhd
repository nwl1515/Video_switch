----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
--
-- Module Name: edid_rom - Behavioral
--
-- Description: A simple EDID ROM, configured for 1920x1080@60Hz, HDMI format.
--
----------------------------------------------------------------------------------
-- The MIT License (MIT)
-- 
-- Copyright (c) 2015 Michael Alan Field
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

entity edid_rom_0 is
   port ( clk      : in    std_logic;
          sclk_raw : in    std_logic;
          sdat_raw : inout std_logic := 'Z';
          edid_debug : out std_logic_vector(2 downto 0) := (others => '0')
  );
end entity;

architecture Behavioral of edid_rom_0 is

   type a_edid_rom is array (0 to 255) of std_logic_vector(7 downto 0);

   signal edid_rom : a_edid_rom := (
      ------- BASE EDID Bytes 0 to 35 -----------------------------
      -- Fixed Header
      x"00",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"00",
      -- Manufacturer ID - NIL
      x"3A",x"EC", 
		-- Manufacturer product code - 1
		x"01",x"00", 
      -- Serial number - 1
      x"01",x"00",x"00",x"00",
      -- Week of manufacturing - 06
      x"06", 
		-- Year of manufacturing - 2016
		x"1A",
      -- EDID Version - 1.3
      x"01", x"03",
      
		
		------------------------------------
      -- Basic display parameters 
		------------------------------------
      -- Digital Video input,
      x"81", 
      -- Max horizontal image size - 129 cm
      x"60", 
		-- Max vertical image size - 96 cm
		x"39", 
		-- Display gamma - 2.2
		x"78",      
      -- Supported features - sRGB and prederred timing mode specifiged in descruptor block 1 
      x"06",
		
		-------------------------------------
      -- Chromaticity coordinates
		-------------------------------------
		-- Std. settings for sRGB
      x"EE", x"91", x"a3", x"54", x"4c", x"99", x"26", x"0f", x"50", x"54",
		
		-------------------------------------
		-- Supported std. timing modes - None
		-------------------------------------
      x"00", x"00", x"00",
		
		-------------------------------------
      -- Standard timing information 8x2byte std. display modes
		-------------------------------------
		-- Display mode 1: 1280 x-resolution, X:Y = 16:9 aspect ratio, vertical freq = 60 Hz 
      x"81", x"C0", 
		
		-- Display mode 2-8 - Not defined
		x"01", x"01", 
		x"01", x"01", 
		x"01", x"01", 
      x"01", x"01", 
		x"01", x"01", 
		x"01", x"01", 
		x"01", x"01", 

		-------------------------------------
		-- 4 x 18byte descripter blocks
		-------------------------------------
		
		
      -- Block 1: Detailed Timing Descripter 1280x720p
      -- Pixel clock 74,25 MHz
      x"01",x"1D",
      -- Horizontal 1280 with 370 blanking
      x"00", x"72", x"51",
      -- Vertical 720 with 30 lines blanking
      x"D0", x"1E", x"20",
      -- Horizontal front porch -- 110/40
      x"6E",x"28",
      -- Vertical front porch -- 5/5
      x"55",x"00",
      -- Horizontal and vertical image size - 961 x 567 mm.
      x"C1", x"37", x"32",
      -- Horizontal and vertical boarder - 0/0
      x"00", x"00",
      -- Options - Prograssive, No stereo, Sync type = digital seperate, Vertical sync = +, HSync = +
      x"1E",

		-- Block 2: Monitor Name - Conf 2/6-n-sw
		-- Define not a timing descriptor
		x"00", x"00", x"00",
		-- Define descriptor type - Monitor name
		x"FC",
		-- Just zero
		x"00",
		-- Conf 2/6-2-Sw
		x"43",x"6F",x"6E",x"66",x"20",x"32",x"2F",x"36",x"2D",x"6E",x"2D",x"53",x"77",
		
		-- Block 3: Monitor Serial number - 0000000000001
		-- Define not a timing descriptor
		x"00",x"00", x"00",
		-- Define descriptor type -- Monitor serial
		x"FF",
		-- Just zero
		x"00",
		-- Serial number - 0000000000001
		x"30",x"30",x"30",x"30",x"30",x"30",x"30",x"30",x"30",x"30",x"30",x"30",x"31",
		
		-- Block 4: Just some text for padding
		-- Define not a timing descruptor
		x"00",x"00",x"00",
		-- Define descriptor type -- Unspecified text
		x"FE",
		-- Just zero
		x"00",
		-- Secret text
		x"4E",x"69",x"6B",x"6F",x"6C",x"61",x"6A",x"20",x"4C",x"65",x"74",x"68",x"0A",

      -- Extension flag - 1 extension CEA/EDID extension block
      x"01", 
		-- Checksum
		x"C4",
      --------------------------
		-- END of Block 0
		--------------------------
		
		--------------------------
		-- Start block 1: CEA/EDID extension block
		--------------------------
      -- Extension tag - CEA EDID
		x"02",
		-- Revision number - 3
		x"03", 
		-- Byte number 'd' within block, where DTDs begin - 12
		x"0C",
		-- No overscan, no audio, no, YCbCr 4:4:4 and 4:2:2, 1 DTD
		x"01", 
		--------------------------
		-- Data block collection
		--------------------------
		-- Data block 1: Video
		-- Type Video, lenght after this byte 1
		x"41", 
		-- Video Data block - Native 720p 
		x"84", 
		
		-- Data block 2: Vendor Specific
		-- Type Vendor- lenght after this byte 5
		x"65", 
		-- Define HDMI
		x"03", x"0C", x"00", 
		-- Source Physical Address - 1000 (just something)
		x"10", x"00", 
		
		---------------------------
		-- Detailed timing descriptor - start at 0C/ byte 12
		---------------------------
		--  Detailed Timing Descripter 1: 1280x720p
      -- Pixel clock 74,25 MHz
      x"01",x"1D",
      -- Horizontal 1280 with 370 blanking
      x"00", x"72", x"51",
      -- Vertical 720 with 30 lines blanking
      x"D0", x"1E", x"20",
      -- Horizontal front porch -- 110/40
      x"6E",x"28",
      -- Vertical front porch -- 5/5
      x"55",x"00",
      -- Horizontal and vertical image size - 961 x 567 mm.
      x"C1", x"37", x"32",
      -- Horizontal and vertical boarder - 0/0
      x"00", x"00",
      -- Options - Prograssive, No stereo, Sync type = digital seperate, Vertical sync = +, HSync = +
      x"1E",

		-----------------------------
		-- Padding
		-----------------------------
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
		x"00", 
		-- Checksum
		x"93"
      
      );

   signal sclk_delay  : std_logic_vector(2 downto 0);
   signal sdat_delay  : unsigned(6 downto 0);
   
   type t_state is (   state_idle, 
                     -- States to support writing the device's address
                     state_start,
                     state_dev7,
                     state_dev6,
                     state_dev5,
                     state_dev4,
                     state_dev3,
                     state_dev2,
                     state_dev1,
                     state_dev0,
                     -- States to support writing the address
                     state_ack_device_write,
                     state_addr7,
                     state_addr6,
                     state_addr5,
                     state_addr4,
                     state_addr3,
                     state_addr2,
                     state_addr1,
                     state_addr0,
                     state_addr_ack,
                     -- States to support the selector device 
                     state_selector_ack_device_write,
                     state_selector_addr7,
                     state_selector_addr6,
                     state_selector_addr5,
                     state_selector_addr4,
                     state_selector_addr3,
                     state_selector_addr2,
                     state_selector_addr1,
                     state_selector_addr0,
                     state_selector_addr_ack,
                     -- States to support reading from the the EDID ROM
                     state_ack_device_read,
                     state_read7,
                     state_read6,
                     state_read5,
                     state_read4,
                     state_read3,
                     state_read2,
                     state_read1,
                     state_read0,
                     state_read_ack);

   signal state           : t_state := state_idle;
   signal data_out_sr     : std_logic_vector(7 downto 0) := (others => '1');
   signal data_shift_reg  : std_logic_vector(7 downto 0) := (others => '0');
   signal addr_reg        : unsigned(7 downto 0) := (others => '0');
   signal selector_reg    : unsigned(7 downto 0) := (others => '0');
   signal data_to_send    : std_logic_vector(7 downto 0) := (others => '0');
   signal data_out_delay  : std_logic_vector(7 downto 0) := (others => '0');
   signal PULL_LOW        : std_logic := '0';
   signal sdat_input      : std_logic := '0';
   signal sdat_delay_last : std_logic := '0';
begin

i_IOBUF: IOBUF
    generic map (
       DRIVE => 12,
       IOSTANDARD => "DEFAULT",
       SLEW => "SLOW")
    port map (
       O  => sdat_input, -- Buffer output
       IO => sdat_raw,   -- Buffer inout port (connect directly to top-level port)
       I  => '0',        -- Buffer input
       T  => data_out_sr(data_out_sr'high)      -- 3-state enable input, high=input, low=output 
    );
    edid_debug(0) <= std_logic(sdat_delay(sdat_delay'high));
    edid_debug(1) <= sclk_raw; 

process(clk)
   begin   
      if rising_edge(clk) then
         
         -- falling edge on SDAT while sclk is held high = START condition
         if sclk_delay(1) = '1' and sclk_delay(0) = '1' and sdat_delay_last  = '1' and sdat_delay(sdat_delay'high) = '0' then
            state <= state_start;
            edid_debug(2) <= '1';
         end if;
         
         -- rising edge on SDAT while sclk is held high = STOP condition
         if sclk_delay(1) = '1' and sclk_delay(0) = '1' and sdat_delay_last = '0' and sdat_delay(sdat_delay'high) = '1' then
            state <= state_idle;
            selector_reg <= (others => '0');
            edid_debug(2) <= '0';
         end if;

         -- rising edge on SCLK - usually a data bit 
         if sclk_delay(1) = '1' and sclk_delay(0) = '0' then
            -- Move data into a shift register
            data_shift_reg <= data_shift_reg(data_shift_reg'high-1 downto 0) & std_logic(sdat_delay(sdat_delay'high));
         end if;
         
         -- falling edge on SCLK - time to change state
         if sclk_delay(1) = '0' and sclk_delay(0) = '1' then
            data_out_sr <= data_out_sr(data_out_sr'high-1 downto 0) & '1'; -- Add Pull up   
            case state is 
               when state_start            => state <= state_dev7;
               when state_dev7             => state <= state_dev6;
               when state_dev6             => state <= state_dev5;
               when state_dev5             => state <= state_dev4;
               when state_dev4             => state <= state_dev3;
               when state_dev3             => state <= state_dev2;
               when state_dev2             => state <= state_dev1;
               when state_dev1             => state <= state_dev0;
               when state_dev0             => if data_shift_reg = x"A1" then
                                                 state <= state_ack_device_read;
                                                 data_out_sr(data_out_sr'high) <= '0'; -- Send Slave ACK
                                              elsif data_shift_reg = x"A0" then
                                                 state <= state_ack_device_write;
                                                 data_out_sr(data_out_sr'high) <= '0'; -- Send Slave ACK
                                              elsif data_shift_reg = x"60" then
                                                 state <= state_selector_ack_device_write;
                                                 data_out_sr(data_out_sr'high) <= '0'; -- Send Slave ACK
                                              else
                                                 state <= state_idle;
                                              end if;               
               when state_ack_device_write => state <= state_addr7;
               when state_addr7            => state <= state_addr6;
               when state_addr6            => state <= state_addr5;
               when state_addr5            => state <= state_addr4;
               when state_addr4            => state <= state_addr3;
               when state_addr3            => state <= state_addr2;
               when state_addr2            => state <= state_addr1;
               when state_addr1            => state <= state_addr0;
               when state_addr0            => state <= state_addr_ack;
                                              addr_reg  <= unsigned(data_shift_reg);
                                              data_out_sr(data_out_sr'high) <= '0'; -- Send Slave ACK
               when state_addr_ack         => state <= state_idle;   -- SLave ACK and ignore any written data
                ------------------------------------
                -- Process the write to the selector
                ------------------------------------
               when state_selector_ack_device_write => state <= state_selector_addr7;
               when state_selector_addr7            => state <= state_selector_addr6;
               when state_selector_addr6            => state <= state_selector_addr5;
               when state_selector_addr5            => state <= state_selector_addr4;
               when state_selector_addr4            => state <= state_selector_addr3;
               when state_selector_addr3            => state <= state_selector_addr2;
               when state_selector_addr2            => state <= state_selector_addr1;
               when state_selector_addr1            => state <= state_selector_addr0;
               when state_selector_addr0            => state <= state_selector_addr_ack;
                                              selector_reg  <= unsigned(data_shift_reg(7 downto 0));
                                              data_out_sr(data_out_sr'high) <= '0'; -- Send Slave ACK
               when state_selector_addr_ack         => state <= state_idle;   -- SLave ACK and ignore any written data
               -------------------------

               when state_ack_device_read  => state <= state_read7;
                                              data_out_sr <=  edid_rom(to_integer(addr_reg));
               when state_read7            => state <= state_read6;
               when state_read6            => state <= state_read5;
               when state_read5            => state <= state_read4;
               when state_read4            => state <= state_read3;
               when state_read3            => state <= state_read2;
               when state_read2            => state <= state_read1;
               when state_read1            => state <= state_read0;
               when state_read0            => state <= state_read_ack; 
               when state_read_ack         => if sdat_delay(sdat_delay'high) = '0' then 
                                                 state <= state_read7;
                                                 data_out_sr <=  edid_rom(to_integer(addr_reg+1));
                                              else 
                                                 state <= state_idle;
                                              end if;                     
                                              addr_reg <= addr_reg+1;
               when others                 => state <= state_idle;
            end case;
         end if;
        sdat_delay_last <= sdat_delay(sdat_delay'high);
         -- Synchronisers for SCLK and SDAT
         sclk_delay <= sclk_raw & sclk_delay(sclk_delay'high downto 1);
         -- Resolve any 'Z' state in simulation - make it pull up. 
         if sdat_input = '0'  then 
            if sdat_delay(sdat_delay'high) = '1' then 
                sdat_delay <= sdat_delay - 1;
            else
                sdat_delay <= (others => '0');
            end if; 
         else
            if sdat_delay(sdat_delay'high) = '0' then 
                 sdat_delay <= sdat_delay + 1;
             else
                 sdat_delay <= (others => '1');
             end if; 
         end if;
      end if;
   end process;
end architecture;