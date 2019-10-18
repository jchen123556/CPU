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
	wire [15:0] pc_ctr, pc_n, pc_br;
	wire [15:0] instr;
	
	// inputs
	wire [3:0] opcode;
	wire [3:0] rs, rt, rd;
	wire [7:0] imm_8_bit;
	wire [8:0] imm_9_bit;
        wire [15:0] rs_reg, rt_reg;
	
	// control signals
	wire memw, memr, memtoreg, alusrc, aluop, pcsrc, regw, br, hlt;
	
	//assign pc_ctr here... including branch conditions
	Register pc_register(.clk(clk), .rst(!rst_n), .D(pc_next), .WriteReg(1'b1), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(pc_ctr), .Bitline2());
	pc_next = (!rst_n) ? 0 : (hlt) ? pc_ctr : (br) ? pc_br : pc_inc;
	cla_16bit pc_inc(.Sum(pc_inc), .Ovfl(), .A(pc_ctr), .B(16'h0002), .Cin(1'b0));
        cla_16bti branch_sum(.Sum(pc_br), .Ovfl(), .A(pc_inc), .B({345{instr[8]}, int
	assign hlt = (opcode == h'hf);
	wire out, p1, p2, p3, p4, p5, p6, p7, p8;
	assign p1 = ((C == 3'b000) && (F[2] == 1'b0)) ? 1'b1 : 1'b0;
	assign p2 = ((C == 3'b001) && (F[2] == 1'b1)) ? 1'b1 : 1'b0;	
	assign p3 = ((C == 3'b010) && ({F[2], F[0]} == 2'b00)) ? 1'b1 : 1'b0; 
	assign p4 = ((C == 3'b011) && (F[0] == 1)) ? 1'b1 : 1'b0;
	assign p5 = ((C == 3'b100) && ((F[2] == 1'b1) || ({F[2], F[0]} == 2'b00))) ? 1'b1 : 1'b0; 
	assign p6 = ((C == 3'b101) && ((F[2] == 1'b1) || (F[0] == 1'b0))) ? 1'b1 : 1'b0;
	assign p7 = ((C == 3'b110) && (F[1] == 1'b1)) ? 1'b1 : 1'b0;
	assign p8 = (C == 3'b111) ? 1'b1 : 1'b0;
	assign br = p1 || p2 || p3 || p4 || p5 || p6 || p7 || p8;
	
	// Fetch instruction from instruction mem
	memory ins_mem(.data_out(instr), .data_in(16'h0000), .addr(pc_ctr), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(!rst_n));
	
	// assign inputs
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
	RegisterFile rf (.clk(clk), .rst(!rst_n), .SrcReg1(rs), .SrcReg2(rt), .DstReg(rd), .WriteReg(regw), .DstData(/*cal value*/), .SrcData1(rs_reg), .SRCData2(rt_reg));
        cla_16bit lw_sw_adder(.Sum(lw_sw_offset), .Ovfl(), .A({{11{instr[3]}}, instr[3:0], 1'b0}), .B({rs_reg[15:1], 1'b0}), .Cin(1'b0));

	// main filespace
	memory usr_data(.data_out(rt_reg), .data_in(rt_reg), .addr(lw_sw_offset), .enable(memr), .wr(memw), .clk(clk), .rst(!rst_n));
	
	endmodule
