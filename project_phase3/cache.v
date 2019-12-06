module cache(input clk, input rst, input [15:0] DI, input W, input [15:0] addr, output [15:0] DO, output hit);
	wire [5:0] tag, index;
	wire [3:0] offset;
	
	wire [15:0] ddataout0, ddataout1;
	
	wire [7:0] mdatain0, mdatain1, mdataout0, mdataout1;
	wire hit0, hit1;
	
	wire [7:0] wordnum;
	wire [63:0] blocknum;
	
	wire w0, w1;
	wire dw0, dw1;
	
	wire LRU;
	
	// Init arrays
	// MetaData Array: dataout[7:2] = tag, dataout[1] = valid, dataout[0] = LRU
	MetaDataArray mArray0(.clk(clk), .rst(rst), .DataIn(mdatain0), .Write(w0), .BlockEnable(blocknum), .DataOut(mdataout0));
	MetaDataArray mArray1(.clk(clk), .rst(rst), .DataIn(mdatain1), .Write(w1), .BlockEnable(blocknum), .DataOut(mdataout1));
	
	DataArray dArray0(.clk(clk), .rst(rst), .DataIn(DI), .Write(dw0), .BlockEnable(blocknum), .WordEnable(wordnum), .DataOut(ddataout0));
	DataArray dArray1(.clk(clk), .rst(rst), .DataIn(DI), .Write(dw1), .BlockEnable(blocknum), .WordEnable(wordnum), .DataOut(ddataout1));
	
	// extract relevant bits
	assign offset = (rst) ? 4'h0 : addr[3:0];
	assign index = (rst) ? 6'h00 : addr[9:4];
	assign tag = (rst) ? 6'h00 : addr[15:10];
	
	// decode block and word number
	decoder_6_64 d0(.in(index), .out(blocknum));
	decoder_3_8 d1(.in(offset[3:1]), .out(wordnum));
	
	assign w0 = (W & ~mdataout0[1] & ~mdataout1[1]) | (mdataout0[1] & mdataout1[1]) | (mdataout0[1] & ~mdataout1[1]);
	assign w1 = (W & mdataout0[1] & ~mdataout1[1]) | (mdataout0[1] & mdataout1[1]);
	
	assign dw0 = W & ((~mdataout0[1] & ~mdataout1[1]) | (mdataout0[1] & mdataout1[1] & hit0) | (mdataout0[1] & mdataout1[1] & ~mdataout0[0]));
	assign dw1 = W & ((mdataout0[1] & ~mdataout1[1]) | (mdataout0[1] & mdataout1[1] & hit1) | (mdataout0[1] & mdataout1[1] & ~mdataout1[0]));
	
	assign LRU = (hit0 | (~mdataout0[1] & ~mdataout1[1]) | (mdataout0[1] & mdataout1[1] & ~mdataout0[0]));
	assign mdatain0 = dw0 ? {tag, 1'b1, LRU} : {mdataout0[7:1], LRU}; //TODO, fix concat for LRU
	assign mdatain1 = dw1 ? {tag, 1'b1, ~LRU} : {mdataout1[7:1], ~LRU}; //TODO, fix concat for LRU
	
	// Assign outputs
	assign hit0 = ((mdataout0[7:2] == tag) && (mdataout0[1] == 1'b1));
	assign hit1 = ((mdataout1[7:2] == tag) && (mdataout1[1] == 1'b1));
	
	assign hit = hit0 | hit1;
	assign DO = hit1 ? ddataout1 : ddataout0;
	// assign DO = blocknum[15:0];
endmodule