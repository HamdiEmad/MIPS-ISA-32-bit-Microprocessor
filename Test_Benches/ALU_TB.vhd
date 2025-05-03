library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_tb is
end ALU_tb;

architecture behavior of ALU_tb is
    component ALU is
        Port (
            A        : in  std_logic_vector(31 downto 0);
            B        : in  std_logic_vector(31 downto 0);
            ALU_Sel  : in  std_logic_vector(3 downto 0);
            Result   : out std_logic_vector(31 downto 0);
            Zero     : out std_logic
        );
    end component;

    signal A       : std_logic_vector(31 downto 0) := (others => '0');
    signal B       : std_logic_vector(31 downto 0) := (others => '0');
    signal ALU_Sel : std_logic_vector(3 downto 0) := (others => '0');
    signal Result  : std_logic_vector(31 downto 0);
    signal Zero    : std_logic;

begin

    uut: ALU
        port map (
            A => A,
            B => B,
            ALU_Sel => ALU_Sel,
            Result => Result,
            Zero => Zero
        );

    stim_proc: process
    begin  
		
        -- Test addition
        A <= x"0000000A"; -- 10
        B <= x"00000014"; -- 20
        ALU_Sel <= "0000"; -- A + B
        wait for 10 ns;

        -- Test subtraction
        ALU_Sel <= "0001"; -- A - B
        wait for 10 ns;

        -- Test division
        ALU_Sel <= "0010"; -- A / B
        wait for 10 ns;

        -- Test AND
        ALU_Sel <= "0100";
        wait for 10 ns;

        -- Test OR
        ALU_Sel <= "0101";
        wait for 10 ns;

        -- Test XOR
        ALU_Sel <= "0110";
        wait for 10 ns;

        -- Test NOT
        ALU_Sel <= "0111";
        wait for 10 ns;

        -- Test shift right
        ALU_Sel <= "1000";
        wait for 10 ns;

        -- Test shift left
        ALU_Sel <= "1001";
        wait for 10 ns;

        -- Test Zero flag (A - A = 0)
        A <= x"00000010";
        B <= x"00000010";
        ALU_Sel <= "0001"; -- A - B
        wait for 10 ns;

        wait; -- Stop simulation
    end process;

end behavior;