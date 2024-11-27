`timescale  1ns/1ns
module harzard_detection_tb ();
   logic clk;

   logic [31:0]   instr_F,
                  instr_D,
                  instr_E,
                  instr_M,
                  instr_W;

   logic ID_EX_flush    ;
   logic IF_ID_enable   ;
   logic pc_enable      ;
   logic EX_ME_flush    ; 
   logic EX_ME_enable   ;
   logic ME_WB_enable   ;
   logic ME_WB_flush    ;
   logic ID_EX_enable   ;      

   always_ff @(posedge clk) begin 
      instr_D <= instr_F;
      instr_E <= instr_D;
      instr_M <= instr_E;
      instr_W <= instr_M;
   end
   
   initial begin 
      clk = 0;
      forever #1 clk = ~clk;
   end

   harzard_detection hazard_dut (
      .instr_D       (instr_D)      ,
      .instr_E       (instr_E)      ,
      .instr_M       (instr_M)      ,
      .instr_W       (instr_W)      ,   
      .ID_EX_flush   (ID_EX_flush)  ,
      .IF_ID_enable  (IF_ID_enable) ,
      .pc_enable     (pc_enable)    ,
      .EX_ME_flush   (EX_ME_flush)  ,
      .EX_ME_enable  (EX_ME_enable) ,
      .ME_WB_enable  (ME_WB_enable) ,
      .ME_WB_flush   (ME_WB_flush)  ,
      .ID_EX_enable  (ID_EX_enable)
   );

   task instr_fetch (input [31:0] instr);
      instr_F = instr ;
      #2;
   endtask
   
   task check (input [31:0] instr);
      fork
         instr_fetch (instr);
         repeat(1) @(posedge clk);
      join
   endtask

   task case1 ();
      // add x5, x3, x2
      // xor x6, x5 , x1
      // sub x9, x3, x5
      // or x2, x7, x5
      // sll x4, x5, x5

      check (32'h002182B3);
      check (32'h0012C333);
      check (32'h405184B3);
      check (32'h0053E133);
      check (32'h00529233);
   endtask

   initial begin 
      case1;

      #20;
      $finish;
   end

endmodule 


