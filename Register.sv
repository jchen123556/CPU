module RegisterFile(input clk, input rst, input[3:0] SrcReg1, input[3:0] SrcReg2, input[3:0] 
DstReg, input WriteReg, input[15:0] DstData, inout[15:0] SrcData1, inout[15:0] SrcData2);

wire [15:0] read_en1, read_en2, Write_en;

ReadDecoder_4_16 rd1(.RegId(SrcReg1), .Wordline(read_en1));
ReadDecoder_4_16 rd2(.RegId(SrcReg2), .Wordline(read_en2));

WriteDecoder_4_16 we(.RegId(SrcReg1), .WriteReg(WriteReg), .Wordline(Write_en));

Register r0(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[0]),
 .ReadEnable1(read_en1[0]), .ReadEnable2(read_en2[0]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r1(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[1]),
 .ReadEnable1(read_en1[1]), .ReadEnable2(read_en2[1]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r2(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[2]),
 .ReadEnable1(read_en1[2]), .ReadEnable2(read_en2[2]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r3(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[3]),
 .ReadEnable1(read_en1[3]), .ReadEnable2(read_en2[3]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r4(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[4]),
 .ReadEnable1(read_en1[4]), .ReadEnable2(read_en2[4]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r5(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[5]),
 .ReadEnable1(read_en1[5]), .ReadEnable2(read_en2[5]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r6(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[6]),
 .ReadEnable1(read_en1[6]), .ReadEnable2(read_en2[6]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r7(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[7]),
 .ReadEnable1(read_en1[7]), .ReadEnable2(read_en2[7]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r8(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[8]),
 .ReadEnable1(read_en1[8]), .ReadEnable2(read_en2[8]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r9(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[9]),
 .ReadEnable1(read_en1[9]), .ReadEnable2(read_en2[9]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r10(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[10]),
 .ReadEnable1(read_en1[10]), .ReadEnable2(read_en2[10]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r11(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[11]),
 .ReadEnable1(read_en1[11]), .ReadEnable2(read_en2[11]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r12(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[12]),
 .ReadEnable1(read_en1[12]), .ReadEnable2(read_en2[12]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r13(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[13]),
 .ReadEnable1(read_en1[13]), .ReadEnable2(read_en2[13]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r14(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[14]),
 .ReadEnable1(read_en1[14]), .ReadEnable2(read_en2[14]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register r15(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_en[15]),
 .ReadEnable1(read_en1[15]), .ReadEnable2(read_en2[15]), .Bitline1(SrcData1), .Bitline2(SrcData2));

endmodule



module Register(input clk, input rst, input [15:0] D, input WriteReg, input ReadEnable1,
 input ReadEnable2, inout[15:0] Bitline1, inout[15:0] Bitline2);

BitCell bc0(.clk(clk), .rst(rst), .D(D[0]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[0]), .Bitline2(Bitline2[0]));
BitCell bc1(.clk(clk), .rst(rst), .D(D[1]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[1]), .Bitline2(Bitline2[1]));
BitCell bc2(.clk(clk), .rst(rst), .D(D[2]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[2]), .Bitline2(Bitline2[2]));
BitCell bc3(.clk(clk), .rst(rst), .D(D[3]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[3]), .Bitline2(Bitline2[3]));
BitCell bc4(.clk(clk), .rst(rst), .D(D[4]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[4]), .Bitline2(Bitline2[4]));
BitCell bc5(.clk(clk), .rst(rst), .D(D[5]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[5]), .Bitline2(Bitline2[5]));
BitCell bc6(.clk(clk), .rst(rst), .D(D[6]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[6]), .Bitline2(Bitline2[6]));
BitCell bc7(.clk(clk), .rst(rst), .D(D[7]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[7]), .Bitline2(Bitline2[7]));
BitCell bc8(.clk(clk), .rst(rst), .D(D[8]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[8]), .Bitline2(Bitline2[8]));
BitCell bc9(.clk(clk), .rst(rst), .D(D[9]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[9]), .Bitline2(Bitline2[9]));
BitCell bc10(.clk(clk), .rst(rst), .D(D[10]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[10]), .Bitline2(Bitline2[10]));
BitCell bc11(.clk(clk), .rst(rst), .D(D[11]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[11]), .Bitline2(Bitline2[11]));
BitCell bc12(.clk(clk), .rst(rst), .D(D[12]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[12]), .Bitline2(Bitline2[12]));
BitCell bc13(.clk(clk), .rst(rst), .D(D[13]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[13]), .Bitline2(Bitline2[13]));
BitCell bc14(.clk(clk), .rst(rst), .D(D[14]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[14]), .Bitline2(Bitline2[14]));
BitCell bc15(.clk(clk), .rst(rst), .D(D[15]), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
 .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[15]), .Bitline2(Bitline2[15]));

endmodule


module BitCell(input clk, input rst, input D, input WriteReg, input ReadEnable1, 
input ReadEnable2, inout Bitline1, inout Bitline2);

wire q;

dff flop(.q(q), .d(D), .wen(WriteReg), .clk(clk), .rst(rst));

assign Bitline1 = ReadEnable1 ? (WriteReg ? D : q) : 1'bz;
assign Bitline2 = ReadEnable2 ? (WriteReg ? D : q) : 1'bz;

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






