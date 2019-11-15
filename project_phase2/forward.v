module ForwardingUnit(input [3:0] IDEX_rs, input [3:0] IDEX_rt, input [3:0] EXMEM_rd, input EXMEM_rw, 
	input MEMWB_rw, input [3:0] MEMWB_rt, input [3:0] MEMWB_rd, input [3:0] EXMEM_rs, input [3:0] EXMEM_rt, input EXMEM_mr, input EXMEM_mw,
	output [1:0] ex_fwd1, output [1:0] ex_fwd2, output mem_fwd1, output mem_fwd2);
	
	wire [1:0] extoex1, extoex2;
	
	assign extoex1 = (EXMEM_rw && (EXMEM_rd != 4'b0000) && (EXMEM_rd == IDEX_rs)) ? 2'b10 : 2'b00;
	assign extoex2 = (EXMEM_rw && (EXMEM_rd != 4'b0000) && (EXMEM_rd == IDEX_rt)) ? 2'b10 : 2'b00;
	
	assign ex_fwd1 = (MEMWB_rw && (MEMWB_rd != 4'b0000) && ~(EXMEM_rw && (EXMEM_rd != 4'b0000) && (EXMEM_rd != IDEX_rs)) && (MEMWB_rd == IDEX_rs)) ? 2'b01 : extoex1;
	assign ex_fwd2 = (MEMWB_rw && (MEMWB_rd != 4'b0000) && ~(EXMEM_rw && (EXMEM_rd != 4'b0000) && (EXMEM_rd != IDEX_rt)) && (MEMWB_rd == IDEX_rt)) ? 2'b01 : extoex2;
	
	assign memfwd1 = (MEMWB_rw && (MEMWB_rt != 4'b0000) && (MEMWB_rt == EXMEM_rs) && (EXMEM_mr || EXMEM_mw) ) ? 1'b1 : 1'b0;
	assign memfwd2 = (MEMWB_rw && (MEMWB_rt != 4'b0000) && (MEMWB_rt == EXMEM_rt) && (EXMEM_mr || EXMEM_mw) ) ? 1'b1 : 1'b0;
endmodule
