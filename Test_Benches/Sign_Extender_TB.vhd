library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtender_TB is
end entity;

architecture sim of SignExtender_TB is
    -- Signals for the SignExtender module ports
    signal InData  : std_logic_vector(15 downto 0);
    signal OutData : std_logic_vector(31 downto 0);

    -- Component declaration
    component SignExtender is
        port (
            InData  : in  std_logic_vector(15 downto 0);
            OutData : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    -- Instantiate the SignExtender component
    uut: SignExtender
        port map (
            InData  => InData,
            OutData => OutData
        );

    -- Stimulus process to apply different test cases
    stimulus: process
    begin
        -- Test 1: Apply a positive 16-bit value
        InData <= "0000000000001010";  -- Example positive value (10 in decimal)
        wait for 10 ns;
        assert (OutData = "00000000000000000000000000001010") report "Test failed!" severity error;

        -- Test 2: Apply a negative 16-bit value (sign extension)
        InData <= "1111111111111010";  -- Example negative value (-6 in decimal, two's complement)
        wait for 10 ns;
        assert (OutData = "11111111111111111111111111111010") report "Test failed!" severity error;

        -- Test 3: Apply all zeros
        InData <= "0000000000000000";  -- Zero value
        wait for 10 ns;
        assert (OutData = "00000000000000000000000000000000") report "Test failed!" severity error;

        -- Test 4: Apply all ones (negative number in two's complement)
        InData <= "1111111111111111";  -- All ones (negative value -1 in two's complement)
        wait for 10 ns;
        assert (OutData = "11111111111111111111111111111111") report "Test failed!" severity error;

        -- Done
        wait;
    end process;

end architecture;