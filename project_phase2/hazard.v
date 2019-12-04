module hazard(input IDEX_mr, input IFID_br, input [3:0] IDEX_rd, input [3:0] IFID_rt, input [3:0] IFID_rs,
	input EXMEM_mr, input [3:0] EXMEM_rd, input IDEX_rw, input IFID_mr, input IFID_mw, output stall);
	
	assign stall = ( ((IDEX_mr && ~(IFID_mr || IFID_mw)) || (IFID_br && IDEX_rw)) && 
		(IDEX_rd != 4'b0000) && 
		((IDEX_rd == IFID_rs) || (IDEX_rd == IFID_rt)) ) ||
		( (EXMEM_mr && IFID_br) &&
		(EXMEM_rd != 4'b0000) &&
		((EXMEM_rd == IFID_rs) || (EXMEM_rd == IFID_rt)) ) ? 1'b1 : 1'b0;
endmodule