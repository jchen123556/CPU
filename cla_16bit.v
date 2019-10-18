module cla_16bit(Sum, Ovfl, A, B, Cin);

/////////////////////////////////////////////////////////////////////////////|
// Implementation of a 16 bit carry-look-ahead adder                         |
// By: Parker Schroeder                                                      |
/////////////////////////////////////////////////////////////////////////////|

output wire [15:0] Sum;
output wire Ovfl;
input wire [15:0] A;
input wire [15:0] B;
input wire Cin;

wire [3:0] G, P;
wire [4:0] C;

cla_4bit c0(.Sum(Sum[3:0]), .Ovfl(), .Gout(G[0]), .Pout(P[0]), .A(A[3:0]), .B(B[3:0]), .Cin(C[0]));
cla_4bit c1(.Sum(Sum[7:4]), .Ovfl(), .Gout(G[1]), .Pout(P[1]), .A(A[7:4]), .B(B[7:4]), .Cin(C[1]));
cla_4bit c2(.Sum(Sum[11:8]), .Ovfl(), .Gout(G[2]), .Pout(P[2]), .A(A[11:8]), .B(B[11:8]), .Cin(C[2]));
cla_4bit c3(.Sum(Sum[15:12]), .Ovfl(), .Gout(G[3]), .Pout(P[3]), .A(A[15:12]), .B(B[15:12]), .Cin(C[3]));

// Create the Carry Terms:
assign C[0] = Cin;
assign C[1] = G[0] | (P[0] & C[0]);
assign C[2] = G[1] | (P[1] & C[1]);
assign C[3] = G[2] | (P[2] & C[2]);
assign C[4] = G[3] | (P[3] & C[3]);

endmodule
