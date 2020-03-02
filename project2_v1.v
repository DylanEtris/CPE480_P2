// Important State Machine States
'define Start	5'b0000
'define Decode  5'b0001

// Basic sizes
'define STATE	[3:0]
'define WORD	[15:0]
'define MEMSIZE [65535:0]	// Total amount of instructions in memory
'define REGSIZE [7:0]		// Number of Registers

//Instruction Field Placements
//NOTE: I could be wrong about these, I generated them from Dr. Deitz's assembler implementation
'define Op0		[15:12]
'define Op1		[11:8]
'define Reg0	[3:0]
'define Reg1	[7:4]
'define Imm8	[11:4]

// TODO: complete ALU
module alu()

module processor(halt, reset, clk);
	//control signal definitions
	output reg halt;
	input reset, clk;
	reg 'STATE s, op

	//processor component definitions
	reg 'WORD text'MEMSIZE;		// instruction memory
	reg 'WORD data 'MEMSIZE;	// data memory
	reg 'WORD pc = 0;
	reg 'WORD ir;
	reg 'WORD r 'REGSIZE;		// Register File Size
	//alu myalu();

	//processor initialization
	always @(posedge reset) begin
		halt <= 0;
		pc <= 0;
		s <= 'Start;

		//The following functions read from VMEM?
		//readmemh1(text);
		//readmemh2(data);
	end

	always @(posedge clk) begin
		//State machine case
		case (s)
			'Start: begin ir <= text[pc]; s <= 'Decode; end // Fetches first instruction and moves the state to decode
			'Decode: 
				begin // TODO: Figure out how to assign state s to procede with next step.
					pc <= pc + 1;
					op <= ir 'Op0;
					rn <= ir 'Reg0;
				end
			// TODO: add other state cases like jumps, branches, and arithmetic operations.
			default: begin sys <= ir 'Imm8; halt <= 1; end; // halts the program and saves the current instruction
		endcase	
	end
endmodule