// this file only be used to test under the grandtest of CXHai

module singlecycle (
   input  wire          i_clk,
                        i_rst_n,
   input  wire [31:0]   i_io_sw,
   input  wire [3:0]    i_io_btn,
   output wire [31:0]   o_pc_debug,
   output wire          o_insn_vld,
   output wire [31:0]   o_io_ledr,
                        o_io_ledg,
                        o_io_lcd,
   output wire [6:0]    o_io_hex0,
                        o_io_hex1,
                        o_io_hex2,
                        o_io_hex3,
                        o_io_hex4,
                        o_io_hex5,
                        o_io_hex6,
                        o_io_hex7
);

   // single_cycle u_single_cycle (
   //    .clk(i_clk),
   //    .rst_n(i_rst_n),
   //    .sw(i_io_sw),
   //    .btn(i_io_btn),
   //    .pc_debug(o_pc_debug),
   //    .instr_vld(o_insn_vld),
   //    .ledr(o_io_ledr),
   //    .ledg(o_io_ledg),
   //    .lcd(o_io_lcd),
   //    .hex0(o_io_hex0),
   //    .hex1(o_io_hex1),
   //    .hex2(o_io_hex2),
   //    .hex3(o_io_hex3),
   //    .hex4(o_io_hex4),
   //    .hex5(o_io_hex5),
   //    .hex6(o_io_hex6),
   //    .hex7(o_io_hex7)
   // );

   pipelined_ver1 u_pipelined_ver1 (
      .clk(i_clk),
      .rst_n(i_rst_n),
      .sw(i_io_sw),
      .btn(i_io_btn),
      .pc_debug(o_pc_debug),
      .instr_vld(o_insn_vld),
      .ledr(o_io_ledr),
      .ledg(o_io_ledg),
      .lcd(o_io_lcd),
      .hex0(o_io_hex0),
      .hex1(o_io_hex1),
      .hex2(o_io_hex2),
      .hex3(o_io_hex3),
      .hex4(o_io_hex4),
      .hex5(o_io_hex5),
      .hex6(o_io_hex6),
      .hex7(o_io_hex7)
   );

endmodule