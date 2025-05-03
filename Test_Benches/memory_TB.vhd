library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_memory is
end tb_memory;

architecture behavior of tb_memory is
    component memory
        port(
            address     : in std_logic_vector(31 downto 0);
            writeData   : in std_logic_vector(31 downto 0);
            memRead     : in std_logic;
            memWrite    : in std_logic;
            Clk         : in std_logic;
            enable      : in std_logic;
            memData     : out std_logic_vector(31 downto 0)
        );
    end component;

    signal address     : std_logic_vector(31 downto 0) := (others => '0');
    signal writeData   : std_logic_vector(31 downto 0) := (others => '0');
    signal memRead     : std_logic := '0';
    signal memWrite    : std_logic := '0';
    signal Clk         : std_logic := '0';
    signal enable      : std_logic := '1';
    signal memData     : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin
    uut: memory
        port map (
            address     => address,
            writeData   => writeData,
            memRead     => memRead,
            memWrite    => memWrite,
            Clk         => Clk,
            enable      => enable,
            memData     => memData
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            Clk <= '0';
            wait for clk_period / 2;
            Clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Wait for global reset
        wait for 20 ns;

        -- Read a known instruction (e.g., address 0)
        address <= x"00000000";
        memRead <= '1';
        wait for clk_period;

        memRead <= '0';
        wait for clk_period;

        -- Write to address 256
        address <= x"00000100"; -- byte offset 256
        writeData <= x"DEADBEEF";
        memWrite <= '1';
        wait for clk_period;
        memWrite <= '0';

        -- Read back from address 256
        wait for clk_period;
        memRead <= '1';
        wait for clk_period;
        memRead <= '0';

        wait;
    end process;

end behavior;
