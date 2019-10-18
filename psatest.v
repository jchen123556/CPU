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
	
	ALU alu (.Opcode(op), .in1(i1), .in2(i2), .out(out1));
	//cla_16bit ctest(.Sum(claout), .Ovfl(), .A(i1), .B(i2), .Cin(1'b0));
	
	initial begin
		op = 4'b0001;
		i1 = 16'b0000000000000001;
		i2 = 16'b0000000000000001;
		
		#10;
		//$display("%B + %B = %B", i1, i2, claout);
		$display("%B op %B = %B, Opcode = %B", i1, i2, out1, op);
	end
endmodule