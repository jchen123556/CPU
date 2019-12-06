module cache_fill_2_tb();

reg clk, rst;				// system clock and active-high synch reset
reg miss_detected1, miss_detected2, memory_data_valid;
reg [15:0] miss_address1, miss_address2, memory_data;

wire [1:0] fsm_busy, write_data_array, write_tag_array;
wire [15:0] memory_address;

wire [1:0] next_valid;
wire [1:0] inv_valid;
wire [1:0] q_valid;

wire [1:0] miss, d_miss, q_miss;

cache_fill_FSM cfsmD(.clk(clk), .rst_n(rst_n), .miss_detected(miss[0]), .miss_address(miss_address1), 
					.fsm_busy(fsm_busy[0]), .write_data_array(write_data_array[0]), .write_tag_array(write_tag_array[0]), .memory_address(memory_address), 
					.memory_data(memory_data), .memory_data_valid(next_valid[0] && memory_data_valid));
					
cache_fill_FSM cfsmI(.clk(clk), .rst_n(rst_n), .miss_detected(miss[1]), .miss_address(miss_address2), 
					.fsm_busy(fsm_busy[1]), .write_data_array(write_data_array[1]), .write_tag_array(write_tag_array[1]), .memory_address(memory_address), 
					.memory_data(memory_data), .memory_data_valid(next_valid[1] && memory_data_valid));

// 00 - no valid, 01 - cfsmD valid, 10 - cfsmI valid
assign next_valid = (!fsm_busy[1] && !fsm_busy[0]) ? 2'b00 : (fsm_busy[1] && !fsm_busy[0]) ? 2'b10 : (!fsm_busy[1] && fsm_busy[0]) ? 2'b01 : q_valid;
assign inv_valid = (memory_data_valid || (|miss)) ? ~next_valid : next_valid;

dff valid_ff1(.q(q_valid[1]), .d(inv_valid[1]), .wen(1), .clk(clk), .rst(rst));
dff valid_ff0(.q(q_valid[0]), .d(inv_valid[0]), .wen(1), .clk(clk), .rst(rst));

// I cache gets priority //
assign d_miss[1] = (write_data_array[0] && !write_tag_array[0]) && miss_detected2;
assign miss[1] = (!(write_data_array[0] && !write_tag_array[0]) && miss_detected2) || q_miss[1];

// D cache miss logic //
assign d_miss[0] = ((write_data_array[1] && !write_tag_array[1]) || miss_detected2) && miss_detected1;
assign miss[0] = (!((write_data_array[1] && !write_tag_array[1]) || miss_detected2) && miss_detected1) || q_miss[0];

dff miss_ff1(.q(q_miss[1]), .d(d_miss[1]), .wen(1'b1), .clk(clk), .rst(rst));
dff miss_ff0(.q(q_miss[0]), .d(d_miss[0]), .wen(1'b1), .clk(clk), .rst(rst));

/////////////////////////////////////////////////////////|
// Implementation of a testbench for 16, 16 bit registers|
// By: Parker Schroeder                                  |
/////////////////////////////////////////////////////////|

assign rst_n = ~rst;

initial begin

    clk = 0;
    rst = 1;
	miss_detected1 = 0;
	miss_detected2 = 0;
	memory_data_valid = 0;

    @(posedge clk);
    @(negedge clk);
    rst = 0;
	miss_detected1 = 0;
	miss_detected2 = 0;
	
	@(posedge clk);
	@(negedge clk);
	miss_detected1 = 1;
	miss_detected2 = 1;
	memory_data_valid = 0;
	miss_address1 = 16'habcd;
	miss_address2 = 16'hffff;
	memory_data = 16'hcdef;
	
	@(posedge clk);
	miss_detected1 = 0;
	miss_detected2 = 0;
	
	@(posedge clk);
	miss_detected1 = 0;
	miss_detected2 = 0;
	
	@(posedge clk);
	miss_detected2 = 0;
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	miss_detected2 = 0;
	
	@(posedge clk);
	memory_data_valid = 0;
	miss_detected2 = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
    @(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	memory_data_valid = 0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	memory_data_valid = 1;
	
	@(posedge clk);
	@(posedge clk);
    $stop();


end

always
	#5 clk = ~clk;

endmodule
