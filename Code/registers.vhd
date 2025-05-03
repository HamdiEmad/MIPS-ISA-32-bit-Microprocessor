library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is
	port (
	input : in std_logic_vector(31 downto 0);
	output : out std_logic_vector(31 downto 0) := X"00000000";
	enable : in std_logic;
	reset : in std_logic;
	Clk : in std_logic
	);
end registers;

architecture archReg of registers is 
signal regOut : std_logic_vector(31 downto 0);
begin
	process (Clk, enable, reset)
	begin
		if reset = '1' then
			regOut <= (others => '0' );
		elsif rising_edge(Clk) and enable = '1' then 
			regOut <= input;
			end if;
		end process;
		output <= regOut;
end archReg;