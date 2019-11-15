module pcc(input clk, input rst_n, input [2:0] fl, input [15:0] instr, input [15:0] rs_reg, input [15:0] pc_output, output [15:0] pc_next, input [15:0] pc_inc, output hlt);
	wire [15:0] pc_br, pc_bs;
	wire [3:0] opcode;
	wire [2:0] F, C;
	wire z_en, v_en, n_en;
	wire br, p1, p2, p3, p4, p5, p6, p7, p8;

	assign C = instr[11:9];	
	assign opcode = instr[15:12];
	
	assign pc_next = (hlt) ? pc_output : (!br) ? pc_inc : (opcode[0] == 1'b0) ? pc_bs : pc_br;
	//cla_16bit pc_step(.Sum(pc_inc), .Ovfl(), .A(pc_output), .B(16'h0002), .Cin(1'b0));
        cla_16bit branch_sum(.Sum(pc_bs), .Ovfl(), .A(pc_inc), .B({{{6{instr[8]}}, instr[8:0]}, 1'b0}), .Cin(1'b0));
	assign pc_br = rs_reg;

	assign hlt = (opcode == 4'hf);
	assign p1 = ((C == 3'b000) && (F[2] == 1'b0)) ? 1'b1 : 1'b0;
	assign p2 = ((C == 3'b001) && (F[2] == 1'b1)) ? 1'b1 : 1'b0;	
	assign p3 = ((C == 3'b010) && ({F[2], F[0]} == 2'b00)) ? 1'b1 : 1'b0; 
	assign p4 = ((C == 3'b011) && (F[0] == 1'b1)) ? 1'b1 : 1'b0;
	assign p5 = ((C == 3'b100) && ((F[2] == 1'b1) || ({F[2], F[0]} == 2'b00))) ? 1'b1 : 1'b0; 
	assign p6 = ((C == 3'b101) && ((F[2] == 1'b1) || (F[0] == 1'b0))) ? 1'b1 : 1'b0;
	assign p7 = ((C == 3'b110) && (F[1] == 1'b1)) ? 1'b1 : 1'b0;
	assign p8 = (C == 3'b111) ? 1'b1 : 1'b0;
	assign br = (opcode[3:1] == 3'b110) && (p1 || p2 || p3 || p4 || p5 || p6 || p7 || p8 );
	
	assign z_en = (opcode[3:2] == 2'b00 && opcode[1:0]!=2'b00);
	assign v_en = (opcode[3:1] == 3'b000);
	assign n_en = (opcode[3:1] == 3'b000);

	dff z(.d(fl[2]), .q(F[2]), .wen(z_en), .clk(clk), .rst(!rst_n));    // zvn
	dff v(.d(fl[1]), .q(F[1]), .wen(v_en), .clk(clk), .rst(!rst_n));
	dff n(.d(fl[0]), .q(F[0]), .wen(n_en), .clk(clk), .rst(!rst_n));

endmodule
