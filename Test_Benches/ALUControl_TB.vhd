library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUControl_tb is
end ALUControl_tb;

architecture behavior of ALUControl_tb is

    -- Component Declaration for the ALUControl
    component ALUControl is
        port(
            funct   : in std_logic_vector(5 downto 0);
            ALUop   : in std_logic_vector(1 downto 0);
            ALUSel  : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Testbench signals
    signal funct   : std_logic_vector(5 downto 0) := (others => '0');
    signal ALUop   : std_logic_vector(1 downto 0) := (others => '0');
    signal ALUSel  : std_logic_vector(3 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: ALUControl
        port map (
            funct   => funct,
            ALUop   => ALUop,
            ALUSel  => ALUSel
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test ALUop = "00" (e.g., LW or SW)
        ALUop <= "00";
        funct <= "000000";  -- Don't care
        wait for 10 ns;

        -- Test ALUop = "01" (e.g., BEQ)
        ALUop <= "01";
        funct <= "000000";  -- Don't care
        wait for 10 ns;

        -- Test ALUop = "10" (R-type instructions)
        ALUop <= "10";

        funct <= "100000"; -- ADD
        wait for 10 ns;

        funct <= "100010"; -- SUB
        wait for 10 ns;

        funct <= "011010"; -- DIV
        wait for 10 ns;

        funct <= "011000"; -- MUL
        wait for 10 ns;

        funct <= "100100"; -- AND
        wait for 10 ns;

        funct <= "100101"; -- OR
        wait for 10 ns;

        funct <= "100110"; -- XOR
        wait for 10 ns;

        funct <= "101010"; -- SLT
        wait for 10 ns;

        funct <= "000010"; -- SRL
        wait for 10 ns;

        funct <= "111111"; -- Undefined function
        wait for 10 ns;

        -- Test invalid ALUop
        ALUop <= "11";
        funct <= "100000"; -- ADD (should not matter)
        wait for 10 ns;

        wait;
    end process;

end behavior;