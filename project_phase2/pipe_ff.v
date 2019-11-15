// Gokul's D-flipflop

module pipe_ff (q, d, wen, clk, rst);

    output         q; //DFF output
    input          d; //DFF input
    input 	   wen; //Write Enable - I can't think of a good reason to use this here
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    reg            state;

    // wires needed //
    /*input d_MemRead;
    input d_MemWrite;

    input d_RegisterRd;
    input d_RegisterRs;
    input d_RegisterRt;   

    input d_RegWrite;

    input d_Branch; // May not need this for all stuff
    input [31:0] d_SignExtend;
*/

    assign q = state;

    always @(posedge clk) begin
      state = rst ? 0 : (wen ? d : state);
    end

endmodule
