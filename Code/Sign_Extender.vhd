library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SignExtender is
    Port (
        InData  : in  std_logic_vector(15 downto 0);
        OutData : out std_logic_vector(31 downto 0)
    );
end SignExtender;

architecture Behavioral of SignExtender is
begin
    -- (sign extend)
    OutData <= (15 downto 0 => InData(15)) & InData;
end Behavioral;
 