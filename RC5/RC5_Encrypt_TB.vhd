--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:16:27 12/11/2016
-- Design Name:   
-- Module Name:   C:/Users/Windows 8/Desktop/AHD Examples/RC5/RC5_Encrypt_TB.vhd
-- Project Name:  RC5
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RC5_Encryption
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
 
ENTITY RC5_Encrypt_TB IS
END RC5_Encrypt_TB;
 
ARCHITECTURE behavior OF RC5_Encrypt_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RC5_Encryption
    PORT(
         clr : IN  std_logic;
         clk : IN  std_logic;
         key_ready : IN  std_logic;
         input : IN  std_logic_vector(63 downto 0);
         s_key : IN  S_ARRAY;
         output : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clr : std_logic := '0';
   signal clk : std_logic := '0';
   signal key_ready : std_logic := '0';
   signal input : std_logic_vector(63 downto 0) := (others => '0');
   signal s_key : S_ARRAY;

 	--Outputs
   signal output : std_logic_vector(63 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RC5_Encryption PORT MAP (
          clr => clr,
          clk => clk,
          key_ready => key_ready,
          input => input,
          s_key => s_key,
          output => output
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
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		
		

      wait;
   end process;

END;
