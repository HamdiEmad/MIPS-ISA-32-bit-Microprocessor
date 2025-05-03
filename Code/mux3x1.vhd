library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux3x1 is 
	generic (
	 	WIDTH : Integer
	);
    port (
		A,B,C: in  std_logic_vector(WIDTH-1 downto 0);
        Sel    : in  std_logic_vector(1 downto 0);
        Y      : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture Behavioral of mux3x1 is
begin
	Y <= A when Sel = "00" else
		 B when Sel = "01" else
		 C when Sel = "10" else
		 X"00000000";
end architecture;
						  					