module cpu(clk, rst_n, hlt, pc_out);
	input clk, rst_n;
	output hlt;
	output [15:0] pc_out;
	wire [15:0] pc_ctr, pc_inc, pc_br, pc_next;
	wire [15:0] instr;
	
	// inputs
	wire [3:0] opcode;
	wire [3:0] rs, rt, rd;
	wire [7:0] imm_8_bit;
	wire [8:0] imm_9_bit;
        wire [15:0] rs_reg, rt_reg;
	
	// control signals
	wire memw, memr, memtoreg, alusrc, aluop, pcsrc, regw, br;
	
	// wires
	wire [15:0] lw_sw_offset;
	wire [2:0] fl;
	wire z_en, v_en, n_en;
	wire [15:0] dst_data, lb_data, lw_data, alu_data;
	wire out, p1, p2, p3, p4, p5, p6, p7, p8;
	wire [15:0] reg_output;
	wire [15:0] alu_in1, alu_in2;



	wire [2:0] C, F;
	assign C = instr[11:9];	
	assign pc_out = reg_output;
	//assign pc_ctr here... including branch conditions
	Register pc_register(.clk(clk), .rst(!rst_n), .D(pc_next), .WriteReg(1'b1), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(reg_output), .Bitline2());
	assign pc_ctr = reg_output;

	assign pc_next = (hlt) ? pc_ctr : (br) ? pc_br : pc_inc;
	cla_16bit pc_step(.Sum(pc_inc), .Ovfl(), .A(pc_ctr), .B(16'h0002), .Cin(1'b0));
        cla_16bit branch_sum(.Sum(pc_br), .Ovfl(), .A(pc_inc), .B({{{6{instr[8]}}, instr[8:0]}, 1'b0}), .Cin(1'b0));
	assign hlt = (opcode == 4'hf);
	assign p1 = ((C == 3'b000) && (F[2] == 1'b0)) ? 1'b1 : 1'b0;
	assign p2 = ((C == 3'b001) && (F[2] == 1'b1)) ? 1'b1 : 1'b0;	
	assign p3 = ((C == 3'b010) && ({F[2], F[0]} == 2'b00)) ? 1'b1 : 1'b0; 
	assign p4 = ((C == 3'b011) && (F[0] == 1)) ? 1'b1 : 1'b0;
	assign p5 = ((C == 3'b100) && ((F[2] == 1'b1) || ({F[2], F[0]} == 2'b00))) ? 1'b1 : 1'b0; 
	assign p6 = ((C == 3'b101) && ((F[2] == 1'b1) || (F[0] == 1'b0))) ? 1'b1 : 1'b0;
	assign p7 = ((C == 3'b110) && (F[1] == 1'b1)) ? 1'b1 : 1'b0;
	assign p8 = (C == 3'b111) ? 1'b1 : 1'b0;
	assign br = (opcode[3:1] == 3'b110) && (p1 || p2 || p3 || p4 || p5 || p6 || p7 || p8 || (opcode[0] == 0));
	
	// Fetch instruction from instruction mem
	memory1c ins_mem(.data_out(instr), .data_in(16'h0000), .addr(reg_output), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(!rst_n));
	
	// assign inputs
	assign opcode = instr[15:12];
	assign rd = instr[11:8];
	assign rs = instr[7:4];
	assign rt = (opcode[3:1] == 3'b100) ? instr[11:8] : instr[3:0];		// used for immediate for SLL, SRA, ROR
	assign imm_8_bit = instr[7:0];
	assign imm_9_bit = instr[8:0];

	// assign control signals
	assign memw = (opcode == 4'b1001);
	assign memr = (opcode == 4'b1000);
	assign memtoreg = ((opcode == 4'b1000) | (opcode == 4'b1010) | (opcode == 4'b1011));
	// alusrc to be determined
	// aluop to be determined
	// pc src determined by branch control
	assign regw = (opcode[3] == 1'b0) | (opcode == 4'b1000) | (opcode[3:1] == 3'b101) | (opcode == 4'b1110);
	
	assign dst_data = (!opcode[3]) ? alu_data : (opcode[3:1] == 3'b101) ? lb_data : (opcode[3:0] == 4'b1110) ? pc_inc : lw_data;
	assign lb_data = (opcode[0]) ? {imm_8_bit, rs_reg[7:0]} : {rs_reg[15:8], imm_8_bit};
	
	assign z_en = (opcode[3:2] == 2'b00 && opcode[1:0]!=2'b00);
	assign v_en = (opcode[3:1] == 3'b000);
	assign n_en = (opcode[3:1] == 3'b000);

	assign alu_in1 = (opcode[3:1] == 3'b100) ? {rs_reg[15:1], 1'b0} : rs_reg;
	assign alu_in2 = (opcode[3:1] == 3'b100) ? {{ {11{instr[3]}}, instr[3:0]}, 1'b0} : ((opcode[3:2] == 2'b01) && (opcode[1:0] != 2'b11)) ? {12'h000, instr[3:0]} : rt_reg;
	
	ALU alu(.Opcode(opcode), .in1(alu_in1), .in2(alu_in2), .out(alu_data), .flags(fl));
	dff z(.d(fl[2]), .q(F[2]), .wen(z_en), .clk(clk), .rst(!rst_n));    // zvn
	dff v(.d(fl[1]), .q(F[1]), .wen(v_en), .clk(clk), .rst(!rst_n));
	dff n(.d(fl[0]), .q(F[0]), .wen(n_en), .clk(clk), .rst(!rst_n));
	// Fetch from registers
	// check RST signal...
	wire [3:0] rs_lb;
	assign rs_lb = (opcode[3:1] == 3'b101) ? rd : rs;
	RegisterFile rf (.clk(clk), .rst(!rst_n), .SrcReg1(rs_lb), .SrcReg2(rt), .DstReg(rd), .WriteReg(regw), .DstData(dst_data), .SrcData1(rs_reg), .SrcData2(rt_reg));

	// main filespace
	memory1c usr_data(.data_out(lw_data), .data_in(rt_reg), .addr(alu_data), .enable(memr), .wr(memw), .clk(clk), .rst(!rst_n));
	
	endmodule
