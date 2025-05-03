library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux4x1_TB is
end entity;

architecture sim of mux4x1_TB is
    constant WIDTH : integer := 32;

    signal A, B, C, D : std_logic_vector(WIDTH-1 downto 0);
    signal Sel        : std_logic_vector(1 downto 0);
    signal Y          : std_logic_vector(WIDTH-1 downto 0);

    -- Component declaration
    component mux4x1 is
        generic (WIDTH : Integer);
        port (
            A, B, C, D : in  std_logic_vector(WIDTH-1 downto 0);
            Sel        : in  std_logic_vector(1 downto 0);
            Y          : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

begin
    -- Instantiate the MUX
    uut: mux4x1
        generic map (WIDTH => WIDTH)
        port map (
            A => A,
            B => B,
            C => C,
            D => D,
            Sel => Sel,
            Y => Y
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Apply input values
        A <= x"AAAAAAAA";
        B <= x"BBBBBBBB";
        C <= x"CCCCCCCC";
        D <= x"DDDDDDDD";

        -- Test Sel = "00" ? Y = A
        Sel <= "00";
        wait for 10 ns;

        -- Test Sel = "01" ? Y = B
        Sel <= "01";
        wait for 10 ns;

        -- Test Sel = "10" ? Y = C
        Sel <= "10";
        wait for 10 ns;

        -- Test Sel = "11" ? Y = D
        Sel <= "11";
        wait for 10 ns;

        wait;
    end process;

end architecture;
