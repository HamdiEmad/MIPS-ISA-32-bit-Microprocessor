library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers_TB is
end entity;

architecture sim of registers_TB is
    -- Signals for the registers module ports
    signal input   : std_logic_vector(31 downto 0);
    signal output  : std_logic_vector(31 downto 0);
    signal enable  : std_logic := '0';
    signal reset   : std_logic := '0';
    signal Clk     : std_logic := '0';

    -- Component declaration
    component registers is
        port (
            input   : in std_logic_vector(31 downto 0);
            output  : out std_logic_vector(31 downto 0);
            enable  : in std_logic;
            reset   : in std_logic;
            Clk     : in std_logic
        );
    end component;

begin
    -- Clock generation: 10ns period (50 MHz clock)
    clk_process: process
    begin
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
        wait for 5 ns;
    end process;

    -- Instantiate the registers component
    uut: registers
        port map (
            input   => input,
            output  => output,
            enable  => enable,
            reset   => reset,
            Clk     => Clk
        );

    -- Stimulus process to apply different test cases
    stimulus: process
    begin
        -- Test 1: Reset the register to all zeroes
        reset <= '1';  -- Assert reset
        wait for 10 ns;
        reset <= '0';  -- Deassert reset

        -- Test 2: Enable and write value to register
        input <= x"12345678";
        enable <= '1';  -- Enable the register
        wait for 10 ns;

        -- Test 3: Disable writing (output should not change)
        enable <= '0';  -- Disable the register
        wait for 10 ns;

        -- Test 4: Reset the register again
        reset <= '1';  -- Assert reset again
        wait for 10 ns;
        reset <= '0';  -- Deassert reset again

        -- Test 5: Enable again and write a different value
        input <= x"87654321";
        enable <= '1';  -- Enable the register
        wait for 10 ns;

        -- Done
        wait;
    end process;

end architecture;
