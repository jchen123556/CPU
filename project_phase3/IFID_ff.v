// Gokul's D-flipflop

module IFID_ff (q_pc_inc, q_pc_out, q_instr, q_rs_reg, d_pc_inc, d_pc_out, d_instr, d_rs_reg, q_halt, d_halt, wen, clk, rst);

    //output         q; //DFF output
    //input          d; //DFF input
    input 		   wen; //Write Enable - I can't think of a good reason to use this here
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    // inputs //
    input [15:0] d_pc_inc;
	input [15:0] d_pc_out;
    input [15:0] d_instr;
	input [15:0] d_rs_reg;
	input d_halt;

    // outputs //
    output [15:0] q_pc_inc;
	output [15:0] q_pc_out;
    output [15:0] q_instr;
	output [15:0] q_rs_reg;
	output q_halt;

    reg [15:0] s_pc_inc;
	reg [15:0] s_pc_out;
    reg	[15:0] s_instr;
	reg [15:0] s_rs_reg;
	reg s_halt;

    assign q_pc_inc = s_pc_inc;
	assign q_pc_out = s_pc_out;
    assign q_instr = s_instr;
	assign q_rs_reg = s_rs_reg;
	assign q_halt = s_halt;

    always @(posedge clk) begin
      s_pc_inc <= rst ? 0 : (wen ? d_pc_inc : s_pc_inc);
	  s_pc_out <= rst ? 0 : (wen ? d_pc_out : s_pc_out);
      s_instr <= rst ? 16'h4000 : (wen ? d_instr : s_instr); 
	  s_rs_reg <= rst ? 0 : (wen ? d_rs_reg : s_rs_reg);
	  s_halt <= rst ? 0 : (wen ? d_halt : s_halt);
    end

endmodule