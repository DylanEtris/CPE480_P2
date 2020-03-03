// Important State Machine States
`define Start		4'b1000
`define Decode  	4'b1001

// Basic sizes
`define OPSIZE		[7:0]
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

//4 bit op codes
`define LdOrSt		4'b0010
`define TrapOrJr	4'b0000
`define OPci8		4'b1011
`define OPcii		4'b1100
`define OPcup		4'b1101
`define OPbz		4'b1110
`define OPbnz		4'b1111

// 8 bit op codes
`define OPtrap		8'b00000000
`define OPjr 		8'b00000001
`define OPld		8'b00100000
`define OPst		8'b00100001
`define OPnot		8'b00010000
`define OPi2p		8'b00100000
`define OPii2pp		8'b00100001
`define OPp2i		8'b00100010
`define OPpp2ii		8'b00100011
`define OPinvp		8'b00100100
`define OPinvpp		8'b00100101
`define OPanyi		8'b00110000
`define OPanyii		8'b00110001
`define OPnegi		8'b00110010
`define OPnegii		8'b00110011
`define OPand		8'b01010000
`define OPxor		8'b01010001
`define OPaddp		8'b01100000
`define OPaddpp		8'b01100001
`define OPmulp		8'b01100010
`define OPmulpp		8'b01100011
`define OPaddi		8'b01110000
`define OPaddii		8'b01110001
`define OPmuli		8'b01110010
`define OPmulii		8'b01110011
`define OPshi		8'b01110100
`define OPshii		8'b01110101
`define OPslti		8'b01110110
`define OPsltii		8'b01110111

// TODO: complete ALU
module alu(rd, rs, op, out);
	input reg `WORD rd;
	input wire `WORD rs;
	input wire `OPSIZE op;
	output wire `WORD out;
	always @* begin 
		case (op)
			`OPaddi: 
				begin
					out = rd + rs;
				end
			`OPaddii:
	end
endmodule

module processor(halt, reset, clk);
	//control signal definitions
	output reg halt;
	input reset, clk;
	reg `STATE s;
	wire `OPSIZE op;

	//processor component definitions
	reg `WORD text `MEMSIZE;		// instruction memory
	reg `WORD data `MEMSIZE;		// data memory
	reg `WORD pc = 0;
	reg `WORD ir;
	reg `WORD r `REGSIZE;		// Register File Size
	reg `WORD rd;
	wire `WORD rs;
	alu myalu(rd, rs, op, aluOut);

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
			`TrapOrJr: begin
				case (op)
					`OPtrap: 
						begin
							sys <= ir `Imm8; halt <= 1; 
						end
					`OPjr:
						begin
							//TODO do this instr
						end
				endcase
			 end // halts the program and saves the current instruction
			`Start: begin ir <= text[pc]; s <= `Decode; end // Fetches first instruction and moves the state to decode
			`Decode: 
				begin // TODO: Figure out how to assign state s to procede with next step.
					pc <= pc + 1;
					op <= {ir `Op0, ir `Op1};
					rn <= ir `Reg0;
					s  <= ir `Op0;
				end
			`LdOrSt:
				begin
					case (op)
						'OPld
						'OPst
				end
			`OPci8:
				begin
				end
			`OPcii:
				begin
				end
			`OPcup:
				begin
				end
			`OPbz:
				begin
				end
			`OPbnz:
				begin
				end
			default: //default cases are handled by ALU
				begin
					rd <= rn [ir `Reg0];
					rs <= rn [ir `Reg1];
					rn [ir `Reg0] <= aluOut;
				end
		endcase	
	end
endmodule
