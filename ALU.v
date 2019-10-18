module ALU (input [3:0] Opcode, input [15:0] in1, input [15:0] in2, output [15:0] out, output [2:0] flags); // flags are [2] Z, [1] V, [0] N
	wire [31:0] routlong;
	wire [15:0] addout, shout, redout, padout;
	wire add, pad, shift, red, overflow;
	
	wire [15:0] addsat;
	
	wire sign1, sign2;
	
	wire [15:0] in2edit;
	
	// Unused
	wire psaerror, claovf;

	wire sub;
	assign sub = Opcode == 4'b0001 ? 1'b1 : 1'b0;
	
	assign in2edit = sub == 1'b1 ? ~in2 : in2;
	
	assign sign1 = in1[15];
	assign sign2 = in2[15] ^ sub;
	
	cla_16bit a (.Sum(addout), .Ovfl(claovf), .A(in1), .B(in2edit), .Cin(sub));
	Shifter s (.Shift_Out(shout), .Shift_In(in1), .Shift_Val(in2[3:0]), .Mode(Opcode[1:0]));
	reduction r (.a(in1), .b(in2), .c(routlong));
	PSA_16bit p (.Sum(padout), .Error(psaerror), .A(in1), .B(in2));
	
	assign addsat = ((sign1 == 1'b0 && sign2 == 1'b0) && (addout[15] == 1'b1)) 
	? 16'b0111111111111111 : ((sign1 == 1'b1 && sign2 == 1'b1) && (addout[15] == 1'b0))
	? 16'b1000000000000000 : addout;
	
	assign overflow = ((sign1 == 1'b0 && sign2 == 1'b0) && (addout[15] == 1'b1)) || ((sign1 == 1'b1 && sign2 == 1'b1) && (addout[15] == 1'b0)) ? 1'b1 : 1'b0;
	
	assign add = Opcode[3:1] == 3'b000 || Opcode[3:2] == 2'b10;
	assign pad = Opcode [3:0] == 4'b0111;
	assign shift = Opcode[3:2] == 2'b01 && Opcode[2:0] != 3'b111;
	assign red = Opcode[3:0] == 4'b0011;
	
	assign out = add ? addsat : 
		(pad) ? padout : 
		(shift) ? shout : 
		(red) ? routlong[15:0] : (in1 ^ in2);
		
	assign flags[2] = (out == 16'h0000) ? 1'b1 : 1'b0;
	assign flags[1] = overflow;
	assign flags[0] = out[15];
endmodule