module EX_ME_reg (
   input  logic         clk         , 
   input  logic         rst_n       ,   
   input  logic         flush       ,
   input  logic         enable      ,

   input  logic [ 1:0]  wb_sel_E    ,  
   input  logic         mem_wr_en_E ,
   input  logic [ 3:0]  bmask_E     ,
   input  logic [ 2:0]  ld_sel_E    ,
   input  logic         reg_wr_en_E ,
   input  logic         insn_vld_E  ,

   input  logic [31:0]  instr_E     ,
   input  logic [31:0]  pc_E        , 

   input  logic [31:0]  alu_data_E  ,
   input  logic [31:0]  rs2_data_E  ,

   output logic [ 1:0]  wb_sel_M    ,
   output logic         mem_wr_en_M ,
   output logic [ 3:0]  bmask_M     ,
   output logic [ 2:0]  ld_sel_M    ,
   output logic         reg_wr_en_M ,
   output logic         insn_vld_M  ,

   output logic [31:0]  instr_M     ,
   output logic [31:0]  pc_M        , 

   output logic [31:0]  alu_data_M  ,
   output logic [31:0]  rs2_data_M
);

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin 
         wb_sel_M          <= 0;
         mem_wr_en_M       <= 0;
         bmask_M           <= 0;
         ld_sel_M          <= 0;
         reg_wr_en_M       <= 0;
         instr_M           <= 0;
         pc_M              <= 0;
         alu_data_M        <= 0;
         rs2_data_M        <= 0;
         insn_vld_M        <= 0;
      end else if (flush) begin 
         wb_sel_M          <= 0;
         mem_wr_en_M       <= 0;
         bmask_M           <= 0;
         ld_sel_M          <= 0;
         reg_wr_en_M       <= 0;
         instr_M           <= 0;
         pc_M              <= 0;
         alu_data_M        <= 0;
         rs2_data_M        <= 0;
         insn_vld_M        <= 0;
      end else if (enable) begin
         wb_sel_M          <= wb_sel_E;
         mem_wr_en_M       <= mem_wr_en_E;
         bmask_M           <= bmask_E;
         ld_sel_M          <= ld_sel_E;
         reg_wr_en_M       <= reg_wr_en_E;
         instr_M           <= instr_E;
         pc_M              <= pc_E;
         alu_data_M        <= alu_data_E;
         rs2_data_M        <= rs2_data_E;
         insn_vld_M        <= insn_vld_E;
      end else if (~enable) begin
         wb_sel_M          <= wb_sel_M;
         mem_wr_en_M       <= mem_wr_en_M;
         bmask_M           <= bmask_M;
         ld_sel_M          <= ld_sel_M;
         reg_wr_en_M       <= reg_wr_en_M;
         instr_M           <= instr_M;
         pc_M              <= pc_M;
         alu_data_M        <= alu_data_M;
         rs2_data_M        <= rs2_data_M;
         insn_vld_M        <= insn_vld_M;
      end 
   end

endmodule 
