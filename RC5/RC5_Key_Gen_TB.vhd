--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:22:54 12/05/2016
-- Design Name:   
-- Module Name:   C:/Users/Windows 8/Desktop/AHD Examples/RC5/RC5_Key_Gen_TB.vhd
-- Project Name:  RC5
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RC5_Key_Gen
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
USE WORK.RC5_Package.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY RC5_Key_Gen_TB IS
END RC5_Key_Gen_TB;
 
ARCHITECTURE behavior OF RC5_Key_Gen_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RC5_Key_Gen
    PORT(
         clr : IN  std_logic;
         clk : IN  std_logic;
         key_in : IN  std_logic;
         user_key : IN  std_logic_vector(127 downto 0);
         s_key : INOUT  S_ARRAY;
         key_ready : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clr : std_logic := '0';
   signal clk : std_logic := '0';
   signal key_in : std_logic := '0';
   signal user_key : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal s_key : S_ARRAY;
   signal key_ready : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RC5_Key_Gen PORT MAP (
          clr => clr,
          clk => clk,
          key_in => key_in,
          user_key => user_key,
          s_key => s_key,
          key_ready => key_ready
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 20 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

		clr <= '1';
		
		wait for 1 ns;
		
		clr <= '0';
		
		wait for 1 ns;
		
		user_key <= (OTHERS => '0');
		
		wait for 1 ns;
		
		key_in <= '1';
		
		wait for 1 ns;
		
      wait;
   end process;

END;
