module cpu(clk, rst_n, hlt, pc_out);
	input clk, rst_n;
	output hlt;
	output [15:0] pc_out;
	wire [15:0] instr;	
	wire stall;
	wire [1:0] ex_fwd1, ex_fwd2;
	wire mem_fwd1, mem_fwd2;
	wire [15:0] real_alu_input_0, real_alu_input_1;
	
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
	
	wire rst;
	assign rst = !rst_n;
    wire halt;





    //// Pipeline flop test ////
	wire IF_halt;
	wire [15:0] IF_pc_inc, IF_pc_out, IF_instr, IF_rs_reg;
	wire [15:0] ID_pc_inc, ID_pc_out, ID_instr;
	
	wire ID_RegDst, ID_ALUOp1, ID_ALUOp0, ID_ALUSrc, ID_halt;
	wire ID_Branch, ID_MemRead, ID_MemWrite;
	wire ID_RegWrite, ID_MemtoReg;
	wire [3:0] ID_RegRd, ID_RegRs, ID_RegRt, ID_Opcode;
	wire [15:0] ID_RegRsVal, ID_RegRtVal;
	wire [7:0] ID_imm8;
	
	wire EX_RegDst, EX_ALUOp1, EX_ALUOp0, EX_ALUSrc, EX_halt;
	wire EX_Branch, EX_MemRead, EX_MemWrite;
	wire EX_RegWrite, EX_MemtoReg;
	wire [3:0] EX_RegRd, EX_RegRs, EX_RegRt, EX_Opcode;
	wire [15:0] EX_instr, EX_alu_data, EX_RegRsVal, EX_RegRtVal;
	wire [15:0] EX_pc_inc;
	wire [7:0] EX_imm8;
	
	wire MEM_Branch, MEM_MemRead, MEM_MemWrite, MEM_halt;
	wire MEM_RegWrite, MEM_MemtoReg;
	wire [3:0] MEM_RegRd, MEM_RegRs, MEM_RegRt, MEM_Opcode;
	wire [15:0] MEM_RegRsVal, MEM_RegRtVal;
	wire [15:0] MEM_alu_data, MEM_lw_data, MEM_pc_inc;
	wire [7:0] MEM_imm8;
	
	wire WB_RegWrite, WB_MemtoReg, WB_halt;
	wire [3:0] WB_RegRd, WB_RegRs, WB_RegRt, WB_Opcode;
	wire [15:0] WB_RegRsVal, WB_RegRtVal;
	wire [15:0] WB_alu_data, WB_lw_data, WB_pc_inc;
	wire [7:0] WB_imm8;
	
    IFID_ff ff_ifid(.d_pc_inc(IF_pc_inc), .d_pc_out(IF_pc_out), .d_instr(IF_instr), .d_rs_reg(), 
					.q_pc_inc(ID_pc_inc), .q_pc_out(ID_pc_out), .q_instr(ID_instr), .q_rs_reg(), 
					.q_halt(ID_halt), .d_halt(IF_halt),
					.wen(!stall), .clk(clk), .rst(rst | ID_Branch));
	
	IDEX_ff ff_idex(.d_RegDst(ID_RegDst), .d_ALUOp1(ID_ALUOp1), .d_ALUOp0(ID_ALUOp0), .d_ALUSrc(ID_ALUSrc),
				    .q_RegDst(EX_RegDst), .q_ALUOp1(EX_ALUOp1), .q_ALUOp0(EX_ALUOp0), .q_ALUSrc(EX_ALUSrc),
					.d_Branch(ID_Branch), .d_MemRead(ID_MemRead), .d_MemWrite(ID_MemWrite),
					.q_Branch(EX_Branch), .q_MemRead(EX_MemRead), .q_MemWrite(EX_MemWrite),
					.d_RegWrite(ID_RegWrite), .d_MemtoReg(ID_MemtoReg),
					.q_RegWrite(EX_RegWrite), .q_MemtoReg(EX_MemtoReg), 
					.d_RegRd(ID_RegRd), .d_RegRs(ID_RegRs), .d_RegRt(ID_RegRt),
					.q_RegRd(EX_RegRd), .q_RegRs(EX_RegRs), .q_RegRt(EX_RegRt),
					.d_RegRsVal(ID_RegRsVal), .d_RegRtVal(ID_RegRtVal),
					.q_RegRsVal(EX_RegRsVal), .q_RegRtVal(EX_RegRtVal),
					.d_pc_inc(ID_pc_inc), .d_halt(ID_halt),
					.q_pc_inc(EX_pc_inc), .q_halt(EX_halt),
					.d_imm8(ID_imm8), .d_instr(ID_instr), .d_Opcode(ID_Opcode),
					.q_imm8(EX_imm8), .q_instr(EX_instr), .q_Opcode(EX_Opcode),
					.wen(1'b1), .clk(clk), .rst(rst));
				
	EXMEM_ff ff_exmem(.d_Branch(EX_Branch), .d_MemRead(EX_MemRead), .d_MemWrite(EX_MemWrite),
				      .q_Branch(MEM_Branch), .q_MemRead(MEM_MemRead), .q_MemWrite(MEM_MemWrite),
					  .d_RegWrite(EX_RegWrite), .d_MemtoReg(EX_MemtoReg),
					  .q_RegWrite(MEM_RegWrite), .q_MemtoReg(MEM_MemtoReg), 
					  .d_RegRd(EX_RegRd), .d_RegRs(EX_RegRs), .d_RegRt(EX_RegRt),
					  .q_RegRd(MEM_RegRd), .q_RegRs(MEM_RegRs), .q_RegRt(MEM_RegRt),
					  .d_RegRsVal(EX_RegRsVal), .d_RegRtVal(EX_RegRtVal),
					  .q_RegRsVal(MEM_RegRsVal), .q_RegRtVal(MEM_RegRtVal),
					  .d_pc_inc(EX_pc_inc), .d_halt(EX_halt),
					  .q_pc_inc(MEM_pc_inc), .q_halt(MEM_halt),
					  .d_imm8(EX_imm8), .d_alu_data(EX_alu_data), .d_Opcode(EX_Opcode),
					  .q_imm8(MEM_imm8), .q_alu_data(MEM_alu_data), .q_Opcode(MEM_Opcode),
					  .wen(1'b1), .clk(clk), .rst(rst));
				
	MEMWB_ff ff_memwb(.d_RegWrite(MEM_RegWrite), .d_MemtoReg(MEM_MemtoReg),
				      .q_RegWrite(WB_RegWrite), .q_MemtoReg(WB_MemtoReg), 
					  .d_RegRd(MEM_RegRd), .d_RegRs(MEM_RegRs), .d_RegRt(MEM_RegRt),
					  .q_RegRd(WB_RegRd), .q_RegRs(WB_RegRs), .q_RegRt(WB_RegRt),
					  .d_RegRsVal(MEM_RegRsVal), .d_RegRtVal(MEM_RegRtVal),
					  .q_RegRsVal(WB_RegRsVal), .q_RegRtVal(WB_RegRtVal),
					  .d_pc_inc(MEM_pc_inc), .d_halt(MEM_halt),
					  .q_pc_inc(WB_pc_inc), .q_halt(WB_halt),
					  .d_imm8(MEM_imm8), .d_alu_data(MEM_alu_data), .d_Opcode(MEM_Opcode),
					  .q_imm8(WB_imm8), .q_alu_data(WB_alu_data), .q_Opcode(WB_Opcode),
					  .d_lw_data(MEM_lw_data),
					  .q_lw_data(WB_lw_data),
					  .wen(1'b1), .clk(clk), .rst(rst));

    assign IF_instr = instr;
	assign IF_pc_inc = pc_inc;	// TODO: make sure this is correct
	assign IF_pc_out = pc_out;
	
	assign ID_MemRead = memr;
	assign ID_MemWrite = (stall) ? 0 : memw;
	assign ID_MemtoReg = memtoreg;
	assign ID_RegWrite = (stall) ? 0 : regw;
	
	assign ID_ALUOp0 = alu_in1; // not right, check rs_reg to see what it does
	assign ID_ALUOp1 = alu_in2; // not right, check rs_reg to see what it does
	assign ID_RegRd = rd;
	assign ID_RegRs = rs; // TODO: double check that this is correct and not rs_lb
	assign ID_RegRt = rt;
	assign ID_RegRsVal = rs_reg;
	assign ID_RegRtVal = rt_reg;
	assign ID_Opcode = opcode;
	assign ID_imm8 = imm_8_bit;

	assign EX_alu_data = alu_data;	
	assign MEM_lw_data = lw_data;

	
	


	// Fetch stage ?
	wire pc_mux;
	assign pc_mux = (ID_Branch) ? pc_next : IF_pc_inc;
	
	//assign pc_ctr here... including branch conditions
	Register pc_register(.clk(clk), .rst(!rst_n), .D(pc_next), .WriteReg(((!stall)&&(ID_Branch||!IF_halt))), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(pc_output), .Bitline2());
	
	// IF Stage //
	cla_16bit pc_step(.Sum(pc_inc), .Ovfl(), .A(pc_output), .B(16'h0002), .Cin(1'b0));
	assign IF_halt = (!ID_Branch) & (IF_instr[15:12] == 4'hf);
	
	// WB Stage // 
	assign hlt = WB_halt;
	
	// ID Stage // 
	pcc control(.clk(clk), .rst_n(rst_n), .fl(fl), .instr(ID_instr), .rs_reg(rs_reg), .pc_output(ID_pc_out), .pc_next(pc_next), .pc_inc(ID_pc_inc), .branch(ID_Branch)); // TODO extract code to split stages

	// IF Stage //
	// Fetch instruction from instruction mem
	memory1c ins_mem(.data_out(instr), .data_in(16'h0000), .addr(pc_output), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(!rst_n));
	
	// ID Stage //
	// assign inputs
	assign opcode = ID_instr[15:12];
	assign rd = ID_instr[11:8];
	assign rs = ID_instr[7:4];
	assign rt = (opcode[3:1] == 3'b100) ? ID_instr[11:8] : ID_instr[3:0];		// used for immediate for SLL, SRA, ROR
	assign imm_8_bit = ID_instr[7:0];
	assign imm_9_bit = ID_instr[8:0]; // not used

    // ID Stage //
	// assign control signals
	//assign ID_halt_real = (ID_Branch) ? 1'b0 : ID_halt;
	assign memw = (opcode == 4'b1001);
	assign memr = (opcode[3:1] == 3'b100);
	assign memtoreg = ((opcode == 4'b1000) | (opcode == 4'b1010) | (opcode == 4'b1011));
	// alusrc to be determined
	// aluop to be determined
	// pc src determined by branch control
	assign regw = (opcode[3] == 1'b0) | (opcode == 4'b1000) | (opcode[3:1] == 3'b101) | (opcode == 4'b1110);
	
	// ID Stage //
	hazard haz(.IDEX_mr(EX_MemRead), .IFID_br(ID_Branch), .IDEX_rd(EX_RegRd), .IFID_rt(ID_RegRt), .IFID_rs(ID_RegRs),
	.EXMEM_mr(MEM_MemRead), .EXMEM_rd(MEM_RegRd), .IDEX_rw(EX_RegWrite), .stall(stall));	
	
	// WB stage maybe?
	
	assign dst_data = (!WB_Opcode[3]) ? WB_alu_data : (WB_Opcode[3:1] == 3'b101) ? lb_data : (WB_Opcode[3:0] == 4'b1110) ? WB_pc_inc : WB_lw_data; // TODO: what are these variables
	
	// WB actually?
	assign lb_data = (WB_Opcode[0]) ? {WB_imm8, WB_RegRsVal[7:0]} : {WB_RegRsVal[15:8], WB_imm8};  // TODO: pipeline these immediates
	
	// ID stage stuff
	
	assign alu_in1 = (opcode[3:1] == 3'b100) ? {rs_reg[15:1], 1'b0} : rs_reg;
	assign alu_in2 = (opcode[3:1] == 3'b100) ? {{ {11{ID_instr[3]}}, ID_instr[3:0]}, 1'b0} : 
			((opcode[3:2] == 2'b01) && (opcode[1:0] != 2'b11)) ? {12'h000, ID_instr[3:0]} : rt_reg;
	
	// EX stage
	ALU alu(.Opcode(EX_Opcode), .in1(real_alu_input_0), .in2(real_alu_input_1), .out(alu_data), .flags(fl)); // TODO: pipeline flags
	
	ForwardingUnit forward(.IDEX_rs(EX_RegRs), .IDEX_rt(EX_RegRt), .EXMEM_rd(MEM_RegRd), .EXMEM_rw(MEM_RegWrite), 
	.MEMWB_rw(WB_RegWrite), .MEMWB_rt(WB_RegRt), .MEMWB_rd(WB_RegRd), .EXMEM_rs(MEM_RegRs), .EXMEM_rt(MEM_RegRt), .EXMEM_mr(MEM_MemRead), .EXMEM_mw(MEM_MemWrite),
	.ex_fwd1(ex_fwd1), .ex_fwd2(ex_fwd2), .mem_fwd1(mem_fwd1), .mem_fwd2(mem_fwd2));
	
	// EX forwarding muxes //
	assign real_alu_input_0 = (ex_fwd1 == 2'b10) ? MEM_alu_data : (ex_fwd1 == 2'b01) ? dst_data : EX_ALUOp0;
	assign real_alu_input_1 = (ex_fwd2 == 2'b10) ? MEM_alu_data : (ex_fwd2 == 2'b01) ? dst_data : EX_ALUOp1;
	
	// MEM forwarding muxes //
	wire [15:0] real_mem_input_0, real_mem_input_1;
	wire [15:0] ext_forwarding_addr;
	cla_16bit imm_add(.Sum(ext_forwarding_addr), .Ovfl(), .A(WB_lw_data), .B({{8{MEM_imm8[7]}}, MEM_imm8}), .Cin(1'b0));
	
	assign real_mem_input_0 = (mem_fwd1 == 1'b0) ? MEM_alu_data : ext_forwarding_addr;
	assign real_mem_input_1 = (mem_fwd2 == 1'b0) ? MEM_RegRtVal : WB_lw_data;
	
	// Register file deals with stuff in the ID and WB stages
	
	// Fetch from registers
	// check RST signal...
	wire [3:0] rs_lb;
	assign rs_lb = (opcode[3:1] == 3'b101) ? rd : rs;
	RegisterFile rf (.clk(clk), .rst(!rst_n), .SrcReg1(rs_lb), .SrcReg2(rt), .DstReg(WB_RegRd), .WriteReg(regw), .DstData(dst_data), .SrcData1(rs_reg), .SrcData2(rt_reg));

    // MEM stage //

	// main filespace
	memory1c usr_data(.data_out(lw_data), .data_in(real_mem_input_1), .addr(real_mem_input_0), .enable(MEM_MemRead), .wr(MEM_MemWrite), .clk(clk), .rst(!rst_n)); // TODO: pipeline data
	
	endmodule
