// Gokul's D-flipflop

module MEMWB_ff (q_RegWrite, d_RegWrite, q_MemtoReg, d_MemtoReg,
				q_RegRd, d_RegRd, q_RegRs, d_RegRs, q_RegRt, d_RegRt,
				q_RegRsVal, d_RegRsVal, q_RegRtVal, d_RegRtVal,
				q_alu_data, d_alu_data, q_imm8, d_imm8, q_Opcode, d_Opcode, q_pc_inc, d_pc_inc,
				q_lw_data, d_lw_data, q_halt, d_halt,
				wen, clk, rst);

    //output         q; //DFF output
    //input          d; //DFF input
    input			wen; //Write Enable - I can't think of a good reason to use this here
    input          	clk; //Clock
    input          	rst; //Reset (used synchronously)

    reg s_RegWrite, s_MemtoReg;
	reg s_halt;
    reg [3:0] s_RegRd, s_RegRs, s_RegRt;
	reg [3:0] s_Opcode;
	reg [15:0] s_RegRsVal, s_RegRtVal;
	reg [15:0] s_alu_data, s_lw_data, s_pc_inc;
    reg [7:0] s_imm8;

    //// IO signals ////
	
    // control signals for write back stage //
    input d_RegWrite;		output q_RegWrite;
    input d_MemtoReg;		output q_MemtoReg;

    // register signals //
    input [3:0] d_RegRd;			output [3:0] q_RegRd;
    input [3:0] d_RegRs;			output [3:0] q_RegRs;
    input [3:0] d_RegRt;			output [3:0] q_RegRt;
	input [15:0] d_RegRsVal;		output [15:0] q_RegRsVal;
	input [15:0] d_RegRtVal;		output [15:0] q_RegRtVal;

	input d_halt;					output q_halt;
	input [3:0] d_Opcode;			output [3:0] q_Opcode;
	input [15:0] d_alu_data;		output [15:0] q_alu_data;
	input [15:0] d_pc_inc;			output [15:0] q_pc_inc;
	input [15:0] d_lw_data;			output [15:0] q_lw_data;
    input [7:0] d_imm8;				output [7:0] q_imm8;

    // Set new state //
    assign q_RegWrite = s_RegWrite;
    assign q_MemtoReg = s_MemtoReg;

    assign q_RegRd = s_RegRd;
    assign q_RegRs = s_RegRs;
    assign q_RegRt = s_RegRt;
	assign q_RegRsVal = s_RegRsVal;
	assign q_RegRtVal = s_RegRtVal;
	
	assign q_halt = s_halt;
	assign q_Opcode = s_Opcode;
	assign q_alu_data = s_alu_data;
	assign q_pc_inc = s_pc_inc;
	assign q_lw_data = s_lw_data;
	assign q_imm8 = s_imm8;

    always @(posedge clk) begin
	  s_RegWrite <= rst ? 0 : (wen ? d_RegWrite : s_RegWrite);
	  s_MemtoReg <= rst ? 0 : (wen ? d_MemtoReg : s_MemtoReg);
	  
	  s_RegRd <= rst ? 0 : (wen ? d_RegRd : s_RegRd);
	  s_RegRs <= rst ? 0 : (wen ? d_RegRs : s_RegRs);
	  s_RegRt <= rst ? 0 : (wen ? d_RegRt : s_RegRt);
	  s_RegRsVal <= rst ? 0 : (wen ? d_RegRsVal : s_RegRsVal);
	  s_RegRtVal <= rst ? 0 : (wen ? d_RegRtVal : s_RegRtVal);
	  
	  s_halt <= rst ? 0 : (wen ? d_halt : s_halt);
	  s_Opcode <= rst ? 4'b0100 : (wen ? d_Opcode : s_Opcode);
	  s_alu_data <= rst ? 0 : (wen ? d_alu_data : s_alu_data);
	  s_pc_inc <= rst ? 0 : (wen ? d_pc_inc : s_pc_inc);
	  s_lw_data <= rst ? 0 : (wen ? d_lw_data : s_lw_data);
	  s_imm8 <= rst ? 0 : (wen ? d_imm8 : s_imm8);
    end

endmodule
