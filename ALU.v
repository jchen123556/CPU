module ALU (input [3:0] Opcode, input [15:0] in1, input [15:0] in2, output [15:0] out);
	wire [31:0] routlong;
	wire [15:0] addout, shout, redout, padout;
	wire add, pad, shift, red, excor;
	
	wire [15:0] in2edit;
	
	// Unused
	wire psaerror, claovf;

	wire sub;
	assign sub = Opcode == 4'b0001 ? 1'b1 : 1'b0;
	
	assign in2edit = sub == 1'b1 ? ~in2 : in2;

	cla_16bit a (.Sum(addout), .Ovfl(claovf), .A(in1), .B(in2edit), .Cin(sub));
	Shifter s (.Shift_Out(shout), .Shift_In(in1), .Shift_Val(in2[3:0]), .Mode(Opcode[1:0]));
	reduction r (.a(in1), .b(in2), .c(routlong));
	PSA_16bit p (.Sum(padout), .Error(psaerror), .A(in1), .B(in2));
	
	assign add = Opcode[3:1] == 3'b000 || Opcode[3:2] == 2'b10;
	assign pad = Opcode [3:0] == 4'b0111;
	assign shift = Opcode[3:2] == 2'b01 && Opcode[2:0] != 3'b111;
	assign red = Opcode[3:0] == 4'b0011;
	
	assign out = add ? addout : 
		(pad) ? padout : 
		(shift) ? shout : 
		(red) ? routlong[15:0] : (in1 ^ in2);
endmodule