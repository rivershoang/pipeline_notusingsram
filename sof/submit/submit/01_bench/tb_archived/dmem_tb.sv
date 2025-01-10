`timescale 1ns/1ps

module dmem_tb ();
   localparam FREQ = 50_000_000;
   localparam PERIOD = 1_000_000_000/FREQ;
   localparam HALF_PERIOD = PERIOD/2;

   localparam DMEM_ADDR_W = 11;

   reg [7:0]               w_data, r_data;
   reg [DMEM_ADDR_W-1:0]   addr;
   reg                     clk,
                           w_en;

   dmem #(
      .ADDR_WIDTH(DMEM_ADDR_W),
      .DATA_WIDTH(8)
   ) u_dmem (
      .w_data  (w_data  ),
      .addr    (addr    ),
      .w_en    (w_en    ),
      .clk     (clk     ),
      .r_data  (r_data  )
   );

   always #HALF_PERIOD clk = ~clk;

   initial begin
      clk = 0;
      $display("================= DMEM test =================");
      for (integer i = 0; i < 2**DMEM_ADDR_W-1; i = i + 1) begin
         addr = i;
         write(i);
         check_write(i);
      end


      $display("================= PERI test =================");

      
      $display("================= SRAM test =================");

      
      $finish;
   end

   task write (input [10:0] addr);
      @(negedge clk);
      w_data = $urandom_range(0, 2**8-1);
      w_en = 1;
      @(posedge clk);
      @(negedge clk);
      w_en = 0;
      $display("Write to DMEM[%h] = %h", addr, w_data);
   endtask

   task check_write (input[10:0] addr);
      if (w_data == r_data) begin
         $display("Read out DMEM[%h] = %h \t >> \t PASSED", addr, r_data);      
      end
      else begin
         $display("Read out DMEM[%h] = %h \t >> \t FAILED", addr, r_data);
      end
   endtask
   
   initial begin
      $dumpfile("dmem.vcd");
      $dumpvars(0, dmem_tb);
   end

endmodule
