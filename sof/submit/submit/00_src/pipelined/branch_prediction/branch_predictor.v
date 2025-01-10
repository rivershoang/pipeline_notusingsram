`include "D:/Verilog_archived/02_CPU/03_FinnRISCV/rtl/cpu_def.vh"

module branch_predictor (
   input  wire          clk,
                        rst_n,
                        prev_taken,
   input  wire [31:0]   targetted_PC_in,
                        pcF, pcD, pcE,
                        instrF, instrE,
   output wire [31:0]   nxt_pc,
   output wire          flush_D_E
);

   wire        is_branch,
               predict_taken,
               hit,
               cache_vld,
               after_and,
               is_branchF;
   wire [31:0] targetted_PC_out,
               expected_pc,
               nxt_pc_tmp;
   wire [19:0] tag_out;
   
   assign is_branch = (instrE[6:0] == `B_TYPE || instrE[6:0] == `I_TYPE_JALR || instrE[6:0] == `J_TYPE);  
   assign is_branchF = (instrF[6:0] == `B_TYPE || instrF[6:0] == `I_TYPE_JALR || instrF[6:0] == `J_TYPE);      
   assign hit = (tag_out == pcF[31:12]);     // is that branch
   assign after_and = predict_taken & hit & cache_vld;
   assign nxt_pc_tmp = is_branchF & after_and ? targetted_PC_out : (pcF + 4);
   assign expected_pc = prev_taken ? targetted_PC_in : (pcE + 4);
   assign flush_D_E = is_branch && (pcD != expected_pc);
   assign nxt_pc = flush_D_E ? expected_pc : nxt_pc_tmp;

   one_bit_predictor u_one_bit_predictor (
      .clk           (clk           ),
      .rst_n         (rst_n         ),
      .is_branch     (is_branch     ),
      .prev_taken    (prev_taken    ),
      .predict_taken (predict_taken )
   );

   cache u_branch_target_buffer (
      .clk              (clk              ),
      .w_en             (is_branch        ),
      .targetted_PC_in  (targetted_PC_in  ),
      .tag_in           (pcE[31:12]       ),
      .w_addr           (pcE[11:2]        ),
      .r_addr           (pcF[11:2]        ),
      .targetted_PC_out (targetted_PC_out ),
      .tag_out          (tag_out          ),
      .cache_vld        (cache_vld        )
   );
endmodule 