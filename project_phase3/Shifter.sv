module Shifter(Shift_Out, Shift_In, Shift_Val, Mode);  // mode is last two of opcode 
input[15:0] Shift_In;
input[3:0] Shift_Val;
input [1:0] Mode;
output[15:0] Shift_Out;

wire [15:0] l1, l2, l3, l4, r1, r2, r3, r4, t1, t2, t3, t4;

assign {l1} = (Shift_Val[0]) ? {Shift_In[14:0], 1'b0} : Shift_In;  // SLL
assign {l2} = (Shift_Val[1]) ? {l1[13:0], 2'b00} : l1;
assign {l3} = (Shift_Val[2]) ? {l2[11:0], 4'b0000} : l2;
assign {l4} = (Shift_Val[3]) ? {l3[7:0], 8'h00} : l3;

assign {r1} = (Shift_Val[0]) ? {Shift_In[15], Shift_In[15:1]} : Shift_In;  // SRA
assign {r2} = (Shift_Val[1]) ? { {2{Shift_In[15]}}, r1[15:2]} : r1;
assign {r3} = (Shift_Val[2]) ? { {4{r2[15]}}, r2[15:4]} : r2;
assign {r4} = (Shift_Val[3]) ? { {8{r3[15]}}, r3[15:8]} : r3;

assign {t1} = (Shift_Val[0]) ? {Shift_In[0], Shift_In[15:1]} : Shift_In;  // ROT
assign {t2} = (Shift_Val[1]) ? { t1[1:0], t1[15:2]} : t1;
assign {t3} = (Shift_Val[2]) ? { t2[3:0], t2[15:4]} : t2;
assign {t4} = (Shift_Val[3]) ? { t3[7:0], t3[15:8]} : t3;

assign Shift_Out = (Mode[0]) ? r4 : (Mode[1]) ? t4 : l4;

endmodule
