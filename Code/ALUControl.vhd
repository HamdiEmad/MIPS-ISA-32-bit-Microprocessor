library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUControl is 
	port( 
		funct : in std_logic_vector(5 downto 0);
		ALUop : in std_logic_vector(1 downto 0);
		ALUSel : out std_logic_vector(3 downto 0)
	);
end entity;

Architecture Behavioral of ALUControl is
begin
	process(funct,ALUop)
	begin
		case ALUop is 
			when "00" => ALUSel <= "0000";
			when "01" => ALUSel <= "0001";
			when "10" => 
			case funct is  
				when "100000" => ALUSel <= "0000";
				when "100010" => ALUSel <= "0001";
				when "011010" => ALUSel <= "0010";
				when "011000" => ALUSel <= "0011";
				when "100100" => ALUSel <= "0100";
				when "100101" => ALUSel <= "0101";
				when "100110" => ALUSel <= "0110";
				when "101010" => ALUSel <= "1001";
				when "000010" => ALUSel <= "1000";
				when others => ALUSel <= "1111";
			end case;
			when others => ALUSel <= "1111";
		end case;	
	end process;
end architecture;