module cpu(clk, rst_n, hlt, pc_out);
	input clk, rst_n;
	output hlt;
	output [15:0] pc_out;
	wire [15:0] instr;
	
	// inputs
	wire [3:0] opcode;
	wire [3:0] rs, rt, rd;
	wire [7:0] imm_8_bit;
	wire [8:0] imm_9_bit;
        wire [15:0] rs_reg, rt_reg, pc_next, pc_inc;
	
	// control signals
	wire memw, memr, memtoreg, alusrc, aluop, pcsrc, regw, br;
	
	// wires
	wire [15:0] lw_sw_offset;
	wire [2:0] fl;
	wire [15:0] dst_data, lb_data, lw_data, alu_data;
	wire [15:0] pc_output;
	wire [15:0] alu_in1, alu_in2;

	wire [2:0] C, F;
	assign C = instr[11:9];	
	assign pc_out = pc_output;
	//assign pc_ctr here... including branch conditions
	Register pc_register(.clk(clk), .rst(!rst_n), .D(pc_next), .WriteReg(1'b1), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(pc_output), .Bitline2());
	
	pcc control(.clk(clk), .rst_n(rst_n), .fl(fl), .instr(instr), .rs_reg(rs_reg), .pc_output(pc_output), .pc_next(pc_next), .pc_inc(pc_inc), .hlt(hlt));

	// Fetch instruction from instruction mem
	memory1c ins_mem(.data_out(instr), .data_in(16'h0000), .addr(pc_output), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(!rst_n));
	
	// assign inputs
	assign opcode = instr[15:12];
	assign rd = instr[11:8];
	assign rs = instr[7:4];
	assign rt = (opcode[3:1] == 3'b100) ? instr[11:8] : instr[3:0];		// used for immediate for SLL, SRA, ROR
	assign imm_8_bit = instr[7:0];
	assign imm_9_bit = instr[8:0];

	// assign control signals
	assign memw = (opcode == 4'b1001);
	assign memr = (opcode[3:1] == 3'b100);
	assign memtoreg = ((opcode == 4'b1000) | (opcode == 4'b1010) | (opcode == 4'b1011));
	// alusrc to be determined
	// aluop to be determined
	// pc src determined by branch control
	assign regw = (opcode[3] == 1'b0) | (opcode == 4'b1000) | (opcode[3:1] == 3'b101) | (opcode == 4'b1110);
	
	assign dst_data = (!opcode[3]) ? alu_data : (opcode[3:1] == 3'b101) ? lb_data : (opcode[3:0] == 4'b1110) ? pc_inc : lw_data;
	assign lb_data = (opcode[0]) ? {imm_8_bit, rs_reg[7:0]} : {rs_reg[15:8], imm_8_bit};
	
	assign alu_in1 = (opcode[3:1] == 3'b100) ? {rs_reg[15:1], 1'b0} : rs_reg;
	assign alu_in2 = (opcode[3:1] == 3'b100) ? {{ {11{instr[3]}}, instr[3:0]}, 1'b0} : ((opcode[3:2] == 2'b01) && (opcode[1:0] != 2'b11)) ? {12'h000, instr[3:0]} : rt_reg;
	
	ALU alu(.Opcode(opcode), .in1(alu_in1), .in2(alu_in2), .out(alu_data), .flags(fl));
	
	// Fetch from registers
	// check RST signal...
	wire [3:0] rs_lb;
	assign rs_lb = (opcode[3:1] == 3'b101) ? rd : rs;
	RegisterFile rf (.clk(clk), .rst(!rst_n), .SrcReg1(rs_lb), .SrcReg2(rt), .DstReg(rd), .WriteReg(regw), .DstData(dst_data), .SrcData1(rs_reg), .SrcData2(rt_reg));

	// main filespace
	memory1c usr_data(.data_out(lw_data), .data_in(rt_reg), .addr(alu_data), .enable(memr), .wr(memw), .clk(clk), .rst(!rst_n));
	
	endmodule