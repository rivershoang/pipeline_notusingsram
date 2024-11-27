module harzard_detection (
   input  logic         is_taken    ,
   input  logic [31:0]  instr_D     ,
   input  logic [31:0]  instr_E     ,
   input  logic [31:0]  instr_M     , 
   input  logic [31:0]  instr_W     ,   

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

   logic [ 4:0]   rd_addr_E   ,
                  rs1_addr_D  ,
                  rs2_data_D  ,
                  rd_addr_M   ,
                  rd_addr_W   ;
   
   logic is_branch,
         is_jump  ,
         is_jalr  ,
         is_load  ;


   assign rd_addr_E  = instr_E[11: 7];
   assign rs1_addr_D = instr_D[19:15];
   assign rs2_addr_D = instr_D[24:20];
   assign rd_addr_M  = instr_M[11: 7];
   assign rd_addr_W  = instr_W[11: 7];
   assign is_load = (instr_E[6:0] == 7'b0000011) ? 1 : 0;
   assign is_branch = (instr_E[6:0] == 7'b1100011) ? 1 : 0;
   assign is_jump  = (instr_E[6:0] == 7'b1101111) ? 1 : 0;
   assign is_jalr = (instr_E[6:0] == 7'b1100111) ? 1 : 0;

   always_comb begin 
      if  (((rd_addr_E == rs1_addr_D)  && (rd_addr_E != 0) && (rs1_addr_D != 0)) || 
                     ((rd_addr_E == rs2_addr_D) && (rs2_addr_D !=0) && (rd_addr_E != 0)) || 
                     (is_load && ((rd_addr_E == rs1_addr_D) || (rd_addr_E == rs2_addr_D))) && (rd_addr_E != 0)) begin
         pc_enable = 0;

         IF_ID_enable = 0;
         IF_ID_flush = 0;

         ID_EX_flush = 1;
         ID_EX_enable = 0;

         EX_ME_enable = 1;
         EX_ME_flush = 0;

         ME_WB_enable = 1;
         ME_WB_flush = 0;
         end else if (((rd_addr_M == rs1_addr_D)  && (rd_addr_M != 0) && (rs1_addr_D != 0)) || 
                     ((rd_addr_M == rs2_addr_D) && (rs2_addr_D !=0) && (rd_addr_M !=0))||
                     (is_load && ((rd_addr_M == rs1_addr_D) || (rd_addr_M == rs2_addr_D))) && (rd_addr_M != 0)) begin
         pc_enable = 0;
         
         IF_ID_enable = 0;
         IF_ID_flush = 0;

         ID_EX_flush = 0;
         ID_EX_enable = 0;

         EX_ME_flush = 1;
         EX_ME_enable = 0;

         ME_WB_enable = 1;
         ME_WB_flush = 0;
         end else if (((rd_addr_W == rs1_addr_D)  && (rd_addr_W != 0) && (rs1_addr_D != 0)) || 
                     ((rd_addr_W == rs2_addr_D) && (rs2_addr_D != 0) && (rd_addr_W != 0)) ||
                     (is_load && ((rd_addr_W == rs1_addr_D) || (rd_addr_W == rs2_addr_D))) && (rd_addr_W != 0)) begin
         pc_enable = 0;

         IF_ID_enable = 0;
         IF_ID_flush = 0;

         ID_EX_flush = 0;
         ID_EX_enable = 0;

         EX_ME_flush = 0;
         EX_ME_enable = 0;

         ME_WB_flush = 1;
         ME_WB_enable = 0;
         end else if (is_taken && (is_branch || is_jump || is_jalr)) begin 
         pc_enable = 1;
               
         IF_ID_enable = 0;
         IF_ID_flush = 1;
               
         ID_EX_flush = 1;
         ID_EX_enable = 0;
               
         EX_ME_enable = 1;
         EX_ME_flush = 0;
               
         ME_WB_enable = 1;
         ME_WB_flush = 0;
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