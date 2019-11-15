// Gokul's D-flipflop

module IFID_ff (q_PC_inc, q_instr, q_rs_reg, d_PC_inc, d_instr, d_rs_reg, wen, clk, rst);

    //output         q; //DFF output
    //input          d; //DFF input
    input 		   wen; //Write Enable - I can't think of a good reason to use this here
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    // inputs //
    input [15:0] d_PC_inc;
    input [15:0] d_instr;
	input [15:0] d_rs_reg;

    // outputs //
    output [15:0] q_PC_inc;
    output [15:0] q_instr;
	output [15:0] q_rs_reg;

    reg [15:0] s_PC_inc;
    reg	[15:0] s_instr;
	reg [15:0] s_rs_reg;

    assign q_PC_inc = s_PC_inc;
    assign q_instr = s_instr;
	assign q_rs_reg = s_rs_reg;

    always @(posedge clk) begin
      s_PC_inc <= rst ? 0 : (wen ? d_PC_inc : s_PC_inc);
      s_instr <= rst ? 0 : (wen ? d_instr : s_instr); 
	  s_rs_reg <= rst ? 0 : (wen ? d_rs_reg : s_rs_reg);
    end

endmodule