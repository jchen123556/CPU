module cla_4bit(Sum, Ovfl, Gout, Pout, A, B, Cin);

/////////////////////////////////////////////////////////////////////////////|
// Implementation of a 4 bit carry-look-ahead adder                          |
// By: Parker Schroeder                                                      |
/////////////////////////////////////////////////////////////////////////////|

output wire [3:0] Sum;
output wire Ovfl;
output wire Gout;
output wire Pout;
input wire [3:0] A, B;
input wire Cin;

wire [4:0] C;
wire [3:0] G, P;

full_adder_1bit FA0(.Sum(Sum[0]), .Ovfl(), .A(A[0]), .B(B[0]), .Cin(C[0]));
full_adder_1bit FA1(.Sum(Sum[1]), .Ovfl(), .A(A[1]), .B(B[1]), .Cin(C[1]));
full_adder_1bit FA2(.Sum(Sum[2]), .Ovfl(), .A(A[2]), .B(B[2]), .Cin(C[2]));
full_adder_1bit FA3(.Sum(Sum[3]), .Ovfl(Ovfl), .A(A[3]), .B(B[3]), .Cin(C[3]));

// Create the Generate (G) Terms:  Gi=Ai*Bi
assign G[0] = A[0] & B[0];
assign G[1] = A[1] & B[1];
assign G[2] = A[2] & B[2];
assign G[3] = A[3] & B[3];

// Create the Propagate Terms: Pi=Ai+Bi
assign P[0] = A[0] | B[0];
assign P[1] = A[1] | B[1];
assign P[2] = A[2] | B[2];
assign P[3] = A[3] | B[3];

// Create the Carry Terms:
assign C[0] = Cin; // no carry input
assign C[1] = G[0] | (P[0] & C[0]);
assign C[2] = G[1] | (P[1] & C[1]);
assign C[3] = G[2] | (P[2] & C[2]);
assign C[4] = G[3] | (P[3] & C[3]);

assign Gout = C[4];
assign Pout = (C[4] && Sum != 4'b0);
//assign Ovfl = ~(A[3] ^ B[3]) & (A[3] ^ ~Sum[3]);

endmodule