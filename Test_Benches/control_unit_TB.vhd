library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit_tb is
end control_unit_tb;

architecture behavior of control_unit_tb is

    -- Component Declaration
    component control_unit is
        port (
            clk, reset           : in  std_logic;
            operation            : in  std_logic_vector(5 downto 0);
            pc_write             : out std_logic;
            pc_write_condition   : out std_logic;
            IorD                 : out std_logic;
            memory_read          : out std_logic;
            memory_write         : out std_logic;
            memorytoregister     : out std_logic;
            IR_write             : out std_logic;
            ALUSrcA              : out std_logic;
            RegWrite             : out std_logic;
            RegDst               : out std_logic;
            ALUSrcB              : out std_logic_vector(1 downto 0);
            ALU_operation        : out std_logic_vector(1 downto 0);
            pc_source            : out std_logic_vector(1 downto 0)
        );
    end component;

    -- Signals for interconnecting with DUT
    signal clk, reset                   : std_logic := '0';
    signal operation                    : std_logic_vector(5 downto 0) := (others => '0');
    signal pc_write, pc_write_condition : std_logic;
    signal IorD, memory_read            : std_logic;
    signal memory_write, memorytoregister : std_logic;
    signal IR_write, ALUSrcA            : std_logic;
    signal RegWrite, RegDst             : std_logic;
    signal ALUSrcB                      : std_logic_vector(1 downto 0);
    signal ALU_operation, pc_source     : std_logic_vector(1 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the control_unit
    uut: control_unit
        port map (
            clk => clk,
            reset => reset,
            operation => operation,
            pc_write => pc_write,
            pc_write_condition => pc_write_condition,
            IorD => IorD,
            memory_read => memory_read,
            memory_write => memory_write,
            memorytoregister => memorytoregister,
            IR_write => IR_write,
            ALUSrcA => ALUSrcA,
            RegWrite => RegWrite,
            RegDst => RegDst,
            ALUSrcB => ALUSrcB,
            ALU_operation => ALU_operation,
            pc_source => pc_source
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply reset
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        -- Test LW (opcode = "100011")
        operation <= "100011";
        wait for 6 * clk_period;

        -- Test SW (opcode = "101011")
        operation <= "101011";
        wait for 6 * clk_period;

        -- Test R-type (opcode = "000000")
        operation <= "000000";
        wait for 6 * clk_period;

        -- Test ADDI (opcode = "001000")
        operation <= "001000";
        wait for 6 * clk_period;

        -- Test BEQ (opcode = "000100")
        operation <= "000100";
        wait for 4 * clk_period;

        -- Test JUMP (opcode = "000010")
        operation <= "000010";
        wait for 3 * clk_period;

        -- Finish simulation
        wait;
    end process;

end behavior;
