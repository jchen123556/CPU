module reduction( input [15:0] a, input [15:0] b, output [31:0] c);

wire [8:0] ab, cd;
wire [31:0] abcd;
wire about, cdout, t1, t2;
//Sum Ovfl A B Cin
CLA cla_ab1( .A(a[11:8]), .B(a[3:0]), .Cin(0), .Ovfl(about), .Sum(ab[3:0]) );
CLA cla_ab2( .A(a[15:12]), .B(a[7:4]), .Cin(about), .Ovfl(ab[8]), .Sum(ab[7:4]) );

CLA cla_cd1( .A(b[11:8]), .B(b[3:0]), .Cin(0), .Ovfl(cdout), .Sum(cd[3:0]) );
CLA cla_cd2( .A(b[15:12]), .B(b[7:4]), .Cin(cdout), .Ovfl(cd[8]), .Sum(cd[7:4]) );

CLA cla_t1( .A(ab[3:0]), .B(cd[3:0]), .Cin(0), .Ovfl(t1), .Sum(c[3:0]) );
CLA cla_t2( .A(ab[7:4]), .B(cd[7:4]), .Cin(t1), .Ovfl(t2), .Sum(c[7:4]) );
CLA cla_t3( .A({4{ab[8]}}), .B({4{cd[8]}}), .Cin(t2), .Ovfl(t3), .Sum(c[11:8]) );

assign c[31:12] = {20{t3}};

endmodule






