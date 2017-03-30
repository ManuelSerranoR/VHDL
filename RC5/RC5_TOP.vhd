----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:04:48 12/05/2016 
-- Design Name: 
-- Module Name:    RC5_TOP - Behavioral 
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.RC5_Package.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RC5_TOP is
    Port ( clr : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (15 downto 0);
           button_a : in  STD_LOGIC;
           button_b : in  STD_LOGIC;
			  in_val : in  STD_LOGIC;
           leds : out  STD_LOGIC_VECTOR (15 downto 0);
           segments_catode : out  STD_LOGIC_VECTOR (7 downto 0);
           segments_anode : out  STD_LOGIC_VECTOR (7 downto 0));
end RC5_TOP;

architecture Behavioral of RC5_TOP is

-----------------------------------------------------------------------------------------------------------
--THE FOLLOWING CODE IS FOR THE 7-SEG DISPLAY
-----------------------------------------------------------------------------------------------------------
component Hex_to_seg 
	port (
		CLK: in STD_LOGIC; 
		X: in STD_LOGIC_VECTOR (3 downto 0); 
		Y: out STD_LOGIC_VECTOR (7 downto 0)
	); 
end component;

type arr is array(0 to 22) of std_logic_vector(7 downto 0);
signal NAME: arr;

constant CNTR_MAX : std_logic_vector(23 downto 0) := x"030D40"; --100,000,000 = clk cycles per second
constant VAL_MAX : std_logic_vector(3 downto 0) := "1001"; --9

--This is used to determine when the 7-segment display should be
--incremented
signal Cntr : std_logic_vector(26 downto 0) := (others => '0');

--This counter keeps track of which number is currently being displayed
--on the 7-segment.
signal Val : std_logic_vector(3 downto 0) := (others => '0');

--This is the signal that holds the hex value to be diplayed
signal value_display: std_logic_vector(31 downto 0):= x"00000000";
-----------------------------------------------------------------------------------------------------------
--END OF CODE FOR 7 SEGMENTS DISPLAYS
-----------------------------------------------------------------------------------------------------------


--Components

component RC5_Key_Gen
Port (     clr : IN  STD_LOGIC;
           clk : IN  STD_LOGIC;
           key_in : IN STD_LOGIC;
           user_key : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
           s_key : INOUT  S_ARRAY;
           key_ready : OUT  STD_LOGIC);
end component;

component RC5_Encryption
Port (     clr : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  key_ready : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (63 downto 0);
			  s_key : in  S_ARRAY;
			  output_ready : out  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (63 downto 0));
end component;

component RC5_Decryption
Port (     clr : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  key_ready : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (63 downto 0);
			  s_key : in  S_ARRAY;
			  output_ready : out  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (63 downto 0));
end component;

--Wires that connect components
signal wire_key_ready : STD_LOGIC;
signal key : S_ARRAY;
signal user_key : STD_LOGIC_VECTOR (127 DOWNTO 0); --This signal is the values of the 128 bits user key before expanding
signal user_key_ready : STD_LOGIC;

signal AB_Input : STD_LOGIC_VECTOR (63 downto 0); --This signal is the input that is to be treated
signal AB_Output_Encrypted : STD_LOGIC_VECTOR (63 downto 0); --This signal is the output already treated
signal AB_Output_Decrypted : STD_LOGIC_VECTOR (63 downto 0); --This signal is the output already treated
signal AB_Output_Encrypted_Stable : STD_LOGIC_VECTOR (63 downto 0); --This signal is the output already treated
signal AB_Output_Decrypted_Stable : STD_LOGIC_VECTOR (63 downto 0); --This signal is the output already treated

signal output_ready_encryption : STD_LOGIC;
signal output_ready_decryption : STD_LOGIC;
type states IS (load, run, display);
signal state, nextstate : states;

--Clock divider
SIGNAL clock_counter : integer range 0 to 1 := 0;
SIGNAL clk : STD_LOGIC := '0';

begin


