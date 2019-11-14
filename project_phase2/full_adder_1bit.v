module full_adder_1bit(Sum, Ovfl, A, B, Cin);

////////////////////////////////////////////////|
// 1 bit full adder implementation with overflow|
// By: Parker Schroeder                         |
////////////////////////////////////////////////|

input wire A,B;     // Input values
input wire Cin;     // Carry in value
output wire Sum;    // sum output
output wire Ovfl;   // to indicate overflow

assign Sum = (A ^ B) ^ Cin;
assign Ovfl = ((A & B) | (A & Cin)) | (B & Cin);

endmodule
