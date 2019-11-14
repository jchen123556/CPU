module hazard(input IDEX_mr, input IFID_br, input [4:0] IDEX_rd, input [4:0] IFID_rt, input [4:0] IFID_rs,
	input EXMEM_mr, input [4:0] EXMEM_rd, input IDEX_rw, output stall);
	
	assign stall = ( (IDEX_mr || (IFID_br && IDEX_rw)) && 
		(IDEX_rd != 5'b00000) && 
		((IDEX_rd == IFID_rs) || (IDEX_rd == IFID_rt)) ) ||
		( (EXMEM_mr && IFID_br) &&
		(EXMEM_rd == 5'b00000) &&
		((EXMEM_rd == IFID_rs) || (EXMEM_rd == IFID_rt)) ) ? 1'b1 : 1'b0;
endmodule