-----------------------------------------------------------------------------------------------------------
--THE FOLLOWING CODE IS FOR THE 7-SEG DISPLAY
-----------------------------------------------------------------------------------------------------------
timer_counter_process : process (clock)
begin
	if (rising_edge(clock)) then
		if ((Cntr = CNTR_MAX) or (clr = '1')) then
			Cntr <= (others => '0');
		else
			Cntr <= Cntr + 1;
		end if;
	end if;
end process;

--This process increments the digit being displayed on the 
--7-segment display every second.
timer_inc_process : process (clock)
begin
	if (rising_edge(clock)) then
		if (clr = '1') then
			Val <= (others => '0');
		elsif (Cntr = CNTR_MAX) then
			if (Val = VAL_MAX) then
				Val <= (others => '0');
			else
				Val <= Val + 1;
			end if;
		end if;
	end if;
end process;

--This select statement selects the 7-segment diplay anode. 
with Val select
	segments_anode <= "01111111" when "0001",
							"10111111" when "0010",
							"11011111" when "0011",
							"11101111" when "0100",
							"11110111" when "0101",
							"11111011" when "0110",
							"11111101" when "0111",
							"11111110" when "1000",
							"11111111" when others;

--This select statement selects the value of HexVal to the necessary
--cathode signals to display it on the 7-segment
with Val select
	segments_catode <= NAME(0) when "0001",
							NAME(1) when "0010",
							NAME(2) when "0011",
							NAME(3) when "0100",
							NAME(4) when "0101",
							NAME(5) when "0110",
							NAME(6) when "0111",
							NAME(7) when "1000",
							NAME(0) when others;

CONV1: Hex_to_seg port map (CLK => clock, X => value_display(31 downto 28), Y => NAME(0));
CONV2: Hex_to_seg port map (CLK => clock, X => value_display(27 downto 24), Y => NAME(1));
CONV3: Hex_to_seg port map (CLK => clock, X => value_display(23 downto 20), Y => NAME(2));
CONV4: Hex_to_seg port map (CLK => clock, X => value_display(19 downto 16), Y => NAME(3));		
CONV5: Hex_to_seg port map (CLK => clock, X => value_display(15 downto 12), Y => NAME(4));
CONV6: Hex_to_seg port map (CLK => clock, X => value_display(11 downto 8), Y => NAME(5));
CONV7: Hex_to_seg port map (CLK => clock, X => value_display(7 downto 4), Y => NAME(6));
CONV8: Hex_to_seg port map (CLK => clock, X => value_display(3 downto 0), Y => NAME(7));
-----------------------------------------------------------------------------------------------------------
--END OF CODE FOR 7-SEG DISPLAY
-----------------------------------------------------------------------------------------------------------


--Map Components port_of_the_component => signal_here

Key_Genator: RC5_Key_Gen  
port map (  clr => clr,
				clk => clk,
				key_in => user_key_ready,
				user_key => user_key,
				s_key => key,
				key_ready => wire_key_ready
			 );
			 
Encryption: RC5_Encryption  
port map (  clr => clr,
				clk => clk,
				key_ready => wire_key_ready,
				input => AB_Input,
				s_key => key,
				output_ready => output_ready_encryption,
				output => AB_Output_Encrypted
			 );
			 
Decryption: RC5_Decryption  
port map (  clr => clr,
				clk => clk,
				key_ready => wire_key_ready,
				input => AB_Input,
				s_key => key,
				output_ready => output_ready_decryption,
				output => AB_Output_Decrypted
			 );

--State Machine LOAD, RUN, DISPLAY

process(state, button_a, button_b, output_ready_encryption, output_ready_decryption)
begin
		case state is
			when load =>
				leds(15 downto 0) <= "1111000000000000";
				if (button_b = '1') then
					user_key_ready <= '1';
					nextstate <= run; 
				else 
					nextstate <= load;
				end if;
				
			when run =>
				leds(15 downto 0) <= "0000111100000000";
				if( (output_ready_encryption = '1') AND (output_ready_decryption = '1') )then
					AB_Output_Encrypted_Stable <= AB_Output_Encrypted;
					AB_Output_Decrypted_Stable <= AB_Output_Decrypted;
					nextstate <= display; 
				else 
					nextstate <= run;
				end if;
			
			when display =>
				leds(15 downto 0) <= "0000000011110000";
				if (button_a = '1') then
					nextstate <= load; 
				else 
					nextstate <= display;
				end if;
			end case;
