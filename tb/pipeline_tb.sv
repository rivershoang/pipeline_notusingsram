`timescale 1ns/1ns
module pipeline_tb ();
    logic           clk, rst_n;
    logic  [31:0]   io_sw;
    logic  [ 6:0]   io_hex0, io_hex1, io_hex2, io_hex3, io_hex4, io_hex5, io_hex6, io_hex7;
    logic  [31:0]   io_ledr, io_ledg, io_lcd, pc_debug;
    logic  [ 3:0]   io_btn;

  // Instantiate the single_cycle module
  pipeline dut (
    .clk   (clk     )          ,
    .rst_n   (rst_n )          ,
    .pc_debug (pc_debug)       ,
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


  // Clock generation
   initial begin 
      clk = 0;
      forever #1 clk = ~clk;
   end
  // Initializations
   initial begin 
    rst_n = 0;
    io_btn = 0;
    #5 
    rst_n = 1;
    io_sw = 32'd1234;
    #10000;
    $finish; 
 end



endmodule