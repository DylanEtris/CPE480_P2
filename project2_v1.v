// Important State Machine States
`define Start		4'b1000
`define Decode  	4'b1001

// Basic sizes
`define OPSIZE			[7:0]
`define STATE		[3:0]
`define WORD		[15:0]
`define MEMSIZE 	[65535:0]	// Total amount of instructions in memory
`define REGSIZE 	[7:0]		// Number of Registers

//Instruction Field Placements
//NOTE: I could be wrong about these, I generated them from Dr. Deitz's assembler implementation
`define Op0		[15:12]
`define Op1		[11:8]
`define Reg0		[3:0]
`define Reg1		[7:4]
`define Imm8		[11:4]

//Instruction Codes
`define JrOrTrap	4'b0000
`define Conversions	4'b0010
`define AnyOrNeg	4'b0011
`define LdOrSt		4'b0100
`define Bitwise		4'b0101
`define PositArith	4'b0110
`define IntArith	4'b0111
`define Ci8		4'b1011
`define Cii		4'b1100
`define Cup		4'b1101
`define Bz		4'b1110
`define Bnz		4'b1111

// TODO: complete ALU
module alu();
	
endmodule

module processor(halt, reset, clk);
	//control signal definitions
	output reg halt;
	input reset, clk;
	reg `STATE s;
	reg `OPSIZE op;

	//processor component definitions
	reg `WORD text `MEMSIZE;		// instruction memory
	reg `WORD data `MEMSIZE;	// data memory
	reg `WORD pc = 0;
	reg `WORD ir;
	reg `WORD r `REGSIZE;		// Register File Size
	//alu myalu();

	//processor initialization
	always @(posedge reset) begin
		halt <= 0;
		pc <= 0;
		s <= `Start;

		//The following functions read from VMEM?
		//readmemh1(text);
		//readmemh2(data);
	end

	always @(posedge clk) begin
		//State machine case
		case (s)
			`Start: begin ir <= text[pc]; s <= `Decode; end // Fetches first instruction and moves the state to decode
			`Decode: 
				begin // TODO: Figure out how to assign state s to procede with next step.
					pc <= pc + 1;
					op <= {ir `Op0, ir `Op1};
					rn <= ir `Reg0;
					s  <= ir `Op0;
				end
			`JrOrTrap:
				begin
					case (op [3:0])
						4'b0000:
							s <= 4'b0000;
						4'b0001:
							pc <= r [rn] `REGSIZE;
					endcase
					s <= `Start;
				end
			`Not: 
				begin
					r [rn] `REGSIZE <= ~ r [rn] `REGSIZE;
					s <= `Start;
				end
			`Conversions:
				begin
					s <= 4'b0000;
				end
			`AnyOrNeg:
				begin
				end
			`LdOrSt:
				begin
				end
			`Bitwise:
				begin
				end
			`PositArith:
				begin
					s <= 4'b0000;
				end
			`IntArith:
				begin
					case (op [3:0])
						4'b0000:
							
				end
			`Ci8:
				begin
				end
			`Cii:
				begin
				end
			`Cup:
				begin
				end
			`Bz:
				begin
				end
			`Bnz:
				begin
				end
			// TODO: add other state cases like jumps, branches, and arithmetic operations.
			default: begin sys <= ir `Imm8; halt <= 1; end; // halts the program and saves the current instruction
		endcase	
	end
endmodule
