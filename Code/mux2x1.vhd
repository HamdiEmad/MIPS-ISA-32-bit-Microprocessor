library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux2x1 is 
	generic (
	 	WIDTH : Integer
	);
    port (
		A,B    : in  std_logic_vector(WIDTH-1 downto 0);
        Sel    : in  std_logic;
        Y      : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture Behavioral of mux2x1 is
begin
	Y <= A when Sel = '0' else
	 	 B;
end architecture;
