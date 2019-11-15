// Gokul's D-flipflop

module pipe_ff (q, d, wen, clk, rst);

    //output         q; //DFF output
    //input          d; //DFF input
    input 	   wen; //Write Enable - I can't think of a good reason to use this here
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    reg s_RegDst, s_ALUOp1, s_ALUOp0, s_ALUSrc;
    reg s_Branch, s_MemRead, s_MemWrite;
    reg s_RegWrite, s_MemtoReg;
    reg s_RegRd, s_RegRs, s_RegRt;
    reg [31:0] s_SignExt;

    //// IO signals ////

    // control signals for execution stage //
    input d_RegDst;		output q_RegDst;
    input d_ALUOp1;		output q_ALUOp1;
    input d_ALUOp0;		output q_ALUOp0;
    input d_ALUSrc;		output q_ALUSrc;

    // control signals for memory stage
    input d_Branch;		output q_Branch;
    input d_MemRead;		output q_MemRead;
    input d_MemWrite;		output q_MemWrite;

    // control signals for write back stage //
    input d_RegWrite;		output q_RegWrite;
    input d_MemtoReg;		output q_MemtoReg;

    // register signals //
    input d_RegRd;		output q_RegRd;
    input d_RegRs;		output q_RegRs;
    input d_RegRt;		output q_RegRt;

    input [31:0] d_SignExt;	output [31:0] q_SignExt;

    // Set new state //
    assign q_RegDst = s_RegDst;
    assign q_ALUOp1 = s_ALUOp1;
    assign q_ALUOp0 = s_ALUOp0;
    assign q_ALUSrc = s_ALUSrc;

    assign q_Branch = s_Branch;
    assign q_MemRead = s_MemRead;
    assign q_MemWrite = s_MemWrite;

    assign q_RegWrite = s_RegWrite;
    assign q_MemtoReg = s_MemtoReg;

    assign q_RegRd = s_RegRd;
    assign q_RegRs = s_RegRs;
    assign q_RegRt = s_RegRt;

    always @(posedge clk) begin
      state = rst ? 0 : (wen ? d : state);
    end

endmodule
