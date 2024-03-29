module PSA_16bit (Sum, Error, A, B);
	input [15:0] A, B;    // Input data values
	output [15:0] Sum;  // Sum output
	output	Error; // To indicate overflows
	
	wire [15:0] tempSum;
	
	wire c1, c2, c3, c4; // Tracks carry out of all 4 adders
	wire p1, g1, p2, g2, p3, g3, p4, g4;
	
	cla_4bit A1 (.Sum(tempSum[3:0]), .Ovfl(c1), .A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .Pout(p1), .Gout(g1));
	cla_4bit A2 (.Sum(tempSum[7:4]), .Ovfl(c2), .A(A[7:4]), .B(B[7:4]), .Cin(1'b0), .Pout(p2), .Gout(g2));
	cla_4bit A3 (.Sum(tempSum[11:8]), .Ovfl(c3), .A(A[11:8]), .B(B[11:8]), .Cin(1'b0), .Pout(p3), .Gout(g3));
	cla_4bit A4 (.Sum(tempSum[15:12]), .Ovfl(c4), .A(A[15:12]), .B(B[15:12]), .Cin(1'b0), .Pout(p4), .Gout(g4));

	
	assign Sum[3:0] = ((A[3] == 1'b0 && B[3] == 1'b0) && (tempSum[3] == 1'b1))		// Pos overflow
		? 4'b0111 : ((A[3] == 1'b1 && B[3] == 1'b1) && (tempSum[3] == 1'b0)) 			// Neg overflow
		? 4'b1000 : tempSum[3:0];
	assign Sum[7:4] = ((A[7] == 1'b0 && B[7] == 1'b0) && (tempSum[7] == 1'b1))		// Pos overflow
		? 4'b0111 : ((A[7] == 1'b1 && B[7] == 1'b1) && (tempSum[7] == 1'b0)) 			// Neg overflow
		? 4'b1000 : tempSum[7:4];
	assign Sum[11:8] = ((A[11] == 1'b0 && B[11] == 1'b0) && (tempSum[11] == 1'b1))		// Pos overflow
		? 4'b0111 : ((A[11] == 1'b1 && B[11] == 1'b1) && (tempSum[11] == 1'b0)) 			// Neg overflow
		? 4'b1000 : tempSum[11:8];
	assign Sum[15:12] = ((A[15] == 1'b0 && B[15] == 1'b0) && (tempSum[15] == 1'b1))		// Pos overflow
		? 4'b0111 : (((A[15] == 1'b1 && B[15] == 1'b1) && (tempSum[15] == 1'b0)) 			// Neg overflow
		? 4'b1000 : tempSum[15:12]);
	
	assign Error = c1 | c2 | c3 | c4;
endmodule