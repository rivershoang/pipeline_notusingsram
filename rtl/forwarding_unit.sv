module forwarding_unit (
   input  logic [31:0]  instr_E     ,
   input  logic [31:0]  instr_M     ,
   input  logic [31:0]  instr_W     ,
   input  logic         reg_wr_en_M ,
   input  logic         reg_wr_en_W ,
   input  logic         is_taken    ,

   output logic [ 1:0]  forward_opA ,
   output logic [ 1:0]  forward_opB ,
   
   output logic         IF_ID_enable,
   output logic         IF_ID_flush ,

   output logic         ID_EX_flush ,
   output logic         ID_EX_enable,

   output logic         EX_ME_flush ,
   output logic         EX_ME_enable,
   
   output logic         ME_WB_enable,
   output logic         ME_WB_flush ,
   
   output logic         pc_enable  
);


   logic [4:0] rs1_addr_E  ,
               rs2_addr_E  ,
               rd_addr_M   ,
               rd_addr_W   ;

   logic is_load, is_branch, is_jump, is_jalr;

   assign rs1_addr_E = instr_E[19:15];
   assign rs2_addr_E = instr_E[24:20];
   assign rd_addr_M = instr_M[11:7];
   assign rd_addr_W = instr_W[11:7];
   assign is_load = (instr_M[6:0] == 7'b0000011) ? 1 : 0;
   assign is_branch = (instr_E[6:0] == 7'b1100011) ? 1 : 0;
   assign is_jump  = (instr_E[6:0] == 7'b1101111) ? 1 : 0;
   assign is_jalr = (instr_E[6:0] == 7'b1100111) ? 1 : 0;

   always_comb begin
      // forward operand A
      if (reg_wr_en_M && (rs1_addr_E != 0) && (rd_addr_M == rs1_addr_E) && (rd_addr_M != 0)) begin
         forward_opA = 2'b01; // forward from MEM
      end else if (reg_wr_en_W && (rs1_addr_E != 0) && (rd_addr_W == rs1_addr_E) && (rd_addr_W != 0)) begin
         forward_opA = 2'b10; // forward from WB
      end else begin 
         forward_opA = 2'b00;
         forward_opB = 2'b00; 
      end
      // forward operand B
      if (reg_wr_en_M && (rs2_addr_E != 0) && (rd_addr_M == rs2_addr_E) && (rd_addr_M != 0)) begin
         forward_opB = 2'b01; // forward from MEM
      end else if (reg_wr_en_W && (rs2_addr_E != 0) && (rd_addr_W == rs2_addr_E) && (rd_addr_W != 0)) begin
         forward_opB = 2'b10; // forward from WB
      end else begin 
         forward_opA = 2'b00;
         forward_opB = 2'b00; 
      end
   end

   always_comb begin       
      if (reg_wr_en_M && (rd_addr_M != 0) && is_load && ((rd_addr_M == rs1_addr_E) || (rd_addr_M == rs2_addr_E))) begin
         EX_ME_flush = 1;
         ID_EX_enable = 0;
         IF_ID_enable = 0;
         pc_enable = 0;
         ME_WB_enable = 1;
      end else if (is_taken && (is_branch || is_jump || is_jalr)) begin
         pc_enable = 1;
         IF_ID_flush = 1;
         ID_EX_flush = 1;
         ID_EX_enable = 0;
      end else begin 
         pc_enable = 1;
         IF_ID_enable = 1;
         ID_EX_enable = 1;
         EX_ME_enable = 1;
         ME_WB_enable = 1;
     
         IF_ID_flush = 0;
         ID_EX_flush = 0;
         EX_ME_flush = 0;
         ME_WB_flush = 0;
      end
   end

endmodule 


   