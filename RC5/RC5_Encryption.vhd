--RC5 ENCRYPTION
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:53:16 12/05/2016 
-- Design Name: 
-- Module Name:    RC5_Encryption - Behavioral 
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL; -- For CONV INTEGER
USE WORK.RC5_Package.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RC5_Encryption is
    Port ( clr : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  key_ready : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (63 downto 0);
			  s_key : in  S_ARRAY;
			  output_ready : out  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (63 downto 0));
end RC5_Encryption;

architecture Behavioral of RC5_Encryption is
	
   SIGNAL counter: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";  
	
   SIGNAL AB_xor: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL A_rotated: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL A: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL A_register: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	
   SIGNAL BA_xor: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL B_rotated: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL B: STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL B_register: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	
	SIGNAL skey : S_ARRAY;
	SIGNAL flag_started : STD_LOGIC := '0';
					
begin

	AB_xor <= A_register XOR B_register;
	WITH B_register(4 DOWNTO 0) SELECT
	A_rotated<=AB_xor(30 DOWNTO 0) & AB_xor(31) WHEN "00001",
					 AB_xor(29 DOWNTO 0) & AB_xor(31 DOWNTO 30) WHEN "00010",
					 AB_xor(28 DOWNTO 0) & AB_xor(31 DOWNTO 29) WHEN "00011",
					 AB_xor(27 DOWNTO 0) & AB_xor(31 DOWNTO 28) WHEN "00100",
					 AB_xor(26 DOWNTO 0) & AB_xor(31 DOWNTO 27) WHEN "00101",
					 AB_xor(25 DOWNTO 0) & AB_xor(31 DOWNTO 26) WHEN "00110",
					 AB_xor(24 DOWNTO 0) & AB_xor(31 DOWNTO 25) WHEN "00111",
					 AB_xor(23 DOWNTO 0) & AB_xor(31 DOWNTO 24) WHEN "01000",
					 AB_xor(22 DOWNTO 0) & AB_xor(31 DOWNTO 23) WHEN "01001",
					 AB_xor(21 DOWNTO 0) & AB_xor(31 DOWNTO 22) WHEN "01010",
					 AB_xor(20 DOWNTO 0) & AB_xor(31 DOWNTO 21) WHEN "01011",
					 AB_xor(19 DOWNTO 0) & AB_xor(31 DOWNTO 20) WHEN "01100",
					 AB_xor(18 DOWNTO 0) & AB_xor(31 DOWNTO 19) WHEN "01101",
					 AB_xor(17 DOWNTO 0) & AB_xor(31 DOWNTO 18) WHEN "01110",
					 AB_xor(16 DOWNTO 0) & AB_xor(31 DOWNTO 17) WHEN "01111",
					 AB_xor(15 DOWNTO 0) & AB_xor(31 DOWNTO 16) WHEN "10000",
					 AB_xor(14 DOWNTO 0) & AB_xor(31 DOWNTO 15) WHEN "10001",
					 AB_xor(13 DOWNTO 0) & AB_xor(31 DOWNTO 14) WHEN "10010",
					 AB_xor(12 DOWNTO 0) & AB_xor(31 DOWNTO 13) WHEN "10011",
					 AB_xor(11 DOWNTO 0) & AB_xor(31 DOWNTO 12) WHEN "10100",
					 AB_xor(10 DOWNTO 0) & AB_xor(31 DOWNTO 11) WHEN "10101",
					 AB_xor(9 DOWNTO 0) & AB_xor(31 DOWNTO 10) WHEN "10110",
					 AB_xor(8 DOWNTO 0) & AB_xor(31 DOWNTO 9) WHEN "10111",
					 AB_xor(7 DOWNTO 0) & AB_xor(31 DOWNTO 8) WHEN "11000",
					 AB_xor(6 DOWNTO 0) & AB_xor(31 DOWNTO 7) WHEN "11001",
					 AB_xor(5 DOWNTO 0) & AB_xor(31 DOWNTO 6) WHEN "11010",
					 AB_xor(4 DOWNTO 0) & AB_xor(31 DOWNTO 5) WHEN "11011",
					 AB_xor(3 DOWNTO 0) & AB_xor(31 DOWNTO 4) WHEN "11100",
					 AB_xor(2 DOWNTO 0) & AB_xor(31 DOWNTO 3) WHEN "11101",
					 AB_xor(1 DOWNTO 0) & AB_xor(31 DOWNTO 2) WHEN "11110",
					 AB_xor(0) & AB_xor(31 DOWNTO 1) WHEN "11111",
                AB_xor WHEN OTHERS;
					 
   A<=A_rotated + skey(CONV_INTEGER(counter & '0')); --S[2×i]


   BA_xor <= B_register XOR A;
   WITH A(4 DOWNTO 0) SELECT
   B_rotated<=BA_xor(30 DOWNTO 0) & BA_xor(31) WHEN "00001",
					 BA_xor(29 DOWNTO 0) & BA_xor(31 DOWNTO 30) WHEN "00010",
					 BA_xor(28 DOWNTO 0) & BA_xor(31 DOWNTO 29) WHEN "00011",
					 BA_xor(27 DOWNTO 0) & BA_xor(31 DOWNTO 28) WHEN "00100",
					 BA_xor(26 DOWNTO 0) & BA_xor(31 DOWNTO 27) WHEN "00101",
					 BA_xor(25 DOWNTO 0) & BA_xor(31 DOWNTO 26) WHEN "00110",
					 BA_xor(24 DOWNTO 0) & BA_xor(31 DOWNTO 25) WHEN "00111",
					 BA_xor(23 DOWNTO 0) & BA_xor(31 DOWNTO 24) WHEN "01000",
					 BA_xor(22 DOWNTO 0) & BA_xor(31 DOWNTO 23) WHEN "01001",
					 BA_xor(21 DOWNTO 0) & BA_xor(31 DOWNTO 22) WHEN "01010",
					 BA_xor(20 DOWNTO 0) & BA_xor(31 DOWNTO 21) WHEN "01011",
					 BA_xor(19 DOWNTO 0) & BA_xor(31 DOWNTO 20) WHEN "01100",
					 BA_xor(18 DOWNTO 0) & BA_xor(31 DOWNTO 19) WHEN "01101",
					 BA_xor(17 DOWNTO 0) & BA_xor(31 DOWNTO 18) WHEN "01110",
					 BA_xor(16 DOWNTO 0) & BA_xor(31 DOWNTO 17) WHEN "01111",
					 BA_xor(15 DOWNTO 0) & BA_xor(31 DOWNTO 16) WHEN "10000",
					 BA_xor(14 DOWNTO 0) & BA_xor(31 DOWNTO 15) WHEN "10001",
					 BA_xor(13 DOWNTO 0) & BA_xor(31 DOWNTO 14) WHEN "10010",
					 BA_xor(12 DOWNTO 0) & BA_xor(31 DOWNTO 13) WHEN "10011",
					 BA_xor(11 DOWNTO 0) & BA_xor(31 DOWNTO 12) WHEN "10100",
					 BA_xor(10 DOWNTO 0) & BA_xor(31 DOWNTO 11) WHEN "10101",
					 BA_xor(9 DOWNTO 0) & BA_xor(31 DOWNTO 10) WHEN "10110",
					 BA_xor(8 DOWNTO 0) & BA_xor(31 DOWNTO 9) WHEN "10111",
					 BA_xor(7 DOWNTO 0) & BA_xor(31 DOWNTO 8) WHEN "11000",
					 BA_xor(6 DOWNTO 0) & BA_xor(31 DOWNTO 7) WHEN "11001",
					 BA_xor(5 DOWNTO 0) & BA_xor(31 DOWNTO 6) WHEN "11010",
					 BA_xor(4 DOWNTO 0) & BA_xor(31 DOWNTO 5) WHEN "11011",
					 BA_xor(3 DOWNTO 0) & BA_xor(31 DOWNTO 4) WHEN "11100",
					 BA_xor(2 DOWNTO 0) & BA_xor(31 DOWNTO 3) WHEN "11101",
					 BA_xor(1 DOWNTO 0) & BA_xor(31 DOWNTO 2) WHEN "11110",
					 BA_xor(0) & BA_xor(31 DOWNTO 1) WHEN "11111",
                BA_xor WHEN OTHERS; 

