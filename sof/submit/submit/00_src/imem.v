module imem #(
   parameter DATA_WIDTH = 32, 
   parameter ADDR_WIDTH = 13,
   parameter WORD_NUM    = (2**ADDR_WIDTH)/4     // 1 word = 4 bytes
)(
	input  wire [ADDR_WIDTH-1:0]   r_addr,
	output wire [DATA_WIDTH-1:0]   r_data
);

	reg [DATA_WIDTH-1:0] ROM [0:WORD_NUM-1];

	initial
	begin
		// $readmemh("D:/Verilog_archived/02_CPU/03_FinnRISCV/mem/1_hex2seg.hex", ROM);
      $readmemh("D:/Verilog_archived/02_CPU/03_FinnRISCV/mem/2_stopwatch.hex", ROM);
      // $readmemh("D:/Verilog_archived/02_CPU/03_FinnRISCV/mem/3_HelloWorldLCD.hex", ROM);
      // $readmemh("D:/Verilog_archived/02_CPU/03_FinnRISCV/mem/4_CalculateLCD.hex", ROM);
      // $readmemh("D:/Verilog_archived/02_CPU/03_FinnRISCV/mem/5_CoordinateLCD.hex", ROM);
   end
	
	assign r_data = ROM[r_addr[ADDR_WIDTH-1:2]];

endmodule
