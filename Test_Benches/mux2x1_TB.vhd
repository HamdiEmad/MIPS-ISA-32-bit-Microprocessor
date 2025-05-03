library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux2x1_TB is
end entity;

architecture sim of mux2x1_TB is
    constant WIDTH : integer := 8;
    
    signal A, B : std_logic_vector(WIDTH-1 downto 0);
    signal Sel  : std_logic;
    signal Y    : std_logic_vector(WIDTH-1 downto 0);

    -- Component declaration
    component mux2x1 is
        generic (WIDTH : Integer);
        port (
            A, B : in std_logic_vector(WIDTH-1 downto 0);
            Sel  : in std_logic;
            Y    : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

begin
    -- Instantiate the MUX
    uut: mux2x1
        generic map (WIDTH => WIDTH)
        port map (
            A => A,
            B => B,
            Sel => Sel,
            Y => Y
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Test 1: Sel = '0' --> Y = A
        A   <= x"AA";  -- 10101010
        B   <= x"55";  -- 01010101
        Sel <= '0';
        wait for 10 ns;

        -- Test 2: Sel = '1' --> Y = B
        Sel <= '1';
        wait for 10 ns;

        -- Test 3: Change inputs again
        A   <= x"0F";
        B   <= x"F0";
        Sel <= '0';
        wait for 10 ns;

        Sel <= '1';
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end architecture;