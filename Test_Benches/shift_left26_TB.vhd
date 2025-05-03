library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shift_Left26_TB is
end entity;

architecture sim of Shift_Left26_TB is
    -- Signals for the Shift_Left26 module ports
    signal input   : std_logic_vector(25 downto 0);
    signal output  : std_logic_vector(27 downto 0);

    -- Component declaration
    component Shift_Left26 is
        port (
            input  : in  std_logic_vector(25 downto 0);
            output : out std_logic_vector(27 downto 0)
        );
    end component;

begin
    -- Instantiate the Shift_Left26 component
    uut: Shift_Left26
        port map (
            input   => input,
            output  => output
        );

    -- Stimulus process to apply different test cases
    stimulus: process
    begin
        -- Test 1: Apply a simple input value
        input <= "10101010101010101010101010";  -- Example value: 26 bits
        wait for 10 ns;
        assert (output = "1010101010101010101010101000") report "Test failed!" severity error;

        -- Test 2: Test with all zeros input
        input <= "00000000000000000000000000";  -- 26 zeros
        wait for 10 ns;
        assert (output = "0000000000000000000000000000") report "Test failed!" severity error;

        -- Test 3: Test with all ones input
        input <= "11111111111111111111111111";  -- 26 ones
        wait for 10 ns;
        assert (output = "1111111111111111111111111100") report "Test failed!" severity error;

        -- Test 4: Apply another arbitrary value
        input <= "01101010010111011010101000";  -- Another random 26-bit value
        wait for 10 ns;
        assert (output = "0110101001011101101010100000") report "Test failed!" severity error;

        -- Done
        wait;
    end process;

end architecture;
