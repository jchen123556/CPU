`include "memory.v"

module cpu(clk, rst_n, hlt, pc);
	input clk rst_n;
	output hlt;
	output [15:0] pc;
	// 0aaa dddd ssss tttt
	// Opcode rd, rs, rt		ADD, PADDSB, SUB, XOR, RED
	// Opcode rd, rs, imm		SLL, SRA, ROR
	
	// 100a tttt ssss oooo
	// Opcode rt, rs, offset	LW, SW
	
	// 101a dddd uuuu uuuu		LLB, LHB
	
	// B ccc, Label				B, BR
	// Opcode ccci iiii iiii
	
	// PCS rd					PCS
	// Opcode dddd xxxx xxxx
	
	// Opcode xxxx xxxx xxxx	HLT
	
	wire [15:0] prog_ctr;
	wire [15:0] instr;
	
	// inputs
	wire [3:0] opcode;
	wire [3:0] rs, rt, rd;
	wire [7:0] imm_8_bit;
	wire [8:0] imm_9_bit;
	
	// control signals
	wire memw, memr, memtoreg, alusrc, aluop, pcsrc, regw;
	
	//assign prog_ctr here...
	
	// Fetch instruction from instruction mem
	memory ins_mem(.data_out(instr), .data_in(16'b0), .addr(prog_ctr), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(1'b0));
	
	// assign imputs
	assign opcode = instr[15:12];
	assign rd = instr[11:8];
	assign rs = instr[7:4];
	assign rt = (opcode[3:1] == 3'b100) ? instr[11:8] : instr[3:0];				// used for immediate for SLL, SRA, ROR
	assign imm_8_bit = instr[7:0];
	assign imm_9_bit = instr[8:0];
	
	// assign control signals
	assign memw = (opcode == 4'b1001);
	assign memr = ((opcode == 4'b1000) | (opcode == 4'b1010) | (opcode == 4'b1011));
	assign memtoreg = ((opcode == 4'b1000) | (opcode == 4'b1010) | (opcode == 4'b1011));
	// alusrc to be determined
	// aluop to be determined
	// pc src determined by branch control
	assign regw = (opcode[3] == 1'b0) | (opcode == 4'b1000) | (opcode == 4'b1010) | (opcode == 4'b1011);
	
	// Fetch from registers
	// check RST signal...
	RegisterFile rf (.clk(clk), .rst(1'b0), .SrcReg1(rs), .SrcReg2(rt), .input(rd), .SrcData1(), .SRCData2());
endmodule