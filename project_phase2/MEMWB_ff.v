// Gokul's D-flipflop

module MEMWB_ff (q, d, wen, clk, rst);

    output         q; //DFF output
    input          d; //DFF input
    input 	   wen; //Write Enable - I can't think of a good reason to use this here
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    reg            state;

    // inputs for mem and registers //
    input d_MemRead;
    input d_MemWrite;

    input d_RegisterRd;
    input d_RegisterRs;
    input d_RegisterRt;   

    input d_RegWrite;

    input d_Branch; // May not need this for all stuff
    input [31:0] d_SignExtend;

    // outputs for mem and registers //
    output q_MemRead;
    output q_MemWrite;

    output q_RegisterRd;
    output q_RegisterRs;
    output q_RegisterRt;   

    output q_RegWrite;

    output q_Branch; // May not need this for all stuff
    output [31:0] q_SignExtend;

    assign q = state;

    always @(posedge clk) begin
      state = rst ? 0 : (wen ? d : state);
    end

endmodule