`include "../rtl//include/opcode_type.svh"

module branch_select 
import opcode_type::*;
(
   input  logic [31:0]  instr    ,
   input  logic         br_equal ,
   input  logic         br_less  ,
   output logic         is_taken
);
   opcode_type_e opcode_type;
   funct3_e funct3_type;
  
   always_comb begin
      opcode_type = opcode_type_e'(instr[6:0]);
      funct3_type = funct3_e'(instr[14:12]);
      
      case (opcode_type)
      B_type: 
         case (funct3_type)
         BEQ_LB_SB_ADDI    : is_taken = br_equal ? 1 : 0;               // beq
         BNE_LH_SH_SLLI    : is_taken = ~br_equal ? 1 : 0;              // bne
         BLT_LBU_XORI      : is_taken = br_less ? 1 : 0;                // blt
         BGE_LHU_SRLI_SRAI : is_taken = (~br_less || br_equal) ? 1 : 0; // bge
         BLTU_ORI          : is_taken = br_less ? 1 : 0;                // bltu
         BGEU_ANDI         : is_taken = (~br_less || br_equal) ? 1 : 0; // bgeu
         default           : is_taken = 0;
         endcase
      JAL:  is_taken = 1; 
      JALR: is_taken = 1;   
      default: is_taken = 0;
      endcase
   end

endmodule 