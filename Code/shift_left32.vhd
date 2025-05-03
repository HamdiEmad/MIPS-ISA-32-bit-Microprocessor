library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Shift_Left32 is
    Port (
        input  : in  STD_LOGIC_VECTOR(31 downto 0);
        output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Shift_Left32;

architecture Behavioral of Shift_Left32 is
begin   
    output <= input(29 downto 0) & "00";
end Behavioral;
