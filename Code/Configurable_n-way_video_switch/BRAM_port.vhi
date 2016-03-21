
-- VHDL Instantiation Created from source file BRAM_port.vhd -- 12:37:46 03/14/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT BRAM_port
	PORT(
		Clk_out_i : IN std_logic;
		Clk_in_I0_i : IN std_logic;
		Clk_in_I1_i : IN std_logic;
		Clk_in_I0_h_i : IN std_logic;
		Clk_in_I1_h_i : IN std_logic;
		S_selector_i : IN std_logic;
		S_selector_i_n : IN std_logic;
		H_count_I0 : IN std_logic;
		H_count_I0_h : IN std_logic;
		H_count_I1 : IN std_logic;
		H_count_I1_h : IN std_logic;
		Px_enable : IN std_logic;
		Px_Ih_select : IN std_logic;
		PX_I_select_out : IN std_logic;
		Px_H_count_out : IN std_logic_vector(10 downto 0);
		Px_data_in_I0 : IN std_logic_vector(23 downto 0);
		Px_data_in_I1 : IN std_logic_vector(23 downto 0);
		Px_data_out : IN std_logic_vector(23 downto 0);       
		);
	END COMPONENT;

	Inst_BRAM_port: BRAM_port PORT MAP(
		Clk_out_i => ,
		Clk_in_I0_i => ,
		Clk_in_I1_i => ,
		Clk_in_I0_h_i => ,
		Clk_in_I1_h_i => ,
		S_selector_i => ,
		S_selector_i_n => ,
		H_count_I0 => ,
		H_count_I0_h => ,
		H_count_I1 => ,
		H_count_I1_h => ,
		Px_enable => ,
		Px_Ih_select => ,
		PX_I_select_out => ,
		Px_H_count_out => ,
		Px_data_in_I0 => ,
		Px_data_in_I1 => ,
		Px_data_out => 
	);


