library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        A        : in  std_logic_vector(31 downto 0);
        B        : in  std_logic_vector(31 downto 0);
        ALU_Sel  : in  std_logic_vector(3 downto 0);
        Result   : out std_logic_vector(31 downto 0);
        Zero     : out std_logic
    );
end ALU;

architecture Behavioral of ALU is
    signal result_int : std_logic_vector(31 downto 0);
begin
    process(A, B, ALU_Sel)
    begin
        case ALU_Sel is
            when "0000" => result_int <= std_logic_vector(unsigned(A) + unsigned(B)); -- Addition
            when "0001" => result_int <= std_logic_vector(unsigned(A) - unsigned(B)); -- Subtraction
            when "0010" => 
                if unsigned(B) /= 0 then
                    result_int <= std_logic_vector(unsigned(A) / unsigned(B)); -- Division
                else
                    result_int <= (others => '0');
                end if;
            when "0011" => result_int <= std_logic_vector(unsigned(A) * unsigned(B)); -- Multiplication
            when "0100" => result_int <= A and B; -- AND
            when "0101" => result_int <= A or B;  -- OR
            when "0110" => result_int <= A xor B; -- XOR
            when "0111" => result_int <= not A;   -- NOT
            when "1000" => result_int <= std_logic_vector(shift_right(unsigned(A), 1)); -- Shift Right
            when "1001" => result_int <= std_logic_vector(shift_left(unsigned(A), 1));  -- Shift Left
            when others => result_int <= (others => '0');
        end case;
    end process;

    Result <= result_int;
    Zero <= '1' when result_int = x"00000000" else '0';
end Behavioral;

