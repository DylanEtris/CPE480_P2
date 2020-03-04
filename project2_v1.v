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
`define HighBits	[15:8]
`define LowBits		[7:0]

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
`define OPor		8'b01010001
`define OPxor		8'b01010010
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
module alu(rd, rs, op, aluOut, aluTrap);
	input `WORD rd;
	input wire `WORD rs;
	input wire `OPSIZE op;
	output wire `WORD aluOut;
	output wire aluTrap;
	
	reg `WORD out;
	assign aluOut = out;
	
	reg trap;
	assign aluTrap = trap;
	
	
	//These are the operations 
	always @* begin 
		case (op)
			`OPaddi:  begin out = rd `WORD + rs `WORD; end
			`OPaddii: begin
				out `HighBits = rd `HighBits + rs `HighBits; 
				out `LowBits = rd `LowBits + rs `LowBits;
			end
			`OPmuli: begin out = rd `WORD * rs `WORD; end
			`OPmulii: begin 
				out `HighBits = rd `HighBits * rs `HighBits; 
				out `LowBits = rd `LowBits * rs `LowBits; 
			end
			`OPshi: begin out = ((rs `WORD > 0) ? (rd `WORD << rs `WORD) : (rd[15:0] >> -rs[15:0])); end
			`OPshii: begin 
				out `HighBits = ((rs `HighBits >0)?(rd `HighBits <<rs `HighBits):(rd `HighBits >>-rs `HighBits ));
				out `LowBits = ((rs `LowBits >0)?(rd `LowBits <<rs `LowBits):(rd `LowBits >>-rs `LowBits ));
			end
			`OPslti: begin out = rd `WORD < rs `WORD; end
			`OPsltii: begin 
				out `HighBits= rd `HighBits < rs `HighBits; 
				out `LowBits = rd `LowBits < rs `LowBits; 
			end
			`OPaddp: begin assign trap = 1; end
			`OPaddpp: begin trap = 1; end
			`OPmulp: begin trap = 1; end
			`OPmulpp: begin trap = 1; end
			`OPand: begin out = rd & rs; end
			`OPor: begin out = rd | rs; end
			`OPxor: begin out = rd ^ rs; end
			`OPanyi: begin out = (rd ? -1: 0); end
			`OPanyii: begin 
				out `HighBits= (rd `HighBits ? -1 : 0); 
				out `LowBits = (rd `LowBits ? -1 : 0); 
			end
			`OPnegi: begin out = ~rd; end
			`OPnegii: begin 
				out `HighBits = ~rd `HighBits; 
				out `LowBits = ~rd `LowBits; 
			end
			`OPi2p: begin trap = 1; end
			`OPii2pp: begin trap = 1; end
			`OPp2i: begin trap = 1; end
			`OPpp2ii: begin trap = 1; end
			`OPinvp: begin trap = 1; end
			`OPinvpp: begin trap = 1; end
			`OPnot: begin out = ~rd; end	
		endcase	
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
	reg `WORD regfile `REGSIZE;		// Register File Size
	reg `WORD rd;
	wire `WORD rs, aluOut;
	wire trap;
	alu myalu(rd, rs, op, aluOut, trap);

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
							halt <= 1; 
						end
					`OPjr:
						begin
							//TODO do this instr
						end
				endcase
			 end // halts the program and saves the current instruction
			`Start: begin ir <= text[pc]; pc <= pc + 1; s <= `Decode; end // Fetches first instruction and moves the state to decode
			`Decode: 
				begin // TODO: Figure out how to assign state s to procede with next step.
					op <= {ir `Op0, ir `Op1};
					s  <= ir `Op0;
				end
			`LdOrSt:
				begin
					case (op)
						`OPld:
							begin
							end
						`OPst:
							begin
							end
					endcase
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

module testbench;
reg reset = 0;
reg clk = 0;
wire halted;
processor PE(halted, reset, clk);
initial begin
  $dumpfile;
  $dumpvars(0, PE);
  #10 reset = 1;
  #10 reset = 0;
  while (!halted) begin
    #10 clk = 1;
    #10 clk = 0;
  end
  $finish;
end
endmodule
