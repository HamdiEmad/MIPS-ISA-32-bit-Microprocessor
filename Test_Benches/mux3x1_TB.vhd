library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux3x1_TB is
end entity;

architecture sim of mux3x1_TB is
    constant WIDTH : integer := 32;

    signal A, B, C : std_logic_vector(WIDTH-1 downto 0);
    signal Sel     : std_logic_vector(1 downto 0);
    signal Y       : std_logic_vector(WIDTH-1 downto 0);

    -- Component declaration
    component mux3x1 is
        generic (WIDTH : Integer);
        port (
            A, B, C : in  std_logic_vector(WIDTH-1 downto 0);
            Sel     : in  std_logic_vector(1 downto 0);
            Y       : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

begin
    -- Instantiate the MUX
    uut: mux3x1
        generic map (WIDTH => WIDTH)
        port map (
            A => A,
            B => B,
            C => C,
            Sel => Sel,
            Y => Y
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Set input values
        A <= x"AAAAAAAA";
        B <= x"BBBBBBBB";
        C <= x"CCCCCCCC";

        -- Test Sel = "00" ? Y = A
        Sel <= "00";
        wait for 10 ns;

        -- Test Sel = "01" ? Y = B
        Sel <= "01";
        wait for 10 ns;

        -- Test Sel = "10" ? Y = C
        Sel <= "10";
        wait for 10 ns;

        -- Test Sel = "11" ? Y = X"00000000"
        Sel <= "11";
        wait for 10 ns;

        wait;
    end process;

end architecture;
