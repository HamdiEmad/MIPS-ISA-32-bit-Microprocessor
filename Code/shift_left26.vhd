library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Shift_Left26 is
    Port (
        input  : in  STD_LOGIC_VECTOR(25 downto 0);
        output : out STD_LOGIC_VECTOR(27 downto 0)
    );
end Shift_Left26;

architecture Behavioral of Shift_Left26 is
begin   
    output <= input & "00";
end Behavioral;
