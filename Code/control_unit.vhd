library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity control_unit is 	 
	port(
	clk,reset : in std_logic;
	operation : in std_logic_vector(5 downto 0);
	pc_write,pc_write_condition,IorD,memory_read,memory_write,memorytoregister,IR_write,ALUSrcA,RegWrite,RegDst : out std_logic;
    ALUSrcB,ALU_operation,pc_source : out std_logic_vector(1 downto 0)	
	);
end control_unit;

architecture Behavioral of control_unit is
  type state is( InstructionFetch,
                 InstructionDecode,
                 MemoryAddressComp,
                 Execution_R,
                 Execution_I,
                 BranchCompletion,
                 JumpCompletion,
                 MemoryAccessLoad,
                 MemoryAccessStore,
                 RTypeCompletion,
                 ITypeCompletion,
                 MemoryReadCompletionStep );
				 
				 
  signal current_state, next_state : state;
  signal ctrl_state : std_logic_vector(15 downto 0) := (others => '0');	
  begin
	  
	  
  process(clk, reset, operation)
  begin
    if reset = '1' then
      current_state <= InstructionFetch;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;		
	

	case current_state is
      when InstructionFetch  => next_state <= InstructionDecode;
	  --case current_state is
      when InstructionDecode =>
        case operation is
          when "100011" => next_state <= MemoryAddressComp;
          when "101011" => next_state <= MemoryAddressComp;
          when "000000" => next_state <= Execution_R;
          when "001000" => next_state <= Execution_I;
          when "000100" => next_state <= BranchCompletion;
          when "000010" => next_state <= JumpCompletion;
          when others   => next_state <= InstructionFetch;
        end case;						
	  when MemoryAddressComp => if operation = "100011" then -- lw
                                    next_state <= MemoryAccessLoad;
                                  else  -- sw
                                    next_state <= MemoryAccessStore;
                                  end if;		  
	  when Execution_R         => next_state <= RTypeCompletion;

      when Execution_I       => next_state <= ITypeCompletion;
		
	  when MemoryAccessLoad  => next_state <= MemoryReadCompletionStep;

      when MemoryAccessStore => next_state <= InstructionFetch;

      when BranchCompletion  => next_state <= InstructionFetch;

      when JumpCompletion    => next_state <= InstructionFetch;

      when RTypeCompletion   => next_state <= InstructionFetch;

      when others            => next_state <= InstructionFetch;

    end case;
  end process;	  
  
  
  with current_state select
    ctrl_state <= "1001001000001000" when InstructionFetch,
                  "0000000000011000" when InstructionDecode,
                  "0000000000010100" when MemoryAddressComp,
                  "0000000001000100" when Execution_R,
                  "0000000000010100" when Execution_I,
                  "0100000010100100" when BranchCompletion,
                  "1000000100000000" when JumpCompletion,
                  "0011000000000000" when MemoryAccessLoad,
                  "0010100000000000" when MemoryAccessStore,
                  "0000000000000011" when RTypeCompletion,
                  "0000000000000010" when ITypeCompletion,
                  "0000010000000010" when MemoryReadCompletionStep,
                  "0000000000000000" when others;	 
				  
  pc_write                    <= ctrl_state(15);
  pc_write_condition          <= ctrl_state(14);
  IorD                        <= ctrl_state(13);
  Memory_Read                 <= ctrl_state(12);
  Memory_Write                <= ctrl_state(11);
  memorytoregister            <= ctrl_state(10);
  IR_write                     <= ctrl_state(9);
  pc_source           <= ctrl_state(8 downto 7);
  ALU_operation       <= ctrl_state(6 downto 5);
  ALUSrcB             <= ctrl_state(4 downto 3);
  ALUSrcA                      <= ctrl_state(2);
  RegWrite                     <= ctrl_state(1);
  RegDst                       <= ctrl_state(0);

end Behavioral;

