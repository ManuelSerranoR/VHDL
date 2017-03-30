--RC5 DECRYPTION
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:25:38 12/05/2016 
-- Design Name: 
-- Module Name:    RC5_Decryption - Behavioral 
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL; -- For CONV INTEGER
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.RC5_Package.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RC5_Decryption is
    Port ( clr : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  key_ready : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (63 downto 0);
			  s_key : in  S_ARRAY;
			  output_ready : out  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (63 downto 0));
	end RC5_Decryption;

architecture Behavioral of RC5_Decryption is
	
   SIGNAL counter: STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";  
	
   SIGNAL A_minus_S: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL A_rotated_B: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL A: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL A_register: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	
   SIGNAL B_minus_S: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL B_rotated_A: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL B: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL B_register: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	
	SIGNAL skey : S_ARRAY;
	SIGNAL flag_started : STD_LOGIC := '0';
	
BEGIN	

	B_minus_S <= B_register - skey(CONV_INTEGER(counter & '1'));--S[2×i+1]
	WITH A_register(4 DOWNTO 0) SELECT
	B_rotated_A<=B_minus_S(30 DOWNTO 0) & B_minus_S(31) WHEN "00001",
					 B_minus_S(29 DOWNTO 0) & B_minus_S(31 DOWNTO 30) WHEN "00010",
					 B_minus_S(28 DOWNTO 0) & B_minus_S(31 DOWNTO 29) WHEN "00011",
					 B_minus_S(27 DOWNTO 0) & B_minus_S(31 DOWNTO 28) WHEN "00100",
					 B_minus_S(26 DOWNTO 0) & B_minus_S(31 DOWNTO 27) WHEN "00101",
					 B_minus_S(25 DOWNTO 0) & B_minus_S(31 DOWNTO 26) WHEN "00110",
					 B_minus_S(24 DOWNTO 0) & B_minus_S(31 DOWNTO 25) WHEN "00111",
					 B_minus_S(23 DOWNTO 0) & B_minus_S(31 DOWNTO 24) WHEN "01000",
					 B_minus_S(22 DOWNTO 0) & B_minus_S(31 DOWNTO 23) WHEN "01001",
					 B_minus_S(21 DOWNTO 0) & B_minus_S(31 DOWNTO 22) WHEN "01010",
					 B_minus_S(20 DOWNTO 0) & B_minus_S(31 DOWNTO 21) WHEN "01011",
					 B_minus_S(19 DOWNTO 0) & B_minus_S(31 DOWNTO 20) WHEN "01100",
					 B_minus_S(18 DOWNTO 0) & B_minus_S(31 DOWNTO 19) WHEN "01101",
					 B_minus_S(17 DOWNTO 0) & B_minus_S(31 DOWNTO 18) WHEN "01110",
					 B_minus_S(16 DOWNTO 0) & B_minus_S(31 DOWNTO 17) WHEN "01111",
					 B_minus_S(15 DOWNTO 0) & B_minus_S(31 DOWNTO 16) WHEN "10000",
					 B_minus_S(14 DOWNTO 0) & B_minus_S(31 DOWNTO 15) WHEN "10001",
					 B_minus_S(13 DOWNTO 0) & B_minus_S(31 DOWNTO 14) WHEN "10010",
					 B_minus_S(12 DOWNTO 0) & B_minus_S(31 DOWNTO 13) WHEN "10011",
					 B_minus_S(11 DOWNTO 0) & B_minus_S(31 DOWNTO 12) WHEN "10100",
					 B_minus_S(10 DOWNTO 0) & B_minus_S(31 DOWNTO 11) WHEN "10101",
					 B_minus_S(9 DOWNTO 0) & B_minus_S(31 DOWNTO 10) WHEN "10110",
					 B_minus_S(8 DOWNTO 0) & B_minus_S(31 DOWNTO 9) WHEN "10111",
					 B_minus_S(7 DOWNTO 0) & B_minus_S(31 DOWNTO 8) WHEN "11000",
					 B_minus_S(6 DOWNTO 0) & B_minus_S(31 DOWNTO 7) WHEN "11001",
					 B_minus_S(5 DOWNTO 0) & B_minus_S(31 DOWNTO 6) WHEN "11010",
					 B_minus_S(4 DOWNTO 0) & B_minus_S(31 DOWNTO 5) WHEN "11011",
					 B_minus_S(3 DOWNTO 0) & B_minus_S(31 DOWNTO 4) WHEN "11100",
					 B_minus_S(2 DOWNTO 0) & B_minus_S(31 DOWNTO 3) WHEN "11101",
					 B_minus_S(1 DOWNTO 0) & B_minus_S(31 DOWNTO 2) WHEN "11110",
					 B_minus_S(0) & B_minus_S(31 DOWNTO 1) WHEN "11111",
                B_minus_S WHEN OTHERS;
	B <= B_rotated_A XOR A_register;


   A_minus_S <= A_register - skey(CONV_INTEGER(counter & '0'));--S[2×i]
   WITH B_register(4 DOWNTO 0) SELECT
   A_rotated_B<=A_minus_S(30 DOWNTO 0) & A_minus_S(31) WHEN "00001",
					 A_minus_S(29 DOWNTO 0) & A_minus_S(31 DOWNTO 30) WHEN "00010",
					 A_minus_S(28 DOWNTO 0) & A_minus_S(31 DOWNTO 29) WHEN "00011",
					 A_minus_S(27 DOWNTO 0) & A_minus_S(31 DOWNTO 28) WHEN "00100",
					 A_minus_S(26 DOWNTO 0) & A_minus_S(31 DOWNTO 27) WHEN "00101",
					 A_minus_S(25 DOWNTO 0) & A_minus_S(31 DOWNTO 26) WHEN "00110",
					 A_minus_S(24 DOWNTO 0) & A_minus_S(31 DOWNTO 25) WHEN "00111",
					 A_minus_S(23 DOWNTO 0) & A_minus_S(31 DOWNTO 24) WHEN "01000",
					 A_minus_S(22 DOWNTO 0) & A_minus_S(31 DOWNTO 23) WHEN "01001",
					 A_minus_S(21 DOWNTO 0) & A_minus_S(31 DOWNTO 22) WHEN "01010",
					 A_minus_S(20 DOWNTO 0) & A_minus_S(31 DOWNTO 21) WHEN "01011",
					 A_minus_S(19 DOWNTO 0) & A_minus_S(31 DOWNTO 20) WHEN "01100",
					 A_minus_S(18 DOWNTO 0) & A_minus_S(31 DOWNTO 19) WHEN "01101",
					 A_minus_S(17 DOWNTO 0) & A_minus_S(31 DOWNTO 18) WHEN "01110",
					 A_minus_S(16 DOWNTO 0) & A_minus_S(31 DOWNTO 17) WHEN "01111",
					 A_minus_S(15 DOWNTO 0) & A_minus_S(31 DOWNTO 16) WHEN "10000",
					 A_minus_S(14 DOWNTO 0) & A_minus_S(31 DOWNTO 15) WHEN "10001",
					 A_minus_S(13 DOWNTO 0) & A_minus_S(31 DOWNTO 14) WHEN "10010",
					 A_minus_S(12 DOWNTO 0) & A_minus_S(31 DOWNTO 13) WHEN "10011",
					 A_minus_S(11 DOWNTO 0) & A_minus_S(31 DOWNTO 12) WHEN "10100",
					 A_minus_S(10 DOWNTO 0) & A_minus_S(31 DOWNTO 11) WHEN "10101",
					 A_minus_S(9 DOWNTO 0) & A_minus_S(31 DOWNTO 10) WHEN "10110",
					 A_minus_S(8 DOWNTO 0) & A_minus_S(31 DOWNTO 9) WHEN "10111",
					 A_minus_S(7 DOWNTO 0) & A_minus_S(31 DOWNTO 8) WHEN "11000",
					 A_minus_S(6 DOWNTO 0) & A_minus_S(31 DOWNTO 7) WHEN "11001",
					 A_minus_S(5 DOWNTO 0) & A_minus_S(31 DOWNTO 6) WHEN "11010",
					 A_minus_S(4 DOWNTO 0) & A_minus_S(31 DOWNTO 5) WHEN "11011",
					 A_minus_S(3 DOWNTO 0) & A_minus_S(31 DOWNTO 4) WHEN "11100",
					 A_minus_S(2 DOWNTO 0) & A_minus_S(31 DOWNTO 3) WHEN "11101",
					 A_minus_S(1 DOWNTO 0) & A_minus_S(31 DOWNTO 2) WHEN "11110",
					 A_minus_S(0) & A_minus_S(31 DOWNTO 1) WHEN "11111",
                A_minus_S WHEN OTHERS; 
			A <= A_rotated_B XOR B_register;
			
PROCESS(key_ready, flag_started)
BEGIN
	IF (key_ready = '1') then 
		flag_started <= '1';
	END IF;
END PROCESS;


PROCESS(clk , clr, key_ready) BEGIN
	IF ( (clr = '1') OR (key_ready = '1') ) then 
		A_register <= input(63 downto 32);
		B_register <= input(31 downto 0);
		skey <= s_key;
	ELSIF (clk'event and clk ='1' ) then 
		A_register <= A;
		B_register <= B;
	END IF;
END PROCESS;


PROCESS(clk, clr, key_ready)  
BEGIN
  IF( (clr='1') OR (key_ready = '1') ) THEN 
	counter<="1100";
  ELSIF(clk'EVENT AND clk='1') THEN
       IF(counter="0001") THEN
			IF (flag_started = '1') THEN
				output_ready <= '1';
			END IF;
         counter<="1100";
       ELSE
         counter<=counter-'1';
       END IF;
    END IF;
END PROCESS;

output <= (A_register - skey(0))&(B_register - skey(1));

end Behavioral;

