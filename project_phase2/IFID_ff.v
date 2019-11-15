// Gokul's D-flipflop

module IFID_ff (q_PC, q_instr, d_PC, d_instr, wen, clk, rst);

    //output         q; //DFF output
    //input          d; //DFF input
    input 	   wen; //Write Enable - I can't think of a good reason to use this here
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    // inputs //
    input d_PC;
    input d_instr;

    // outputs //
    output q_PC;
    output q_instr;

    reg            state_PC;
    reg		   state_instr;

    assign q_PC = state_PC;
    assign q_instr = state_instr;

    always @(posedge clk) begin
      state_PC = rst ? 0 : (wen ? d_PC : state_PC);
      state_instr = rst ? 0 : (wen ? d_instr : state_instr); 
    end

endmodule