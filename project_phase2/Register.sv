module RegisterFile(input clk, input rst, input[3:0] SrcReg1, input[3:0] SrcReg2, input[3:0] 
DstReg, input WriteReg, input[15:0] DstData, inout[15:0] SrcData1, inout[15:0] SrcData2);

wire [15:0] read_en1, read_en2, Write_en;

ReadDecoder_4_16 rd1(.RegId(SrcReg1), .Wordline(read_en1));
ReadDecoder_4_16 rd2(.RegId(SrcReg2), .Wordline(read_en2));

WriteDecoder_4_16 we(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(Write_en));

Register rf[15:0] (.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en),
 .ReadEnable1(read_en1), .ReadEnable2(read_en2), .Bitline1(SrcData1), .Bitline2(SrcData2));

endmodule



module Register(input clk, input rst, input [15:0] D, input WriteReg, input ReadEnable1,
 input ReadEnable2, inout[15:0] Bitline1, inout[15:0] Bitline2);

BitCell bc[15:0](.clk(clk), .rst(rst), .D(D), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1), .Bitline2(Bitline2));

endmodule


module BitCell(input clk, input rst, input D, input WriteReg, input ReadEnable1, 
input ReadEnable2, inout Bitline1, inout Bitline2);

wire q;

dff flop(.q(q), .d(D), .wen(WriteReg), .clk(clk), .rst(rst));

assign Bitline1 = ReadEnable1 ? q : 1'bz;
assign Bitline2 = ReadEnable2 ? q : 1'bz;

endmodule

module WriteDecoder_4_16(input[3:0] RegId, input WriteReg, output[15:0] Wordline);

assign Wordline = (!WriteReg) ? 16'h0000 :
		(RegId == 4'h0) ? 16'h0001 :
		(RegId == 4'h1) ? 16'h0002 :
		(RegId == 4'h2) ? 16'h0004 :
		(RegId == 4'h3) ? 16'h0008 :
		(RegId == 4'h4) ? 16'h0010 :
		(RegId == 4'h5) ? 16'h0020 :
		(RegId == 4'h6) ? 16'h0040 :
		(RegId == 4'h7) ? 16'h0080 :
		(RegId == 4'h8) ? 16'h0100 :
		(RegId == 4'h9) ? 16'h0200 :
		(RegId == 4'ha) ? 16'h0400 :
		(RegId == 4'hb) ? 16'h0800 :
		(RegId == 4'hc) ? 16'h1000 :
		(RegId == 4'hd) ? 16'h2000 :
		(RegId == 4'he) ? 16'h4000 : 16'h8000;

endmodule


module ReadDecoder_4_16(input[3:0] RegId, output[15:0] Wordline);

assign Wordline =
		(RegId == 4'h0) ? 16'h0001 :
		(RegId == 4'h1) ? 16'h0002 :
		(RegId == 4'h2) ? 16'h0004 :
		(RegId == 4'h3) ? 16'h0008 :
		(RegId == 4'h4) ? 16'h0010 :
		(RegId == 4'h5) ? 16'h0020 :
		(RegId == 4'h6) ? 16'h0040 :
		(RegId == 4'h7) ? 16'h0080 :
		(RegId == 4'h8) ? 16'h0100 :
		(RegId == 4'h9) ? 16'h0200 :
		(RegId == 4'ha) ? 16'h0400 :
		(RegId == 4'hb) ? 16'h0800 :
		(RegId == 4'hc) ? 16'h1000 :
		(RegId == 4'hd) ? 16'h2000 :
		(RegId == 4'he) ? 16'h4000 : 16'h8000;

endmodule






