module cache_fill_FSM(clk, rst_n, miss_detected, miss_address, fsm_busy, write_data_array, write_tag_array, memory_address, memory_data, memory_data_valid);
  input clk, rst_n;
  input miss_detected; // active high when tag match logic detects a miss
  input [15:0] miss_address; // address that missed the cache
  output fsm_busy; // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
  output write_data_array; // write enable to cache data array to signal when filling with memory_data
  output write_tag_array; // write enable to cache tag array to signal when all words are filled in to data array
  output [15:0] memory_address; // address to read from memory 
  input [15:0] memory_data; // data returned by memory (after  delay)
  input memory_data_valid; // active high indicates valid data returning on memory bus

  wire [2:0] bit_cntr;
  wire [2:0] bit_sum;
  wire [2:0] bit_mux;
  wire [2:0] ovfl;
  wire counted;
  wire state;
  reg next_state;	// 0 = IDLE, 1 = WAIT, 2 INC
  reg stall_sig, write_cache_sig, finish_cache_sig, inc_cnt;
  reg [15:0] req_mem_addr;
  
  //assign memory_address = miss_address; // is this right?
  assign fsm_busy = stall_sig;
  assign write_data_array = write_cache_sig;
  assign write_tag_array = finish_cache_sig;
  assign memory_address = req_mem_addr;
  
  assign bit_mux = (inc_cnt) ? bit_sum : bit_cntr;
  
  dff ff_fsm(.q(state), .d(next_state), .wen(1'b1), .rst(!rst_n), .clk(clk));
  
  full_adder_1bit fa0(.Sum(bit_sum[0]), .Ovfl(ovfl[0]), .A(bit_cntr[0]), .B(1'b1), .Cin(1'b0));
  full_adder_1bit fa1(.Sum(bit_sum[1]), .Ovfl(ovfl[1]), .A(bit_cntr[1]), .B(ovfl[0]), .Cin(1'b0));
  full_adder_1bit fa2(.Sum(bit_sum[2]), .Ovfl(ovfl[2]), .A(bit_cntr[2]), .B(ovfl[1]), .Cin(1'b0));
  
  dff ff_adder0(.q(bit_cntr[0]), .d(bit_sum[0]), .wen(inc_cnt), .rst(!rst_n), .clk(clk));
  dff ff_adder1(.q(bit_cntr[1]), .d(bit_sum[1]), .wen(inc_cnt), .rst(!rst_n), .clk(clk));  
  dff ff_adder2(.q(bit_cntr[2]), .d(bit_sum[2]), .wen(inc_cnt), .rst(!rst_n), .clk(clk)); 
  dff ff_adder3(.q(counted), .d(ovfl[2]), .wen(1'b1), .rst(!rst_n), .clk(clk));
  
  // next state logic
  always @* begin
    case(state)
      1'b0 : begin			// Idle case
	    req_mem_addr = 16'hzzzz;
		write_cache_sig = 0;
	    finish_cache_sig = 0;
		inc_cnt = 0;
        if(miss_detected) begin
		  stall_sig = 1'b1; // Send stall to processor
		  req_mem_addr = miss_address; // Send request (addr) to main mem to get data
          next_state = 1'b1;
        end
        else begin
		  stall_sig = 1'b0;
          next_state = 1'b0;
        end
      end
      1'b1 : begin		// Wait case
        if(bit_cntr != 3'b000 || inc_cnt == 1'b0 || !counted) begin
		  req_mem_addr = 16'hzzzz;
		  finish_cache_sig = 1'b0;
		  write_cache_sig = 1'b0;
		  // Get 2B chunk
		  if(memory_data_valid) begin
		    if (bit_cntr != 3'b111) req_mem_addr = miss_address;
			inc_cnt = 1'b1; // Increase count (#chunks received in this burst)
			write_cache_sig = 1'b1; // Write to cache
		  end
		  else begin
			finish_cache_sig = 1'b0;
		    write_cache_sig = 1'b0;
			inc_cnt = 1'b0;
		  end
		  stall_sig = 1'b1;
          next_state = 1'b1;
        end
        else begin
		  req_mem_addr = 16'hzzzz;
		  inc_cnt = 1'b0;
		  write_cache_sig = 1'b0;
		  finish_cache_sig = 1'b1; // Write tag and valid bit
		  stall_sig = 1'b0; // Deassert stall signal
          next_state = 1'b0;
        end
      end	  
    endcase
  end
endmodule
