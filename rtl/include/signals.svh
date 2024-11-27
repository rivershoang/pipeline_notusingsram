`ifndef SIGNALS_SVH
`define SIGNALS_SVH

// control unit signal Decode
typedef struct packed {
   logic [31:0] instr;
   logic [31:0] pc;

   logic [ 1:0] wb_sel;
   logic        mem_wr_en;
   logic [ 3:0] bmask;
   logic [ 2:0] ld_sel;
   logic [ 3:0] alu_sel;
   logic        a_sel;
   logic        b_sel;
   logic        br_un;
   logic        reg_wr_en;

   logic [31:0] rs1_data;
   logic [31:0] rs2_data;
   logic [31:0] imm;

   logic [31:0] alu_data;

   logic [31:0] ld_data;    
   logic [31:0] pc_four;   
} signal_s;

`endif 