B<=B_rotated+skey(CONV_INTEGER(counter & '1'));--S[2×i+1]


PROCESS(key_ready, flag_started)
BEGIN
	IF (key_ready = '1') then 
		flag_started <= '1';
	END IF;
END PROCESS;

PROCESS(clk , clr, key_ready) 
BEGIN
	IF ( (clr = '1') OR (key_ready = '1') ) then  
		A_register <= input(63 downto 32) + s_key(0); -- Leo de la entrante directa porque el primer ciclo a la vez estoy seteando skey (cuando llega el flag ready)
		B_register <= input(31 downto 0) + s_key(1);
	ELSIF (clk'event and clk ='1' ) then 
		A_register <= A;
   	B_register <= B;
	END IF;
END PROCESS;

PROCESS(clr, clk, key_ready)  
BEGIN
	IF( (clr='1') OR (key_ready = '1') ) THEN 
		skey <= s_key;
		counter<="0001";
	ELSIF(clk'EVENT AND clk='1') THEN
		IF(counter="1100") THEN
			IF (flag_started = '1') THEN
				output_ready <= '1';
			END IF;
			counter<="0001";
		ELSE
         counter<=counter+'1';
      END IF;
   END IF;
END PROCESS;

output <= A_register & B_register;

end Behavioral;