module ForwardingUnit(input [4:0] IDEX_rs, input [4:0] IDEX_rt, input [4:0] EXMEM_rd, input EXMEM_rw, 
	input MEMWB_rw, input [4:0] MEMWB_rd, input [4:0] EXMEM_rs, input [4:0] EXMEM_rt, 
	output [1:0] ex_fwd1, output [1:0] ex_fwd2, output mem_fwd1, output mem_fwd2);
	
	wire [1:0] extoex1, extoex2;
	
	assign extoex1 = (EXMEM_rw && (EXMEM_rd != 5'b00000) && (EXMEM_rd == IDEX_rs)) ? 2'b10 : 2'b00;
	assign extoex2 = (EXMEM_rw && (EXMEM_rd != 5'b00000) && (EXMEM_rd == IDEX_rt)) ? 2'b10 : 2'b00;
	
	assign ex_fwd1 = (MEMWB_rw && (MEMWB_rd != 5'b00000) && ~(EXMEM_rw && (EXMEM_rd != 5'b00000) && (EXMEM_rd != IDEX_rs)) && (MEMWB_rd == IDEX_rs)) ? 2'b01 : extoex1;
	assign ex_fwd2 = (MEMWB_rw && (MEMWB_rd != 5'b00000) && ~(EXMEM_rw && (EXMEM_rd != 5'b00000) && (EXMEM_rd != IDEX_rt)) && (MEMWB_rd == IDEX_rt)) ? 2'b01 : extoex2;
	
	assign memfwd1 = (MEMWB_rw && (MEMWB_rd != 5'b00000) && (MEMWB_rd == EXMEM_rs)) ? 1'b1 : 1'b0;
	assign memfwd2 = (MEMWB_rw && (MEMWB_rd != 5'b00000) && (MEMWB_rd == EXMEM_rt)) ? 1'b1 : 1'b0;
endmodule