end process;

--State Machine clear and progress
process(clr, clk) 
begin
	if (rising_edge(clk)) then 
		if (clr = '1') then 
			state <= load;
		else 
			state <= nextstate;
		end if;
	end if;
end process;

--Taking Inputs
process(clr, clk, in_val, input, state) 
begin
	if (rising_edge(clk)) then
		if (clr = '1') then
			AB_input <= (others=>'0');
			user_key <= (others=>'0');
			
		elsif (state = load and input(7 downto 0) = x"00" and in_val = '1') then 
			user_key (7 downto 0) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"01" and in_val = '1') then 
			user_key (15 downto 8) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"02" and in_val = '1') then 
			user_key (23 downto 16) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"03" and in_val = '1') then 
			user_key (31 downto 24) <= input(15 downto 8);
			
		elsif (state = load and input(7 downto 0) = x"04" and in_val = '1') then 
			user_key (39 downto 32) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"05" and in_val = '1') then 
			user_key (47 downto 40) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"06" and in_val = '1') then 
			user_key (55 downto 48) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"07" and in_val = '1') then 
			user_key (63 downto 56) <= input (15 downto 8);
			
		elsif (state = load and input(7 downto 0) = x"08" and in_val = '1') then 
			user_key (71 downto 64) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"09" and in_val = '1') then 
			user_key (79 downto 72) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"0A" and in_val = '1') then 
			user_key (87 downto 80) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"0B" and in_val = '1') then 
			user_key (95 downto 88) <= input (15 downto 8);
			
		elsif (state = load and input(7 downto 0) = x"0C" and in_val = '1') then 
			user_key (103 downto 96) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"0D" and in_val = '1') then 
			user_key (111 downto 104) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"0E" and in_val = '1') then 
			user_key (119 downto 112) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"0F" and in_val = '1') then 
			user_key (127 downto 120) <= input (15 downto 8);
			
			
		elsif (state = load and input(7 downto 0) = x"10" and in_val = '1') then 
			AB_input (7 downto 0) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"11" and in_val = '1') then 
			AB_input (15 downto 8) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"12" and in_val = '1') then 
			AB_input (23 downto 16) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"13" and in_val = '1') then 
			AB_input (31 downto 24) <= input (15 downto 8);
			
		elsif (state = load and input(7 downto 0) = x"14" and in_val = '1') then 
			AB_input (39 downto 32) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"15" and in_val = '1') then 
			AB_input (47 downto 40) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"16" and in_val = '1') then 
			AB_input (55 downto 48) <= input (15 downto 8);
		elsif (state = load and input(7 downto 0) = x"17" and in_val = '1') then 
			AB_input (63 downto 56) <= input (15 downto 8);
		end if;
	end if;		
end process;

process (state, input(1 downto 0), AB_Output_Encrypted_Stable, AB_Output_Decrypted_Stable)
begin

	if (state = display) then
		if (input(1 downto 0) = "00") then 
			value_display <= AB_Output_Encrypted_Stable(31 downto 0);
		elsif (input(1 downto 0) = "01") then 
			value_display <= AB_Output_Encrypted_Stable(63 downto 32);
		elsif (input(1 downto 0) = "10") then 
			value_display <= AB_Output_Decrypted_Stable(31 downto 0);
		elsif (input(1 downto 0) = "11") then 
			value_display <= AB_Output_Decrypted_Stable(63 downto 32);
		else 
			value_display <= x"55555555";
		end if;
	end if;
end process;

frequency_escaler: 
PROCESS(clock) 
BEGIN
	IF (rising_edge(clock)) THEN
		IF (clock_counter = 1) THEN
			clk <= NOT(clk);
			clock_counter <= 0;
		ELSE
			clock_counter <= clock_counter + 1;
		END IF;
	END IF;
END PROCESS;

end Behavioral;