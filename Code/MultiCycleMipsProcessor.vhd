library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MultiCycleMipsProcessor is 
	port(	
		clk,reset,enable : in std_logic
	);
end entity;
Architecture Behavioral of MultiCycleMipsProcessor is 

component control_unit is 
	port(
		clk,reset : in std_logic;
		operation : in std_logic_vector(5 downto 0);
		pc_write,pc_write_condition,IorD,memory_read,memory_write,memorytoregister,IR_write,ALUSrcA,RegWrite,RegDst : out std_logic;
	    ALUSrcB,ALU_operation,pc_source : out std_logic_vector(1 downto 0)	
	);
end component;

component memory is 
	port(
		address : in std_logic_vector(31 downto 0);
		writeData : in std_logic_vector(31 downto 0);
		memData : out std_logic_vector(31 downto 0);
		memRead : in std_logic;
		memWrite : in std_logic;
		Clk : in std_logic;
		enable : in std_logic
	);
end component;

component register_file is 
	port(
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

component registers is 
	port(
		input : in std_logic_vector(31 downto 0);
		output : out std_logic_vector(31 downto 0);
		enable : in std_logic;
		reset : in std_logic;
		Clk : in std_logic
	);
end component;

component ALU is 
	port(
		A        : in  std_logic_vector(31 downto 0);
	    B        : in  std_logic_vector(31 downto 0);
	    ALU_Sel  : in  std_logic_vector(3 downto 0);
	    Result   : out std_logic_vector(31 downto 0);
	    Zero     : out std_logic
	);
end component;	

component mux2x1 is
	generic (
    	WIDTH : Integer
	);
	port(
		A      : in  std_logic_vector(WIDTH-1 downto 0);
		B      : in  std_logic_vector(WIDTH-1 downto 0);
        Sel    : in  std_logic;
        Y      : out std_logic_vector(WIDTH-1 downto 0)
	);
end component;

component mux4x1 is
	generic (
	 	WIDTH : Integer
	);
    port (
		A,B,C,D: in  std_logic_vector(WIDTH-1 downto 0);
        Sel    : in  std_logic_vector(1 downto 0);
        Y      : out std_logic_vector(WIDTH-1 downto 0)
    );
end component;

component mux3x1 is
	generic (
	 	WIDTH : Integer
	);
    port (
		A,B,C: in  std_logic_vector(WIDTH-1 downto 0);
        Sel    : in  std_logic_vector(1 downto 0);
        Y      : out std_logic_vector(WIDTH-1 downto 0)
    );
end component;

component SignExtender is 
	port(
		InData  : in  std_logic_vector(15 downto 0);
	    OutData : out std_logic_vector(31 downto 0)
	);
end component;

component ALUControl is 
	port(
		funct : in std_logic_vector(5 downto 0);
		ALUop : in std_logic_vector(1 downto 0);
		ALUSel : out std_logic_vector(3 downto 0)
	);
end component; 

component shift_left32 is 
    Port (
        input  : in  STD_LOGIC_VECTOR(31 downto 0);
        output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component shift_left26 is 
    Port (
        input  : in  STD_LOGIC_VECTOR(25 downto 0);
        output : out STD_LOGIC_VECTOR(27 downto 0)
    );
end component; 

signal instruction,MuxToPC,PC_out,MuxToAddress,RegAout,RegBOut,memData,MDRToMux,MuxToWriteData,srcA,srcB,SignExtenderOut,shift_left32ToMux,Mux4ToALU,Mux5ToALU,ALUResultTOALUOut,ALUOut,jumpAddress : std_logic_vector(31 downto 0);
signal MuxToWriteReg : std_logic_vector(4 downto 0); 
signal ALUControltoALU : std_logic_vector(3 downto 0);
signal ALUSrcB,ALU_operation,pc_source : std_logic_vector(1 downto 0); 									
signal pc_write,pc_write_condition,IorD,memory_read,memory_write,memorytoregister,IR_write,ALUSrcA,RegWrite,RegDst,AndToOr,OrToPC,Zero : std_logic;
begin 
	AndToOr <= pc_write_condition and Zero;
	OrToPC <= AndToOr or pc_write;
	jumpAddress(31 downto 28) <= PC_out(31 downto 28);
	
	ControlUnit : control_unit 
	port map( 
		clk => clk,
		reset => reset,
		operation => instruction(31 downto 26),
		
		pc_write => pc_write,
		pc_write_condition => pc_write_condition,
		IorD => IorD,
		memory_read => memory_read,
		memory_write => memory_write,
		memorytoregister => memorytoregister,
		IR_write => IR_write,
		
		pc_source => pc_source,
		ALU_operation => ALU_operation,
		ALUSrcB => ALUSrcB,
		ALUSrcA => ALUSrcA,
		RegWrite => RegWrite,
		RegDst => RegDst
	);
	
	PC : registers
	port map( 
		Clk => clk,
		reset => reset,
		enable => OrToPC,
		input => MuxToPC,
		output => PC_out
	); 
	
	Memo : memory 
	port map( 
		Clk => clk,
		address => MuxToAddress,
		writeData => RegBOut,
		memRead => memory_read,
		memWrite => memory_write,
		memData => memData,
		enable => enable
	);
	
	MDR : registers
	port map( 
	 	Clk => clk,
		reset => reset,
		enable => '1',
		input => memData,
		output => MDRToMux
	); 
	
	IR : registers
	port map(
	 	Clk => clk,
		reset => reset,
		enable => IR_write,
		input => memData,
		output => instruction
	);
	
	RegFile : register_file
	port map(
		clk => clk,
		reset => '0',
		read_reg1 => instruction(25 downto 21),
		read_reg2 => instruction(20 downto 16),
		write_reg => MuxToWriteReg,
		write_data => MuxToWriteData,
		reg_write => RegWrite,
		read_data1 => srcA,
		read_data2 => srcB
	);
	
	Sign_Extender : SignExtender
	port map(
		InData => instruction(15 downto 0),
		OutData => SignExtenderOut
	);
	
	shiftLeft32 : shift_left32
	port map(
		input => SignExtenderOut,
		output => shift_left32ToMux
	);
	
	ALU_CONTROL : ALUControl
	port map (
		funct => instruction(5 downto 0),
		ALUop => ALU_operation,
		ALUSel => ALUControltoALU
	);
	
	Reg_A : registers
	port map(
		Clk => clk,
		reset => reset,
		enable => '1',
		input => srcA,
		output => RegAout
	);	
	
	Reg_B : registers
	port map(
		Clk => clk,
		reset => reset,
		enable => '1',
		input => srcB,
		output => RegBout
	);
	
	ARETHMITIC_LOGIC_UNIT : ALU
	port map(
		A => Mux4ToALU,
		B => Mux5ToALU,
		ALU_Sel => ALUControltoALU,
		Result => ALUResultTOALUOut, 
		Zero => Zero
	);
	
	ALU_OUT : registers
	port map(
		Clk => clk,
		reset => reset,
		enable => '1',
		input => ALUResultTOALUOut,
		output => ALUOut
	);
	
	shiftLeft26 : shift_left26
	port map(
		input => instruction(25 downto 0),
		output => jumpAddress(27 downto 0)
	);
	
	mux1 : mux2x1
	generic map(
	    WIDTH => 32
	)
	port map(
		A => PC_out,
		B => ALUOut,
		Sel => IorD,
		Y => MuxToAddress
	);
	
	mux2 : mux2x1
	generic map(
	    WIDTH => 5
	)
	port map(
		A => instruction(20 downto 16),
		B => instruction(15 downto 11),
		Sel => RegDst,
		Y => MuxToWriteReg
	);
	
	mux3 : mux2x1
	generic map(
	    WIDTH => 32
	)
	port map(
		A => ALUOut,
		B => MDRToMux,
		Sel => memorytoregister,
		Y => MuxToWriteData
	);
	
	mux4 : mux2x1
	generic map(
	    WIDTH => 32
	)
	port map(
		A => PC_out,
		B => SrcA,
		Sel => ALUSrcA,
		Y => Mux4ToALU
	);
	
	mux5 : mux4x1
	generic map(
	    WIDTH => 32
	)
	port map(
		A => SrcB,
		B => X"00000004",
		C => SignExtenderOut,
		D => shift_left32ToMux,
		Sel => ALUSrcB,
		Y => Mux5ToAlu
	);
	
	mux6 : mux3x1
	generic map(
	    WIDTH => 32
	)
	port map(
		A => ALUResultTOALUOut,
		B => ALUOut,
		C => jumpAddress,
		Sel => pc_source,
		Y => MuxToPc
	);
end Architecture;









