`timescale 1ns/1ns
module pipeline (
   input  logic        clk     , 
   input  logic        rst_n   ,
   output logic [31:0] pc_debug,
   output logic        insn_vld, 
   // output reg         insn_tmp,
   output logic [31:0] io_ledr ,
   output logic [31:0] io_ledg , 
   output logic [ 6:0] io_hex0 ,
   output logic [ 6:0] io_hex1 ,
   output logic [ 6:0] io_hex2 ,
   output logic [ 6:0] io_hex3 ,
   output logic [ 6:0] io_hex4 ,
   output logic [ 6:0] io_hex5 ,
   output logic [ 6:0] io_hex6 ,
   output logic [ 6:0] io_hex7 ,
   output logic [31:0] io_lcd  ,
   input  logic [31:0] io_sw   ,
   input  logic [ 3:0] io_btn  
);

   logic [31:0]   nxt_pc      ,   
                  pc_F        ,
                  pc_four     ,
                  instr_F     ,
                  alu_data_E  ,
                  instr_D     ,
                  pc_D        ,
                  instr_W     ,
                  wb_data     ,
                  rs1_data_D  ,
                  rs2_data_D  ,
                  imm_D       ,
                  instr_E     ,
                  pc_E        ,
                  rs1_data_E  ,
                  rs2_data_E  ,
                  imm_E       ,
                  operand_a   ,
                  operand_b   ,
                  instr_M     ,
                  pc_M        ,
                  alu_data_M  ,
                  rs2_data_M  ,
                  ld_data_M   ,
                  pc_four_M   ,
                  pc_four_W   ,
                  alu_data_W  ,
                  ld_data_W   ;

   logic          is_taken    ,
                  IF_ID_flush ,
                  IF_ID_enable,
                  reg_wr_en_W ,
                  mem_wr_en_D ,
                  b_sel_D     ,
                  a_sel_D     ,
                  br_un_D     ,
                  reg_wr_en_D , 
                  ID_EX_flush ,
                  ID_EX_enable,
                  mem_wr_en_E ,
                  a_sel_E     ,
                  b_sel_E     ,
                  br_un_E     ,
                  reg_wr_en_E ,
                  br_equal    ,
                  br_less     ,
                  EX_ME_flush ,
                  EX_ME_enable,
                  mem_wr_en_M ,
                  reg_wr_en_M ,
                  ME_WB_flush ,
                  ME_WB_enable,
                  insn_vld_D  ,
                  insn_vld_E  ,
                  insn_vld_M  ,
                  insn_vld_W  ,
                  pc_en       ,
                  insn_tmp    ; 

   logic [ 1:0]   wb_sel_D,
                  wb_sel_E,
                  wb_sel_M,
                  wb_sel_W;
   
   logic [ 3:0]   bmask_D  ,
                  alu_sel_D,
                  bmask_E  ,
                  alu_sel_E,
                  bmask_M  ;
               
                  
   logic [ 2:0]   ld_sel_D,
                  ld_sel_E,
                  ld_sel_M;

   pc pc (
      .clk        (clk)    ,
      .rst_n      (rst_n)  ,
      .pc_enable  (pc_en)  ,
      .pc_in      (nxt_pc) ,
      .pc_out     (pc_F)   
   );

   assign pc_four = pc_F + 4; 

   inst_mem imem (
      .raddr (pc_F[12:0]),
      .rdata (instr_F)
   );

   // mux fetch 
   assign nxt_pc = is_taken ? alu_data_E : pc_four;

   IF_ID_reg IF_to_ID (
      .clk     (clk)          ,
      .rst_n   (rst_n)        ,
      .flush   (IF_ID_flush)  ,
      .enable  (IF_ID_enable) ,
      .instr_F (instr_F)      ,
      .pc_F    (pc_F)         ,
      .instr_D (instr_D)      ,
      .pc_D    (pc_D)
   );

   regfile regfile_p (
      .clk        (clk)             ,
      .rst_n      (rst_n)           ,
      .rs1_addr   (instr_D[19:15])  ,
      .rs2_addr   (instr_D[24:20])  ,
      .rd_addr    (instr_W[11:7])   ,
      .rd_wren    (reg_wr_en_W)     ,
      .rd_data    (wb_data)         ,
      .rs1_data   (rs1_data_D)      ,
      .rs2_data   (rs2_data_D)
   );

   immgen immidiate (
      .instr   (instr_D),
      .imm     (imm_D)
   );

   control_unit cu (
      .instr      (instr_D)      ,
      .wb_sel     (wb_sel_D)     ,
      .wr_en      (mem_wr_en_D)  ,
      .bmask      (bmask_D)      ,
      .ld_sel     (ld_sel_D)     ,
      .alu_sel    (alu_sel_D)    ,
      .b_sel      (b_sel_D)      ,
      .a_sel      (a_sel_D)      ,
      .br_un      (br_un_D)      ,
      .reg_wr_en  (reg_wr_en_D)  ,
      .insn_vld   (insn_vld_D)
   );

   ID_EX_reg ID_EX (
      .clk           (clk)          ,   
      .rst_n         (rst_n)        , 
      .flush         (ID_EX_flush)  ,
      .enable        (ID_EX_enable) ,
      .wb_sel_D      (wb_sel_D)     ,
      .mem_wr_en_D   (mem_wr_en_D)  ,
      .bmask_D       (bmask_D)      ,
      .ld_sel_D      (ld_sel_D)     ,
      .alu_sel_D     (alu_sel_D)    ,
      .a_sel_D       (a_sel_D)      ,
      .b_sel_D       (b_sel_D)      ,
      .br_un_D       (br_un_D)      ,
      .reg_wr_en_D   (reg_wr_en_D)  ,
      .insn_vld_D    (insn_vld_D)   ,
      .instr_D       (instr_D)      ,
      .pc_D          (pc_D)         ,
      .rs1_data_D    (rs1_data_D)   ,
      .rs2_data_D    (rs2_data_D)   ,
      .imm_D         (imm_D)        ,
      .wb_sel_E      (wb_sel_E)     ,
      .mem_wr_en_E   (mem_wr_en_E)  ,
      .insn_vld_E    (insn_vld_E)   ,
      .bmask_E       (bmask_E)      ,
      .ld_sel_E      (ld_sel_E)     ,
      .alu_sel_E     (alu_sel_E)    ,
      .a_sel_E       (a_sel_E)      ,
      .b_sel_E       (b_sel_E)      ,
      .br_un_E       (br_un_E)      ,
      .reg_wr_en_E   (reg_wr_en_E)  ,
      .instr_E       (instr_E)      ,
      .pc_E          (pc_E)         ,
      .rs1_data_E    (rs1_data_E)   ,
      .rs2_data_E    (rs2_data_E)   ,
      .imm_E         (imm_E)
   );

   brc brach_comp (
      .rs1_data   (rs1_data_E),
      .rs2_data   (rs2_data_E),
      .br_un      (br_un_E)   ,
      .br_equal   (br_equal)  ,
      .br_less    (br_less)
   );

   branch_select bru (
      .instr      (instr_E)   ,
      .br_equal   (br_equal)  ,
      .br_less    (br_less)   ,
      .is_taken   (is_taken)
   );

   assign operand_a = a_sel_E ? pc_E : rs1_data_E;
   assign operand_b = b_sel_E ? imm_E : rs2_data_E;

   alu alu_inst (
      .operand_a  (operand_a),
      .operand_b  (operand_b),
      .alu_op     (alu_sel_E),
      .alu_data   (alu_data_E)
   );

   EX_ME_reg EX_ME (
      .clk           (clk)          ,
      .rst_n         (rst_n)        ,
      .flush         (EX_ME_flush)  ,
      .enable        (EX_ME_enable) ,
      .wb_sel_E      (wb_sel_E)     ,
      .mem_wr_en_E   (mem_wr_en_E)  ,
      .bmask_E       (bmask_E)      ,
      .ld_sel_E      (ld_sel_E)     ,
      .reg_wr_en_E   (reg_wr_en_E)  ,
      .insn_vld_E    (insn_vld_E)   ,
      .instr_E       (instr_E)      ,
      .pc_E          (pc_E)         ,
      .alu_data_E    (alu_data_E)   ,
      .rs2_data_E    (rs2_data_E)   ,
      .wb_sel_M      (wb_sel_M)     ,
      .mem_wr_en_M   (mem_wr_en_M)  ,
      .bmask_M       (bmask_M)      ,
      .ld_sel_M      (ld_sel_M)     ,
      .reg_wr_en_M   (reg_wr_en_M)  ,
      .insn_vld_M    (insn_vld_M)   ,
      .instr_M       (instr_M)      ,
      .pc_M          (pc_M)         ,
      .alu_data_M    (alu_data_M)   ,
      .rs2_data_M    (rs2_data_M)
   );

   lsu l_s (
      .clk     (clk)             ,
      .rst_n   (rst_n)           ,
      .addr    (alu_data_M[15:0]),
      .w_data  (rs2_data_M)      ,
      .wr_en   (mem_wr_en_M)     ,
      .bmask   (bmask_M)         ,
      .ld_sel  (ld_sel_M)        ,
      .r_data  (ld_data_M)       ,
      .io_ledr (io_ledr)         ,
      .io_ledg (io_ledg)         ,
      .io_hex0 (io_hex0)         ,
      .io_hex1 (io_hex1)         ,
      .io_hex2 (io_hex2)         ,
      .io_hex3 (io_hex3)         , 
      .io_hex4 (io_hex4)         ,
      .io_hex5 (io_hex5)         ,  
      .io_hex6 (io_hex6)         ,
      .io_hex7 (io_hex7)         ,
      .io_lcd  (io_lcd)          ,
      .io_sw   (io_sw)           ,
      .io_btn  (io_btn)  
   );

   assign pc_four_M = pc_M + 4;

   ME_WB_reg ME_WB (
      .clk           (clk)          ,
      .rst_n         (rst_n)        ,
      .flush         (ME_WB_flush)  ,
      .enable        (ME_WB_enable) ,
      .wb_sel_M      (wb_sel_M)     ,
      .reg_wr_en_M   (reg_wr_en_M)  ,
      .insn_vld_M    (insn_vld_M)   ,
      .instr_M       (instr_M)      ,
      .pc_four_M     (pc_four_M)    ,
      .alu_data_M    (alu_data_M)   ,
      .ld_data_M     (ld_data_M)    , 
      .wb_sel_W      (wb_sel_W)     ,
      .reg_wr_en_W   (reg_wr_en_W)  ,
      .insn_vld_W    (insn_vld_W)   ,
      .instr_W       (instr_W)      ,
      .pc_four_W     (pc_four_W)    ,
      .alu_data_W    (alu_data_W)   ,
      .ld_data_W     (ld_data_W)
   );

   always_comb begin 
      case (wb_sel_W) 
         2'b00: wb_data = alu_data_W;
         2'b01: wb_data = ld_data_W;
         2'b10: wb_data = pc_four_W;
         default wb_data = 0;
      endcase 
   end

   harzard_detection hd (
      .instr_D       (instr_D)      ,
      .instr_E       (instr_E)      ,
      .instr_M       (instr_M)      ,
      .instr_W       (instr_W)      ,
      .ID_EX_flush   (ID_EX_flush)  ,
      .IF_ID_enable  (IF_ID_enable) ,
      .IF_ID_flush   (IF_ID_flush)  ,
      .pc_enable     (pc_en)        ,
      .EX_ME_enable  (EX_ME_enable) ,
      .ME_WB_enable  (ME_WB_enable) ,
      .EX_ME_flush   (EX_ME_flush)  ,
      .ME_WB_flush   (ME_WB_flush)  ,
      .ID_EX_enable  (ID_EX_enable) ,
      .is_taken      (is_taken) 
   );

   //assign pc_debug = pc_F;
   assign insn_vld_tmp = insn_vld_W;

   // Hai Cao Xuan
   always @(posedge clk) begin
      pc_debug <= pc_F;
      insn_vld <= insn_vld_tmp;
   end


endmodule