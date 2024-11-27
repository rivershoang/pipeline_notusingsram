module ME_WB_reg (
   input  logic         clk         , 
   input  logic         rst_n       ,   
   input  logic         flush       ,
   input  logic         enable      ,

   input  logic [ 1:0]  wb_sel_M    ,
   input  logic         reg_wr_en_M ,
   input  logic [31:0]  instr_M     ,
   input  logic [31:0]  pc_four_M   ,
   input  logic [31:0]  alu_data_M  ,
   input  logic [31:0]  ld_data_M   ,
   input  logic         insn_vld_M  ,     

   output logic         insn_vld_W  ,
   output logic [ 1:0]  wb_sel_W    , 
   output logic         reg_wr_en_W ,
   output logic [31:0]  instr_W     ,
   output logic [31:0]  pc_four_W   ,
   output logic [31:0]  alu_data_W  ,
   output logic [31:0]  ld_data_W
);

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin 
         wb_sel_W     <= 0;
         reg_wr_en_W  <= 0;
         pc_four_W    <= 0;
         instr_W      <= 0;
         alu_data_W   <= 0;
         ld_data_W    <= 0;
         insn_vld_W   <= 0;
      end else if (flush) begin 
         wb_sel_W     <= 0;
         reg_wr_en_W  <= 0;
         pc_four_W    <= 0;
         instr_W      <= 0;
         alu_data_W   <= 0;
         ld_data_W    <= 0;
         insn_vld_W   <= 0;
      end else if (enable) begin
         wb_sel_W     <= wb_sel_M;
         reg_wr_en_W  <= reg_wr_en_M;
         pc_four_W    <= pc_four_M;
         instr_W      <= instr_M;
         alu_data_W   <= alu_data_M;
         ld_data_W    <= ld_data_M;
         insn_vld_W   <= insn_vld_M;
      end else if (~enable) begin
         wb_sel_W     <= wb_sel_W;
         reg_wr_en_W  <= reg_wr_en_W;
         pc_four_W    <= pc_four_W;
         instr_W      <= instr_W;
         alu_data_W   <= alu_data_W;
         ld_data_W    <= ld_data_W;
         insn_vld_W   <= insn_vld_W;
      end 
   end

endmodule 