library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file_TB is
end entity;

architecture sim of register_file_TB is
    -- Signals for register_file ports
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal read_reg1  : std_logic_vector(4 downto 0);
    signal read_reg2  : std_logic_vector(4 downto 0);
    signal write_reg  : std_logic_vector(4 downto 0);
    signal write_data : std_logic_vector(31 downto 0);
    signal reg_write  : std_logic := '0';
    signal read_data1 : std_logic_vector(31 downto 0);
    signal read_data2 : std_logic_vector(31 downto 0);

    -- Component declaration
    component register_file is
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            read_reg1   : in std_logic_vector(4 downto 0);
            read_reg2   : in std_logic_vector(4 downto 0);
            write_reg   : in std_logic_vector(4 downto 0);
            write_data  : in std_logic_vector(31 downto 0);
            reg_write   : in std_logic;
            read_data1  : out std_logic_vector(31 downto 0);
            read_data2  : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    -- Clock generation: 10ns period
    clk_process: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- Instantiate register file
    uut: register_file
        port map (
            clk        => clk,
            reset      => reset,
            read_reg1  => read_reg1,
            read_reg2  => read_reg2,
            write_reg  => write_reg,
            write_data => write_data,
            reg_write  => reg_write,
            read_data1 => read_data1,
            read_data2 => read_data2
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Reset the register file
        reset <= '1';
        wait for 10 ns;
        reset <= '0';

        -- Write 0xABCD1234 into register 5
        write_reg  <= "00101";          -- reg 5
        write_data <= x"ABCD1234";
        reg_write  <= '1';
        wait for 10 ns;

        -- Stop writing
        reg_write <= '0';

        -- Read from reg5 and reg0 (should be 0)
        read_reg1 <= "00101";           -- reg 5
        read_reg2 <= "00000";           -- reg 0 (always 0)
        wait for 10 ns;

        -- Read from reg2 and reg3 (should return default init values x"00000002" and x"00000003")
        read_reg1 <= "00010";
        read_reg2 <= "00011";
        wait for 10 ns;

        -- Done
        wait;
    end process;

end architecture;
