`include "../rtl//include/opcode_type.svh"

module control_unit 
import opcode_type::*; (
  input  logic [31:0] instr    ,
//  input  logic        br_less  ,
//  input  logic        br_equal ,
//  output logic        pc_sel   , // 0 if pc_four, 1 if alu_data
  output logic        reg_wr_en,
  output logic        br_un    , // 1 if signed, 0 if unsigned
  output logic        a_sel    , // 0 if rs1_data, 1 if pc
  output logic        b_sel    , // 0 if rs2_data, 1 if imm
  output logic [ 3:0] alu_sel  ,
  output logic        wr_en    , // write enable from SRAN/LSU
  output logic [ 2:0] ld_sel   , // select byte load
  output logic [ 3:0] bmask    , // select byte store
  output logic [ 1:0] wb_sel   , // 00 if alu_data, 01 if pc_four, 10 if ld_data
  output logic        insn_vld 
);
  
   opcode_type_e opcode_type;
   funct3_e funct3_type;
  
   logic [17:0] other_signal;

   assign {a_sel, b_sel, reg_wr_en, br_un, wr_en, alu_sel, bmask, ld_sel, wb_sel} = other_signal;

   always_comb begin 
      opcode_type = opcode_type_e'(instr[6:0]);
      funct3_type = funct3_e'(instr[14:12]);

      case (opcode_type) 
         LUI   : begin other_signal = 18'b1_1_1_1_0_1011_1111_111_00; insn_vld = 1'b1; end // lui
         AUIPC : begin other_signal = 18'b1_1_1_1_0_0000_1111_111_00; insn_vld = 1'b1; end // auipc
         JAL   : begin other_signal = 18'b1_1_1_1_0_0000_1111_111_10; insn_vld = 1'b1; end // jal
         JALR  : begin other_signal = 18'b0_1_1_1_0_0000_1111_111_10; insn_vld = 1'b1; end // jalr
         B_type: begin 
            case (funct3_type) 
               BEQ_LB_SB_ADDI   : begin other_signal =  18'b1_1_0_1_0_0000_1111_111_00 ; insn_vld = 1'b1; end               // beq
               BNE_LH_SH_SLLI   : begin other_signal =  18'b1_1_0_1_0_0000_1111_111_00 ; insn_vld = 1'b1; end              // bne
               BLT_LBU_XORI     : begin other_signal =  18'b1_1_0_1_0_0000_1111_111_00 ; insn_vld = 1'b1; end              // blt
               BGE_LHU_SRLI_SRAI: begin other_signal =  18'b1_1_0_1_0_0000_1111_111_00 ; insn_vld = 1'b1; end              // bge
               BLTU_ORI         : begin other_signal =  18'b1_1_0_0_0_0000_1111_111_00 ; insn_vld = 1'b1; end              // bltu
               BGEU_ANDI        : begin other_signal =  18'b1_1_0_0_0_0000_1111_111_00 ; insn_vld = 1'b1; end              // bgeu
               default          : begin other_signal = 18'd0; insn_vld = 1'b0; end
            endcase
         end 
         I_type: begin 
            case (funct3_type)
               BEQ_LB_SB_ADDI   : begin other_signal = 18'b0_1_1_1_0_0000_1111_111_00; insn_vld = 1'b1; end    // addi
               LW_SW_SLTI       : begin other_signal = 18'b0_1_1_1_0_0010_1111_111_00; insn_vld = 1'b1; end   // slti
               SLTIU            : begin other_signal = 18'b0_1_1_0_0_0011_1111_111_00; insn_vld = 1'b1; end  // sltiu
               BLT_LBU_XORI     : begin other_signal = 18'b0_1_1_1_0_0100_1111_111_00; insn_vld = 1'b1; end  // xori
               BLTU_ORI         : begin other_signal = 18'b0_1_1_1_0_0110_1111_111_00; insn_vld = 1'b1; end  // ori
               BGEU_ANDI        : begin other_signal = 18'b0_1_1_1_0_0111_1111_111_00; insn_vld = 1'b1; end  // andi
               BNE_LH_SH_SLLI   : begin other_signal = 18'b0_1_1_1_0_0001_1111_111_00; insn_vld = 1'b1; end  // slli
               BGE_LHU_SRLI_SRAI: begin other_signal = (~instr[30]) ? 18'b0_1_1_1_0_0101_1111_111_00 : 18'b0_1_1_1_0_1101_1111_111_00; insn_vld = 1'b1; end  // srli, srai
               default          : begin other_signal = 18'd0; insn_vld = 1'b0; end  
            endcase 
         end
         R_type: begin 
            case (funct3_type)
               BEQ_LB_SB_ADDI   : begin other_signal = (~instr[30]) ? 18'b0_0_1_1_0_0000_1111_111_00 : 18'b0_0_1_1_0_1000_1111_111_00; insn_vld = 1'b1; end  // add, sub
               LW_SW_SLTI       : begin other_signal = 18'b0_0_1_1_0_0010_1111_111_00; insn_vld = 1'b1; end  // slt
               SLTIU            : begin other_signal = 18'b0_0_1_0_0_0011_1111_111_00; insn_vld = 1'b1; end  // sltu
               BLT_LBU_XORI     : begin other_signal = 18'b0_0_1_1_0_0100_1111_111_00; insn_vld = 1'b1; end  // xor
               BLTU_ORI         : begin other_signal = 18'b0_0_1_1_0_0110_1111_111_00; insn_vld = 1'b1; end  // or
               BGEU_ANDI        : begin other_signal = 18'b0_0_1_1_0_0111_1111_111_00; insn_vld = 1'b1; end  // and
               BNE_LH_SH_SLLI   : begin other_signal = 18'b0_0_1_1_0_0001_1111_111_00; insn_vld = 1'b1; end  // sll
               BGE_LHU_SRLI_SRAI: begin other_signal = (~instr[30]) ? 18'b0_0_1_1_0_0101_1111_111_00 : 18'b0_0_1_1_0_1101_1111_111_00; insn_vld = 1'b1; end  // srl, sra
               default          : begin other_signal = 18'd0; insn_vld = 1'b0; end  
            endcase 
         end
         Load: begin
            case (funct3_type)
               BEQ_LB_SB_ADDI   : begin other_signal = 18'b0_1_1_0_0_0000_1111_000_01; insn_vld = 1'b1; end  // lb
               BNE_LH_SH_SLLI   : begin other_signal = 18'b0_1_1_0_0_0000_1111_001_01; insn_vld = 1'b1; end  // lh
               BLT_LBU_XORI     : begin other_signal = 18'b0_1_1_0_0_0000_1111_011_01; insn_vld = 1'b1; end  // lbu
               BGE_LHU_SRLI_SRAI: begin other_signal = 18'b0_1_1_0_0_0000_1111_100_01; insn_vld = 1'b1; end  // lhu
               LW_SW_SLTI       : begin other_signal = 18'b0_1_1_0_0_0000_1111_010_01; insn_vld = 1'b1; end  // lw
               default          : begin other_signal = 18'd0; insn_vld = 1'b0; end  
            endcase 
         end
         Store: begin 
            case (funct3_type)
               BEQ_LB_SB_ADDI: begin other_signal = 18'b0_1_0_0_1_0000_0001_000_00; insn_vld = 1'b1; end  // sb 
               BNE_LH_SH_SLLI: begin other_signal = 18'b0_1_0_0_1_0000_0011_000_00; insn_vld = 1'b1; end  // sh
               LW_SW_SLTI    : begin other_signal = 18'b0_1_0_0_1_0000_1111_000_00; insn_vld = 1'b1; end  // sw
               default       : begin other_signal = 18'd0; insn_vld = 1'b0; end  
            endcase
         end
         default: begin 
            other_signal = 18'd0;
            insn_vld = 0;
         end
      endcase
   end

endmodule