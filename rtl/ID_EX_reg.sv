module ID_EX_reg (
   input  logic         clk         , 
   input  logic         rst_n       ,     
   input  logic         flush       ,
   input  logic         enable      ,

   input  logic [ 1:0]  wb_sel_D    ,
   input  logic         mem_wr_en_D ,
   input  logic [ 3:0]  bmask_D     ,
   input  logic [ 2:0]  ld_sel_D    ,
   input  logic [ 3:0]  alu_sel_D   ,
   input  logic         a_sel_D     ,
   input  logic         b_sel_D     ,
   input  logic         br_un_D     ,
   input  logic         reg_wr_en_D ,
   input  logic         insn_vld_D  ,   

   input  logic [31:0]  instr_D     ,
   input  logic [31:0]  pc_D        ,

   input  logic [31:0]  rs1_data_D  ,
   input  logic [31:0]  rs2_data_D  ,
   input  logic [31:0]  imm_D       ,
   
   output logic [ 1:0]  wb_sel_E    ,
   output logic         mem_wr_en_E ,
   output logic [ 3:0]  bmask_E     ,
   output logic [ 2:0]  ld_sel_E    ,
   output logic [ 3:0]  alu_sel_E   ,
   output logic         a_sel_E     ,
   output logic         b_sel_E     ,
   output logic         br_un_E     ,
   output logic         reg_wr_en_E ,
   output logic         insn_vld_E  ,

   output logic [31:0]  instr_E     ,
   output logic [31:0]  pc_E        ,

   output logic [31:0]  rs1_data_E  ,
   output logic [31:0]  rs2_data_E  ,
   output logic [31:0]  imm_E
);
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin 
         wb_sel_E     <= 0;
         mem_wr_en_E  <= 0;
         bmask_E      <= 0;
         ld_sel_E     <= 0;
         alu_sel_E    <= 0;
         a_sel_E      <= 0;
         b_sel_E      <= 0;
         br_un_E      <= 0;
         reg_wr_en_E  <= 0;
         instr_E      <= 0;
         pc_E         <= 0;
         rs1_data_E   <= 0;
         rs2_data_E   <= 0;
         imm_E        <= 0;
         insn_vld_E   <= 0;
      end else if (flush) begin 
         wb_sel_E     <= 0;
         mem_wr_en_E  <= 0;
         bmask_E      <= 0;
         ld_sel_E     <= 0;
         alu_sel_E    <= 0;
         a_sel_E      <= 0;
         b_sel_E      <= 0;
         br_un_E      <= 0;
         reg_wr_en_E  <= 0;
         instr_E      <= 0;
         pc_E         <= 0;
         rs1_data_E   <= 0;
         rs2_data_E   <= 0;
         imm_E        <= 0;
         insn_vld_E   <= 0;
      end else if (enable) begin
         wb_sel_E     <= wb_sel_D;
         mem_wr_en_E  <= mem_wr_en_D;
         bmask_E      <= bmask_D;
         ld_sel_E     <= ld_sel_D;
         alu_sel_E    <= alu_sel_D;
         a_sel_E      <= a_sel_D;
         b_sel_E      <= b_sel_D;
         br_un_E      <= br_un_D;
         reg_wr_en_E  <= reg_wr_en_D;
         instr_E      <= instr_D;
         pc_E         <= pc_D;
         rs1_data_E   <= rs1_data_D;
         rs2_data_E   <= rs2_data_D;
         imm_E        <= imm_D;
         insn_vld_E   <= insn_vld_D;
      end else if (~enable) begin
         wb_sel_E     <= wb_sel_E;
         mem_wr_en_E  <= mem_wr_en_E;
         bmask_E      <= bmask_E;
         ld_sel_E     <= ld_sel_E;
         alu_sel_E    <= alu_sel_E;
         a_sel_E      <= a_sel_E;
         b_sel_E      <= b_sel_E;
         br_un_E      <= br_un_E;
         reg_wr_en_E  <= reg_wr_en_E;
         instr_E      <= instr_E;
         pc_E         <= pc_E;
         rs1_data_E   <= rs1_data_E;
         rs2_data_E   <= rs2_data_E;
         imm_E        <= imm_E;
         insn_vld_E   <= insn_vld_E;
      end
   end

endmodule