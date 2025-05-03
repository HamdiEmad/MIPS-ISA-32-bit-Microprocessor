library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shift_Left32_TB is
end entity;

architecture sim of Shift_Left32_TB is
    -- Signals for the Shift_Left32 module ports
    signal input   : std_logic_vector(31 downto 0);
    signal output  : std_logic_vector(31 downto 0);

    -- Component declaration
    component Shift_Left32 is
        port (
            input  : in  std_logic_vector(31 downto 0);
            output : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    -- Instantiate the Shift_Left32 component
    uut: Shift_Left32
        port map (
            input   => input,
            output  => output
        );

    -- Stimulus process to apply different test cases
    stimulus: process
    begin
        -- Test 1: Apply a simple input value
        input <= "10101010101010101010101010101010";  -- Example value: 31 bits (shift should happen)
        wait for 10 ns;
        assert (output = "10101010101010101010101010101000") report "Test failed!" severity error;

        -- Test 2: Test with all zeros input
        input <= "00000000000000000000000000000000";  -- 32 zeros
        wait for 10 ns;
        assert (output = "00000000000000000000000000000000") report "Test failed!" severity error;

        -- Test 3: Test with all ones input
        input <= "11111111111111111111111111111111";  -- 32 ones
        wait for 10 ns;
        assert (output = "11111111111111111111111111111100") report "Test failed!" severity error;

        -- Test 4: Apply another arbitrary value
        input <= "01101010010111011010101010101010";  -- Another random 32-bit value
        wait for 10 ns;
        assert (output = "01101010010111011010101010101000") report "Test failed!" severity error;

        -- Done
        wait;
    end process;

end architecture;