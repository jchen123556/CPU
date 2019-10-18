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