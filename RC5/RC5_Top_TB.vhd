--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:30:38 12/11/2016
-- Design Name:   
-- Module Name:   C:/Users/Windows 8/Desktop/AHD Examples/RC5/RC5_Top_TB.vhd
-- Project Name:  RC5
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RC5_TOP
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
 
ENTITY RC5_Top_TB IS
END RC5_Top_TB;
 
ARCHITECTURE behavior OF RC5_Top_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RC5_TOP
    PORT(
         clr : IN  std_logic;
         clock : IN  std_logic;
         input : IN  std_logic_vector(15 downto 0);
         button_a : IN  std_logic;
         button_b : IN  std_logic;
         in_val : IN  std_logic;
         leds : OUT  std_logic_vector(15 downto 0);
         segments_catode : OUT  std_logic_vector(7 downto 0);
         segments_anode : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clr : std_logic := '0';
   signal clock : std_logic := '0';
   signal input : std_logic_vector(15 downto 0) := (others => '0');
   signal button_a : std_logic := '0';
   signal button_b : std_logic := '0';
   signal in_val : std_logic := '0';

 	--Outputs
   signal leds : std_logic_vector(15 downto 0);
   signal segments_catode : std_logic_vector(7 downto 0);
   signal segments_anode : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RC5_TOP PORT MAP (
          clr => clr,
          clock => clock,
          input => input,
          button_a => button_a,
          button_b => button_b,
          in_val => in_val,
          leds => leds,
          segments_catode => segments_catode,
          segments_anode => segments_anode
        );

   -- Clock process definitions
   clk_process :process
   begin
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		clr <= '1';
		wait for 100 ns;
		
		clr <= '0';
		wait for 100 ns;
		
--		input <= "1111000011110000";
--		wait for 100 ns;
--		in_val <= '1';
--		wait for 100 ns;
--		in_val <= '0';
--		wait for 100 ns;
--		
--		input <= "0000111100001111";
--		wait for 100 ns;
--		in_val <= '1';
--		wait for 100 ns;
--		in_val <= '0';
--		wait for 100 ns;
		
		button_b <= '1';
		wait for 100 ns;
		
		button_b <= '0';
		wait for 100 ns;
		
		
		--button_a <= '1';
		--wait for 10 ns;
		
		--button_a <= '0';
		wait for 100 ns;
		
		--clr <= '1';
		wait for 100 ns;
		
		--clr <= '0';
		wait for 100 ns;
      wait;
   end process;

END;
