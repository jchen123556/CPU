module PSA_tb();
	reg [15:0] A, B;
	wire [15:0] sum;
	reg [3:0] e1, e2, e3,e4;
	wire Error;
	reg of1, of2, of3, of4;
	
	reg [15:0] Expected; 
	reg Exp_Error;
	
	reg [3:0] a1, b1;
	wire [3:0] s;
	wire c, p1, g1;
	
	PSA_16bit psa(.Sum(sum), .Error(Error), .A(A), .B(B));
	
	cla_4bit clatest(.Sum(s[3:0]), .Ovfl(c1), .A(a1[3:0]), .B(b1[3:0]), .Cin(1'b0), .Pout(p1), .Gout(g1));
	
	initial begin
		//repeat (10) begin
			A = 16'b0001000011110111;
			B = 16'b0001000010000111;
			
			a1 = 4'b0001;
			b1 = 4'b0001;
			
			#10;
			$display("%B + %B = %B\n", a1, b1, s);
			$display("%B PSA %B = %B", A, B, sum);
		//end
	end
endmodule

module ALU_tb();
	reg [15:0] i1, i2;
	reg [3:0] op;
	wire [15:0] out1;
	
	wire [15:0] claout;
	wire [2:0] flag;
	
	ALU alu (.Opcode(op), .in1(i1), .in2(i2), .out(out1), .flags(flag));
	cla_16bit ctest(.Sum(claout), .Ovfl(), .A(16'h9000), .B(16'h9000), .Cin(1'b0));
	
	initial begin
		#10
		$display("%B + %B = %B", 16'h9000, 16'h9000, claout);
		
		// shifts
		op = 4'b0100;
		i1 = 16'b0000000000000001;
		i2 = 16'b0000000000000010;
		#10;
		$display("%B sll %B = %B, Opcode = %B", i1, i2, out1, op);
		op = 4'b0101;
		i1 = 16'b0000000000001000;
		i2 = 16'b0000000000000001;
		#10;
		$display("%B sra %B = %B, Opcode = %B", i1, i2, out1, op);
		op = 4'b0110;
		i1 = 16'b0000000000000001;
		i2 = 16'b0000000000000010;
		#10;
		$display("%B ror %B = %B, Opcode = %B", i1, i2, out1, op);
		
		// psa
		
		// adds
		// normal add
		op = 4'b0000;
		i1 = 16'h24a3;
		i2 = 16'h0093;
		#10;
		$display("%B + %B = %B, Opcode = %B, flags = %B", i1, i2, out1, op, flag);
		
		// normal subtraction
		op = 4'b0001;
		i1 = 16'h0032;
		i2 = 16'h0005;
		#10;
		$display("%B - %B = %B, Opcode = %B", i1, i2, out1, op);
		
		// overflow below
		op = 4'b0001;
		i1 = 16'h9000;
		i2 = 16'h9000;
		#10;
		$display("%B - %B = %B, Opcode = %B", i1, i2, out1, op);
		
		// overflow above
		op = 4'b0000;
		i1 = 16'h7f0f;
		i2 = 16'h7888;
		#10;
		$display("%B + %B = %B, Opcode = %B", i1, i2, out1, op);
		// reduction
	end
endmodule




