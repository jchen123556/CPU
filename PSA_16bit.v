module PSA_16bit (Sum, Error, A, B);
	input [15:0] A, B;    // Input data values
	output [15:0] Sum;  // Sum output
	output	Error; // To indicate overflows
	
	wire [15:0] tempSum;
	
	wire o1, o2, o3, o4; // Tracks overflow of all 4 adders
	
	cla_4bit A1 (.Sum(tempSum[3:0]), .Ovfl(o1), .A(A[3:0]), .B(B[3:0]));
	cla_4bit A2 (.Sum(tempSum[7:4]), .Ovfl(o2), .A(A[7:4]), .B(B[7:4]));
	cla_4bit A3 (.Sum(tempSum[11:8]), .Ovfl(o3), .A(A[11:8]), .B(B[11:8]));
	cla_4bit A4 (.Sum(tempSum[15:12]), .Ovfl(o4), .A(A[15:12]), .B(B[15:12]));
	
	assign Sum[3:0] = o1 ? 1'hf : tempSum[3:0];
	assign Sum[7:4] = o2 ? 1'hf : tempSum[7:4];
	assign Sum[11:8] = o3 ? 1'hf : tempSum[11:8];
	assign Sum[15:12] = o4 ? 1'hf : tempSum[15:12];
	
	assign Error = o1 | o2 | o3 | o4;
endmodule